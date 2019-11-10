DeclareRepresentation(
  "IsSptSetCoeffZnRep",
  IsCategoryOfSptSetCoefficient and IsComponentObjectRep,
  ["torsion", "gAction"]
);

DeclareRepresentation(
  "IsSptSetCoeffU1Rep",
  IsCategoryOfSptSetCoefficient and IsComponentObjectRep,
  ["gAction"]
);

BindGlobal(
  "TheFamilyOfSptSetCoefficients",
  NewFamily("TheFamilyOfSptSetCoefficients")
);

BindGlobal(
  "TheTypeSptSetCoeffZn",
  NewType(TheFamilyOfSptSetCoefficients, IsSptSetCoeffZnRep)
);

BindGlobal(
  "TheTypeSptSetCoeffU1",
  NewType(TheFamilyOfSptSetCoefficients, IsSptSetCoeffU1Rep)
);

InstallGlobalFunction(SptSetCoefficientZn,
  function(n, gAction)
    return Objectify(TheTypeSptSetCoeffZn,
      rec(torsion := n, gAction := gAction));
  end);

InstallGlobalFunction(SptSetCoefficientU1,
  function(gAction)
    return Objectify(TheTypeSptSetCoeffU1,
      rec(gAction := gAction));
  end);
