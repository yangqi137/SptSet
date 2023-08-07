DeclareRepresentation(
    "IsSptSetFpZExtModuleRep",
    IsSptSetFpZModuleRep,
    ["submodules", "projections"]
);

InstallGlobalFunction(SptSetFpZModuleExtension,
function(modules, ext_data)
    local nm;

    msizes := List(modules, {x} -> (SptSetNumberOfGenerators(x)));
    n := Sum(msizes);

    E := [];
    P := [];
    R := [];
    
    nm := Length(modules);
    # ext_id := 0;
    for im in [1..(nm-1)] do
        M := modules[im];
        ng := msizes[im];
        for j in [1..ng] do
            vj := M!.generators[j];
            tj := M!.relations[j][j];
            vj_ext := List([1..n], {x}->0);
            ext_id := Sum(msizes{[1..(im-1)]}) + j;
            vj_ext[ext_id] := 1;
            if tj <> 0 then # torsion-free case has no extension.
                ext_j := ext_data[i][j];
                vj_ext{[Sum(msizes{[1..im]})..n]} := ext_j / tj;
            fi;
            E[ext_id] := vj_ext;
            R[ext_id][ext_id] := tj;
        od;
    od;
end);
