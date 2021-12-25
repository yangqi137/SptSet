LoadPackage("SptSet");

SetAssertionLevel(1);
for it in [2..17] do
  Display(it);
  SG := SpaceGroupBBNWZ(2, it);
  fSG := IsomorphismPcpGroup(SG);
  SG1 := Image(fSG);
  R := ResolutionAlmostCrystalGroup(SG1, 6);
  gs := GeneratorsOfGroup(SG);
  w := Spin12Factor(2, it);
  ww := {g1, g2} -> w(PreImageElm(fSG, g1), PreImageElm(fSG, g2));

  f := GroupHomomorphismByImagesNC(SG1, GL(1, Integers),
    List(gs, x -> Image(fSG, x)),
    List(gs, x -> [[DeterminantMat(x)]]));

  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "HAP");
  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "debug");
  SS := FermionSPTSpecSeq(R, f, ww);
  FermionSPTLayersVerbose(SS, 2);
od;
