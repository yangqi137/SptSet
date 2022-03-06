InstallGlobalFunction(SptSetBockstein,
  function(hapResolution, deg, gAction, v)
    local v2, n, i, dei, bdry, elts, x, vx;
    n := Dimension(hapResolution)(deg+1);
    v2 := [];
    bdry := BoundaryMap(hapResolution);
    elts := hapResolution!.elts;
    for i in [1..n] do
      v2[i] := 0;
      dei := bdry(deg+1, i);
      for x in dei do
        vx := SignInt(x[1]) * (elts[x[2]]^gAction)[1][1] * v[AbsInt(x[1])];
        #vx := vx - Int(vx);
        v2[i] := v2[i] + vx;
      od;
    od;
    return v2;
  end);
