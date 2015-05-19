[[ -f analizador.exe ]] && rm -f analizador.exe
bison -d cmm.y
flex cmm.l
gcc -o analizador.exe cmm.tab.c lex.yy.c
rm cmm.tab.c cmm.tab.h lex.yy.c
