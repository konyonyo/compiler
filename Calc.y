/* 数式の計算 */

%{
#include <stdio.h>
#include <ctype.h>
%}

%token NUM

%%

lines : lines line
      | line
      ;

line : expr '\n' { printf("%d\n", $1); }
     ; 

expr : expr '+' term { $$ = $1 + $3; }
     | expr '-' term { $$ = $1 - $3; }
     | term
     ;

term : term '*' factor { $$ = $1 * $3; }
     | term '/' factor { if($3 != 0){
                             $$ = $1 / $3;
                         }else{
                             yyerror("devided by zero");
                         }
                       }
     | term '%' factor { if($3 != 0){
                             $$ = $1 % $3;
                         }else{
                             yyerror("devided by zero");
                         }
                       }
     | factor
     ;

factor : '(' expr ')' { $$ = $2; }
       | '(' expr ')' '!' { $$ = fac($2); } 
       | NUM
       | NUM '!' { $$ = fac($1); }
       | '-' NUM { $$ = -1 * $2; }
       ;

%%

int yylex(){
    int c = skipBadChar();

    if(isdigit(c)){
        yylval = c - '0';
        while(isdigit(c = skipBadChar())){
            yylval = yylval * 10 + (c - '0');
        }
        ungetc(c, stdin);
        return NUM;
    }else{
        return c;
    }


}

int skipBadChar(){
    int c = getchar();
    while(c == ' ' || c == '\t'){
        c = getchar();
    }
    if(!(c == '+' || c == '-' || c == '*' || c == '/' || c == '%' || c == '(' || c == ')' || c == '!' || c == '\n' || c == EOF || isdigit(c) || isspace(c))){
        yyerror("bad char");
    }

    return c;
}

int fac(int n){
    if(n == 0){
        return 1;
    }else if(n > 0){
        return n * fac(n - 1);
    }else{
        yyerror("negative value");
        return 0;        
    }
}

int yyerror(const char* s){
    printf("ERROR: %s\n", s);
    return 0;
}
