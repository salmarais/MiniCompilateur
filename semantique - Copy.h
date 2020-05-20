
  /* Table de Hashage */
  typedef struct {
    char* sym_name;
    int sym_type; // 0: integer; 1: procedure
    int test_init;
    int test_use;
    int nbr_args;
    struct symbol *sous_liste;
  } symbol;
  

  #define TAILLE_INITIALE_DICO 50
  #define INCREMENT_TAILLE_DICO 25

  


// Initialisation des méthodes

void createDico();
void resizeDico();
void fatalError(char *message);
void semanticError(char *message, int nbrligne);
void addSymbol(char *sym_name, int sym_type, int sym_nbrarg);
int getSymbol(char *sym_name);
void initSymbol(char *sym_name);
void useSymbol(char *sym_name);
int exists(char *identif, int type, int inf, int sup, int *ptrPosition);


// 1. Vérifier qu’une variable n’est déclarée qu’une seule fois
int checkIfIdentifierIsDeclaredOneTime(char* ident, int type, int nbligne, int *ptr_position);
// 2. Vérifier qu’une variable utilisée est déclarée
int checkIfIdentifierIsDeclared(char* ident, int type, int nbligne);
// 3. Vérifier si les variables utilisées sont initialisées
int checkIfVariableIsInitialized(char* ident, int type, int nbligne);
// 4. Vérifier si les variables déclarées sont utilisées
int checkIfVariableIsUsed(char* ident, int type, int nbligne);
// 5. Vérifier l’appel des procédures avec les bons arguments
int checkNbrOfArguments(char* ident, int type, int nbligne);
