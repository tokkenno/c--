%{ /* Codigo C */
#include <stdio.h>

%}



/* Declaraciones de BISON */

%union {
  int valor_entero;
  double valor_real;
  char * texto;
}


/* Definición de los TOKENS */

%token <valor_real> REAL
%token <valor_entero> ENTERO
%token <texto> IDENTIFICADOR LIBRERIA CARACTER CADENA AUTO BREAK CASE CHAR CONTINUE DEFAULT DEFINE DO DOUBLE ELSE  EXTERN FLOAT FOR GOTO IF INCLUDE INT REGISTER RETURN SHORT SIGNED STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID WHILE LONG

/* Definición de la ASOCIATIVIDAD y PRECEDENCIA de los operadores */	

%right '=' PORIGUAL MODIGUAL  DIVIGUAL  MASIGUAL MENOSIGUAL MENORMENORIGUAL MAYORMAYORIGUAL ANDIGUAL POWIGUAL ORIGUAL 
%right '?' ':'
%left OR
%left AND
%left '|'
%left '^'
%left '&'
%left ADMIRACIONIGUAL IGUALIGUAL
%left MAYORIGUAL MENORIGUAL '<' '>'
%left MAYORMAYOR  MENORMENOR
%left '-' '+'
%left '*' '/' '%'
%right MENOSMENOS MASMAS SIZEOF
%left GUIMAY 
%left ')'
%right '('

%expect 2

%%

/* Gramatica */

/****************************** BLOQUES ************************************/

programa : lista_bloques { printf("Programa -> lista_bloques\n"); };

lista_bloques: bloque { printf("Lista_bloques -> bloque\n"); }
            |  bloque  lista_bloques { printf("Lista_bloques -> lista_bloques bloque\n"); };

bloque : definicion_funcion { printf("bloque -> definicion_funcion\n"); }
       | declaracion { printf("bloque -> declaracion\n"); }
       | macros { printf("bloque -> macros\n"); } ;

definicion_funcion : IDENTIFICADOR bloque_instrucciones { printf("definicion_funcion -> IDENTIFICADOR bloque_instrucciones\n"); }
                   | declaracion_tipo IDENTIFICADOR bloque_instrucciones { printf("definicion_funcion -> declaracion_tipo IDENTIFICADOR bloque_instrucciones\n"); }
                   | asterisco_list IDENTIFICADOR bloque_instrucciones { printf("definicion_funcion -> asterisco_list IDENTIFICADOR bloque_instrucciones\n"); }
                   | declaracion_tipo asterisco_list IDENTIFICADOR bloque_instrucciones { printf("definicion_funcion -> declaracion_tipo asterisco_list IDENTIFICADOR bloque_instrucciones\n"); };

macros : '#' INCLUDE LIBRERIA { printf("macros -> '#' include LIBRERIA\n"); }
       | '#' DEFINE IDENTIFICADOR constante { printf("macros -> '#' define IDENTIFICADOR constante\n"); };


constante : ENTERO { printf("constante -> ENTERO\n"); }
          | REAL { printf("constante -> REAL\n"); }
          | CADENA { printf("constante -> CADENA\n"); }
          | CARACTER { printf("constante -> CARACTER\n"); };

/****************************** DECLARACIONES ************************************/

		  
declaracion : declaracion_tipo lista_nombres '#'  ';' { printf("Declaracion -> declaracion_tipo lista_nombres\n"); }
      | declaracion_tipo lista_nombres ';' { printf("Declaracion -> declaracion_tipo lista_nombres\n"); }
      | declaracion_tipo '#' ';' { printf("Declaracion -> declaracion_tipo\n"); }
      | declaracion_tipo ';'  { printf("Declaracion -> declaracion_tipo\n"); }
      | TYPEDEF declaracion_tipo ';' { printf("Declaracion -> TYPEDEF declaracion_tipo ';'\n"); }
  	  | TYPEDEF declaracion_tipo identificador_list ';' { printf("Declaracion -> TYPEDEF declaracion_tipo identificador_list ';'\n"); };
	  
identificador_list : IDENTIFICADOR { printf("identificador_list -> IDENTIFICADOR\n"); }
                   | IDENTIFICADOR identificador_list { printf("identificador_list -> identificador_list IDENTIFICADOR\n"); };

declaracion_tipo: almacenamiento_list  tipo_basico_modificado { printf("Declaracion_tipo -> declaracion_tipo\n"); }
                |  definicion_struct_union { printf("Declaracion_tipo -> almacenamiento_list  definicion_struct_union\n"); };
                | tipo_basico_modificado { printf("Declaracion_tipo -> tipo_basico_modificado\n"); }
 				| almacenamiento_list definicion_struct_union { printf("Declaracion_tipo -> almacenamiento_list  definicion_struct_union\n"); };
						
 tipo_basico_modificado :  signo longitud tipo_basico { printf("Tipo_basico_modificado -> signo longitud tipo_basico\n"); }
                           | '[' IDENTIFICADOR ']' { printf("Tipo_basico_modificado -> '[' IDENTIFICADOR ']'\n"); }
                           | signo tipo_basico { printf("Tipo_basico_modificado -> signo tipo_basico\n"); }
                           | longitud tipo_basico { printf("Tipo_basico_modificado -> longitud tipo_basico\n"); }
                           | tipo_basico { printf("Tipo_basico_modificado -> tipo_basico \n"); };
						   
almacenamiento : EXTERN { printf("Almacenamiento -> EXTERN\n"); }
                | STATIC { printf("Almacenamiento -> STATIC\n"); }
                | AUTO { printf("Almacenamiento -> AUTO\n"); }
                | REGISTER { printf("Almacenamiento -> REGISTER\n"); };   

almacenamiento_list : almacenamiento { printf("almacenamiento_list -> almacenamiento\n"); }
                    | almacenamiento almacenamiento_list { printf("almacenamiento_list -> almacenamiento_list almacenamiento\n"); };

     
longitud : SHORT { printf("longitud -> short\n"); }
         | LONG { printf("longitud -> long\n"); };

signo : SIGNED { printf("signo -> signed\n"); }
      | UNSIGNED { printf("signo -> unsigned\n"); };


tipo_basico : VOID { printf("tipo_basico -> void\n"); }
            | CHAR { printf("tipo_basico -> char\n"); }
            | INT { printf("tipo_basico -> int\n"); }
            | FLOAT { printf("tipo_basico -> float\n"); }
            | DOUBLE { printf("tipo_basico -> double\n"); };

definicion_struct_union: struct_union  IDENTIFICADOR  '{' declaracion_struct_list'}' { printf("definicion_struct_union -> struct_union  IDENTIFICADOR  '{' declaracion_struct '}'\n"); }
                       | struct_union IDENTIFICADOR { printf("definicion_struct_union -> struct_union IDENTIFICADOR\n"); }
    		           | struct_union '{' declaracion_struct_list '}' { printf("definicion_struct_union -> struct_union '{' declaracion_struct_list '}'\n"); };						  

struct_union : STRUCT { printf("struct_union -> STRUCT\n"); }
             | UNION { printf("struct_union -> UNION\n"); };
                  

declaracion_struct_list : declaracion_struct { printf("declaracion_struct_list -> declaracion_struct\n"); }
                        | declaracion_struct declaracion_struct_list { printf("declaracion_struct_list -> declaracion_struct_list declaracion_struct\n"); };

declaracion_struct : tipo_basico_modificado lista_nombres ';' { printf("declaracion_struct -> tipo_basico_modificado lista_nombres ';'\n"); }
                   | definicion_struct_union lista_nombres ';' { printf("declaracion_struct -> definicion_struct_union lista_nombres ';'\n"); };


lista_nombres : nombre { printf("lista_nombres -> nombre\n"); }
              | nombre ',' lista_nombres { printf("lista_nombres -> lista_nombres ',' nombre\n"); };

nombre : dato { printf("nombre -> dato\n"); }
       | dato '=' elementos { printf("nombre -> dato '=' elementos\n"); };
 
dato :  asterisco_list  IDENTIFICADOR  '[' expresion ']' { printf("Dato -> asterisco_list  IDENTIFICADOR  '[' expresion ']'\n"); }
	  | asterisco_list IDENTIFICADOR '[' ']' { printf("Dato -> asterisco_list IDENTIFICADOR '[' ']'\n"); }
      | asterisco_list IDENTIFICADOR { printf("Dato -> asterisco_list IDENTIFICADOR \n"); };
      | IDENTIFICADOR { printf("Dato -> 'IDENTIFICADOR'\n"); }
	  | IDENTIFICADOR '['']' { printf("Dato -> 'IDENTIFICADOR' '['']'\n"); }
	  | IDENTIFICADOR '[' expresion ']' { printf("Dato -> 'IDENTIFICADOR' '[' expresion ']'\n"); }
		
elementos : expresion { printf("elementos -> expresion\n"); }
          | '{' elementosLista '}' { printf("elementos -> '{' elementosLista elementosLista '}'\n"); } ; 	
		  
elementosLista : elementos { printf("elementosLista -> elementos ,\n"); }
               | elementos ',' elementosLista { printf("elementoslista -> elementos ',' elementosLista  ,\n"); } ;             

 

/****************************** EXPRESIONES ************************************/

expresion : expresion_logica { printf("Expresion  -> expresion_logica\n"); }
     | expresion_logica  '?' expresion ':' expresion  { printf("Expresion  -> expresion_logica '?' expresion ':' expresion \n"); }
     | expresion '-' expresion  { printf("Expresion_logica -> expresion '-' expresion\n"); }
     | expresion '+' expresion  { printf("Expresion_logica -> expresion '+' expresion\n"); }
     | expresion '*' expresion { printf("Expresion_logica -> expresion '*' expresion\n"); }
     | expresion '/' expresion { printf("Expresion_logica -> expresion '/' expresion\n"); }
     | expresion '%' expresion { printf("Expresion_logica -> expresion '%c' expresion\n",37); };

expresion_logica: expresion_prefija { printf("Expresion_logica -> expresion_prefija \n"); }
          | expresion OR expresion { printf("Expresion_logica -> expresion OR expresion \n"); }
          | expresion AND expresion { printf("Expresion_logica -> expresion AND expresion \n"); }
          | expresion '|' expresion { printf("Expresion_logica -> expresion '|' expresion  \n"); }
          | expresion '^' expresion { printf("Expresion_logica -> expresion '^' expresion\n"); }
          | expresion '&' expresion { printf("Expresion_logica -> expresion '&' expresion\n"); }
          | expresion ADMIRACIONIGUAL expresion { printf("Expresion_logica -> expresion 'ADMIRACIONIGUAL' expresion\n"); }
          | expresion IGUALIGUAL expresion { printf("Expresion_logica -> expresion 'IGUALIGUAL' expresion\n"); }
          | expresion MAYORIGUAL expresion  { printf("Expresion_logica -> expresion 'MAYORIGUAL' expresion\n"); }
          | expresion MENORIGUAL expresion  { printf("Expresion_logica -> expresion 'MENORIGUAL' expresion\n"); }
          | expresion '<' expresion  { printf("Expresion_logica -> expresion '<' expresion\n"); }
          | expresion '>' expresion  { printf("Expresion_logica -> expresion '>' expresion\n"); }
          | expresion MENORMENOR expresion { printf("Expresion_logica -> expresion 'MENORMENOR' expresion\n"); }
          | expresion MAYORMAYOR expresion { printf("Expresion_logica -> expresion 'MAYORMAYOR' expresion\n"); };


expresion_constante : ENTERO { printf("expresion_constante -> ENTERO\n"); }
                      | REAL { printf("expresion_constante -> REAL\n"); }
                      | CADENA { printf("expresion_constante -> CADENA\n"); }
                      | CARACTER { printf("expresion_constante -> CARACTER\n"); }
                      | '(' expresion ')' { printf("expresion_constante -> '(' expresion ')'\n"); };


expresion_funcional : IDENTIFICADOR '(' ')' { printf("expresion_funcional -> IDENTIFICADOR '(' ')'\n"); }
                    | IDENTIFICADOR '(' lista_expresiones ')' { printf("expresion_funcional -> IDENTIFICADOR '(' lista_expresiones ')'\n"); };

lista_expresiones : expresion { printf("lista_expresiones -> expresion\n"); }
                  | lista_expresiones ',' expresion { printf("lista_expresiones -> lista_expresiones ',' expresion\n"); } ;                                    


expresion_indexada : IDENTIFICADOR { printf("expresion_indexada -> IDENTIFICADOR\n"); }
                   | expresion_indexada '[' expresion ']' { printf("expresion_indexada -> expresion_indexada '[' expresion ']'\n"); }
                   | expresion_indexada '.' IDENTIFICADOR { printf("expresion_indexada -> expresion_indexada '.' IDENTIFICADOR\n"); }
                   | expresion_indexada GUIMAY IDENTIFICADOR { printf("expresion_indexada -> expresion_indexada GUIMAY IDENTIFICADOR\n"); };

expresion_postfija : expresion_constante { printf("expresion_postfija -> expresion_constante\n"); }
                   | expresion_funcional { printf("expresion_postfija -> expresion_funcional\n"); }
                   | expresion_indexada { printf("expresion_postfija -> expresion_indexada\n"); }
                   | expresion_postfija MASMAS { printf("expresion_postfija -> expresion_postfija ++\n"); }
                   | expresion_postfija MENOSMENOS { printf("expresion_postfija -> expresion_postfija --\n"); };

expresion_prefija : expresion_postfija { printf("expresion_prefija -> expresion_postfija\n"); }
                  | SIZEOF expresion_prefija { printf("expresion_prefija -> SIZEOF expresion_prefija\n"); }
                  | SIZEOF '(' nombre_tipo ')' { printf("expresion_prefija -> SIZEOF '(' nombre_tipo ')'\n"); }
                  | MASMAS expresion_prefija { printf("expresion_prefija -> ++ expresion_prefija\n"); }
                  | MENOSMENOS expresion_prefija { printf("expresion_prefija -> -- expresion_prefija\n"); }
                  | operador_unario expresion_cast { printf("expresion_prefija -> operador_unario expresion_cast\n"); };


operador_unario : '&' { printf("Operador unario  -> '&'\n"); }
                 | '*' { printf("Operador unario  -> '*'\n"); }
                 | '+' { printf("Operador unario  -> '+'\n"); }
                 | '-' { printf("Operador unario  -> '-'\n"); }
                 | '~' { printf("Operador unario  -> '~'\n"); }
                 | '!' { printf("Operador unario  -> '!'\n"); };

expresion_cast : expresion_prefija { printf("expresion_cast -> expresion_prefija\n"); }
               | '(' nombre_tipo ')' expresion_cast { printf("expresion_cast -> '(' nombre_tipo ')' expresion_cast\n"); };

nombre_tipo : tipo_basico_modificado { printf("nombre_tipo -> tipo_basico_modificado\n"); }
            | tipo_basico_modificado asterisco_list { printf("nombre_tipo -> tipo_basico_modificado asterisco_list\n"); };



asterisco_list : '*' { printf("asterisco_list -> '*'\n"); }
               | '*' asterisco_list { printf("asterisco_list -> asterisco_list '*'\n"); };


/****************************** INSTRUCCIONES ************************************/

instruccion : bloque_instrucciones { printf("instruccion -> bloque_instrucciones\n"); }
            | instruccion_expresion { printf("instruccion -> instruccion_expresion\n"); }
            | instruccion_bifurcacion { printf("instruccion -> instruccion_bifurcacion\n"); }
            | instruccion_bucle { printf("instruccion -> instruccion_bucle\n"); }
            | instruccion_salto { printf("instruccion -> instruccion_salto\n"); }
            | instruccion_destino_salto { printf("instruccion -> instruccion_destino_salto\n"); }
            | instruccion_retorno { printf("instruccion -> instruccion_retorno\n"); };

bloque_instrucciones : '{' '}' { printf("bloque_instrucciones -> '{' '}'\n"); }
                     | '{' declaracion_list '}' { printf("bloque_instrucciones -> '{' declaracion_list '}'\n"); }
                     | '{' instruccion_list '}' { printf("bloque_instrucciones -> '{' instruccion_list '}'\n"); }
                     | '{' declaracion_list instruccion_list '}' { printf("bloque_instrucciones -> '{' declaracion_list instruccion_list '}'\n"); };
                      
declaracion_list : declaracion { printf("declaracion_list -> declaracion\n"); }
                 | declaracion declaracion_list { printf("declaracion_list -> declaracion_list declaracion\n"); };
                

instruccion_list : instruccion { printf("instruccion_list -> instruccion\n"); }
                 | instruccion instruccion_list { printf("instruccion_list -> instruccion_list instruccion\n"); };

instruccion_expresion : expresion ';' { printf("instruccion_expresion -> expresion ';'\n"); }
                      | asignacion ';' { printf("instruccion_expresion -> asignacion ';'\n"); }
              


asignacion : expresion_indexada operador_asignacion expresion { printf("asignacion -> expresion_indexada operador_asignacion expresion\n"); } ;


operador_asignacion : '=' { printf("operador_asignacion -> '='\n"); }
                    | PORIGUAL { printf("operador_asignacion -> PORIGUAL\n"); }
					| MODIGUAL { printf("operador_asignacion -> MODIGUAL\n"); }
                    | DIVIGUAL { printf("operador_asignacion -> DIVIGUAL\n"); }
                    | MASIGUAL { printf("operador_asignacion -> MASIGUAL\n"); }
                    | MENOSIGUAL { printf("operador_asignacion -> MENOSIGUAL\n"); }
                    | MENORMENORIGUAL { printf("operador_asignacion -> MENORMENORIGUAL\n"); }
                    | MAYORMAYORIGUAL { printf("operador_asignacion -> MAYORMAYORIGUAL\n"); }
                    | ANDIGUAL { printf("operador_asignacion -> ANDIGUAL\n"); }
                    | POWIGUAL { printf("operador_asignacion -> POWIGUAL\n"); }
                    | ORIGUAL { printf("operador_asignacion -> ORIGUAL\n"); };

instruccion_bifurcacion : IF '(' expresion ')' instruccion { printf("instruccion_bifurcacion -> IF '(' expresion ')' instruccion\n"); }
                        | IF '(' expresion ')' instruccion ELSE instruccion { printf("instruccion_bifurcacion -> IF '(' expresion ')' instruccion ELSE instruccion\n"); }
                        | SWITCH '(' expresion ')' '{' instruccion_caso_list'}' { printf("instruccion_bifurcacion -> SWITCH '(' expresion ')' '{' instruccion_caso_list'}'\n"); };

instruccion_caso_list : instruccion_caso { printf("instruccion_caso_list -> instruccion_caso\n"); }
                      | instruccion_caso instruccion_caso_list { printf("instruccion_caso_list -> instruccion_caso_list instruccion_caso\n"); } ;    

instruccion_caso : CASE expresion ':' instruccion { printf("instruccion_caso -> CASE expresion ':' instruccion\n"); }
                 | DEFAULT ':' instruccion { printf("instruccion_caso -> DEFAULT ':' instruccion\n"); };

instruccion_bucle : WHILE '(' expresion ')' instruccion { printf("instruccion_bucle -> WHILE '(' expresion ')' instruccion\n"); }
                  | DO instruccion WHILE '(' expresion ')' ';' { printf("instruccion_bucle -> DO instruccion WHILE '(' expresion ')' ;\n"); }
                  | FOR '(' ';' expresion ';' expresion ')' instruccion { printf("instruccion_bucle -> FOR '(' ';' expresion ';' expresion ')' instruccion\n"); }
                  | FOR '(' lista_asignaciones ';' expresion ';' expresion ')' instruccion { printf("instruccion_bucle -> FOR '(' lista_asignaciones ';' expresion ';' expresion ')' instruccion\n"); };

lista_asignaciones : asignacion { printf("lista_asignaciones -> asignacion\n"); }
                   | asignacion ',' lista_asignaciones { printf("lista_asignaciones -> lista_asignaciones ',' asignacion\n"); } ;      

instruccion_salto : GOTO IDENTIFICADOR ';' { printf("instruccion_salto -> GOTO IDENTIFICADOR ';'\n"); }
                  | CONTINUE ';' { printf("instruccion_salto -> CONTINUE ';'\n"); }
                  | BREAK ';' { printf("instruccion_salto -> BREAK ';'\n"); };

instruccion_destino_salto : IDENTIFICADOR ':' instruccion ';' { printf("instruccion_destino_salto -> IDENTIFICADOR ':' instruccion ';'\n"); };

instruccion_retorno : RETURN ';' { printf("instruccion_retorno -> RETURN ';'\n"); }
                    | RETURN expresion ';' { printf("instruccion_retorno -> RETURN expresion ';'\n"); };
                                                                                          
                  

%%

int main (int argc, char * argv[ ])
{
    extern FILE * yyin;

    if (argc != 2) {
        fprintf(stderr, "USO: %s fichero\n", argv[0]);
        return -1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Fichero inexistente %s\n", argv[1]);
        return -1;
    }

    yyparse();
    fclose(yyin);

    
    return 1;

    
}

yyerror (char *s) { printf ("%s\n", s); }

int yywrap() { return 1; }




