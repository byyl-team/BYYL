%{
	
	
	#include <stdlib.h>
	#include <stdio.h>
	#include<string.h>
	#include<regex.h>
	#include"syntax.tab.h"
	FILE* f;
	int column = 1;  //记录该行第几个字符
	char n = '\n';   
	char* nad=NULL;  //注释中换行符的位置

%}
%option yylineno
COMMENTM \/\*([^\*]*(\*)+[^\*\/])*[^\*]*\*+\/
COMMENTS \/\/.*
SPACE [ \t\f\r]+
SPACEN \n+
INT 0|[1-9][0-9]*
INT16 0[xX][a-fA-F0-9]+
INT8 0[1-7][0-7]*
FLOAT (([0-9]+\.[0-9]+)([e|E][\+-]?[0-9]+)?)|(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))[e|E][\+-]?[0-9]+
FLOAT_ERROR ([0-9]+\.[0-9]*|[0-9]*\.[0-9]+|[0-9]*)((e|E)[\+-]?([0-9]+\.[0-9]*|[0-9]*\.[0-9]+|[0-9]*))?
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
TYPE int|float
SEMI ;
COMMA ,
PLUS \+
ASSIGNOP =
MINUS -
STAR \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT !
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
RELOP >|<|>=|<=|==|\!=
ID [a-z_A-Z][a-z_A-Z0-9]*
INT16_ERROR 0[xX][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
INT8_ERROR 0[0-7]*[89]+[0-7]*
IDERROR [a-zA-Z_][a-zA-Z0-9_]*[^ \n\t\f\r\p{Z}]*
%%
{COMMENTM} {
    printf("NOTE at line %d char %d:%s \n",yylineno,column,yytext);  //多行注释
    column = (nad = strrchr(yytext,n))==NULL?(column+yyleng):(yyleng-(nad-yytext)); //根据多行注释最后换行符的位置，更新当前的列指针
}
{COMMENTS} {
    printf("NOTE at line %d char %d:%s \n",yylineno,column,yytext);  //单行注释
    column+=yyleng;
}
{SPACE} {
    // printf("space at line %d char %d:%s!\n",yylineno,column,yytext);
    column+=yyleng;
}
{SPACEN} {
    column = 1;  //出现换行符，列指针回到开头
}
{INT} {
	//printf("INT data at line %d char %d: %s\n",yylineno,column,yytext);
	column+=yyleng;
	yylval = atoi(yytext);
	return INT;
	
}
	
{INT16} {
	//printf("INT16 at line %d char %d: charachters \"%s\"\n",yylineno,column,yytext);
	column+=yyleng;
	yylval = strtol(yytext,NULL,16);
	return INT;
}
{INT8} {
    //printf("INT8 at line %d char %d: charachters \"%s\"\n",yylineno,column,yytext);
    column+=yyleng;
    yylval = strtol(yytext,NULL,8);
    return INT;
}
{INT16_ERROR} {
    //printf("ERROR Type A at line %d char %d:Illgal INT16 number \"%s\"\n",yylineno,column,yytext);
    column+=yyleng;
    yylval = strtol(yytext,NULL,16);
    return ERROR;
}
{INT8_ERROR} {
    //printf("ERROR Type A at line %d char %d: Illgal INT8 number \"%s\"\n",yylineno,column,yytext);
    column+=yyleng;
    yylval = strtol(yytext,NULL,8);
    return ERROR;
}
{STRUCT} {
    column+=yyleng;
    return STRUCT;
}
{RETURN} {
    column+=yyleng;
    return RETURN;
}
{IF} {
    column+=yyleng;
    return IF;
}
{ELSE} {
    column+=yyleng;
    return ELSE;
}
{WHILE} { 
    //printf("KEYWORD at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return WHILE;
}
{TYPE} { 
    //printf("TYPE at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return TYPE;
}
{ID} {
    //printf("ID at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    yylval = strdup(yytext);
    return ID;
}
{PLUS} { 
    //printf("PLUS at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return PLUS;
}
{SEMI} { 
    //printf("SEMI at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return SEMI;
}
{COMMA} { 
    //printf("COMMA at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return COMMA;
}
{ASSIGNOP} { 
    //printf("ASSIGNOP at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return ASSIGNOP;
}
{MINUS} { 
    //printf("MINUS at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return MINUS;
}
{STAR} {
    //printf("STAR at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return STAR;
}
{DIV} { 
    //printf("DIV at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return DIV;
}
{AND} { 
    //printf("AND at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return AND;
}
{OR} { 
    //printf("OR at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return OR;
}
{DOT} { 
    //printf("DOT at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return DOT;
}
{NOT} { 
    //printf("NOT at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return NOT;
}
{LP} { 
    //printf("LP at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return LP;
}
{RP} { 
    //printf("RP at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return RP;
}
{LB} { 
    //printf("LB at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return LB;
}
{RB} { 
    //printf("RB at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return RB;
}
{LC} { 
    //printf("LC at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return LC;
}
{RC} { 
    //printf("RC at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return RC;
}
{RELOP} { 
    //printf("RELOP at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
    return RELOP;
}
{FLOAT} {
    //printf("FLOAT at line %d char %d:%s\n",yylineno,column,yytext);
    column+=yyleng;
    yylval = atof(yytext);
    return FLOAT;
}
{FLOAT_ERROR} {
    //printf("Error Type A at line %d,char %d:  Illgal float number: \"%s\"\n",yylineno,column,yytext);
    column+=yyleng;
    return ERROR;
}
. { 
    //printf("UNDEFINED at line %d char %d: %s\n",yylineno,column,yytext);
    column+=yyleng;
}
%% 
/*int main(int argc, char* argv[])
{
    if (argc > 1){
        if(!(yyin = fopen(argv[1], "r"))){
            perror(argv[1]);
            return 1;
        }
        while (yylex() != 0);
    }
    return 0;
}*/
