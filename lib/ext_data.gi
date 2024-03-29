InstallGlobalFunction(DecodeFraction@,
function(str)
    return (Position(["0.125", "0.25", "0.375", "0.5", "0.625", "0.75", "0.875"], str)/8);
end);

InstallGlobalFunction(LoadExtDataFile@,
function(nParams, fileName)
    local fin, line, r, i, idx, result;
    # Display(DirectoriesPackageLibrary("SptSet", "lib/data"));
    # return 0;
    fin := InputTextFile(Filename(DirectoriesPackageLibrary("SptSet", "lib/data"), fileName));
    if fin = fail then
        Display("File does not exist!");
        return fail;
    fi;
    result := [];
    while true do
        line := ReadLine(fin);
        if line = fail then break; fi;
        r := SplitString(line, "", " \r\n");
        # Display(r);
        idx := 0;
        for i in [1..nParams] do
            idx := idx * 2 + Int(r[i]);
        od;
        # Display(idx);
        result[idx] := DecodeFraction@(r[nParams + 1]);
    od;
    return result;
end);

InstallValue(AddTwister2DTable@, LoadExtDataFile@(9, "AddTwister2D.dat"));

InstallGlobalFunction(ExtData@,
function(datavar, params...)
    local idx, p;
    idx := 0;
    for p in params do
        idx := 2 * idx + (p mod 2);
    od;
    if idx = 0 then return 0; fi;
    #return datavar[idx];
    if IsBound(datavar[idx]) then
        return datavar[idx];
    else
        return 0;
    fi;
end);