DeclareRepresentation(
    "IsSptSetFpZExtModuleRep",
    IsSptSetFpZModuleRep,
    ["submodules", "projections"]
);

InstallGlobalFunction(SptSetFpZModuleExtension,
function(modules, ext_data)
    local nm;

    n := Sum(List(modules, {x} -> {SptSetNumberOfGenerators(x)}));
    
    nm := Length(modules);
    for im in [1..(nm-1)] do
        M := modules[im];
        ng := SptSetNumberOfGenerators(M);
        for j in [1..ng] do
            vj := M!.generators[j];
            tj := M!.relations[j][j];
            vvj := 
            if tj <> 0 then
                ext_j := ext_data[i][j];
            else
            fi;
            
        od;
    od;
end);
