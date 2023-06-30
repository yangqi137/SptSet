LoadPackage("SptSet");

for it in [4..17] do
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
  SS := FermionEZSPTSpecSeq(R, f);
  layers := FermionSPTLayers(SS, 2);
  Display("Layers:");
  Display(layers);

  E21inf := SptSetSpecSeqComponentInf(SS, 2, 1);
  SptSetFpZModuleCanonicalForm(E21inf);  
  E30inf := SptSetSpecSeqComponentInf(SS, 3, 0);
  SptSetFpZModuleCanonicalForm(E30inf);

  n := SptSetNumberOfGenerators(layers[1]);
  for i in [1..n] do
    Display(["Majorana generator #", i]);
    v1 := layers[1]!.generators[i];
    cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 1, v1);
    SptSetPurifySpecSeqClass(cl1);
    cl2 := cl1 + cl1;
    SptSetPurifySpecSeqClass(cl2);
    Display(LeadingLayer(cl2));
    if LeadingLayer(cl2) = 2 then
      a_ := cl2!.cochain!.layers[2+1];
      a := SptSetMapFromBarCocycle(SS!.brMap, 2, SS!.spectrum[1+1], a_);
      Display(SptSetFpZModuleCanonicalElm(E21inf, a));

      cl4 := cl2 + cl2;
      SptSetPurifySpecSeqClass(cl4);
      Display(LeadingLayer(cl4));

      a_ := cl4!.cochain!.layers[3+1];
      a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
      Display(SptSetFpZModuleCanonicalElm(E30inf, a));
    else
      a_ := cl2!.cochain!.layers[3+1];
      a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);        
      Display(SptSetFpZModuleCanonicalElm(E30inf, a));
    fi;
  od;

  n := SptSetNumberOfGenerators(layers[2]);
  for i in [1..n] do
    Display(["Complex generator #", i]);
    v1 := layers[2]!.generators[i];
    cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
    SptSetPurifySpecSeqClass(cl1);
    cl2 := cl1 + cl1;
    SptSetPurifySpecSeqClass(cl2);
    Display(LeadingLayer(cl2));
    a_ := cl2!.cochain!.layers[3+1];
    a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);        
    Display(SptSetFpZModuleCanonicalElm(E30inf, a));
  od;

  
od;
