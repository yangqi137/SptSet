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

InstallGlobalFunction(SptSetSpecSeqCochainZero,
function(ss, deg)
  local layers, p;
  layers := [];
  for p in [0..deg] do
    layers[p+1] := ZeroCocycle@;
  od;
  return SptSetSpecSeqCochain(ss, deg, layers);
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
  layers := [];
  for p in [0..deg] do
    q := deg - p;
    layers[p+1] := AddInhomoCochain@(c1!.layers[p+1], c2!.layers[p+1]);
    if p > 0 then # the p=0 layer cannot be twisted
      layers[p+1] := AddInhomoCochain@(layers[p+1],
      SS!.addTwister[p+1][q+1](c1!.layers, c2!.layers));
    fi;
  od;

  return SptSetSpecSeqCochain(SS, deg, layers);
end);

InstallGlobalFunction(SptSetSpecSeqCoboundarySL,
function(SS, deg, p, a)
  local gid, q, dalayers, da, rmax, r, pp;
  gid := Identity(GroupOfResolution(SS!.resolution));
  q := deg - p;
  dalayers := [];
  da := InhomoCoboundary@(SS!.spectrum[q+1], a);
  for pp in [0..p] do
    dalayers[pp+1] := ZeroCocycle@;
  od;
  dalayers[(p+1)+1] := da;
  rmax := q + 1;
  for r in [2..rmax] do
    dalayers[p + r +1] := NegativeInhomoCochain@(SS!.bdry[r+1][p+1][q+1](a, da));
  od;
  return SptSetSpecSeqCochain(SS, deg+1, dalayers);
end);

InstallGlobalFunction(SptSetSpecSeqCoboundary,
function(c)
  local F, SS, deg, p, dcp, dc;
  F := FamilyObj(c);
  SS := F!.specSeq;
  deg := F!.degree;

  dc := SptSetSpecSeqCochainZero(SS, deg);

  for p in [0..deg] do
    if c!.layers[p+1] <> ZeroCocycle@ then
      dcp := SptSetSpecSeqCoboundarySL(SS, deg, p, c!.layers[p+1]);
      dc := SptSetStack(dc, dcp);
    fi;
  od;

  return dc;
end);
