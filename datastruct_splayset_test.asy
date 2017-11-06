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

validations[Fns.INSERT] = new void() {
  tint toinsert = getrand();
  if (reference.insert(toinsert) != splayset.insert(toinsert) ||
      reference != splayset) {
    write("error inserting " + (string)toinsert);
    write("reference: ");
    write(new tint[][] {reference});
    write("splayset: ");
    write(new tint[][] {splayset});
  }
};
  

for (int i = 0; i < 500; ++i) {
  int action = (Fns.length * unitrand());
  
}
