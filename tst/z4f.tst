gap> START_TEST( "Z4f test" );
gap> G := CyclicGroup(2);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> utAct := SptSetTrivialGroupAction(G);;
gap> f1 := GeneratorsOfGroup(G)[1];;
gap> w := function(g1, g2) if g1=f1 and g2=f1 then return 1; else return 0;fi;end;;
gap> ss := FermionSPTSpecSeq(R, utAct, w);;
gap> FermionSPTLayersVerbose(ss, 2);;
Majorana:
<ZL-Module with torsions [ 2 ]>
<ZL-Module []>
<ZL-Module []>
Complex fermion:
<ZL-Module with torsions [ 2 ]>
<ZL-Module []>
Bosonic:
<ZL-Module with torsions [ 2 ]>
<ZL-Module []>
<ZL-Module []>
gap> STOP_TEST( "z4f.tst" );
