%{
	#include <stdio.h>
%}
%right ASSIGNOP
%left AND OR
%left PLUS MINUS
%left STAR DIV
%left RELOP
%token NOT
%token LB RB LP RP
%token DOT 
%token COMMA SEMI
%token INT FLOAT ID STRUCT TYPE
%token RETURN IF ELSE WHILE LC RC

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%
ExProgram : ExtDefList
	;
ExtDefList : ExtDef ExtDefList
	| /* empty */
	;
ExtDef : Specifier ExtDecList SEMI
	| Specifier SEMI
	|Specifier FunDec CompSt
	;
ExtDecList : VarDec
	| VarDec COMMA ExtDecList
	;
Exp : Exp ASSIGNOP Exp 
    | Exp AND Exp { $$ = $1 && $3; }
    | Exp OR Exp { $$ = $1 || $3; } 
    | Exp RELOP Exp 
    | Exp PLUS Exp  { $$ = $1 + $3; }
    | Exp MINUS Exp { $$ = $1 - $3; }
    | Exp STAR Exp { $$ = $1 * $3; }
    | Exp DIV Exp { $$ = $1 / $3; }
    | LP Exp RP
    | MINUS Exp
    | NOT Exp
    | ID LP Args RP
    | ID LP RP
    | Exp LB Exp RB
    | Exp DOT ID
    | ID
    | INT
    | FLOAT
    ;
Args : Exp COMMA Args
    | Exp
    ;
DefList : /* empty */
	| Def DefList
	;
Def : Specifier DecList SEMI
	;
DecList : Dec
	| Dec COMMA DecList
	;
Dec : VarDec
	| VarDec ASSIGNOP Exp
	;
CompSt : LC DefList StmtList RC
	;
StmtList : /* empty */
	| Stmt StmtList
	;
Stmt : Exp SEMI
	| CompSt
	| RETURN Exp SEMI
	| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
	| IF LP Exp RP Stmt ELSE Stmt
	| WHILE LP Exp RP Stmt
	;
VarDec : ID
	| VarDec LB INT RB
	;
FunDec : ID LP VarList RP
	| ID LP RP
	;
VarList : ParamDec COMMA VarList
	| ParamDec
	;
ParamDec : Specifier VarDec
	;
Specifier : TYPE
	| StructSpecifier
	;
StructSpecifier : STRUCT OptTag LC DefList RC
	| STRUCT Tag
	;
OptTag : ID
	| /* empty */
	;
Tag : ID
	;
%%
#include "lex.yy.c"
int main(){
	if(argc <= 1) return 1;
  	FILE* f = fopen(argv[1], "r");
  	if(!f)
  	{
    		perror(argv[1]);
    		return 1;
  	}
	yyrestart(f);
	yyparse();
	return 0;
}
yyerror(char *msg)
{
	fprintf(stderr,"error:%s\n",msg);
}
