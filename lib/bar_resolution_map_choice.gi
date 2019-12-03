InstallMethod(SptSetBarResolutionMap,
"create a map to/from the bar resolution",
[IsHapResolution],
function(R)
  local imp;
  if ValueOption("BarResMapChoice") = "HAP" then
    imp := IsSptSetBarResMapHapRep;
  elif ValueOption("BarResMapChoice") = "debug" then
    imp := IsSptSetBarResMapDebugRep;
  else
    imp := IsSptSetBarResMapMineRep;
  fi;
  return SptSetConstructBarResMap(imp, R);
end);
