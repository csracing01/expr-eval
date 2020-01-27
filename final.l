%{
#define YYSTYPE double
extern YYSTYPE yylval;
#include "y.tab.h"
%}

%%

[0-9]+|([0-9]*"."[0-9]+)                       { yylval = atof(yytext);
                                                 return NUMBER; }

[-+*/()\n]                                     { return *yytext; }

(";")[ \t]*                                    { return END; }

[ \t]                                          ;

.                                              { return OTHER; }

%%

int yywrap(void)
{
    return 1;
}