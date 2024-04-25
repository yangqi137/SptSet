InstallGlobalFunction(AvgFermionSPTSpecSeq,
function(R, auMap, w)
  local brMap, spectrum, ss, s;
  brMap := SptSetBarResolutionMap(R);
  spectrum := [];
  spectrum[0+1] := SptSetCoefficientZn(1, auMap);
  spectrum[1+1] := SptSetCoefficientZn(2, auMap);
  spectrum[2+1] := SptSetCoefficientZn(2, auMap);
  spectrum[3+1] := SptSetCoefficientZn(0, auMap);

  ss := SptSetSpecSeqVanilla(R, spectrum);

  s := g -> (1-(g^auMap)[1][1])/2;

  SptSetInstallCoboundary(ss, 2, 0, 1,
  function(n0, dn0)
      return {g1, g2} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 1,
  function(n1, dn1)
      return {g1, g2, g3} -> 0;
  end);
  SptSetInstallCoboundary(ss, 2, 0, 2,
  function(n0, dn0)
    return {g1, g2} -> n0() * w(g1, g2);
  end);
  SptSetInstallCoboundary(ss, 3, 0, 2,
  function(n0, dn0)
    return ZeroCocycle@;
  end);
  
  SptSetInstallCoboundary(ss, 2, 1, 2,
  function(n1, dn1)
    return {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3) + w(g1, g2) * n1(g3));
  end);
  SptSetInstallCoboundary(ss, 3, 1, 2,
  function(n1, dn1)
    return {g1, g2, g3, g4} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
      return {g1, g2, g3, g4} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 0, 3,
  function(n0, dn0)
    return {g1, g2} -> (n0() * w(g1, g2));
  end);
  SptSetInstallCoboundary(ss, 3, 0, 3,
  function(n0, dn0)
    local n02, coeff, w1w;
    n02 := Int(n0()/2);
    coeff := ss!.spectrum[1+1];
    w1w := Cup1@(2, 2, coeff, w, w);
    return {g1, g2, g3} -> (n02 * w1w(g1, g2, g3));
  end);
  SptSetInstallCoboundary(ss, 4, 0, 3,
  function(n0, dn0)
    return {g1, g2, g3, g4} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 1, 3,
  function(n1, dn1)

    if dn1 = ZeroCocycle@ then
      return {g1, g2, g3} -> (w(g1, g2) * n1(g3) + s(g1) * n1(g2) * n1(g3));
    else
      return function(g1, g2, g3)
        local val;
        val := w(g1, g2) * n1(g3);
        val := val + s(g1) * n1(g2) * n1(g3);
        val := val + n1(g1) * dn1(g2, g3);
        # val := val + s(g1) * n1 cup1 dn1;
        return val;
      end;
    fi;
  end);

  SptSetInstallCoboundary(ss, 3, 1, 3,
  function(n1, dn1)
    return {g1, g2, g3, g4} -> 0;
  end);

  SptSetInstallCoboundary(ss, 4, 1, 3,
  function(n1, dn1)
    return {g1, g2, g3, g4, g5} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 2, 2,
  function(n2, dn2)
    return
    function(g1, g2, g3, g4)
      local w2n2, n2n2, n2c1n2;
      # we are ignoring the G-action because Z2 can only have a trivial G-action.
      w2n2 := w(g1, g2) * n2(g3, g4);
      n2n2 := n2(g1, g2) * n2(g3, g4);
      #n2c1n2 := ??;
      #f c1 g (0123) = B[f(023),g(012)]−B[f(013),g(123)]
      #n2 c1 n2(g1, g2, g3) = n2(g1*g2, g3)n2(g1, g2) - n2(g1, g2*g3)n2(g2, g3);
      n2c1n2 := n2(g2*g3, g4) * n2(g2, g3) - n2(g2, g3*g4) * n2(g3, g4);
      # TODO: need to add dn2
      return w2n2 + n2n2 + s(g1) * n2c1n2;
    end;
  end);

  SptSetInstallCoboundary(ss, 3, 2, 2,
  function(n2, dn2)
    return {g1, g2, g3, g4, g5} -> 0;
  end);

  SptSetInstallCoboundary(ss, 2, 3, 1,
      function(n3, dn3)
          return {g1, g2, g3, g4, g5} -> 0;
      end);

  SptSetInstallAddTwister(ss, 1, 1, {l1, l2} -> ZeroCocycle@);
    
  SptSetInstallAddTwister(ss, 2, 0,
    function(l1, l2)
      return {g1, g2} -> 0;
    end);

  SptSetInstallAddTwister(ss, 1, 2,
      function(l1, l2)
          return ZeroCocycle@;
      end);

  SptSetInstallAddTwister(ss, 2, 1,
  function(l1, l2)
    local n11, n12, coeff;
    n11 := l1[1+1];
    n12 := l2[1+1];
    coeff := spectrum[1+1];
    if n11 = ZeroCocycle@ or n12 = ZeroCocycle@ then
      return ZeroCocycle@;
    fi;
    return {g1, g2} -> (n11(g1) * n12(g2) + s(g1) * n11(g2) * n12(g2));
  end);
  SptSetInstallAddTwister(ss, 3, 0, {l1, l2} -> ZeroCocycle@);

  SptSetInstallAddTwister(ss, 1, 3, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 2, 2, {l1, l2} -> ZeroCocycle@);
  SptSetInstallAddTwister(ss, 3, 1, function(l1, l2)
    local coeff, n21, n22, m3a, m3b;

    coeff := spectrum[1+1];
    n21 := l1[2+1];
    n22 := l2[2+1];

    m3a := Cup1@(2, 2, coeff, n21, n22);
    m3b := Cup0@(1, 2, coeff, s, Cup2@(2, 2, coeff, n21, n22));

    return AddInhomoCochain@(m3a, m3b);
  end);
  SptSetInstallAddTwister(ss, 4, 0, {l1, l2} -> ZeroCocycle@);

    # place holders for twisters in (4+1)D
    SptSetInstallAddTwister(ss, 1, 4, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 2, 3, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 3, 2, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 4, 1, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 5, 0, {l1, l2} -> ZeroCocycle@);

  return ss;
end);
