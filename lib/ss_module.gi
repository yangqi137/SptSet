DeclareRepresentation(
  "IsSptSetSpecSeqModuleRep",
  IsSptSetFpZModuleRep,
  ["specSeq", "pRange", "deg", "basis_classes", "res_projections"]
);

BindGlobal(
  "TheFamilyOfSptSetSpecSeqModules",
  NewFamily("TheFamilyOfSptSetSpecSeqModules")
);

BindGlobal(
            "TheTypeSptSetSpecSeqModule",
            NewType(TheFamilyOfSptSetSpecSeqModules, IsSptSetSpecSeqModuleRep)
    );

InstallGlobalFunction
    (SptSetSpecSeqComponentEx,
    function(ss, p, q)
        local Epq, compEx, n, np, clnp;
        Epq := SptSetSpecSeqComponentInf(ss, p, q);
        SptSetFpZModuleCanonicalForm(Epq);
        compEx := rec();
        compEx.specSeq := ss;
        compEx.deg := p + q;
        compEx.pRange := [p];
        compEx.basis_classes := [];
        compEx.res_projections := [];
        compEx.res_projections[p] := Epq!.projection;
        n := SptSetNumberOfGenerators(Epq);
        for np in Epq!.generators do
            clnp := SptSetSpecSeqClassFromLevelCocycle(ss, compEx.deg, p, np);
            Add(compEx.basis_classes, clnp);
        od;
        compEx.generators := IdentityMat(n);
        compEx.projection := IdentityMat(n);
        compEx.relations := Epq!.relations;
        return Objectify(TheTypeSptSetSpecSeqModule, compEx);
        
    end);

InstallGlobalFunction
    (SptSetSpecSeqModuleVectorToClass,
    function(M, a)
        local n, ss, deg, i, j, cl, nci;
        n := SptSetEmbedDimension(M);
        ss := M!.specSeq;
        deg := M!.deg;
        Assert(0, n = Length(a));
        
        cl := SptSetSpecSeqClassFromCochainNC(SptSetSpecSeqCochainZero(ss, deg));
        for i in [1..n] do
            if a[i] >= 0 then
                for j in [1..(a[i])] do
                    cl := cl + M!.basis_classes[i];
                od;
            else;
                nci := -M!.basis_classes[i];
                for j in [1..(-a[i])] do
                    cl := cl + nci;
                od;
            fi;
        od;
        return cl;
    end);

InstallGlobalFunction
    (SptSetSpecSeqModuleClassToLeadingVector,
    function(M, cl)
        local pRange, pf, p, ss, deg, v;
        pRange := M!.pRange;
        if Length(pRange) > 1 then
            Error("Not implemented");
        fi;
        pf := Last(pRange);
        ss := M!.specSeq;
        deg := M!.deg;
           
        SptSetPurifySpecSeqClass(cl);
        p := LeadingLayer(cl);
        if p >= pf then
            # Display(p);
            v := SptSetMapFromBarCocycle(ss!.brMap, pf, ss!.spectrum[deg - pf +1], cl!.cochain!.layers[pf + 1]);
            # Display(v);
            return v * M!.res_projections[pf];
        else
            return fail;
        fi;
    end);

InstallGlobalFunction(SptSetSpecSeqModuleExtension,
function(M1, M2)
    local deg, pf, n1, n2, n, r1, r2, r, Emat, Pmat, Rmat, i, j, tj, vjn, cjn, vjnf, Mext;

    Assert(0, M1!.deg = M2!.deg);
    Assert(0, Length(M2!.pRange) = 1);
    Assert(0, Last(M1!.pRange) + 1 = M2!.pRange[1]);

    deg := M1!.deg;
    pf := M2!.pRange[1];

    if SptSetFpZModuleIsZero(M2) then
        Emat := M1!.generators;
        Pmat := M1!.projection;
        Rmat := M1!.relations;
    elif SptSetFpZModuleIsZero(M1) then
        Emat := M2!.generators;
        Pmat := M2!.projection;
        Rmat := M2!.relations;
    else

        SptSetFpZModuleCanonicalForm(M1);

        n1 := SptSetEmbedDimension(M1);
        n2 := SptSetEmbedDimension(M2);
        n := n1 + n2;
        r1 := SptSetNumberOfGenerators(M1);
        r2 := SptSetNumberOfGenerators(M2);
        r := r1 + r2;
        Emat := NullMat(r, n);
        Pmat := NullMat(n, r);
        Rmat := NullMat(r, r);

        for j in [1..r1] do
            for i in [1..n1] do
                Emat[j, i] := M1!.generators[j, i];
                Pmat[i, j] := M1!.projection[i, j];
            od;
        od;

        for j in [1..r1] do
            tj := M1!.relations[j, j];
            vjn := tj * M1!.generators[j];
            Rmat[j, j] := tj;
            if tj <> 0 then # torsion-free generators have no extension.
                cjn := SptSetSpecSeqModuleVectorToClass(M1, vjn);
                vjnf := SptSetSpecSeqModuleClassToLeadingVector(M2, cjn);
                Rmat[j]{[(r1+1)..r]} := vjnf;
            fi;
        od;

        for j in [(r1+1)..r] do
            for i in [(n1+1)..n] do
                Emat[j, i] := M2!.generators[j-r1, i-n1];
                Pmat[i, j] := M2!.projection[i-n1, j-r1];
            od;
            for i in [(r1+1)..r] do
                Rmat[j, i] := M2!.relations[j-r1, i-r1];
            od;
        od;
    fi;    

    Mext := rec();
    Mext.specSeq := M1!.specSeq;
    Mext.deg := M1!.deg;
    Mext.pRange := Concatenation(M1!.pRange, M2!.pRange);
    Mext.basis_classes := Concatenation(M1!.basis_classes, M2!.basis_classes);
    Mext.res_projections := M1!.res_projections;
    Mext.res_projections[pf] := M2!.res_projections[pf];
    Mext.generators := Emat;
    Mext.projection := Pmat;
    Mext.relations := Rmat;

    return Objectify(TheTypeSptSetSpecSeqModule, Mext);

end);

InstallGlobalFunction(SptSetSpecSeqResult,
function(ss, deg, pRange)
    local p, Epq, M;
    for p in pRange do
        Epq := SptSetSpecSeqComponentEx(ss, p, deg - p);
        if p = pRange[1] then
            M := Epq;
        else
            M := SptSetSpecSeqModuleExtension(M, Epq);
        fi;
    od;

    return M;
end);