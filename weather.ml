(* Weather data from http://openweathermap.org/ *)

open Batteries
open Printf

type t = Json.t

let (>>=) = Option.bind
let api_key = "0a5c48c5769671dca8b2072de18e6904"
let host = "api.openweathermap.org"
let path = ["data";"2.5";"weather"]

let for_region region =
  let query = [("APPKEY",api_key);("q",region)] in
  let url = Http.Url.make host path query |> Http.Url.to_string in
  let resp = Http.get url in
  Json.from_string resp |> Option.get

let temperature w = (Some w) >>= 
  Json.field "main" >>= 
  Json.field "temp" >>=
  Json.float_value |> Option.get

let dump = Json.to_string
