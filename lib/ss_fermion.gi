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

  SptSetInstallCoboundary(ss, 2, 3, 1, function(n3, dn3)
    return function(g1, g2, g3, g4, g5)
      local o5, n3c1n3, n3c2dn3;
      # o5 = 1/2 * (w2 u n3 + n3 u1 n3).
      # we are again ignoring the G-actions because Z2 can only have a trivial G-action.
      o5 := 1/2 * w(g1, g2) * n3(g3, g4, g5);
      n3c1n3 := n3(g1*g2*g3, g4, g5) * n3(g1, g2, g3);
      n3c1n3 := n3c1n3 + n3(g1, g2*g3*g4, g5) * n3(g2, g3, g4);
      n3c1n3 := n3c1n3 + n3(g1, g2, g3*g4*g5) * n3(g3, g4, g5);
      o5 := o5 + 1/2 * n3c1n3;
      if dn3 <> ZeroCocycle@ then
        n3c2dn3 := n3(g1, g2, g3) * dn3(g1, g2*g3, g4, g5) - n3(g1*g2, g3, g4) * dn3(g1, g2, g3*g4, g5) + n3(g1*g2*g3, g4, g5) * dn3(g1, g2, g3, g4*g5)
          + n3(g1, g2, g3) * dn3(g2, g3, g4, g5) + n3(g1, g2*g3, g4) * dn3(g2, g3, g4, g5);
        o5 := o5 + 1/2 * n3c2dn3;

        # 1/2w2(013)dn3(12345)
        o5 := o5 + 1/2 * w(g1, g2*g3) * dn3(g2, g3, g4, g5);

        # 1/2w2(023)[dn3(01245) + dn3(01235) + dn3(01234)]
        o5 := o5 + 1/2 * w(g1*g2, g3) * (dn3(g1, g2, g3*g4, g5)
          + dn3(g1, g2, g3, g4*g5) + dn3(g1, g2, g3, g4));

        # 1/2dn3(02345)dn3(01235)
        o5 := o5 + 1/2 * dn3(g1*g2, g3, g4, g5) * dn3(g1, g2, g3, g4*g5);
        # 1/4dn3(01245)dn3(01234)
        o5 := o5 + 1/4 * (dn3(g1, g2, g3*g4, g5) * dn3(g1, g2, g3, g4) mod 2);
        # -1/4[dn3(12345)+dn3(02345)+dn3ð01345)]dn3(01235)
        o5 := o5 - 1/4 * ((dn3(g2, g3, g4, g5) + dn3(g1*g2, g3, g4, g5)
          + dn3(g1, g2*g3, g4, g5)) * dn3(g1, g2, g3, g4*g5) mod 2);
      fi;
      return o5;
    end;
  end);

  return ss;
end);
