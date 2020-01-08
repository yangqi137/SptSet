DeclareOperation("SptSetSpecSeqVanilla",
  [IsHapResolution, IsList]);

DeclareOperation("SptSetInstallCoboundary",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt, IsFunction]);
DeclareGlobalFunction("SptSetSpecSeqCochainType");
