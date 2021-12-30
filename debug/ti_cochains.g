LoadPackage("SptSet");

omega0 := {g1, g2} -> 0;

it := 7;
SG := SpaceGroupBBNWZ(2, it);
fSG := IsomorphismPcpGroup(SG);
SG1 := Image(fSG);
R := ResolutionAlmostCrystalGroup(SG1, 6);
gs := GeneratorsOfGroup(SG);

f := GroupHomomorphismByImagesNC(SG1, GL(1, Integers),
  List(gs, x -> Image(fSG, x)),
  List(gs, x -> [[DeterminantMat(x)]]));

  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "HAP");
  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "debug");
SS := InsulatorSPTSpecSeq(R, f, f, omega0);
InsulatorSPTLayersVerbose(SS, 2);
layers := FermionSPTLayers(SS, 2);
Display("Layers:");
Display(layers);

v1 := layers[2]!.generators[1];
cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));

a_ := cl2!.cochain!.layers[4];
brm := SS!.brMap;
gAct := SS!.spectrum[0+1]!.gAction;
a := SptSetMapFromBarCocycle(brm, 3, SS!.spectrum[0+1], a_);
Display(a);
E30inf := SptSetSpecSeqComponent2Inf(SS, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);
Display(a * E30inf!.projection);
Display(E30inf!.relations);

v1 := layers[2]!.generators[2];
cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
SptSetPurifySpecSeqClass(cl1);
cl2 := cl1 + cl1;
SptSetPurifySpecSeqClass(cl2);
Display(LeadingLayer(cl2));

a_ := cl2!.cochain!.layers[4];
brm := SS!.brMap;
gAct := SS!.spectrum[0+1]!.gAction;
a := SptSetMapFromBarCocycle(brm, 3, SS!.spectrum[0+1], a_);
Display(a);
E30inf := SptSetSpecSeqComponent2Inf(SS, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);
Display(a * E30inf!.projection);
Display(E30inf!.relations);
