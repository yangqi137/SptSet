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
  drm1, beta, beta_, cbeta, 
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
    cp := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp_);
    Assert(-1, ForAll(cp, IsInt), "ASSERTION FAILURE: top layer is not a cocycle");
    #Display(["Top layer element: ", cp]);
    Epqinf := SptSetSpecSeqComponent2Inf(SS, p, q);
    if not SptSetFpZModuleIsZeroElm(Epqinf, cp) then
      ##SetLeadingLayer(cl, p);
      ##SetLeadingLayerElement(cl, cp);
      #Display(["Purification ended at layer", p]);
      break;
      #return [cl, 0]; # The leading element is nontrivial. Purification complete.
      # TODO: return the coboundary in this path? this behavior now serves as an assertion check for the caller SptSetSpecSeqClassFromLevelCocycle, but this should be changed later.
    fi;

    #Assert(0, SptSetFpZModuleIsZeroElm(
    #SptSetSpecSeqComponent2(SS, p+1, p, q), cp),
    #"Assertion: p+1 should be the highest page with trivialization");
    for r in [p,(p-1)..2] do
      Erpq := SptSetSpecSeqComponent2(SS, r, p, q);
      if not SptSetFpZModuleIsZeroElm(Erpq, cp) then
        #Error("purification at r>2 is not implimented.");

        bdry2 := PartialPurify@(coc, p, r, cp);
        SptSetStackInplace(bdry, bdry2);        
      fi;
    od;

    bdry2 := PartialPurifyCoboundary@(coc, p, cp);
    SptSetStackInplace(bdry, bdry2);
    #if ValueOption("PurifyDebug") = true then
    #  Display(coc!.layers[3] = ZeroCocycle@);
    #fi;
  od;

#  if ValueOption("PurifyDebug") = true then
#    Display(coc!.layers[3] = ZeroCocycle@);
#  fi;
  # cl!.cochain := coc;
  SetLeadingLayer(cl, p);
  #Display(["Debugging: ", cl!.cochain!.layers[3](g, g)]);
  #Display(["Purification completed at layer", p+1]);
  #return [cl, bdry];
  return bdry;
end);

InstallGlobalFunction(PartialPurify@,
function(coc, p, r, cp)
  Error("Not implemented!");
  #drm1 := SptSetSpecSeqDerivative2(SS, r-1, p-r+1, q+r-2);
  #beta := SptSetZLMapInverse(drm1, cp);
  #beta_ := SptSetMapToBarCocycle(SS!.brMap, p-r+1, spectrum[q+r-2+1], beta);
  #cbeta := SptSetSpecSeqCoboundarySL(SS, ??, ??, NegativeInhomoCochain@(beta_));
end);

InstallGlobalFunction(PartialPurifyCoboundary@,
function(coc, p, cp)
  local F, SS, deg, brMap, q,
  cp_, n, n_, bdry, dnc;
  F := FamilyObj(coc);
  SS := F!.specSeq;
  deg := F!.degree;
  brMap := SS!.brMap;
  q := deg - p;

  bdry := SptSetSpecSeqCochainZero(SS, deg-1);
  cp_ := coc!.layers[p+1];
  # cp_ must be a trivial coboundary.
  n := SptSetZLMapInverse(SptSetSpecSeqDerivative2(SS, 1, p-1, q), cp);
  n_ := SptSetSolveCocycleEq(brMap, p, SS!.spectrum[q+1], cp_, n);
  # n_ := NegativeInhomoCochain@(n_);
  # bdry!.layers[p-1 +1] := n_;
  
  bdry!.layers[p-1 +1] := NegativeInhomoCochain@(n_);

  dnc := SptSetSpecSeqCoboundarySL(SS, deg-1, p-1, NegativeInhomoCochain@(n_));
  SptSetStackInplace(coc, dnc);
  coc!.layers[p+1] := ZeroCocycle@;

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
