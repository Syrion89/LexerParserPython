/****
 *
 * This is a simple stand-alone testing program for the Python lexer defined in
 * PythonLexer.JFLex.  The main method accepts an input file as its first
 * command-line argument.  It then calls the lexer's next_token method with an
 * input reader for that file.  The value of each Symbol returned by next_token
 * is printed to stanard output.
 *                                                                      <p>
 * The following command-line invocation will read in the test program in the
 * file "lexer-test.p" and print out each token found in that file:
 *
 *     java PythonLexerTest lexer-test.p
 *
 */

import java.io.*;
import java.util.HashMap;
import java_cup.runtime.*;

public class PythonLexerTest {

	/* usato solo per poter stampare la coppia <Nome Token, Attributo> */
	private static final Integer[] TOKEN_IDS = new Integer[] {46, 6, 18, 51, 54, 70, 71, 86, 29, 25, 69, 56, 24, 28, 47, 84, 75, 79, 48, 60, 85, 66, 89, 13, 42, 53, 82, 65, 91, 76, 12, 34, 83, 26, 11, 59, 93, 2, 92, 36, 45, 9, 15, 38, 4, 80, 39, 90, 88, 50, 61, 32, 77, 3, 17, 74, 43, 30, 41, 14, 31, 8, 68, 95, 81, 64, 57, 0, 62, 72, 87, 52, 21, 78, 23, 40, 22, 27, 35, 1, 16, 10, 20, 63, 37, 7, 73, 44, 19, 94, 58, 67, 5, 55, 33, 49};
	private static final String[] TOKEN_NAMES = new String[] { " AT "," AS "," FROM "," B_XOR "," GT "," ARROW "," PLUS_EQ "," NEWLINE "," RAISE "," NONLOCAL "," SEMI "," GET "," LAMBDA "," PASS "," BLS "," INDENT "," F_DIV_EQ "," B_XOR_EQ "," BRS "," COMMA "," DEDENT "," RBRACE "," NOT_IN "," ELIF "," POW "," LT "," POW_EQ "," LBRACE "," LONG_INT "," MOD_EQ "," DEL "," YIELD "," FALSE "," NOT "," DEF "," NEQQ "," IMAG_NUMB "," ERROR "," FLOAT "," EQ "," MOD "," CLASS "," EXCEPT "," EXJOIN "," TRUE "," BRS_EQ "," PLUS "," IS_NOT "," EXEC "," B_OR "," LPAR "," WHILE "," B_AND_EQ "," NONE "," FOR "," DIV_EQ "," DIV "," RETURN "," MULT "," ELSE "," TRY "," BREAK "," DOT "," INT "," BLS_EQ "," RSB "," EQEQ "," EOF "," RPAR "," MINUS_EQ "," PRINT "," B_O_COMP "," IMPORT "," B_OR_EQ "," IS "," MINUS "," IN "," OR "," IDENT "," error "," FINALLY "," CONTINUE "," IF "," LSB "," COLON "," ASSERT "," MULT_EQ "," F_DIV "," GLOBAL "," STRING "," NEQ "," EXLINE "," AND "," LET "," WITH "," B_AND "};

	public static void main(String[] args) {
		HashMap<Integer, String> tokenNames = new HashMap<Integer, String>();
		for (int i = 0; i < TOKEN_IDS.length; i++)
			tokenNames.put(TOKEN_IDS[i], TOKEN_NAMES[i]);

		Symbol sym;
		try {
			Lexer lexer = new Lexer(new FileReader(args[0]));

			for (sym = lexer.next_token(); sym.sym != 0; sym = lexer.next_token()) {
        /* stampa della coppia <Nome Token, Attributo> e posizione di linea e colonna */
      	System.out.println("<" + tokenNames.get(sym.sym) + (sym.value == null ? "" : "," + sym.value)
						+ ">  at line " + sym.left + ", column " + sym.right);
      					
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}


}
