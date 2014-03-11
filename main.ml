open Batteries
open Printf
open BatOptParse

let opts = OptParser.make
  ~version:"0.1"
  ~usage:"%prog [location...]"
  () |> OptParser.parse_argv

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

let pick_input ?use_stdin:(use_stdin=false) () =
  if use_stdin then
    stdin
  else if Sys.file_exists (home_file ".weather") then
    open_in (home_file ".weather")
  else if Sys.file_exists (etc_file "weather") then
    open_in (etc_file "weather")
  else
    stdin

let rec loop ch =
  try
    let line = input_line ch in
    let w = Weather.for_region line in
    let temp = Weather.temperature w |> Float.round_to_int in
    let desc = Weather.description w in
    printf "%d degrees - %s\n" temp desc;
    loop ch
  with
  | End_of_file -> ()

let () = 
  let ch = pick_input () in
  loop ch
