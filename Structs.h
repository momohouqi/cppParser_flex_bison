#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>

using namespace std;


class Node{
public:
    typedef boost::shared_ptr<Node> Ptr;
    enum NodeType {
        ID = 0,
        ARG,
        ARGS,
        FUNC_DECLARE,
        PATH,
        INCLUDE,
        INCLUDES
    };

    Node(const char* s, const NodeType type);
    void addString(const char* s);
    virtual string str() const;
    NodeType type() const;
    void addChild(const Ptr &child);
    void addChild(const Node* child);
    std::vector<Node*> children() const;
private:
    string m_str;
    NodeType m_type;
    std::vector<Node*> m_children;
};
// ===================================================
class ArgsNode : public Node {
public:
    ArgsNode();
    virtual string str() const;
};
// ===================================================
class FuncDeclareNode : public Node {
public:
    FuncDeclareNode();
    virtual string str() const;
    void setReturnType(Node *returnType) {m_returnType = returnType;}
    void setFuncName(Node *funcName) {m_funcName = funcName;}
    void setArgs(Node *args) {m_args = args;}
private:
    Node *m_returnType;
    Node *m_funcName;
    Node *m_args;
};
// ===================================================
class NodesFactory {
public:
    static Node* createNode(const char *s, const Node::NodeType type = Node::ID);
    static vector<Node::Ptr> s_nodes;
};

