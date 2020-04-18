InstallMethod(InsulatorSPTSpecSeq,
"build topological-insulator SPT spectral sequence",
[IsHapResolution, IsGeneralMapping, IsGeneralMapping, IsFunction],
function(R, auMap, u1cMap, omega_)
  local brMap, spectrum, G, trivialMap, ss, s;
  brMap := SptSetBarResolutionMap(R);

  G := GroupOfResolution(R);
  trivialMap := SptSetTrivialGroupAction(G);

  spectrum := [];
  spectrum[0+1] := SptSetCoefficientU1(auMap);
  spectrum[1+1] := SptSetCoefficientZn(0, u1cMap);
  # spectrum[2+1] is 0;
  spectrum[3+1] := SptSetCoefficientZn(0, auMap);
  ss := SptSetSpecSeqVanilla(R, spectrum);

  s := g -> (1-(g^auMap)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 1, 1,
  function(n1, dn1)
    return {g1, g2, g3} -> omega_(g1, g2) * n1(g3);
  end);

  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
    return {g1, g2, g3, g4}
    -> omega_(g1, g2) * n2(g3, g4) + 1/2 * n2(g1, g2) * n2(g3, g4);
  end);

  return ss;
end);

InstallGlobalFunction(InsulatorSPTLayersVerbose,
function(ss, dim)
  local layerNames, p, q, rmax, r, Erpq;
  layerNames := ["Bosonic:", "Complex fermion:", "Empty:", "p+ip:"];
  for p in [1..(dim+1)] do
    q := dim + 1 - p;
    if q >= 0 and q <= 3 then
      Display(layerNames[q+1]);
      rmax := Maximum(q+2, p+1);
      for r in [2..rmax] do
        Erpq := SptSetSpecSeqComponent(ss, r, p, q);
        SptSetFpZModuleCanonicalForm(Erpq);
        Display(Erpq);
      od;
    fi;
  od;
end);