InstallMethod(FermionEZSPTSpecSeq,
  "build fermion-ez-spt spectral sequence",
  [IsHapResolution, IsGeneralMapping],
  function(R, auMap)
    local brMap, spectrum, ss, s;
    brMap := SptSetBarResolutionMap(R);
    spectrum := [];
    spectrum[1] := SptSetCoefficientU1(auMap);
    spectrum[2] := SptSetCoefficientZn(2, auMap);
    spectrum[3] := SptSetCoefficientZn(2, auMap);
    spectrum[4] := SptSetCoefficientZn(0, auMap);
    ss := SptSetSpecSeqVanilla(R, spectrum);

    s := g -> (1+(g^auMap)[1][1])/2;

    SptSetInstallRawDerivative(ss, 2, 2, 1,
      function(n2)
        return {g1, g2, g3, g4} -> (1/2 * n2(g1, g2) * n2(g3, g4));
      end);
    SptSetInstallRawDerivative(ss, 2, 1, 2,
      function(n1)
        return {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3));
      end);
    SptSetInstallRawDerivative(ss, 2, 0, 3,
      function(n0)
        return {g1, g2} -> 0;
      end);
    SptSetInstallRawDerivative(ss, 2, 0, 2,
      function(n0)
        return {g1, g2} -> 0;
      end);

    SptSetInstallRawDerivative(ss, 3, 1, 2,
      function(n1, dn2, n2)
        return function(g1, g2, g3, g4)
          local val1, val2, val3, val4;
          val1 := 1/2 * (n2(g1, g2) * n2(g3, g4) mod 2);
          val2 := 1/2 * ((n2(g1*g2*g3, g4) * dn2(g1, g2, g3)
            + n2(g1, g2*g3*g4) * dn2(g2, g3, g4)) mod 2);
          val3 := 1/2 * (dn2(g1, g2, g3*g4) * dn2(g1*g2, g3, g4) mod 2);
          val4 := -1/4 * (dn2(g1, g2, g3) * (1 - dn2(g1, g2, g3*g4)) mod 2);
          return val1 + val2 + val3 + val4;
        end;
      end);

    return ss;
  end);

InstallGlobalFunction(FermionSPTLayersVerbose,
function(ss)
  local E212, E312, E412, E221, E321, E230;
  Display("Majorana:");
  E212 := SptSetSpecSeqComponent(ss, 2, 1, 2);
  SptSetFpZModuleCanonicalForm(E212);
  Display(E212);
  E312 := SptSetSpecSeqComponent(ss, 3, 1, 2);
  SptSetFpZModuleCanonicalForm(E312);
  Display(E312);
  E412 := SptSetSpecSeqComponent(ss, 4, 1, 2);
  SptSetFpZModuleCanonicalForm(E412);
  Display(E412);
  Display("Complex fermion:");
  E221 := SptSetSpecSeqComponent(ss, 2, 2, 1);
  SptSetFpZModuleCanonicalForm(E221);
  Display(E221);
  E321 := SptSetSpecSeqComponent(ss, 3, 2, 1);
  SptSetFpZModuleCanonicalForm(E321);
  Display(E321);
  Display("Bosonic:");
  E230 := SptSetSpecSeqComponent(ss, 2, 3, 0);
  SptSetFpZModuleCanonicalForm(E230);
  Display(E230);

  return [E412, E321, E230];
end);

InstallGlobalFunction(FermionSPTLayers,
function(ss)
  local E412, E321, E230;
  E412 := SptSetSpecSeqComponent(ss, 4, 1, 2);
  SptSetFpZModuleCanonicalForm(E412);
  E321 := SptSetSpecSeqComponent(ss, 3, 2, 1);
  SptSetFpZModuleCanonicalForm(E321);
  E230 := SptSetSpecSeqComponent(ss, 2, 3, 0);
  SptSetFpZModuleCanonicalForm(E230);

  return [E412, E321, E230];
end);
