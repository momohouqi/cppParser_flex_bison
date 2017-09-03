%{
#include "funcParser.tab.h"
#include <string>
#define YY_DECL extern "C" int yylex()

%}

%option yylineno

%%

"(" { return PARENTHESIS_LEFT;}
")" { return PARENTHESIS_RIGHT;}
"int" {yylval.sval = strdup(yytext); return DATA_TYPE;}
"void" {yylval.sval = strdup(yytext); return DATA_TYPE;}
"include" {return INCLUDE;}
\" {return QUOTE;}
"<" {return ANGLE_LEFT;}
">" {return ANGLE_RIGHT;}
[ \t] { ;}
\n {;}
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER;}
. {return yytext[0];}

%%

/*
void singleLineComment(yyscan_t yyscanner) {

}
*/
