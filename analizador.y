%{ /* Codigo C */
#include <stdio.h>
#include <math.h>
%}

%union {
  int valor_entero;
  double valor_real;
  char * texto;
}

%token INCLUDE DEFINE
%token ALMOHADILLA
%token SUMA RESTA DIVISION MULTIPLICACION
%token ARCHIVO
%token IDENTIFICADOR
%start programa

%%

programa: < bloque > bloque;

bloque: definicion_funcion
    | declaracion
    | macros
;

macros: ALMOHADILLA INCLUDE ARCHIVO
    | ALMOHADILLA DEFINE IDENTIFICADOR constante
;

constante: ENTERO
    | REAL
    | CADENA
    | CARACTER
;

%%

int main(int argc, char** argv) {
  yyparse();
}

yyerror (char *s) { printf ("%s\n", s); }

int yywrap() { return 1; }
