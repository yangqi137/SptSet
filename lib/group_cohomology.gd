DeclareCategory("IsCategoryOfSptSetCochainComplex", IsObject);

DeclareOperation("SptSetHomToIntegralModule",
  [IsHapResolution, IsGeneralMapping]);
DeclareOperation("SptSetHomToIntegerModN", [IsHapResolution, IsInt]);
DeclareOperation("SptSetCohomology", [IsCategoryOfSptSetCochainComplex, IsInt]);
DeclareOperation("SptSetCochainComplexModule",
  [IsCategoryOfSptSetCochainComplex, IsInt]);
DeclareOperation("SptSetCochainComplexDerivative",
  [IsCategoryOfSptSetCochainComplex, IsInt]);
