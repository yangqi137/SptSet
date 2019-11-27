gap> START_TEST( "arbitrary identifier string" );
gap> a := [ [3, 1, 5], [2, 2, 4] ];
[ [ 3, 1, 5 ], [ 2, 2, 4 ] ]
gap> a := [ [3, 1, 5], [2, 2, 4] ];;
gap> BarResolutionHomotopy@SptSet(1, 10, 2, a);;
gap> a;
[ [ 30, 1, 2, 5 ], [ 20, 1, 4, 4 ] ]
gap> BarResolutionBoundary@SptSet(1, [2,3,4,5]);
[ [ 1, 2, 3, 4, 5 ], [ -1, 1, 6, 4, 5 ], [ 1, 1, 2, 12, 5 ], 
  [ -1, 1, 2, 3, 20 ], [ 1, 1, 2, 3, 4 ] ]
gap> G := CyclicGroup(3);;
gap> SetNameObject(GeneratorsOfGroup(G)[1], "a");
gap> GeneratorsOfGroup(G);
[ a ]
gap> R := ResolutionFiniteGroup(G, 6);;
gap> STOP_TEST( "brm_mine.tst" );
