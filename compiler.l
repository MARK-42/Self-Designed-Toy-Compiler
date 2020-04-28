/*Lex/Flex Scanner Generator code */

alpha [A-Za-z_]
digit [0-9]

/* DEFINITION SECTION */
%{
int line=1;
/*variable declaration*/
%}


/* RULES SECTION (input regular exp and corresponding C action) */
%%

[ \t]+   ;		/* Generated scanner ignores whitespaces  */
\n	{line++;}          /* To keep the count of the line no. for error messages */

"<="		{return LESSEQ;}         /* Different types of relational operators*/
">="		{return GRTEQ;}        
"=="		{return EQUAL;}
"!="		{return NOTEQ;}
"&&"		{return AND;}
"||"		{return OR;}


int	{
yylval.ival = INT;  		 /*we store the value of var in yylval & return INT token*/
return INT;
}    
 
float	{
yylval.ival = FLOAT; 		/*we store the value of var in yylval & return FLOAT token*/
return FLOAT;
}

void	{yylval.ival = VOID; 
return VOID;
}
else	{return ELSE;}		/* Conditional statements*/  
do	{return DO;}
if	{return IF;}

while	{return WHILE;}	/*Looping statements*/
for	{return FOR;}

struct 	{return STRUCT;}	/*struct and other keywords*/
return 	{return RETURN;}

printf	{return PRINT;}        /*Pre defined function*/


"{"	{
open_paraenthesis(); 
return '{';
}          /* identifies the opening parenthesis { and notes their count */

"}"	{
close_paraenthesis(); 
return '}';
}	     /* identifies the closing parenthesis } and notes their count */

"#include".+	{return PREPROC;}	/* Generated scanner removes preprocessing directives*/

"#define".+	{return PREPROC;}   /* Generated scanner removes preprocessing directives*/

{alpha}({alpha}|{digit})* {
yylval.str=strdup(yytext); 
return ID;
} 	/*for variables e.g :num1*/

[1-9]+{digit}*	{
yylval.str=strdup(yytext);
return NUM;
}		/*for numbers	e.g : 676*/

{digit}+\.{digit}+([eE][-+]?{digit}+)? 	{
yylval.str=strdup(yytext); 
return REAL;
}   /*e.g : 1.2E+6*/

\".*\"	{return STRING;}	/*for a string, that is, everything between the two double quotes  “ ” */
.	{return yytext[0];}	/* Ignore rest and print token value of string pointer yytext()*/ 

%%

/* END OF SECTION */



/* USE CODE SECTION */


yywrap()	/* Called by lex when input is finished */
{
	return(1);	/* No more processing required */
}


