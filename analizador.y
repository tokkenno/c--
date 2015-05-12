%{ /* Codigo C */
#include <stdio.h>
#include <math.h>
%}

%union {
  int valor_entero;
  double valor_real;
  char * texto;
}

%token <texto> INCLUDE DEFINE
%token <texto> ALMOHADILLA
%token <texto> SUMA RESTA DIVISION MULTIPLICACION
%token <texto> ARCHIVO
%token <texto> IDENTIFICADOR
%token <valor_entero> ENTERO
%token <valor_real> REAL
%token <texto> CADENA
%token <texto> CARACTER
%start programa

%type <texto> macros
%type <texto> programa
%type <texto> bloque
%type <texto> definicion_funcion
%type <texto> declaracion

%%

programa: bloque;

bloque: definicion_funcion
    | declaracion
    | macros
;

declaracion: INCLUDE;

definicion_funcion: DEFINE;

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
