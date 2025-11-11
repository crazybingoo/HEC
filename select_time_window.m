function Xseg = select_time_window(X1, startSec, endSec, fs)
% SELECT_TIME_WINDOW  Extract a time window from SEEG data.
%
%   Xseg = select_time_window(X1, startSec, endSec, fs)
%
%   INPUT
%       X1        - matrix (channels x time samples).
%       startSec  - start time (seconds).
%       endSec    - end time (seconds).
%       fs        - sampling frequency (Hz).
%
%   OUTPUT
%       Xseg      - matrix (channels x selected time samples).

    startIdx = floor(startSec * fs) + 1;
    endIdx   = floor(endSec   * fs);

    Xseg = X1(:, startIdx:endIdx);
end
