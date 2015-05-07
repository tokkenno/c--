%{
        #include <stdio.h>
        #include <string.h>

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
RESERVADA "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"define"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"include"|"int"|"long"|"register"|"return"|"short"|"signed"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
DELIMITADOR [\(\)\{\}\?\:\;\,]
OPERADOR [\+\-\*\/\%(\-\-)(\+\+)(\*\=)(\/\=)(\%\=)(\+\=)(\-\=)\.(\-\>)\*\&\[\]\~\|\^(\<\<)(\>\>)(\<\<\=)(\>\>\=)(\&\=)(\^\=)(\|\=)\<\>(\<\=)(\>\=)(\=\=)(\!\=)\!(\&\&)(\|\|)\=(\.\.\.)\#(\#\#)]|"sizeof"
PALABRA [^"]
CIDENTIFICADOR [a-zA-Z\_]
IDENTIFICADOR [a-zA-Z\_0-9]
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
                fprintf(salida, "linea %d, ctc entera: %s \n", counter, yytext);
						endError();
                }

{NUMERO}*[.]?{NUMERO}+[eE]?{SIGNO}?{NUMERO}*    {
                                                fprintf(salida, "linea %d, ctc real: %s \n", counter, yytext);
						endError();
                                                }

{RESERVADA}             {
                        fprintf(salida, "linea %d, palabra reservada: %s \n", counter, yytext);
						endError();
                        }

{DELIMITADOR}           {
                        fprintf(salida, "linea %d, delimitador: %s \n", counter, yytext);
						endError();
                        }

{OPERADOR}*             {
                        fprintf(salida, "linea %d, operador %s \n", counter, yytext);
						endError();
                        }

{SALTO}                 {
                        ++counter;
						endError();
                        }

{CIDENTIFICADOR}?{IDENTIFICADOR}*       {
                                        fprintf(salida, "linea %d, identificador: %s\n", counter, yytext);
										endError();
                                        }

{IL}{PALABRA}{FL}       {
                        fprintf(salida, "linea %d, librería: %s\n", counter, yytext);
						endError();
                        }
                        
{COMILLAS}\<			{
                        fprintf(salida, "linea %d, librería: %s", counter, yytext);
						endError();
                        BEGIN(CADENA);
                        }

{COMILLAS}              {
                        fprintf(salida, "linea %d, cadena: %s", counter, yytext);
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
