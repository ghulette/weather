(* Weather data from http://openweathermap.org/ *)

open Batteries
open Printf

let api_key = "0a5c48c5769671dca8b2072de18e6904"
let host = "api.openweathermap.org"
let path = ["data";"2.5";"weather"]

let get_weather region =
  let query = [("APPKEY",api_key);("q",region)] in
  let url = Http.Url.make host path query |> Http.Url.to_string in
  Http.get url

