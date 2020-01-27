/* Print lines beginning with and ending in 'a'. */

%{

#include <stdio.h>

%}



%%

^[aA].*[aA]$ { printf("%s\n", yytext); }

. ;

("\n") ;
%%



int main(int argc, char *argv[])

{

    yyin = fopen(argv[1], "r");
    yylex();

    fclose(yyin);
    return 0;

}



int yywrap()

{

    return 1;

}