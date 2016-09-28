# LexerParserPython
This is a simple java-cup parser for Python 2.7 programs, It shows the sintax abstract tree of your python program.
There are two main parts:

  -The Lexer (Jflex: http://www.jflex.de)
  
  -The Parser (Java-Cup: http://www.cs.princeton.edu/~appel/modern/java/CUP/)
  
<h1> Compile </h1>

On first usage:

```
 javac com/mxgraph/*/*.java
 javac java_cup/runtime/*.java
```

In order to modify somethings in the Lexer you will need to download Jflex and execute the follow command:
  ```
 jflex python.jflex
  ```
  
To modify the Parser and compile everythings you will need to execute:



  ```
 java -jar java-cup-11a.jar -expect 1000 -interface -parser Parser python.cup
 javac -cp "java-cup-11a.jar:jgraphx.jar" *.java
  ```
  
<h1>Usage</h1>

Lexer:

```
syrion:LexerParserPython r00t$ java PythonLexerTest input.py 
< IDENT ,a>  at line 0, column 0
< EQ >  at line 0, column 2
< STRING ,'Hello World'>  at line 0, column 16
< NEWLINE >  at line 0, column 17
< PRINT >  at line 1, column 0
< IDENT ,a>  at line 1, column 6
```

Parser:

```
syrion:LexerParserPython r00t$ java Parser input.py
Start:


Finish
Python_program 
	|_= 
	|_	|_a 
	|_	|_'Hello World' 
	|_Print 
	|_	|_a 
```



 

 

