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
  | [< >] -> sub (* ident *)

(* parse without AST *)

let rec parse_doc s = parser (* Doc *)
  | [< e1 = parse_decl; 'Dot; e2 = parse_doc e1 >] -> String.concat "." [s;e2]
	| [< >] -> s

and parse_decl = parser (* Decl *)
  | [< e1 = parse_atom; e2 = parse_atom; e3 = parse_decl_aux e1 >] -> String.concat "" [e1;e2;e3]

and parse_decl_aux s = parser (* F' *)
	| [< 'Semicolon; e1 = parse_atom; e2 = parse_decl_aux s >] ->  (String.concat "" [s;e1;".";e2])
	| [< >] -> ""

and parse_atom = parser (* A *)
  | [< 'Atom s >] -> String.concat s ["<";">"]

(*
(* Next, we define a type to represent abstract syntax trees: *)

type expr = Num of int | Add of expr * expr | Sub of expr * expr | Mul of expr * expr

(* The recursive descent parser consists of three mutually-recursive functions: *)

let rec parse_expr = parser
  | [< e1 = parse_factor; e2 = parse_expr_aux e1 >] -> e2

and parse_expr_aux e1 = parser
  | [< 'Plus; e2 = parse_factor; e3 = parse_expr_aux (Add (e1,e2)) >] -> e3
  | [< 'Minus; e2 = parse_factor; e3 = parse_expr_aux (Sub (e1,e2)) >] -> e3
  | [< >] -> e1

and parse_factor = parser
  | [< e1 = parse_atom; e2 = parse_factor_aux e1 >] -> e2

and parse_factor_aux e1 = parser
  | [< 'Times; e2 = parse_atom; e3 = parse_factor_aux (Mul (e1,e2)) >] -> e3
  | [< >] -> e1

and parse_atom = parser
  | [< 'Int n >] -> Num n
  | [< 'LeftBracket; e = parse_expr; 'RightBracket >] -> e
*)

(* That is all that is required to parse simple arithmetic
expressions. We can test it by lexing and parsing a string to get the
abstract syntax tree representing the expression: *)

let test s = parse_decl_aux "ah" (lex (Stream.of_string s));;


print_string (test ";<Remy>;<plop> \n")
(*- : expr = Sub (Add (Num 1, Mul (Num 2, Add (Num 3, Num 4))), 5) *)

