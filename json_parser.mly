%token <int> INT
%token <float> FLOAT
%token <string> STRING
%token TRUE FALSE NULL
%token LEFT_BRACE RIGHT_BRACE
%token LEFT_BRACK RIGHT_BRACK
%token COLON COMMA
%token EOF

%start <Json_base.t option> top
%%

top : EOF { None } | value { Some $1 };

value :
  | NULL { Json_base.Unit }
  | TRUE { Json_base.Bool true }
  | FALSE { Json_base.Bool false }
  | n = INT { Json_base.Int n }
  | r = FLOAT { Json_base.Float r }
  | s = STRING { Json_base.String s }
  | LEFT_BRACK; ls = list_fields; RIGHT_BRACK { Json_base.List ls }
  | LEFT_BRACE; ls = assoc_fields; RIGHT_BRACE { Json_base.Assoc ls }
  ;

list_fields : ls = separated_list (COMMA, value) { ls };
assoc_fields : ls = separated_list (COMMA, assoc_field) { ls };
assoc_field : k = STRING; COLON; v = value { (k,v) };
