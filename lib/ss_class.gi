DeclareRepresentation(
"IsSptSetSpecSeqClassRep",
IsCategoryOfSptSetSpecSeqClass and IsComponentObjectRep and IsAttributeStoringRep,
["cochain"]
);

InstallGlobalFunction(SptSetSpecSeqClassFromCochainNC,
function(c)
  local cl, Fc, SS, deg, Tcl;

  Fc := FamilyObj(c);
  SS := Fc!.specSeq;
  deg := Fc!.degree;
  Tcl := SptSetSpecSeqClassType(SS, deg);
  return Objectify(Tcl, rec(cochain := c));
end);

InstallMethod(\+,
"add two classes",
IsIdenticalObj,
[IsSptSetSpecSeqClassRep, IsSptSetSpecSeqClassRep],
function(cl1, cl2)
  local c1, c2, c3;
  c1 := cl1!.cochain;
  c2 := cl2!.cochain;
  c3 := SptSetStack(c1, c2);
  return SptSetSpecSeqClassFromCochainNC(c3);
end);

InstallGlobalFunction(SptSetPurifySpecSeqClass,
function(cl) # recursive version
  local F, SS, deg, layers, brMap, bdry, p, q, cp, cp_, Epqinf, r, Erpq,
  n, n_, dnc, coc, pll;
  F := FamilyObj(cl);
  SS := F!.specSeq;
  deg := F!.degree;
  coc := cl!.cochain;
  layers := coc!.layers;
  brMap := SS!.brMap;
  pll := -1; # -1 indicating that it is not set.

  bdry := SptSetSpecSeqCochainZero(SS, deg-1);

  for p in [0..deg] do
    if layers[p+1] = ZeroCocycle@ then
      continue;
    fi;
    q := deg - p;
    cp_ := layers[p+1];
    cp := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp_);
    Epqinf := SptSetSpecSeqComponent2Inf(SS, p, q);
    if not SptSetFpZModuleIsZeroElm(Epqinf, cp) then
      SetLeadingLayer(cl, p);
      SetLeadingLayerElement(cl, cp);
      #Display(["Purification ended at layer", p]);
      return; # The leading element is nontrivial. Purification complete.
      # TODO: return the coboundary in this path? this behavior now serves as an assertion check for the caller SptSetSpecSeqClassFromLevelCocycle, but this should be changed later.
    fi;

    #Assert(0, SptSetFpZModuleIsZeroElm(
    #SptSetSpecSeqComponent2(SS, p+1, p, q), cp),
    #"Assertion: p+1 should be the highest page with trivialization");
    for r in [p,(p-1)..2] do
      Erpq := SptSetSpecSeqComponent2(SS, r, p, q);
      if not SptSetFpZModuleIsZeroElm(Erpq, cp) then
        Error("purification at r>2 is not implimented.");
      fi;
    od;
    # cp_ must be a trivial coboundary.
    n := SptSetZLMapInverse(SptSetSpecSeqDerivative2(SS, 1, p-1, q), cp);
    n_ := SptSetSolveCocycleEq(brMap, p, SS!.spectrum[q+1], cp_, n);
    n_ := NegativeInhomoCochain@(n_);
    bdry!.layers[p-1 +1] := n_;

    dnc := SptSetSpecSeqCoboundarySL(SS, deg-1, p-1, n_);
    coc := SptSetStack(coc, dnc);
    coc!.layers[p+1] := ZeroCocycle@;
    layers := coc!.layers;
    #if ValueOption("PurifyDebug") = true then
    #  Display(coc!.layers[3] = ZeroCocycle@);
    #fi;
  od;

#  if ValueOption("PurifyDebug") = true then
#    Display(coc!.layers[3] = ZeroCocycle@);
#  fi;
  cl!.cochain := coc;
  SetLeadingLayer(cl, p+1);
  #Display(["Purification completed at layer", p+1]);
  #return SptSetSpecSeqClassFromCochainNC(coc);
  return bdry;
end);

InstallGlobalFunction(SptSetSpecSeqClassFromLevelCocycle,
function(SS, deg, p, a)
  local brMap, q, a_, da, cl_da, b;
  brMap := SS!.brMap;
  q := deg - p;
  a_ := SptSetMapToBarCocycle(brMap, p, SS!.spectrum[q+1], a);
  da := SptSetSpecSeqCoboundarySL(SS, deg, p, a_);
  da!.layers[p+1 +1] := ZeroCocycle@; # da must be a cocycle.
  cl_da := SptSetSpecSeqClassFromCochainNC(da);
  b := SptSetPurifySpecSeqClass(cl_da);
  b!.layers[p+1] := a_;
  #return b;
  return SptSetSpecSeqClassFromCochainNC(b);
end);
