LoadPackage("SptSet");

G := Group([(1,2,3,4), (5,6)]);
R := ResolutionFiniteGroup(G, 7);

f := GroupHomomorphismByImagesNC(G, GL(1, Integers), [(1,2,3,4), (5,6)], [ [[1]], [[-1]] ]);

w := function(g1, g2)
    if 5 ^ g1 = 6 then
        return (1 - (g2^f)[1][1])/2;
    else
        return 0;
    fi;
end;

SSG := FermionSPTSpecSeq(R, f, w);
FermionSPTLayersVerbose(SSG, 3);
layers := FermionSPTLayers(SSG, 3);
Display("Layers: ");
Display(layers);

M := SptSetSpecSeqResult(SSG, 4, [2,3,4]);
SptSetFpZModuleCanonicalForm(M);
Display(M);

H := Group([(5,6)]);
fHG := GroupHomomorphismByImages(H, G, [(5, 6)], [(5, 6)]);
fH := GroupHomomorphismByImagesNC(H, GL(1, Integers), [(5, 6)], [ [[-1]] ]);

RH := ResolutionFiniteGroup(H, 7);
SSH := FermionSPTSpecSeq(RH, fH, w);
FermionSPTLayersVerbose(SSH, 3);
MH := SptSetSpecSeqResult(SSH, 4, [2,3,4]);
SptSetFpZModuleCanonicalForm(MH);
Display(MH);

cl := SptSetSpecSeqModuleVectorToClass(M, M!.generators[1]);
cch := SptSetMapSpecSeqCochainByGroupHomomorphism(cl!.cochain, SSH, fHG);
clh := SptSetSpecSeqClassFromCochainNC(cch);

SptSetPurifySpecSeqClass(clh);
Display(LeadingLayer(clh));

SptSetSpecSeqModuleClassToLeadingVector(M, SptSetSpecSeqModuleVectorToClass(M, [0, 0, 0, 0, 1, 1]));