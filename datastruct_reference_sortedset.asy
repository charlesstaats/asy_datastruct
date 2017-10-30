private string definesortedsetimpl = "
// FOR TESTING ONLY
// This file supplies a reference implementation for a SortedSet. It is intended to
// be simple (hence easy to make bug-free) but not remotely efficient. Thus it is
// useful to validate a more reasonable SortedSet implementation against.

SortedSet_\type GetBadSortedSet_\type(
    bool leq(\type a, \type b),
    \type emptyresponse,
    bool isemptyresponse(\type)) {
  SortedSet_\type toreturn;
  \type[] buffer;
  
  toreturn.iterable.foreach = new void(IteratorAction process(\type)) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      IteratorAction action = process(buffer[ii]);
      if (action.stop) break;
    }
  };
  
  toreturn.size = new int() { return buffer.length; };

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

  toreturn.contains = new bool(\type item) {
    for (\type possibility : buffer) {
      if (equal(possibility, item)) return true; 
    }
    return false;
  };

  toreturn.after = new \type(\type item) {
    for (\type possibility : buffer) {
      if (gt(possibility, item)) return possibility;
    }
    return emptyresponse;
  };

  toreturn.before = new \type(\type item) {
    for (int ii = buffer.length - 1; ii >= 0; --ii) {
      \type possibility = buffer[ii];
      if (lt(possibility, item)) return possibility;
    }
    return emptyresponse;
  };

  toreturn.min = new \type() {
    if (buffer.length == 0) return emptyresponse;
    return buffer[0];
  };

  toreturn.max = new \type() {
    if (buffer.length == 0) return emptyresponse;
    return buffer[buffer.length - 1];
  };

  toreturn.insert = new bool(\type item) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      if (equal(buffer[ii], item)) return false;
      else if (gt(buffer[ii], item)) {
        buffer.insert(ii, item);
        return true;
      }
    }
    buffer.push(item);
    return true;
  };

  toreturn.delete = new bool(\type item) {
    for (int ii = 0; ii < buffer.length; ++ii) {
      if (equal(buffer[ii], item)) {
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
