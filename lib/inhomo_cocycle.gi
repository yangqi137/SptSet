InstallGlobalFunction(ZeroCocycle@,
function(arg...) return 0; end);

InstallGlobalFunction(InhomoCoboundary@,
function(coeff, a)
  local gAction, gid, da;
  gAction := coeff!.gAction;
  gid := Identity(PreImage(gAction));
  da := function(glist...)
    local n, dglist, result, x, xs, xg, xgl;
    n := Length(glist);
    dglist := BarResolutionBoundary(gid, glist);
    result := 0;
    for x in dglist do
      xs := x[1];
      xg := x[2];
      xgl := x{[3..n]};
      result := result + xs * (xg^gAction)[1][1] * CallFuncList(a, xgl);
    od;

    return result;
  end;

  return da;
end);

InstallGlobalFunction(NegativeInhomoCochain@,
function(a)
  return {glist...} -> (-CallFuncList(a, glist));
end);

InstallGlobalFunction(AddInhomoCochain@,
function(a, b)
  return {glist...} -> (CallFuncList(a, glist) + CallFuncList(b, glist));
end);
