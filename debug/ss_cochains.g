LoadPackage("SptSet");
G := CyclicGroup(4);
x := GeneratorsOfGroup(G)[1];
gid := Identity(G);
R := ResolutionFiniteGroup(G, 7);
utAct := SptSetTrivialGroupAction(G);
ss := FermionEZSPTSpecSeq(R, utAct);
layers := FermionSPTLayers(ss, 2);
v1 := layers[1]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(ss, 3, 1, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
#SptSetPurifySpecSeqClass(cl2 : PurifyDebug := true);
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));