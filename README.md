
# Binary Search Tree

Binary Search Tree implementation done by ruby





## Methods

- #build_tree method which takes an array of data and turns it into a balanced binary tree full of Node objects appropriately placed.  
- #insert method which accepts a value to insert it into the tree.  
- #delete method which accepts a value to remove it from the tree.  
- #find method which accepts a value and returns the node with the given value.  
- #level_order method which accepts a block. This method traverses the tree in breadth-first level order and yield each node to the provided block. if no block is provided it will return an array of values. (#level_method_rec does the same but recursively). 
- #inorder, #preorder, and #postorder methods that accepts a block. Each method traverses the tree in their respective depth-first order and yield each node to the provided block. if no block is provided it will return an array of values.  
- #height method which accepts a node and returns its height.  
- #depth method which accepts a node and returns its depth.  
- #balanced? method which checks if the tree is balanced.  
- #rebalance method which rebalances an unbalanced tree.  
