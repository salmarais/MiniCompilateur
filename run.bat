@echo off
set count=0
:a
flex lexical.lex
bison -d lexical.y --verbose
gcc lex.yy.c lexical.tab.c 
a.exe test.txt
PAUSE
delete
goto :a