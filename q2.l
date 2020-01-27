/* Count the number of lines, words, and characters. */

%{

#include <stdio.h>

int nline, nword, nchar;

%}



%%


\n           { nline++; nchar++; }

[^ \t\n]+    { nword++; nchar += yyleng; }

.            { nchar++; }

%%



int main(int argc, char *argv[])

{

    yyin = fopen(argv[1], "r");    
    yylex();
    fclose(yyin);
    printf("\nNumber of lines: %d", nline);
    printf("\nNumber of words: %d", nword);
    printf("\nNumber of characters: %d\n\n", nchar);

    return 0;

}



int yywrap()

{
    
    return 1;

}