DeclareRepresentation(
  "IsSptSetInhomoCochainRep",
  IsCategoryOfSptSetInhomoCochain and IsComponentObjectRep,
  ["rank", "group", "coeff", "f"]
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
);

InstallMethod(SptSetCup,
  "Computes the cup product of two inhomogeneous cochains",
  [IsSptSetInhomoCochainRep, IsSptSetInhomoCochainRep],
  function(a, b)
    local p, q, coeff, gAction, f, gid;
    p := a!.rank;
    q := b!.rank;
    coeff := a!.coeff;
    gAction := coeff!.gAction;
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
