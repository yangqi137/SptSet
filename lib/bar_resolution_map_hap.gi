DeclareRepresentation(
  "IsSptSetBarResMapHapRep",
  IsCategoryOfSptSetBarResMap and IsComponentObjectRep,
  ["hapResolution", "group", "hapEquiv"]
);

BindGlobal(
  "TheTypeSptSetBarResMapHap",
  NewType(TheFamilyOfSptSetBarResMaps, IsSptSetBarResMapHapRep)
);

InstallMethod(SptSetBarResolutionMap,
  "create a map to/from the bar resolution",
  [IsHapResolution],
  function(R)
    local G;
    G := GroupOfResolution(R);
    return Objectify(TheTypeSptSetBarResMapHap,
      rec(hapResolution := R, group := G,
        hapEquiv := BarResolutionEquivalence(R)));
  end);

InstallMethod(SptSetMapFromBarWord,
  "map from a word in bar resolution",
  [IsSptSetBarResMapHapRep, IsInt, IsList],
  function(brMap, deg, glist)
    local w;
    w := [];
    w[1] := [1, Identity(brMap!.group)];
    Append(w[1], glist);
    return brMap!.hapEquiv!.phi(deg, w);
  end);

InstallMethod(SptSetMapToBarWord,
  "map to a word in bar resolution",
  [IsSptSetBarResMapHapRep, IsInt, IsPosInt],
  function(brMap, deg, i)
    local w, idpos;
    idpos := Position(brMap!.hapResolution!.elts, Identity(brMap!.group));
    if idpos = fail then
      Display("Adding new element");
      Add(brMap!.hapResolution!.elts, Identity(brMap!.group));
      idpos := Length(brMap!.hapResolution!.elts);
    fi;
    #w := [ [1, idpos, i] ];
    w := [ [1, i, idpos] ];
    return brMap!.hapEquiv!.psi(deg, w);
  end);

InstallMethod(SptSetMapEquivBarWord,
"compute the homotopy equivalence of a bar-resolution word",
[IsSptSetBarResMapHapRep, IsList],
function(brMap, glist)
  local deg, w;
  deg := Length(glist);
  w := [1, Identity(brMap!.group)];
  Append(w, glist);
  return brMap!.hapEquiv!.equiv(deg, [w]);
end);
