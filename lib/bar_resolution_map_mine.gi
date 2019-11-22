DeclareRepresentation(
  "IsSptSetBarResMapMineRep",
  IsCategoryOfSptSetBarResMap and IsComponentObjectRep,
  ["hapResolution", "group", "toBarCache", "fromBarCache"]
);

BindGlobal("TheTypeSptSetBarResMapMine",
NewType(TheFamilyOfSptSetBarResMaps, IsSptSetBarResMapMineRep));

InstallMethod(SptSetMapToBarWord,
"map to a word in bar resolution",
[IsSptSetBarResMapMineRep, IsInt, IsPosInt],
function(brMap, deg, i)
  local R, elts, gid, fei, dei, x, xs, xb, xg, fxb, xfxb;
  if not IsBound(brMap!.toBarCache[deg+1][i]) then
    R := brMap!.hapResolution;
    elts := R!.elts;
    gid := Identity(brMap!.group);
    fei := [];
    dei := StructuralCopy(BoundaryMap(R)(deg, i));
    for x in dei do
      xs := SignInt(x[1]);
      xb := AbsInt(x[1]);
      xg := elts[x[2]];
      if xg <> gid then
        fxb := StructuralCopy(SptSetMapToBarWord(brMap, deg-1, xb));
        for xfxb in fxb do
          xfxb[1] := xfxb[1] * xs;
          Add(xfxb, xg, 3);
          Add(fei, xfxb);
        od;
      fi;
    od;
    brMap!.toBarCache[deg+1][i] := fei;
  fi;
  return brMap!.toBarCache[deg+1][i];
end);

InstallMethod(SptSetMapFromBarWord,
"map from a word in bar resolution",
[IsSptSetBarResMapMineRep, IsInt, IsList],
function(brMap, deg, glist)
  local R, elts, gid, dg, xdg, glxdg, fglxdg;

  R := brMap!.hapResolution;
  elts := R!.elts;
  gid := Identity(brMap!.group);

  dg := BarResolutionBoundary(glist);
  for xdg in dg do
    glxdg := xdg{[3..(deg+1)]};
    fglxdg := SptSetMapFromBarWord(brMap, deg-1, glxdg);

  od;
end);
