LoadPackage("SptSet");
SetAssertionLevel(1);

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

Display("#10 in 3D");
G := SpaceGroupBBNWZ(3, 10);
gs := GeneratorsOfGroup(G);
c2 := gs[2];
m := gs[1];
w := Spin12Factor(3, 10);
Display(w(c2, c2));
#Display([w(c4, c4), w(c4^2, c4), w(c4^3, c4)]);
Display([w(m, m)]);

Display("#75 (P4) in 3D");
G := SpaceGroupBBNWZ(3, 75);
gs := GeneratorsOfGroup(G);
c4 := gs[1];
c2 := gs[2];
w := Spin12Factor(3, 10);
Display([w(c4, c4), w(c4^2, c4), w(c4^3, c4)]);
#Display(w(c4^2, c4));
Display([w(c2, c2)]);

Display("#168 (P6) in 3D");
G := SpaceGroupBBNWZ(3, 168); # P6
gs := GeneratorsOfGroup(G);
c2 := gs[1];
c3 := gs[2];
w := Spin12Factor(3, 168);
Display(["c2: ", w(c2, c2)]);
Display(["c3: ", w(c3, c3), w(c3^2, c3)]);
