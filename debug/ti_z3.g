LoadPackage("SptSet");

CheckU1CochainIsZero := function(G, n, a)
  local m, gs, i, gss, glist, gsc;
  m := Size(G);
  gs := List(G);
  Remove(gs, Position(gs, Identity(G)));

  gss := [];
  for i in [1..n] do
    Add(gss, gs);
  od;
  gsc := Cartesian(gss);

  for glist in gsc do
    Assert(-1, IsInt(CallFuncList(a, glist)), "ASSERTION FAILURE: cochain entry is nonzero");
  od;
end;

CheckZCochainIsZero := function(G, n, a)
  local m, gs, i, gss, glist, gsc;
  m := Size(G);
  gs := List(G);
  Remove(gs, Position(gs, Identity(G)));

  gss := [];
  for i in [1..n] do
    Add(gss, gs);
  od;
  gsc := Cartesian(gss);

  for glist in gsc do
    Assert(-1, CallFuncList(a, glist) = 0 , "ASSERTION FAILURE: cochain entry is nonzero");
  od;
end;

CheckU1CochainsEqual := function(G, n, a, b)
  local m, gs, i, gss, glist, gsc;
  m := Size(G);
  gs := List(G);
  Remove(gs, Position(gs, Identity(G)));

  gss := [];
  for i in [1..n] do
    Add(gss, gs);
  od;
  gsc := Cartesian(gss);

  for glist in gsc do
    Assert(-1, IsInt(CallFuncList(a, glist) - CallFuncList(b, glist)), "ASSERTION FAILURE: cochain entries are not equal");
  od;
end;

CheckZCochainsEqual := function(G, n, a, b)
  local m, gs, i, gss, glist, gsc;
  m := Size(G);
  gs := List(G);
  Remove(gs, Position(gs, Identity(G)));

  gss := [];
  for i in [1..n] do
    Add(gss, gs);
  od;
  gsc := Cartesian(gss);

  for glist in gsc do
    Assert(-1, CallFuncList(a, glist) = CallFuncList(b, glist), "ASSERTION FAILURE: cochain entries are not equal");
  od;
end;

G := CyclicGroup(3);
#G := DihedralGroup(6);
R := ResolutionFiniteGroup(G, 7);
gs := GeneratorsOfGroup(G);
#f := GroupHomomorphismByImagesNC(G, GL(1, Integers), gs, [ [[-1]], [[1]] ]);
f := SptSetTrivialGroupAction(G);
ww := {g1, g2} -> 0;

SS := InsulatorSPTSpecSeq(R, f, f, ww);
InsulatorSPTLayersVerbose(SS, 2);

layers := FermionSPTLayers(SS, 2);
Display("Layers:");
Display(layers);

n := SptSetNumberOfGenerators(layers[2]);

E30inf := SptSetSpecSeqComponent2Inf(SS, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);

v1 := layers[2]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
cl1_n2 := cl1!.cochain!.layers[2+1];
#dcl1_n2 := InhomoCoboundary@SptSet(SS!.spectrum[1+1], cl1_n2);
cl1_nu := cl1!.cochain!.layers[3+1];
dcl1_nu := InhomoCoboundary@SptSet(SS!.spectrum[0+1], cl1_nu);
#CheckU1CochainIsZero(G, 4, dcl1_nu);
o4 := NegativeInhomoCochain@SptSet(SS!.bdry[2+1][2+1][1+1](cl1_n2, ZeroCocycle@SptSet));
CheckU1CochainsEqual(G, 4, dcl1_nu, o4);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
cl3 := cl2 + cl1;
cl3_n2 := cl3!.cochain!.layers[2+1];
#dcl1_n2 := InhomoCoboundary@SptSet(SS!.spectrum[1+1], cl1_n2);
cl3_nu := cl3!.cochain!.layers[3+1];
dcl3_nu := InhomoCoboundary@SptSet(SS!.spectrum[0+1], cl3_nu);
#CheckU1CochainIsZero(G, 4, dcl1_nu);
o4 := NegativeInhomoCochain@SptSet(SS!.bdry[2+1][2+1][1+1](cl3_n2, ZeroCocycle@SptSet));
CheckU1CochainsEqual(G, 4, dcl3_nu, o4);

# Check purification
n2_ := cl3_n2;
brMap := SS!.brMap;
n2 := SptSetMapFromBarCocycle(brMap, 2, SS!.spectrum[1+1], n2_);
Display(n2);
n1 := SptSetZLMapInverse(SptSetSpecSeqDerivative2(SS, 1, 1, 1), n2);
n1_ := SptSetSolveCocycleEq(brMap, 2, SS!.spectrum[1+1], n2_, n1);
dn1_ := InhomoCoboundary@SptSet(SS!.spectrum[1+1], n1_);
CheckZCochainsEqual(G, 2, dn1_, n2_);

del_n1 := SptSetSpecSeqCoboundarySL(SS, 2, 1, NegativeInhomoCochain@SptSet(n1_));
# check if del_n1 is consistent?
del_n1_nu3 := del_n1!.layers[3+1];
del_n1_n2 := del_n1!.layers[2+1];
d_del_n1_nu3 := InhomoCoboundary@SptSet(SS!.spectrum[0+1], del_n1_nu3);
Display("Check if del_n1 has nu3 = 0?");
CheckU1CochainIsZero(G, 3, del_n1_nu3);
Display("Check if del_n1 has dnu3 = 0?");
CheckU1CochainIsZero(G, 4, d_del_n1_nu3);
o4 := SS!.bdry[2+1][2+1][1+1](del_n1_n2, ZeroCocycle@SptSet);
Display("Check if del_n1 has dnu3 = o4[n2]?");
CheckU1CochainsEqual(G, 4, d_del_n1_nu3, o4);

coc := SptSetStack(cl3!.cochain, del_n1);
CheckZCochainIsZero(G, 2, coc!.layers[2+1]);
nu3_ := coc!.layers[3+1];
dnu3_ := InhomoCoboundary@SptSet(SS!.spectrum[0+1], nu3_);
Display("This may fail...");
CheckU1CochainIsZero(G, 4, dnu3_);

SptSetPurifySpecSeqClass(cl3);
a_ := cl2!.cochain!.layers[4];
a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
Display(SptSetFpZModuleCanonicalElm(E30inf, a));
