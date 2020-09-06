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

InstallMethod(SptSetCoefficientTensorProduct,
"Computes the tensor product of two Zn coefficients",
[IsSptSetCoeffZnRep, IsSptSetCoeffZnRep],
function(c1, c2)
  local torsion, G, gl, sl, gact;
  torsion := Gcd(c1!.torsion, c2!.torsion);
  G := PreImage(c1!.gAction);
  gl := GeneratorsOfGroup(G);
  sl := List(gl, x -> ((x ^ c1!.gAction) * (x ^ c2!.gAction)));
  gact := GroupHomomorphismByImagesNC(G, GL(1, Integers), gl, sl);
  return SptSetCoefficientZn(torsion, gact);
end);
