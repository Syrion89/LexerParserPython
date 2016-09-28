jflex python.jflex
java -jar java-cup-11a.jar -expect 1000 -interface -parser Parser python.cup
javac -cp "java-cup-11a.jar:jgraphx.jar" *.java