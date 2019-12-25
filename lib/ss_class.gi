DeclareRepresentation(
"IsSptSetSpecSeqCochainRep",
IsCategoryOfSptSetSpecSeqCochain and IsComponentObjectRep,
["layers"]
);

InstallMethod(\+,
"add two classes",
IsIdenticalObj,
[IsSptSetSpecSeqCochainRep, IsSptSetSpecSeqCochainRep],
function(c1, c2)
  local F, SS;
  F := FamilyObj(c1);
  SS := F!.specSeq;
end);

InstallGlobalFunction(SptSetPurifySpecSeqClass,
function(c)
  local F, SS, brMap, deg, p;
  F := FamilyObj(c);
  SS := F!.specSeq;
  brMap := SS!.brMap;
  deg := F!.deg;
  p := PositionBound(c!.layers);
  cp := c!.layers[p];
  cpv := SptSetMapFromBarCocycle(brMap, p, SS!.spectrum[q+1], cp);
end);
