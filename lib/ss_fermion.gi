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
      local dn2;
      dn2 := {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3) + w(g1, g2) * n1(g3));
      return function(g1, g2, g3, g4)
        local val;
        val := 1/2 * s(g1) * dn2(g2, g3, g4);
        val := val + 1/2 * (w(g1, g2*g3) * dn2(g2, g3, g4));
        val := val + 1/2 * dn2(g1, g2, g3*g4) * dn2(g1*g2, g3, g4);
        val := val - 1/4 * ((dn2(g1, g2, g3) * (1 - dn2(g1, g2, g3*g4))) mod 2);
        return val;
      end;
  end);
  SptSetInstallCoboundary(ss, 2, 2, 1,
  function(n2, dn2)
      local c4, coeff;
      coeff := spectrum[1+1];
      c4 := {g1, g2, g3, g4} -> ((w(g1, g2) + n2(g1, g2)) * n2(g3, g4));
      if dn2 <> ZeroCocycle@ then
        c4 := AddInhomoCochain@(c4, Cup1@(3, 2, coeff, dn2, n2));
      fi;
      return ScaleInhomoCochain@(1/2, c4);
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
    return function(g1, g2, g3, g4, g5)
      local n2_123, n2_134, n2_125, n2_145,
        n2_234, n2_245, n2_235, n2_345,
        a4, b4, N2345, L12345, a4t, b4t, o5sym, t5;

      n2_123 := n2(g2, g3) mod 2;
      n2_134 := n2(g2*g3, g4) mod 2;
      n2_125 := n2(g2, g3*g4*g5) mod 2;
      n2_145 := n2(g2*g3*g4, g5) mod 2;

      n2_234 := n2(g3, g4) mod 2;
      n2_245 := n2(g3*g4, g5) mod 2;
      n2_235 := n2(g3, g4*g5) mod 2;
      n2_345 := n2(g4, g5) mod 2;
        
      a4 := (n2_123 * n2_345 + s(g2) * n2_235 * n2_345) mod 2;
      b4 := (s(g2) * n2_245 * n2_234) mod 2;

      N2345 := (n2_234 * n2_235 * n2_245 * n2_345) mod 2;
      L12345 := (n2_123 * n2_134 * (1-n2_125) * (1-n2_145)
                + n2_134 * n2_145 * (1-n2_123) * (1-n2_125)
                + (1-n2_123) * (1-n2_125) * (1-n2_134) * (1-n2_145)) mod 2;
      a4t := a4 + N2345 * (1-L12345) * b4;
      b4t := b4 + N2345 * (L12345-1) * b4;

      o5sym := 1/2 * (s(g1) * a4t + w(g1, g2*g3) * a4t + w(g1, g2) * b4t);

      t5 := ExtData@(O5gamma@, s(g1*g2), s(g1), w(g1*g2, g3), w(g1, g2*g3), w(g1, g2),
        n2(g1, g2), n2(g1, g2*g3), n2(g1, g2*g3*g4), n2(g1, g2*g3*g4*g5),
        n2(g1*g2, g3), n2(g1*g2, g3*g4), n2(g1*g2, g3*g4*g5),
        n2(g1*g2*g3, g4), n2(g1*g2*g3, g4*g5), n2(g1*g2*g3*g4, g5));

      return o5sym + t5;
    end;
  end);

  SptSetInstallCoboundary(ss, 2, 3, 1, function(n3, dn3)
    local c5, coeff;
    coeff := spectrum[1+1];

    c5 := AddInhomoCochain@(Cup0@(2, 3, coeff, w, n3), Cup1@(3, 3, coeff, n3, n3));
    if dn3 <> ZeroCocycle@ then
      c5 := AddInhomoCochain@(c5, Cup2@(4, 3, coeff, dn3, n3));
    fi;
    return ScaleInhomoCochain@(1/2, c5);

    # return function(g1, g2, g3, g4, g5)
    #   local o5, n3c1n3, n3c2dn3;
    #   # o5 = 1/2 * (w2 u n3 + n3 u1 n3).
    #   # we are again ignoring the G-actions because Z2 can only have a trivial G-action.
    #   o5 := 1/2 * w(g1, g2) * n3(g3, g4, g5);
    #   n3c1n3 := n3(g1*g2*g3, g4, g5) * n3(g1, g2, g3);
    #   n3c1n3 := n3c1n3 + n3(g1, g2*g3*g4, g5) * n3(g2, g3, g4);
    #   n3c1n3 := n3c1n3 + n3(g1, g2, g3*g4*g5) * n3(g3, g4, g5);
    #   o5 := o5 + 1/2 * n3c1n3;
    #   if dn3 <> ZeroCocycle@ then
    #     n3c2dn3 := n3(g1, g2, g3) * dn3(g1, g2*g3, g4, g5) - n3(g1*g2, g3, g4) * dn3(g1, g2, g3*g4, g5) + n3(g1*g2*g3, g4, g5) * dn3(g1, g2, g3, g4*g5)
    #       + n3(g1, g2, g3) * dn3(g2, g3, g4, g5) + n3(g1, g2*g3, g4) * dn3(g2, g3, g4, g5);
    #     o5 := o5 + 1/2 * n3c2dn3;

    #     # 1/2w2(013)dn3(12345)
    #     o5 := o5 + 1/2 * w(g1, g2*g3) * dn3(g2, g3, g4, g5);

    #     # 1/2w2(023)[dn3(01245) + dn3(01235) + dn3(01234)]
    #     o5 := o5 + 1/2 * w(g1*g2, g3) * (dn3(g1, g2, g3*g4, g5)
    #       + dn3(g1, g2, g3, g4*g5) + dn3(g1, g2, g3, g4));

    #     # 1/2dn3(02345)dn3(01235)
    #     o5 := o5 + 1/2 * dn3(g1*g2, g3, g4, g5) * dn3(g1, g2, g3, g4*g5);
    #     # 1/4dn3(01245)dn3(01234)
    #     o5 := o5 + 1/4 * (dn3(g1, g2, g3*g4, g5) * dn3(g1, g2, g3, g4) mod 2);
    #     # -1/4[dn3(12345)+dn3(02345)+dn3ð01345)]dn3(01235)
    #     o5 := o5 - 1/4 * ((dn3(g2, g3, g4, g5) + dn3(g1*g2, g3, g4, g5)
    #       + dn3(g1, g2*g3, g4, g5)) * dn3(g1, g2, g3, g4*g5) mod 2);
    #   fi;
    #   return o5;
    # end;
  end);

  SptSetInstallAddTwister(ss, 1, 1, {l1, l2} -> ZeroCocycle@);
    
  SptSetInstallAddTwister(ss, 2, 0,
    function(l1, l2)
      local n11, n12;
      n11 := l1[1+1];
      n12 := l2[1+1];
      return {g1, g2} -> 1/2 * n11(g1) * n12(g2);
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

  SptSetInstallAddTwister
    (ss, 3, 0, 
    function(l1, l2)
      local coeff, n11, n12, n21, n22, c3, t3, dn21, dn22, m2, N2;

      n11 := l1[1+1];
      n12 := l2[1+1];
      n21 := l1[2+1];
      n22 := l2[2+1];
      coeff := spectrum[0+1];

      dn21 := {g1, g2, g3} -> (s(g1) * n11(g2) * n11(g3) + w(g1, g2) * n11(g3));
      dn22 := {g1, g2, g3} -> (s(g1) * n12(g2) * n12(g3) + w(g1, g2) * n12(g3));
      m2 := {g1, g2} -> (n11(g1) * n12(g2) + s(g1) * n11(g2) * n12(g2));
      N2 := {g1, g2} -> (n21(g1, g2) + n22(g1, g2) + m2(g1, g2));

      # c3 := AddInhomoCochain@(Cup1@(2, 2, coeff, n22, n21), Cup2@(3, 2, coeff, dn22, n21));
      # c3 := AddInhomoCochain@(c3, Cup1@(2, 2, coeff, N2, m2));
      # c3 := AddInhomoCochain@(c3, Cup0@(1, 2, coeff, s, m2));
      # if n11 <> n12 and n21 <> n22 then
      #   c3 := AddInhomoCochain@(c3, Cup2@(3, 2, coeff,
      #     {g1, g2, g3} -> (s(g1) * (n11(g2)*n12(g3)-n12(g2)*n11(g3))),
      #     {g1, g2} -> (n21(g1, g2) + n22(g1, g2))));
      # fi;

      c3 := AddInhomoCochain@(Cup1@(2, 2, coeff, n22, n21), Cup2@(3, 2, coeff, dn22, n21));
      c3 := AddInhomoCochain@(c3, Cup2@(2, 3, coeff, n22, dn21));
      c3 := AddInhomoCochain@(c3, Cup2@(2, 3, coeff, n21, dn22));
      c3 := AddInhomoCochain@(c3, Cup1@(2, 2, coeff, m2, N2));
      c3 := AddInhomoCochain@(c3, Cup2@(2, 3, coeff, m2, InhomoCoboundary@(coeff, N2)));
      c3 := AddInhomoCochain@(c3, Cup2@(3, 2, coeff, AddInhomoCochain@(dn21, dn22), m2));

      t3 := function(g1, g2, g3)
        local g03;
        g03 := g1*g2*g3;
        return ExtData@(AddTwister2DTable@,
          n11(g1), n11(g03), n11(g2),
          n12(g1), n12(g03), n12(g2),
          w(g1, g2), s(g1), s(g2));
      end;

      return {g1, g2, g3} -> (1/2*c3(g1, g2, g3) + t3(g1, g2, g3));
    end);

    # place holders for twisters in (3+1)D
    SptSetInstallAddTwister(ss, 1, 3, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 2, 2, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 3, 1, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 4, 0,
    function(l1, l2)
      local coeff, n31, n32;

      # Assert(0, l1[2+1] = ZeroCocycle@ or l2[2+1] = ZeroCocycle@);
      # Assert(0, l1[1+1] = ZeroCocycle@ or l2[1+1] = ZeroCocycle@);

      coeff := spectrum[1+1];
      n31 := l1[3+1];
      n32 := l2[3+1];

      return ScaleInhomoCochain@(1/2, Cup2@(3, 3, coeff, n31, n32));
    end);

    # place holders for twisters in (4+1)D
    SptSetInstallAddTwister(ss, 1, 4, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 2, 3, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 3, 2, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 4, 1, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 5, 0,
    function(l1, l2)
      local coeff, n41, n42;

      # Assert(0, l1[3+1] = ZeroCocycle@ or l2[3+1] = ZeroCocycle@);
      # Assert(0, l1[2+1] = ZeroCocycle@ or l2[2+1] = ZeroCocycle@);

      coeff := spectrum[1+1];
      n41 := l1[4+1];
      n42 := l2[4+1];

      return ScaleInhomoCochain@(1/2, Cup3@(4, 4, coeff, n41, n42));
    end);
    

  return ss;
end);
