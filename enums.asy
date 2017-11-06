void DefineEnum(string module, string enumname, string commaseparatedenums) {
  string[] enums = split(replace(commaseparatedenums, " ", ""), ",");
  string evalstring = "struct _" + module + "_" + enumname + " {" + '\n';
  for (int ii = 0; ii < enums.length; ++ii) {
    evalstring += "static restricted int " + (string)enums[ii] + " = " + (string)ii + ';\n';
  }
  evalstring += "static string tostring(int i) {" + '\n';
  evalstring += "  static string[] enumnames = {";
  for (int ii = 0; ii < enums.length; ++ii) {
    evalstring += '"' + enums[ii] + '"';
    if (ii < enums.length - 1) evalstring += ", ";
  }
  evalstring += "};" + '\n';
  evalstring += "  return enumnames[i];" + '\n';
  evalstring += "}" + '\n';
  evalstring += "static restricted int length = " + (string)enums.length + ';\n';
  evalstring += "}";
  eval(evalstring, true);
}
