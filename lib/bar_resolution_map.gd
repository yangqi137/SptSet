DeclareCategory("IsCategoryOfSptSetBarResMap", IsObject);

DeclareOperation("SptSetBarResolutionMap",
  [IsHapResolution]
);

DeclareOperation("SptSetMapToBarWord",
  [IsCategoryOfSptSetBarResMap, IsInt, IsPosInt]
);
DeclareOperation("SptSetMapFromBarWord",
  [IsCategoryOfSptSetBarResMap, IsInt, IsList]
);
DeclareOperation("SptSetMapToBarCocycle",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject, IsRowVector]
);
DeclareOperation("SptSetMapFromBarCocycle",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject, IsFunction]
);
DeclareOperation("SptSetSolveCocycleEq",
  [IsCategoryOfSptSetBarResMap, IsInt, IsObject,
    IsFunction, IsRowVector]
);
