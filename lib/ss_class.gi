DeclareRepresentation(
"IsSptSetSpecSeqClassRep",
IsCategoryOfSPtSetSpecSeqClass and IsComponentObjectRep,
["layers"]
);

InstallMethod(\+,
"add two classes",
IsIdenticalObj,
[IsSptSetSpecSeqClassRep, IsSptSetSpecSeqClassRep],
function(c1, c2)
  local F, SS;
  F := FamilyObj(c1);
  SS := F!.specSeq;
end);

InstallGlobalFunction(SptSetPurifySpecSeqClass,
function(c)
  local F, SS, brMap, deg, p, q, Epqinf, r, Erpq, n, n_;
  F := FamilyObj(c);
  SS := F!.specSeq;
  brMap := F!.brMap;
  deg := F!.deg;

  while true do
    p := PositionBound(c!.layers);
    q := deg - p;
    if p = fail then
      break;
    fi;
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
          else
            n_ := SptSetMapToBarCocycle(brMap, p-1, SS!.spectrum[q+1], n);
          fi;
          
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
