%option yylineno

%{
    #include "cmm.tab.h"
    int nLinea = 1;
    int lineStart = 0;
    char buffer[1024] = "";
%}

%x COMENTARIOML STRING LIBRERIA

COMENTARIOS \/\/.*

DELIMITADORES "{"|"}"|"?"|":"|";"|","|"("|")"

OPERADORESBASICOS "+"|"-"|"*"|"/"|"%"|"."|"&"|"["|"]"|"~"|"|"|"^"|"<"|">"|"!"|"="|"#"|"%"

ENTERO	(0[xX][0-9A-Fa-f]+)|(0[0-7]+)|[0-9]+
REAL	([0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?)|(0[xX][0-9A-Fa-f]*\.?[0-9A-Fa-f]+([eE][+-]?[0-9]+)?)
CARACTER	(\'[^\n'\\]\')|(\'\\['"\?\\abfnrtv]\')|(\'\\[0-3]?[0-7]{1,2}\')|(\'\\x[0-9A-Fa-f]{1,2}\')

CIDENTIFICADOR [a-zA-Z\_]
IDENTIFICADOR [a-zA-Z\_0-9]
LIBRERIA_START \"<
LIBRERIA_END >\"
ESPACIOS (\n|\t|\ )

%%

{LIBRERIA_START} {
    BEGIN(LIBRERIA);
}

<LIBRERIA>\n {
    ++nLinea;
}

<LIBRERIA>{LIBRERIA_END} {
    BEGIN(INITIAL);
    return(LIBRARY);
}

<LIBRERIA>[A-Za-z]*\.h {
    printf("(Lexer | Linea %d) Librería: %s\n", yylineno, yytext);
}

"auto"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(AUTO); }
"break"     { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(BREAK); }
"case"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(CASE); }
"char"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(CHAR); }
"continue"  { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(CONTINUE); }
"default"   { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(DEFAULT); }
"define"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(DEFINE); }
"do"        { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(DO); }
"double"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(DOUBLE); }
"else"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(ELSE); }
"extern"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(EXTERN); }
"float"     { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(FLOAT); }
"for"       { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(FOR); }
"goto"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(GOTO); }
"if"        { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(IF); }
"include"   { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(INCLUDE); }
"int"       { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(INT); }
"long"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(LONG); }
"register"  { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(REGISTER); }
"return"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(RETURN); }
"short"     { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(SHORT); }
"signed"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(SIGNED); }
"sizeof"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(SIZEOF); }
"static"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(STATIC); }
"struct"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(STRUCT); }
"switch"    { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(SWITCH); }
"typedef"   { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(TYPEDEF); }
"union"     { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(UNION); }
"unsigned"  { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(UNSIGNED); }
"void"      { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(VOID); }
"while"     { printf("(Lexer | Linea %d) Palabra reservada: %s\n", yylineno, yytext); return(WHILE); }

"&&"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(AND); }
"||"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(OR); }

"--"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(DMINUS); }
"++"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(DPLUS); }

"->"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(ARROW); }

"=="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(DEQUAL); }
"!="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(OPPOSITEAS); }
"*="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(TEQUAL); }
"/="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(DIVEQUAL); }
"%="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(PEQUAL); }
"+="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(PLUSEQUAL); }
"-="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(MINUSEQUAL); }
"&="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(ANDEQUAL); }
"^="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(POWEQUAL); }
"|="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(OREQUAL); }
"<="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(MINOREQUAL); }
">="    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(MAYOREQUAL); }
"<<="   { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(BYTELASSIGN); }
">>="   { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(BYTELASSIGN); }

"<<"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(BYTELMOVE); }
">>"    { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(BYTERMOVE); }

{OPERADORESBASICOS} { printf("(Lexer | Linea %d) Operador: %s\n", yylineno, yytext); return(yytext[0]); }

{ENTERO}    { printf("(Lexer | Linea %d) Constante entera: %s\n", yylineno, yytext); return(INTEGER); }
{REAL}      { printf("(Lexer | Linea %d) Constante real: %s\n", yylineno, yytext); return(REAL); }
{CARACTER}  { printf("(Lexer | Linea %d) Carácter: %s\n", yylineno, yytext); return(CHARACTER); }

{ESPACIOS}                          { /* Se ignoran sin más */ }
{DELIMITADORES}                     { printf("(Lexer | Linea %d) Delimitador: %s\n", yylineno, yytext); return(yytext[0]); }
{CIDENTIFICADOR}?{IDENTIFICADOR}*   { printf("(Lexer | Linea %d) Identificador: %s\n", yylineno, yytext); return(IDENTIFIER); }

{COMENTARIOS} { printf("(Lexer | Linea %d) Comentario ignorado.\n", yylineno); }
"/*" { BEGIN(COMENTARIOML); /* Comentario multilinea */ }
<COMENTARIOML>.
<COMENTARIOML>\n      { ++nLinea; }
<COMENTARIOML>"*/"    { printf("(Lexer | Linea %d) Comentario ignorado.\n", yylineno); BEGIN(INITIAL); }



\" {
    BEGIN(STRING);
    lineStart = yylineno;
    strncpy(buffer, "\"", 1024);
}

<STRING>[^\"\n"] {
    strcat(buffer, yytext);
}

<STRING>\n {
    ++nLinea;
    strcat(buffer, yytext);;
}

<STRING>\\\" {
    strcat(buffer, yytext);
}

<STRING>\" {
    strcat(buffer, yytext);
    BEGIN(INITIAL);
    printf("(Lexer | Linea %d) Cadena de caracteres: %s \n", lineStart, buffer);
    strncpy(buffer, "", 1024);
    return(CADENA);
}

.   {printf("(Lexer | Linea %d) ERROR: %s\n", yylineno, yytext);}

%%
