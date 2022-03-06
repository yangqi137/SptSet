BindGlobal(
  "TheFamilyOfSptSetBarResMaps",
  NewFamily("TheFamilyOfSptSetBarResMaps")
);

InstallMethod(SptSetMapToBarCocycle,
"map to an inhomogeneous cocycle",
[IsCategoryOfSptSetBarResMap, IsInt, IsGeneralMapping, IsRowVector],
function(brMap, deg, gAction, alpha)
  local f;
  f := function(glist...)
    local elts, w, x, val, xs, xg, xb;
    if Length(glist) <> deg then
      return fail;
    fi;
    elts := brMap!.hapResolution!.elts;
    w := SptSetMapFromBarWord(brMap, deg, glist);
    val := 0;
    for x in w do
      xs := x[1];
      xb := x[2];
      xg := elts[x[3]];
      val := val + xs * (xg^gAction)[1][1] * alpha[xb];
    od;

    return val;
  end;
  return f;
end);

InstallMethod(SptSetMapToBarCocycle,
"map to an inhomogeneous cocycle",
[IsCategoryOfSptSetBarResMap, IsInt, IsSptSetCoeffZnRep, IsRowVector],
function(brMap, deg, coeff, alpha)
  return SptSetMapToBarCocycle(brMap, deg, coeff!.gAction, alpha);
end);

InstallMethod(SptSetMapFromBarCocycle,
"map from an inhomogeneous cocycle",
[IsCategoryOfSptSetBarResMap, IsInt, IsGeneralMapping, IsFunction],
function(brMap, deg, gAction, alpha_)
  local n, val, i, fei, feiw;
  n := Dimension(brMap!.hapResolution)(deg);
  val := [];
  for i in [1..n] do
    val[i] := 0;
    fei := SptSetMapToBarWord(brMap, deg, i);
    for feiw in fei do
      val[i] := val[i] + feiw[1] * (feiw[2]^gAction)[1][1]
        * CallFuncList(alpha_, feiw{[3..(deg+2)]});
    od;
  od;
  return val;
end);
InstallMethod(SptSetMapFromBarCocycle,
"map from an inhomogeneous cocycle",
[IsCategoryOfSptSetBarResMap, IsInt, IsSptSetCoeffZnRep, IsFunction],
function(brMap, deg, coeff, alpha_)
  return SptSetMapFromBarCocycle(brMap, deg, coeff!.gAction, alpha_);
end);
InstallMethod(SptSetMapFromBarCocycle,
"map from an inhomogeneous cocycle",
[IsCategoryOfSptSetBarResMap, IsInt, IsSptSetCoeffU1Rep, IsFunction],
function(brMap, deg, coeff, alpha_)
  local alpha;
  alpha := SptSetMapFromBarCocycle(brMap, deg, coeff!.gAction, alpha_);
  return SptSetBockstein(brMap!.hapResolution,
    deg, coeff!.gAction, alpha);
end);

InstallMethod(SptSetSolveCocycleEq,
"solve an inhomogeneous cocycle equation using maps to/from the bar resolution",
[IsCategoryOfSptSetBarResMap, IsInt, IsGeneralMapping,
  IsFunction, IsRowVector],
function(brMap, deg, gAction, alpha_, beta)
  local solveCocycleEq, alpha, h_alpha_, beta_;
  beta_ := SptSetMapToBarCocycle(brMap, deg-1, gAction, beta);
  h_alpha_ := function(glist...)
    local w, hw, whw, val;
    #w := [1, Identity(brMap!.group)];
    #Append(w, glist);
    #hw := StructuralCopy(brMap!.hapEquiv!.equiv(deg-1, [w]));
    hw := StructuralCopy(SptSetMapEquivBarWord(brMap, glist));
    val := 0;
    for whw in hw do
      val := val + whw[1] * (whw[2]^gAction)[1][1]
        * CallFuncList(alpha_, whw{[3..(deg+2)]});
    od;
    return val;
  end;

  return function(glist...)
    return CallFuncList(beta_, glist) - CallFuncList(h_alpha_, glist);
  end;
end);
InstallMethod(SptSetSolveCocycleEq,
"solve an inhomogeneous cocycle equation using maps to/from the bar resolution",
[IsCategoryOfSptSetBarResMap, IsInt, IsSptSetCoeffZnRep,
  IsFunction, IsRowVector],
function(brMap, deg, coeff, alpha_, beta)
  return SptSetSolveCocycleEq(brMap, deg, coeff!.gAction, alpha_, beta);
end);

InstallGlobalFunction(SolveU1CocycleEq@,
function(hapResolution, deg, f, a)
  local bdry, G, elts, nd, ndm1, cobdryMat, j, dej, wdej, sw, iw, gw,
        snf, U, V, D, i, a2, b, cobdryMat1;
  bdry := BoundaryMap(hapResolution);
  G := GroupOfResolution(hapResolution);
  elts := hapResolution!.elts;

  nd := Dimension(hapResolution)(deg);
  ndm1 := Dimension(hapResolution)(deg - 1);
  cobdryMat := NullMat(ndm1, nd);
  for j in [1..nd] do
    dej := bdry(deg, j);
    for wdej in dej do
      sw := SignInt(wdej[1]);
      iw := AbsInt(wdej[1]);
      gw := elts[wdej[2]];
      cobdryMat[iw][j] := cobdryMat[iw][j] + sw * ((gw^f)[1][1]);
    od;
  od;

  snf := SmithNormalFormIntegerMatTransforms(cobdryMat);
  U := snf.rowtrans;
  D := snf.normal;
  V := snf.coltrans;
  a2 := a * V;
  b := [];

  for i in [1..ndm1] do
    if IsBound(D[i][i]) and D[i][i] <> 0 then
      b[i] := a2[i] / D[i][i];
    else
        Assert(0, a2[i] = 0, "a is not a coboundary");


      #if a2[i] <> 0 then
        #Error("a is not a coboundary");
      #fi;
      b[i] := 0;
    fi;
  od;
  b := b * U;
  return b;
end);

InstallMethod(SptSetSolveCocycleEq,
"solve an inhomogeneous cocycle equation: spectial U(1) edition",
[IsCategoryOfSptSetBarResMap, IsInt, IsSptSetCoeffU1Rep,
  IsFunction, IsRowVector],
function(brMap, deg, coeff, alpha_, beta)
  local res, alpha, alpha2, beta2;
  res := brMap!.hapResolution;
  alpha := SptSetMapFromBarCocycle(brMap, deg, coeff!.gAction, alpha_);
  alpha2 := alpha - beta;
  beta2 := SolveU1CocycleEq@(res, deg, coeff!.gAction, alpha2);
  return SptSetSolveCocycleEq(brMap, deg, coeff!.gAction, alpha_, beta2);
end);
