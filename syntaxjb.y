%{
	#include <stdio.h>
	#include<unistd.h>
	#include "gramtree.h"
	#define YYERROR_VERBOSE
	//#include "lex.yy.c"
%}
%union
{
	struct gramtree* newfather;
	double d;
}
%token <newfather> INT FLOAT 
%token <newfather> ID STRUCT TYPE RETURN IF ELSE WHILE SPACE COMMA SEMI ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR NOT LB RB LP RP LC RC ERROR DOT
%type <newfather> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier OptTag Tag VarDec FunDec VarList ParamDec CompSt StmtList Stmt DefList Def DecList Dec Exp Args
%nonassoc error
%right ASSIGNOP
%left AND OR
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LB RB LP RP LC RC
%left DOT
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%
Program : ExtDefList {$$=gramTree("Program",1,$1);printf("\n");circulate($$,0);}
	;
ExtDefList : ExtDef ExtDefList{$$=gramTree("ExtDefList",2,$1,$2);}
	| {$$=gramTree("ExtDefList",0,-1);}
	;
ExtDef : Specifier ExtDecList SEMI{$$=gramTree("ExtDef",3,$1,$2,$3);} 
	| Specifier SEMI{$$=gramTree("ExtDef",2,$1,$2);}
|error SEMI {printf("error1 at line: %d\n",$2->lineno);$$=gramTree("ExtDef",1,$2);}
|Specifier FunDec CompSt {printf("ExtDef->Specifier FunDec CompSt at %d\n",$3->lineno); $$=gramTree("ExtDef",3,$1,$2,$3);}

	;
ExtDecList : VarDec{$$=gramTree("ExtDecList",1,$1);}
	| VarDec COMMA ExtDecList{$$=gramTree("ExtDecList",3,$1,$2,$3);}
	;
Specifier : TYPE {$$=gramTree("Specifier",1,$1);}
	| StructSpecifier {$$=gramTree("Specifier",1,$1);}
	;
StructSpecifier : STRUCT OptTag LC DefList RC{$$=gramTree("StructSpecifier",5,$1,$2,$3,$4,$5);}
| error RC {printf("error2 at line: %d\n",$2->lineno);$$=gramTree("StructSpecifier",1,$2);}
| STRUCT Tag{$$=gramTree("StructSpecifier",2,$1,$2);}
	;
OptTag : ID{$$=gramTree("OptTag",1,$1);}
	| {$$=gramTree("OptTag",0,-1);}
	;
Tag : ID{$$=gramTree("Tag",1,$1);}
	;
VarDec : ID{$$=gramTree("VarDec",1,$1);}
	| VarDec LB INT RB{printf("VarDec->VarDec LB INT RB\n");$$=gramTree("VarDec",4,$1,$2,$3,$4);}
| error RB{printf("error3 at line: %d\n",$2->lineno);$$=gramTree("VarDec",1,$2);}
	;
FunDec : ID LP VarList RP{$$=gramTree("FunDec",4,$1,$2,$3,$4);}
	| ID LP RP{$$=gramTree("FunDec",3,$1,$2,$3);}
| error RP{printf("error4 at line: %d\n",$2->lineno);$$=gramTree("FunDec",1,$2);}	
;
VarList : ParamDec COMMA VarList  {$$=gramTree("VarList",3,$1,$2,$3);}
	| ParamDec {$$=gramTree("VarList",1,$1);}
	;
ParamDec : Specifier VarDec{printf("ParamDec-> Specifier VarDec\n");$$=gramTree("ParamDec",2,$1,$2);}
	;
CompSt : LC DefList StmtList RC{$$=gramTree("Compst",4,$1,$2,$3,$4);}
       | error RC {printf("error5 at line: %d\n",$2->lineno);$$=gramTree("CompSt",1,$2);}
;
StmtList : {$$=gramTree("StmtList",0,-1);}
	| Stmt StmtList{$$=gramTree("StmtList",2,$1,$2);}
	;
Stmt : Exp SEMI {$$=gramTree("Stmt",2,$1,$2);}
	| CompSt {$$=gramTree("Stmt",1,$1);}
	|RETURN Exp SEMI {$$=gramTree("Stmt",3,$1,$2,$3);}
	|IF LP Exp RP Stmt {$$=gramTree("Stmt",5,$1,$2,$3,$4,$5);}
	|IF LP Exp RP Stmt ELSE Stmt {$$=gramTree("Stmt",7,$1,$2,$3,$4,$5,$6,$7);}
	|WHILE LP Exp RP Stmt {$$=gramTree("Stmt",5,$1,$2,$3,$4,$5);}
| error SEMI {printf("error6 at line: %d\n",$2->lineno);$$=gramTree("Stmt",1,$2);}
;
DefList : Def DefList{$$=gramTree("DefList",2,$1,$2);}
	| {$$=gramTree("DefList",0,-1);}
	;
Def : Specifier DecList SEMI {$$=gramTree("Def",3,$1,$2,$3);}
| error SEMI {printf("error7 at line: %d\n",$2->lineno);$$=gramTree("Def",1,$2);}
;
DecList : Dec {$$=gramTree("DecList",1,$1);}
	|Dec COMMA DecList {$$=gramTree("DecList",3,$1,$2,$3);}
	;
Dec : VarDec {$$=gramTree("Dec",1,$1);}
	|VarDec ASSIGNOP Exp {$$=gramTree("Dec",3,$1,$2,$3);}
	;
Exp : Exp ASSIGNOP Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp AND Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp OR Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp RELOP Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp PLUS Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp MINUS Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp STAR Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp DIV Exp{$$=gramTree("Exp",3,$1,$2,$3);}
        |LP Exp RP{$$=gramTree("Exp",3,$1,$2,$3);}
        |MINUS Exp {$$=gramTree("Exp",2,$1,$2);}
        |NOT Exp {$$=gramTree("Exp",2,$1,$2);}
        |ID LP Args RP {$$=gramTree("Exp",4,$1,$2,$3,$4);}
        |ID LP RP {$$=gramTree("Exp",3,$1,$2,$3);}
        |Exp LB Exp RB {$$=gramTree("Exp",4,$1,$2,$3,$4);}
        |Exp DOT ID {$$=gramTree("Exp",3,$1,$2,$3);}
        |ID {$$=gramTree("Exp",1,$1);}
        |INT {$$=gramTree("Exp",1,$1);}
        |FLOAT{$$=gramTree("Exp",1,$1);}
| error RB {printf("error8 at line: %d\n",$2->lineno);$$=gramTree("Exp",1,$2);}
| error RP {printf("error9 at line: %d\n",$2->lineno);$$=gramTree("Exp",1,$2);}        
;
Args : Exp COMMA Args {$$=gramTree("Args",3,$1,$2,$3);}
        |Exp {$$=gramTree("Args",1,$1);}
        ;
%%

int main(int argc,char** argv){
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


/*
yyerror(char *msg)
{
	fprintf(stderr,"error:%s\n",msg);
}*/

