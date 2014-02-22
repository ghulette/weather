open Batteries
open Printf

type t = 
  | Unit
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | List of t list
  | Assoc of (string * t) list

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
