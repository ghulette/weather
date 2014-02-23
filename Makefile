SOURCES = json.ml parser.mly lexer.mll http.mli http.ml service.ml	\
main.ml
RESULT  = weather

PACKS = batteries netstring netclient
OCAMLYACC = menhir

all: byte-code native-code

include OCamlMakefile
