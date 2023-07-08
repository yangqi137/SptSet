InstallGlobalFunction(ZeroCocycle@,
function(arg...) return 0; end);

InstallGlobalFunction(BarResolutionBoundary@,
function(gid, glist)
  local n, dglist, gl2, glext, i;
  n := Length(glist);
  dglist := [];
  if n > 0 then
    gl2 := StructuralCopy(glist);
    Add(gl2, 1, 1);
    Add(dglist, gl2);

    glext := StructuralCopy(glist);
    Add(glext, 1, 1);
    Add(glext, gid, 2);

    for i in [1..(n-1)] do
      gl2 := StructuralCopy(glext);
      gl2[i+2] := gl2[i+2] * Remove(gl2, i+3);
      if i mod 2 = 1 then
        gl2[1] := -1;
      fi;
      Add(dglist, gl2);
    od;

    gl2 := StructuralCopy(glext);
    if n mod 2 = 1 then
      gl2[1] := -1;
    fi;
    Remove(gl2, n+2);
    Add(dglist, gl2);
  fi;
  return dglist;
end);

InstallGlobalFunction(InhomoCoboundary@,
function(coeff, a)
  local gAction, gid, da;
  gAction := coeff!.gAction;
  gid := Identity(PreImage(gAction));
  da := function(glist...)
    local n, dglist, result, x, xs, xg, xgl;
    n := Length(glist);
    dglist := BarResolutionBoundary@(gid, glist);
    result := 0;
    for x in dglist do
      xs := x[1];
      xg := x[2];
      xgl := x{[3..(n+1)]};
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

InstallGlobalFunction(ScaleInhomoCochain@,
function(k, a)
  return {glist...} -> (k * CallFuncList(a, glist));
end);

InstallGlobalFunction(AddInhomoCochain@,
function(a, b)
  if a = ZeroCocycle@ then
    return b;
  elif b = ZeroCocycle@ then
    return a;
  fi;
  return {glist...} -> (CallFuncList(a, glist) + CallFuncList(b, glist));
end);

InstallGlobalFunction(Cup0@,
function(p, q, coeff, a, b)
  local gAction, f, gid;
  gAction := coeff!.gAction;
  gid := Identity(PreImage(gAction));
  f := function(glist...)
    local gp, gq, gpp;
    gp := glist{[1..p]};
    gq := glist{[(p+1)..(p+q)]};
    gpp := Product(gp, gid);
    return CallFuncList(a, gp) *
      ((gpp^gAction)[1][1] * CallFuncList(b, gq));
  end;
  return f;
end);

InstallGlobalFunction(Cup1@,
function(p, q, coeff, a, b)
  local gAction, f, gid;
  gAction := coeff!.gAction;
  gid := Identity(PreImage(gAction));
  f := function(glist...)
    local g1, g2, g3, g1p, g2p, s, i, result;
    result := 0;
    for i in [0..(p-1)] do
      g1 := glist{[1..i]};
      g2 := glist{[(i+1)..(i+q)]};
      g3 := glist{[(i+q+1)..(p+q-1)]};
      g1p := Product(g1, gid);
      g2p := Product(g2, gid);
      s := (-1)^((p-i)*(q+1));
      result := result + s * CallFuncList(a, Concatenation(g1, [g2p], g3))
        * ((g1p^gAction)[1][1] * CallFuncList(b, g2));
    od;
    return result;
  end;
  return f;
end);

InstallGlobalFunction(Cup2@,
function(p, q, coeff, a, b)
  local gAction, f, gid;
  gAction := coeff!.gAction;
  gid := Identity(PreImage(gAction));
  return function(glist...)
    local gl1, gl2, gl3, gl4, gl1p, gl2p, gl3p, i, j, s, result;
    result := 0;
    for i in [0..(p-1)] do
      for j in [(i+1)..(q-1)] do
        gl1 := glist{[1..i]};
        gl2 := glist{[(i+1)..j]};
        gl3 := glist{[(j+1)..(j-i+p-1)]};
        gl4 := glist{[(j-i+p)..(p+q-2)]};

        gl1p := Product(gl1, gid);
        gl2p := Product(gl2, gid);
        gl3p := Product(gl3, gid);

        s:= (-1)^((p-i)*(j-i+1));
        result := result + s * CallFuncList(a, Concatenation(gl1, [gl2p], gl3))
          * ((gl1p^gAction)[1][1] * CallFuncList(b, Concatenation(gl2, [gl3p], gl4)));
      od;
    od;
    return result;
  end;
end);

InstallGlobalFunction(CheckCochainEqOverBasisListZ2@,
function(c1, c2, basislist)
  local deg, glist;
  if c1 = ZeroCocycle@ then
    if c2 = ZeroCocycle@ then return;
    else
      deg := NumberArgumentsFunction(c2);
    fi;
  else
    deg := NumberArgumentsFunction(c1);
  fi;

  for glist in basislist do
    if (CallFuncList(c1, glist) mod 2) <> (CallFuncList(c2, glist) mod 2) then
      Error("CheckCochainEqOverSubset fails!");
    fi;
  od;
end);

InstallGlobalFunction(CheckCochainEqOverBasisListU1@,
function(c1, c2, basislist)
  local deg, glist;
  if c1 = ZeroCocycle@ then
    if c2 = ZeroCocycle@ then return;
    else
      deg := NumberArgumentsFunction(c2);
    fi;
  else
    deg := NumberArgumentsFunction(c1);
  fi;

  for glist in basislist do
    if not IsInt(CallFuncList(c1, glist) - CallFuncList(c2, glist)) then
      Error("CheckCochainEqOverSubset fails!");
    fi;
  od;
end);

InstallGlobalFunction(ShortBasisListFromResolution@,
function(brMap, deg)
  local R, n, i, bl, bwl, bw;
  R := brMap!.hapResolution;
  n := Dimension(R)(deg);
  bl := SSortedList([]);
  for i in [1..n] do
    bwl := SptSetMapToBarWord(brMap, deg, i);
    for bw in bwl do
      AddSet(bl, bw{[3..(deg+2)]});
    od;
  od;
  return bl;
end);
