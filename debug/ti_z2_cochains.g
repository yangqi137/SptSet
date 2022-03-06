LoadPackage("SptSet");

omega0 := {g1, g2} -> 0;

G := CyclicGroup(2);
g := GeneratorsOfGroup(G)[1];
R := ResolutionFiniteGroup(G, 6);

f := GroupHomomorphismByImagesNC(G, GL(1, Integers), [g], [ [[+1]] ]);

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
        #Display(a * E30inf!.projection);
        #Display(E30inf!.relations);
    fi;
od;
