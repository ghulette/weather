type t

val for_region : string -> t
val temperature : t -> float
val description : t -> string
val dump : t -> string
