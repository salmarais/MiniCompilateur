  /* Table de Hashage */
  typedef struct symbol{
    char* sym_name;
    int sym_type; // 0: integer; 1: procedure
    int test_init;
    int test_use;
    int nbr_args;
    struct symbol *sous_liste;
  } symbol;
  

  #define TAILLE_INITIALE_DICO 50
  #define INCREMENT_TAILLE_DICO 25

void debug(const char *message);
void debugInt(const char *message, int num);
void fatalError(const char *message);
void semanticError(const char *message, int nbrligne);


void createDico();
void resizeDico();
void addSymbol(const char *sym_name, int sym_type, int nbr_args);
int getSymbol(const char *sym_name);
int exists(const char *ident, int type, int inf, int sup, int *ptrPosition);
int initSymbol(const char *ident, int nbligne);

// 1. Vérifier qu’une variable n’est déclarée qu’une seule fois
int checkIfIdentifierIsDeclaredOneTime(const char* ident, int type, int nbligne, int *ptr_position);
// 2. Vérifier qu’une variable utilisée est déclarée
void checkIfIdentifierIsDeclared(const char* ident, int type, int nbligne);
// 3. Vérifier si les variables utilisées sont initialisées
void checkIfVariableIsInitialized(const char* ident, int type, int nbligne);
// 4. Vérifier si les variables déclarées sont utilisées
void checkIfVariableIsUsed(const char* ident, int type, int nbligne);
// 5. Vérifier l’appel des procédures avec les bons arguments
int checkNbrOfArguments(const char* ident, int type, int nbligne);


int listAll();