gap> START_TEST( "arbitrary identifier string" );
gap> a := [ [3, 1, 5], [2, 2, 4] ];
[ [ 3, 1, 5 ], [ 2, 2, 4 ] ]
gap> a := [ [3, 1, 5], [2, 2, 4] ];;
gap> BarResolutionHomotopy@SptSet(1, 10, 2, a);
[ [ 30, 1, 2, 5 ], [ 20, 1, 4, 4 ] ]
gap> BarResolutionBoundary@SptSet(1, [2,3,4]);
[ [ 1, 2, 3, 4 ], [ -1, 1, 6, 4 ], [ 1, 1, 2, 12 ], [ -1, 1, 2, 3 ] ]
gap> WordSimplify@SptSet([ [1, 2, 3], [2, 1, 4], [-3, 2, 3] ]);
[ [ 2, 1, 4 ], [ -2, 2, 3 ] ]
gap> G := CyclicGroup(3);;
gap> R := ResolutionFiniteGroup(G, 6);;
gap> SetNameObject(Identity(G), "id");;
gap> brm := SptSetConstructBarResMap(IsSptSetBarResMapMineRep, R);;
gap> SptSetMapFromBarWord(brm, 0, []);
[ [ 1, 1, 1 ] ]
gap> SptSetMapToBarWord(brm, 0, 1);
[ [ 1, id ] ]
gap> SptSetMapToBarWord(brm, 1, 1);
[ [ 1, id, f1 ] ]
gap> SptSetMapToBarWord(brm, 2, 1);
[ [ 1, id, f1^2, f1 ], [ 1, id, f1, f1 ] ]
gap> SptSetMapToBarWord(brm, 3, 1);
[ [ 1, id, f1, f1^2, f1 ], [ 1, id, f1, f1, f1 ] ]
gap> id := Identity(G);;
gap> f1 := GeneratorsOfGroup(G)[1];;
gap> SptSetMapFromBarWord(brm, 3, [f1, id, f1]);
[  ]
gap> SptSetMapFromBarWord(brm, 1, [f1]);
[ [ 1, 1, 1 ] ]
gap> SptSetMapFromBarWord(brm, 1, [f1^2]);
[ [ 1, 1, 2 ], [ 1, 1, 1 ] ]
gap> SptSetMapEquivBarWord(brm, []);
[  ]
gap> SptSetMapEquivBarWord(brm, [id]);
[  ]
gap> SptSetMapEquivBarWord(brm, [f1]);
[  ]
gap> SptSetMapEquivBarWord(brm, [f1^2]);
[ [ 1, id, f1, f1 ] ]
gap> SptSetMapEquivBarWord(brm, [f1, f1]);
[  ]
gap> SptSetMapEquivBarWord(brm, [f1^2, f1]);
[  ]
gap> SptSetMapEquivBarWord(brm, [f1, f1^2]);
[ [ -1, id, f1, f1, f1 ] ]
gap> SptSetMapEquivBarWord(brm, [f1^2, f1^2]);
[ [ -1, id, f1^2, f1, f1 ] ]
gap> STOP_TEST( "brm_mine.tst" );
