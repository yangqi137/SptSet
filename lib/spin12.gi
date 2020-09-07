pi@ := 3.1415926;

InstallGlobalFunction(PtGrp2DOrthogonalMatrix@, function(it)
  if it >= 13 and it <= 17 then
    return [[1., 0., 0.], [-1/2., Sqrt(3.)/2, 0.], [0., 0., 1.]];
  else
    return IdentityMat(3);
  fi;
end);

InstallGlobalFunction(PtGrp2DProjRep@, function(m)
  # Assume m is an O(2) matrix.
  local s, t;
  s := SignFloat(Float(DeterminantMat(m)));
  t := Atan2(Float(m[1][2]), Float(m[1][1]));
  return [s, t/2];
end);

InstallGlobalFunction(AddPtGrp2DProjRep@, function(p1, p2)
  local s;
  if p1[1] = -1 and p2[1] = -1 then
    s := Atan(1.) * 4;
  else
    s := 0;
  fi;
  return [p1[1]*p2[1], p2[1]*p1[2] + p2[2] + s];
end);

InstallGlobalFunction(Spin12Factor2D@, function(om)
  local w, om2;
  om2 := Inverse(om);
  w := function(g1, g2)
    local pi, pg1, pg2, g12, pg12, pg, diff;
    pi := Atan(1.) * 4;
    pg1 := PtGrp2DProjRep@(om2 * g1 * om);
    pg2 := PtGrp2DProjRep@(om2 * g2 * om);
    g12 := g1 * g2;
    pg12 := PtGrp2DProjRep@(om2 * g12 * om);
    pg := AddPtGrp2DProjRep@(pg1, pg2);
    #Error(1);
    Assert(0, pg12[1] = pg[1], "ASSERTION FAIL: projective reps do not agree1");
    diff := Rat((pg[2] - pg12[2]) / pi);
    #Display(diff);
    Assert(0, IsInt(diff), "ASSERTION FAIL: projective reps do not agree2");
    return 1/2*(diff mod 2);
  end;

  return w;
end);

InstallGlobalFunction(Spin12Factor, function(d, it)
  local om;
  if d <> 2 then
    Display("only implimented for d=2");
    return fail;
  fi;
  om := PtGrp2DOrthogonalMatrix@(it);
  return Spin12Factor2D@(om);
end);
