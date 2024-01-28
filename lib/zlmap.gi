DeclareRepresentation(
  "IsSptSetZLMapRep",
  IsCategoryOfSptSetZLMap and
  IsComponentObjectRep and IsAttributeStoringRep,
  ["domain", "codomain", "B"]
);

DeclareRepresentation(
  "IsSptSetZLMapZeroRep",
  IsCategoryOfSptSetZLMap and
  IsComponentObjectRep and IsAttributeStoringRep,
  ["domain", "codomain"]
);

BindGlobal(
  "TheFamilyOfSptSetZLMaps",
  NewFamily("TheFamilyOfSptSetZLMaps")
);

BindGlobal(
  "TheTypeSptSetZLMap",
  NewType(TheFamilyOfSptSetZLMaps, IsSptSetZLMapRep)
);
BindGlobal(
  "TheTypeSptSetZLMapZero",
  NewType(TheFamilyOfSptSetZLMaps, IsSptSetZLMapZeroRep)
);

InstallMethod(SptSetZLMapByImages,
  "Construct a Z-linear map using a matrix",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep, IsMatrix],
  function(M, N, A)
    local r, r2, dimA, B, frec;
    r := SptSetNumberOfGenerators(M);
    r2 := SptSetNumberOfGenerators(N);
    dimA := DimensionsMat(A);
    if dimA[1] <> r or dimA[2] <> r2 then
      return fail;
    fi;
    B := M!.projection * A * N!.generators;
    frec := rec(domain := M, codomain := N, B := B);
    return Objectify(TheTypeSptSetZLMap, frec);
  end);

InstallMethod(SptSetZeroMap,
  "Construct a zero map",
  [IsSptSetFpZModuleRep, IsSptSetFpZModuleRep],
  function(M, N)
    return Objectify(TheTypeSptSetZLMapZero, rec(domain:=M, codomain:=N));
  end);

InstallMethod(SptSetZLMapInverseMat,
  "computes the inverse matrix in the raw basis of a ZL-map",
  [IsSptSetZLMapRep],
  function(psi)
    local M, N, A, R2, diagR2, idsR2,
      tA, snf, tU, tV, tD, tE, Ainv, m, n, i;
    M := psi!.domain;
    N := psi!.codomain;
    if not SptSetFpZModuleIsCanonical(N) then
      SptSetFpZModuleCanonicalForm(N);
    fi;
    A := M!.generators * psi!.B * N!.projection;
    R2 := StructuralCopy(psi!.codomain!.relations);

    # remove null rows in R2.
    diagR2 := DiagonalOfMat(R2);
    idsR2 := PositionsProperty(diagR2, x -> x<>0);
    R2 := R2{idsR2};
    tA := StructuralCopy(A);
    Append(tA, R2);
    snf := SmithNormalFormIntegerMatTransforms(tA);
    tU := snf.rowtrans;
    tD := snf.normal;
    tV := snf.coltrans;
    tE := SptSetPseudoInverseSpecialMat(tD);

    Ainv := tV * tE * tU;
    m := DimensionsMat(Ainv)[1];
    n := DimensionsMat(M!.generators)[1];
    for i in [1..m] do
      Ainv[i] := Ainv[i]{[1..n]};
    od;
    return N!.projection * Ainv * M!.generators;
  end);
InstallMethod(SptSetZLMapInverse,
  "computes the preimage of a linear map",
  [IsSptSetZLMapRep, IsRowVector],
  function(psi, v)
    return v * SptSetZLMapInverseMat(psi);
  end);

InstallGlobalFunction(SptSetPseudoInverseSpecialMat,
  function(A)
    local Ainv, m, n, i, j;
    Ainv := StructuralCopy(A);
    if A = [] then
      return Ainv;
    fi;
    m := DimensionsMat(A)[1];
    n := DimensionsMat(A)[2];
    for i in [1..m] do
      for j in [1..n] do
        if Ainv[i][j] <> 0 then
          Ainv[i][j] := 1 / Ainv[i][j];
        fi;
      od;
    od;
    Ainv := TransposedMat(Ainv);
    return Ainv;
  end);

InstallMethod(SptSetKernelModule,
  "Computes the kernel module of a Z-linear map",
  [IsSptSetZLMapRep],
  function(phi)
    local A, R2, M, N, diagR2, idsR2, R2inv, r, r2, s, i, j,
          tA, snf, tU, D, diag, idsD, r3,
          Pj, U, tUinv, W, WW, Q, E3, P3, R3;
    #A := phi!.A;
    M := phi!.domain;
    N := phi!.codomain;
    if not SptSetFpZModuleIsCanonical(N) then
      SptSetFpZModuleCanonicalForm(N);
    fi;
    if SptSetFpZModuleIsZero(N) then
      return SptSetCopyFpZModule(M);
    fi;
    A := M!.generators * phi!.B * N!.projection;
    R2 := StructuralCopy(phi!.codomain!.relations);

    # remove null rows in R2.
    diagR2 := DiagonalOfMat(R2);
    idsR2 := PositionsProperty(diagR2, x -> x<>0);
    R2 := R2{idsR2};
    # construct the pseudoinverse
    R2inv := SptSetPseudoInverseSpecialMat(R2);
    r := DimensionsMat(A)[1];
    r2 := DimensionsMat(A)[2];
    if R2 = [] then
      s := 0;
    else
      s := DimensionsMat(R2)[1];
    fi;

    tA := StructuralCopy(A);
    Append(tA, R2);
    snf := SmithNormalFormIntegerMatTransforms(tA);
    tU := snf!.rowtrans;
    D := snf!.normal;
    #Display(D);
    diag := DiagonalOfMat(TransposedMat(D));
    idsD := Positions(diag, 0);
    if idsD = [] then # We got an empty kernel...
      #return SptSetFpZModuleEPR([[1]], [[1]], [[1]]);
      return SptSetZeroModule();
    fi;
    Pj := IdentityMat(r+s){idsD};
    #Pj := NullMat(r3, r + s);
    #for i in [1..r3] do
    #  Pj[idsD[i]] := 1;
    #od;

    U := StructuralCopy(tU);
    Apply(U, row -> row{[1..r]});
    #Display(Pj, U);
    E3 := Pj * U * M!.generators;

    tUinv := Inverse(tU);
    W := tUinv{[1..r]};
    WW := tUinv{[(r+1)..(r+s)]};
    if s > 0 then
      Q := (W - A * R2inv * WW) * TransposedMat(Pj);
    else
      Q := W * TransposedMat(Pj);
    fi;

    P3 := M!.projection * Q;
    R3 := M!.relations * Q;

    return SptSetFpZModuleEPR(E3, P3, R3);
  end);

InstallMethod(SptSetKernelModule,
  "Computes the kernel module of a zero map",
  [IsSptSetZLMapZeroRep],
  function(phi)
    return SptSetCopyFpZModule(phi!.domain);
  end);

InstallMethod(SptSetCokernelModule,
  "Computes the cokernel module of a Z-linear map",
  [IsSptSetZLMapRep],
  function(phi)
    local N, A;
    N := SptSetCopyFpZModule(phi!.codomain);
    A := phi!.domain!.generators * phi!.B * N!.projection;
    if IsEmptyMatrix(N!.relations) then
      N!.relations := A;
    else
      Append(N!.relations, A);
    fi;
    return N;
  end);

InstallMethod(SptSetCokernelModule,
  "Computes the cokernel module of a zero map",
  [IsSptSetZLMapZeroRep],
  function(phi)
    return SptSetCopyFpZModule(phi!.codomain);
  end);

InstallMethod(SptSetHomologyModule,
  "Computes the homology module given two Z-linear maps",
  [IsCategoryOfSptSetZLMap, IsSptSetZLMapRep],
  function(phi, psi)
    local N, psi2, A;
    N := SptSetCokernelModule(phi);
    if SptSetFpZModuleIsZero(N) then
      # Quick fix: if N is empty, the answer is clearly an empty module.
      # however, the following code may fail because A would be an empty matrix which does not have meaningful dimensions.
      return SptSetZeroModule();
    fi;
    #A := psi!.domain!.generators * psi!.B * N!.projection;
    A := N!.generators * psi!.B * psi!.codomain!.projection;
    psi2 := SptSetZLMapByImages(N, psi!.codomain, A);
    return SptSetKernelModule(psi2);
  end);

  InstallMethod(SptSetHomologyModule,
    "Computes the homology module given two Z-linear maps",
    [IsCategoryOfSptSetZLMap, IsSptSetZLMapZeroRep],
    function(phi, psi)
      return SptSetCokernelModule(phi);
    end);
