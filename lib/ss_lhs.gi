InstallGlobalFunction
    (LyndonHochschildSerreSpecSeq,
    function(R, auMap, w, Ncplx)
        local spectrum, Q, dmax;
        Q := GroupOfResolution(R);
        dmax := Length(Ncplx!.hapResolution) - 1;
        for i in [0..dmax] do
            spectrum[i+1] := SptSetCoefficientCohomologyModule(Ncplx, i, Q, auMap);
        od;

        ss := SptSetSpecSeqVanilla(R, spectrum);

        s := g -> (1 - (g^auMap)[1][1]) / 2;

        SptSetInstallCoboundary(ss, 2, 1, 1, 
        function(n1, dn1)
        end);
        
    end);
