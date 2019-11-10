#DeclareCategory("IsCategoryOfSptSetCochainModule", IsCategoryOfSptSetFpZModule);

DeclareOperation("SptSetCochainModule", [IsHapResolution, IsInt, IsObject]);

DeclareOperation("SptSetCoboundaryMap",
  [IsCategoryOfSptSetFpZModule, IsCategoryOfSptSetFpZModule,
   IsHapResolution, IsInt, IsObject]);

DeclareOperation("SptSetTrivialGroupAction",
  [IsGroup]);
