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
        for ig in [1..ng] do
            vi := M!.generators[i];
        od;
    od;
end);