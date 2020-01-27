/* Print line number before line. */

%{
 
#include <stdio.h>

int yylineno;
 
%}



%%


^(.*)\n { printf("%4d\t%s", ++yylineno, yytext); }

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