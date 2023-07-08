LoadPackage("SptSet");

SetAssertionLevel(1);
it := 15;
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

  layers := FermionSPTLayers(SS, 2);
  Display("Layers:");
  Display(layers);

  E21inf := SptSetSpecSeqComponentInf(SS, 2, 1);
  SptSetFpZModuleCanonicalForm(E21inf);  
  E30inf := SptSetSpecSeqComponentInf(SS, 3, 0);
  SptSetFpZModuleCanonicalForm(E30inf);

  n := SptSetNumberOfGenerators(layers[1]);
  # for i in [1..n] do
  i := 1;
    Display(["Majorana generator #", i]);
    v1 := layers[1]!.generators[i];
    cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 1, v1);
    #SptSetPurifySpecSeqClass(cl1);
    cl2 := cl1 + cl1;
    SptSetPurifySpecSeqClass(cl2);
    Display(LeadingLayer(cl2));
      a_ := cl2!.cochain!.layers[3+1];
      a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
      Display(a);
      Display(SptSetFpZModuleCanonicalElm(E30inf, a));
  #od;

#od;

bl2 := ShortBasisListFromResolution@SptSet(SS!.brMap, 2);
bl3 := ShortBasisListFromResolution@SptSet(SS!.brMap, 3);
bl4 := ShortBasisListFromResolution@SptSet(SS!.brMap, 4);

n1_ := cl1!.cochain!.layers[1+1];
n2_ := cl1!.cochain!.layers[2+1];
nu3_ := cl1!.cochain!.layers[3+1];

CheckCochainEqOverBasisListZ2@SptSet(InhomoCoboundary@SptSet(SS!.spectrum[2+1], n2_), SS!.bdry[2+1][1+1][2+1](n1_, ZeroCocycle@SptSet), bl3);

dnu3_ := InhomoCoboundary@SptSet(SS!.spectrum[0+1], nu3_);
dn2_ := InhomoCoboundary@SptSet(SS!.spectrum[1+1], n2_);
O4_ := SS!.bdry[2+1][2+1][1+1](n2_, dn2_);
CheckCochainEqOverBasisListU1@SptSet(O4_, dnu3_, bl4);