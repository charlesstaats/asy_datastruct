include datastruct_interface;

string DefineInterfacesCode(string type, bool defineequals=true) {
  string codestring = replace(definesingletypeinterfaces, "\type", type);
  if (defineequals) {
    codestring += replace(defineequalscode, "\type", type);
  }
  return codestring;
}

include datastruct_splayset;

string DefineSplaySetCode(string type) {
  string codestring = replace(splaytreecode, "\type", type);
  return codestring;
}

// TODO: use a set rather than an array
private bool addnamespace(string namespace) {
  static string[] namespaces;
  if (all(namespaces != namespace)) {
    namespaces.push(namespace);
    return true;
  }
  return false;
}

void RequireGenericModule(string module, string type, bool defineequals=true) {
  string namespace = '_' + module + '_' + type;

  // for testing (so that line numbers make sense)
  write("DefineInterfacesCode");
  eval(DefineInterfacesCode(type, defineequals), true);
  write("DefineSplaySetCode");
  eval(DefineSplaySetCode(type), true);
//  if (addnamespace(namespace)) {
//    string codestring = DefineInterfacesCode(type, defineequals)
//                        + DefineSplaySetCode(type);
//    codestring = "struct " + namespace + "{"
//                 + codestring
//                 + '\n' + "}";
//    eval(codestring, true);
//  }
}
