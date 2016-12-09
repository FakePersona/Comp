
(* global variable for the symbol table *)
let st : (string * (Llvm.llvalue *bool)) list list ref = ref []

(* opens a new scope *)
let open_scope () =
  st := []::!st

(* closes the current scope *)
let close_scope () =
  match !st with
  | [] -> failwith "SymbolTable.leave_scope: no scope to close"
  | _::l -> st := l

(* adds a symbol from its id and 'llvalue' in the current scope *)
let add id v =
  match !st with
  | [] -> failwith "SymbolTable.add: no open scope"
  | scope::l ->
      if List.mem_assoc id scope
      then failwith ("SymbolTable.add: " ^ id ^ " already defined in the current scope")
      else st := ((id,(v,false))::scope)::l

(* adds an array symbol from its id and 'llvalue' in the current scope *)
let add_array id v =
  match !st with
  | [] -> failwith "SymbolTable.add: no open scope"
  | scope::l ->
      if List.mem_assoc id scope
      then failwith ("SymbolTable.add: " ^ id ^ " already defined in the current scope")
      else st := ((id,(v,true))::scope)::l

(* lookup the 'llvalue' of a symbol from its id in the innermost scope *)
let lookup id =
  let rec aux st =
    match st with
    | [] -> failwith ("SymbolTable.lookup: unknown variable " ^ id ) 
    | scope::l ->
	try List.assoc id scope
	with Not_found -> aux l
  in
  match aux !st with
  |(a,is_array) -> a

(* lookup the 'llvalue' of a symbol from its id in the innermost scope *)
let is_array id =
  let rec aux st =
    match st with
    | [] -> failwith ("SymbolTable.lookup: unknown variable " ^ id ) 
    | scope::l ->
	try List.assoc id scope
	with Not_found -> aux l
  in
  match aux !st with
  |(a,is_array) -> is_array
