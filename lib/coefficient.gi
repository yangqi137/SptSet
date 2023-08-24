DeclareRepresentation(
  "IsSptSetCoeffZnRep",
  IsCategoryOfSptSetCoefficient and IsComponentObjectRep,
  ["torsion", "gAction"]
);

DeclareRepresentation(
  "IsSptSetCoeffU1Rep",
  IsCategoryOfSptSetCoefficient and IsComponentObjectRep,
  ["gAction"]
    );

DeclareRepresentation("IsSptSetCoeffCM",
                      IsCategoryOfSptSetCoefficient and IsComponentObjectRep,
                      ["module", "group", "degree", "coeff", "brMap", "gAction"]
                     );

BindGlobal(
  "TheFamilyOfSptSetCoefficients",
  NewFamily("TheFamilyOfSptSetCoefficients")
);

BindGlobal(
  "TheTypeSptSetCoeffZn",
  NewType(TheFamilyOfSptSetCoefficients, IsSptSetCoeffZnRep)
);

BindGlobal(
  "TheTypeSptSetCoeffU1",
  NewType(TheFamilyOfSptSetCoefficients, IsSptSetCoeffU1Rep)
    );

BindGlobal("TheTypeSptSetCoeffCM",
           NewType(TheFamilyOfSptSetCoefficients, IsSptSetCoeffCM)
          );

InstallGlobalFunction(SptSetCoefficientZn,
  function(n, gAction)
    return Objectify(TheTypeSptSetCoeffZn,
      rec(torsion := n, gAction := gAction));
  end);

InstallGlobalFunction(SptSetCoefficientU1,
  function(gAction)
    return Objectify(TheTypeSptSetCoeffU1,
      rec(gAction := gAction));
  end);

InstallGlobalFunction
    (SptSetCoefficientCohomologyModule,
    function(cplx, deg, G)
        local rCoeff, module, N, gens, coeff, brMap, fgens, g, n, i, a, a_, ga_, ga, fg, gAction;
        module := SptSetCohomology(cplx, deg);
        N := GroupOfResolution(cplx!.hapResolution);
        coeff := cplx!.coeff;
        # brMap := cplx!.barResMap;
        brMap := SptSetBarResolutionMap(cplx!.hapResolution);
        
        gens := GeneratorsOfGroup(G);
        fgens := [];

        n := SptSetNumberOfGenerators(module);

        for g in gens do
            fg := [];
            for i in [1..n] do
                a := module!.generators[i];
                # a_ := SptSetMapToBarCocycle(brMap, deg+1, coeff!.gAction, a);
                a_ := SptSetMapToBarCocycle(brMap, deg, coeff, a);
                ga_ := function(hlist...)
                    return CallFuncList(a_, List(hlist, {x}->x^g));
                end;
                # ga := SptSetMapFromBarCocycle(brMap, deg+1, coeff!.gAction, ga_);
                ga := SptSetMapFromBarCocycle(brMap, deg, coeff, ga_);
                fg[i] := SptSetFpZModuleCanonicalElm(module, ga);
            od;
            Add(fgens, fg);
        od;

        gAction := GroupHomomorphismByImagesNC(G, GL(n, Integers), gens, fgens);
        
        rCoeff := rec(module := module,
                      group := N,
                      degree := deg,
                      coeff := coeff,
                      brMap := brMap,
                      gAction := gAction);
        return Objectify(TheTypeSptSetCoeffCM, rCoeff);
        
    end);
