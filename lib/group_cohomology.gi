DeclareRepresentation(
  "IsSptSetCochainComplexRep",
  IsCategoryOfSptSetCochainComplex and IsComponentObjectRep,
  ["modulesCache", "derivsCache", "hapResolution", "mod_n", "gAction"]
);

BindGlobal(
  "TheFamilyOfSptSetCochainComplexes",
  NewFamily("TheFamilyOfSptSetCochainComplexes")
);
BindGlobal(
  "TheTypeSptSetCochainComplex",
  NewType(TheFamilyOfSptSetCochainComplexes, IsSptSetCochainComplexRep)
);

InstallMethod(SptSetHomToIntegralModule,
  "construct a cochain complex by homing to Z with an action",
  [IsHapResolution, IsGeneralMapping],
  function(resolution, gAction)
    return Objectify(TheTypeSptSetCochainComplex,
      rec(modulesCache := [], derivsCache := [],
        hapResolution := resolution, mod_n := 0, gAction := gAction));
  end);

InstallMethod(SptSetHomToIntegerModN,
  "construct a cochain complex by homing to Z_n",
  [IsHapResolution, IsInt],
  function(resolution, n)
    local gAction;
    gAction := SptSetTrivialGroupAction(GroupOfResolution(resolution));
    return Objectify(TheTypeSptSetCochainComplex,
      rec(modulesCache := [], derivsCache := [],
        hapResolution := resolution, mod_n := n, gAction := gAction)
    );
  end);

InstallMethod(SptSetCohomology,
  "compute the k-th cohomology module of a cochain complex",
  [IsSptSetCochainComplexRep, IsInt],
  function(cc, k)
    local dkm1, dk, h;
    dk := SptSetCochainComplexDerivative(cc, k);
    if k = 0 then
      h := SptSetKernelModule(dk);
    else
      dkm1 := SptSetCochainComplexDerivative(cc, k-1);
      h := SptSetHomologyModule(dkm1, dk);
    fi;
    SptSetFpZModuleCanonicalForm(h);
    return h;
  end);

InstallMethod(SptSetCochainComplexModule,
  "obtain degree-k module",
  [IsSptSetCochainComplexRep, IsInt],
  function(cc, k)
    if not IsBound(cc!.modulesCache[k+1]) then
      cc!.modulesCache[k+1] :=
        SptSetCochainModule(cc!.hapResolution, k, cc!.mod_n);
    fi;
    return cc!.modulesCache[k+1];
  end);

InstallMethod(SptSetCochainComplexDerivative,
  "obtain d^k",
  [IsSptSetCochainComplexRep, IsInt],
  function(cc, k)
    local domain, codomain;
    if not IsBound(cc!.derivsCache[k+1]) then
      domain := SptSetCochainComplexModule(cc, k);
      codomain := SptSetCochainComplexModule(cc, k+1);
      cc!.derivsCache[k+1] :=
        SptSetCoboundaryMap(domain, codomain,
          cc!.hapResolution, k, cc!.gAction);
    fi;
    return cc!.derivsCache[k+1];
  end);
