InstallGlobalFunction(DisorderInsulatorSPTSpecSeq,
function(R, auMap, u1cMap, omega_)
  local brMap, spectrum, G, trivialMap, ss, s;
  brMap := SptSetBarResolutionMap(R);

  G := GroupOfResolution(R);
  trivialMap := SptSetTrivialGroupAction(G);

  spectrum := [];
  spectrum[0+1] := SptSetCoefficientZn(1, auMap);
  spectrum[1+1] := SptSetCoefficientZn(1, u1cMap);
  spectrum[2+1] := SptSetCoefficientZn(1, trivialMap);
  spectrum[3+1] := SptSetCoefficientZn(0, auMap);
  ss := SptSetSpecSeqVanilla(R, spectrum);

  s := g -> (1-(g^auMap)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 1, 1,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 2,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 1, 2,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 3,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 1, 3,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 4, 1, 3,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 2,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 2, 2,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 3, 1,
  function(n3, dn3)
    return ZeroCocycle@;
  end);
  SptSetInstallAddTwister(ss, 1, 1, {l1, l2} -> ZeroCocycle@);
    
  SptSetInstallAddTwister(ss, 2, 0,
    function(l1, l2)
      return ZeroCocycle@;
    end);

  SptSetInstallAddTwister(ss, 1, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 1, {l1, l2} -> ZeroCocycle@);

  # place holders for twisters in (3+1)D
  SptSetInstallAddTwister(ss, 1, 3, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 3, 1, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 4, 0, {l1, l2} -> ZeroCocycle@);

  SptSetInstallAddTwister(ss, 3, 0,
  function(l1, l2)
    return ZeroCocycle@;
  end);

  return ss;
  end);

  InstallGlobalFunction(AvgInsulatorSPTSpecSeq,
function(R, auMap, u1cMap, omega_)
  local brMap, spectrum, G, trivialMap, au_u1cMap, ss, s;
  brMap := SptSetBarResolutionMap(R);

  G := GroupOfResolution(R);
  trivialMap := SptSetTrivialGroupAction(G);
  au_u1cMap := GroupHomomorphismByFunction(G, GL(1, Integers), {g} -> auMap(g)*u1cMap(g));

  spectrum := [];
  spectrum[0+1] := SptSetCoefficientZn(1, auMap);
  spectrum[1+1] := SptSetCoefficientZn(1, u1cMap);
  spectrum[2+1] := SptSetCoefficientZn(1, trivialMap);
  spectrum[3+1] := SptSetCoefficientZn(0, auMap);
  ss := SptSetSpecSeqVanilla(R, spectrum);

  s := g -> (1-(g^auMap)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 1, 1,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 2,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 1, 2,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 3,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 1, 3,
  function(n1, dn1)
    local coeff_omega_, coeff_s, beta_omega_, beta_s;
    coeff_omega_ := SptSetCoefficientZn(0, au_u1cMap);
    coeff_s := SptSetCoefficientZn(2, trivialMap);
    beta_omega_ := InhomoCoboundary@(coeff_omega_, omega_);
    beta_s := ScaleInhomoCochain@(1/2, InhomoCoboundary@(coeff_s, s));
    return AddInhomoCochain@(Cup0@(3, 1, spectrum[3+1], beta_omega_, n1),
      Cup0@(3, 1, spectrum[3+1], Cup0@(2, 1, spectrum[3+1], beta_s, n1), n1));
  end);

  SptSetInstallCoboundary(ss, 4, 1, 3,
  function(n1, dn1)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 2,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 3, 2, 2,
  function(n2, dn2)
    return ZeroCocycle@;
  end);

  SptSetInstallCoboundary(ss, 2, 3, 1,
  function(n3, dn3)
    return ZeroCocycle@;
  end);
    
  SptSetInstallAddTwister(ss, 1, 1, {l1, l2} -> ZeroCocycle@);
    
  SptSetInstallAddTwister(ss, 2, 0,
    function(l1, l2)
      return ZeroCocycle@;
    end);

  SptSetInstallAddTwister(ss, 1, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 1, {l1, l2} -> ZeroCocycle@);

  # place holders for twisters in (3+1)D
  SptSetInstallAddTwister(ss, 1, 3, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 3, 1, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 4, 0, {l1, l2} -> ZeroCocycle@);

  # place holders for twisters in (4+1)D
  SptSetInstallAddTwister(ss, 1, 4, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 3, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 3, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 4, 1, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 5, 0, {l1, l2} -> ZeroCocycle@);

  SptSetInstallAddTwister(ss, 3, 0,
  function(l1, l2)
    return ZeroCocycle@;
  end);

  return ss;
  end);