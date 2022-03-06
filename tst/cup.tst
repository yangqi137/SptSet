gap> START_TEST( "testing cup products" );
gap> x := (1,2,3,4);;
gap> G := Group([x]);;
gap> gAct := SptSetTrivialGroupAction(G);;
gap> Z0 := SptSetCoefficientZn(0, gAct);;
gap> f11 := function(g1, g2)
> if g1 = x and g2 = x then return 1; fi;
> return 0;
> end;;
gap> f22 := function(g1, g2)
> if g1 = x^2 and g2 = x^2 then return 2; fi;
> return 0;
> end;;
gap> f21 := function(g1, g2)
> if g1 = x^2 and g2 = x then return 1; fi;
> return 0;
> end;;
gap> f12 := function(g1, g2)
> if g1 = x and g2 = x^2 then return 1; fi;
> return 0;
> end;;
gap> Cup0@SptSet(2, 2, Z0, f11, f22)(x, x, x^2, x^2);
2
gap> Cup0@SptSet(2, 2, Z0, f22, f11)(x, x, x^2, x^2);
0
gap> Cup1@SptSet(2, 2, Z0, f21, f11)(x, x, x);
1
gap> Cup1@SptSet(2, 2, Z0, f12, f11)(x, x, x);
-1
gap> STOP_TEST( "cup.tst" );
