private string definesingletypeinterfaces = "
struct Iterable_\type {
  void foreach(IteratorAction process(\type item));
  void foreach(void process(\type item)) {
    foreach(new IteratorAction(\type Item) {
	process(Item);
	return IteratorAction.Continue;
      });
  }
}

\type[] operator cast(Iterable_\type iterable) {
  \type[] buffer;
  iterable.foreach(new void(\type item) {
      buffer.push(item);
    });
  return buffer;
}

bool operator==(Iterable_\type a, Iterable_\type b) {
  return all((\type[])a == (\type[])b);
}
bool operator!=(Iterable_\type a, Iterable_\type b) {
  return !(a == b);
}

bool operator==(Iterable_\type a, \type[] b) {
  bool areequal = true;
  int ii = 0;
  a.foreach(new IteratorAction(\type item) {
    if (ii >= b.length || item != b[ii]) {
      areequal = false;
      return IteratorAction.Quit;
    }
    return IteratorAction.Continue;
  });
  return ii == b.length && areequal;
}
bool operator!=(Iterable_\type a, \type[] b) { return !(a == b); }
bool operator==(\type[] a, Iterable_\type b) { return b == a; }
bool operator!=(\type[] a, Iterable_\type b) { return !(b == a); }

struct SortedSet_\type {
  Iterable_\type iterable;
  bool isemptyresponse(\type item);
  int size();
  bool empty() { return size() == 0; }
  bool contains(\type item);
  \type after(\type item);   // Returns the least element > item, or emptyresponse if there is no such element.
  \type before(\type item);  // Returns the greatest element < item, or emptyresponse if there is no such element.
  \type firstGEQ(\type item) { return contains(item) ? item : after(item); }
  \type firstLEQ(\type item) { return contains(item) ? item : before(item); }
  \type min();               // Returns emptyresponse if collection is empty.
  \type max();               // Returns emptyresponse if collection is empty.
  bool insert(\type item);   // Returns true iff the collection is modified.
  bool delete(\type item);   // Returns true iff the collection is modified.
  void foreach(IteratorAction process(\type item)) { iterable.foreach(process); }
  void foreach(void process(\type item)) { iterable.foreach(process); }
}

Iterable_\type operator cast(SortedSet_\type data) { return data.iterable; }

\type[] operator cast(SortedSet_\type data) { return data.iterable; }

// Low-performing implementation, for testing purposes only
/*
Set_\type GetBadSet_\type(bool areequal(\type a, \type b)=operator==) {
  Set_\type toreturn;
  \type[] buffer;
  
  toreturn.iterable.foreach = new void(IteratorAction process(\type)) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      IteratorAction action = process(buffer[ii]);
      if (action.remove) {
	buffer.delete(ii);
	--ii;
      }
      if (action.stop)
	break;
    }
  };
  
  toreturn.iterable.foreach = new void(void process(\type)) {
    for (\type item : buffer) {
      process(item);
    }
  };
  
  toreturn.size = new int() { return buffer.length; };

  toreturn.contains = new bool(\type item) {
    for (\type possibility : buffer) {
      if (areequal(possibility, item)) return true; 
    }
    return false;
  };

  toreturn.insert = new bool(\type item) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      if (areequal(buffer[ii], item)) return false;
    }
    buffer.push(item);
    return true;
  };

  toreturn.delete = new bool(\type item) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      if (areequal(buffer[ii], item)) {
	buffer.delete(ii);
	return true;
      }
    }
    return false;
  };

  return toreturn;
}
*/
";

// An IteratorAction is immutable once constructed.
struct IteratorAction {
  restricted bool remove;
  restricted bool stop;
  void operator init(bool remove=false, bool stop=false) {
    this.remove = remove;
    this.stop = stop;
  }
  // Since an IteratorAction is immutable, externally visible
  // constants of type IteratorAction are reasonable.
  restricted static IteratorAction Continue = IteratorAction();
  restricted static IteratorAction Remove = IteratorAction(remove=true);
  restricted static IteratorAction Quit = IteratorAction(stop=true);
  restricted static IteratorAction RemoveAndQuit =
    IteratorAction(remove=true, stop=true);
}


void DefineInterfaces(string type) {
  eval(replace(definesingletypeinterfaces, "\type", type), true);
}
