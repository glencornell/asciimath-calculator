/* Companion source code for "flex & bison", published by O'Reilly
 * Media, ISBN 978-0-596-15597-1
 * Copyright (c) 2009, Taughannock Networks. All rights reserved.
 * See the README file for license conditions and contact info.
 * $Header: /home/johnl/flnb/code/RCS/asciimath.l,v 2.1 2009/11/08 02:53:18 johnl Exp $
 */
/* recognize tokens for the calculator */

%option noyywrap nodefault yylineno
%{
# include "asciimath.h"
# include "am.h"
%}

/* float exponent */
EXP	([Ee][-+]?[0-9]+)

%%
 /* single character ops */
"+" |
"-" |
"*" |
"/" |
"=" |
"|" |
"," |
";" |
"(" |
")"     { return yytext[0]; }

 /* comparison ops */
">"     { yylval.fn = 1; return CMP; }
"<"     { yylval.fn = 2; return CMP; }
"!="    { yylval.fn = 3; return CMP; }
"=="    { yylval.fn = 4; return CMP; }
">="    { yylval.fn = 5; return CMP; }
"<="    { yylval.fn = 6; return CMP; }

 /* keywords */

"if"    { return IF; }
"then"  { return THEN; }
"else"  { return ELSE; }
"while" { return WHILE; }
"do"    { return DO; }
"let"   { return LET;}

 /* built in functions */
"sin"   { yylval.fn = B_sin; return FUNC; }
"cos"	{ yylval.fn = B_cos; return FUNC; }
"tan"	{ yylval.fn = B_tan; return FUNC; }
"sec"	{ yylval.fn = B_sec; return FUNC; }
"csc"	{ yylval.fn = B_csc; return FUNC; }
"cot"	{ yylval.fn = B_cot; return FUNC; }
"arcsin"	{ yylval.fn = B_arcsin; return FUNC; }
"arccos"	{ yylval.fn = B_arccos; return FUNC; }
"arctan"	{ yylval.fn = B_arctan; return FUNC; }
"sinh"	{ yylval.fn = B_sinh; return FUNC; }
"cosh"	{ yylval.fn = B_cosh; return FUNC; }
"tanh"	{ yylval.fn = B_tanh; return FUNC; }
"sech"	{ yylval.fn = B_sech; return FUNC; }
"csch"	{ yylval.fn = B_csch; return FUNC; }
"coth"	{ yylval.fn = B_coth; return FUNC; }
"exp"	{ yylval.fn = B_exp; return FUNC; }
"ln"	{ yylval.fn = B_ln; return FUNC; }
"log"	{ yylval.fn = B_log; return FUNC; }
"sqrt"	{ yylval.fn = B_sqrt; return FUNC; }
"abs"	{ yylval.fn = B_abs; return FUNC; }
"floor"	{ yylval.fn = B_floor; return FUNC; }
"ceil"	{ yylval.fn = B_ceil; return FUNC; }
"print" { yylval.fn = B_print; return FUNC; }

 /* debug hack */
"debug"[0-9]+ { debug = atoi(&yytext[5]); printf("debug set to %d\n", debug); }

 /* names */
[a-zA-Z][a-zA-Z0-9]*  { yylval.s = lookup(yytext); return NAME; }

[0-9]+"."[0-9]*{EXP}? |
"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }

"//".*  
[ \t]   /* ignore white space */ 
\\\n    printf("c> "); /* ignore line continuation */
"\n"    { return EOL; }

.	{ yyerror("Mystery character %c\n", *yytext); }
%%
