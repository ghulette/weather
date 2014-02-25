open Batteries
open Printf

let (>>=) = Option.bind

let temp_path doc = 
  doc >>= Json.field "main" >>= Json.field "temp" >>= Json.float_value |> Option.get

let () =
  let resp = Weather.get_weather "San Francisco, CA" in
  let doc = Json.from_string resp in
  let temp = temp_path doc in
  printf "%f\n" temp;
  printf "%s\n" (doc |> Option.get |> Json.to_string)
