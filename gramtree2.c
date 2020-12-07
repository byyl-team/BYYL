#include<stdio.h>
#include<stdlib.h>
#include<stdarg.h>
#include<string.h>
#include"gramtree.h"
#define YYERROR_VERBOSE
struct gramtree *gramTree(char* name,int num,...)
{
	va_list valist;//定义变长参数列表
	struct gramtree *newfather=(struct gramtree *)malloc(sizeof(struct gramtree));//新生成的父节点
	struct gramtree *temp=(struct gramtree*)malloc(sizeof(struct gramtree));
	if(!newfather)
	{
		yyerror("out of space!");
		exit(0);
	}
	newfather->name=name;
	va_start(valist,num);//初始化变长参数为num后的参数
	if(num>0)//num>0为非终结符：变长参数均为语法树结点，孩子兄弟表示法
    	{
        	temp=va_arg(valist, struct gramtree*);//取变长参数列表中的第一个结点设为左孩子
        	newfather->leftchild=temp;
        	newfather->lineno=temp->lineno;//父节点的行号等于左孩子的行号

        	if(num>=2) //可以规约到a的语法单元>=2
        	{
			int i;
            		for(i=0; i<num-1; ++i)//取变长参数列表中的剩余结点，依次设置成兄弟结点
            		{
                		temp->rightchild=va_arg(valist,struct gramtree*);
                		temp=temp->rightchild;
            		}
        	}
    	}
    	else //num==0为终结符或产生空的语法单元：第1个变长参数表示行号，产生空的语法单元行号为-1。
    	{
        	int t=va_arg(valist, int); //取第1个变长参数
        	newfather->lineno=t;
        	if((!strcmp(newfather->name,"ID"))||(!strcmp(newfather->name,"TYPE")))//"ID,TYPE,INTEGER，借助union保存yytext的值
        	{
        		char*t;
        		t=(char*)malloc(sizeof(char* )*40);
        		strcpy(t,yytext);
        		newfather->IDTYPE=t;
        	}
        	else if(!strcmp(newfather->name,"INT")) {newfather->INT=atoi(yytext);}
        	else {}
    	}
    	return newfather;
}
void circulate(struct gramtree* newfather,int level)
{
	if(newfather!=NULL)
    	{
		int i;
        	for(i=0; i<level; ++i)//孩子结点相对父节点缩进2个空格
            		printf("  ");
        	if(newfather->lineno!=-1){ //产生空的语法单元不需要打印信息
            		printf("%s ",newfather->name);//打印语法单元名字，ID/TYPE/INTEGER要打印yytext的值
            		if((!strcmp(newfather->name,"ID"))||(!strcmp(newfather->name,"TYPE")))printf(":%s ",newfather->IDTYPE);
            	else if(!strcmp(newfather->name,"INT"))printf(":%d",newfather->INT);
            	else
                	printf("(%d)",newfather->lineno);
        }
        printf("\n");

        circulate(newfather->leftchild,level+1);//遍历左子树
        circulate(newfather->rightchild,level);//遍历右子树
    }
}

void yyerror(char*s,...) //变长参数错误处理函数
{
    va_list ap;
    va_start(ap,s);
    fprintf(stderr,"%d:error:",yylineno);//错误行号
    vfprintf(stderr,s,ap);
    fprintf(stderr,"\n");
}
/*int main()
{
    printf(">");
    return yyparse(); //启动文法分析，调用词法分析
}*/
