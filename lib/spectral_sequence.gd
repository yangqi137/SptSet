DeclareCategory("IsCategoryOfSptSetSpecSeq", IsObject);

DeclareOperation("SptSetSpecSeqBuildComponent",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt]);
DeclareOperation("SptSetSpecSeqBuildDerivative",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt]);
DeclareOperation("SptSetSpecSeqComponent",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt]);
DeclareOperation("SptSetSpecSeqComponentInf",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt]);
DeclareOperation("SptSetSpecSeqDerivative",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt]);

DeclareGlobalFunction("InstallSptSetSpecSeqDerivative");
DeclareGlobalFunction("InstallSptSetSpecSeqDerivativeU1");
