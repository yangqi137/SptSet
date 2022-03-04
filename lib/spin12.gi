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
  if t<0. then t := t + Atan(1.) * 8; fi;
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
    #return 1/2*(diff mod 2);
    return diff mod 2;
  end;

  return w;
end);

InstallGlobalFunction(Spin@, function(R)
  local Jx, Jy, Jz, c, s, lambdas, pos, es, axis, n, J, nn, Rp, Rm;
  local c2, s2, sx, sy, sz, sR;

  Jx := [[0, 0, 0], [0, 0, 1], [0, -1, 0]];
  Jy := [[0, 0, -1], [0, 0, 0], [1, 0, 0]];
  Jz := [[0, 1, 0], [-1, 0, 0], [0, 0, 0]];

  sx := [[0, 1], [1, 0]];
  sy := [[0, -E(4)], [E(4), 0]];
  sz := [[1, 0], [0, -1]];

  c := (TraceMat(R) - 1) / 2; # c = cos(theta)
  s := Sqrt(1 - c*c); # s = sin(theta)
  if c = 1 then
    return IdentityMat(2);
  else
    lambdas := Eigenvalues(Rationals, R);
    #Display(lambdas);
    pos := Position(lambdas, 1);
    es := Eigenspaces(Rationals, R)[pos];
    axis := GeneratorsOfVectorSpace(es)[1];
    #Display([axis, c, s]);
    #Display(BasisVectors(Basis(es)));
    n := axis / Sqrt(axis[1]*axis[1] + axis[2]*axis[2] + axis[3]*axis[3]);
    J := n[1]*Jx + n[2]*Jy + n[3]*Jz;
    nn := TransposedMat([n])*[n];
    Rp := s * J + c * (IdentityMat(3) - nn) + nn;
    Rm := -s * J + c * (IdentityMat(3) - nn) + nn;
    if R = Rm then
      s := -s;
    else
      Assert(R = Rp, "ASSERTION FAILURE: R is neither Rp nor Rm");
    fi;
    c2 := Sqrt((1+c)/2); # c2 = cos(theta/2)
    s2 := Sqrt((1-c)/2); # s2 = sin(theta/2)
    sR := c2 * IdentityMat(2) + s2 * (n[1]*sx + n[2]*sy + n[3]*sz);
    return sR;
  fi;
end);

InstallGlobalFunction(Spin12FactorForPointGroup, function(pg)
  local om, om2;
  om := FindOrthogonalMatrix@(pg);
  w := function(g1, g2)
    local s1, s2, s12, s1s2;
    s1 := Spin@(om2 * g1 * om);
    s2 := Spin@(om2 * g2 * om);
    s12 := Spin@(om2 * g1 * g2 * om);
    s1s2 := s1 * s2;
    if s12 = s1s2 then
      return 0;
    else
      Assert(s12 = -s1s2, "ASSERTION FAIL: s1*s2 <> +/- s12");
      return 1;
    fi;
  end;

  return w;
end);

InstallGlobalFunction(Spin12FactorForSpaceGroup, function(sg)
  local pg, fpg, wpg;
  fpg := PointHomomorphism(sg);
  pg := Image(fpg);
  wpg := Spin12FactorForPointGroup(pg);
  return {g1, g2} -> wpg(g1^fpg, g2^fpg);
end);

InstallGlobalFunction(Spin12Factor, function(d, it)
  local om;
  if d = 2 then
    om := PtGrp2DOrthogonalMatrix@(it);
    return Spin12Factor2D@(om);
  elif d=3 then
    #om := PtGrpOrthogonalMatrix@(it);
    return Spin12FactorForSpaceGroup(SpaceGroupBBNWZ(d, it));
  else
    Display("only implimented for d=2, 3");
    return fail;
  fi;
end);
