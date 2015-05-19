%{
        #include <stdio.h>
        #include <string.h>
        #include "analizador.tab.h"

        FILE* salida;
        int counter = 1, i = 0;
        int error = 0;

        void onError();
        void endError();
%}

SIGNO "+"|"-"
NUMERO [0-9]|0[xX][0-9a-fA-F]+
SALTO   [\n]
COMILLAS \"
BARRA \\
COMENTARIOSIMPLE "//"
COMENTARIOMULTILINEA "/*"
COMENTARIOFINAL "*/"
DELIMITADOR [\(\)\{\}\?\:\;\,]
OPERADORLOGICO ">"|"<"|"<="|">="|"||"|"&&"|"!="|"=="|"!"
OPERADORARITMETICO "+"|"-"|"*"|"/"|"%"|"++"|"--"|"&"|"|"|"~"|"^"|"<<"|">>"|"<<="|">>="
OPERADORASIGNACION "="|"+="|"-="|"*="|"/="|"%="|"&="|"|="|"^="
OPERADORFLECHA "->"
OPERADORPUNTO "."
OPERADORALMOHADILLA "#"|"##"
OPERADORSIZEOF "sizeof"
PALABRA [^"]
CIDENTIFICADOR [a-zA-Z\_]
IDENTIFICADOR [a-zA-Z\_0-9]


RESERVADA "erm....eto..."
OPERADOR "y aqui lo mismo..."

IL [\"\<]
FL [\>\"]

%x CADENA
%x COMENS
%X COMENM

%%

{COMENTARIOSIMPLE}      {
                        BEGIN(COMENS);
						            endError();
                        }

<COMENS>{SALTO}         {
                        ++counter;
                        BEGIN(INITIAL);
                        /* Comentatio ignorado */
                        }

<COMENS>[^\n]{1}      	{ /* Comentario ignorado */ }

{COMENTARIOMULTILINEA}  {
                        BEGIN(COMENM);
						            endError();
                        }

<COMENM>{SALTO}         {
                        ++counter;
                        }

<COMENM>{COMENTARIOFINAL}       {
                                BEGIN(INITIAL);
                                }

<COMENM>[^\n{COMENTARIOFINAL}]{1}      	{ /* Comentario ignorado */ }

{NUMERO}+        {
                 fprintf(salida, "Analizador lexico, linea %d, ctc entera: %s \n", counter, yytext);
						     endError();
                 return CONSTANTE_ENTERA;
                 }

{NUMERO}*[.]?{NUMERO}+[eE]?{SIGNO}?{NUMERO}*    {
                                                fprintf(salida, "LEXER(%d). Constante real: %s \n", counter, yytext);
						                                    endError();
                                                return CONSTANTE_REAL;
                                                }

"include"               { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return INCLUDE; }
"define"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return DEFINE; }
"auto"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return AUTO; }
"break"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return BREAK; }
"case"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return CASE; }
"char"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return CHAR; }
"const"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return CONST; }
"continue"              { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return CONTINUE; }
"default"               { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return DEFAULT; }
"do"                    { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return DO; }
"double"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return DOUBLE; }
"else"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return ELSE; }
"enum"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return ENUM; }
"extern"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return EXTERN; }
"float"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return FLOAT; }
"for"                   { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return FOR; }
"goto"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return GOTO; }
"if"                    { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return IF; }
"int"                   { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return INT; }
"long"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return LONG; }
"register"              { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return REGISTER; }
"return"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return RETURN; }
"short"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return SHORT; }
"signed"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return SIGNED; }
"static"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return STATIC; }
"struct"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return STRUCT; }
"switch"                { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return SWITCH; }
"typedef"               { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return TYPEDEF; }
"union"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return UNION; }
"unsigned"              { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return UNSIGNED; }
"void"                  { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return VOID; }
"volatile"              { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return VOLATILE; }
"while"                 { fprintf(salida, "LEXER(%d). Palabra reservada: %s\n", counter, yytext); endError(); return WHILE; }

{RESERVADA}             {
                        fprintf(salida, "Analizador lexico, linea %d, palabra reservada: %s\n \n", counter, yytext);
						            endError();
                        }

{DELIMITADOR}           {
                        fprintf(salida, "Analizador lexico, linea %d, delimitador: %s \n", counter, yytext);
						            endError();
                        // Hay que retornar delimitadores separados?
                        }

{OPERADORLOGICO}        { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return(OPERADORLOGICO); }

{OPERADOR}*             {
                        fprintf(salida, "Analizador lexico, linea %d, operador %s \n", counter, yytext);
						            endError();
                        return OPERADOR;
                        }

{OPERADORLOGICO}        { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return OPLOGICO; }
{OPERADORARITMETICO}    { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return OPARITMETICO; }
{OPERADORASIGNACION}    { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return OPASIGNACION; }
{OPERADORFLECHA}        { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return FLECHA; }
{OPERADORPUNTO}         { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return PUNTO; }
{OPERADORALMOHADILLA}   { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return ALMOHADILLA; }
{OPERADORSIZEOF}        { fprintf(salida, "LEXER(%d). Operador logico: %s\n", counter, yytext); endError(); return SIZEOF; }

{SALTO}                 {
                        ++counter;
						            endError();
                        }

{CIDENTIFICADOR}?{IDENTIFICADOR}*       {
                                        fprintf(salida, "Analizador lexico, linea %d, identificador: %s\n", counter, yytext);
					                              endError();
                                        return IDENTIFICADOR;
                                        }

{IL}{PALABRA}{FL}       {
                        fprintf(salida, "Analizador lexico, linea %d, librería: %s\n", counter, yytext);
						            endError();
                        return LIBRERIA;
                        }

{COMILLAS}\<			      {
                        fprintf(salida, "Analizador lexico, linea %d, librería: %s", counter, yytext);
						            endError();
                        BEGIN(CADENA);
                        }

{COMILLAS}              {
                        fprintf(salida, "Analizador lexico, linea %d, cadena: %s", counter, yytext);
						            endError();
                        BEGIN(CADENA);
                        }


<CADENA>{BARRA}{SALTO}  {
                        fprintf(salida, "%s", yytext);
                        ++counter;
                        }


<CADENA>{PALABRA}       {
                        fprintf(salida, "%s", yytext);
                        }

<CADENA>{BARRA}{COMILLAS}       {
                                fprintf(salida, "%s", yytext);
                                }

<CADENA>{COMILLAS}      {
                        fprintf(salida, "%s \n", yytext);
                        BEGIN(INITIAL);
                        }

[^ \n\t]				{
							  onError();
						    }

[ \t]					{ /* Ignoramos espacios y tabulaciones sueltas */ }

%%

void onError()
{
	if (!error) {
		fprintf(salida, "linea %d, ERROR: %s", counter, yytext);
	}
	else {
		fprintf(salida, "%s", yytext);
	}

	error = 1;
}

void endError()
{
	if (error) {
		fprintf(salida, "\n");
		error = 0;
	}
}

int yywrap()
{
        return 1;
}

int main(int arcg, char* argv[])
{
        yyin = fopen(argv[1],"r");
        salida = fopen("resultado.txt","w");
        while(yylex());
}
