DeclareRepresentation(
"IsSptSetSpecSeqCochainRep",
IsCategoryOfSptSetSpecSeqCochain and IsComponentObjectRep,
["layers"]
);

InstallGlobalFunction(SptSetSpecSeqCochain,
function(ss, deg, layers)
  local t;
  t := SptSetSpecSeqCochainType(ss, deg);
  return Objectify(t, rec(layers := layers));
end);

InstallMethod(SptSetStack,
"stack two cochains",
IsIdenticalObj,
[IsSptSetSpecSeqCochainRep, IsSptSetSpecSeqCochainRep],
function(c1, c2)
  local F, SS, deg, p, layers, q;
  F := FamilyObj(c1);
  SS := F!.specSeq;
  deg := F!.degree;
  layers := []
  for p in [1..deg] do
    q := deg - p;
    layers[p] := AddInhomoCochain@(c1!.layers[p], c2!.layers[p]);
    layers[p] := AddInhomoCochain@(layers[p],
    SS!.addTwister[p+1][q+1](c1!.layers, c2!.layers));
  od;

  return SptSetSpecSeqCochain(SS, deg, layers);
end);

InstallGlobalFunction(SptSetSpecSeqCoboundarySL,
function(SS, deg, p, a)
  local dalayers, da, rmax, r, pp, q;
  q := deg - p;
  dalayers := [];
  da := InhomoCoboundary@(a);
  for pp in [1..p] do
    dalayers[pp] := ZeroCocycle@;
  od;
  dalayers[p+1] := da;
  rmax := q + 1;
  for r in [2..rmax] do
    dalayers[p + r] := SS!.bdry[r+1][p+1][q+1](a, da);
  od;
  return SptSetSpecSeqCochain(SS, deg+1, dalayers);
end);

InstallGlobalFunction(SptSetPurifySpecSeqClass,
function(c)
  local F, SS, brMap, deg, p, q, Epqinf, r, Erpq, n, n_,
  pp, rpp, npp;
  F := FamilyObj(c);
  SS := F!.specSeq;
  brMap := F!.brMap;
  deg := F!.degree;

  while true do
    p := PositionBound(c!.layers);
    if p = fail then
      break;
    fi;
    q := deg - p;
    cp := c!.layers[p];
    cpv := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp);
    Epqinf := SptSetSpecSeqComponentInf(SS, p, q);
    if SptSetFpZModuleIsZeroElm(Epqinf, cpv) then
      # it is a trivial element. try to eliminate it.
      # find the first page on which cpv is trivial:
      r := 2;
      while true do
        Erpq := SptSetSpecSeqComponent(SS, r, p, q);
        if SptSetFpZModuleIsZeroElm(Erpq, cpv) then
          # trivialize
          n := ??;
          if r = 2 then
            n_ := SptSetSolveCocycleEq(brMap, p, SS!.spectrum[q+1], cp, n);
            Unbind(c!.layers, p);
          else
            n_ := SptSetMapToBarCocycle(brMap, p-1, SS!.spectrum[q+1], n);
            c!.layers[p] := SubstractInhomoCochain@(c!.layers[p], InhomoCoboundary(n_));
          fi;

          for pp in [(p+1)..deg] do
            rpp := pp - p + 1; # ??
            n_pp_ := SS!.rawDerivative[r][p-1][q+1](n_, ...??);
            c!.layers[pp] := SubstractInhomoCochain@(c!.layers[pp], n_pp_);
          od;

          break;
        fi;
        r := r + 1;
      od;
    else
      # it is nontrivial at layer p. we are done.
      break;
    fi;
  od;
end);
