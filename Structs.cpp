#include "Structs.h"
#include <boost/foreach.hpp>

Node::Node(const char* s, const NodeType type)
    : m_str(s), m_type(type) {
}

void Node::addString(const char* s) {
    m_str += s;
}

string Node::str() const {
    return m_str;
}

Node::NodeType Node::type() const {
    return m_type;
}

std::vector<Node*> Node::children() const {
    return m_children;
}

void Node::addChild(const Ptr &child) {
    m_children.push_back(child.get());
}

void Node::addChild(const Node* child) {
    m_children.push_back(const_cast<Node*>(child));
}
// ===================================================
ArgsNode::ArgsNode()
    : Node("", Node::ARGS){
}

string ArgsNode::str() const {
    string re;
    BOOST_FOREACH(const Node* arg, children()) {
        re += arg->str() + ", ";
    }
    if (!re.empty()) {
        re.erase(re.size() - 2, 2);
    }
    return re;
}
// ==================================================
FuncDeclareNode::FuncDeclareNode()
    : Node("", FUNC_DECLARE) {
}

string FuncDeclareNode::str() const {
    return m_returnType->str() + " " + m_funcName->str() + "(" + m_args->str() + ")";
}
// ===================================================
vector<Node::Ptr> NodesFactory::s_nodes;
Node* NodesFactory::createNode(const char *s, const Node::NodeType type) {
    Node::Ptr ptr;
    switch (type) {
        case Node::ARGS:
            ptr.reset(new ArgsNode());
            break;
        case Node::FUNC_DECLARE:
            ptr.reset(new FuncDeclareNode());
            break;
        default:
            ptr.reset(new Node(s, type));
            break;
    }
    s_nodes.push_back(ptr);
    return ptr.get();
}
