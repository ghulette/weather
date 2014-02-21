%token <int> INT
%token <float> FLOAT
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

top : EOF { None } | value { Some $1 };

value :
  | NULL { Json.Unit }
  | TRUE { Json.Bool true }
  | FALSE { Json.Bool false }
  | n = INT { Json.Int n }
  | r = FLOAT { Json.Float r }
  | s = STRING { Json.String s }
  | LEFT_BRACK; ls = list_fields; RIGHT_BRACK { Json.List ls }
  | LEFT_BRACE; ls = assoc_fields; RIGHT_BRACE { Json.Assoc ls }
  ;

list_fields : ls = separated_list (COMMA, value) { ls };
assoc_fields : ls = separated_list (COMMA, assoc_field) { ls };
assoc_field : k = STRING; COLON; v = value { (k,v) };
