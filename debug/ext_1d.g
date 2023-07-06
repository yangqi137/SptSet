LoadPackage("SptSet");

R := ResolutionAbelianGroup([0, 2], 6);
G := GroupOfResolution(R);
gens := GeneratorsOfGroup(G);
m := gens[1];
tx := gens[2];

#f := SptSetTrivialGroupAction(G);
#f := GroupHomomorphismByImagesNC(G, GL(1, Integers), gens, [ [[+1]], [[+1]] ]);
f := GroupHomomorphismByFunction(G, GL(1, Integers), {x} -> [[+1]]);

SS := FermionEZSPTSpecSeq(R, f);

layers := FermionSPTLayers(SS, 1);
Display("Layers:");
Display(layers);

  E11inf := SptSetSpecSeqComponentInf(SS, 1, 1);
  SptSetFpZModuleCanonicalForm(E11inf);  
  E20inf := SptSetSpecSeqComponentInf(SS, 2, 0);
  SptSetFpZModuleCanonicalForm(E20inf);

n := SptSetNumberOfGenerators(layers[2]);
  
  for i in [1..n] do
    Display(["Complex generator #", i]);
    v1 := layers[2]!.generators[i];
    cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 2, 1, v1);
    #SptSetPurifySpecSeqClass(cl1);
    cl2 := cl1 + cl1;
    SptSetPurifySpecSeqClass(cl2);
    Display(LeadingLayer(cl2));
    a_ := cl2!.cochain!.layers[2+1];
    a := SptSetMapFromBarCocycle(SS!.brMap, 2, SS!.spectrum[0+1], a_);        
    Display(SptSetFpZModuleCanonicalElm(E20inf, a));
  od;