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
import java.util.Stack;
import java.util.HashMap;


%%


%cup
%line
%column
%unicode
%class Lexer
%implements sym



%{

int num_tab; /* numero di tab */
int s;  /* valore testa stack temporaneo */
int dedent; /*n numero di dedent */
int flag = 0; /* */


 StringBuffer string_buffer = new StringBuffer();
 StringBuffer string_prefix = new StringBuffer();
 Stack<Integer> stack = new Stack<Integer>();
 HashMap<Integer,String> StringList= new HashMap<Integer,String>();
 HashMap<Integer,String> IdentifierList= new HashMap<Integer,String>();
 HashMap<Integer,String> NumericList= new HashMap<Integer,String>();

  public int curr_line(){
        return yyline;
    }
     public int curr_col(){
        return yycolumn;
    }


Symbol newSym(int tokenId) {
    return new Symbol(tokenId, yyline, yycolumn);
}

Symbol newSym(int tokenId, Object value) {
    return new Symbol(tokenId, yyline, yycolumn, value);
}




%}









%state INDENTATION, SHORT_STRING_S, SHORT_STRING_D,LONG_STRING_S,LONG_STRING_D, 


/** Identificatori e Commenti **/

NEWLINE = \n | \r
digit = [0-9]
uppercase = [A-Z]
lowercase = [a-z]


letter = {uppercase}|{lowercase}
identifier = ( {letter} | "_") ({letter} | {digit} | "_")* 
comment_body    = .*
comment         = "#"{comment_body}
whitespace      = [ \n\t]
encodingDeclaration = "#"[^\n]*"coding"[:=][^\n]*
inde = \t | "    "

/* Lessemi per gli escape */

unicodeescape = "\\u"[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]
unicodeescape32 = "\\u"[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]
octescape = "\\"[0-7][0-7][0-7]
hexescape = "\\"[xX][0-9a-fA-F][0-9a-fA-F]

/** Righe **/

explicitline = [\\]

/** Stringhe **/

stringprefix  =  "r" | "u" | "ur" | "R" | "U" | "UR" | "Ur" | "uR"| "b" | "B" | "br" | "Br" | "bR" | "BR"
shortstringchar = [\x00-\x09\x11-\x21\x23-\x26\x28-\x5b\x5d-\x7F]*
longstringchar = [\x00-\x21\x23-\x26\x28-\x5B\x5D-\x7F]* 


/** Integer **/

longinteger = {integer} ("l" | "L")
integer = {decimalinteger} | {octinteger} | {hexinteger} | {bininteger}

decimalinteger = {nonzerodigit} {digit}* | "0"
octinteger  = "0" ("o" | "O") {octdigit}+ | "0" {octdigit}+
hexinteger  = "0" ("x" | "X") {hexdigit}+
bininteger 	= "0" ("b" | "B") {bindigit}+
nonzerodigit = [1-9]
octdigit = [0-7]
bindigit = "0" | "1"
hexdigit = {digit} | [a-f] | [A-F]

/** Float **/

exponent = ("e" | "E") ("+" | "-")? {digit}+
fraction  = "." {digit}+
intpart   = {digit}+
exponentfloat = ({intpart} | {pointfloat}) {exponent}
pointfloat  = {intpart}? {fraction} | {intpart}"."
floatnumber  = {pointfloat} | {exponentfloat}


/**Imaginary */

imagnumber = ({floatnumber} | {intpart}) ("j" | "J")


/** Invalid **/

invalid = "$" | "?" | "`"

%%
<YYINITIAL> {

/** Keywords **/

"is not" {   if(!stack.isEmpty() && yycolumn==0){
                      yypushback(yytext().length()); 
                      stack.pop();
                      return newSym(sym.DEDENT);
      }   
      return newSym(sym.IS_NOT); 
}
"not in" {   if(!stack.isEmpty() && yycolumn==0){
                      yypushback(yytext().length()); 
                      stack.pop();
                      return newSym(sym.DEDENT);
      }   
      return newSym(sym.NOT_IN); 
}

"exec" {   if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}   
 			return newSym(sym.EXEC); 
}

"print" {   if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}   
 			return newSym(sym.PRINT); 
}


"False" {   if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}   
 			return newSym(sym.FALSE); 
}

 "None" {   if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}    
 			return newSym(sym.NONE); 
 }

 "True" {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			} 
 			return newSym(sym.TRUE); 
}

 "and"  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length());
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}    
 			return newSym(sym.AND); 
}

"as"  {     if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}    
 			return newSym(sym.AS); 
}

 "assert"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}    
 				return newSym(sym.ASSERT); 
 }

 "break"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
												stack.pop();
 											return newSym(sym.DEDENT);
				}    
				return newSym(sym.BREAK); 
}

 "class" 	{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}
 				return newSym(sym.CLASS); 
}

 "continue"  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.CONTINUE); 
}

 "def"  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}      
 			return newSym(sym.DEF); 
 }

 "del" {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}      
 			return newSym(sym.DEL); 
}


 "elif"  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}      
 			return newSym(sym.ELIF); 
 }

 "else"  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}    
 			return newSym(sym.ELSE); 
 }

 "except"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 			}      
 			return newSym(sym.EXCEPT); 
}

 "finally"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}
 			    return newSym(sym.FINALLY); 
}

"for" {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}
 			return newSym(sym.FOR); 
}

"from"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.FROM); 
}

"global"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.GLOBAL); 
}

"if"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.IF); 
}

 "import"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.IMPORT); 
}

 "in"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}
 				return newSym(sym.IN); 
}

 "is"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.IS); 
}

 "lambda"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.LAMBDA); 
}

 "nonlocal"  {	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.NONLOCAL); 
}

 "not"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.NOT); 
}

 "or"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.OR); 
}

 "pass"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.PASS); 
 }

 "raise"  {		if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.RAISE); 
}

"return"  	{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.RETURN); 
}

"try" 	 	{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.TRY); 
}

"while"  	{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.WHILE); 
}

"with" 		{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.WITH); 	
}

"yield"  	{	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 				}      
 				return newSym(sym.YIELD); 
}


/** Reserved Classes of Identifiers **/


/** Operatori **/

"+" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.PLUS);
}

"-" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MINUS);
}

"*" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MULT);
}

"**"	 {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.POW);
}

"/" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.DIV);
}

"//" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.F_DIV);
}

"%" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MOD);
}

"<<" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.BLS);
}

">>" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.BRS);
}

"&" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_AND);
}

"|" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_OR);
}

"^" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_XOR);
}

"~" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_O_COMP);
}

"<" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.LT);
}

">" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.GT);
}

"<=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.LET);
}

">=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.GET);
}

"==" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.EQEQ);
}

"!=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.NEQ);
}

"!="  { if(!stack.isEmpty() && yycolumn==0){
                      yypushback(yytext().length()); 
                      stack.pop();
                      return newSym(sym.DEDENT);
      }     
      return newSym(sym.NEQ);
}

"<>"  { if(!stack.isEmpty() && yycolumn==0){
                      yypushback(yytext().length()); 
                      stack.pop();
                      return newSym(sym.DEDENT);
      }     
      return newSym(sym.NEQQ);
}

/** Delimitatori **/

"(" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.LPAR);
}

")" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.RPAR);
}

"[" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.LSB);
}

"]" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.RSB);
}

"{" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.LBRACE);
}

"}" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.RBRACE);
}

"," 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.COMMA);
}

":" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.COLON); 
}

"." 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.DOT);
}

";"		{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.SEMI);
}

"@" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.AT);
}

"=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}      
 			return newSym(sym.EQ); 
}

"->" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.ARROW);
}

"+=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.PLUS_EQ);
}

"-=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MINUS_EQ);
}

"*=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MULT_EQ);
}

"/=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.DIV_EQ);
}

"//=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.F_DIV_EQ);
}

"%=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.MOD_EQ);
}


"&=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
			return newSym(sym.B_AND_EQ);
}

"|=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_OR_EQ);
}

"^=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.B_XOR_EQ);
}

">>=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.BRS_EQ);
}

"<<=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.BLS_EQ);
}

"**=" 	{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 			}     
 			return newSym(sym.POW_EQ);
}

 

{NEWLINE} {	return newSym(sym.NEWLINE);}

{inde} 	{	if(yycolumn == 0){
							num_tab=1;
							flag=1;
							yybegin(INDENTATION);
			}
}




{encodingDeclaration}       {  if(yyline < 2){
                  						System.out.println("Dichiarazione di codifica: " + yytext()); 
                  				}
                  				else {
                  						System.out.println("Commento: " + yytext());
                  				}
}

{comment}       { /* Stampo il commento  */
                  System.out.println("Commento: " + yytext()); }

{explicitline} 	{	if(!stack.isEmpty() && yycolumn==0){
 													yypushback(yytext().length()); 
 													stack.pop();
 											return newSym(sym.DEDENT);
 					}     
 					return newSym(sym.EXLINE);
}

{imagnumber} 	{	if(!stack.isEmpty() && yycolumn==0){
 													yypushback(yytext().length()); 
 													stack.pop();
 											return newSym(sym.DEDENT);
 					}      	
 					NumericList.put(yytext().hashCode(),yytext());
					return newSym(sym.IMAG_NUMB,yytext());
}

{floatnumber} 	{	if(!stack.isEmpty() && yycolumn==0){
 													yypushback(yytext().length()); 
 													stack.pop();
 											return newSym(sym.DEDENT);
 					}
 					NumericList.put(yytext().hashCode(),yytext());
					return newSym(sym.FLOAT,yytext());
}

{integer}  { 	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 				}     	
				NumericList.put(yytext().hashCode(),yytext());
				return newSym(sym.INT,yytext());
}

{longinteger}  { 	if(!stack.isEmpty() && yycolumn==0){
 													yypushback(yytext().length()); 
 													stack.pop();
 											return newSym(sym.DEDENT);
 					}     
					NumericList.put(yytext().hashCode(),yytext());
					return newSym(sym.LONG_INT,yytext());
}



{stringprefix}?\'\'\'  {	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 							}     
							string_buffer.setLength(0); 
							string_prefix.setLength(0);
							string_prefix.append(yytext().toLowerCase());
					 		if(yytext().toLowerCase().indexOf('u') >=0) {
					 			string_buffer.append("u");
					 		}	
					 		string_buffer.append("'");
							yybegin(LONG_STRING_S); 
}

{stringprefix}?\"\"\"  { 	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 							}     
							string_buffer.setLength(0); 
							string_prefix.setLength(0);
							string_prefix.append(yytext().toLowerCase());
					 		if(yytext().toLowerCase().indexOf('u') >=0) 	 {
					 			string_buffer.append("u");
							}
							string_buffer.append("'");
							yybegin(LONG_STRING_D); 
}

{stringprefix}?\'  {if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 					}     
					string_buffer.setLength(0); 
					string_prefix.setLength(0);
					string_prefix.append(yytext().toLowerCase());
					if(yytext().toLowerCase().indexOf('u') >=0)  {
					 	string_buffer.append("u");
					}
					string_buffer.append("'");
					yybegin(SHORT_STRING_S); 
}

{stringprefix}?\"  { 	if(!stack.isEmpty() && yycolumn==0){
 												yypushback(yytext().length()); 
 												stack.pop();
 											return newSym(sym.DEDENT);
 						}     
						string_buffer.setLength(0);
					 	string_prefix.setLength(0);
					 	string_prefix.append(yytext().toLowerCase());
						 if(yytext().toLowerCase().indexOf('u') >=0) {
					 		string_buffer.append("u");
						 }
					 	string_buffer.append("'");
					 	yybegin(SHORT_STRING_D); 
}


{identifier}    { 	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 					}     
					IdentifierList.put(yytext().hashCode(),yytext());
					return newSym(sym.IDENT,yytext());
}

{invalid}		{	if(!stack.isEmpty() && yycolumn==0){
 											yypushback(yytext().length()); 
 											stack.pop();
 											return newSym(sym.DEDENT);
 					}     
					return newSym(sym.ERROR,yytext()); 
}

{whitespace}    { /* Gli spazi bianchi vengono ignorati */ }

.               { return newSym(sym.ERROR,yytext()); }
<<EOF>>			{	
					if(stack.isEmpty()) {return newSym(sym.EOF);
					}
					else{
							stack.pop();
							return newSym(sym.DEDENT);
					}
					
				}
	                   
}

<INDENTATION>
{

{inde} 	{	num_tab++;
}	

. 	{
		
		

		if(stack.isEmpty()){
	   				s = 0;
		}
		else { 
					s = stack.peek();
		}
		

		if(s < num_tab && flag==1){	
						yybegin(YYINITIAL);
						yypushback(1);
						stack.push(num_tab);
						return newSym(sym.INDENT);
		}		
		else if (s > num_tab && !stack.isEmpty()){
								flag = 0;
								yypushback(1);
								stack.pop();
							
								return newSym(sym.DEDENT);

						
						

		}
		else if(s == num_tab ){
								yybegin(YYINITIAL);
								yypushback(1);
						}
		else{					yybegin(YYINITIAL);
								yypushback(1);
								return newSym(sym.ERROR,"Inconsistent dedent");
						}

}

}






<SHORT_STRING_D>{
\"              { 	yybegin(YYINITIAL);
					string_buffer.append("'");
					StringList.put(string_buffer.toString().hashCode(),string_buffer.toString());
					return newSym(sym.STRING,string_buffer.toString());
				}
\'				{	
					string_buffer.append("'");
				}	
							
\\				{
					
					string_buffer.append("\\");

				}

\\\'			{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("'");
							break;
						case "u":
							string_buffer.append("'");
							break;	
						case "r":
							string_buffer.append("\\'");
							break;
						case "ur":
							string_buffer.append("\\'");
							break;
						case "br":
							string_buffer.append("\\'");
							break;
						default:
							string_buffer.append("'");
							break;	
					}
				}
				

\\\"			{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append('"');
							break;
						case "u":
							string_buffer.append('"');
							break;	
						case "r":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "ur":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "br":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						default:
							string_buffer.append('"');
							break;	
					}
				}				
				
\\\\			{		
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\\\");
							break;
						case "u":
							string_buffer.append("\\\\");
							break;	
						case "r":
							string_buffer.append("\\\\\\\\");
							break;
						case "ur":
							string_buffer.append("\\\\\\\\");
							break;
						case "br":
							string_buffer.append("\\\\\\\\");
							break;
						default:
							string_buffer.append("\\\\");
							break;	
					}	
			}

			
\\a 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u0007");
							break;
						case "u":
							string_buffer.append("\u0007");
							break;	
						case "r":
							string_buffer.append("\\a");
							break;
						case "ur":
							string_buffer.append("\\a");
							break;
						case "br":
							string_buffer.append("\\a");
							break;
						default:
							string_buffer.append("\u0007");
							break;	
					}	
			}	
				

\\n 		{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\n");
							break;
						case "u":
							string_buffer.append("\n");
							break;	
						case "r":
							string_buffer.append("\\n");
							break;
						case "ur":
							string_buffer.append("\\n");
							break;
						case "br":
							string_buffer.append("\\n");
							break;
						default:
							string_buffer.append("\n");
							break;	
					}
}					
					/* OK */
\\b 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u0008");
							break;
						case "u":
							string_buffer.append("\u0008");
							break;	
						case "r":
							string_buffer.append("\\b");
							break;
						case "ur":
							string_buffer.append("\\b");
							break;
						case "br":
							string_buffer.append("\\b");
							break;
						default:
							string_buffer.append("\u0008");
							break;	
					}	
			}	
\\f 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u000c");
							break;
						case "u":
							string_buffer.append("\u000c");
							break;	
						case "r":
							System.out.println('3');
							string_buffer.append("\\f");
							break;
						case "ur":
							System.out.println('4');
							string_buffer.append("\\f");
							break;
						case "br":
							System.out.println('5');
							string_buffer.append("\\f");
							break;
						default:
							System.out.println('6');
							string_buffer.append("\u000c");
							break;	
					}	
			}	
\\r 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\r");
							break;
						case "u":
							string_buffer.append("\r");
							break;	
						case "r":
							string_buffer.append("\\r");
							break;
						case "ur":
							string_buffer.append("\\r");
							break;
						case "br":
							string_buffer.append("\\r");
							break;
						default:
							string_buffer.append("\r");
							break;	
					}	
			}

\\t 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\t");
							break;
						case "u":
							string_buffer.append("\t");
							break;	
						case "r":
							string_buffer.append("\\t");
							break;
						case "ur":
							string_buffer.append("\\t");
							break;
						case "br":
							string_buffer.append("\\t");
							break;
						default:
							string_buffer.append("\t");
							break;	
					}	
			}

\\v 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u000b");
							break;
						case "u":
							string_buffer.append("\u000b");
							break;	
						case "r":
							string_buffer.append("\\v");
							break;
						case "ur":
							string_buffer.append("\\v");
							break;
						case "br":
							string_buffer.append("\\v");
							break;
						default:
							string_buffer.append("\u000b");
							break;	
					}	
			}	

{unicodeescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{unicodeescape32}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{octescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{hexescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "u":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
						case "r":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "ur":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "br":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						default:
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
					}
						
}

{shortstringchar} {string_buffer.append(yytext());}

{NEWLINE}	{ yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }

<<EOF>> { yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }

.               { yybegin(YYINITIAL); return newSym(sym.ERROR,"Non-ASCII character "+yytext()); }
}

<SHORT_STRING_S>{

\'             { 	yybegin(YYINITIAL);
					string_buffer.append("'");
					StringList.put(string_buffer.toString().hashCode(),string_buffer.toString());
					return newSym(sym.STRING,string_buffer.toString());
				}
\"				{
					string_buffer.append('"');
				}				
\\				{
					
					string_buffer.append("\\");

				}

\\\'			{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("'");
							break;
						case "u":
							string_buffer.append("'");
							break;	
						case "r":
							string_buffer.append("\\'");
							break;
						case "ur":
							string_buffer.append("\\'");
							break;
						case "br":
							string_buffer.append("\\'");
							break;
						default:
							string_buffer.append("'");
							break;	
					}
				}
				

\\\"			{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append('"');
							break;
						case "u":
							string_buffer.append('"');
							break;	
						case "r":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "ur":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "br":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						default:
							string_buffer.append('"');
							break;	
					}
				}				
				
\\\\			{		
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\\\");
							break;
						case "u":
							string_buffer.append("\\\\");
							break;	
						case "r":
							string_buffer.append("\\\\\\\\");
							break;
						case "ur":
							string_buffer.append("\\\\\\\\");
							break;
						case "br":
							string_buffer.append("\\\\\\\\");
							break;
						default:
							string_buffer.append("\\\\");
							break;	
					}	
			}

			
\\a 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u0007");
							break;
						case "u":
							string_buffer.append("\u0007");
							break;	
						case "r":
							string_buffer.append("\\a");
							break;
						case "ur":
							string_buffer.append("\\a");
							break;
						case "br":
							string_buffer.append("\\a");
							break;
						default:
							string_buffer.append("\u0007");
							break;	
					}	
			}	
				

\\n 		{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\n");
							break;
						case "u":
							string_buffer.append("\n");
							break;	
						case "r":
							string_buffer.append("\\n");
							break;
						case "ur":
							string_buffer.append("\\n");
							break;
						case "br":
							string_buffer.append("\\n");
							break;
						default:
							string_buffer.append("\n");
							break;	
					}
}					
					/* OK */
\\b 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u0008");
							break;
						case "u":
							string_buffer.append("\u0008");
							break;	
						case "r":
							string_buffer.append("\\b");
							break;
						case "ur":
							string_buffer.append("\\b");
							break;
						case "br":
							string_buffer.append("\\b");
							break;
						default:
							string_buffer.append("\u0008");
							break;	
					}	
			}	
\\f 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u000c");
							break;
						case "u":
							string_buffer.append("\u000c");
							break;	
						case "r":
							System.out.println('3');
							string_buffer.append("\\f");
							break;
						case "ur":
							System.out.println('4');
							string_buffer.append("\\f");
							break;
						case "br":
							System.out.println('5');
							string_buffer.append("\\f");
							break;
						default:
							System.out.println('6');
							string_buffer.append("\u000c");
							break;	
					}	
			}	
\\r 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\r");
							break;
						case "u":
							string_buffer.append("\r");
							break;	
						case "r":
							string_buffer.append("\\r");
							break;
						case "ur":
							string_buffer.append("\\r");
							break;
						case "br":
							string_buffer.append("\\r");
							break;
						default:
							string_buffer.append("\r");
							break;	
					}	
			}

\\t 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\t");
							break;
						case "u":
							string_buffer.append("\t");
							break;	
						case "r":
							string_buffer.append("\\t");
							break;
						case "ur":
							string_buffer.append("\\t");
							break;
						case "br":
							string_buffer.append("\\t");
							break;
						default:
							string_buffer.append("\t");
							break;	
					}	
			}

\\v 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\u000b");
							break;
						case "u":
							string_buffer.append("\u000b");
							break;	
						case "r":
							string_buffer.append("\\v");
							break;
						case "ur":
							string_buffer.append("\\v");
							break;
						case "br":
							string_buffer.append("\\v");
							break;
						default:
							string_buffer.append("\u000b");
							break;	
					}	
			}	

{unicodeescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{unicodeescape32}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{octescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{hexescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-1)){
						case "":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "u":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
						case "r":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "ur":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "br":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						default:
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
					}
						
}

{shortstringchar} {string_buffer.append(yytext());}
{NEWLINE}	{ yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }
<<EOF>> { yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }
.               { yybegin(YYINITIAL); return newSym(sym.ERROR,"Non-ASCII character "+yytext()); }
}

<LONG_STRING_D>{

\"\"\"          { 	yybegin(YYINITIAL);
					string_buffer.append("'");
					StringList.put(string_buffer.toString().hashCode(),string_buffer.toString());
					return newSym(sym.STRING,string_buffer.toString());
				}
\'				{
					string_buffer.append("'");
				}

\"				{
					string_buffer.append('"');
				}				
\\				{
					
					string_buffer.append("\\");

				}

\\\'			{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("'");
							break;
						case "u":
							string_buffer.append("'");
							break;	
						case "r":
							string_buffer.append("\\'");
							break;
						case "ur":
							string_buffer.append("\\'");
							break;
						case "br":
							string_buffer.append("\\'");
							break;
						default:
							string_buffer.append("'");
							break;	
					}
				}
				

\\\"			{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append('"');
							break;
						case "u":
							string_buffer.append('"');
							break;	
						case "r":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "ur":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "br":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						default:
							string_buffer.append('"');
							break;	
					}
				}				
				
\\\\			{		
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\\\");
							break;
						case "u":
							string_buffer.append("\\\\");
							break;	
						case "r":
							string_buffer.append("\\\\\\\\");
							break;
						case "ur":
							string_buffer.append("\\\\\\\\");
							break;
						case "br":
							string_buffer.append("\\\\\\\\");
							break;
						default:
							string_buffer.append("\\\\");
							break;	
					}	
			}

			
\\a 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u0007");
							break;
						case "u":
							string_buffer.append("\u0007");
							break;	
						case "r":
							string_buffer.append("\\a");
							break;
						case "ur":
							string_buffer.append("\\a");
							break;
						case "br":
							string_buffer.append("\\a");
							break;
						default:
							string_buffer.append("\u0007");
							break;	
					}	
			}	
				

\\n 		{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\n");
							break;
						case "u":
							string_buffer.append("\n");
							break;	
						case "r":
							string_buffer.append("\\n");
							break;
						case "ur":
							string_buffer.append("\\n");
							break;
						case "br":
							string_buffer.append("\\n");
							break;
						default:
							string_buffer.append("\n");
							break;	
					}
}					
					/* OK */
\\b 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u0008");
							break;
						case "u":
							string_buffer.append("\u0008");
							break;	
						case "r":
							string_buffer.append("\\b");
							break;
						case "ur":
							string_buffer.append("\\b");
							break;
						case "br":
							string_buffer.append("\\b");
							break;
						default:
							string_buffer.append("\u0008");
							break;	
					}	
			}	
\\f 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u000c");
							break;
						case "u":
							string_buffer.append("\u000c");
							break;	
						case "r":
							System.out.println('3');
							string_buffer.append("\\f");
							break;
						case "ur":
							System.out.println('4');
							string_buffer.append("\\f");
							break;
						case "br":
							System.out.println('5');
							string_buffer.append("\\f");
							break;
						default:
							System.out.println('6');
							string_buffer.append("\u000c");
							break;	
					}	
			}	
\\r 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\r");
							break;
						case "u":
							string_buffer.append("\r");
							break;	
						case "r":
							string_buffer.append("\\r");
							break;
						case "ur":
							string_buffer.append("\\r");
							break;
						case "br":
							string_buffer.append("\\r");
							break;
						default:
							string_buffer.append("\r");
							break;	
					}	
			}

\\t 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\t");
							break;
						case "u":
							string_buffer.append("\t");
							break;	
						case "r":
							string_buffer.append("\\t");
							break;
						case "ur":
							string_buffer.append("\\t");
							break;
						case "br":
							string_buffer.append("\\t");
							break;
						default:
							string_buffer.append("\t");
							break;	
					}	
			}

\\v 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u000b");
							break;
						case "u":
							string_buffer.append("\u000b");
							break;	
						case "r":
							string_buffer.append("\\v");
							break;
						case "ur":
							string_buffer.append("\\v");
							break;
						case "br":
							string_buffer.append("\\v");
							break;
						default:
							string_buffer.append("\u000b");
							break;	
					}	
			}	

{unicodeescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{unicodeescape32}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{octescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{hexescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "u":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
						case "r":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "ur":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "br":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						default:
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
					}
						
}

{longstringchar} {string_buffer.append(yytext());}

{NEWLINE}	{ string_buffer.append(yytext()); }

<<EOF>> { yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }

.               { yybegin(YYINITIAL); return newSym(sym.ERROR,"Non-ASCII character"+yytext()); }

}

<LONG_STRING_S>{

\'\'\'           { 	yybegin(YYINITIAL);
					string_buffer.append("'");
					StringList.put(string_buffer.toString().hashCode(),string_buffer.toString());
					return newSym(sym.STRING,string_buffer.toString());
				}



\'				{
					string_buffer.append(yytext());
				}

\"				{
					string_buffer.append(yytext());
				}				
\\				{
					
					string_buffer.append("\\");

				}

\\\'			{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("'");
							break;
						case "u":
							string_buffer.append("'");
							break;	
						case "r":
							string_buffer.append("\\'");
							break;
						case "ur":
							string_buffer.append("\\'");
							break;
						case "br":
							string_buffer.append("\\'");
							break;
						default:
							string_buffer.append("'");
							break;	
					}
				}
				

\\\"			{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append('"');
							break;
						case "u":
							string_buffer.append('"');
							break;	
						case "r":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "ur":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						case "br":
							string_buffer.append("\\\\");
							string_buffer.append('"');
							break;
						default:
							string_buffer.append('"');
							break;	
					}
				}				
				
\\\\			{		
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\\\");
							break;
						case "u":
							string_buffer.append("\\\\");
							break;	
						case "r":
							string_buffer.append("\\\\\\\\");
							break;
						case "ur":
							string_buffer.append("\\\\\\\\");
							break;
						case "br":
							string_buffer.append("\\\\\\\\");
							break;
						default:
							string_buffer.append("\\\\");
							break;	
					}	
			}

			
\\a 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u0007");
							break;
						case "u":
							string_buffer.append("\u0007");
							break;	
						case "r":
							string_buffer.append("\\a");
							break;
						case "ur":
							string_buffer.append("\\a");
							break;
						case "br":
							string_buffer.append("\\a");
							break;
						default:
							string_buffer.append("\u0007");
							break;	
					}	
			}	
				

\\n 		{	
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\n");
							break;
						case "u":
							string_buffer.append("\n");
							break;	
						case "r":
							string_buffer.append("\\n");
							break;
						case "ur":
							string_buffer.append("\\n");
							break;
						case "br":
							string_buffer.append("\\n");
							break;
						default:
							string_buffer.append("\n");
							break;	
					}
}					
					/* OK */
\\b 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u0008");
							break;
						case "u":
							string_buffer.append("\u0008");
							break;	
						case "r":
							string_buffer.append("\\b");
							break;
						case "ur":
							string_buffer.append("\\b");
							break;
						case "br":
							string_buffer.append("\\b");
							break;
						default:
							string_buffer.append("\u0008");
							break;	
					}	
			}	
\\f 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u000c");
							break;
						case "u":
							string_buffer.append("\u000c");
							break;	
						case "r":
							System.out.println('3');
							string_buffer.append("\\f");
							break;
						case "ur":
							System.out.println('4');
							string_buffer.append("\\f");
							break;
						case "br":
							System.out.println('5');
							string_buffer.append("\\f");
							break;
						default:
							System.out.println('6');
							string_buffer.append("\u000c");
							break;	
					}	
			}	
\\r 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\r");
							break;
						case "u":
							string_buffer.append("\r");
							break;	
						case "r":
							string_buffer.append("\\r");
							break;
						case "ur":
							string_buffer.append("\\r");
							break;
						case "br":
							string_buffer.append("\\r");
							break;
						default:
							string_buffer.append("\r");
							break;	
					}	
			}

\\t 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\t");
							break;
						case "u":
							string_buffer.append("\t");
							break;	
						case "r":
							string_buffer.append("\\t");
							break;
						case "ur":
							string_buffer.append("\\t");
							break;
						case "br":
							string_buffer.append("\\t");
							break;
						default:
							string_buffer.append("\t");
							break;	
					}	
			}

\\v 		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\u000b");
							break;
						case "u":
							string_buffer.append("\u000b");
							break;	
						case "r":
							string_buffer.append("\\v");
							break;
						case "ur":
							string_buffer.append("\\v");
							break;
						case "br":
							string_buffer.append("\\v");
							break;
						default:
							string_buffer.append("\u000b");
							break;	
					}	
			}	

{unicodeescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{unicodeescape32}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{octescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append(yytext().toString());
							break;
						case "u":
							string_buffer.append(yytext().toString());
							break;	
						case "r":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "ur":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						case "br":
							string_buffer.append("\\");
							string_buffer.append(yytext().toString());
							break;
						default:
							string_buffer.append(yytext().toString());
							break;	
					}
						
}

{hexescape}		{
					switch((string_prefix.toString()).substring(0,(string_prefix.toString()).length()-3)){
						case "":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "u":
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
						case "r":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "ur":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						case "br":
							string_buffer.append("\\\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;
						default:
							string_buffer.append("\\u00");
							string_buffer.append(yytext().toString().substring(2,4));
							break;	
					}
						
}

{longstringchar} {string_buffer.append(yytext());}

{NEWLINE}	{ string_buffer.append(yytext()); }

<<EOF>> { yybegin(YYINITIAL); return newSym(sym.ERROR,"EOL while scanning string literal"); }

.               { yybegin(YYINITIAL); return newSym(sym.ERROR,"Non-ASCII character"+yytext()); }
}

