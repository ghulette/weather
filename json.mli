open Batteries
open BatIO

type t

val from_string : string -> t option
val from_channel : input -> t option
val to_string : t -> string
val output : (t,'a) printer

val bool_value : t -> bool option
val int_value : t -> int option
val float_value : t -> float option
val string_value : t -> string option
val nth : int -> t -> t option
val field : string -> t -> t option

val of_unit : unit -> t
val of_bool : bool -> t
val of_float : float -> t
val of_int : int -> t
val of_string : string -> t
