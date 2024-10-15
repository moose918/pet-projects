#include <iostream>

/**
 * Part A (i)
 */
class OS_Node {
public:
    int size = 0;
    int treeLevel = 0;
    int val;
    OS_Node* parent = nullptr;
    OS_Node* left = nullptr;
    OS_Node* right = nullptr;

    OS_Node(int v) : val(v){};
};

class OS_BST{
public:
    int treeHeight = 0;
    OS_Node* root = nullptr;

public:
    OS_BST(){}

};

void insertUpdateSize(OS_Node *pOS_Node);

void preOrderTreeWalk(OS_Node* x) {
    if (x != nullptr) {
        std::cout << " " << x->val << ":" << x->size << " " ;
        preOrderTreeWalk(x->left);
        preOrderTreeWalk(x->right);
    }
}
void inOrderTreeWalk(OS_Node* x) {
    if (x != nullptr) {
        inOrderTreeWalk(x->left);
        std::cout << " " << x->val << ":" << x->size << " " ;
        inOrderTreeWalk(x->right);
    }
}

/**
 * Change the parents of node u over to node v
 * @param T
 * @param u
 * @param v
 */
void transplant(OS_BST& T, OS_Node* u, OS_Node* v) {
    if (u->parent == nullptr)
        T.root = v;
    else if (u == u->parent->left)
        u->parent->left = v;
    else
        u->parent->right = v;

    if (v != nullptr)
        v->parent = u->parent;
}
OS_Node* treeMinimum(OS_Node* x) {
    while (x->left != nullptr)
        x = x->left;

    return x;
}
OS_Node* iterativeTreeSearch(OS_Node* x, int keyVal) {
    while (x != nullptr && keyVal != x->val) {
        if (keyVal < x->val)
            x = x->left;
        else
            x = x->right;
    }
    return x;
}

void treeInsert(OS_BST& T, int newVal) {
    OS_Node* z = new OS_Node(newVal);
    OS_Node* y = nullptr;
    OS_Node* x = T.root;

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
    if (T.treeHeight <= z->treeLevel) {
        T.treeHeight = z->treeLevel + 1;
    }

    insertUpdateSize(z);
}

/**
 * Update the sizes of the ancestors of the new child
 * @param pOS_Node
 */
void insertUpdateSize(OS_Node *pOS_Node) {
    while (pOS_Node != nullptr) {
        pOS_Node->size = (pOS_Node->left == nullptr ? 0 : pOS_Node->left->size) + (pOS_Node->right == nullptr ? 0 : pOS_Node->right->size) + 1;
        pOS_Node = pOS_Node->parent;
    }
}
/**
 * Update the sizes of the ancestors of the removed child
 * @param pOS_Node
 */
void deleteUpdateSize(OS_Node *pOS_Node) {
    while (pOS_Node != nullptr) {
        --pOS_Node->size;
        pOS_Node = pOS_Node->parent;
    }
}

void osTreeDelete(OS_BST& T, OS_Node* z) {
    if (z == nullptr)
        return;

    if (z->left == nullptr) {
        deleteUpdateSize(z);

        transplant(T, z, z->right);
    }
    else if (z->right == nullptr) {
        deleteUpdateSize(z);

        transplant(T, z, z->left);
    }
    else {
        OS_Node* y = treeMinimum(z->right);

        // The sizes of the ancestors of the successor need to be updated
        deleteUpdateSize(y);

        if (y->parent != z) {

            transplant(T, y, y->right);
            y->right = z->right;
            y->right->parent = y;

        }

        transplant(T, z, y);
        y->left = z->left;
        y->left->parent = y;

        // Update the size of the successor in its new position
        y->size = (y->left == nullptr ? 0 : y->left->size) + (y->right == nullptr ? 0 : y->right->size) + 1;
    }

    delete z;
}

/**
 * Performs a search for the node of a particular rank
 * @param x
 * @param iRank
 * @return
 */
OS_Node * osSearch(OS_Node* x, int iRank) {
    int rankX = (x->left == nullptr ? 0 : x->left->size) + 1;
    if (iRank == rankX)
        return x;
    else if (iRank < rankX)
        return osSearch(x->left, iRank);
    else
        return osSearch(x->right, iRank - rankX);
}

/**
 * Calculates the rank of a given node
 * @param T
 * @param x
 * @return
 */
int osRank(OS_BST T, OS_Node* x) {
    int rank = (x->left == nullptr ? 0 : x->left->size) + 1;
    OS_Node* y = x;

    while (y != T.root) {
        if (y == y->parent->right) {
            rank += (y->parent->left == nullptr ? 0 : y->parent->left->size) + 1;
        }
        y = y->parent;
    }

    return rank;
}
