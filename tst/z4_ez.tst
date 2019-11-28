gap> START_TEST( "arbitrary identifier string" );
gap> G := CyclicGroup(4);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> utAct := SptSetTrivialGroupAction(G);;
gap> ss := FermionEZSPTSpecSeq(R, utAct);;
gap> FermionSPTLayersVerbose(ss);;
Majorana:
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
Complex fermion:
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
Bosonic:
<ZL-Module with torsions [ 4 ]>
gap> z2tAct := GroupHomomorphismByImagesNC(G, GL(1, Integers),
>   GeneratorsOfGroup(G), [ [[-1]], [[1]] ]);;
gap> ss := FermionEZSPTSpecSeq(R, z2tAct);;
gap> FermionSPTLayersVerbose(ss);;
Majorana:
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
<ZL-Module with torsions [ 2 ]>
Complex fermion:
<ZL-Module with torsions [ 2 ]>
<ZL-Module []>
Bosonic:
<ZL-Module []>
gap> STOP_TEST( "z4_ez.tst" );
