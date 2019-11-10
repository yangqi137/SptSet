DeclareCategory("IsCategoryOfSptSetZLMap", IsObject);

DeclareOperation("SptSetZLMapByImages",
  [IsCategoryOfSptSetFpZModule, IsCategoryOfSptSetFpZModule, IsMatrix]
);
DeclareOperation("SptSetZeroMap",
  [IsCategoryOfSptSetFpZModule, IsCategoryOfSptSetFpZModule]
);

DeclareAttribute("SptSetZLMapInverseMat", IsCategoryOfSptSetZLMap);

DeclareOperation("SptSetKernelModule", [IsCategoryOfSptSetZLMap]);
DeclareOperation("SptSetCokernelModule", [IsCategoryOfSptSetZLMap]);
DeclareOperation("SptSetHomologyModule",
  [IsCategoryOfSptSetZLMap, IsCategoryOfSptSetZLMap]
);
DeclareOperation("SptSetZLMapInverse",
  [IsCategoryOfSptSetZLMap, IsRowVector]
);

DeclareGlobalFunction("SptSetPseudoInverseSpecialMat");
