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
  write("reference splayset");
  write(new tint[][]{reference, splayset});
}

string operator cast(bool b) {
  return b ? "true" : "false";
}

validations[Fns.BEFORE] = new void() {
  tint[][] previous = new tint[][]{reference, splayset};
  tint toask = getrand();
  tint refbefore = reference.before(toask);
  tint splaysetbefore = splayset.before(toask);
  if (refbefore != splaysetbefore ||
      reference != splayset) {
    write("error querying before " + (string)toask);
    write("before:");
    write(previous);
    write("ref before: " + (string)refbefore);
    write("splayset before: " + (string)splaysetbefore);
    writesets();
    assert(false);
  }
};
validations[Fns.AFTER] = new void() {
  tint[][] previous = new tint[][]{reference, splayset};
  tint toask = getrand();
  tint refafter = reference.after(toask);
  tint splaysetafter = splayset.after(toask);
  if (refafter != splaysetafter ||
      reference != splayset) {
    write("error querying after " + (string)toask);
    write("before:");
    write(previous);
    write("ref after: " + (string)refafter);
    write("splayset after: " + (string)splaysetafter);
    writesets();
    assert(false);
  }
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
  int action = floor(5/*Fns.length*/ * unitrand());
  validations[action](); 
}

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

