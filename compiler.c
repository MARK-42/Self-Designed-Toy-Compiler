// Code of generating Symbol Table
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

// struct  defining layout of a symbol and all its attribute
struct symbl{
    int num_s;
    char tok[ 100 ];
    int type[ 100 ];
    int tn;
    int address;
    float fvalue;
    int scope;
}strctT[ 100 ];

int n=0,arr[10];
float t[100];
int iter=0;

// function's return type is returned in this method.
int RetType(int tmpx){
    return arr[tmpx-1];
}

//storing return type of the function
void ReturnTypeStorer( int tmpx, int retTyp ){
    arr[tmpx] = retTyp;
    return;
}

//token's scope is defined here
void insrttokenScope(char *a,int symtok){
    int i;
    for(i=0;i<n;i++){
        if(!strcmp(a,strctT[i].tok)){
            strctT[i].scope=symtok;
            break;
        }
    }
}

// returning token's scope
int scope_returner(char *a,int cscope){
    int i,maxm = 0;
    for(i=0;i<=n;i++){
        if(!(strcmp(a,strctT[i].tok)) && cscope>=strctT[i].scope){
            if(strctT[i].scope>=maxm)
                maxm = strctT[i].scope;
        }
    }
    return maxm;
}

//check whether a token is already present or not
int func_lookup(char *a){
    int i;
    for(i=0;i<n;i++){
        if( !strcmp( a, strctT[i].tok) )
            return 0;
    }
    return 1;
}

int funcRetType(char *a,int sct){
    int i;
    for(i=0;i<=n;i++){
        if(!strcmp(a,strctT[i].tok) && strctT[i].scope==sct){
            return strctT[i].type[0];
        }
    }
}

void ScopeUpdatecheckFunc(char *a,char *b,int tmpscope){
    int i,j,k,maxm=0;
    for(i=0;i<=n;i++){
        if(!strcmp(a,strctT[i].tok)   && tmpscope>=strctT[i].scope){
            if(strctT[i].scope>=maxm)
                maxm=strctT[i].scope;
        }
    }
    for(i=0;i<=n;i++){
        if(!strcmp(a,strctT[i].tok)   && maxm==strctT[i].scope){
            float temp=atof(b);
            for(k=0;k<strctT[i].tn;k++){
                if(strctT[i].type[k]==258)
                    strctT[i].fvalue=(int)temp;
                else
                    strctT[i].fvalue=temp;
            }
        }
    }
}



// function inserting new symbol
void funcInsertSymbol(char *name, int typ, int addr){
    int i;
    if(func_lookup(name)){
        strcpy(strctT[n].tok,name);
        strctT[n].tn=1;
        strctT[n].type[strctT[n].tn-1]=typ;
        strctT[n].address=addr;
        strctT[n].num_s=n+1;
        n++;
    }
    else{
        for(i=0;i<n;i++){
            if(!strcmp(name,strctT[i].tok)){
                strctT[i].tn++;
                strctT[i].type[strctT[i].tn-1]=typ;
                break;
            }
        }
    }    
    
    return;
}

// Function to insert a duplicate symbol in the symbol table
void duplicateSymbolInsertFunc(char *name, int typ, int addr,int tmpscope){
    strcpy(strctT[n].tok,name);
    strctT[n].tn=1;
    strctT[n].type[strctT[n].tn-1]=typ;
    strctT[n].address=addr;
    strctT[n].num_s=n+1;
    strctT[n].scope=tmpscope;
    n++;
    return;
}

//For printing purposes
void printingDetailsFunc(){
    int i,j;
    printf("\n\nTable of Symbols\n\n");
    printf("\nnum_s.\ttoken\taddressess\tValue\tScope\tType\n");
    for(i=0;i<n;i++){
        if(strctT[i].type[0]==258)
            printf("%d\t%s\t%d\t%d\t%d",strctT[i].num_s
    
    ,strctT[i].tok,strctT[i].address,(int)strctT[i].fvalue,strctT[i].scope);
        else
            printf("%d\t%s\t%d\t%.1f\t%d",strctT[i].num_s
    
    ,strctT[i].tok,strctT[i].address,strctT[i].fvalue,strctT[i].scope);
        for(j=0;j<strctT[i].tn;j++){
            if(strctT[i].type[j]==258)
                printf("\tINT");
            else if(strctT[i].type[j]==259)
                printf("\tFLOAT");
            else if(strctT[i].type[j]==271)
                printf("\tFUNCTION");
            else if(strctT[i].type[j]==269)
                printf("\tARRAY");
            else if(strctT[i].type[j]==260)
                printf("\tVOID");
        }
        printf("\n");
    }
    return;
}








