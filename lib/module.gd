DeclareCategory("IsCategoryOfSptSetFpZModule", IsObject);

DeclareOperation("SptSetFpZModuleEPR", [IsMatrix, IsMatrix, IsMatrix]);
DeclareOperation("SptSetCopyFpZModule", [IsCategoryOfSptSetFpZModule]);
DeclareOperation("SptSetFreeFpZModule", [IsInt]);
DeclareOperation("SptSetFpZModuleFromTorsions", [IsRowVector]);

DeclareOperation("SptSetNumberOfGenerators", [IsCategoryOfSptSetFpZModule]);
DeclareOperation("SptSetEmbedDimension", [IsCategoryOfSptSetFpZModule]);

DeclareOperation("SptSetFpZModuleCanonicalForm", [IsCategoryOfSptSetFpZModule]);

DeclareGlobalFunction("SptSetZeroModule");
DeclareGlobalFunction("SptSetFpZModuleIsZero");
DeclareGlobalFunction("SptSetFpZModuleIsCanonical");
DeclareGlobalFunction("SptSetFpZModuleIsZeroElm");
DeclareGlobalFunction("SptSetFpZModuleCanonicalElm");
