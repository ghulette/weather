RESULT = weather

SOURCES = json_base.ml json_parser.mly json_lexer.mll json.mli json.ml \
http.mli http.ml weather.ml main.ml

PACKS = batteries netstring netclient
OCAMLYACC = menhir

all: byte-code native-code

include OCamlMakefile
