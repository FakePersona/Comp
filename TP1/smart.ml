(*
  The expression parser from the Web page, adapted to respect
  left-associativity of operators.
*)

open String

let string_of_char c = String.make 1 c

(* function to convert digit chars into integers *)
let int_of_char c = Char.code c - Char.code '0'

(* First, we define the tokens (lexical units) *)

type token = Atom of string | Dot | Comma | Semicolon

(* Then we define the lexer, using stream parsers with only right recursion *)

let rec lex = parser (* char stream -> token stream *)
  | [< 'c when c = ' ' || c = '\t'; toks = lex >] -> toks (* spaces are ignored *)
  | [< tok = token; toks = lex >] -> [< 'tok; toks >]
    (* recognizing one token at a time *)
  | [< >] -> [< >] (* end of stream *)
and token = parser
  | [< ' ('.') >] -> Dot
  | [< ' (',') >] -> Comma
  | [< ' (';') >] -> Semicolon
  | [< ' ('<') ; s = token_ident "" >] -> Atom s
and token_ident sub = parser (* number: 'num' is what has been recognized so far *)
  | [< 'c when c != '>'; s = token_ident (String.concat "" [sub;string_of_char c]) >] -> s (* reading more characters *)
| [< ' ('>') >] -> sub
  | [< >] -> sub (* ident *)

(* parse without AST *)

type ast = Id of string | Doc of ast * ast | Decl of ast * ast | Pred of ast * ast | Enum of ast * ast | Conj of ast * ast


(* The recursive descent parser consists of three mutually-recursive functions: *)

let rec parse_doc = parser
                  | [< e1 = parse_decl; e2 = parse_doc >] -> Doc(e1,e2)
                  | [< >] -> Id("")

and parse_decl = parser
               | [< e1 = parse_atom; e2 = parse_obj; e3 = parse_conj e2>] -> Decl(e1,e3)

and parse_conj e = parser
                 | [< 'Semicolon; e1 = parse_obj; e2 = parse_conj (Conj(e,e1))>] -> e2
                 | [< >] -> e

and parse_obj = parser
              | [< e1 = parse_atom; e2 = parse_atom; e3 = parse_enum e2>] -> Pred(e1,e3)

and parse_enum e = parser
                 | [< 'Comma; e1 = parse_atom; e2 = parse_enum (Enum(e,e1))>] -> e2
                 | [< >] -> e

and parse_atom = parser
               | [< 'Atom s >] -> Id(s)


(* let rec parse_doc = parser (\* Doc *\) *)
(*   | [< e1 = parse_decl; 'Dot; e2 = parse_doc >] -> Doc(e1,e2) *)
(* 	| [< >] -> Atom("") *)

(* and parse_decl = parser (\* Decl *\) *)
(* | [< e = parse_atom; e1 = parse_atom; e2 = parse_obj Decl(e,e1); e3 = parse_decl_aux e >] -> String.concat "" [e2;e3] *)

(* and parse_decl_aux s = parser (\* Decl' *\) *)
(* 	| [< 'Semicolon; e1 = parse_atom; e2 = parse_obj (String.concat "" [s;e1]); e3 = parse_decl_aux s >] ->  (String.concat "" [e2;e3]) *)
(* 	| [< >] -> "" *)

(* and parse_obj s = parser (\* Obj *\) *)
(*   | [< e1 = parse_atom; e2 = parse_obj_aux s >] -> String.concat "" [s;e1;".\n";e2] *)

(* and parse_obj_aux s = parser (\* Obj' *\) *)
(* 	| [< 'Comma; e1 = parse_atom; e2 = parse_obj_aux s >] ->  (String.concat "" [s;e1;".\n";e2]) *)
(* 	| [< >] -> "" *)

(* and parse_atom = parser (\* A *\) *)
(*   | [< 'Atom s >] -> String.concat s ["<";">"] *)

(* let rec parse = parser *)
(* | [< 'Atom s; e = parse >] -> String.concat "" [s; e] *)
(* | [< 'token; e = parse >] -> String.concat "" ["tok"; e] *)


(* That is all that is required to parse simple arithmetic
expressions. We can test it by lexing and parsing a string to get the
abstract syntax tree representing the expression: *)

(* let test s = parse_doc (lex (Stream.of_string s));; *)


(* print_string (test "<Je> <prendre> <doucement>;<manger> <rire>,<pleurer>; <tomber> <mal>.<Tu> <dors> <vite>,<fort>.") *)

(* let test2 s = parse (lex (Stream.of_string s));; *)


(* print_string (test2 "<Remy>;<plop>;<plop> \n") *)
(*- : expr = Sub (Add (Num 1, Mul (Num 2, Add (Num 3, Num 4))), 5) *)
