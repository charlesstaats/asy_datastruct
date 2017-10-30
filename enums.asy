void DefineEnum(string module, string enumname, string commaseparatedenums) {
  string[] enums = split(replace(commaseparatedenums, " ", ""), ",");
  string evalstring = "struct _" + module + "_" + enumname + " {" + '\n';
  for (int ii = 0; ii < enums.length; ++ii) {
    evalstring += "static restricted int " + (string)enums[ii] + " = " + (string)ii + ';\n';
  }
  evalstring += "static restricted int length = " + (string)enums.length + ';\n';
  evalstring += "}";
  eval(evalstring, true);
}
