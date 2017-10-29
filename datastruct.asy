include datastruct_interface.asy;

void DefineInterfaces(string type, bool defineequals=true) {
  eval(replace(definesingletypeinterfaces, "\type", type), true);
  if (defineequals) {
    eval(replace(defineequalscode, "\type", type), true);
  }
}
