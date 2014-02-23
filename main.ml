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

let (>>=) = Option.bind

let () =
  let resp = Service.get_weather "San Francisco, CA" in
  let lexbuf = Lexing.from_string resp in
  let doc = parse_json lexbuf in
  let temp = begin doc
    >>= Json.field "main"
    >>= Json.field "temp" 
    >>= Json.float_value
    |> Option.get
  end in
  printf "%f\n" temp

