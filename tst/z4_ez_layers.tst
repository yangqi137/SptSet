gap> START_TEST( "arbitrary identifier string" );
gap> G := CyclicGroup(4);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> utAct := SptSetTrivialGroupAction(G);;
gap> ss := FermionEZSPTSpecSeq(R, utAct);;
gap> layers := FermionSPTLayers(ss, 2);;
gap> Length(layers);
3
gap> layers[1];
<ZL-Module with torsions [ 2 ]>
gap> layers[2];
<ZL-Module with torsions [ 2 ]>
gap> layers[3];
<ZL-Module with torsions [ 4 ]>
gap> z2tAct := GroupHomomorphismByImagesNC(G, GL(1, Integers),
>   GeneratorsOfGroup(G), [ [[-1]], [[1]] ]);;
gap> ss := FermionEZSPTSpecSeq(R, z2tAct);;
gap> layers := FermionSPTLayers(ss, 2);;
gap> Length(layers);
3
gap> layers[1];
<ZL-Module with torsions [ 2 ]>
gap> layers[2];
<ZL-Module []>
gap> layers[3];
<ZL-Module []>
gap> STOP_TEST( "z4_ez_layers.tst" );
