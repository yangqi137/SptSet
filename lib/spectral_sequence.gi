DeclareRepresentation(
  "IsSptSetSpecSeqRep",
  IsCategoryOfSptSetSpecSeq and IsComponentObjectRep,
  ["modulePages", "derivPages"]
);

#DeclareRepresentation(
#  "IsFermionSPTSpecSeqRep",
#  IsSptSetSpecSeqRep,
#  ["resolution", "auMap", "omega2"]
#);

BindGlobal(
  "TheFamilyOfSptSetSpecSeqs",
  NewFamily("TheFamilyOfSpecSeqs")
);

InstallMethod(SptSetSpecSeqComponent,
  "Return the component Epqr from the cache or build it",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    if r<0 or p<0 or q<0 then
      return SptSetSpecSeqBuildComponent(ss, r, p, q);
    fi;
    if not IsBound(ss!.modulePages[r+1]) then
      ss!.modulePages[r+1] := [];
    fi;
    if not IsBound(ss!.modulePages[r+1][p+1]) then
      ss!.modulePages[r+1][p+1] := [];
    fi;
    if not IsBound(ss!.modulePages[r+1][p+1][q+1]) then
      ss!.modulePages[r+1][p+1][q+1]
        := SptSetSpecSeqBuildComponent(ss, r, p, q);
    fi;
    return ss!.modulePages[r+1][p+1][q+1];
  end);

InstallMethod(SptSetSpecSeqDerivative,
  "Return the derivative from the cache or build it",
  [IsCategoryOfSptSetSpecSeq, IsInt, IsInt, IsInt],
  function(ss, r, p, q)
    if r<0 or p<0 or q<0 then
      return SptSetSpecSeqBuildDerivative(ss, r, p, q);
    fi;
    if not IsBound(ss!.derivPages[r+1]) then
      ss!.derivPages[r+1] := [];
    fi;
    if not IsBound(ss!.derivPages[r+1][p+1]) then
      ss!.derivPages[r+1][p+1] := [];
    fi;
    if not IsBound(ss!.derivPages[r+1][p+1][q+1]) then
      ss!.derivPages[r+1][p+1][q+1]
        := SptSetSpecSeqBuildDerivative(ss, r, p, q);
    fi;
    return ss!.derivPages[r+1][p+1][q+1];
  end);

#InstallGlobalFunction(InstallSptSetSpecSeqDerivative,
#  function(str, r, p, q, type, fInhom)
#    local f;
#    f := function(a, ss)
#      if TypeObj(ss) <> type then
#        return fail;
#      fi;
#    end;
#  end);
