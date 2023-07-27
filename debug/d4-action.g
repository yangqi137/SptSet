LoadPackage("SptSet");

D3 := DihedralGroup(6);
gens := GeneratorsOfGroup(D3);
b := gens[1];
a := gens[2];
Z3 := Group([a]);
Z2 := Group([b]);
R := ResolutionFiniteGroup(Z3, 6);
f := GroupHomomorphismByImagesNC(Z3, GL(1, Integers), [a], [ [[+1]] ]);
u1 := SptSetCoefficientU1(f);
cplx := SptSetCochainComplex(R, u1);
Display(SptSetCohomology(cplx, 1));
Display(SptSetCohomology(cplx, 2));
Display(SptSetCohomology(cplx, 3));

coeff := SptSetCoefficientCohomologyModule(cplx, 1, Z2);
Display(coeff!.gAction);


