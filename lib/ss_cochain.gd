DeclareCategory("IsCategoryOfSptSetSpecSeqCochain",
IsObject);

DeclareGlobalFunction("SptSetSpecSeqCochain");
DeclareGlobalFunction("SptSetSpecSeqCochainZero");
DeclareOperation("SptSetStack",
[IsCategoryOfSptSetSpecSeqCochain, IsCategoryOfSptSetSpecSeqCochain]);
DeclareOperation("SptSetStackInplace",
[IsCategoryOfSptSetSpecSeqCochain, IsCategoryOfSptSetSpecSeqCochain]);
DeclareOperation("SptSetInverse",
[IsCategoryOfSptSetSpecSeqCochain]);
DeclareGlobalFunction("SptSetSpecSeqCoboundary");
DeclareGlobalFunction("SptSetSpecSeqCoboundarySL");
DeclareGlobalFunction("PartialConstructSSCochain@");
