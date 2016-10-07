(*
  The expression parser from the Web page, adapted to respect
  left-associativity of operators.
*)

(* function to convert digit chars into integers *)
let int_of_char c = Char.code c - Char.code '0'

(* First, we define the tokens (lexical units) *)

type token = Int of int | Plus | Minus | Times | LeftBracket | RightBracket

(* Then we define the lexer, using stream parsers with only right recursion *)

let rec lex = parser (* char stream -> token stream *)
  | [< 'c when c = ' ' || c = '\t'; toks = lex >] -> toks (* spaces are ignored *)
  | [< tok = token; toks = lex >] -> [< 'tok; toks >]
    (* recognizing one token at a time *)
  | [< >] -> [< >] (* end of stream *)
and token = parser
  | [< ' ('+') >] -> Plus
  | [< ' ('-') >] -> Minus
  | [< ' ('*') >] -> Times
  | [< ' ('(') >] -> LeftBracket
  | [< ' (')') >] -> RightBracket
  | [< ' ('0') >] -> Int 0
    (* special case for 0 *)
  | [< 'c when c >= '1' && c <= '9'; n = token_number (int_of_char c) >] -> Int n
    (* numbers start with 1..9 *)
and token_number num = parser (* number: 'num' is what has been recognized so far *)
  | [< 'c when c >= '0' && c <= '9'; n = token_number (num*10 + int_of_char c) >] -> n (* reading more digits *)
  | [< >] -> num (* end of number *)


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

(* That is all that is required to parse simple arithmetic
expressions. We can test it by lexing and parsing a string to get the
abstract syntax tree representing the expression: *)

let test s = parse_expr (lex (Stream.of_string s))

let _ = test "1+2*(3+4)-5"
(*- : expr = Sub (Add (Num 1, Mul (Num 2, Add (Num 3, Num 4))), 5) *)

