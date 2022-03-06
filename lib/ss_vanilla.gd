DeclareOperation("SptSetSpecSeqVanilla",
  [IsHapResolution, IsList]);

DeclareOperation("SptSetInstallCoboundary",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt, IsFunction]);
DeclareOperation("SptSetInstallAddTwister",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsFunction]);
DeclareGlobalFunction("SptSetSpecSeqCochainType");
DeclareGlobalFunction("SptSetSpecSeqClassType");
