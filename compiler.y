/*YACC Parser Generator code */

/*YACC definitions*/

%token<ival> INT FLOAT VOID	/* token types coming from the lexical analysis*/
%token<str> ID NUM REAL LESSEQ GRTEQ EQUAL NOTEQ AND OR
%token WHILE IF RETURN PREPROC STRING PRINT FUNCTION DO ARRAY ELSE STRUCT STRUCT_VAR FOR
%left LESSEQ GRTEQ EQUAL NOTEQ AND OR '<' '>'		/* Left associativity given to these operators*/
%left '+' '-'
%left '*' '/' 
%right '='		/* Right  associativity given to these operators*/
%right UMINUS 
%type<str> assignment assignment1 consttype '=' '+' '-' '*' '/' E T F 
%type<ival> Type	
%union {			/*So the lexical analyser can return tokens of different types*/
		int ival;
		char *str;
	}

/* Definitions*/

%{
#include <stdlib.h>
#include <stdio.h>
#include "compiler.c"      /*compiler.c file is included*/ 

char temp[2]="t";
int g_addr = 100;
char i1[2]="0";
char st1[100][10];
int i=1, count1=0, label1[20], ltop1;
int store[100], ind1=0, end[100], arr[10], vargl1, vargl2, varct, c,b,fl,top=0,label[20],count=0;
int ltop=0;
void yyerror( char *s );

/* Functions declaration*/
/*void str_change(int temp[0], int i1){
temp[0]="t";
	strcat(temp,i1);
}*/

/* for counting the open parenthesis*/
void open_paraenthesis(){
	store[ind1++]=i;
	i=i+1;
}

/* for counting the close parenthesis*/
void close_paraenthesis(){
end[store[--ind1]]=1;
	store[ind1]=0;
}

void funcif_1(){
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = not %s\n",temp,st1[top]);  
 	printf("if %s goto L%d\n",temp,++count);  
	i1[0]++;
	label[++ltop]=count;	
}

void funcif_2(){
	printf("goto L%d\n",++count);  
	printf("L%d: \n",label[ltop--]);
	label[++ltop]=count;     
}

void funcif_3(){
	printf("L%d:\n",label[ltop--]);   
}

void word1(){
	label[++ltop]=++count;
	printf("L%d:\n",count);
}

void word2(){
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = not %s\n",temp,st1[top--]);  
 	printf("if %s goto L%d\n",temp,++count);
	i1[0]++;
	label[++ltop]=count;
}

void word3(){
	int y=label[ltop--];
	printf("goto L%d\n",label[ltop--]);
	printf("L%d:\n",y);
}

void funcDw1(){
	label[++ltop]=++count;
	printf("L%d:\n",count);
}

void funcDw2(){
 	printf("if %s goto L%d\n",st1[top--],label[ltop--]);
}

void func1(){
	label[++ltop]=++count;
	printf("L%d:\n",count);
}

void func2(){
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = not %s\n",temp,st1[top--]);
 	printf("if %s goto L%d\n",temp,++count);
	i1[0]++;
	label[++ltop]=count;
	printf("goto L%d\n",++count);
	label[++ltop]=count;
	printf("L%d:\n",++count);	
	label[++ltop]=count;
}

void func3(){
	printf("goto L%d\n",label[ltop-3]);
	printf("L%d:\n",label[ltop-1]);
}

void func4(){
	printf("goto L%d\n",label[ltop]);
	printf("L%d:\n",label[ltop-2]);
	ltop-=4;
}

void push(char *a){
	strcpy(st1[++top],a);
}

/* Defining functions for array*/

void arrayFunc1(){
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = %s * 4\n",temp,st1[top]);        
	strcpy(st1[top],temp);
	i1[0]++;
	strcpy(temp,"t");
	strcat(temp,i1);
	printf("%s = %s [ %s ] \n",temp,st1[top-1],st1[top]);
	top--;
	strcpy(st1[top],temp);
	i1[0]++;	
}

/* functions for intermediate code generator */

void code_generate()
{
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = %s %s %s\n",temp,st1[top-2],st1[top-1],st1[top]);   
	top-=2;
	strcpy(st1[top],temp);   
	i1[0]++;
}

void codegenerate_umin(){
	/*str_change(temp[0],i1);*/
	temp[0]="t";
	strcat(temp,i1);
	printf("%s = -%s\n",temp,st1[top]);  
	top--;
	strcpy(st1[top],temp);      
	i1[0]++;
}

void codegenerate_assign(){
	printf("%s = %s\n",st1[top-2],st1[top]);     
	top-=2;
}
%}

/* Production Rules (CFG) */

%%

start : Function start 
	| PREPROC start 
	| Declaration start
	| 
	;

Function : Type ID '('')'  CompoundStmt {
	if(strcmp($2,"main")!=0){
		printf("goto F%d\n",count1);
	}
	if ($1!=RetType(varct)){
		/*printf("\nError : Type mismatch : Line %d\n",line);*/
	}



	if (!(strcmp($2,"printf") && strcmp($2,"scanf") && strcmp($2,"getc") && strcmp($2,"gets") && strcmp($2,"getchar") && strcmp	($2,"puts") && strcmp($2,"putchar") && strcmp($2,"clearerr") && strcmp($2,"getw") && strcmp($2,"putw") && strcmp($2,"putc") && strcmp($2,"rewind") && strcmp($2,"sprint") && strcmp($2,"sscanf") && strcmp($2,"remove") && strcmp($2,"fflush"))) 
		printf("Error : Type mismatch in redeclaration of %s : Line %d\n",$2,line); 
	else{ 
		funcInsertSymbol($2,FUNCTION,g_addr); 
		funcInsertSymbol($2,$1,g_addr); 
		g_addr+=4;
	}
	}
	;

Type : INT
	| FLOAT
	| VOID
	;

CompoundStmt : '{' StmtList '}'
	;

StmtList : StmtList stmt 
	| 
	;

stmt : Declaration
	| if 
	| ID '(' ')' ';' 
	| while 
	| dowhile 
	| for 
	| RETURN consttype ';' {
					if(!(strspn($2,"0123456789")==strlen($2))) 
						ReturnTypeStorer(varct,FLOAT); 
					else 
						ReturnTypeStorer(varct,INT); varct++;
					} 
	| RETURN ';' {ReturnTypeStorer(varct,VOID); varct++;} 
	| ';'
	| PRINT '(' STRING ')' ';' 
	| CompoundStmt 
	;

dowhile : DO {funcDw1();} CompoundStmt WHILE '(' E ')' {funcDw2();} ';'
	;

for	: FOR '(' E {func1();} ';' E {func2();}';' E {func3();} ')' CompoundStmt {func4();}
	;

if : 	 IF '(' E ')' {funcif_1();} CompoundStmt {funcif_2();} else
	;

else : ELSE CompoundStmt {funcif_3();}
	| 
	;

while : WHILE {word1();}'(' E ')' {word2();} CompoundStmt {word3();}
	;

assignment : ID '=' consttype 
	| ID '+' assignment 
	| ID ',' assignment
	| consttype ',' assignment
	| ID
	| consttype
	;

assignment1 : ID {push($1);} '=' {strcpy(st1[++top],"=");} E {codegenerate_assign();}  {
		int sct=scope_returner($1,store[ind1-1]); 
		int type=funcRetType($1,sct); 
		if((!(strspn($5,"0123456789")==strlen($5))) && type==258 && fl==0) 
			printf("\nError : Type Mismatch : Line %d\n",line); 
		if(!func_lookup($1)){ 
			int currscope=store[ind1-1]; 
			int scope=scope_returner($1,currscope); 
			if((scope<=currscope && end[scope]==0) && !(scope==0)){
				ScopeUpdatecheckFunc($1,$5,currscope);
			}
		} 
		}

	| ID ',' assignment1 {
					if(func_lookup($1)) 
						printf("\nUndeclared Variable %s : Line %d\n",$1,line);
				}
	| consttype ',' assignment1   
	| ID  {
		if(func_lookup($1)) 
			printf("\nUndeclared Variable %s : Line %d\n",$1,line);
		}
	| consttype
	;

consttype : NUM
	| REAL
	;

Declaration : Type ID {push($2);} '=' {strcpy(st1[++top],"=");} E {codegenerate_assign();} ';'  
	{
		if( (!(strspn($6,"0123456789")==strlen($6))) && $1==258 && (fl==0)) 
		{
			printf("\nError : Type Mismatch : Line %d\n",line);
			fl=1;
		} 
		if(!func_lookup($2)){
			int currscope = store[ind1-1]; 
			int previous_scope = scope_returner($2,currscope); 
			if(currscope == previous_scope) 
				printf("\nError : Redeclaration of %s : Line %d\n",$2,line); 
			else{
				duplicateSymbolInsertFunc($2,$1,g_addr,currscope);
				ScopeUpdatecheckFunc($2,$6,store[ind1-1]);
				int sg=scope_returner($2,store[ind1-1]); 
				g_addr+=4;
			}
		} 
		else{ 
			int scope=store[ind1-1];  
			funcInsertSymbol($2,$1,g_addr); 
			insrttokenScope($2,scope); 
			ScopeUpdatecheckFunc($2,$6,store[ind1-1]);
			g_addr+=4;
		}
	}

	| assignment1 ';'  {
				if(!func_lookup($1)){ 
					int currscope=store[ind1-1]; 
					int scope=scope_returner($1,currscope); 
					if(!(scope<=currscope && end[scope]==0) || scope==0) 
						printf("\nError : Variable %s out of scope : Line %d\n",$1,line);
				} 
				else 
					printf("\nError : Undeclared Variable %s : Line %d\n",$1,line); 
				}

	| Type ID '[' assignment ']' ';' {
						funcInsertSymbol($2,ARRAY,g_addr); 
						funcInsertSymbol($2,$1,g_addr); 
						g_addr+=4; 
					}
	| ID '[' assignment1 ']' ';'
	| STRUCT ID '{' Declaration '}' ';' {
						funcInsertSymbol($2,STRUCT,g_addr); 
						g_addr+=4; 
						}
	| STRUCT ID ID ';' {
				funcInsertSymbol($3,STRUCT_VAR,g_addr); 
				g_addr+=4;
				}
	| error
	;

array : ID {push($1);}'[' E ']'
	;
/* $1,$2,etc reference RHS of the rule */
/* $$ references LHS of the rule*/

E : E '+'{strcpy(st1[++top],"+");} T{code_generate();}
   | E '-'{strcpy(st1[++top],"-");} T{code_generate();}
   | T
   | ID {push($1);} LESSEQ {strcpy(st1[++top],"<=");} E {code_generate();}	/* Here $1 is E */
   | ID {push($1);} GRTEQ {strcpy(st1[++top],">=");} E {code_generate();}
   | ID {push($1);} EQUAL {strcpy(st1[++top],"==");} E {code_generate();}
   | ID {push($1);} NOTEQ {strcpy(st1[++top],"!=");} E {code_generate();}
   | ID {push($1);} AND {strcpy(st1[++top],"&&");} E {code_generate();}
   | ID {push($1);} OR {strcpy(st1[++top],"||");} E {code_generate();}
   | ID {push($1);} '<' {strcpy(st1[++top],"<");} E {code_generate();}
   | ID {push($1);} '>' {strcpy(st1[++top],">");} E {code_generate();}
   | ID {push($1);} '=' {strcpy(st1[++top],"||");} E {codegenerate_assign();}
   | array {arrayFunc1();}
   ;
T : T '*'{strcpy(st1[++top],"*");} F{code_generate();}
   | T '/'{strcpy(st1[++top],"/");} F{code_generate();}
   | F
   ;
F : '(' E ')' {$$=$2;}		/* Here $$ is F and $2 is E */
   | '-'{strcpy(st1[++top],"-");} F{codegenerate_umin();} %prec UMINUS
   | ID {push($1);fl=1;}
   | consttype {push($1);}
   ;

%%

/* Auxiliary functions */

#include "lex.yy.c"	/*Table-driven scanner included*/
#include<ctype.h>

int main(int argc, char *argv[]){

	yyin =fopen(argv[1],"r");    /*yyin is a variable of type FILE* and it points to the test file*/
	yyparse();	/* yyparse() will read tokens from yylex() */
	
if(!yyparse()){            /* return at end of input*/
		printf("Parsing done\n");  
		printingDetailsFunc();
	}
	else{
		printf("Error\n");
	}
	fclose(yyin);     /*close the file*/
return 0;
}
/*error analysis of yacc inbuilt function*/
void yyerror(char *s){
	printf("\nLine %d : %s %s\n",yylineno,s,yytext);
}





