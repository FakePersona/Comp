
open Ast
open SymbolTableList
 

exception TODO (* to be used for actions remaining to be done *)
exception Error of string (* to be used for semantic errors *)


(*****************************************)
(*****************************************)
(*********                       *********)
(*********  GLOBAL DECLARATIONS  *********)
(*********                       *********)
(*****************************************)
(*****************************************)

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


(******************************************)
(******************************************)
(*********                        *********)
(*********  PREDEFINED FUNCTIONS  *********)
(*********                        *********)
(******************************************)
(******************************************)

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


(****************************************************)
(****************************************************)
(*********                                  *********)
(*********  MUTABLE ALLOCATION PRIMITIVES   *********)
(*********                                  *********)
(****************************************************)
(****************************************************)

(* Create an alloca instruction in the entry block of the
function. This is used for mutable local variables. *)

let create_entry_block_alloca the_function var_name typ =
  let builder = Llvm.builder_at context (Llvm.instr_begin (Llvm.entry_block the_function)) in
  Llvm.build_alloca typ var_name builder

let create_entry_block_array_alloca the_function var_name typ size =
  let builder = Llvm.builder_at context (Llvm.instr_begin (Llvm.entry_block the_function)) in
  let vsize = Llvm.const_int int_type size in
  Llvm.build_array_alloca typ vsize var_name builder


(*******************************************************)
(*******************************************************)
(*********                                     *********)
(*********  CODE GENERATING FUNCTIONS FOR AST  *********)
(*********                                     *********)
(*******************************************************)
(*******************************************************)

(********************************************)
(*****  Generating code for expressions *****)
(********************************************)

let rec gen_expression : expression -> Llvm.llvalue = function
(*** Creates Llvm constant for vsl constant ***)
  | Const n ->
     const_int n

(*** Computes and stores sum of two expressions ***)
  | Plus (e1,e2) ->

      let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_add t1 t2 "plus" builder
	(* appends an 'add' instruction and returns the result llvalue *)

(*** Computes and stores difference of two expressions ***)
  | Minus (e1,e2) ->

     let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_sub t1 t2 "minus" builder
	(* appends a 'sub' instruction and returns the result llvalue *)

(*** Computes and stores product of two expressions ***)
  | Mul (e1,e2) ->

     let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_mul t1 t2 "mul" builder
	(* appends a 'mul' instruction and returns the result llvalue *)

(*** Computes and stores division of two expressions ***)
  | Div (e1,e2) ->

     let t1 = gen_expression e1 in
        (* generates the code for [e1] and returns the result llvalue *)
      let t2 = gen_expression e2 in
        (* the same for e2 *)
      Llvm.build_udiv t1 t2 "div" builder
  (* appends a 'div' instruction and returns the result llvalue *)

(*** Looks up and loads value of variable id ***)
  | Expr_Ident(id) ->

     let symb = try lookup id with
		|Not_found -> raise (Error "Undeclared variable")
     in
     Llvm.build_load symb id builder

(*** Looks up and loads eth value of array id ***)
  | ArrayElem(id,e) -> let arr = lookup id in
		       let symb = Llvm.build_gep arr [|gen_expression e|] "assignarray" builder in
  		       Llvm.build_load symb id builder

(*** Calls function f_id on args and returns return value ***)
  | ECall (f_id, args) ->

     (* Look up the name in the module table. *)
     let f =
       match Llvm.lookup_function f_id the_module with
       | Some f -> f
       | None -> raise (Error "unknown function called")
     in
     let params = Llvm.params f in

     (* If argument mismatch error. *)
     if Array.length params == Array.length args then () else
       raise (Error "incorrect # arguments passed");
     let args = Array.map gen_expression args in

     Llvm.build_call f args "calltmp" builder




(********************************************)
(*****  Generating code for print_items *****)
(********************************************)

let gen_print_item : print_item -> unit = function

(*** Computes value of e and prepare a valid input for C's printf ***)
  | Print_Expr e ->
     let s = [|const_string "%d";  (gen_expression e)|] in
     ignore(Llvm.build_call func_printf s "callprint" builder)

(*** Calls C's printf to print s ***)
  | Print_Text s -> ignore(Llvm.build_call func_printf (Array.make 1 (const_string s)) "callprint" builder)




(********************************************)
(*****  Generating code for read_items *****)
(********************************************)

let gen_read_item : read_item -> unit = function

(*** Prepares valid input for C's scanf and calls it ***)
  | LHS_Ident id -> let s = [|const_string "%d"; lookup id|] in
		    ignore(Llvm.build_call func_scanf s "callread" builder)

(*** Prepares valid input for C's scanf while looking up array's eth position and calls it ***)
  | LHS_ArrayElem(id,e) -> let arr = lookup id in
		     let symb = Llvm.build_gep arr [|gen_expression e|] "assignarray" builder in
		     let s = [|const_string "%d"; symb|] in
		    ignore(Llvm.build_call func_scanf s "callread" builder)




(******************************************)
(*****  Generating code for dec_items *****)
(******************************************)

let gen_dec_item : dec_item -> unit = function

(*** Allocate id variable in entry block and add to symbol table ***)
  | Dec_Ident (id) ->
     let before_bb = Llvm.insertion_block builder in
     let the_function = Llvm.block_parent before_bb in
     let symb =  create_entry_block_alloca the_function id int_type in
     add id symb

(*** Allocate id array of length size in entry block and add to symbol table ***)
  | Dec_Array (id,size) ->
     let before_bb = Llvm.insertion_block builder in
     let the_function = Llvm.block_parent before_bb in
     let symb =  create_entry_block_array_alloca the_function id int_type size in
     add id symb




(*********************************************)
(*****  Generating code for declarations *****)
(*********************************************)

(*** Mostly a shell function calling dec_item on every element of declaration ***)
let rec gen_declaration : declaration -> unit = function
  | [] -> ()
  | p::q -> (gen_dec_item p);(gen_declaration q)




(******************************************)
(*****  Generating code for statement3s *****)
(******************************************)

let rec gen_statement : statement -> unit = function
  | Return(e) -> let t = gen_expression e in
		 ignore(Llvm.build_ret t builder)
  | Assign(LHS_Ident(lhs),e) -> let symb = lookup lhs in
				let value = gen_expression e in
				ignore(Llvm.build_store value symb builder)
  | Assign(LHS_ArrayElem(id, e),assigned) -> let arr = lookup id in
					  let symb = Llvm.build_gep arr [|gen_expression e|] "assignarray" builder in
  					  let value = gen_expression assigned in
  					  ignore(Llvm.build_store value symb builder)
  | Block(d,sl) -> open_scope();
		   gen_declaration d;
		   ignore(List.map gen_statement sl);
		   close_scope ()
  | If(c,t,Some e) ->let before_bb = Llvm.insertion_block builder in
		   let the_function = Llvm.block_parent before_bb in

		   let if_bb =  Llvm.append_block context "if" the_function in
		   Llvm.position_at_end if_bb builder;

		   let cond = gen_expression c in
		    let zero = const_int 0 in
		    let cond_val = Llvm.build_icmp Llvm.Icmp.Ne cond zero "ifcond" builder in
		    
		    let if_bb = Llvm.insertion_block builder in
		    let the_function = Llvm.block_parent if_bb in

		    let end_bb = Llvm.append_block context "eblock" the_function in
		    
		    let true_bb = Llvm.append_block context "itrue" the_function in
		    Llvm.position_at_end true_bb builder;		    
		    let i_t = gen_statement t in
		    ignore(Llvm.build_br end_bb builder);
		    
		    let false_bb = Llvm.append_block context "ifalse" the_function in
		    Llvm.position_at_end false_bb builder;
		    let i_f = gen_statement e in
		    ignore(Llvm.build_br end_bb builder);

		    Llvm.position_at_end before_bb builder;
		    ignore(Llvm.build_br if_bb builder);
		    
		    Llvm.position_at_end if_bb builder;
		    ignore(Llvm.build_cond_br cond_val true_bb false_bb builder);

		    Llvm.position_at_end end_bb builder

  | If(c,t,None) -> let before_bb = Llvm.insertion_block builder in
		   let the_function = Llvm.block_parent before_bb in

		   let if_bb =  Llvm.append_block context "if" the_function in
		   Llvm.position_at_end if_bb builder;

		   let cond = gen_expression c in
		   let zero = const_int 0 in
		   let cond_val = Llvm.build_icmp Llvm.Icmp.Ne cond zero "ifcond" builder in
	   
		    let end_bb = Llvm.append_block context "eblock" the_function in
		    
		    let true_bb = Llvm.append_block context "itrue" the_function in
		    Llvm.position_at_end true_bb builder;		    
		    let i_t = gen_statement t in
		    ignore(Llvm.build_br end_bb builder);
		    
		    Llvm.position_at_end before_bb builder;
		    ignore(Llvm.build_br if_bb builder);

   
		    Llvm.position_at_end if_bb builder;
		    ignore(Llvm.build_cond_br cond_val true_bb end_bb builder);
		    
		    Llvm.position_at_end end_bb builder
  | While(c,s) ->  let before_bb = Llvm.insertion_block builder in
		   let the_function = Llvm.block_parent before_bb in

		   let while_bb =  Llvm.append_block context "while" the_function in
		   Llvm.position_at_end while_bb builder;

		   let cond = gen_expression c in
		   let zero = const_int 0 in
		   let cond_val = Llvm.build_icmp Llvm.Icmp.Ne cond zero "while" builder in
		   
     		   let end_bb = Llvm.append_block context "eblock" the_function in
		    
		    let loop_bb = Llvm.append_block context "loop" the_function in
		    Llvm.position_at_end loop_bb builder;		    
		    let i_s = gen_statement s in
		    ignore(Llvm.build_br while_bb builder);
		    
		    
		    Llvm.position_at_end while_bb builder;
		    ignore(Llvm.build_cond_br cond_val loop_bb end_bb builder);

		    Llvm.position_at_end before_bb builder;
		    ignore(Llvm.build_br while_bb builder);
		    
		    Llvm.position_at_end end_bb builder
  | SCall (f_id, args) ->
     (* Look up the name in the module table. *)
     let f =
       match Llvm.lookup_function f_id the_module with
       | Some f -> f
       | None -> raise (Error "unknown function called")
     in
     let params = Llvm.params f in

     (* If argument mismatch error. *)
     if Array.length params == Array.length args then () else
       raise (Error "incorrect # arguments passed");
     let args = Array.map gen_expression args in
     ignore(Llvm.build_call f args "" builder)
  | Print l -> ignore(List.map gen_print_item l)
  | Read l -> ignore(List.map gen_read_item l)

let gen_proto : proto -> Llvm.llvalue = function
  | (t,id,args) -> 
     let ty = (if  t = Type_Int then int_type else void_type) in
     let parameters = Array.make (Array.length args) int_type in
     let ft = Llvm.function_type ty parameters in
       match Llvm.lookup_function id the_module with
       | None ->
	  let f = Llvm.declare_function id ft the_module in
		 		    	  		    Array.iteri (fun i a ->
				 let n = args.(i) in
				 Llvm.set_value_name n a;
				 add n a;
							) (Llvm.params f);
		 f
       | Some f ->

          if Llvm.block_begin f <> Llvm.At_end f then
            raise (Error "Already defined function");
	  
          if Llvm.element_type (Llvm.type_of f) <> ft then
            raise (Error "Function declared with more parameters");
          f


let gen_function : program_unit -> unit = function(* llvm.params llvm.set_value_name *)
  | Proto(p) -> ignore(gen_proto p)
  | Function(p,s) ->let f = gen_proto p in
		    (* Create a new basic block to start insertion into. *)
		    (* Set names for all arguments. *)
		    let ty = (match p with (t,_,_) -> if  t = Type_Int then int_type else void_type) in
		    open_scope();

		    let args = match p with
		      | (_, _,args) -> args
		    in
		    
		    let entry_bb = Llvm.append_block context "entry" f in
		    Llvm.position_at_end entry_bb builder;
		    Array.iteri (fun i ai ->
				 let var_name = args.(i) in
				 (* Create an alloca for this variable. *)
				 let alloca = create_entry_block_alloca f var_name int_type in
    
				 (* Store the initial value into the alloca. *)
				 ignore(Llvm.build_store ai alloca builder);

				 (* Add arguments to variable symbol table. *)
				 add var_name alloca;
				) (Llvm.params f);
		    ignore(gen_statement s);
		    let zero = const_int 0 in
		    if ty = void_type then ignore(Llvm.build_ret_void builder) else ignore(Llvm.build_ret zero builder);
		    close_scope()

let rec gen_program : program -> unit = function
  | [] -> ()
  | p::q -> gen_function p; gen_program q



(* function that turns the code generated for an expression into a valid LLVM code *)
let gen (p : program) : unit =
  open_scope();
  gen_program p;
  close_scope()
