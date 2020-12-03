%{
	#include <stdio.h>
%}

%union{
    int type_int;
    float type_float;
}
%token <type_int> INT
%token <type_float> FLOAT

%%
Exp     : Exp ASSIGNOP Exp  {$$=$1;}
	| Exp AND Exp   {$$=$1 && $2;}
	| Exp OR Exp    {$$=$1 || $2;}
	| Exp RELOP Exp
        | Exp PLUS Exp  {$$=$1+$2;}
        | Exp MINUS Exp     {$$=$1-$2;}
        | Exp STAR Exp  {$$=$1*$2;}
        | Exp DIV Exp   {$$=$1/$2;}
        | LP Exp RP
        | MINUS Exp {$$=-1*$1;}
	| NOT Exp       {$$=!$1;}
        | ID LP Args RP
        | ID LP RP
        | Exp LB Exp RB
        | Exp DOT ID
        | ID
        | INT   {$$=$1;}
        | FLOAT     {$$=$1;}
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
%%
#include "lex.yy.c"
int main(){
	yyparse();
}
yyerror(char *msg)
{
	fprintf(stderr,"error:%s\n",msg);
}
