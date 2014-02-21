{
  open Lexing
  open Parser
  
  exception SyntaxError of string

  let buf = Buffer.create 17

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in 
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos; 
		 pos_lnum = pos.pos_lnum + 1
      }
}

let digit = ['0'-'9']
let int = '-'? digit+
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"

rule read = parse
  | white    { read lexbuf }
  | newline  { next_line lexbuf; read lexbuf }
  | "null"   { NULL }
  | "true"   { TRUE }
  | "false"  { FALSE }
  | int      { INT (int_of_string (lexeme lexbuf)) }
  | float    { FLOAT (float_of_string (lexeme lexbuf)) }
  | '"'      { Buffer.clear buf; STRING (read_string lexbuf) }
  | '{'      { LEFT_BRACE }
  | '}'      { RIGHT_BRACE }
  | '['      { LEFT_BRACK }
  | ']'      { RIGHT_BRACK }
  | ':'      { COLON }
  | ','      { COMMA }
  | eof      { EOF }
  | _        { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf)) }

and read_string = parse
  | '"' { Buffer.contents buf }
  | '\\' '/' { Buffer.add_char buf '/'; read_string lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string lexbuf } 
  | '\\' 'b' { Buffer.add_char buf '\b'; read_string lexbuf } 
  | '\\' 'f' { Buffer.add_char buf '\012'; read_string lexbuf } 
  | '\\' 'n' { Buffer.add_char buf '\n'; read_string lexbuf } 
  | '\\' 'r' { Buffer.add_char buf '\r'; read_string lexbuf } 
  | '\\' 't' { Buffer.add_char buf '\t'; read_string lexbuf } 
  | [^ '"' '\\']+ { Buffer.add_string buf (Lexing.lexeme lexbuf); 
		    read_string lexbuf }
  | eof { raise (SyntaxError ("String is not terminated")) }
  | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
