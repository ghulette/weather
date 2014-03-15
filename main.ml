open Batteries
open Printf
open BatOptParse

let file_opt = Opt.value_option 
  "<filename>" None (fun f -> f) (fun _ v -> v)

let opts =
  let p = OptParser.make
    ~version:"0.1" ~usage:"%prog [location...]" ()
  in 
  OptParser.add p ~help:"Read from file" 
    ~short_name:'f' ~long_name:"file" 
    file_opt;
  OptParser.parse_argv p

let home_file path =
  if not (Filename.is_implicit path) then 
    raise (Invalid_argument path)
  else
    let home_dir = Sys.getenv "HOME" in
    Filename.concat home_dir path

let etc_file path =
  if not (Filename.is_implicit path) then 
    raise (Invalid_argument path)
  else
    let etc_dir = "/etc" in
    Filename.concat etc_dir path

let pick_input () =
  if Opt.is_set file_opt then
    try open_in (Opt.get file_opt) with 
      | Sys_error msg -> prerr_endline msg; exit (-1)
  else if Sys.file_exists (home_file ".weather") then
    open_in (home_file ".weather")
  else if Sys.file_exists (etc_file "weather") then
    open_in (etc_file "weather")
  else
    stdin

let rec read_line_loop ch proc =
   try 
     let line = input_line ch in 
     proc line; 
     read_line_loop ch proc
  with End_of_file -> ()

let () = 
  let ch = pick_input () in
  read_line_loop ch begin fun line ->
    let w = Weather.for_region line in
    let temp = Weather.temperature w |> Float.round_to_int in
    let desc = Weather.description w in
    printf "%d degrees - %s\n" temp desc;
  end
