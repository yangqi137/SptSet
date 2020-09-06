DeclareCategory("IsCategoryOfSptSetCoefficient", IsObject);

DeclareGlobalFunction("SptSetCoefficientU1");
DeclareGlobalFunction("SptSetCoefficientZn");

DeclareOperation("SptSetCoefficientTensorProduct",
  [IsCategoryOfSptSetCoefficient, IsCategoryOfSptSetCoefficient]);
