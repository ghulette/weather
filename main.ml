open Batteries
open Printf

let rec loop () =
  try 
    let input = read_line () in
    let w = Weather.for_region input in
    let temp = Weather.temperature w |> Float.round_to_int in
    let desc = Weather.description w in
    printf "%d degrees - %s\n" temp desc;
    loop ()
  with
  | End_of_file -> ()

let () = loop ()
