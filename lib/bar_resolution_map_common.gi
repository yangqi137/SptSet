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
