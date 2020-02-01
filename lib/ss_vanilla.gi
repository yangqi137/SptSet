DeclareRepresentation(
  "IsSptSetSpecSeqVanillaRep",
  IsSptSetSpecSeqRep,
  ["resolution", "brMap", "spectrum", "bdry", "addTwister", "cochainTypes"]
);

BindGlobal(
  "TheTypeSptSetVanillaSpecSeq",
  NewType(TheFamilyOfSptSetSpecSeqs, IsSptSetSpecSeqVanillaRep)
);

#ZeroCocycle@ := {arg...} -> 0;

InstallMethod(SptSetSpecSeqVanilla,
  "Construct a spectral sequence with a spectrum",
  [IsHapResolution, IsList],
  function(resolution, spectrum)
    return Objectify(TheTypeSptSetVanillaSpecSeq, rec(
      modulePages := [],
      derivPages := [],
      resolution := resolution,
      brMap := SptSetBarResolutionMap(resolution),
      spectrum := spectrum,
      bdry := [],
      addTwister := [],
      cochainTypes := []));
  end);

InstallMethod(SptSetInstallCoboundary,
  "Install raw derivative of a spectral sequence",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsInt, IsFunction],
  function(ss, r, p, q, f)
    if not IsBound(ss!.bdry[r+1]) then
      ss!.bdry[r+1] := [];
    fi;
    if not IsBound(ss!.bdry[r+1][p+1]) then
      ss!.bdry[r+1][p+1] := [];
    fi;
    ss!.bdry[r+1][p+1][q+1] := f;
  end);

InstallMethod(SptSetInstallAddTwister,
  "Install add twister of a spectral sequence",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsFunction],
  function(ss, p, q, A)
      if not IsBound(ss!.addTwister[p+1]) then
          ss!.addTwister[p+1] := [];
      fi;
      ss!.addTwister[p+1][q+1] := f;
  end);

InstallMethod(SptSetSpecSeqBuildComponent,
  "build E^pq_r",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    local phi, psi;
    #if r=3 and p=1 and q=2 then
    #  Error("haha");
    #fi;
    if p < 0 or q < 0 then
      return SptSetZeroModule();
    fi;
    if not IsBound(ss!.spectrum[q+1]) then
      return SptSetZeroModule();
    fi;
    if r < 1 then
      Display("the spectral sequence starts at the first page");
      return fail;
    elif r = 1 then
      return SptSetCochainModule(ss!.resolution,
        p, ss!.spectrum[q+1]);
    else
      #if p-(r-1) >= 0 and q+(r-1)-1 <= 3 then
        phi := SptSetSpecSeqDerivative(ss, r-1, p-(r-1), q+(r-1)-1);
      #else
      #  phi := 0;
      #fi;
      #if q - (r-1) +1 >= 0 then
        psi := SptSetSpecSeqDerivative(ss, r-1, p, q);
      #else
      #  psi := 0;
      #fi;
      #if phi <> 0 and psi <> 0 then
        return SptSetHomologyModule(phi, psi);
      #elif phi = 0 then
      #  return SptSetKernelModule(psi);
      #else
      #  return SptSetCokernelModule(phi);
      #fi;
    fi;
  end);

InstallMethod(SptSetSpecSeqBuildDerivative,
  "build d^pq_r",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    local M, N, m, n, fA, i, np_, opr_, dnp1_, dnp1, np1, np1_, opr;
    M := SptSetSpecSeqComponent(ss, r, p, q);
    N := SptSetSpecSeqComponent(ss, r, p+r, q-r+1);
    if SptSetFpZModuleIsZero(M) or SptSetFpZModuleIsZero(N) then
      return SptSetZeroMap(M, N);
    fi;

    if r = 1 then # First page: coboundary maps
      return SptSetCoboundaryMap(M, N,
        ss!.resolution, p, ss!.spectrum[q+1]);
    fi;
    m := Length(M!.generators);
    n := Length(N!.generators);
    fA := [];

    for i in [1..m] do
      np_ := SptSetMapToBarCocycle(ss!.brMap, p, ss!.spectrum[q+1],
        M!.generators[i]);
      if r = 2 then
        #opr_ := ss!.bdry[r+1][p+1][q+1](np_);
        opr_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
      elif r = 3 then
        dnp1_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
        dnp1 := SptSetMapFromBarCocycle(ss!.brMap,
          p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_);
        np1 := SptSetZLMapInverse(
          SptSetSpecSeqDerivative(ss, 1, p+1, q-1),
          dnp1);
        np1_ := SptSetSolveCocycleEq(ss!.brMap,
          p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_, np1);
        #opr_ := ss!.bdry[r+1][p+1][q+1](np_, dnp1_, np1_);
        opr_ := ss!.bdry[2+1][p+1+1][q-1+1](np1_, dnp1_);
      else
        Display(["d", r, "not implimented"]);
        return fail;
      fi;

      opr := SptSetMapFromBarCocycle(ss!.brMap,
        p+r, ss!.spectrum[q-r+1 +1], opr_);
      fA[i] := opr * N!.projection;
    od;

    #if fA = [] then
    #  fA := EmptyMatrix(0);
    #fi;
    return SptSetZLMapByImages(M, N, fA);

  end);

InstallGlobalFunction(SptSetSpecSeqCochainType,
function(ss, deg)
  local f;
  if not IsBound(ss!.cochainTypes[deg+1]) then
    f := NewFamily("SptSetSSCochainFamily");
    f!.specSeq := ss;
    f!.degree := deg;
    ss!.cochainTypes[deg+1] := NewType(f, IsSptSetSpecSeqCochainRep);
  fi;
  return ss!.cochainTypes[deg+1];
end);
