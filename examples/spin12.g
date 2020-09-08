LoadPackage("SptSet");
G := SpaceGroupBBNWZ(2, 13);
gs := GeneratorsOfGroup(G);
oproj := PtGrp2DOrthogonalMatrix@SptSet(13);

Display(gs[1]);
g := Inverse(oproj)*gs[1]*oproj;
Display(g);
Display(PtGrp2DProjRep@SptSet(g));
Display(gs[1]^2);
g := Inverse(oproj)*gs[1]^2*oproj;
Display(g);
Display(PtGrp2DProjRep@SptSet(g));

w := Spin12Factor(2, 13);
Display(w(gs[1], gs[1]));
