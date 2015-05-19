%option yylineno
%{
#include "analizador.tab.h"
int nLinea = 1;
int marcador = 0;
char imprimir[100] = "";
%}

%x comentario cadena libreria



COMENTARIO \/\/.*

DELIMITADOR "{"|"}"|"?"|":"|";"|","|"("|")"

OPERADORESBASICOS "+"|"-"|"*"|"/"|"%"|"."|"&"|"["|"]"|"~"|"|"|"^"|"<"|">"|"!"|"="|"#"|"%"

ENTERO	(0[xX][0-9A-Fa-f]+)|(0[0-7]+)|[0-9]+
REAL	([0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?)|(0[xX][0-9A-Fa-f]*\.?[0-9A-Fa-f]+([eE][+-]?[0-9]+)?)
CARACTER	(\'[^\n'\\]\')|(\'\\['"\?\\abfnrtv]\')|(\'\\[0-3]?[0-7]{1,2}\')|(\'\\x[0-9A-Fa-f]{1,2}\')

IDENTIFICADOR [a-zA-Z_][a-zA-Z0-9_]*
LIBRERIAI \"<
LIBRERIAF >\"
ESPACIOS (\n|\t|\ )

%%

{LIBRERIAI} {BEGIN(libreria); printf("Comienzo libreria\n");}
<libreria>\n {++nLinea;}
<libreria>{LIBRERIAF} {BEGIN(INITIAL); return(LIBRERIA);}
<libreria>[A-Za-z]*\.h {printf("Linea %d, libreria: %s\n",yylineno,yytext);}

"auto"  {return(AUTO);}
"break"  {return(BREAK);}
"case"  {return(CASE);}
"char"   {return(CHAR);}
"continue" {return(CONTINUE);}
"default"  {return(DEFAULT);}
"define"   {return(DEFINE);}
"do"   {return(DO);}
"double"   {return(DOUBLE);}
"else"   {return(ELSE);}
"extern"   {return(EXTERN);}
"float"   {return(FLOAT);}
"for"   {return(FOR);}
"goto"    {return(GOTO);}
"if"   {return(IF);}
"include"   {return(INCLUDE);}
"int"   {return(INT);}
"long"    {return(LONG);}
"register"  {return(REGISTER);}
"return"    {return(RETURN);}
"short"   {return(SHORT);}
"signed"   {return(SIGNED);}
"sizeof"   {return(SIZEOF);}
"static"   {return(STATIC);}
"struct"   {return(STRUCT);}
"switch"   {return(SWITCH);}
"typedef"  {return(TYPEDEF);}
"union"    {return(UNION);}
"unsigned" {return(UNSIGNED);}
"void"   {return(VOID);}
"while"  {return(WHILE);}

"--"  {return(MENOSMENOS);}
"++" {return(MASMAS);}
"->" {return(GUIMAY);}
"*=" {return(PORIGUAL);}
"/=" {return(DIVIGUAL);}
"%=" {return(MODIGUAL);}
"+=" {return(MASIGUAL);}
"-=" {return(MENOSIGUAL);}
"<<=" {return(MENORMENORIGUAL);}
">>=" {return(MAYORMAYORIGUAL);}
"&=" {return(ANDIGUAL);}
"^=" {return(POWIGUAL);}
"|=" {return(ORIGUAL);}
"<<"  {return(MENORMENOR);}
">>"  {return(MAYORMAYOR);}
"<="  {return(MENORIGUAL);}
">="  {return(MAYORIGUAL);}
"=="  {return(IGUALIGUAL);}
"!="  {return(ADMIRACIONIGUAL);}
"&&"  {return(AND);}
"||"  {return(OR);}

{ENTERO} {printf("Linea %d, ctc entera: %s\n", yylineno, yytext); return(ENTERO);}
{REAL} {printf("Linea %d, ctc real: %s\n", yylineno, yytext); return(REAL);}
{CARACTER} {printf("Linea %d, caracter: %s\n", yylineno, yytext);return(CARACTER);}

{DELIMITADOR} {printf("Linea %d, delimitador: %s\n", yylineno, yytext); return(yytext[0]);}
{OPERADORESBASICOS} {printf("Linea %d, operador: %s\n", yylineno, yytext);return(yytext[0]);}
{IDENTIFICADOR} {printf("Linea %d, identificador: %s\n", yylineno, yytext); return(IDENTIFICADOR);}

{COMENTARIO} {}
{ESPACIOS} {}



"/*" {BEGIN(comentario);}

<comentario>.

<comentario>\n  {++nLinea;}

<comentario>"*/" { BEGIN(INITIAL); }

\" {
    BEGIN(cadena);
    marcador = yylineno;
    strncpy(imprimir, "\"", 100);
}

<cadena>[^\"\n"] {
    strcat(imprimir, yytext);
}
<cadena>\n {
    strcat(imprimir, yytext);;
}

<cadena>\\\" {
    strcat(imprimir, yytext);
}

<cadena>\" {
    strcat(imprimir, yytext);
    BEGIN(INITIAL);
    printf("Linea %d, Cadena: %s \n",marcador, imprimir);
    strncpy(imprimir, "", 100);return(CADENA);
}



.     {printf("Linea %d, ERROR DE SINTAXIS: %s\n", yylineno, yytext);}
		
%%


