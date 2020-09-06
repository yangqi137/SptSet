DeclareRepresentation(
  "IsSptSetInhomoCochainRep",
  IsCategoryOfSptSetInhomoCochain and IsComponentObjectRep,
  ["rank", "coeff", "f"]
);

BindGlobal(
  "TheFamilyOfSptSetInhomoCochains",
  NewFamily("TheFamilyOfSptSetInhomoCochains")
);

BindGlobal(
  "TheTypeSptSetInhomoCochains",
  NewType(TheFamilyOfSptSetInhomoCochains, IsSptSetInhomoCochains)
);

InstallGlobalFunction(SptSetInhomoCochain,
function (p, coeff, f)
  local crec;
  crec := rec(rank := p, coeff := coeff, f := f);
  return Objectify(TheTypeSptSetInhomoCochains, crec);
end);

InstallMethod(SptSetCup,
  "Computes the cup product of two inhomogeneous cochains",
  [IsSptSetInhomoCochainRep, IsSptSetInhomoCochainRep],
  function(a, b)
    local p, q, ca, cb, cab, gAction, f, gid;
    p := a!.rank;
    q := b!.rank;
    ca := a!.coeff;
    cb := b!.coeff;
    cab := SptSetCoefficientTensorProduct(ca, cb);
    gAction := cb.gAction;
    gid := Identity(PreImage(gAction));
    f := function(glist...)
      local gp, gq, gpp;
      gp := glist{[1..p]};
      gq := glist{[(p+1)..(p+q)]};
      gpp := Product(gp, gid);
      return CallFuncList(a, gp) *
               ((gpp^gAction)[1][1] * CallFuncList(b, gq));
    end;
    return SptSetInhomoCochain(p+q, coeff, f);
  end);
