CC=g++
OBJECT=main

$(OBJECT): funcParser.tab.o lex.yy.o Structs.o
	$(CC) funcParser.tab.o lex.yy.o Structs.o -lfl -I /usr/local/boost_1_64_0 -o $(OBJECT)

Structs.o: Structs.cpp
	$(CC) -c Structs.cpp -I /usr/local/boost_1_64_0

funcParser.tab.o: funcParser.tab.c
	$(CC) -c funcParser.tab.c -I /usr/local/boost_1_64_0

funcParser.tab.c: funcParser.y
	bison -d funcParser.y

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

lex.yy.c: func.lex
	flex func.lex

clean:
	@rm -f $(OBJECT) *.o funcParser.tab.c lex.yy.c funcParser.tab.h
