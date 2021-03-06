(*
  The expression parser from the Web page, adapted to respect
  left-associativity of operators.
*)
open Printf
open String
open List

let file = "tests/test1.ttl"

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

(* parse without AST *)
(* We have two attributes: c_begin (inherited, current beginning of sentence) and string (synthetized) *)

let rec parse_doc = parser (* Doc *)
  | [< e1 = parse_decl; 'Dot; e2 = parse_doc >] -> String.concat "" [e1;e2]
	| [< >] -> ""

and parse_decl = parser (* Decl *)
| [< e = parse_atom; e1 = parse_atom; e2 = parse_obj (String.concat "" [e;e1]); e3 = parse_decl_aux e >] -> String.concat "" [e2;e3]

and parse_decl_aux c_begin = parser (* Decl' *)
	| [< 'Semicolon; e1 = parse_atom; e2 = parse_obj (String.concat "" [c_begin;e1]); e3 = parse_decl_aux c_begin >] ->  (String.concat "" [e2;e3])
  | [< >] -> ""

and parse_obj c_begin = parser (* Obj *)
  | [< e1 = parse_atom_aux; e2 = parse_obj_aux c_begin >] -> String.concat "" [c_begin;e1;".\n";e2]

and parse_obj_aux c_begin = parser (* Obj' *)
	| [< 'Comma; e1 = parse_atom_aux; e2 = parse_obj_aux c_begin >] ->  (String.concat "" [c_begin;e1;".\n";e2])
  | [< >] -> ""

and parse_atom = parser (* A *)
| [< 'Atom s >] -> String.concat s ["<";">"]


and parse_atom_aux = parser (* A' *)
  | [< 'Atom s >] -> String.concat s ["<";">"]
| [< 'Str s >] -> String.concat s ["\"";"\""]



let test s = parse_doc (lex s);;

let ic = open_in file in
let s = Stream.of_channel ic in
print_string (test s)
