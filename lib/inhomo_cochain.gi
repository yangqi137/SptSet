DeclareRepresentation(
  "IsSptSetInhomoCochainRep",
  IsCategoryOfSptSetInhomoCochain and IsComponentObjectRep,
  ["rank", "coeff", "f"]
);

DeclareRepresentation(
  "IsSptSetZeroInhomoCochainRep",
  IsCategoryOfSptSetInhomoCochain and IsComponentObjectRep,
  ["rank", "coeff"]
);

BindGlobal(
  "TheFamilyOfSptSetInhomoCochains",
  NewFamily("TheFamilyOfSptSetInhomoCochains")
);

BindGlobal(
  "TheTypeSptSetInhomoCochains",
  NewType(TheFamilyOfSptSetInhomoCochains, IsSptSetInhomoCochains)
);

BindGlobal(
  "TheTypeSptSetZeroInhomoCochains",
  NewType(TheFamilyOfSptSetInhomoCochains, IsSptSetZeroInhomoCochainRep)
);

InstallGlobalFunction(SptSetInhomoCochain,
function (p, coeff, f)
  local crec;
  crec := rec(rank := p, coeff := coeff, f := f);
  return Objectify(TheTypeSptSetInhomoCochains, crec);
end);

InstallGlobalFunction(SptSetZeroInhomoCochain,
function(p, coeff)
  local crec;
  crec := rec(rank := p, coeff := coeff);
  return Objectify(TheTypeSptSetZeroInhomoCochains, crec);
end);

InstallMethod(\+, "add two cochains", IsIdenticalObj,
[IsSptSetSpecSeqClassRep, IsSptSetSpecSeqClassRep],
function(c1, c2)
  local crec, f;
  f := function(glist...)
    return c1!.f(glist) + c2!.f(glist);
  end;
  crec := rec(rank := c1!.rank, coeff := c1!.coeff, f := f);
  return Objectify(TheTypeSptSetInhomoCochains, crec);
end);

InstallMethod(SptSetCup,
  "Computes the cup product of two inhomogeneous cochains",
  [IsSptSetInhomoCochainRep, IsSptSetInhomoCochainRep],
  function(a, b)
    local p, q, ca, cb, cab, gAction, fa, fb, f, gid;
    p := a!.rank;
    q := b!.rank;
    ca := a!.coeff;
    cb := b!.coeff;
    cab := SptSetCoefficientTensorProduct(ca, cb);
    gAction := cb.gAction;
    gid := Identity(PreImage(gAction));
    fa := a!.f;
    fb := b!.f;
    f := function(glist...)
      local gp, gq, gpp;
      gp := glist{[1..p]};
      gq := glist{[(p+1)..(p+q)]};
      gpp := Product(gp, gid);
      return CallFuncList(fa, gp) *
               ((gpp^gAction)[1][1] * CallFuncList(fb, gq));
    end;
    return SptSetInhomoCochain(p+q, coeff, f);
  end);

InstallMethod(SptSetCup,
"Computes the cup product when the first input is zero",
[IsSptSetZeroInhomoCochainRep, IsSptSetInhomoCochains],
function(a, b)
  local p, q, ca, cb, cab;
  p := a!.rank;
  q := b!.rank;
  ca := a!.coeff;
  cb := b!.coeff;
  cab := SptSetCoefficientTensorProduct(ca, cb);
  return SptSetZeroInhomoCochain(p+q, cab);
end);

InstallMethod(SptSetCup,
"Computes the cup product when the second input is zero",
[IsSptSetInhomoCochains, IsSptSetZeroInhomoCochainRep],
function(a, b)
  local p, q, ca, cb, cab;
  p := a!.rank;
  q := b!.rank;
  ca := a!.coeff;
  cb := b!.coeff;
  cab := SptSetCoefficientTensorProduct(ca, cb);
  return SptSetZeroInhomoCochain(p+q, cab);
end);
