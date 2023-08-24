LoadPackage("SptSet");

it := 2;
SG := SpaceGroupBBNWZ(2, it);
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

E12inf := SptSetSpecSeqComponentEx(SS, 1, 2);
E21inf := SptSetSpecSeqComponentEx(SS, 2, 1);
E1221 := SptSetSpecSeqModuleExtension(E12inf, E21inf);
SptSetFpZModuleCanonicalForm(E1221);
Display(E1221);
E30inf := SptSetSpecSeqComponentEx(SS, 3, 0);
E122130 := SptSetSpecSeqModuleExtension(E1221, E30inf);
SptSetFpZModuleCanonicalForm(E122130);
Display(E122130);