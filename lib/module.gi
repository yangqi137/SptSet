DeclareRepresentation(
  "IsSptSetFpZModuleRep",
  IsCategoryOfSptSetFpZModule and IsComponentObjectRep,
  ["generators", "projection", "relations"]
);

BindGlobal(
  "TheFamilyOfSptSetFpZModules",
  NewFamily("TheFamilyOfSptSetFpZModules")
);

BindGlobal(
  "TheTypeSptSetFpZModule",
  NewType(TheFamilyOfSptSetFpZModules, IsSptSetFpZModuleRep)
);

InstallMethod(SptSetFpZModuleEPR,
  "Creates a FpZ Module with generators, projection and relations",
  [IsMatrix, IsMatrix, IsMatrix],
  function(E, P, R)
    local mrec, n, r;
    r := DimensionsMat(E)[1];
    if r > 0 and E * P <> IdentityMat(r) then
      return fail;
    fi;
    if r > 0 and R <> [[ ]] and r <> DimensionsMat(R)[2] then
      return fail;
    fi;
    mrec := rec(generators := E, projection := P, relations := R);
    return Objectify(TheTypeSptSetFpZModule, mrec);
  end);

InstallMethod(SptSetCopyFpZModule,
  "Make a deep copy of a FpZ module",
  [IsSptSetFpZModuleRep],
  function(m)
    if SptSetFpZModuleIsZero(m) then
      return SptSetZeroModule();
    else
      return SptSetFpZModuleEPR(
        StructuralCopy(m!.generators),
        StructuralCopy(m!.projection),
        StructuralCopy(m!.relations));
    fi;
  end);

InstallMethod(SptSetFreeFpZModule,
  "Creates free Z module of rank n",
  [IsInt],
  function(n)
    return SptSetFpZModuleEPR(IdentityMat(n), IdentityMat(n), [[ ]]);
  end);

InstallMethod(SptSetFpZModuleFromTorsions,
  "Creates Z module with torsions",
  [IsRowVector],
  function(torsions)
    local n;
    n := Length(torsions);
    return SptSetFpZModuleEPR(
      IdentityMat(n),
      IdentityMat(n),
      DiagonalMat(torsions));
  end);

InstallMethod(SptSetNumberOfGenerators,
  "Return the number of generators in a module presentation",
  [IsSptSetFpZModuleRep],
  function(M)
    #return DimensionsMat(M!.generators)[1];
    return Length(M!.generators);
  end);

InstallMethod(SptSetEmbedDimension,
  "the dimension of the embeded space",
  [IsSptSetFpZModuleRep],
  function(M)
    return DimensionsMat(M!.generators)[2];
  end);

InstallMethod(SptSetFpZModuleCanonicalForm,
  "Transform a module to its canonical form",
  [IsSptSetFpZModuleRep],
  function(M)
    local snf, V, D, n, i, diag, indices;
    if SptSetFpZModuleIsZero(M) then return; fi;
    snf := SmithNormalFormIntegerMatTransforms(M!.relations);
    V := snf!.coltrans;
    D := snf!.normal;
    M!.generators := Inverse(V) * M!.generators;
    M!.projection := M!.projection * V;
    #M!.relations := D;

    # Now, we pad D to make it square.
    #s := DimensionsMat(R)[1];
    #r := DimensionsMat(R)[2];
    #if s < r then
    #  # add more rows to the bottom.
    #  Append(D, NullMat(r-s, r));
    #fi;
    #if s > r then
    #  #remove some rows from the bottom.
    #  D := D{[1..r]};
    #fi;
    diag := DiagonalOfMat(D);
    indices := PositionsProperty(diag, x -> x<>1);
    diag := diag{indices};
    M!.generators := M!.generators{indices};
    n := DimensionsMat(M!.projection)[1];
    for i in [1..n] do
      M!.projection[i] := M!.projection[i]{indices};
    od;
    if diag = [] then
      M!.relations := [];
    else
      M!.relations := DiagonalMat(diag);
    fi;
  end);

InstallGlobalFunction(SptSetZeroModule,
  function()
    return SptSetFpZModuleEPR(EmptyMatrix(0), EmptyMatrix(0), EmptyMatrix(0));
  end);

InstallGlobalFunction(SptSetFpZModuleIsZero,
  function(M)
    local E;
    E := M!.generators;
    return E = [] or DimensionsMat(E)[1] = 0;
  end);

InstallGlobalFunction(SptSetFpZModuleIsCanonical,
  function(M)
    local R, dimR;
    R := M!.relations;
    if R = [] then return true; fi;
    dimR := DimensionsMat(R);
    return (dimR[1] = dimR[2]) and IsDiagonalMat(R);
  end);

InstallMethod(String,
  "view string of a module",
  [IsSptSetFpZModuleRep],
  function(M)
    if SptSetFpZModuleIsZero(M) then
      return "<ZL-Module []>";
    fi;
    if SptSetFpZModuleIsCanonical(M) then
      return StringFormatted("<ZL-Module with torsions {}>", DiagonalOfMat(M!.relations));
    else
      return "<ZL-Module>";
    fi;
  end);

InstallGlobalFunction(SptSetFpZModuleIsZeroElm,
function(M, v)
  local P, R, n, vp, i;
  if SptSetFpZModuleIsZero(M) then
    return true;
  fi;
  if not SptSetFpZModuleIsCanonical(M) then
    SptSetFpZModuleCanonicalForm(M);
  fi;
  P := M!.projection;
  R := M!.relations;
  vp := v * P;
  n := Length(vp);
  for i in [1..n] do
    if (R[i][i] <> 0) and (vp[i] mod R[i][i] <> 0) then
      return false;
    fi;
  od;
  return true;
end);

InstallGlobalFunction(SptSetFpZModuleCanonicalElm,
function(M, v)
    local P, R, N, vp, i, n;
  if SptSetFpZModuleIsZero(M) then
    return [];
  fi;
  if not SptSetFpZModuleIsCanonical(M) then
    SptSetFpZModuleCanonicalForm(M);
  fi;
  P := M!.projection;
  R := M!.relations;
  vp := v * P;
  n := Length(vp);
  for i in [1..n] do
    if (R[i][i] <> 0) then
        vp[i] := vp[i] mod R[i][i];
    fi;
  od;
  return vp;
end);
    
