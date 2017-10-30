import datastruct;
import datastruct_reference_sortedset;

RequireGenericModule("datastruct_splayset_test", "int");
SupplyBadSortedSetImpl("int");

import enums;
DefineEnum("datastruct_splayset_test", "Fns",
           "INSERT,DELETE,CONTAINS,AFTER,BEFORE,FIRSTGEQ,FIRSTLEQ," +
               "MIN,MAX,ISEMPTYRESPONSE,SIZE,EMPTY,FOREACH_action,FOREACH");
typedef _datastruct_splayset_test_Fns Fns;
