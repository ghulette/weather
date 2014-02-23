open Batteries
open Printf

let parse_json lexbuf =
  try Parser.top Lexer.read lexbuf with 
    | Lexer.SyntaxError msg ->
      fprintf stderr "%a: %s\n" Lexer.output_pos lexbuf msg;
      None
    | Parser.Error ->
      fprintf stderr "%a: parse error\n" Lexer.output_pos lexbuf; 
      exit (-1)

let () =
  let resp = Service.get_weather "San Francisco, CA" in
  let lexbuf = Lexing.from_string resp in
  match parse_json lexbuf with
    | Some data -> printf "%a\n" Json.output data
    | None -> printf "No data\n"
