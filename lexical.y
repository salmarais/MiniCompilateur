%{
	
	
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>


  #include <stdio.h>
  #include "semantique.c"
		 			
	int yylex(void);
  extern int yylineno;


  int error_syntaxique = 0;
  extern int error_semantique;

	//int error_semantique = 0;


%}


%start program
%token PROGRAM             
%token COMMENT
%token OPP_AFFECT            
%token OPEN_PAR                    
%token CLOSE_PAR                     
%left MUL_OP                         
%left ADD_OP                         
%token TYPE                          
%token KEYWORD                     
%token PUNCT_POINT                        
%token PUNCT_VIRGULE                       
%token PUNCT_POINT_VIRGULE                   
%token PUNCT_DEUX_POINTS
%token VAR
%token PROCEDURE
%token END 
%token IF
%token THEN
%token ELSE
%token PRINT
%token WHILE
%token DO
%token OPEN_CRO
%token CLOSE_CRO
%token ARRAY
%token OF 
%token DEUX_P
%token T_BEGIN

%union {
  int number;
  const char* identifier;
}

%token <number> NUMBER
%token <identifier> IDENT





%%

program:
		  PROGRAM IDENT PUNCT_POINT_VIRGULE liste_declarations declaration_methodes instruction_composee
		| PROGRAM IDENT PUNCT_POINT_VIRGULE  declaration_methodes instruction_composee	
		| PROGRAM IDENT PUNCT_POINT_VIRGULE liste_declarations instruction_composee	
		| PROGRAM IDENT error 		  {yyerror ("\";\" attendu en ligne : "); }
		;
                                                           
type : TYPE  
       |ARRAY OPEN_CRO NUMBER DEUX_P NUMBER CLOSE_CRO OF TYPE
       //Les erreurs possible
       | ARRAY error         {yyerror ("\" [ \" attendu ligne : "); }
       | ARRAY OPEN_CRO NUMBER DEUX_P NUMBER     {yyerror ("\" ] \" attendu ligne : "); }
       | ARRAY OPEN_CRO error         {yyerror("l'intervalle de tableau doit être specifiee en ligne : ");}
       | ARRAY OPEN_CRO NUMBER DEUX_P error         {yyerror("L'intervalle de tableau doit être specifiee en ligne : ");}
       | ARRAY OPEN_CRO NUMBER DEUX_P NUMBER CLOSE_CRO         {yyerror("Le mot reserve \" of \" est attendu en ligne : ");}
	   ;

declaration:
                    VAR IDENT PUNCT_DEUX_POINTS type PUNCT_POINT_VIRGULE {addSymbol($2, 0, 0); checkIfIdentifierIsDeclared($2, 0, yylineno);}
                  | VAR IDENT PUNCT_DEUX_POINTS type error {yyerror ("\";\" attendu en ligne : "); }      
                  | VAR IDENT error {yyerror ("erreur dans la declaration des variables en ligne : "); }     
                  | VAR IDENT PUNCT_DEUX_POINTS error {yyerror ("erreur dans la declaration de type en ligne : "); }
                  ;      



liste_declarations : declaration
                   | declaration  liste_declarations
                   ;


liste_identificateurs :    IDENT {checkIfVariableIsInitialized($1, 0, yylineno);}
				                 | IDENT PUNCT_VIRGULE liste_identificateurs
                         ;

declaration_methodes : declaration_methode 
                     | declaration_methode declaration_methodes
                     ;

declaration_methode : entete_methode instruction_composee
                    | entete_methode liste_declarations instruction_composee 
                    | entete_methode error         {yyerror ("erreur dans la declaration de procedure en ligne: "); }
                    | entete_methode liste_declarations error        {yyerror ("erreur dans la declaration de procedure en ligne: "); }
                    ;

entete_methode : PROCEDURE IDENT arguments PUNCT_POINT_VIRGULE {checkIfIdentifierIsDeclared($2, 1, yylineno);}
               | PROCEDURE IDENT PUNCT_POINT_VIRGULE { checkIfIdentifierIsDeclared($2, 1, yylineno);}
               | PROCEDURE IDENT error   {yyerror ("\";\" attendu en ligne : "); } 
               | error IDENT arguments PUNCT_POINT_VIRGULE    {yyerror("le mot reserve \" procedure \" est attendu en ligne : ");}
               | PROCEDURE error     {yyerror("erreur dans la declaration de procedure en ligne: ");}
               | PROCEDURE IDENT arguments error   {yyerror ("\";\" attendu en ligne : "); }
               ;  

arguments : OPEN_PAR liste_parametres CLOSE_PAR 
          | OPEN_PAR CLOSE_PAR    
          | OPEN_PAR liste_parametres error  {yyerror ("\" ) \" attendu en ligne : "); }
          | OPEN_PAR error    {yyerror("erreur dans la declaration de procedure en ligne: ");}
          ;

liste_parametres : declaration 
                 | declaration liste_parametres
                 ;

instruction_composee : T_BEGIN liste_instructions END 
                     | T_BEGIN liste_instructions error  {yyerror("le mot reserve \" end \" est attendu en ligne : ");}
                     ;

liste_instructions : instruction PUNCT_POINT_VIRGULE
                   | instruction error    {yyerror ("\";\" attendu en ligne : "); }   
                   | instruction PUNCT_POINT_VIRGULE liste_instructions   
                   ;

instruction : IDENT OPP_AFFECT expression {initSymbol($1, yylineno);}
            | IDENT error      {yyerror("\" := \" est attendu en ligne : ");}  
            | appel_methode 
	        | IF expression THEN instruction ELSE instruction 
            | IF error    {yyerror("condition errone en ligne : ");}
            | IF expression THEN error    {yyerror("condition errone en ligne : ");}
            | IF expression THEN instruction ELSE error    {yyerror("condition errone en ligne : ");}
	        | IF expression error     {yyerror("le mot reserve \" then \" est attendu en ligne : ");}
	        | IF expression THEN instruction error instruction      {yyerror("le mot reserve \" else \" est attendu en ligne : ");}
	        | WHILE expression DO instruction 
	        | WHILE expression error      {yyerror("le mot reserve \" do \" est attendu en ligne : ");}
	        | WHILE error        {yyerror("boucle errone en ligne : ");}
	        | WHILE expression DO error     {yyerror("boucle errone en ligne : ");}
	        | PRINT OPEN_PAR liste_identificateurs CLOSE_PAR {debug("Printing");}
	        | PRINT error   {yyerror ("\" ( \" attendu en ligne : "); }
	        | PRINT OPEN_PAR liste_identificateurs error     {yyerror ("\" ) \" attendu en ligne : "); }
	        | PRINT OPEN_PAR error                 {yyerror ("instruction errone en ligne : "); }
	        ;


appel_methode : IDENT OPEN_PAR liste_expressions CLOSE_PAR {checkIfIdentifierIsDeclared($1, 1, yylineno);}
              | IDENT OPEN_PAR CLOSE_PAR {checkIfIdentifierIsDeclared($1, 1, yylineno);}
              | IDENT OPEN_PAR liste_expressions error   {yyerror ("\" ) \" attendu en ligne : ");}
              ;
             
liste_expressions : expression
                  | liste_expressions PUNCT_VIRGULE expression   
                  ;
expression : facteur 
           | facteur ADD_OP facteur  
           | facteur MUL_OP facteur
           ;
facteur : NUMBER 
        | IDENT {checkIfVariableIsInitialized($1, 0, yylineno);}
        | IDENT OPEN_CRO expression CLOSE_CRO 
        | IDENT OPEN_CRO expression error     {yyerror ("\" ] \" attendu en ligne : "); }
        | IDENT OPEN_CRO error     {yyerror ("expression errone en ligne : "); }
        | OPEN_PAR expression CLOSE_PAR
        | OPEN_PAR expression error       {yyerror ("\" ) \" attendu en ligne : "); }
        | OPEN_PAR error           {yyerror ("expression errone en ligne : "); }
        ;


%% 


int yyerror(char const *msg) {
       
	fprintf(stderr,"%s %d\n", msg,yylineno);
	error_syntaxique++;
	return 0;
	
}

extern FILE *yyin;

int main(int argc, char *argv[]) 
{
 // createDico();
  
	 printf("\n analyse syntaxique\n");
   yyin = fopen(argv[1], "r");
	 yyparse();
	if(!error_syntaxique) 
    printf(" --> 0 error syntaxique \n");
 	else 
    printf(" --> %d error(s) syntaxique(s)\n", error_syntaxique);

 if(!error_semantique)
    printf(" --> 0 error semantique \n");
  else 
    printf(" --> %d error(s) semantique(s)\n", error_semantique);
}
 

int yywrap()
{
  return(1);
}
