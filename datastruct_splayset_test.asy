import datastruct;
import datastruct_reference_sortedset;

typedef int tint;
RequireGenericModule("datastruct_splayset_test", "tint");
SupplyBadSortedSetImpl("tint");

import enums;
DefineEnum("datastruct_splayset_test", "Fns",
           "INSERT,DELETE,CONTAINS,AFTER,BEFORE,FIRSTGEQ,FIRSTLEQ," +
              "MIN,MAX,SIZE,EMPTY");
typedef _datastruct_splayset_test_Fns Fns;

bool isEmptyResponse(tint a) { return a == intMin; }
SortedSet_tint reference = GetBadSortedSet_tint(operator<=, intMin, isEmptyResponse);
SortedSet_tint splayset = GetSplayTree_tint(operator<=, intMin, isEmptyResponse);

tint getrand() {
  return rand() % 127;
}

typedef void command();
command[] validations = new command[Fns.length];

void writesets() {
  write("reference \n splayset:");
  write(new tint[][]{reference, splayset});
}

string operator cast(bool b) {
  return b ? "true" : "false";
}

void testfn(bool reffn(tint), bool testedfn(tint), string fnname) {
  tint[][] old = new tint[][]{reference, splayset};
  tint toask = getrand();
  bool refresponse = reffn(toask);
  bool testedresponse = testedfn(toask);
  if (refresponse != testedresponse ||
      reference != splayset) {
    write("error: " + fnname + "(" + (string)toask + "):");
    write("before:");
    write(old);
    write("reference." + fnname + "(" + (string)toask + ") = " + (string)refresponse);
    write("tested." + fnname + "(" + (string)toask + ") = "  + (string)testedresponse);
    writesets();
    assert(false);
  }
}

void testfn(tint reffn(tint), tint testedfn(tint), string fnname) {
  tint[][] old = new tint[][]{reference, splayset};
  tint toask = getrand();
  tint refresponse = reffn(toask);
  tint testedresponse = testedfn(toask);
  if (refresponse != testedresponse ||
      reference != splayset) {
    write("error: " + fnname + "(" + (string)toask + "):");
    write("before:");
    write(old);
    write("reference." + fnname + "(" + (string)toask + ") = " + (string)refresponse);
    write("tested." + fnname + "(" + (string)toask + ") = "  + (string)testedresponse);
    writesets();
    assert(false);
  }
}

void testfn(tint reffn(), tint testedfn(), string fnname) {
  tint[][] old = new tint[][]{reference, splayset};
  tint refresponse = reffn();
  bool refemptyresponse = reference.isemptyresponse(refresponse);
  tint testedresponse = testedfn();
  bool testedemptyresponse = splayset.isemptyresponse(testedresponse);
  if (refemptyresponse != testedemptyresponse ||
      (!refemptyresponse && (refresponse != testedresponse)) ||
      reference != splayset) {
    write("error: " + fnname + "():");
    write("before:");
    write(old);
    write("reference." + fnname + "() = " + (string)refresponse);
    write("tested." + fnname + "() = "  + (string)testedresponse);
    writesets();
    assert(false);
  }
}

validations[Fns.EMPTY] = new void() {
  assert(reference.empty() == (reference.size() == 0));
  assert(splayset.empty() == (splayset.size() == 0));
  assert(reference.empty() == splayset.empty());
};
validations[Fns.SIZE] = new void() {
  tint[][] old = new tint[][]{reference, splayset};
  int refresponse = reference.size();
  int testedresponse = splayset.size();
  string fnname = "size";
  if (refresponse != testedresponse ||
      reference != splayset) {
    write("error: " + fnname + "():");
    write("before:");
    write(old);
    write("reference." + fnname + "() = " + (string)refresponse);
    write("tested." + fnname + "() = "  + (string)testedresponse);
    writesets();
    assert(false);
  }
};
validations[Fns.MIN] = new void() {
  testfn(reference.min, splayset.min, "min");
};
validations[Fns.MAX] = new void() {
  testfn(reference.max, splayset.max, "max");
};
validations[Fns.FIRSTLEQ] = new void() {
  testfn(reference.firstLEQ, splayset.firstLEQ, "firstLEQ");
};
validations[Fns.FIRSTGEQ] = new void() {
  testfn(reference.firstGEQ, splayset.firstGEQ, "firstGEQ");
};
validations[Fns.BEFORE] = new void() {
  testfn(reference.before, splayset.before, "before");
};
validations[Fns.AFTER] = new void() {
  testfn(reference.after, splayset.after, "after");
};
validations[Fns.CONTAINS] = new void() {
  testfn(reference.contains, splayset.contains, "contains");
};
validations[Fns.INSERT] = new void() {
  testfn(reference.insert, splayset.insert, "insert");
};
validations[Fns.DELETE] = new void() {
  testfn(reference.delete, splayset.delete, "delete");
};

void randomaction() {
  int action = floor(Fns.length * unitrand());
  validations[action](); 
}

void runtests() {
  for (int i = 0; i < 1000; ++i) {
    randomaction();
  }

  // test with insert favored, then delete favored
  for (int i = 0; i < 1000; ++i) {
    if (unitrand() > 0.4) validations[Fns.INSERT]();
    else randomaction();
  }
  for (int i = 0; i < 1200; ++i) {
    if (unitrand() > 0.5) validations[Fns.DELETE]();
    else randomaction();
  }
}

runtests();
