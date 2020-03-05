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

    s := g -> (1-(g^auMap)[1][1])/2;

    SptSetInstallCoboundary(ss, 2, 1, 1,
    function(n1, dn1)
      return {g1, g2, g3} -> 0;
    end);

    SptSetInstallCoboundary(ss, 2, 0, 2,
    function(n0, dn0)
      return {g1, g2} -> 0;
    end);
    SptSetInstallCoboundary(ss, 3, 0, 2,
    function(n0, dn0)
      return {g1, g2, g3} -> 0;
    end);

    SptSetInstallCoboundary(ss, 2, 2, 1,
    function(n2, dn2)
      return function(g1, g2, g3, g4)
        local val;
        val := 1/2 * (n2(g1, g2) * n2(g3, g4) mod 2);
        if dn2 <> ZeroCocycle@ then
          val := val + 1/2 * ((n2(g1*g2*g3, g4) * dn2(g1, g2, g3)
            + n2(g1, g2*g3*g4) * dn2(g2, g3, g4)) mod 2);
          val := val + 1/2 * (dn2(g1, g2, g3*g4) * dn2(g1*g2, g3, g4) mod 2);
          val := val - 1/4 * (dn2(g1, g2, g3) * (1 - dn2(g1, g2, g3*g4)) mod 2);
        fi;
        return val;
      end;
    end);

    SptSetInstallCoboundary(ss, 2, 1, 2,
    function(n1, dn1)
      return {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3));
    end);
    SptSetInstallCoboundary(ss, 3, 1, 2,
    function(n1, dn1)
      return {g1, g2, g3, g4} -> 0;
    end);

    SptSetInstallCoboundary(ss, 2, 0, 3,
    function(n0, dn0)
      return {g1, g2} -> 0;
    end);
    SptSetInstallCoboundary(ss, 3, 0, 3,
    function(n0, dn0)
      return {g1, g2, g3} -> 0;
    end);
    SptSetInstallCoboundary(ss, 4, 0, 3,
    function(n0, dn0)
      return {g1, g2, g3, g4} -> 0;
    end);

    SptSetInstallCoboundary(ss, 2, 1, 3,
    function(n1, dn1)
      return {g1, g2, g3} -> (s(g1) * n1(g2) * n1(g3));
    end);
    SptSetInstallCoboundary(ss, 2, 2, 2,
    function(n2, dn2)
      return
      function(g1, g2, g3, g4)
        local n2n2, n2c1n2;
        # we are ignoring the G-action because Z2 can only have a trivial G-action.
        n2n2 := n2(g1, g2) * n2(g3, g4);
        #n2c1n2 := ??;
        #f c1 g (0123) = B[f(023),g(012)]−B[f(013),g(123)]
        #n2 c1 n2(g1, g2, g3) = n2(g1*g2, g3)n2(g1, g2) - n2(g1, g2*g3)n2(g2, g3);
        n2c1n2 := n2(g2*g3, g4) * n2(g2, g3) - n2(g2, g3*g4) * n2(g3, g4);
        # TODO: need to add dn2
        return n2n2 + s(g1) * n2c1n2;
      end;
    end);

    SptSetInstallAddTwister(ss,
      1, 2,
      function(l1, l2)
          return ZeroCocycle@;
      end);

    SptSetInstallAddTwister
        (ss, 2, 1,
         function(l1, l2)
             local n11, n12;
             n11 := l1[1+1];
             n12 := l2[1+1];
             if n11 = ZeroCocycle@ or n12 = ZeroCocycle@ then
               return ZeroCocycle@;
             fi;
             return Cup0@(1, 1, spectrum[2+1], n11, n12);
         end);
    SptSetInstallAddTwister
        (ss, 3, 0,
         function(l1, l2)
             local n11, n12, n21, n22;
             n11 := l1[1+1];
             n12 := l2[1+1];
             n21 := l1[2+1];
             n22 := l2[2+1];

             return ZeroCocycle@;
          end);
    # place holders for twisters in (3+1)D
    SptSetInstallAddTwister(ss, 1, 3, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 2, 2, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 3, 1, {l1, l2} -> ZeroCocycle@);
    SptSetInstallAddTwister(ss, 4, 0, {l1, l2} -> ZeroCocycle@);

    return ss;
  end);

InstallGlobalFunction(FermionSPTLayersVerbose,
function(ss, dim)
  local layerNames, p, q, rmax, r, Erpq;
  layerNames := ["Bosonic:", "Complex fermion:", "Majorana:", "p+ip:"];
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

InstallGlobalFunction(FermionSPTLayers,
function(ss, dim)
  local layers, p, q, rmax, E;
  layers := [];
  for p in [1..(dim+1)] do
    q := dim + 1 - p;
    if q >= 0 and q <= 3 then
      rmax := Maximum(q+2, p+1);
      E := SptSetSpecSeqComponent(ss, rmax, p, q);
      SptSetFpZModuleCanonicalForm(E);
      Add(layers, E);
    fi;
  od;
  return layers;
end);

#InstallGlobalFunction(FermionSPTLayersVerbose,
#function(ss)
#  local E212, E312, E412, E221, E321, E230;
#  Display("Majorana:");
#  E212 := SptSetSpecSeqComponent(ss, 2, 1, 2);
#  SptSetFpZModuleCanonicalForm(E212);
#  Display(E212);
#  E312 := SptSetSpecSeqComponent(ss, 3, 1, 2);
#  SptSetFpZModuleCanonicalForm(E312);
#  Display(E312);
#  E412 := SptSetSpecSeqComponent(ss, 4, 1, 2);
#  SptSetFpZModuleCanonicalForm(E412);
#  Display(E412);
#  Display("Complex fermion:");
#  E221 := SptSetSpecSeqComponent(ss, 2, 2, 1);
#  SptSetFpZModuleCanonicalForm(E221);
#  Display(E221);
#  E321 := SptSetSpecSeqComponent(ss, 3, 2, 1);
#  SptSetFpZModuleCanonicalForm(E321);
#  Display(E321);
#  Display("Bosonic:");
#  E230 := SptSetSpecSeqComponent(ss, 2, 3, 0);
#  SptSetFpZModuleCanonicalForm(E230);
#  Display(E230);

#  return [E412, E321, E230];
#end);
