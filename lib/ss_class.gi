DeclareRepresentation(
"IsSptSetSpecSeqCochainRep",
IsCategoryOfSptSetSpecSeqCochain and IsComponentObjectRep,
["cochain"]
);

InstallGlobalFunction(SptSetSpecSeqClassFromCochainNC,
function(c)
  local cl, Fc, SS, deg, Tcl;

  Fc := FamilyObj(c);
  SS := Fc!.specSeq;
  deg := Fc!.degree;
  Tcl := SptSetSpecSeqClassType(SS, deg);
  return Objectify(Tcl, rec("cochain", c));
end);

InstallMethod(\+,
"add two classes",
IsIdenticalObj,
[IsSptSetSpecSeqCochainRep, IsSptSetSpecSeqCochainRep],
function(cl1, cl2)
  local c1, c2, c3;
  c1 := cl1!.cochain;
  c2 := cl2!.cochain;
  c3 := SptSetStack(c1, c2);
  return SptSetSpecSeqClassFromCochainNC(c3);
end);

InstallGlobalFunction(SptSetPurifySpecSeqClass,
function(cl) # recursive version
  local F, SS, deg, layers, brMap, p, q, cp, Epqinf, r, Erpq,
  n, n_, dnc, coc;
  F := FamilyObj(cl);
  SS := cl!.specSeq;
  deg := cl!.degree;
  coc := cl!.cochain;
  layers := coc!.layers;
  brMap := SS!.brMap;

  for p in [0..deg] do
    if layers[p+1] = ZeroCocycle@ then
      continue;
    fi;
    q := deg - p;
    cp_ := layers[p+1];
    cp := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp);
    Epqinf := SptSetSpecSeqComponentInf(SS, p, q);
    if not SptSetFpZModuleIsZeroElm(Epqinf, cp) then
      return; # The leading element is nontrivial. Purification complete.
    fi;

    Assert(0, SptSetFpZModuleIsZeroElm(
    SptSetSpecSeqComponent(SS, p+1, p, q), cpv),
    "Assertion: p+1 should be the highest page with trivialization");
    for r in [p,(p-1)..2] do
      Erpq := SptSetSpecSeqComponent(SS, r, p, q);
      if not SptSetFpZModuleIsZeroElm(Erpq, cpv) then
        Error("purification at r>2 is not implimented.");
      fi;
    od;
    # cp_ must be a trivial coboundary.
    n := ZLMapInverse(SptSetSpecSeqDerivative(SS, 1, p-1, q), cp);
    n_ := SptSetSolveCocycleEq(brMap, p, SS!.spectrum[q+1], cp_, n);
    n_ := NegativeInhomoCochain@(n_);

    dnc := SptSetSpecSeqCoboundarySL(SS, deg-1, p-1, n_);
    coc := SptSetStack(coc, dnc);
    coc!.layers[p+1] := ZeroCocycle@;
    layers := coc!.layers;
  od;

  return SptSetSpecSeqClassFromCochainNC(coc);
end);
