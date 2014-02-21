SOURCES = json.ml parser.mly lexer.mll main.ml
RESULT  = weather

PACKS = batteries
OCAMLYACC = menhir

all: byte-code native-code

include OCamlMakefile
