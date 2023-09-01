LoadPackage("SptSet");

D4 := DihedralGroup(8);
gens := GeneratorsOfGroup(D4);
b := gens[1];
a := gens[2];
Z4 := Group([a]);
Z2 := Group([b]);
R := ResolutionFiniteGroup(Z4, 6);
f := GroupHomomorphismByImagesNC(Z4, GL(1, Integers), [a], [ [[+1]] ]);
u1 := SptSetCoefficientU1(f);
cplx := SptSetCochainComplex(R, u1);
Display(SptSetCohomology(cplx, 1));
Display(SptSetCohomology(cplx, 2));
Display(SptSetCohomology(cplx, 3));

coeff := SptSetCoefficientCohomologyModule(cplx, 1, Z2, SptSetTrivialGroupAction(Z2));
Display(coeff!.gAction);

RQ := ResolutionFiniteGroup(Z2, 6);
cplxQ := SptSetCochainComplex(RQ, coeff);
C2 := SptSetCochainComplexModule(cplxQ, 2);
Display(C2);
C3 := SptSetCochainComplexModule(cplxQ, 3);
Display(C3);

d2 := SptSetCochainComplexDerivative(cplxQ, 2);
Display(d2);




