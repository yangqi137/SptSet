DeclareRepresentation(
  "IsSptSetBarResMapMineRep",
  IsCategoryOfSptSetBarResMap and IsComponentObjectRep,
  ["hapResolution", "group", "toBarCache", "fromBarCache", "equivBarCache"]
);

BindGlobal("TheTypeSptSetBarResMapMine",
NewType(TheFamilyOfSptSetBarResMaps, IsSptSetBarResMapMineRep));

InstallMethod(SptSetConstructBarResMap,
"construct a bar res map of my implimentation",
[IsSptSetBarResMapMineRep, IsHapResolution],
function(filter, R)
  local G, toBarCache, fromBarCache, equivBarCache, deg, maxFromBarCacheDeg;
  G := GroupOfResolution(R);
  toBarCache := [];
  for deg in [0..Length(R)] do
    toBarCache[deg+1] := [];
  od;
  toBarCache[1][1] := [ [ 1, Identity(G)] ];

  fromBarCache := [];
  # maxFromBarCacheDeg := 4;
  for deg in [0..Length(R)] do
    fromBarCache[deg+1] := NewDictionary(R!.elts, true);
  od;

  equivBarCache := [];
  # maxFromBarCacheDeg := 4;
  for deg in [0..Length(R)] do
    equivBarCache[deg+1] := NewDictionary(R!.elts, true);
  od;
  
  return Objectify(TheTypeSptSetBarResMapMine,
  rec(hapResolution := R, group := G, toBarCache := toBarCache,
    fromBarCache := fromBarCache, equivBarCache := equivBarCache));
end);

# some local functions

BarResolutionHomotopy@ := function(gid, k, g, word)
  local hword, x, hx;
  hword := [];
  for x in word do
    hx := StructuralCopy(x);
    hx[1] := k * hx[1];
    Add(hx, g * hx[2], 3);
    hx[2] := gid;
    if hx[3] <> gid then
      Add(hword, hx);
    fi;
  od;
  return hword;
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

InstallGlobalFunction(WordSimplify@,
function(word)
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
      if x0[1] <> 0 then
        Add(word2, x0);
      fi;
      x0 := x;
    else
      x0[1] := x0[1] + x[1];
    fi;
  od;
  if x0[1] <> 0 then
    Add(word2, x0);
  fi;
  return word2;
end);

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
        Append(fei, BarResolutionHomotopy@(gid, xs, xg, fxb));
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

  ans := LookupDictionary(brMap!.fromBarCache[deg+1], glist);
  if ans = fail then

    ans := [];
    dg := BarResolutionBoundary@(gid, glist);
    for xdg in dg do
      glxdg := xdg{[3..(deg+1)]};
      fglxdg := StructuralCopy(SptSetMapFromBarWord(brMap, deg-1, glxdg));
      hfglxdg := HapResolutionHomotopy@(R, deg-1, xdg[1], xdg[2], fglxdg);
      Append(ans, hfglxdg);
    od;
    
    AddDictionary(brMap!.fromBarCache[deg+1], glist, ans);
  fi;

  return ans;
end);

InstallMethod(SptSetMapEquivBarWord,
"compute the homotopy equivalence of a bar-resolution word",
[IsSptSetBarResMapMineRep, IsList],
function(brMap, glist)
  local gid, deg, elts, dgl, hdgl, fgl, x, fx, xfx, w, ans;
  gid := Identity(brMap!.group);
  deg := Length(glist);
  elts := brMap!.hapResolution!.elts;

  # boundary condition.
  if deg = 0 then
    return [];
  fi;

  if gid in glist then
    return [];
  fi;

  ans := LookupDictionary(brMap!.equivBarCache[deg+1], glist);
  if ans = fail then

    w := [];

    dgl := BarResolutionBoundary@(gid, glist);
    # computes -h(d(gl)) and adds it to w
    for x in dgl do
      fx := StructuralCopy(SptSetMapEquivBarWord(brMap, x{[3..(deg+1)]}));
      for xfx in fx do
        xfx[1] := -x[1] * xfx[1];
        xfx[2] := x[2] * xfx[2];
        Add(w, xfx);
      od;
    od;

    # computes f(g(gl))
    fgl := SptSetMapFromBarWord(brMap, deg, glist);
    for x in fgl do
      # format of x : [prefactor, basis, g]
      fx := StructuralCopy(SptSetMapToBarWord(brMap, deg, x[2]));
      for xfx in fx do
        xfx[1] := xfx[1] * x[1];
        xfx[2] := elts[x[3]] * xfx[2];
        Add(w, xfx);
      od;
    od;

    #compute -gl
    x := [-1, gid];
    Append(x, glist);
    Add(w, x);

    w := WordSimplify@(w);
    ans := BarResolutionHomotopy@(gid, 1, gid, w);

    AddDictionary(brMap!.equivBarCache[deg+1], glist, ans);
  fi;
  return ans;
end);
