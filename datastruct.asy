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

// Returns the code to replace the specified file with an empty file.
private string EmptyFileCode(string filename) {
  static string template = "
file todelete = output('\filename');
write(todelete);
close(todelete);
//";
  return replace(template, "\filename", filename);
}

private void RequireModuleExists(string createcode() ... string[] components) {
  string namespace;
  for (string component : components)
    namespace += '_' + component;
  if (addnamespace(namespace)) {
    string inner_module_code = createcode();
    string outer_filename = namespace + '.asy';
    file outer_module = output(outer_filename);
    write(outer_module, 'include _' + namespace + ';', suffix=endl);
    // Module empties itself once included.
    write(outer_module, EmptyFileCode(outer_filename), suffix=flush);
    close(outer_module);

    string inner_filename = '_' + namespace + '.asy';
    file inner_module = output(inner_filename);
    write(inner_module, inner_module_code, suffix=flush);
    close(inner_module);
  }
}

void RequireGenericModule(string module, string type, bool defineequals=true) {
  
  var modulecode = new string() {
                     return DefineInterfacesCode(type, defineequals) + '\n' +
                         DefineSplaySetCode(type);
                   };
  RequireModuleExists(modulecode, 'datastruct', module, type);
}
