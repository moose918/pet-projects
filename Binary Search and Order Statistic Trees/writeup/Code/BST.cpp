#include <iostream>

/**
 * Part A (i)
 */
class Node {
public:
    int treeLevel = 0;
    int val;
    Node* parent = nullptr;
    Node* left = nullptr;
    Node* right = nullptr;

    Node(int v) : val(v){};
};

class BST{
public:
    int treeHeight = 0;
    Node* root = nullptr;

public:
    BST(){}

};

void preOrderTreeWalk(Node* x) {
    if (x != nullptr) {
        std::cout << " " << x->val << " " ;
        preOrderTreeWalk(x->left);
        preOrderTreeWalk(x->right);
    }
}
void inOrderTreeWalk(Node* x) {
    if (x != nullptr) {
        inOrderTreeWalk(x->left);
        std::cout << " " << x->val << " " ;
        inOrderTreeWalk(x->right);
    }
}
/**
 * Change the parents of node u over to node v
 * @param T
 * @param u
 * @param v
 */
void transplant(BST& T, Node* u, Node* v) {
    if (u->parent == nullptr)
        T.root = v;
    else if (u == u->parent->left)
        u->parent->left = v;
    else
        u->parent->right = v;

    if (v != nullptr)
        v->parent = u->parent;
}
Node* treeMinimum(Node* x) {
    while (x->left != nullptr)
        x = x->left;

    return x;
}
Node* iterativeTreeSearch(Node* x, int keyVal) {
    while (x != nullptr && keyVal != x->val) {
        if (keyVal < x->val)
            x = x->left;
        else
            x = x->right;
    }
    return x;
}

void treeInsert(BST& T, int newVal) {
    Node* z = new Node(newVal);
    Node* y = nullptr;
    Node* x = T.root;

    while (x != nullptr) {
        y = x;
        if (z->val < x->val)
            x = x->left;
        else
            x = x->right;
    }

    z->parent = y;
    if (y != nullptr)
        z->treeLevel = y->treeLevel + 1;

    if (y == nullptr) {
        T.root = z;
    }
    else if (z->val < y->val) {
        y->left = z;
    }
    else {
        y->right = z;
    }
    // Update the tree height if there is a new level in it
    if (T.treeHeight <= z->treeLevel) {
        T.treeHeight = z->treeLevel + 1;
    }
}

void treeDelete(BST& T, Node* z) {

    if (z == nullptr)
        return;

    if (z->left == nullptr) {
        transplant(T, z, z->right);
    }
    else if (z->right == nullptr) {
        transplant(T, z, z->left);
    }
    else {
        Node* y = treeMinimum(z->right);

        if (y->parent != z) {
            transplant(T, y, y->right);
            y->right = z->right;
            y->right->parent = y;
        }
        transplant(T, z, y);
        y->left = z->left;
        y->left->parent = y;
    }

    delete z;
}