InstallMethod(U1SLSpecSeq,
"build U1-spin-liquid spectral sequence",
[IsHapResolution, IsGeneralMapping, IsGeneralMapping, IsFunction],
function(R, rho, auMap, nu)
  local spectrum, ss, r;
  #brMap := SptSetBarResolutionMap(R);
  spectrum := [];
  spectrum[0+1] := SptSetCoefficientU1(auMap);
  spectrum[1+1] := SptSetCoefficientZn(0, rho);

  ss := SptSetSpecSeqVanilla(R, spectrum);

  #s := g -> (1+(g^auMap)[1][1])/2;
  #r := g -> (1 - (g^rho)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 3, 1,
  function(n3, dn3)
    return {g1, g2, g3, g4, g5} ->
    nu(g1, g2) * ((g1*g2)^rho)[1][1] * n3(g3, g4, g5);
  end);

  return ss;
end);
