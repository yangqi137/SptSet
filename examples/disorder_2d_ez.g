LoadPackage("SptSet");

for it in [2..17] do
  Display(it);
  SG := SpaceGroupBBNWZ(2, it);
  fSG := IsomorphismPcpGroup(SG);
  SG1 := Image(fSG);
  R := ResolutionAlmostCrystalGroup(SG1, 6);
  gs := GeneratorsOfGroup(SG);

  f := GroupHomomorphismByImagesNC(SG1, GL(1, Integers),
    List(gs, x -> Image(fSG, x)),
    List(gs, x -> [[DeterminantMat(x)]]));
  ww := {g1, g2} -> 0;

  SS := DisorderFermionSPTSpecSeq(R, f, ww);
  # FermionSPTLayersVerbose(SS, 2);
  layers := FermionSPTLayers(SS, 2);
  Display("Layers:");
  Display(layers);

  M := SptSetSpecSeqResult(SS, 3, [1,2,3]);
  SptSetFpZModuleCanonicalForm(M);
  Display(M);
  
od;
