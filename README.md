# Self-Designed-Toy-Compiler
This is our project for Compiler Design Course at IIIT Allahabad. 

It is a toy compiler, which takes C-grammar and compiles a file using that grammar. 

It has the first four stages of compiler.

## Steps to use:
Install lex and yacc on your terminal
Run the fiollowing commands in the terminal :
lex compiler.l
yacc compiler.y
gcc y.tab.c -ll -w
./a.out test4.c
