%{
   enum yytokentype {

        STRING 258
        INT 259
        COMMA 260
        COLON 261
        SEMICOLON 262
        LPAREN 263
        RPAREN 264
        LBRACK 265
        RBRACK 266
        LBRACE 267
        RBRACE 268
        DOT 269
        PLUS 270
        MINUS 271
        TIMES 272
        DIVIDE 273
        EQ 274
        NEQ 275
        LT 276
        LE 277
        GT 278
        GE 279
        AND 280
        OR 281
        ASSIGN 282
        ARRAY 283
        IF 284
        THEN 285
        ELSE 286
        WHILE 287
        FOR 288
        TO 289
        DO 290
        LET 291
        IN 292
        END 293
        OF 294
        BREAK 295
        NIL 296
        FUNCTION 297
        VAR 298
        TYPE 299
   };
   int yylval;
%}


DIGITO    [0-9]
VARIAVEL [a-zA-Z][a-zA-Z0-9_]*
VARIAVEL_INVALIDA_ANTES [0-9._-]+[a-zA-Z0-9]+
VARIAVEL_INVALIDA_DEPOIS [a-zA-Z]+[0-9.-_]+
INTEIRO  [0-9]+
PONTO_FLUTUANTE [0-9]+.[0-9]+


%%

<INITIAL>

","       { return COMMA     ; }
":"       { return COLON     ; }
"("       { return LPAREN    ; }
")"       { return RPAREN    ; }
"["       { return LBRACK    ; }
"]"       { return RBRACK    ; }
"{"       { return LBRACE    ; }
"}"       { return RBRACE    ; }
"."       { return DOT       ; }
"+"       { return PLUS      ; }
"-"       { return MINUS     ; }
"*"       { return TIMES     ; }
"/"       { return DIVIDE    ; }
"="       { return EQ        ; }
"<>"      { return NEQ       ; }
"<"       { return LT        ; }
"<="      { return LE        ; }
">"       { return GT        ; }
">="      { return GE        ; }
"&"       { return AND       ; }
"|"       { return OR        ; }
":="      { return ASSIGN    ; }

array     { return ARRAY     ; }
if        { return IF        ; }
then      { return THEN      ; }
else      { return ELSE      ; }
let       { return LET       ; }
in        { return IN        ; }
end       { return END       ; }
of        { return OF        ; }
nil       { return NIL       ; }
function  { return FUNCTION  ; }
var       { return VAR       ; }
type      { return TYPE      ; }
to        { return TO        ; }
break     { return BREAK     ; }
while     { return WHILE     ; }
for       { return FOR       ; }

{VARIAVEL}                 { yylval.sval = strdup(yytext); return ID    ; }
{VARIAVEL_INVALIDA_ANTES}  { EM_error(EM_tokPos, "Token ilegal")        ; }
{VARIAVEL_INVALIDA_DEPOIS} { EM_error(EM_tokPos, "Token ilegal") ; }

{INTEIRO}         { yylval.ival = atoi(yytext); return INT; }
{PONTO_FLUTUANTE} { yylval.ival = atoi(yytext); return FLOAT; }


"/*" { BEGIN(IN_COMMENT); contadorComentario++; }

<IN_COMMENT>{
   "/*" { contadorComentario++; }
   \n   {}
   .    {}
   "*/" { if (--contadorComentario == 0) { BEGIN(INITIAL); } }
}

"\"" { strcat(string, yytext); BEGIN(IN_STRING); }

<IN_STRING>{
   "\" { strcat(string, yytext); yylval.sval = strdup(string); strcpy(string, ""); BEGIN(INITIAL); return STRING; }
   .    { strcat(string, yytext); }
}

[ \t\n] { adjust(); }

. ;
%%
main(int argc, char **argv)
{
  int tok;
  while(tok = yylex()) {
    printf("%d", tok);
    if(tok == ID) printf(" = %d\n", yylval);
    else printf("\n");
  }
}