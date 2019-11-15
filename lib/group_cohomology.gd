DeclareCategory("IsCategoryOfSptSetCochainComplex", IsObject);

#DeclareOperation("SptSetHomToIntegralModule",
#  [IsHapResolution, IsGeneralMapping]);
#DeclareOperation("SptSetHomToIntegerModN", [IsHapResolution, IsInt]);
DeclareOperation("SptSetCochainComplex",
  [IsHapResolution, IsCategoryOfSptSetCoefficient]);
DeclareOperation("SptSetCohomology", [IsCategoryOfSptSetCochainComplex, IsInt]);
DeclareOperation("SptSetCochainComplexModule",
  [IsCategoryOfSptSetCochainComplex, IsInt]);
DeclareOperation("SptSetCochainComplexDerivative",
  [IsCategoryOfSptSetCochainComplex, IsInt]);

DeclareOperation("SptSetShowCohomologyClass",
  [IsCategoryOfSptSetCochainComplex, IsInt, IsPosInt]);
DeclareOperation("SptSetInhomogeneousCocycle",
  [IsCategoryOfSptSetCochainComplex, IsInt, IsPosInt]);
