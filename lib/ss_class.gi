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
