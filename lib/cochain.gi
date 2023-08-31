#DeclareRepresentation(
#  "IsSptSetCochainModuleRep",
#  IsSptSetFpZModuleRep and IsCategoryOfSptSetCochainModule and IsComponentObjectRep,
#  ["hapResolution", "degree"]
#);

#BindGlobal(
#  "TheFamilyOfSptSetCochainModules",
#  NewFamily("TheFamilyOfSptSetCochainModules")
#);

#BindGlobal(
#  "TheTypeSptSetCochainModule",
#  NewType(TheFamilyOfSptSetCochainModules, IsSptSetCochainModuleRep)
#);

InstallMethod(SptSetCochainModule,
  "Constructs a list of cochain modules with Zn coefficientsat all levels from a resolution",
  [IsHapResolution, IsInt, IsInt],
  function(resolution, k, n)
  local dk;
  dk := Dimension(resolution)(k);
  return SptSetFpZModuleFromTorsions(List([1..dk], x -> n));
  end);

InstallMethod(SptSetCochainModule,
  "Constructs a list of cochain modules with Zn coefficients at all levels from a resolution",
  [IsHapResolution, IsInt, IsSptSetCoeffZnRep],
  function(resolution, deg, coeff)
      return SptSetCochainModule(resolution, deg, coeff!.torsion);
  end);
InstallMethod(SptSetCochainModule,
  "Constructs a list of cochain modules with U(1) coefficients at all levels from a resolution",
  [IsHapResolution, IsInt, IsSptSetCoeffU1Rep],
  function(resolution, deg, coeff)
      return SptSetCochainModule(resolution, deg + 1, 0);
  end);

InstallMethod(SptSetCochainModule,
  "Construct a cochain module with coefficients in another cohomology group",
  [IsHapResolution, IsInt, IsSptSetCoeffCM],
  function(resolution, deg, coeff)
    local torsions, n, i, torCoeff;
    torsions := [];
    n := Dimension(resolution)(deg);
    torCoeff := DiagonalOfMatrix(coeff!.module!.relations);
    for i in [1..n] do
      torsions[i] := torCoeff;
    od;
    return SptSetFpZModuleFromTorsions(Flat(torsions));
  end);

InstallMethod(SptSetCoboundaryMap,
  "Construct the coboundary map between two cochain modules",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep,
   IsHapResolution, IsInt, IsGeneralMapping],
  function(Ck, Ckp1, Res, k, f)
    local bdry, G, elts,
      cobdryMat, A, nk, nkp1, i, x, wx, gwx, swx, j;
    bdry := BoundaryMap(Res);
    G := GroupOfResolution(Res);
    elts := Res!.elts;
    nk := SptSetEmbedDimension(Ck);
    nkp1 := SptSetEmbedDimension(Ckp1);
    cobdryMat := NullMat(nk, nkp1);
    for j in [1..nkp1] do
      x := bdry(k+1, j);
      for wx in x do
        swx := SignInt(wx[1]);
        i := AbsInt(wx[1]);
        gwx := elts[wx[2]];
        cobdryMat[i][j] := cobdryMat[i][j] + swx * ((gwx^f)[1][1]);
        #Display(["cobdryMat: ", i, j, swx * ((gwx^f)[1][1])]);
      od;
    od;

    A := Ck!.generators * cobdryMat * Ckp1!.projection;
    #Display(["A: ", A]);
    return SptSetZLMapByImages(Ck, Ckp1, A);
  end);

InstallMethod(SptSetCoboundaryMap,
  "Construct the coboundary map between two cochain modules",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep,
   IsHapResolution, IsInt, IsSptSetCoeffZnRep],
  function(M, N, Res, deg, coeff)
    return SptSetCoboundaryMap(M, N, Res, deg, coeff!.gAction);
  end);

InstallMethod(SptSetCoboundaryMap,
  "Construct the coboundary map between two cochain modules",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep,
   IsHapResolution, IsInt, IsSptSetCoeffU1Rep],
  function(M, N, Res, deg, coeff)
    return SptSetCoboundaryMap(M, N, Res, deg+1, coeff!.gAction);
  end);

InstallMethod(SptSetCoboundaryMap,
  "Construct the coboundary map between two cochain modules",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep,
   IsHapResolution, IsInt, IsSptSetCoeffCM],
  function(M, N, Res, deg, coeff)
    local bdry, G, elts, f,
          cobdryMat, A, nM, nN, nk, nkp1, ncoeff,
          i, x, wx, gwx, gwxf, swx, j, gfMat, ii, jj;
    bdry := BoundaryMap(Res);
    G := GroupOfResolution(Res);
    elts := Res!.elts;
    f := coeff!.gAction;
    nM := SptSetEmbedDimension(M);
    nN := SptSetEmbedDimension(N);
    nk := Dimension(Res)(deg);
    nkp1 := Dimension(Res)(deg + 1);
    nCoeff := SptSetNumberOfGenerators(coeff!.module);
    cobdryMat := NullMat(nM, nN);
    for j in [1..nkp1] do
      x := bdry(deg + 1, j);
      for wx in x do
        swx := SignInt(wx[1]);
        i := AbsInt(wx[1]);
        gwx := elts[wx[2]];
        gwxf := gwx ^ f;
        for ii in [1..nCoeff] do
            for jj in [1..nCoeff] do
                cobdryMat[(i-1)*nCoeff + ii][(j-1)*nCoeff+jj] := cobdryMat[(i-1)*nCoeff + ii][(j-1)*nCoeff+jj] + swx * gwxf[ii][jj];
            od;
        od;
      od;
    od;

    A := M!.generators * cobdryMat * N!.projection;
    Display(["A: ", A]);
    return SptSetZLMapByImages(M, N, A);
  end);


InstallMethod(SptSetTrivialGroupAction,
  "helper function constructing a trivial action",
  [IsGroup],
  function(G)
    local gens, ids;
    gens := GeneratorsOfGroup(G);
    ids := List(gens, x -> [[1]]);
    return GroupHomomorphismByImagesNC(G, GL(1, Integers), gens, ids);
  end);
