open Batteries
open Printf

let () =
  let w = Weather.for_region "San Francisco, CA" in
  let temp = Weather.temperature w in
  printf "%f\n" temp
