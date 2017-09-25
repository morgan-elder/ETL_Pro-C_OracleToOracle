#include <stdlib.h>
#include <string.h>
#include <stdlib.h>
#include "BinTree.h"

/******************************************************
 * Inserts the input character string into a tree.    *
 * Returns the current node if the string is already  *
 * in the tree. Otherwise it willl insert the string  *
 * into the tree and return the new node.             *
 ******************************************************/
node *TreeInsert(char *str,int length,node *root)
{
    node *current;
    node *parent;
    node *child;

    current = root;
    parent = 0;

	printf("%s\n",str);
	/*  Find the parent of child node  */
    while(current)
    {
        if(strncmp(str,current->str,length) == 0)
        {
            return(current);
        }
        parent = current;

        if(strncmp(str,current->str,length) < 0)
            current = current->left;
        else
            current = current->right;
    }

    /*  New Node  */
    if((child = (node *) malloc(sizeof(*child))) == 0)
    {
        printf("Error in allocating memory for node\n");
        exit(2);
    }

    strncpy(child->str,str,length);
    child->str[length] = '\0';
    child->parent = parent;
    child->left = NULL;
    child->right = NULL;

    /*  Insert the child node into the tree  */
    if(parent)
    {
		printf("\tParent (%s)\n\tChild  (%s)\n",parent->str,child->str);
        if(strncmp(child->str,parent->str,length) < 0)
            parent->left = child;
        else
            parent->right = child;
    }
    else
        root = child;

    return(child);
}

/********************************************
 * Searches through the tree to find the    *
 * input character string.  If found, the   *
 * pointer to the current node is returned. *
 * If not found, return 0.                  *
 ********************************************/
node *TreeFind(char *str,int length,node *root)
{
    node *current;

    current = root;
	printf("Current str is %s\n",current->str);
	printf("Str is %s, Length is %d\n",str,length);
	while(current != NULL)
    {
		printf("Comparing:\n'%s'\n'%s'\n",str,current->str);
		if(strncmp(str,current->str,length) == 0)
            return(current);
        else
        {
            if(strncmp(str,current->str,length) < 0)
                current = current->left;
            else
                current = current->right;
        }
    }

    return(0);
}

