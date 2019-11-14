gap> START_TEST( "arbitrary identifier string" );
gap> G := CyclicGroup(4);;
gap> gAct := SptSetTrivialGroupAction(G);;
gap> U1 := SptSetCoefficientU1(gAct);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> cocc := SptSetCochainComplex(R, U1);;
gap> SptSetCohomology(cocc, 1);
<ZL-Module with torsions [ 4 ]>
gap> SptSetCohomology(cocc, 2);
<ZL-Module []>
gap> SptSetCohomology(cocc, 3);
<ZL-Module with torsions [ 4 ]>
gap> STOP_TEST( "group_cohomology.tst" );
