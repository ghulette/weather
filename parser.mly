%token <int> INT
%token <float> FLOAT
%token <string> ID
%token <string> STRING
%token TRUE
%token FALSE
%token NULL
%token LEFT_BRACE
%token RIGHT_BRACE
%token LEFT_BRACK
%token RIGHT_BRACK
%token COLON
%token COMMA
%token EOF

%start <Json.t option> top
%%

top:
  | EOF { None }
  | value { Some $1 }
  ;

value:
  | NULL { Json.Unit }
  | TRUE { Json.Bool true }
  | FALSE { Json.Bool false }
  | INT { Json.Int $1 }
  | FLOAT { Json.Float $1 }
  | STRING { Json.String $1 }
  ;
