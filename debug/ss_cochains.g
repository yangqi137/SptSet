LoadPackage("SptSet");
G := CyclicGroup(2);
Display("Computing group structure with G = Z2");
x := GeneratorsOfGroup(G)[1];
gid := Identity(G);
R := ResolutionFiniteGroup(G, 7);
utAct := SptSetTrivialGroupAction(G);
ss := FermionEZSPTSpecSeq(R, utAct);
layers := FermionSPTLayers(ss, 2);
Display("Layers:");
Display(layers);

Display("Stacking two copies of the first-layer generator:");
v1 := layers[1]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(ss, 3, 1, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
#layer3 := cl2!.cochain!.layers[3];
#SptSetPurifySpecSeqClass(cl2 : PurifyDebug := true);
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));

Display("Stacking two copies of the second-layer generator:");
v1 := layers[2]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(ss, 3, 2, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
#layer3 := cl2!.cochain!.layers[3];
#SptSetPurifySpecSeqClass(cl2 : PurifyDebug := true);
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));

SG := SpaceGroupBBNWZ(2, 3);
Display("Computing group structure with G = pm");
fSG := IsomorphismPcpGroup(SG);
SG1 := Image(fSG);
R := ResolutionAlmostCrystalGroup(SG1, 6);
gs := GeneratorsOfGroup(SG);

f := GroupHomomorphismByImagesNC(SG1, GL(1, Integers),
  List(gs, x -> Image(fSG, x)),
  List(gs, x -> [[DeterminantMat(x)]]));

SS := FermionEZSPTSpecSeq(R, f);
layers := FermionSPTLayers(SS, 2);
Display("Layers:");
Display(layers);

Display("Stacking two copies of the first-layer generator:");
v1 := layers[1]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 1, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
#layer3 := cl2!.cochain!.layers[3];
#SptSetPurifySpecSeqClass(cl2 : PurifyDebug := true);
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));
