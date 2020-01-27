%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
#define YYDEBUG 1
extern FILE *yyin;
extern int yy_flex_debug;
int flag;
int zero_error; // to handle divide by zero error
%}

%token NUMBER END OTHER
%left '+' '-' /* + and - have same precedence */
%left '*' '/' /* but lower than that of * and / */
/*%nonassoc UMINUS  unary minus is non-associative but has highest precedence among operators used. */

%%

program: program expr '\n' {  //printf("zero_error = %d", zero_error);
                              if(zero_error != 1)
                              {
                                  if((((int)$2) / $2) == 1)
                                      printf("Answer: %d\n\n", (int)$2);
                                  else
                                      printf("Answer: %.2f\n\n", $2);
                              }
                              else
                                 zero_error = 0;
                              flag = 0;
                           }
         | program expr { flag = 1; } end 
         | program { flag = 0; } end
         | program '\n' { flag = 0; }
         | program error '\n' { flag = 0; yyerrok; } 
         | ;
/* When yacc detects an error in a statement it will call yyerror,
flush input up to the next newline, and resume scanning. */


expr: number                  { $$ = $1; }
      | expr '+' expr         { $$ = $1 + $3; }
      | expr '-' expr         { $$ = $1 - $3; }
      | expr '*' expr         { $$ = $1 * $3; }
      | expr '/' expr         {
                                if($3 == 0)
                                {
                                    zero_error = 1;
                                    yyerror("Cannot divide by zero!!");
                                }
                                else
                                     $$ = $1 / $3;
                              }        
      | '-' expr              { $$ = -$2; }
      | '(' expr ')'          { $$ = $2; };


number: NUMBER;

end: END                      { 
                                  if(flag == 1 && zero_error != 1)
                                  { 
                                        if((((int)$-1) / $-1) == 1) 
                                             printf("Answer: %d\n\n", (int)$-1);
                                        else
                                             printf("Answer: %.2f\n\n", $-1);
                                        flag = 0;
                                  }
                                  zero_error = 0; // redundant because it has to exit
                                  return 0;
                               };

%%

int yyerror(char const *s)
{
      fprintf(stderr, "Invalid Expression: %s\n\n", s);
//    printf("zero_error = %d", zero_error);
}

int main(int argc, char *argv[])
{
//    yydebug = 1;  
//    yy_flex_debug = 1;

    if(argc == 2)
    {
           yyin = fopen(argv[1], "r");
           if (yyin == NULL) 
	   {
               printf("\nFile %s could not be opened in read mode!!!\n", argv[1]);
               return 1;
           }
           printf("\nReading from file %s.\n", argv[1]);
           printf("\n\t\tRESULTS\n");
    }
    else if(argc == 1)
    {
         yyin = stdin;
         printf("\nEnter expressions followed by newline to evaluate. Enter ';' to exit. \n\n");
         // Anything entered after ';' will be ignored.
    }
    else
    {
         printf("\nIncorrect Usage\n");
         printf("\nCorrect Usage: exe_name file_name\n");
         exit(0);
    }

    yyparse();

    if(argc == 2)
    {
        if(fclose(yyin) == EOF)
           printf("\nCould not close %s!!!", argv[1]);
    }

    return 0;
}