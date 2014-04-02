module Url : sig
  type t
  val make : string -> string list -> (string * string) list -> t
  val to_string : t -> string
end

val get : Url.t -> string
