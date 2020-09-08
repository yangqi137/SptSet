InstallGlobalFunction(FermionSPTSpecSeq,
function(R, auMap, w)
  local brMap, spectrum, ss, s;
  brMap := SptSetBarResolutionMap(R);
  spectrum := [];
  spectrum[0+1] := SptSetCoefficientU1(auMap);
  spectrum[1+1] := SptSetCoefficientZn(2, auMap);
  spectrum[2+1] := SptSetCoefficientZn(2, auMap);
  spectrum[3+1] := SptSetCoefficientZn(0, auMap);

  ss := SptSetSpecSeqVanilla(R, spectrum);

  s := g -> (1-(g^auMap)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 0, 1,
  function(n0, dn0)
    return {g1, g2} -> 1/2 * n0() * w(g1, g2);
  end);

  SptSetInstallCoboundary(ss, 2, 1, 1,
  function(n1, dn1)
    if dn1 = ZeroCocycle@ then
      return {g1, g2, g3} -> 1/2 * w(g1, g2) * n1(g3);
    else
      return {g1, g2, g3} -> 1/2 * (w(g1, g2) + dn1(g1, g2)) * n1(g3);
    fi;
  end);
  SptSetInstallCoboundary(ss, 2, 0, 2,
  function(n0, dn0)
    return {g1, g2} -> n0() * w(g1, g2);
  end);
  #SptSetInstallCoboundary(ss, 3, 0, 2,
  #function(n0, dn0)
  #  return ZeroCocycle@;
  #end);

  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
    return function(g1, g2, g3, g4)
      local val;
      val := 1/2 * ((n2(g1, g2) + w(g1, g2)) * n2(g3, g4) mod 2);
      if dn2 <> ZeroCocycle@ then
        val := val + 1/2 * ((n2(g1*g2*g3, g4) * dn2(g1, g2, g3)
          + n2(g1, g2*g3*g4) * dn2(g2, g3, g4)) mod 2);
        val := val + 1/2 * (w(g1, g2*g3) * dn2(g2, g3, g4));
        val := val + 1/2 * (dn2(g1, g2, g3*g4) * dn2(g1*g2, g3, g4) mod 2);
        val := val - 1/4 * (dn2(g1, g2, g3) * (1 - dn2(g1, g2, g3*g4)) mod 2);
      fi;
      return val;
    end;
  end);
  SptSetInstallCoboundary(ss, 2, 1, 2,
  function(n1, dn1)
    return {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3) + w(g1, g2) * n1(g3));
  end);
  #SptSetInstallCoboundary(ss, 3, 1, 2,
  #function(n1, dn1)
  #  return {g1, g2, g3, g4} -> 0;
  #end);
  SptSetInstallCoboundary(ss, 2, 0, 3,
  function(n0, dn0)
    return {g1, g2} -> 0; # This is wrong, but let us just leave it here for now.
  end);

  return ss;
end);
