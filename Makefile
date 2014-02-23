RESULT = weather

SOURCES = json.mli json.ml parser.mly lexer.mll http.mli http.ml	\
service.ml main.ml

PACKS = batteries netstring netclient
OCAMLYACC = menhir

all: byte-code native-code

include OCamlMakefile
