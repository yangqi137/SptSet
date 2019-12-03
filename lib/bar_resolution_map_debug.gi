DeclareRepresentation(
"IsSptSetBarResMapDebugRep",
IsCategoryOfSptSetBarResMap and IsComponentObjectRep,
["hapResolution", "group", "hap", "mine"]
);

BindGlobal(
"TheTypeSptSetBarResMapDebug",
NewType(TheFamilyOfSptSetBarResMaps, IsSptSetBarResMapDebugRep)
);

InstallMethod(SptSetConstructBarResMap,
"construct a bar res map that compares my and HAP results for debugging",
[IsSptSetBarResMapDebugRep, IsHapResolution],
function(filter, R)
  return Objectify(TheTypeSptSetBarResMapDebug,
  rec(hapResolution := R, group := GroupOfResolution(R),
    hap := SptSetConstructBarResMap(IsSptSetBarResMapHapRep, R),
    mine := SptSetConstructBarResMap(IsSptSetBarResMapMineRep, R)));
end);

DeleteIDFromBarWord@ := function(gid, word)
  local x, w2, n;
  w2 := [];
  for x in word do
    n := Length(x);
    if not (gid in x{[3..n]}) then
      Add(w2, StructuralCopy(x));
    fi;
  od;
  return w2;
end;

CompareWords@ := function(w1, w2)
  local wd;
  wd := StructuralCopy(w1);
  Perform(wd, function(x) x[1] := -x[1]; end);
  Append(wd, StructuralCopy(w2));
  return WordSimplify@(wd) = [];
end;

InstallMethod(SptSetMapFromBarWord,
"map from a word in bar resolution",
[IsSptSetBarResMapDebugRep, IsInt, IsList],
function(brMap, deg, glist)
  local wh, wm, wdiff;
  wh := StructuralCopy(SptSetMapFromBarWord(brMap!.hap, deg, glist));
  wm := StructuralCopy(SptSetMapFromBarWord(brMap!.mine, deg, glist));
  Assert(0, CompareWords@(wh, wm));
  return wh;
end);

InstallMethod(SptSetMapToBarWord,
"map to a word in bar resolution",
[IsSptSetBarResMapDebugRep, IsInt, IsPosInt],
function(brMap, deg, i)
  local wh, wm, wdiff;
  wh := StructuralCopy(SptSetMapToBarWord(brMap!.hap, deg, i));
  wm := StructuralCopy(SptSetMapToBarWord(brMap!.mine, deg, i));
  wh := DeleteIDFromBarWord@(Identity(brMap!.group), wh);
  Assert(0, CompareWords@(wh, wm));
  return wh;
end);

InstallMethod(SptSetMapEquivBarWord,
"compute the homotopy equivalence of a word",
[IsSptSetBarResMapDebugRep, IsList],
function(brMap, glist)
  local wh, wm, wdiff;
  wh := StructuralCopy(SptSetMapEquivBarWord(brMap!.hap, glist));
  wm := StructuralCopy(SptSetMapEquivBarWord(brMap!.mine, glist));
  wh := DeleteIDFromBarWord@(Identity(brMap!.group), wh);
  Assert(0, CompareWords@(wh, wm));
  return wh;
end);
