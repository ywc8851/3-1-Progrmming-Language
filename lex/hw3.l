%{
#include <stdio.h>
int preprocessor=0;
int octal_number=0;
int negative_decimal_number=0;
int positive_decimal_number=0;
int operator=0;
int comment=0;
int equal=0;
int open_brace=0;
int close_brace=0;
int word=0;
int wordcase1=0;
int wordcase2=0;
int mark=0;
%}
%%
"/*"([^*]|\*+[^*/])*\*+"/" {comment++;}
"//"(.|" ")*"\n" {comment++;}
#(include|define).*"\n" {preprocessor++;}
"=" {equal++;}
"{" {open_brace++;}
"}" {close_brace++;}
-[0-9]+ {negative_decimal_number++;}
0+[0-7]+  {octal_number++;}
0  {mark++;}
[0-9]+ {positive_decimal_number++;}
"+"|"-"|"*"|"/"|"%"|"++"|"--"|"&&"|"||"|"!"|">"|"<"|"=="|"!="|"<="|">="|","|"&" {operator++;}
[_|a-oq-zA-OQ-Z]*(p|P){1}[_|a-oq-zA-OQ-Z0-9]*(p|P){1}[_|a-oq-zA-OQ-Z0-9]* {wordcase1++;}
(e|E)+([_|a-zA-Z0-9])*(m|M){1} {wordcase2++;}
([_|a-zA-Z])+([_|a-zA-Z0-9])*   {word++;}
\n {mark++;}
. {mark++;}


%%
int main(){
        yylex();
        printf("preprocessor = %d\n",preprocessor);
        printf("octal number = %d\n",octal_number);
        printf("negative decimal number = %d\n",negative_decimal_number);
        printf("positive decimal number = %d\n",positive_decimal_number);
        printf("operator = %d\n",operator);
        printf("comment = %d\n",comment);
        printf("'='= %d\n",equal);
        printf("'{'= %d\n",open_brace);
        printf("'}'= %d\n",close_brace);
        printf("wordcase1 = %d\n",wordcase1);
        printf("wordcase2 = %d\n",wordcase2);
        printf("word = %d\n",word);
        printf("mark = %d\n",mark);
        return 0;
}

int yywrap(){
        return 1;
}
