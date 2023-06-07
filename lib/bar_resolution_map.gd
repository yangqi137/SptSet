DeclareCategory("IsCategoryOfSptSetBarResMap", IsObject);

#DeclareFilter("IsUsingMyBarResolutionMap");
#DeclareFilter("IsUsingHapBarResolutionMap");
DeclareOperation("SptSetBarResolutionMap",
  [IsHapResolution]
);
DeclareConstructor("SptSetConstructBarResMap",
[IsCategoryOfSptSetBarResMap, IsHapResolution]);

DeclareOperation("SptSetMapToBarWord",
  [IsCategoryOfSptSetBarResMap, IsInt, IsPosInt]
);
DeclareOperation("SptSetMapFromBarWord",
  [IsCategoryOfSptSetBarResMap, IsInt, IsList]
);
DeclareOperation("SptSetMapEquivBarWord",
  [IsCategoryOfSptSetBarResMap, IsList]
);
DeclareOperation("SptSetMapToBarCocycle",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject, IsRowVector]
);
DeclareOperation("SptSetMapFromBarCocycle",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject, IsFunction]
                );
DeclareOperation("SptSetMapToInhomo",
                 [IsCategoryOfSptSetBarResMap, IsInt, IsObject, IsRowVector]);
DeclareOperation("SptSetMapFromInhomo",
                 [IsCategoryOfSptSetBarResMap, IsCategoryOfSptSetInhomoCochain]);

DeclareOperation("SptSetSolveCocycleEq",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject,
    IsFunction, IsRowVector]
);

DeclareOperation("SptSetSolveCocycleEq",
  [IsCategoryOfSptSetBarResMap, IsCategoryOfSptSetInhomoCochain, IsRowVector]
);

DeclareGlobalFunction("WordSimplify@");
