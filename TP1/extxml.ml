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

(* parse without AST *)

type ast = Id of string | Name of string | Doc of ast * ast | Decl of ast * (ast list) | Pred of ast * (ast list) | Empty


(* The recursive descent parser consists of three mutually-recursive functions: *)

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

(* Print the AST *)

let rec print_doc a = match a with
  | Doc(e1,e2) -> String.concat "" [print_decl e1; print_doc e2]
  | Empty -> ""
	| e -> print_decl e

and print_decl a = match a with (* Decl *)
  | Decl(e1,e2) -> String.concat "" ["< rdf:Description rdf:about=\"";print_atom "" e1;"\" >\n";print_conj e2;"</rdf:Description>\n"]
  | _ -> ""

and print_conj a =  match a with(* Decl' *)
  | [] -> ""
	| p::q ->  (String.concat "" [print_obj p; print_conj q])

and print_obj a = match a with (* Obj *)
  | Pred(e1,e2) -> print_enum (print_atom "" e1) e2
  | _ -> ""

and print_enum pred a = match a with (* Obj' *)
	| [] -> ""
	| p::q ->  (String.concat "" [print_atom_aux pred p; print_enum pred q])

and print_atom s a = match a with (* A *)
  | Id(i) -> i
  | _ -> ""

and print_atom_aux pred a = match a with (* A *)
  | Id(i) -> String.concat "" ["\t< "; pred;" rdf:resource=\"";i;"\" />\n"]
  | Name(i) -> String.concat "" ["\t< ";pred;" > ";i;" < /";pred;" >\n"]
  | _ -> ""

let print_xml a =
let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<rdf:RDF\n\t xml:base=\"http://mydomain.org/myrdf/\"\n\t xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">" in
    String.concat "\n" [header; print_doc a;"</rdf:RDF>\n"]

let test s = parse_doc (lex s);;

let ic = open_in "tests/test1.ttl" in
    let sp = Stream.of_channel ic in
        print_string (print_xml (test sp))
