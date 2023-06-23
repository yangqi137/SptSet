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
Display("Leading layer x2:");
Display(LeadingLayer(cl2));
cl4 := cl2 + cl2;
SptSetPurifySpecSeqClass(cl4);
Display("Leading layer x4:");
Display(LeadingLayer(cl4));

E30inf := SptSetSpecSeqComponentInf(ss, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);

a_ := cl4!.cochain!.layers[4];
a := SptSetMapFromBarCocycle(ss!.brMap, 3, ss!.spectrum[0+1], a_);        
Display(SptSetFpZModuleCanonicalElm(E30inf, a));

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
Display("Leading layer x2: ");
Display(LeadingLayer(cl2));

E21inf := SptSetSpecSeqComponentInf(SS, 2, 1);
SptSetFpZModuleCanonicalForm(E21inf);

a_ := cl2!.cochain!.layers[3];
a := SptSetMapFromBarCocycle(SS!.brMap, 2, SS!.spectrum[1+1], a_);        
Display(SptSetFpZModuleCanonicalElm(E21inf, a));

cl4 := cl2 + cl2;
SptSetPurifySpecSeqClass(cl4);
Display("Leading layer x4:");
Display(LeadingLayer(cl4));

E30inf := SptSetSpecSeqComponentInf(SS, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);

a_ := cl4!.cochain!.layers[4];
a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);        
Display(SptSetFpZModuleCanonicalElm(E30inf, a));

Display("Stacking two copies of the second-layer generator:");
v2 := layers[2]!.generators[1];
cl2 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v2);
cl22 := cl2 + cl2;
SptSetPurifySpecSeqClass(cl22);
Display("Leading layer x2: ");
Display(LeadingLayer(cl22));

a_ := cl22!.cochain!.layers[4];
a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);        
Display(SptSetFpZModuleCanonicalElm(E30inf, a));
