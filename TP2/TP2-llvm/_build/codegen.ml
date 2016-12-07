
open Ast
open SymbolTableList
 

exception TODO (* to be used for actions remaining to be done *)
exception Error of string (* to be used for semantic errors *)

(* global context, main module, and builder for generating code *)

let context = Llvm.global_context ()
let the_module = Llvm.create_module context "main"
let builder = Llvm.builder context

(* LLVM types for VSL+ *)

let int_type = Llvm.i32_type context
let void_type = Llvm.void_type context
let char_type = Llvm.i8_type context
let string_type = Llvm.pointer_type char_type
let int_array_type = Llvm.array_type int_type 0

(* generation of constant integer LLVM values *)

let const_int n = Llvm.const_int int_type n

let zero_int = const_int 0

(* generation of constant string LLVM values *)

let const_string =
  let string_gep_indices = [|zero_int; zero_int|] in
  fun s ->
    let const_s = Llvm.const_stringz context s in
    let global_s = Llvm.define_global s const_s the_module in
    Llvm.const_gep global_s string_gep_indices

(* the printf function as a LLVM value *)

let func_printf =
  let tf = Llvm.var_arg_function_type int_type [|string_type|] in
  let f = Llvm.declare_function "printf" tf the_module in
  Llvm.add_function_attr f Llvm.Attribute.Nounwind;
  Llvm.add_param_attr (Llvm.param f 0) Llvm.Attribute.Nocapture;
  f

(* the scanf function as a LLVM value *)

let func_scanf =
  let tf = Llvm.var_arg_function_type int_type [|string_type|] in
  let f = Llvm.declare_function "scanf" tf the_module in
  Llvm.add_function_attr f Llvm.Attribute.Nounwind;
  Llvm.add_param_attr (Llvm.param f 0) Llvm.Attribute.Nocapture;
  f

(* Create an alloca instruction in the entry block of the
function. This is used for mutable local variables. *)

let create_entry_block_alloca the_function var_name typ =
  let builder = Llvm.builder_at context (Llvm.instr_begin (Llvm.entry_block the_function)) in
  Llvm.build_alloca typ var_name builder

let create_entry_block_array_alloca the_function var_name typ size =
  let builder = Llvm.builder_at context (Llvm.instr_begin (Llvm.entry_block the_function)) in
  let vsize = Llvm.const_int int_type size in
  Llvm.build_array_alloca typ vsize var_name builder

(* generation of code for each VSL+ construct *)

let rec gen_expression : expression -> Llvm.llvalue = function
  | Const n ->
      const_int n
        (* returns a constant llvalue for that integer *)
  | Plus (e1,e2) ->
      let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_add t1 t2 "plus" builder
	(* appends an 'add' instruction and returns the result llvalue *)
  | Minus (e1,e2) ->
      let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_sub t1 t2 "minus" builder
	(* appends a 'sub' instruction and returns the result llvalue *)
  | Mul (e1,e2) ->
      let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_mul t1 t2 "mul" builder
	(* appends a 'mul' instruction and returns the result llvalue *)
  | Div (e1,e2) ->
      let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_udiv t1 t2 "div" builder
  (* appends a 'div' instruction and returns the result llvalue *)
  | _ -> raise TODO

let gen_dec_item : dec_item -> unit = function
  | Dec_Ident (id) ->
     let symb = Llvm.build_alloca int_type id builder in
     add id symb
  | _ -> raise TODO

let rec gen_declaration : declaration -> unit = function
  | [] -> ()
  | p::q -> (gen_dec_item p);(gen_declaration q)

let rec gen_statement : statement -> unit = function
  | Return(e) -> let t = gen_expression e in
		 ignore(Llvm.build_ret t builder)
  | Assign(LHS_Ident(lhs),e) -> let symb = lookup lhs in
				let value = gen_expression e in
				ignore(Llvm.build_store value symb builder)
  | Block(d,sl) -> open_scope();
		   gen_declaration d;
		   ignore(List.map gen_statement sl);
		   close_scope ()
  | _ -> raise TODO

(* function that turns the code generated for an expression into a valid LLVM code *)
let gen (s : statement) : unit =
  let the_function = Llvm.declare_function "main" (Llvm.function_type int_type [||]) the_module in
  let bb = Llvm.append_block context "entry" the_function in
  Llvm.position_at_end bb builder;
  gen_statement s;
  ignore(Llvm.build_ret_void builder)