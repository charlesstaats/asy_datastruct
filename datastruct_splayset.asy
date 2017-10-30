private string splaytreecode = "
SortedSet_\type GetSpayTree_\type(
    bool leq(\type a, \type b),
    \type emptyresponse,
    bool isemptyresponse(\type)) {
  bool equal(\type a, \type b) {
    return leq(a, b) && leq(b, a);
  }
  bool gt(\type a, \type b) {
    return !leq(b, a);
  }
  bool lt(\type a, \type b) {
    return gt(b, a);
  }
  bool geq(\type a, \type b) {
    return leq(b, a);
  }

  struct treenode {
    treenode leftchild;
    treenode rightchild;
    \type value;
    void operator init(\type value) {
      this.value = value;
    }

    void inOrder(void process(\type)) {
      if (leftchild != null)
        leftchild.inOrder(process);
      process(value);
      if (rightchild != null)
        rightchild.inOrder(process);
    }

    IteratorAction inOrder(IteratorAction process(\type)) {
      if (leftchild != null) {
        if (leftchild.inOrder(process).stop) return IteratorAction.Quit;
      }
      if (process(value).stop) return IteratorAction.Quit;
      if (rightchild != null) {
        if (rightchild.inOrder(process).stop) return IteratorAction.Quit;
      }
      return IteratorAction.Continue;
    }
  }

  treenode splay(treenode[] ancestors) {
    if (ancestors.length == 0) return null;

    treenode root = ancestors[0];
    treenode current = ancestors.pop();
    
    while (ancestors.length >= 2) {
      treenode parent = ancestors.pop();
      treenode grandparent = ancestors.pop();

      if (ancestors.length > 0) {
        treenode greatparent = ancestors[-1];
        if (greatparent.leftchild == grandparent) {
          greatparent.leftchild = current;
        } else greatparent.rightchild = current;
      }

      bool currentside = (parent.leftchild == current);
      bool grandside = (grandparent.leftchild == parent);

      if (currentside == grandside) { // zig-zig
        if (currentside) { // both left
          treenode B = current.rightchild;
          treenode C = parent.rightchild;

          current.rightchild = parent;
          parent.leftchild = B;
          parent.rightchild = grandparent;
          grandparent.leftchild = C;
        } else { // both right
          treenode B = parent.leftchild;
          treenode C = current.leftchild;

          current.leftchild = parent;
          parent.leftchild = grandparent;
          parent.rightchild = C;
          grandparent.rightchild = B;
        }
      } else { // zig-zag
        if (grandside) {  // left-right
          treenode B = current.leftchild;
          treenode C = current.rightchild;

          current.leftchild = parent;
          current.rightchild = grandparent;
          parent.rightchild = B;
          grandparent.leftchild = C;
        } else { //right-left
          treenode B = current.leftchild;
          treenode C = current.rightchild;

          current.leftchild = grandparent;
          current.rightchild = parent;
          grandparent.rightchild = B;
          parent.leftchild = C;
        }
      }
    }

    if (ancestors.length > 0) {
      ancestors.pop();
      if (current == root.leftchild) {
        treenode B = current.rightchild;
        current.rightchild = root;
        root.leftchild = B;
      } else {
        treenode B = current.leftchild;
        current.leftchild = root;
        root.rightchild = B;
      }
    }

    return current;
  }

  SortedSet_\type toreturn;
  treenode root = null;
  int size = 0;

  toreturn.isemptyresponse = isemptyresponse;
  toreturn.size = new int() {
    return size;
  };

  toreturn.contains = new bool(\type item) {
    treenode[] parentstack = new treenode[0];
    parentstack.cyclic = true;
    parentstack.push(root);
    while (true) {
      treenode current = parentstack[-1];
      if (current == null) {
        parentstack.pop();
        root = splay(parentstack);
        return false;
      }
      if (lt(item, current.value)) {
        parentstack.push(current.leftchild);
      } else if (lt(current.value, item)) {
        parentstack.push(current.rightchild);
      } else break;
    }
    root = splay(parentstack);
    return true;
  };

  toreturn.after = new \type(\type item) {
    if (root == null) return emptyresponse;
    treenode[] parentstack = new treenode[0];
    parentstack.cyclic = true;
    parentstack.push(root);
    treenode upper = null;
    while (true) {
      treenode current = parentstack[-1];
      if (current == null) {
        parentstack.pop();
        root = splay(parentstack);
        break;
      } else if (gt(current.value, item)) {
        parentstack.push(current.leftchild);
        upper = current;
      } else /* if (leq(current.value, item)) */ {
        parentstack.push(current.rightchild);
      }
    }
    return (upper == null ? emptyresponse : upper.value);
  };

  toreturn.before = new \type(\type item) {
    if (root == null) return emptyresponse;
    treenode[] parentstack = new treenode[0];
    parentstack.cyclic = true;
    parentstack.push(root);
    treenode lower = null;
    while (true) {
      treenode current = parentstack[-1];
      if (current == null) {
        parentstack.pop();
        root = splay(parentstack);
        break;
      } else if (geq(current.value, item)) {
        parentstack.push(current.leftchild);
      } else /* if (lt(current.value, item)) */ {
        parentstack.push(current.rightchild);
        lower = current;
      }
    }
    return (lower == null ? emptyresponse : lower.value);
  };

  toreturn.min = new \type() {
    treenode[] parentstack = new treenode[0];
    parentstack.cyclic = true;
    parentstack.push(root);
    while (parentstack[-1] != null)
      parentstack.push(parentstack[-1].leftchild);
    parentstack.pop();
    root = splay(parentstack);
    return root.value;
  };

  toreturn.max = new \type() {
    treenode[] parentstack = new treenode[0];
    parentstack.cyclic = true;
    parentstack.push(root);
    while (parentstack[-1] != null)
      parentstack.push(parentstack[-1].rightchild);
    parentstack.pop();
    root = splay(parentstack);
    return root.value;
  };
  /*
   * returns true iff the tree was modified
   */
  toreturn.insert = new bool(\type value) {
    if (root == null) {
      root = treenode(value);
      return true;
    }
    treenode[] ancestors = new treenode[0];
    ancestors.cyclic = true;
    ancestors.push(root);

    bool toReturn = false;
    
    while (!toReturn) {
      treenode current = ancestors[-1];
      if (value < current.value) {
        if (current.leftchild == null) {
          current.leftchild = treenode(value);
          toReturn = true;
        }
        ancestors.push(current.leftchild);
      } else if (current.value < value) {
        if (current.rightchild == null) {
          current.rightchild = treenode(value);
          toReturn = true;
        }
        ancestors.push(current.rightchild);
      } else {
        root = splay(ancestors);
        return false;
      }
    }

    root = splay(ancestors);
    return true;
  };

  /*
   * returns true iff the tree was modified
   */
  toreturn.delete = new bool(\type value) {
    treenode[] ancestors = new treenode[0];
    ancestors.cyclic = true;
    ancestors.push(root);

    while (true) {
      treenode current = ancestors[-1];
      if (current == null) {
        ancestors.pop();
        root = splay(ancestors);
        return false;
      }
      if (value < current.value)
        ancestors.push(current.leftchild);
      else if (current.value < value)
        ancestors.push(current.rightchild);
      else break;
    }

    treenode toDelete = ancestors.pop();
    treenode parent = null;
    if (ancestors.length > 0) parent = ancestors[-1];
    
    if (toDelete.leftchild == null) {
      if (parent != null)  {
        if (parent.rightchild == toDelete) parent.rightchild = toDelete.rightchild;
        else parent.leftchild = toDelete.rightchild;
      } else root = toDelete.rightchild;
    } else if (toDelete.rightchild == null) {
      if (parent == null) root = toDelete.leftchild;
      else if (parent.rightchild == toDelete) parent.rightchild = toDelete.leftchild;
      else parent.leftchild = toDelete.leftchild;
    } else {
      treenode[] innerStack = new treenode[0];
      innerStack.cyclic = true;
      treenode current = toDelete.rightchild;
      while (current != null) {
        innerStack.push(current);
        current = current.leftchild;
      }
      toDelete.rightchild = splay(innerStack);
      toDelete.value = toDelete.rightchild.value;
      toDelete.rightchild = toDelete.rightchild.rightchild;
    }

    if (parent != null) root = splay(ancestors);
    return true;
    
  };

  toreturn.iterable.foreach = new void(IteratorAction process(\type)) {
    if (root == null) return;
    root.inOrder(process); 
  };
  
  toreturn.iterable.foreach = new void(void process(\type)) {
    if (root == null) return;
    root.inOrder(process); 
  };

  return toreturn;
}
//";
