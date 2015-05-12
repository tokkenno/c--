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
%token ENTERO
%token REAL
%token CADENA
%token CARACTER
%token MAS
%token MENOS
%token SIZEOF
%token FLECHA
%start programa

%type <texto> macros
%type <texto> expresion

%%

programa: bloque
	| programa bloque;

bloque: expresion '\n' { printf ("bloque -> expresion \'\\n\'"); }
      | macros '\n'    { printf ("bloque -> macro \'\n\'"); }
;

macros: '#' INCLUDE DEFINE { printf("macros -> # include CABECERA"); }
      | '#' DEFINE IDENTIFICADOR constante { printf("macros -> # define IDENTIFICADOR constante");}

expresion : expresion_logica { printf("expresion -> expresion logica"); }
            | expresion_logica '?' expresion ':' expresion { printf("expresion -> expresion_logica ? expresion : expresion"); }

expresion_logica : expresion_constante { printf("expresion_logica -> expresion_constante"); }
                   | expresion_funcional { printf("expresion_logica -> expresion_funcional"); }
                   | expresion_indexada { printf("expresion_logica -> expresion_indexada"); }
                   | expresion_postfija { printf("expresion_logica -> expresion_postfija"); }
                   | expresion_prefija { printf("expresion_logica -> expresion_prefija"); }
                   | expresion_cast { printf("expresion_logica -> expresion_cast"); }

expresion_constante : ENTERO { printf("expresion_constante -> ENTERO"); }
                      | REAL { printf("expresion_constante -> REAL"); }
                      | CADENA { printf("expresion_constante -> CADENA"); }
                      | CARACTER { printf("expresion_constante -> CARACTER"); }
                      | '(' expresion ')' { printf("expresion_constante -> ( expresion )"); }

lista_expresionYcoma_opcional : expresion
                                | lista_expresionYcoma_opcional ',' { printf("lista_expresionYcoma_opcional -> lista_expresionYcoma_opcional expresion ,"); }

expresion_funcional : IDENTIFICADOR '(' lista_expresionYcoma_opcional ')' { printf("expresion_funcional -> IDENTIFICADOR ( lista_expresionYcoma_opcional )"); }
                      | IDENTIFICADOR '(' ')' { printf("expresion_funcional -> IDENTIFICADOR ( )"); }

expresion_indexada : IDENTIFICADOR { printf("expresion_indexada -> IDENTIFICADOR"); }
                     | expresion_indexada '[' expresion ']' { printf("expresion_indexada -> expresion_indexada [ expresion ]"); }
                     | expresion_indexada '.' IDENTIFICADOR { printf("expresion_indexada -> expresion_indexada . IDENTIFICADOR"); }
                     | expresion_indexada FLECHA IDENTIFICADOR { printf("expresion_indexada -> expresion_indexada FLECHA IDENTIFICADOR"); }

expresion_postfija : expresion_constante { printf("expresion_postfija -> expresion_constante"); }
                     | expresion_funcional { printf("expresion_postfija -> expresion_funcional"); }
                     | expresion_indexada { printf("expresion_postfija -> expresion_indexada"); }
                     | expresion_postfija MAS { printf("expresion_postfija -> expresion_postfija ++"); }
                     | expresion_postfija MENOS { printf("expresion_postfija -> expresion_postfija --"); }

expresion_prefija : expresion_postfija { printf("expresion_prefija -> expresion_postfija"); }
                    | SIZEOF expresion_prefija { printf("expresion_prefija -> SIZEOF expresion_prefija"); }
                    | SIZEOF '(' nombre_tipo ')' { printf("expresion_prefija -> SIZEOF ( nombre_tipo )"); }
                    | MAS expresion_prefija { printf("expresion_prefija -> ++ expresion_prefija"); }
                    | MENOS expresion_prefija { printf("expresion_prefija -> -- expresion_prefija"); }
                    | operador_unario expresion_cast { printf("expresion_prefija -> operador_unario expresion_cast"); }

operador_unario : '&' { printf("operador_unario -> &"); }
                  | '*' { printf("operador_unario -> *"); }
                  | '+' { printf("operador_unario -> +"); }
                  | '-' { printf("operador_unario -> -"); }
                  | '~' { printf("operador_unario -> ~"); }
                  | '!' { printf("operador_unario -> !"); }

expresion_cast : expresion_prefija { printf("expresion_cast -> expresion_prefija"); }
                 | '(' nombre_tipo ')' expresion_cast { printf("expresion_cast -> ( nombre_tipo ) expresion_cast"); }

lista_asterisco_opcional : /* Linea vacia */ { printf("lista_asterisco_opcional -> \"\""); }
                           | lista_asterisco_opcional '*' { printf("lista_asterisco_opcional -> lista_asterisco_opcional *"); }

tipo_basico : "void" { printf("tipo_basico -> void"); }
              | "char" { printf("tipo_basico -> char"); }
              | "int" { printf("tipo_basico -> int"); }
              | "float" { printf("tipo_basico -> float"); }
              | "double" { printf("tipo_basico -> double"); }

signo : "signed" { printf("signo -> \"signed\""); }
        | "unsigned" { printf("signo -> \"unsigned\""); }

signo_opcional : /* Linea vacia */ { printf("signo_opcional -> \"\""); }
                 | signo { printf("signo_opcional -> signo"); }

longitud : "short" { printf("longitud -> \"short\""); }
           | "long" { printf("longitud -> \"long\""); }

longitud_opcional : /* Linea vacia */ { printf("longitud_opcional -> \"\""); }
                    | longitud { printf("longitud_opcional -> longitud"); }

tipo_basico_modificado : signo_opcional longitud_opcional tipo_basico { printf("tipo_basico_modificado -> signo_opcional longitud_opcional tipo_basico"); }
                         | '[' IDENTIFICADOR ']' { printf("tipo_basico_modificado -> [ IDENTIFICADOR ]"); }

nombre_tipo : tipo_basico_modificado lista_asterisco_opcional { printf("nombre_tipo -> tipo_basico_modificado lista_asterisco_opcional"); }


constante: ENTERO { printf("constante -> ENTERO"); }
    | REAL { printf("constante -> REAL"); }
    | CADENA { printf("constante -> CADENA"); }
    | CARACTER { printf("constante -> CARACTER"); }
;

%%

int main(int argc, char** argv) {
  yyparse();
}

yyerror (char *s) { printf ("%s\n", s); }

