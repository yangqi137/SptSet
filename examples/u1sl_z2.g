LoadPackage("SptSet");

G := CyclicGroup(2);;
R := ResolutionFiniteGroup(G, 7);
f1 := GeneratorsOfGroup(G)[1];;
au := SptSetTrivialGroupAction(G);;
rho := GroupHomomorphismByImagesNC(G, GL(1, Integers),
  [f1], [ [[-1]] ]);;
nu := function(g1, g2)
  if g1 = f1 and g2 = f1 then
    return 1/2;
  else
    return 0;
  fi;
end;;
SS := U1SLSpecSeq(R, rho, au, nu);;
E231 := SptSetSpecSeqComponent(SS, 2, 3, 1);
SptSetFpZModuleCanonicalForm(E231);
Display(E231);
E331 := SptSetSpecSeqComponent(SS, 3, 3, 1);
SptSetFpZModuleCanonicalForm(E331);
Display(E331);
