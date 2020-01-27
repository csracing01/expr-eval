# expr-eval

Expression Evaluation using Lex and Yacc

This applicaton reads a sequence of expressions, one to a line (allowing blank lines between expressions), involving numbers with a (optional) decimal point and operators +, - (both unary and binary), * and /.
The following grammar is used:
	E -> E + E | E – E | E * E | E / E | - E | (E) | number

First, the entered expression is tested for validity. For reach valid expression, it is evaluated and its result printed. It accepts input via both command line and a text file.
