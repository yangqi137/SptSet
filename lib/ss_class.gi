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
  local F, SS, deg, coc, brMap, bdry, bdry2, p, q, cp, cp_, Epqinf, r, Erpq;

  F := FamilyObj(cl);
  SS := F!.specSeq;
  deg := F!.degree;
  coc := cl!.cochain;
  brMap := SS!.brMap;

  bdry := SptSetSpecSeqCochainZero(SS, deg-1);

  for p in [0..deg] do
    #if p = deg then
      #Display("Last layer does not need tobe purified.");
      #break;
    #fi;
    if coc!.layers[p+1] = ZeroCocycle@ then
      continue;
    fi;
    q := deg - p;
    cp_ := coc!.layers[p+1];
    cp := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp_);
    Assert(-1, ForAll(cp, IsInt), "ASSERTION FAILURE: top layer is not a cocycle");

    Epqinf := SptSetSpecSeqComponent2Inf(SS, p, q);
    if not SptSetFpZModuleIsZeroElm(Epqinf, cp) then
      break;
    fi;

    #Assert(0, SptSetFpZModuleIsZeroElm(
    #SptSetSpecSeqComponent2(SS, p+1, p, q), cp),
    #"Assertion: p+1 should be the highest page with trivialization");
    for r in [p,(p-1)..2] do
      Erpq := SptSetSpecSeqComponent2(SS, r, p, q);
      if not SptSetFpZModuleIsZeroElm(Erpq, cp) then
        bdry2 := PartialPurify@(coc, p, r, cp);
        SptSetStackInplace(bdry, bdry2);
      fi;
    od;

    bdry2 := PartialPurifyCoboundary@(coc, p, cp);
    SptSetStackInplace(bdry, bdry2);
    # bdry!.layers[p-1+1] := bdry2!.layers[p-1+1];

  od;

  cl!.cochain := coc;
  SetLeadingLayer(cl, p);

  return bdry;
end);

InstallGlobalFunction(PartialPurify@,
function(coc, p, r, cp)
    local F, SS, deg, brMap, q,
          dr, beta, beta_, bdry, dbeta;
    F := FamilyObj(coc);
    SS := F!.specSeq;
    deg := F!.degree;
    brMap := SS!.brMap;
    q := deg - p;

    if r > 2 then
      Error("Purification at r>2 is not implemented.");
    fi;

    dr := SptSetSpecSeqDerivative2(SS, r, p-r, q+r-1);
    beta := SptSetZLMapInverse(dr, cp);
    beta_ := SptSetMapToBarCocycle(brMap, p-r, SS!.spectrum[q+r-1 +1], beta);

    dbeta := SptSetSpecSeqCoboundarySL(SS, deg-1, p-r, NegativeInhomoCochain@(beta_));
    dbeta!.layers[p-r+1+1] := ZeroCocycle@;
    SptSetStackInplace(coc, dbeta);
    
    bdry := SptSetSpecSeqCochainZero(SS, deg-1);
    bdry!.layers[p-r+1] := NegativeInhomoCochain@(beta_);
    return bdry;
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
  # bdry!.layers[p-1 +1] := n_;

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
