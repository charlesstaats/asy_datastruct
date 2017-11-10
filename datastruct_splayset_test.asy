import datastruct;
import datastruct_reference_sortedset;

typedef int tint;
RequireGenericModule("datastruct_splayset_test", "tint");
SupplyBadSortedSetImpl("tint");

import enums;
DefineEnum("datastruct_splayset_test", "Fns",
           "INSERT,DELETE,CONTAINS,AFTER,BEFORE,FIRSTGEQ,FIRSTLEQ," +
               "MIN,MAX,ISEMPTYRESPONSE,SIZE,EMPTY,FOREACH_action,FOREACH");
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

void testget(tint reffn(tint), tint testedfn(tint), string fnname) {
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

void testget(tint reffn(), tint testedfn(), string fnname) {
  tint[][] old = new tint[][]{reference, splayset};
  tint refresponse = reffn();
  tint testedresponse = testedfn();
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
}

//validations[Fns.MIN] = new void() {
//  testget(reference.min, splayset.min, "min");
//};
//validations[Fns.MAX] = new void() {
//  testget(reference.max, splayset.min, "max");
//};
validations[Fns.FIRSTLEQ] = new void() {
  testget(reference.firstLEQ, splayset.firstLEQ, "firstLEQ");
};
validations[Fns.FIRSTGEQ] = new void() {
  testget(reference.firstGEQ, splayset.firstGEQ, "firstGEQ");
};
validations[Fns.BEFORE] = new void() {
  testget(reference.before, splayset.before, "before");
};
validations[Fns.AFTER] = new void() {
  testget(reference.after, splayset.after, "after");
};
validations[Fns.CONTAINS] = new void() {
  tint[][] previous = new tint[][]{reference, splayset};
  tint toask = getrand();
  bool refcontained = reference.contains(toask);
  bool splaysetcontained = splayset.contains(toask);
  if (refcontained != splaysetcontained ||
      reference != splayset) {
    write("error querying contains " + (string)toask);
    write("before:");
    write(previous);
    write("ref contained: " + (string)refcontained);
    write("splayset contained: " + (string)splaysetcontained);
    writesets();
    assert(false);
  }
};
validations[Fns.INSERT] = new void() {
  tint[][] previous = new tint[][]{reference, splayset};
  tint toinsert = getrand();
  bool refinsertchanged = reference.insert(toinsert);
  bool splaysetinsertchanged = splayset.insert(toinsert);
  if (refinsertchanged != splaysetinsertchanged ||
      reference != splayset) {
    write("error inserting " + (string)toinsert);
    write("before:");
    write(previous);
    write("ref insert changed: " + (string)refinsertchanged);
    write("splayset insert changed: " + (string)splaysetinsertchanged);
    writesets();
    assert(false);
  }
};
validations[Fns.DELETE] = new void() {
  tint[][] previous = new tint[][]{reference, splayset};
  tint todelete = getrand();
  bool refdeletechanged = reference.delete(todelete);
  bool splaysetdeletechanged = splayset.delete(todelete);
  if (refdeletechanged != splaysetdeletechanged ||
      reference != splayset) {
    write("error deleting " + (string)todelete);
    write("before:");
    write(previous);
    write("ref delete changed: " + (string)refdeletechanged);
    write("splayset delete changed: " + (string)splaysetdeletechanged);
    writesets();
    assert(false);
  }
};

void randomaction() {
  int action = floor(7/*Fns.length*/ * unitrand());
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
