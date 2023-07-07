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

InstallMethod(SptSetStackInplace,
"stack the second cochain to the first",
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

  c1!.layers := layers;
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

InstallGlobalFunction
    (PartialConstructSSCochain@,
        function(SS, deg, p, cp, r)
            local brMap, q, coc, cp_, dc, p2, r2, dcp2_, dcp2;
            brMap := SS!.brMap;
            q := deg - p;
            coc := SptSetSpecSeqCochainZero(SS, deg);

            cp_ := SptSetMapToBarCocycle(brMap, p, SS!.spectrum[q+1], cp);
            coc!.layers[p+1] := cp_;
            dc := SptSetSpecSeqCoboundarySL(SS, deg, p, cp_);
            dc!.layers[p+1 +1] := ZeroCocycle@ ; # cp_ must be a cocycle.

            for p2 in [(p+1)..(p+1+r)] do
                for r2 in [(p2-p), 2] do
                    dcp2_ := dc!.layers[p2+1];
                    
                od;
                
                    
            od;
        end);

            
        
