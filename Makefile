SOURCES = json.ml parser.mly lexer.mll service.ml main.ml
RESULT  = weather

PACKS = batteries netstring netclient
OCAMLYACC = menhir

all: byte-code native-code

include OCamlMakefile
