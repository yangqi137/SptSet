DeclareRepresentation(
  "IsSptSetSpecSeqVanillaRep",
  IsSptSetSpecSeqRep,
  ["resolution", "brMap", "spectrum", "bdry", "addTwister",
   "cochainTypes", "classTypes"]
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
      module2Pages := [],
      deriv2Pages := [],
      resolution := resolution,
      brMap := SptSetBarResolutionMap(resolution),
      spectrum := spectrum,
      bdry := [],
      addTwister := [],
      cochainTypes := [],
      classTypes := []));
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
      ss!.addTwister[p+1][q+1] := A;
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
      phi := SptSetSpecSeqDerivative(ss, r-1, p-(r-1), q+(r-1)-1);
#      psi := SptSetSpecSeqDerivative(ss, r-1, p, q);
      psi := SptSetSpecSeqDerivative2(ss, r-1, p, q);
      return SptSetHomologyModule(phi, psi);
    fi;
  end);

InstallMethod(SptSetSpecSeqBuildComponent2,
  "build tilde E^pq_r",
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
      phi := SptSetSpecSeqDerivative(ss, r-1, p-(r-1), q+(r-1)-1);
      return SptSetCokernelModule(phi);
    fi;
  end);

InstallMethod(SptSetSpecSeqBuildDerivative,
  "build d^pq_r",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    # local M, N, m, n, fA, i, np_, opr_, dnp1_, dnp1, np1, np1_, opr;
    local M, N, m, n, fA, i, np_, dnp, cl_dnp, opr_, opr;
    M := SptSetSpecSeqComponent(ss, r, p, q);
    N := SptSetSpecSeqComponent(ss, r, p+r, q-r+1);
    if SptSetFpZModuleIsZero(M) or SptSetFpZModuleIsZero(N) then
      return SptSetZeroMap(M, N);
    fi;

    if r = 1 then # First page: coboundary maps; no need to use inhomo cochains.
      return SptSetCoboundaryMap(M, N,
        ss!.resolution, p, ss!.spectrum[q+1]);
    fi;
    m := Length(M!.generators);
    n := Length(N!.generators);
    fA := [];

    for i in [1..m] do
      np_ := SptSetMapToBarCocycle(ss!.brMap, p, ss!.spectrum[q+1], M!.generators[i]);
      dnp := SptSetSpecSeqCoboundarySL(ss, p+q, p, np_);
      dnp!.layers[p+1 +1] := ZeroCocycle@; # d np_ must be a cocycle
      cl_dnp := SptSetSpecSeqClassFromCochainNC(dnp);
      PartialPurifySSClass@(cl_dnp, r, p+r-1);
      Assert(-1, LeadingLayer(cl_dnp) = p+r-1, "ASSERTION FAIL: obstruction does not vanish on the previous page.");
      opr_ := cl_dnp!.cochain!.layers[p+r +1];
      # if r = 2 then
      #   opr_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
      # elif r = 3 then
      #   dnp1_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
      #   dnp1 := SptSetMapFromBarCocycle(ss!.brMap,
      #     p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_);
      #   np1 := SptSetZLMapInverse(
      #     SptSetSpecSeqDerivative(ss, 1, p+1, q-1),
      #     dnp1);
      #   np1_ := SptSetSolveCocycleEq(ss!.brMap,
      #     p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_, np1);
      #   #opr_ := ss!.bdry[r+1][p+1][q+1](np_, dnp1_, np1_);
      #   opr_ := ss!.bdry[2+1][p+1+1][q-1+1](np1_, dnp1_);
      # else
      #   Display(["d", r, "not implimented"]);
      #   return fail;
      # fi;

      opr := SptSetMapFromBarCocycle(ss!.brMap,
        p+r, ss!.spectrum[q-r+1 +1], opr_);
      fA[i] := opr * N!.projection;
    od;

    #if fA = [] then
    #  fA := EmptyMatrix(0);
    #fi;
    return SptSetZLMapByImages(M, N, fA);

  end);

InstallMethod(SptSetSpecSeqBuildDerivative2,
  "build d^pq_r",
  [IsSptSetSpecSeqVanillaRep, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    #local M, N, m, n, fA, i, np_, opr_, dnp1_, dnp1, np1, np1_, opr;
    local M, N, m, n, fA, i, np_, dnp, cl_dnp, opr_, opr;
    M := SptSetSpecSeqComponent(ss, r, p, q);
    N := SptSetSpecSeqComponent2(ss, r, p+r, q-r+1);
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
      np_ := SptSetMapToBarCocycle(ss!.brMap, p, ss!.spectrum[q+1], M!.generators[i]);
      dnp := SptSetSpecSeqCoboundarySL(ss, p+q, p, np_);
      dnp!.layers[p+1 +1] := ZeroCocycle@; # d np_ must be a cocycle
      cl_dnp := SptSetSpecSeqClassFromCochainNC(dnp);
      PartialPurifySSClass@(cl_dnp, r, p+r-1);
      Assert(-1, LeadingLayer(cl_dnp) = p+r-1, "ASSERTION FAIL: obstruction does not vanish on the previous page.");
      opr_ := cl_dnp!.cochain!.layers[p+r +1];
      # if r = 2 then
      #   #opr_ := ss!.bdry[r+1][p+1][q+1](np_);
      #   opr_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
      # elif r = 3 then
      #   dnp1_ := ss!.bdry[2+1][p+1][q+1](np_, ZeroCocycle@);
      #   dnp1 := SptSetMapFromBarCocycle(ss!.brMap,
      #     p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_);
      #   np1 := SptSetZLMapInverse(
      #     SptSetSpecSeqDerivative(ss, 1, p+1, q-1),
      #     dnp1);
      #   np1_ := SptSetSolveCocycleEq(ss!.brMap,
      #     p+r-1, ss!.spectrum[q-(r-1)+1 +1], dnp1_, np1);
      #   #opr_ := ss!.bdry[r+1][p+1][q+1](np_, dnp1_, np1_);
      #   opr_ := ss!.bdry[2+1][p+1+1][q-1+1](np1_, dnp1_);
      # else
      #   Display(["d", r, "not implimented"]);
      #   return fail;
      # fi;

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

InstallGlobalFunction(SptSetSpecSeqClassType,
function(ss, deg)
  local f;
  if not IsBound(ss!.classTypes[deg+1]) then
    f := NewFamily("SptSetSSClassFamily");
    f!.specSeq := ss;
    f!.degree := deg;
    ss!.classTypes[deg+1] := NewType(f, IsSptSetSpecSeqClassRep);
  fi;
  return ss!.classTypes[deg+1];
end);
