LoadPackage("SptSet");

omega0 := {g1, g2} -> 0;

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

  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "HAP");
  #SS := FermionEZSPTSpecSeq(R, f: BarResMapChoice := "debug");
  SS := InsulatorSPTSpecSeq(R, f, f, omega0);
  InsulatorSPTLayersVerbose(SS, 2);

  layers := FermionSPTLayers(SS, 2);
  Display("Layers:");
  Display(layers);

  n := SptSetNumberOfGenerators(layers[2]);

  E30inf := SptSetSpecSeqComponent2Inf(SS, 3, 0);
  SptSetFpZModuleCanonicalForm(E30inf);

  for i in [1..n] do
      if layers[2]!.relations[i, i] = 2 then
          Display(i);
        
          v1 := layers[2]!.generators[i];
          cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
          SptSetPurifySpecSeqClass(cl1);
          cl2 := cl1 + cl1;
          SptSetPurifySpecSeqClass(cl2);
          a_ := cl2!.cochain!.layers[4];
          a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
          Display(SptSetFpZModuleCanonicalElm(E30inf, a));
      fi;
  od;
od;
