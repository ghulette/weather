type t

val from_string : string -> t option
val to_string : t -> string
val output : 'a BatInnerIO.output -> t -> unit
val bool_value : t -> bool option
val int_value : t -> int option
val float_value : t -> float option
val nth : int -> t -> t option
val field : string -> t -> t option
