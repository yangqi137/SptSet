gap> START_TEST( "Z8f test" );
gap> G := CyclicGroup(4);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> utAct := SptSetTrivialGroupAction(G);;
gap> brm := SptSetBarResolutionMap(R);;
gap> z2c := SptSetCoefficientZn(2, utAct);;
gap> w := SptSetMapToBarCocycle(brm, 2, z2c, [1]);;
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
<ZL-Module with torsions [ 4 ]>
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
gap> STOP_TEST( "z8f.tst" );
