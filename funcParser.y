%{
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <cstdio>
#include <boost/shared_array.hpp>
#include <boost/shared_ptr.hpp>
#include "Structs.h"

using namespace std;
extern "C" int yyparse();
extern "C" int yylex();
extern "C" FILE *yyin;

void yyerror(const char* s);
extern int yylineno;

#define YYDEBUG 1
%}


%union {
    int ival;
    char* sval;
    Node* node;
};

%token BRACE_LEFT
%token BRACE_RIGHT
%token PARENTHESIS_LEFT
%token PARENTHESIS_RIGHT
%token VOID
%token INT
%token QUOTE
%token ANGLE_LEFT
%token ANGLE_RIGHT
%token INCLUDE
%token SEMICOLON
%token <sval> IDENTIFIER
%token <sval> DATA_TYPE

%type <sval> body;
%type <node> args;
%type <node> arg;
%type <node> function_declared;
%type <node> path;
%type <sval> head;
%type <sval> includes;
%type <sval> include;

%%

file: head body { cout << " ===rule0:file" << endl; }
    ;
head:
        {}
    | includes { cout << " ===rule1:head" << endl;}
    ;
includes:
        {}
        | includes include { cout << "==rule2:includes" << endl;}
        ;
include:
       '#' INCLUDE QUOTE path QUOTE {cout << "rule3:include:" << $4->str() << endl;}
       | '#' INCLUDE ANGLE_LEFT path ANGLE_RIGHT {cout << "rule4:include:" << $4->str() << endl;}
       ;
path: IDENTIFIER {
        $$ = NodesFactory::createNode($1);
        cout << "==rule5:" << $1<< endl;
      }
    | path '.' IDENTIFIER {
        $$->addString(".");
        $$->addString($3);
        cout << "==rule6:" << $1 << "." << $3<< endl;
      }
    | path '/' IDENTIFIER {
        $$->addString("/");
        $$->addString($3);
        cout << "==rule7" << endl;
      }
    ;

body:
        { cout << "==rule19: empty" << endl;}
    | body part
    ;
part:
    function_declared {cout << "==rule 21:"  << endl;}
    ;
function_declared:
    DATA_TYPE IDENTIFIER PARENTHESIS_LEFT args PARENTHESIS_RIGHT ';' {
        //cout << "==rele 22: function: "<< $1 << " " << $2 << "(" << $4->str() << ")"<< endl;
        Node *returnType = NodesFactory::createNode($1, Node::ID);
        Node *funcName = NodesFactory::createNode($2, Node::ID);
        $$ = NodesFactory::createNode("", Node::FUNC_DECLARE);
        FuncDeclareNode *funcNode = static_cast<FuncDeclareNode*>($$);
        funcNode->setReturnType(returnType);
        funcNode->setFuncName(funcName);
        funcNode->setArgs($4);

        cout << "==rele 22: function: "<< $$->str() << endl;
    }
    ;
args:
    {}
    | arg {
        $$ = NodesFactory::createNode("", Node::ARGS);
        $$->addChild($1);
        cout << "==rule24:"<< $1->str() << endl;
      }
    | args ',' arg {
        $$->addChild($3);
        cout << "==rule24:" << endl;
      }
    ;
arg:
     DATA_TYPE {
         $$ = NodesFactory::createNode($1, Node::ARG);
         cout << "==rule25" << endl;
     }
   | DATA_TYPE IDENTIFIER {
        $$ = NodesFactory::createNode($1, Node::ARG);
        $$->addString(" ");
        $$->addString($2);
        cout << "==rule26:" << endl;
     }
   | DATA_TYPE '*' IDENTIFIER {
        $$ = NodesFactory::createNode($1, Node::ARG);
        $$->addString(" *");
        $$->addString($3);
        cout << "==rule27:" << endl;
     }

%%

void print(const char* s) {
}

void yyerror(const char* s) {
    cout << "yyerror: " << s << " line:"<< yylineno << std::endl;
    //exit(-1);
}

boost::shared_array<char> readFile(const string& path) {
     boost::shared_array<char> buff;

    ifstream file(path.c_str(), ios::in);
    if (!file) {
        cout << "open file fail!" << endl;
        return buff;
    }

    file.seekg(0, ios::end);
    size_t size = file.tellg();
    buff.reset(new char[size + 1]());

    file.seekg(0, ios::beg);
    file.read(buff.get(), size);
    file.close();

    return buff;
}

int main(int arg, char* argv[]) {
    if (arg < 2) {
        cout << "Need a file path" << endl;
        return -1;
    }

    const string path(argv[1]);
    
    boost::shared_array<char> buff1 = readFile(path);
    if (buff1)
        cout << "File content1:" << endl << buff1.get() << endl;
    else
        cout << "read fail!" << endl;

    FILE *myFile = fopen(path.c_str(), "r");
    if (!myFile) {
        cout << "Open file fail!" << endl;
        return -1;
    }
    
    cout << "---parse----" << endl;
    yyin = myFile;
    do {
        yyparse();
    } while(!feof(yyin));

    return 0;
}
