% function for Audio of Morse Code
function [MorseSound1, cnt1] =  AudioMorse(Mcode2, fun)
%   AUDIOMORSE takes coded string as Mcode2 and the function to modulate the
%    Signal with as fun. Fun can be one of each "sin", "squre" or "sawtooth"
%    For dots and dashs timeinterval is given in seconds
%   Returns:
%       MorseSound1: This is the generated audio signal corresponding to 
%        the Morse code. 
%       cnt1: This is a counter that tracks the number of Morse code 
%        elements (dots, dashes, spaces) processed during the function execution.
switch fun
    case "sin"
        DotTimeInterval = sin(1:2500);
        DashTimeInterval = sin(1:5800);
    case "square"
        DotTimeInterval = square(1:2500);
        DashTimeInterval = square(1:5800);
    otherwise
        DotTimeInterval = sawtooth(1:2500);
        DashTimeInterval = sawtooth(1:5800);
end
% Pause and spaces are set with zero, the intervals should remain
% Proportional to each other, unlike real morse scenario we are not 
% Interested to the exact intervals duration and it can change by
% Applicaiton
Pause = zeros(1,4000);

Space_hy_Pause = zeros(1,4500);
% Sound is Initialized by an empty array and counter as well with zero
MorseSound1 = [];

cnt1 = 0;
% For each case that one of dot, dash, slash or space been appeared, their
% Distinct signal is added to  the previous signal to prevent discontinuty
% After each alphabet a pause is added for better experience and detection
% Of the alphbet of the source
for x = Mcode2
  if x == '.'
    cnt1 = cnt1+1;
    MorseSound1 = [MorseSound1 DotTimeInterval Pause];
  elseif x == '-'
    cnt1 = cnt1+1;
    MorseSound1 = [MorseSound1 DashTimeInterval Pause];
  elseif x == ' ' 
    MorseSound1 = [MorseSound1 Space_hy_Pause];
  elseif x == '/'
    MorseSound1 = [MorseSound1 Space_hy_Pause Pause]; 
 end
end
end