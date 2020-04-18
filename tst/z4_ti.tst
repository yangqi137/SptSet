gap> START_TEST( "insulator-spt classification basic test" );
gap> G := CyclicGroup(4);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> utAct := SptSetTrivialGroupAction(G);;
gap> ss := InsulatorSPTSpecSeq(R, utAct, utAct, ZeroCocycle@SptSet);;
gap> InsulatorSPTLayersVerbose(ss, 2);;
Empty:
<ZL-Module []>
<ZL-Module []>
<ZL-Module []>
Complex fermion:
<ZL-Module with torsions [ 4 ]>
<ZL-Module with torsions [ 4 ]>
Bosonic:
<ZL-Module with torsions [ 4 ]>
<ZL-Module with torsions [ 4 ]>
<ZL-Module with torsions [ 4 ]>
gap> z2tAct := GroupHomomorphismByImagesNC(G, GL(1, Integers),
>   GeneratorsOfGroup(G), [ [[-1]], [[1]] ]);;
gap> ss := InsulatorSPTSpecSeq(R, z2tAct, utAct, ZeroCocycle@SptSet);;
gap> InsulatorSPTLayersVerbose(ss, 2);;
Empty:
<ZL-Module []>
<ZL-Module []>
<ZL-Module []>
Complex fermion:
<ZL-Module with torsions [ 4 ]>
<ZL-Module with torsions [ 2 ]>
Bosonic:
<ZL-Module []>
<ZL-Module []>
<ZL-Module []>
gap> STOP_TEST( "z4_ez.tst" );
