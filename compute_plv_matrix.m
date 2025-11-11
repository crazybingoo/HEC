function plvMatrix = compute_plv_matrix(Xseg)
% COMPUTE_PLV_MATRIX  Compute PLV connectivity matrix.
%
%   plvMatrix = compute_plv_matrix(Xseg)
%
%   INPUT
%       Xseg      - matrix (channels x time).
%
%   OUTPUT
%       plvMatrix - dc x dc PLV matrix.

    [dc, ~] = size(Xseg);
    plvMatrix = zeros(dc, dc);

    for ch1 = 1:dc
        phase1 = angle(hilbert(Xseg(ch1, :)));
        for ch2 = 1:dc
            phase2 = angle(hilbert(Xseg(ch2, :)));
            phaseDiff = phase1 - phase2;
            plv = abs(mean(exp(1i * phaseDiff)));
            plvMatrix(ch1, ch2) = plv;
        end
    end
end
