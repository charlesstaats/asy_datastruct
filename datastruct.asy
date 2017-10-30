include datastruct_interface.asy;

string DefineInterfacesCode(string type, bool defineequals=true) {
  codestring = replace(definesingletypeinterfaces, "\type", type);
  if (defineequals) {
    codestring += replace(defineequalscode, "\type", type);
  }
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

void RequireGenericModule(string parentmodule, string type, bool defineequals=true,
                          bool overwrite = false) {
  string namespace = '_' + parentmodule + '_' + type;
  if (addnamespace(namespace)) {
    string codestring = DefineInterfacesCode(type, defineequals);
    codestring = "struct " + namespace + "{" + '\n'
                 + codestring
                 + '\n' + "}";
    eval(codestring, true);
  }
}
