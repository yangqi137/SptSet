LoadPackage("SptSet");

#omega0 := {g1, g2} -> 0;

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
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
cl3 := cl2 + cl1;
SptSetPurifySpecSeqClass(cl3);
a_ := cl2!.cochain!.layers[4];
a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
Display(SptSetFpZModuleCanonicalElm(E30inf, a));
