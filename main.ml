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

let rec loop lexbuf =
  match parse_json lexbuf with
    | None -> ()
    | Some x -> 
      printf "%a\n" Json.output x; 
      loop lexbuf

let () =
  let lexbuf = Lexing.from_channel stdin in
  loop lexbuf
