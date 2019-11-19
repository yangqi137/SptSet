InstallMethod(U1SLSpecSeq,
"build U1-spin-liquid spectral sequence",
[IsHapResolution, IsGeneralMapping, IsFunction],
function(R, rho, tAct, nu)
  local spectrum, ss, s;
  #brMap := SptSetBarResolutionMap(R);
  spectrum := [];
  spectrum[1] := SptSetCoefficientZn(0, rho);
  spectrum[2] := SptSetCoefficientU1(tAct);

  ss := SptSetSpecSeqVanilla(R, spectrum);
end);
