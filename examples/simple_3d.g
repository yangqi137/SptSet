LoadPackage("SptSet");
#G := Group([(1,2,3,4), (5,6)]);
#G := Group([(1,2,3,4,5,6,7,8), (9,10)]);
G := Group([(1,2,3,4), (5,6,7,8)]);
R := ResolutionFiniteGroup(G, 8);
utAct := SptSetTrivialGroupAction(G);;
SS := FermionEZSPTSpecSeq(R, utAct);
FermionEZSPTLayersVerbose(SS, 3);
