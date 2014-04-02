open Batteries
open Http_client.Convenience

module Url = struct
  open Neturl
  open Netencoding.Url

  type t = url

  let http_syntax = Hashtbl.find common_url_syntax "http"

  let to_string = string_of_url

  let make host abs_path queries =
    let query = mk_url_encoded_parameters queries in
    make_url ~encoded:true ~scheme:"http"
      ~host:host
      ~path:(""::abs_path)
      ~query:query
      http_syntax
end

let get = Url.to_string %> http_get
