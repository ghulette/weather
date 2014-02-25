open Batteries
open Printf

let () =
  let w = Weather.for_region "San Francisco, CA" in
  let temp = Weather.temperature w |> Float.round_to_int in
  let desc = Weather.description w in
  printf "%d degrees, %s\n" temp desc;
(*  printf "%s\n" (Weather.dump w)*)
