InstallGlobalFunction
    (LyndonHochschildSerreSpecSeq,
    function(R, auMap, w, Ncplx)
        local spectrum, Q, dmax;
        Q := GroupOfResolution(R);
        dmax := Length(Ncplx!.hapResolution) - 1;
        for i in [0..dmax] do
            spectrum[i+1] := SptSetCoefficientCohomologyModule(Ncplx, i, Q, auMap);
        od;
        
    end);
