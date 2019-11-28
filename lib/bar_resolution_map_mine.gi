DeclareRepresentation(
  "IsSptSetBarResMapMineRep",
  IsCategoryOfSptSetBarResMap and IsComponentObjectRep,
  ["hapResolution", "group", "toBarCache", "fromBarCache"]
);

BindGlobal("TheTypeSptSetBarResMapMine",
NewType(TheFamilyOfSptSetBarResMaps, IsSptSetBarResMapMineRep));

InstallMethod(SptSetConstructBarResMap,
"construct a bar res map of my implimentation",
[IsSptSetBarResMapMineRep, IsHapResolution],
function(filter, R)
  local G, toBarCache, deg;
  G := GroupOfResolution(R);
  toBarCache := [];
  for deg in [0..Length(R)] do
    toBarCache[deg+1] := [];
  od;
  toBarCache[1][1] := [ [ 1, Identity(G)] ];
  return Objectify(TheTypeSptSetBarResMapMine,
  rec(hapResolution := R, group := G, toBarCache := toBarCache));
end);

# some local functions

BarResolutionHomotopy@ := function(gid, k, g, word)
  local x;
  for x in word do
    x[1] := x[1] * k;
    Add(x, g * x[2], 3);
    x[2] := gid;
  od;
end;

HapResolutionHomotopy@ := function(R, deg, k, g, word)
  local elts, gid, hword, x, xs, xb, xg, gxg, gxgid, hxgb, xx;
  elts := R!.elts;
  gid := Identity(GroupOfResolution(R));
  hword := [];
  for x in word do
    xs := x[1];
    xb := x[2];
    xg := elts[x[3]];
    gxg := g * xg;
    gxgid := Position(elts, gxg);
    if gxgid = fail then
      Add(elts, gxg);
      gxgid := Length(elts);
    fi;
    hxgb := R!.homotopy(deg, [xb, gxgid]);
    for xx in hxgb do
      Add(hword, [k * xs * SignInt(xx[1]), AbsInt(xx[1]), xx[2]]);
    od;
  od;
  return hword;
end;

BarResolutionBoundary@ := function(gid, glist)
  local n, dglist, gl2, glext, i;
  n := Length(glist);
  dglist := [];
  if n > 0 then
    gl2 := StructuralCopy(glist);
    Add(gl2, 1, 1);
    Add(dglist, gl2);

    glext := StructuralCopy(glist);
    Add(glext, 1, 1);
    Add(glext, gid, 2);

    for i in [1..(n-1)] do
      gl2 := StructuralCopy(glext);
      gl2[i+2] := gl2[i+2] * Remove(gl2, i+3);
      if i mod 2 = 1 then
        gl2[1] := -1;
      fi;
      Add(dglist, gl2);
    od;

    gl2 := StructuralCopy(glext);
    if n mod 2 = 1 then
      gl2[1] := -1;
    fi;
    Remove(gl2, n+2);
    Add(dglist, gl2);
  fi;
  return dglist;
end;

BarWordSimplify@ := function(word)
  local n, x, x0, word2;
  word2 := [];
  if word = [] then
    return word2;
  fi;
  n := Length(word[1]);
  SortBy(word, x -> x{[2..n]});
  x0 := fail;
  for x in word do
    if x0 = fail then
      x0 := x;
    elif x0{[2..n]} <> x{[2..n]} then
      Add(word2, x0);
      x0 := x;
    else
      x0[1] := x0[1] + x[1];
    fi;
  od;
  Add(word2, x0);
  return word2;
end;

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
        BarResolutionHomotopy@(gid, xs, xg, fxb);
        Append(fei, fxb);
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
  local R, elts, gid, ans, dg, xdg, glxdg, fglxdg, hfglxdg;

  R := brMap!.hapResolution;
  elts := R!.elts;
  gid := Identity(brMap!.group);

  if gid in glist then
    return [];
  fi;
  if deg = 0 then
    return [ [1, 1, Position(elts, gid)] ];
  fi;

  ans := [];

  dg := BarResolutionBoundary@(gid, glist);
  for xdg in dg do
    glxdg := xdg{[3..(deg+1)]};
    fglxdg := StructuralCopy(SptSetMapFromBarWord(brMap, deg-1, glxdg));
    hfglxdg := HapResolutionHomotopy@(R, deg-1, xdg[1], xdg[2], fglxdg);
    Append(ans, hfglxdg);
  od;
  return ans;
end);

InstallMethod(SptSetMapEquivBarWord,
"compute the homotopy equivalence of a bar-resolution word",
[IsSptSetBarResMapMineRep, IsList],
function(brMap, glist)
  local gid, deg, dgl, hdgl, fgl, x, fx, xfx, w;
  gid := Identity(brMap!.group);
  deg := Length(glist);

  w := [];

  # TODO: the boundary condition.

  dgl := BarResolutionBoundary@(gid, glist);
  # computes -h(d(gl)) and adds it to w
  for x in dgl do:
    fx := StructuralCopy(SptSetMapEquivBarWord(brMap, x{[3..(deg+1)]}));
    for xfx in fx do:
      xfx[1] := -x[1] * xfx[1];
      xfx[2] := x[2] * xfx[2];
      Add(w, xfx);
    od;
  od;

  gl2 := SptSetMapFromBarWord(brMap, deg, glist);
  w := [1, gid];
  Append(w, glist);
  for x in gl2 do
    fx := StructuralCopy(SptSetMapToBarWord(brMap, deg, x));
    fx[1] := -fx[1];
    Append(w, fx);
  od;
  w := BarWordSimplify@(w);
end);
