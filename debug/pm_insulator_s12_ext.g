LoadPackage("SptSet");

it := 3;

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

  SS := InsulatorSPTSpecSeq(R, f, f, ww);
  InsulatorSPTLayersVerbose(SS, 2);

  layers := FermionSPTLayers(SS, 2);
  Display("Layers:");
  Display(layers);

  n := SptSetNumberOfGenerators(layers[2]);

  E30inf := SptSetSpecSeqComponentInf(SS, 3, 0);
  SptSetFpZModuleCanonicalForm(E30inf);

  # for i in [1..n] do
  i := 1;
      tor := layers[2]!.relations[i, i];
      if tor <> 0 then
          Display(["Complex generator #", i]);
          Display(["tor", tor]);

          v1 := layers[2]!.generators[i];
          cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
          #SptSetPurifySpecSeqClass(cl1);
          cl2 := cl1 + cl1;
          for j in [3..tor] do
              cl2 := cl2 + cl1;
          od;
          SptSetPurifySpecSeqClass(cl2);
          a_ := cl2!.cochain!.layers[4];
          a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
          Display(SptSetFpZModuleCanonicalElm(E30inf, a));
      fi;
  #od;
#od;


n2_ := cl1!.cochain!.layers[2+1];
m := Image(fSG, gs[1]);
tx := Image(fSG, gs[2]);
ty := Image(fSG, gs[3]);
Display(n2_(m, m));
Display(n2_(m, tx));
Display(n2_(tx, m));
Display(n2_(m, ty));
Display(n2_(ty, m));
Display(n2_(tx, ty));
Display(n2_(ty, tx));

Display("a_");
Display([a_(m, tx, ty), a_(m, ty, tx), a_(tx, m, ty), a_(tx, ty, m), a_(ty, m, tx), a_(ty, tx, m)]);