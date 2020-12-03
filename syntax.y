%{
	#include <stdio.h>
%}



%%
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
	| IF LP Exp RP Stmt
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
Program : ExtDefList
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
Exp 	: Exp ASSIGNOP Exp
    	| Exp AND Exp
    	| Exp OR Exp
    	| Exp RELOP Exp
    	| Exp PLUS Exp
    	| Exp MINUS Exp
    	| Exp STAR Exp
    	| Exp DIV Exp
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
Args 	: Exp COMMA Args
    	| Exp
    	;

%%
#include "lex.yy.c"
int main(){
	yyparse();
}
yyerror(char *msg)
{
	fprintf(stderr,"error:%s\n",msg);
}
