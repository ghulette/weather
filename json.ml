open Batteries
open Printf
open Json_base

type t = Json_base.t

let parse lexbuf =
  try Json_parser.top Json_lexer.read lexbuf with 
    | Json_lexer.SyntaxError msg ->
      fprintf stderr "%a: %s\n" Json_lexer.output_pos lexbuf msg;
      None
    | Json_parser.Error ->
      fprintf stderr "%a: parse error\n" Json_lexer.output_pos lexbuf; 
      None

let from_string s = Lexing.from_string s |> parse
let from_channel c = Lexing.from_channel c |> parse

let bracket s = "[" ^ s ^ "]"
let brace s = "{" ^ s ^ "}"
let paren s = "(" ^ s ^ ")"
let pair sep s1 s2 = s1 ^ sep ^ s2

let rec to_string = function
  | Unit -> "null"
  | Bool true -> "true"
  | Bool false -> "false"
  | Int n -> string_of_int n
  | Float r -> string_of_float r
  | String s -> String.quote s
  | List vs -> String.concat ", " (List.map to_string vs) |> bracket
  | Assoc ps -> 
    List.map (fun (k,v) -> pair ": " (String.quote k) (to_string v)) ps |>
    String.concat ", " |> brace

let rec output ch x =
  fprintf ch "%s" (to_string x)

let list_elt l n = try Some (List.nth l n) with Not_found -> None
let assoc_elt l k = try Some (List.assoc k l) with Not_found -> None

let bool_value = function Bool b -> Some b | _ -> None
let int_value = function Int n -> Some n | _ -> None
let float_value = function Float r -> Some r | _ -> None
let string_value = function String s -> Some s | _ -> None
let nth n = function List vs -> list_elt vs n | _ -> None
let field k = function Assoc ps -> assoc_elt ps k | _ -> None

let of_unit () = Unit
let of_bool b = Bool b
let of_int n = Int n
let of_float r = Float r
let of_string s = String s

