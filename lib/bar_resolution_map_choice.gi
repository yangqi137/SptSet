InstallMethod(SptSetBarResolutionMap,
"create a map to/from the bar resolution",
[IsHapResolution],
function(R)
  local imp;
  if ValueOption("BarResMapChoice") = "HAP" then
    imp := IsSptSetBarResMapHapRep;
  else
    imp := IsSptSetBarResMapMineRep;
  fi;
  return SptSetConstructBarResMap(imp, R);
end);
