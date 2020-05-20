%{
	#include<stdio.h>
	#include<string.h>
	#include <math.h>
	#include "lexical.tab.h"

	extern char nom[50];  /* cha^ıne de caract`eres partag´ee avec l’analyseur lexical */
%}



%option yylineno
delim						[\t]
bl							{delim}+
retour_ligne				[\n]
seperator					"_"
commentaire					\/\/.*\n|\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\/
chiffre						[0-9]
lettre						[a-zA-Z]
identificateur				{lettre}({chiffre}|{lettre})*
literal_entier				{chiffre}*
iderr						({chiffre}|{seperator})({lettre}|{chiffre}|{seperator})*
parenthese_ouvrant			\(
parenthese_fermant			\)
crochet_ouvrant				\[	
crochet_fermant				\]
mulop						"*"|"/"
addop						"+"|"-"
type						"integer"
keyword						"for"|"to"|"repeat"|"until"|"true"|"false"
point 						"."
virgule 					","
point_virgule				";"
deux_points					":"

%x C_COMMENT






%%

"/*"            { BEGIN(C_COMMENT); }
<C_COMMENT><<EOF>> { fprintf(stderr,"unclosed comment on line :%d\n",yylineno); exit( 1 ); }
<C_COMMENT>"*/" { BEGIN(INITIAL); }
<C_COMMENT>\n   { }
<C_COMMENT>.    { }



{bl} /* rien à faire */
" "  /* rien à faire */
"\n" {++yylineno;} 
begin {return T_BEGIN;}
program {return PROGRAM;}
var {return VAR;}
end {return END;}
if {return IF;}
then {return THEN;}
else {return ELSE;}
while {return WHILE;}
do {return DO;}
array {return ARRAY;}
of {return OF;}
procedure {return PROCEDURE;}
print {return PRINT;}
{commentaire} {return COMMENT;}
{type} {return TYPE;}
{identificateur} {strcpy(nom, yytext); fprintf(stderr, "%s \n", yytext); return IDENT;}
{literal_entier} {yylval = atoi(yytext); return NUMBER;}
{keyword} {return KEYWORD;}
{parenthese_ouvrant} {return OPEN_PAR;}
{parenthese_fermant} {return CLOSE_PAR;}
{crochet_ouvrant} {return OPEN_CRO;}
{crochet_fermant} {return CLOSE_CRO;}
{mulop} {return MUL_OP;}
{addop} {return ADD_OP;}
{point} {return PUNCT_POINT;}
{virgule} {return PUNCT_VIRGULE;}
{point_virgule} {return PUNCT_POINT_VIRGULE;}
{deux_points} {return PUNCT_DEUX_POINTS;}
":="   {return OPP_AFFECT;}

{iderr}  {fprintf(stderr,"illegal identifier \'%s\' on line :%d\n",yytext,yylineno);}
.  	{fprintf(stderr,"Illegal character \'%s\' on line :%d\n",yytext,yylineno);}


%%
