LoadPackage("SptSet");

omega0 := {g1, g2} -> 0;

G := CyclicGroup(2);
g := GeneratorsOfGroup(G)[1];
R := ResolutionFiniteGroup(G, 6);

omega2 := function(g1, g2)
    if g1 = g and g2 = g then
        return 1/2;
    else
        return 0;
    fi;
end;

f := GroupHomomorphismByImagesNC(G, GL(1, Integers), [g], [ [[+1]] ]);

SS := InsulatorSPTSpecSeq(R, f, f, omega2);
InsulatorSPTLayersVerbose(SS, 2);
layers := FermionSPTLayers(SS, 2);
Display("Layers:");
Display(layers);

n := SptSetNumberOfGenerators(layers[2]);

E30inf := SptSetSpecSeqComponent2Inf(SS, 3, 0);
SptSetFpZModuleCanonicalForm(E30inf);

for i in [1..n] do
    if layers[2]!.relations[i, i] = 2 then
        Display(["generator: ", i]);

        v1 := layers[2]!.generators[i];
        cl1 := SptSetSpecSeqClassFromLevelCocycle(SS, 3, 2, v1);
        #SptSetPurifySpecSeqClass(cl1);
        Display(["v3=", cl1!.cochain!.layers[4](g, g, g)]);;
        cl2 := cl1 + cl1;
        Display(["Before purification, V3=", cl2!.cochain!.layers[4](g, g, g)]);;
        Display(["N2=", cl2!.cochain!.layers[3](g, g)]);
        SptSetPurifySpecSeqClass(cl2);
        Display(["After purification, V3=", cl2!.cochain!.layers[4](g, g, g)]);;
        Display(["N2=", cl2!.cochain!.layers[3](g, g)]);
        a_ := cl2!.cochain!.layers[4];
        Display(a_(g, g, g));
        a := SptSetMapFromBarCocycle(SS!.brMap, 3, SS!.spectrum[0+1], a_);
        Display(SptSetFpZModuleCanonicalElm(E30inf, a));
        #Display(a * E30inf!.projection);
        #Display(E30inf!.relations);
    fi;
od;
