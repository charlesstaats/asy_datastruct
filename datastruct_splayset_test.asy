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
  return rand() % 41;
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

int maxlength = 0;

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
  maxlength = max(maxlength, splayset.size());
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
  maxlength = max(maxlength, splayset.size());
};

for (int i = 0; i < 500; ++i) {
  int action = floor(2/*Fns.length*/ * unitrand());
  validations[action](); 
}
write('max length: ' + (string)maxlength);
