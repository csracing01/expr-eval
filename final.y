%{
#include <stdio.h>
#define YYSTYPE double
#define YYDEBUG 1
extern FILE *yyin;
extern int yy_flex_debug;
int flag;
%}

%token NUMBER END OTHER
%left '+' '-' /* + and - have same precedence */
%left '*' '/' /* but lower than that of * and / */
%nonassoc UMINUS /* unary minus is non-associative but has highest precedence among operators used. */

%%

program: program expr '\n' { 
                              if((((int)$2) / $2) == 1)
                                    printf("Answer: %d\n\n", (int)$2);
                              else
                                    printf("Answer: %.2f\n\n", $2);
                           }
         | program expr { flag = 1; } end 
         | program end
         | program '\n'
         | program error '\n' { yyerrok; } 
         | ;
/* When yacc detects an error in a statement it will call yyerror,
flush input up to the next newline, and resume scanning. */


expr: number                  { $$ = $1; }
      | expr '+' expr         { $$ = $1 + $3; }
      | expr '-' expr         { $$ = $1 - $3; }
      | expr '*' expr         { $$ = $1 * $3; }
      | expr '/' expr         {
                                   if($3 == 0)
                                       yyerror("Cannot divide by zero.\n\n");
                                   else
                                       $$ = $1 / $3; 
                              }
      | '-' expr              %prec UMINUS { $$ = -$2; }
      | '(' expr ')'          { $$ = $2; };


number: NUMBER;

end: END                      { 
                                  if(flag == 1)
                                  { 
                                        if((((int)$-1) / $-1) == 1) 
                                             printf("Answer: %d\n\n", (int)$-1);
                                        else
                                             printf("Answer: %.2f\n\n", $-1);
                                        flag = 0;
                                  }
                                  return 0;
                               };

%%

int yyerror(char const *s)
{
    fprintf(stderr, "%s\n\n", s);
    flag = 0;
}

int main(int argc, char *argv[])
{
  //  yydebug = 1;  
  //  yy_flex_debug = 1;

    if(argc > 1)
    {
           yyin = fopen(argv[1], "r");
           if (yyin == NULL) 
	       {
               printf("\nFile could not be opened in read mode!!!\n");
               return 1;
           }
           printf("\n");
    }
    else
    {
         yyin = stdin;
         printf("\nEnter expressions followed by newline to evaluate. Enter ';' to exit. \n\n");
         // Anything entered after ';' will be ignored.
    }

    yyparse();

    if(argc > 1)
        fclose(yyin);

    return 0;
}
