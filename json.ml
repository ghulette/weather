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
let nth l n = try Some (List.nth l n) with Not_found -> None
let assoc k l = try Some (List.assoc k l) with Not_found -> None
let (>>=) = Option.bind
let from_some = Option.get

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

let bool_value = function
  | Bool b -> Some b
  | _ -> None

let int_value = function
  | Int n -> Some n
  | _ -> None

let float_value = function
  | Float r -> Some r
  | _ -> None

let nth n = function
  | List vs -> nth vs n
  | _ -> None

let field k = function
  | Assoc ps -> assoc k ps
  | _ -> None

