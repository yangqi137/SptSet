InstallGlobalFunction
    (SptSetSpecSeqExtensionModule, function(SS, deg, pi, pf)
        local Epqinf;
        modules := [];
        for p in [pi..pf] do
            modules[p-pi+1] := SptSetSpecSeqComponentInf(SS, p, deg-p);
        od;
        nmlist := List(modules, {m} -> SptSetNumberOfGenerators(m));
        n := Sum(nmlist);
        Emat := IdentityMat(n);
        Pmat := IdentityMat(n);
        Rmat := IdentityMat(n);

        for i in [1..(Length(modules)-1)] do
            M := modules[i];
            p := pi + i - 1;
            ntot := Sum(nmlist{[1..(i-1)]});
            for j in [1..nmlist[i]] do
                vj := M!.generators[j];
                cj := SptSetSpecSeqClassFromLevelCocycle(SS, deg, p, vj);
                tj := M!.relations[i, i];
                if tj <> 0 then
                    cjn := cj + cj;
                    for l in [1..(tj-1)] do
                        cjn := cjn + cj;
                    od;
                    SptSetPurifySpecSeqClass(cjn);
                    Assert(0, LeadingLayer(cjn) > p);
                    vjn := SptSetMapFromBarCocycle(SS!.brMap, SS!.spectrum[deg-p +1], cjn!.cochain!.layers[p+1+1]);
                    Rmat[ntot + j]{[(ntot+nmlist[i])..(ntot+nmlist[i+1]-1)]} := vjn;
                    
                fi;
            od;
        od;
        
    end);

                         
                         
                         
