(*
  The expression parser from the Web page, adapted to respect
  left-associativity of operators.
*)

open String
open Printf
open Char

let string_of_char c = String.make 1 c

(* function to convert digit chars into integers *)
let int_of_char c = Char.code c - Char.code '0'

(* First, we define the tokens (lexical units) *)

type token = Atom of string | Str of string | Dot | Comma | Semicolon

(* Then we define the lexer, using stream parsers with only right recursion *)

let rec lex = parser (* char stream -> token stream *)
  | [< 'c when c = ' ' || c = '\t' || c = '\n'; toks = lex >] -> toks (* spaces are ignored *)
  | [< tok = token; toks = lex >] -> [< 'tok; toks >]
    (* recognizing one token at a time *)
  | [< >] -> [< >] (* end of stream *)
and token = parser
  | [< ' ('.') >] -> Dot
  | [< ' (',') >] -> Comma
  | [< ' (';') >] -> Semicolon
  | [< ' ('"') ; s = token_ident "" >] -> Str s
  | [< ' ('<') ; s = token_ident "" >] -> Atom s
and token_ident sub = parser (* number: 'num' is what has been recognized so far *)
  | [< 'c when c != '>' && c != '"'; s = token_ident (String.concat "" [sub;string_of_char c]) >] -> s (* reading more characters *)
	| [< ' ('>') >] -> sub
  | [< ' ('"') >] -> sub
  | [< >] -> sub (* ident *)

(* parse to create the AST *)

type ast = Id of string | Name of string | Doc of ast * ast | Decl of ast * (ast list) | Pred of ast * (ast list) | Empty

let rec parse_doc = parser 
                  | [< e1 = parse_decl; 'Dot; e2 = parse_doc >] -> Doc(e1,e2)
                  | [< >] -> Empty

and parse_decl = parser
               | [< e1 = parse_atom; e2 = parse_obj; e3 = parse_conj [e2]>] -> Decl(e1,e3)

and parse_conj e = parser
                 | [< 'Semicolon; e1 = parse_obj; e2 = parse_conj (e1::e)>] -> e2
                 | [< >] -> List.rev e

and parse_obj = parser
                 | [< e1 = parse_atom; e2 = parse_atom_aux; e3 = parse_enum [e2]>] -> Pred(e1,e3)

and parse_enum e = parser
                 | [< 'Comma; e1 = parse_atom_aux; e2 = parse_enum (e1::e)>] -> e2
                 | [< >] -> List.rev e

and parse_atom = parser
               | [< 'Atom s >] -> Id(s)

and parse_atom_aux = parser
                   | [< 'Atom s >] -> Id(s)
	                 |[<'Str s>] -> Name(s)


(* Print the NTRIPLE syntax with the AST *)
(* We have two attributes: c_begin (inherited, current beginning of sentence) and string (synthetized) *)

let rec print_doc a = match a with
  | Doc(e1,e2) -> String.concat "" [print_decl e1; print_doc e2]
  | Empty -> ""
	| e -> print_decl e

and print_decl a = match a with (* Decl *)
  | Decl(e1,e2) -> print_conj (print_atom "" e1) e2
  | _ -> ""                     (* Placeholder to avoid pattern warnings *)

and print_conj c_begin a =  match a with(* Decl' *)
  | [] -> ""
	| p::q ->  (String.concat "" [print_obj c_begin p; print_conj c_begin q])

and print_obj c_begin a = match a with (* Obj *)
  | Pred(e1,e2) -> print_enum (print_atom c_begin e1) e2
  | _ -> ""

and print_enum c_begin a = match a with (* Obj' *)
	| [] -> ""
	| p::q ->  (String.concat ".\n" [print_atom c_begin p; print_enum c_begin q])


<<<<<<< HEAD
let rec parse = parser
| [< 'Atom s; e = parse >] -> String.concat ">" [s; e]
| [< 'Str s; e = parse >] -> String.concat "!" [s; e]
| [< 'token; e = parse >] -> String.concat "" ["token"; e]
| [< >] -> ""
=======
and print_atom c_begin a = match a with (* A *)
  | Id(i) -> String.concat "" [c_begin;"<";i;">"]
  | Name(i) -> String.concat "" [c_begin;"\"";i;"\""]
  | _ -> ""

(* Check number of descriptions *)
>>>>>>> 09466bfa8a381e8d31f88a7019fcb1413196cc7c

let rec nb_desc a =  match a with
  | Doc(e1,e2) -> 2
  | Empty -> 0
  | _ -> 0


let test s = parse_doc (lex s);;

<<<<<<< HEAD
let test2 s = parse (lex s);;
let ic = open_in "tests/test3.ttl" in
let s = Stream.of_channel ic in
print_string (test2 s)
(*- : expr = Sub (Add (Num 1, Mul (Num 2, Add (Num 3, Num 4))), 5) *)
=======
let ic = open_in "tests/test1.ttl" in
    let sp = Stream.of_channel ic in
    print_string (print_doc (test sp));;
>>>>>>> 09466bfa8a381e8d31f88a7019fcb1413196cc7c
