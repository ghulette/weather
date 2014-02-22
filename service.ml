(* Weather data from http://openweathermap.org/ *)

open Batteries
open Printf
open Http_client.Convenience
open Neturl
open Netencoding.Url

let api_key = "0a5c48c5769671dca8b2072de18e6904"

let http_syntax = Hashtbl.find common_url_syntax "http"
let url = make_url
  ~encoded:true
  ~scheme:"http"
  ~host:"api.openweathermap.org"
  ~path:["";"data";"2.5";"weather"]
  http_syntax

let get_weather region =
  let query = mk_url_encoded_parameters [("APPKEY",api_key);("q",region)] in
  let q = modify_url ~encoded:true ~query:query url |> string_of_url in
  printf "URL: %s\n" q;
  let resp = http_get q in
  printf "%s\n" resp
