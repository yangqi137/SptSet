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
  local F, SS, deg, layers, brMap, bdry, p, q, cp, Epqinf, r, Erpq,
  n, n_, dnc, coc;
  F := FamilyObj(cl);
  SS := F!.specSeq;
  deg := F!.degree;
  coc := cl!.cochain;
  layers := coc!.layers;
  brMap := SS!.brMap;

  bdry := SptSetSpecSeqCochainZero(SS, deg-1);

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
    bdry!.layers[p-1] := n_;

    dnc := SptSetSpecSeqCoboundarySL(SS, deg-1, p-1, n_);
    coc := SptSetStack(coc, dnc);
    coc!.layers[p+1] := ZeroCocycle@;
    layers := coc!.layers;
  od;

  cl!.cochain := coc;
  
  #return SptSetSpecSeqClassFromCochainNC(coc);
  return bdry;
end);

InstallGlobalFunction(SptSetSpecSeqClassFromLevelCocycle,
function(SS, deg, p, a)
  local brMap, layers, dlayers, cochain, pp, dlpp2_, dlpp2, lpp1, lpp1_;
  brMap := SS!.brMap;
  layers := [];
  for pp in [0..(p-1)] do
    layers[pp+1] := ZeroCocycle@;
  od;
  layers[p+1] := SptSetMapToBarCocycle(brMap, p, SS!.spectrum[deg-p+1], a);
  for pp in [p..(deg-1)] do
    if pp = p  then
      dlayers := SptSetSpecSeqCoboundarySL(SS, deg, p, layers[p+1]);
    else
      dlayers := SptSetStack(dlayers,
      SptSetSpecSeqCoboundarySL(SS, deg, pp, layers[pp+1]));
    fi;
    dlpp2_ := dlayers!.layers[pp+2 +1];
    dlpp2 := SptSetMapFromBarCocycle(brMap, pp+2,
    SS!.spectrum[deg-(pp+1)+1], dlpp2_);
    lpp1 := SptSetZLMapInverse(SptSetSpecSeqDerivative(SS, 1, pp+1, deg-(pp+1)), dlpp2);
    #lpp1_ := SptSetMapToBarCocycle(bMap, pp+1,
    #SS!.spectrum[deg-(pp+1)+1], lpp1);
    lpp1_ := SptSetSolveCocycleEq(ss!.brMap, pp+2,
    SS!.spectrum[deg-(pp+1)+1], dlpp2_, lpp1);
    layers[pp+1 +1] := lpp1_;
  od;

  cochain := SptSetSpecSeqCochain(SS, deg, layers);
  return SptSetSpecSeqClassFromCochainNC(cochain);
end);
