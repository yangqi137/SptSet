DeclareRepresentation(
  "IsSptSetCochainComplexRep",
  IsCategoryOfSptSetCochainComplex and IsComponentObjectRep,
  ["modulesCache", "derivsCache", "hapResolution", "coeff",
   "barResMap", "cohomologyCache"]
);

BindGlobal(
  "TheFamilyOfSptSetCochainComplexes",
  NewFamily("TheFamilyOfSptSetCochainComplexes")
);
BindGlobal(
  "TheTypeSptSetCochainComplex",
  NewType(TheFamilyOfSptSetCochainComplexes, IsSptSetCochainComplexRep)
);

InstallMethod(SptSetCochainComplex,
  "construct a cochain complex with coefficient",
  [IsHapResolution, IsCategoryOfSptSetCoefficient],
  function(R, M)
    local cocc;
    cocc := rec();
    cocc.modulesCache := [];
    cocc.derivsCache := [];
    cocc.cohomologyCache := [];
    cocc.hapResolution := R;
    cocc.coeff := M;
    return Objectify(TheTypeSptSetCochainComplex, cocc);
  end)
;

InstallMethod(SptSetCohomology,
  "compute the k-th cohomology module of a cochain complex",
  [IsSptSetCochainComplexRep, IsInt],
  function(cc, k)
    local dkm1, dk, h;
    if not IsBound(cc!.cohomologyCache[k+1]) then
      dk := SptSetCochainComplexDerivative(cc, k);
      if k = 0 then
        h := SptSetKernelModule(dk);
      else
        dkm1 := SptSetCochainComplexDerivative(cc, k-1);
        h := SptSetHomologyModule(dkm1, dk);
      fi;
      SptSetFpZModuleCanonicalForm(h);
      cc!.cohomologyCache[k+1] := h;
    fi;
    return cc!.cohomologyCache[k+1];
  end);

InstallMethod(SptSetCochainComplexModule,
  "obtain degree-k module",
  [IsSptSetCochainComplexRep, IsInt],
  function(cc, k)
    if not IsBound(cc!.modulesCache[k+1]) then
      cc!.modulesCache[k+1] :=
        SptSetCochainModule(cc!.hapResolution, k, cc!.coeff);
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
          cc!.hapResolution, k, cc!.coeff);
    fi;
    return cc!.derivsCache[k+1];
  end);

InstallMethod(SptSetShowCohomologyClass,
"print the cohomology class",
[IsSptSetCochainComplexRep, IsInt, IsPosInt],
function(cc, k, i)
  local h, v, brm, n, j, bword;
  h := SptSetCohomology(cc, k);
  v := h!.generators[i];
  if not IsBound(cc!.barResMap) then
    cc!.barResMap := SptSetBarResolutionMap(cc!.hapResolution);
  fi;
  brm := cc!.barResMap;
  n := Length(v);
  for j in [1..n] do
    bword := SptSetMapToBarWord(brm, k, j);
    PrintFormatted("{} = {}", bword, v[j]);
  od;
end);
