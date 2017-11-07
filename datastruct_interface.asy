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
//";

private string defineequalscode = "
bool operator==(Iterable_\type a, Iterable_\type b) {
  \type[] arr_a = a;
  \type[] arr_b = b;
  return arr_a.length == arr_b.length && all(arr_a == arr_b);
}
bool operator!=(Iterable_\type a, Iterable_\type b) {
  return !(a == b);
}
bool operator==(SortedSet_\type a, SortedSet_\type b) {
  return ((Iterable_\type)a == (Iterable_\type)b);
}
bool operator!=(SortedSet_\type a, SortedSet_\type b) {
  return !(a == b);
}

bool operator==(Iterable_\type a, \type[] b) {
  \type[] arr_a = a;
  return arr_a.length == b.length && all(arr_a == b);
}
bool operator!=(Iterable_\type a, \type[] b) { return !(a == b); }
bool operator==(\type[] a, Iterable_\type b) { return b == a; }
bool operator!=(\type[] a, Iterable_\type b) { return !(b == a); }
//";

// An IteratorAction is immutable once constructed.
struct IteratorAction {
  restricted bool stop;
  void operator init(bool stop=false) {
    this.stop = stop;
  }
  // Since an IteratorAction is immutable, externally visible
  // constants of type IteratorAction are reasonable.
  restricted static IteratorAction Continue = IteratorAction();
  restricted static IteratorAction Quit = IteratorAction(stop=true);
}
