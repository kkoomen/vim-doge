// Lazy pre-order traversal over arbitrary tree-sitter trees.

use tree_sitter::{Node, TreeCursor};

pub struct PreOrder<'a> {
    cursor: TreeCursor<'a>,
    done: bool,
}

impl<'a> PreOrder<'a> {
    pub fn new(cursor: TreeCursor<'a>) -> Self {
        Self {
            cursor,
            done: false,
        }
    }
}

// Traverse the tree in root-left-right fashion.
impl<'a> Iterator for PreOrder<'a> {
    type Item = Node<'a>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.done {
            return None;
        }

        // Capture the root node.
        let node = self.cursor.node();

        // If this node has a child, move there and return the root, or
        // if this node has a sibling, move there and return the root.
        if self.cursor.goto_first_child() || self.cursor.goto_next_sibling() {
            return Some(node);
        }

        loop {
            // We are done retracing all the way back to the root node.
            if !self.cursor.goto_parent() {
                self.done = true;
                break;
            }

            if self.cursor.goto_next_sibling() {
                break;
            }
        }

        Some(node)
    }
}
