include datastruct_interface.asy;

string DefineInterfacesCode(string type, bool defineequals=true) {
  codestring = replace(definesingletypeinterfaces, "\type", type);
  if (defineequals) {
    codestring += replace(defineequalscode, "\type", type);
  }
  return codestring;
}

bool fileexists(string filename) {
  file testname = input(filename);
  bool exists = !error(testname);
  close(testname);
  return exists;
}

void RequireGenericModule(string parentmodule, string type, bool defineequals=true,
                          bool overwrite = false) {
  string filename = '_' + parentmodule + '_' + type + '.asy';
  if (overwrite || !fileexists(filename)) {
    file outfile = output(filename); 
    string codestring = DefineInterfacesCode(type, defineequals);
    write(outfile, codestring);
    close(outfile);
  }
}
