open Batteries
open Printf
open BatOptParse

let opt_file = StdOpt.str_option ~metavar:"<filename>" ()
let opt_stdin = StdOpt.store_true ()
let opts =
  let p = OptParser.make
    ~version:"0.1" ~usage:"%prog [location...]" () in 
  OptParser.add p
    ~help:"Read from file" ~short_name:'f' ~long_name:"file" opt_file;
  OptParser.add p 
    ~help:"Read from stdin" ~short_name:'s' ~long_name:"stdin" opt_stdin;
  OptParser.parse_argv p

let in_home path =
  if not (Filename.is_implicit path) then 
    raise (Invalid_argument path)
  else
    let home_dir = Sys.getenv "HOME" in
    Filename.concat home_dir path

let in_etc path =
  if not (Filename.is_implicit path) then
    raise (Invalid_argument path)
  else
    let etc_dir = "/etc" in
    Filename.concat etc_dir path

let pick_input () =
  let home_file = in_home ".weather" in
  let etc_file = in_etc "weather" in
  if Opt.is_set opt_file then
    try open_in (Opt.get opt_file) with 
      | Sys_error msg -> prerr_endline msg; exit (-1)
  else if Sys.file_exists home_file then open_in home_file
  else if Sys.file_exists etc_file then open_in etc_file
  else stdin

let rec read_line_loop ch proc =
  try 
    let line = input_line ch |> String.trim in
    if not (String.is_empty line) then proc line; 
    read_line_loop ch proc
  with 
    | End_of_file -> ()

let () = 
  let ch = pick_input () in
  read_line_loop ch begin fun line ->
    let w = Weather.for_region line in
    let temp = Weather.temperature w |> Float.round_to_int in
    let desc = Weather.description w in
    printf "%d degrees - %s\n%!" temp desc;
  end
