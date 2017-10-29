// FOR TESTING ONLY
// This file supplies a reference implementation for a SortedSet. It is intended to
// be simple (hence easy to make bug-free) but not remotely efficient. Thus it is
// useful to validate a more reasonable SortedSet implementation against.

private string definesortedsetimpl = //"
SortedSet_\type GetBadSortedSet_\type(bool areequal(\type a, \type b)=operator==) {
  SortedSet_\type toreturn;
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
//";

void SupplyBadSortedSetImpl(string type) {
  eval(replace(definesortedsetimpl, "\type", type), true);
}
