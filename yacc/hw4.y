%{
#include <stdio.h>
int functioncount=0;
int operatorcount=0;
int intcount=0;
int charcount=0;
int pointercount=0;
int arraycount=0;
int selectioncount=0;
int loopcount=0;
int returncount=0;
int int_check=0;
int char_check=0;
%}
%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME
%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN
%token PREPROCESSOR COMMENT
%start translation_unit
%%

primary_expression
: IDENTIFIER
| CONSTANT
| STRING_LITERAL
| '(' expression ')'
;
postfix_expression
: primary_expression
| postfix_expression '[' expression ']' 
| postfix_expression '(' ')'  {functioncount++;}
| postfix_expression '(' argument_expression_list ')' {functioncount++;}
| postfix_expression '.' IDENTIFIER {operatorcount++;}
| postfix_expression PTR_OP IDENTIFIER {operatorcount++;}
| postfix_expression INC_OP {operatorcount++;}
| postfix_expression DEC_OP {operatorcount++;}
;
argument_expression_list
: assignment_expression
| argument_expression_list ',' assignment_expression
;
unary_expression
: postfix_expression
| INC_OP unary_expression {operatorcount++;}
| DEC_OP unary_expression {operatorcount++;}
| unary_operator cast_expression
| SIZEOF unary_expression
| SIZEOF '(' type_name ')'
;
unary_operator
: '&' 
| '*'
| '+' 
| '-' 
| '~' 
| '!' 
;
cast_expression
: unary_expression
| '(' type_name ')' cast_expression {operatorcount++;}
;
multiplicative_expression
: cast_expression
| multiplicative_expression '*' cast_expression {operatorcount++;}
| multiplicative_expression '/' cast_expression {operatorcount++;}
| multiplicative_expression '%' cast_expression {operatorcount++;}
;
additive_expression
: multiplicative_expression
| additive_expression '+' multiplicative_expression {operatorcount++;}
| additive_expression '-' multiplicative_expression {operatorcount++;}
;
shift_expression
: additive_expression
| shift_expression LEFT_OP additive_expression {operatorcount++;}
| shift_expression RIGHT_OP additive_expression {operatorcount++;}
;
relational_expression
: shift_expression
| relational_expression '<' shift_expression {operatorcount++;}
| relational_expression '>' shift_expression {operatorcount++;}
| relational_expression LE_OP shift_expression {operatorcount++;}
| relational_expression GE_OP shift_expression {operatorcount++;}
;
equality_expression
: relational_expression
| equality_expression EQ_OP relational_expression {operatorcount++;}
| equality_expression NE_OP relational_expression {operatorcount++;}
;
and_expression
: equality_expression
| and_expression '&' equality_expression {operatorcount++;}
;
exclusive_or_expression
: and_expression
| exclusive_or_expression '^' and_expression {operatorcount++;}
;
inclusive_or_expression
: exclusive_or_expression
| inclusive_or_expression '|' exclusive_or_expression {operatorcount++;}
;
logical_and_expression
: inclusive_or_expression
| logical_and_expression AND_OP inclusive_or_expression {operatorcount++;}
;
logical_or_expression
: logical_and_expression
| logical_or_expression OR_OP logical_and_expression {operatorcount++;}
;
conditional_expression
: logical_or_expression
| logical_or_expression '?' expression ':' conditional_expression  {selectioncount++;}
;
assignment_expression
: conditional_expression
| unary_expression assignment_operator assignment_expression
;
assignment_operator
: '='         {operatorcount++;}
| MUL_ASSIGN {operatorcount++;}
| DIV_ASSIGN {operatorcount++;}
| MOD_ASSIGN {operatorcount++;}
| ADD_ASSIGN {operatorcount++;}
| SUB_ASSIGN {operatorcount++;}
| LEFT_ASSIGN {operatorcount++;}
| RIGHT_ASSIGN {operatorcount++;}
| AND_ASSIGN {operatorcount++;}
| XOR_ASSIGN {operatorcount++;}
| OR_ASSIGN {operatorcount++;}
;
expression
: assignment_expression
| expression ',' assignment_expression
;
constant_expression
: conditional_expression
;
declaration
: declaration_specifiers ';' {int_check=0;}{char_check=0;}
| declaration_specifiers init_declarator_list ';' {int_check=0;}{char_check=0;}
| PREPROCESSOR
| COMMENT
;
declaration_specifiers
: storage_class_specifier
| storage_class_specifier declaration_specifiers
| type_specifier
| type_specifier declaration_specifiers
| type_qualifier
| type_qualifier declaration_specifiers
;
init_declarator_list
: init_declarator
| init_declarator_list ',' init_declarator
;
init_declarator
: declarator
{
if(int_check ==1) 
 {intcount++; 
 }
 else if(char_check==1)
 {charcount++;
 }
}
| declarator '=' initializer {operatorcount++;}
{
if(int_check ==1) 
 {intcount++; 
 }
 else if(char_check==1)
 {charcount++;
 }
} 
;
storage_class_specifier
: TYPEDEF
| EXTERN
| STATIC
| AUTO
| REGISTER
;
type_specifier
: VOID
| CHAR {char_check=1;}
| SHORT
| INT {int_check=1;}
| LONG
| FLOAT
| DOUBLE
| SIGNED
| UNSIGNED
| struct_or_union_specifier
| enum_specifier
| TYPE_NAME
;
struct_or_union_specifier
: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
| struct_or_union '{' struct_declaration_list '}'
| struct_or_union IDENTIFIER
;
struct_or_union
: STRUCT
| UNION
;
struct_declaration_list
: struct_declaration
| struct_declaration_list struct_declaration
;
struct_declaration
: specifier_qualifier_list struct_declarator_list ';'
;
specifier_qualifier_list
: type_specifier specifier_qualifier_list
| type_specifier
| type_qualifier specifier_qualifier_list
| type_qualifier
;
struct_declarator_list
: struct_declarator
| struct_declarator_list ',' struct_declarator
;
struct_declarator
: declarator
| ':' constant_expression
| declarator ':' constant_expression
;
enum_specifier
: ENUM '{' enumerator_list '}'
| ENUM IDENTIFIER '{' enumerator_list '}'
| ENUM IDENTIFIER
;
enumerator_list
: enumerator
| enumerator_list ',' enumerator
;
enumerator
: IDENTIFIER
| IDENTIFIER '=' constant_expression {operatorcount++;}
;
type_qualifier
: CONST
| VOLATILE
;
declarator
: pointer direct_declarator
| direct_declarator
;
direct_declarator
: IDENTIFIER
| '(' declarator ')'
| direct_declarator '[' constant_expression ']' {arraycount++;}
| direct_declarator '[' ']' {arraycount++;}
| direct_declarator '(' parameter_type_list ')' {int_check=0;}{char_check=0;}
| direct_declarator '(' identifier_list ')'
| direct_declarator '(' ')'
;
pointer
: '*' {pointercount++;}
| '*' type_qualifier_list {pointercount++;}
| '*' pointer {pointercount++;}
| '*' type_qualifier_list pointer {pointercount++;}
;
type_qualifier_list
: type_qualifier
| type_qualifier_list type_qualifier
;
parameter_type_list
: parameter_list 
| parameter_list ',' ELLIPSIS
;
parameter_list
: parameter_declaration
| parameter_list ',' parameter_declaration
;
parameter_declaration
: declaration_specifiers declarator
{
if(int_check ==1) 
 {intcount++; 
 }
 else if(char_check==1)
 {charcount++;
 }
}
| declaration_specifiers abstract_declarator
{
if(int_check ==1) 
 {intcount++; 
 }
 else if(char_check==1)
 {charcount++;
 }
}
| declaration_specifiers
;
identifier_list
: IDENTIFIER
| identifier_list ',' IDENTIFIER
;
type_name
: specifier_qualifier_list
| specifier_qualifier_list abstract_declarator
;
abstract_declarator
: pointer
| direct_abstract_declarator
| pointer direct_abstract_declarator
;
direct_abstract_declarator
: '(' abstract_declarator ')'
| '[' ']'
| '[' constant_expression ']'
| direct_abstract_declarator '[' ']'
| direct_abstract_declarator '[' constant_expression ']'
| '(' ')'
| '(' parameter_type_list ')'
| direct_abstract_declarator '(' ')'
| direct_abstract_declarator '(' parameter_type_list ')'
;
initializer
: assignment_expression
| '{' initializer_list '}'
| '{' initializer_list ',' '}'
;
initializer_list
: initializer
| initializer_list ',' initializer
;
statement
: labeled_statement
| compound_statement
| expression_statement
| selection_statement
| iteration_statement
| jump_statement
;
labeled_statement
: IDENTIFIER ':' statement
| CASE constant_expression ':' statement
| DEFAULT ':' statement
;
compound_statement
: '{' '}' 
| '{' statement_list '}'  
| '{' declaration_list '}' 
| '{' declaration_list statement_list '}'
;
declaration_list
: declaration
| declaration_list declaration 
;
statement_list
: statement
| statement_list statement
| statement declaration_list
| statement_list statement declaration_list
;
expression_statement
: ';'
| expression ';'
;
selection_statement
: IF '(' expression ')' statement {selectioncount++;}
/*| IF '(' expression ')' statement ELSE statement */ 
| SWITCH '(' expression ')' statement {selectioncount++;}
;
iteration_statement
: WHILE '(' expression ')' statement {loopcount++;}
| WHILE '(' expression ')' COMMENT statement {loopcount++;}
| DO statement WHILE '(' expression ')' ';' {loopcount++;}
| FOR '(' expression_statement expression_statement ')' statement {loopcount++;}
| FOR '(' expression_statement expression_statement expression ')' statement {loopcount++;}
| FOR '(' INT expression_statement expression_statement expression ')' statement {loopcount++;} {intcount++;}
;
jump_statement
: GOTO IDENTIFIER ';'
| CONTINUE ';'
| BREAK ';'
| RETURN ';' {returncount++;}
| RETURN expression ';' {returncount++;}
;
translation_unit
: external_declaration
| translation_unit external_declaration
;
external_declaration
: function_definition
| declaration
;
function_definition
: declaration_specifiers declarator declaration_list compound_statement {functioncount++;}{int_check=0;}{char_check=0;} 
| declaration_specifiers declarator compound_statement {functioncount++;}{int_check=0;}{char_check=0;}
| declarator declaration_list compound_statement {functioncount++;}
| declarator compound_statement {functioncount++;}
;
%%

#include <stdio.h>
extern char yytext[];
extern int column;
int main(){
	yyparse();
	printf("function = %d\n", functioncount);
	printf("operator = %d\n", operatorcount);
	printf("int = %d\n", intcount);
	printf("char = %d\n", charcount);
	printf("pointer = %d\n", pointercount);
	printf("array = %d\n", arraycount);
	printf("selection = %d\n", selectioncount);
	printf("loop = %d\n", loopcount);
	printf("return = %d\n", returncount);
	return 0;
}

yyerror(s)  
char *s;
{
fflush(stdout);
printf("\n%*s\n%*s\n", column, "^", column, s);  
}