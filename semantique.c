
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "semantique.h"



#define TAILLE_INITIALE_DICO 50
#define INCREMENT_TAILLE_DICO 25

  
symbol *dico;
int maxDico, sommet = 0, base = 0;
int error_semantique = 0;

// Console logs

void fatalError(const char *message) {
  fprintf(stderr, "%s\n", message);
  exit(-1);
}

void debug(const char *message) {
  fprintf(stderr, "/** : %s **/\n", message);
}

void debugInt(const char *message, int num) {
  fprintf(stderr, "/** : %s : %d**/\n", message, num);
}


void semanticError(const char *message, int nbrligne) {
  fprintf(stderr, "%s .Erreur ligne: %d\n", message, nbrligne); 
  error_semantique++;
}

// Implémentation des méthodes

void createDico() {
  maxDico = TAILLE_INITIALE_DICO;
  dico = malloc(maxDico * sizeof(symbol));
  if (dico == NULL)
    fatalError("Erreur interne: pas assez de memoire");

}

void resizeDico() {
  maxDico = maxDico + INCREMENT_TAILLE_DICO;
  dico = realloc(dico, maxDico);
  if(dico == NULL)
    fatalError("Erreur interne: pas assez de memoire");
}




void addSymbol(const char *sym_name, int sym_type, int nbr_args) {
  if (dico == NULL) 
  {
    createDico();
  }
  int placement = 0;

   if (exists(sym_name, sym_type, base, sommet-1, &placement))
    fatalError("Identificateur déja déclarée");


   if (sommet >= maxDico)
      resizeDico();


    dico[sommet].sym_name = malloc(strlen(sym_name) + 1);
    if (dico[sommet].sym_name == NULL)
        fatalError("Erreur interne (pas assez de mémoire)");

    strcpy(dico[sommet].sym_name, sym_name);
    dico[sommet].sym_type = sym_type;  
    dico[sommet].test_init = 0; 
    dico[sommet].test_use = 0;  

    sommet++; 
}

int getSymbol(const char *sym_name) {
  int i = base, j = sommet-1, k;

  while (i <= j) {      /* invariant: i <= position <= j + 1 */
      k = (i + j) / 2;
      if (strcmp(dico[k].sym_name, sym_name) < 0)
        i = k + 1;
      else
        j = k - 1;
  }
   /* ici, de plus, i > j, soit i = j + 1 */
    if(i <= (sommet-1) && strcmp(dico[i].sym_name, sym_name) == 0) 
     return i;

}

int exists(const char *ident, int type, int inf, int sup, int *ptrPosition) {
  int i, j, k;
    i = inf;
    j = sup;
    for(k=i; k<=sup;k++) {
      if (strcmp(dico[k].sym_name, ident) ==  0 && dico[k].sym_type == type) {
        *ptrPosition = k;
        return 1;
      }
    }
    return 0;
}


int initSymbol(const char *ident, int nbligne) {
  int position = 0;
  if(exists(ident, 0, base, sommet, &position)) {
    dico[position].test_init = 1;
  } else {
    semanticError("Ident not declared (is)", nbligne);
  }
}






// 1. Vérifier qu’une variable n’est déclarée qu’une seule fois
int checkIfIdentifierIsDeclaredOneTime(const char* ident, int type, int nbligne, int *ptr_position){
  int position = 0;
  int found = 0;
  while(position <= sommet) {  
    if(exists(ident, type, position, sommet-1, &position)) {
      found++;
    }
    position++;
  }

  if(found == 1)
    *ptr_position = position;
  
  return found;

}

// 2. Vérifier qu’une variable utilisée est déclarée
void checkIfIdentifierIsDeclared(const char* ident, int type, int nbligne){
  int position;
  int found =  checkIfIdentifierIsDeclaredOneTime(ident, type, nbligne, &position);
  //debugInt("Declared one Time ", found);
  if(found == 0)
    semanticError("Var non déclarée ligne : ", nbligne);
}

// 3. Vérifier si les variables utilisées sont initialisées
void checkIfVariableIsInitialized(const char* ident, int type, int nbligne){

  int position;
  int found =  exists(ident,type, base,sommet-1, &position);
  if(found == 0) {
    semanticError("Ident not declared (ii)", nbligne);
  } else if (!(found > 0 && dico[position].test_init == 1)) {
    semanticError("Ident not initialized (ii)", nbligne);
  }
}

// 4. Vérifier si les variables déclarées sont utilisées
void checkIfVariableIsUsed(const char* ident, int type, int nbligne){
 int position;
 int found =  exists(ident,type, base,sommet-1, &position);
 if(!(found > 0 && dico[position].test_use == 1))
    semanticError("Ident not initialized in ligne ", nbligne);
}


// 5. Vérifier l’appel des procédures avec les bons arguments
int checkNbrOfArguments(const char* ident, int type, int nbligne){
  return 1;
}


int listAll() {
  int i=0;
  for (i; i<=sommet; i++)
    fprintf(stderr, "List All : %d : sym_name %s : initialized? : %d\n", i, dico[i].sym_name, dico[i].test_init);
  return 0;
}


