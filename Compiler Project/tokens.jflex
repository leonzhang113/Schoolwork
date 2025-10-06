/*-***
 *
 * This file defines a stand-alone lexical analyzer for a subset of the Pascal
 * programming language.  This is the same lexer that will later be integrated
 * with a CUP-based parser.  Here the lexer is driven by the simple Java test
 * program in ./PascalLexerTest.java, q.v.  See 330 Lecture Notes 2 and the
 * Assignment 2 writeup for further discussion.
 *
 */


import java_cup.runtime.*;


%%
/*-*
 * LEXICAL FUNCTIONS:
 */

%cup
%line
%column
%unicode
%class Lexer

%{

/**
 * Return a new Symbol with the given token id, and with the current line and
 * column numbers.
 */
Symbol newSym(int tokenId) {
    return new Symbol(tokenId, yyline, yycolumn);
}

/**
 * Return a new Symbol with the given token id, the current line and column
 * numbers, and the given token value.  The value is used for tokens such as
 * identifiers and numbers.
 */
Symbol newSym(int tokenId, Object value) {
    return new Symbol(tokenId, yyline, yycolumn, value);
}

%}


/*-*
 * PATTERN DEFINITIONS:
 */
intlit = [0-9]+
floatlit = [0-9]+"."[0-9]+
charlit = \'([^\'\\]|\\.)\'
strlit = \"([^\"\\\n\t])*\"
comment = "\\".*
commentmulti = "\\*"([^*]|(\*+[^\\]))*"*\\"
id = [a-zA-Z][a-zA-Z0-9]*
whitespace = [ \n\t\r]


/** * Implement patterns as regex here */


%%
/**
 * LEXICAL RULES:
 */
class           { return newSym(sym.CLASS, "class"); }
final           { return newSym(sym.FINAL, "final"); }
int             { return newSym(sym.INT, "int"); }
char            { return newSym(sym.CHAR, "char"); }
bool            { return newSym(sym.BOOL, "bool"); }
float           { return newSym(sym.FLOAT, "float"); }
void            { return newSym(sym.VOID, "void"); }
if              { return newSym(sym.IF, "if"); }
else            { return newSym(sym.ELSE, "else"); }
while           { return newSym(sym.WHILE, "while"); }
return          { return newSym(sym.RETURN, "return"); }
read            { return newSym(sym.READ, "read"); }
print           { return newSym(sym.PRINT, "print"); }
printline       { return newSym(sym.PRINTLINE, "printline"); }
true            { return newSym(sym.TRUE, "true"); }
false           { return newSym(sym.FALSE, "false"); }
"++"            { return newSym(sym.PLUSPLUS, "++"); }
"--"            { return newSym(sym.MINMIN, "--"); }
"+"             { return newSym(sym.PLUS, "+"); }
"-"             { return newSym(sym.MINUS, "-"); }
"*"             { return newSym(sym.MULTIPLY, "*"); }
"/"             { return newSym(sym.DIVIDE, "/"); }
"<="            { return newSym(sym.LESSEQUAL, "<="); }
">="            { return newSym(sym.GREATEREQUAL, ">="); }
"=="            { return newSym(sym.EQUAL, "=="); }
"="             { return newSym(sym.ASSIGN, "="); }
"<>"            { return newSym(sym.NOTEQUAL, "<>"); }
"<"             { return newSym(sym.LESS, "<"); }      
">"             { return newSym(sym.GREATER, ">"); }
"||"            { return newSym(sym.OR, "||"); }
"&&"            { return newSym(sym.AND, "&&"); }
"~"             { return newSym(sym.TILDA, "~"); }
"?"             { return newSym(sym.QUESTION, "?"); }
":"             { return newSym(sym.COLON, ":"); }
";"             { return newSym(sym.SEMICOLON, ";"); }
","             { return newSym(sym.COMMA, ","); }
"("             { return newSym(sym.LPAREN, "("); }
")"             { return newSym(sym.RPAREN, ")"); }
"{"             { return newSym(sym.LCURLYBRACE, "{"); }
"}"             { return newSym(sym.RCURLYBRACE, "}"); }
"["             { return newSym(sym.LBRACKET, "["); }
"]"             { return newSym(sym.RBRACKET, "]"); }
{id}            { return newSym(sym.ID, yytext()); }
{intlit}        { return newSym(sym.INTLIT, Integer.valueOf(yytext())); }
{floatlit}      { return newSym(sym.FLOATLIT, Float.valueOf(yytext())); }
{charlit}       { return newSym(sym.CHARLIT, yytext()); }
{strlit}        { return newSym(sym.STRLIT, yytext()); }
{whitespace}    { /* Ignore whitespace */ }
{comment}       { return newSym(sym.COMMENT, yytext()); }
{commentmulti}  { return newSym(sym.COMMENTMULTI, yytext()); }
.               { System.out.println("Illegal char, '" + yytext() +
                 "' line: " + yyline + ", column: " + yycolumn); }
