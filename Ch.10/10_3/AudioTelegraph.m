function [TelegraphSound, count] = AudioTelegraph(telegraphCode, waveformType)
%   AUDIOTELEGRAPH AUDIOTELEGRAPH generates audio from Telegraph code using tones.
%    Each character consists of 5 data bits, preceeded by one start bit (0) 
%    with same duration as data bits and succeeded by one stop bit (1) with 
%    longer duration (in ITA2 protocol with two stop bits (11)).
%    the Mark (bit 1) and Space (bit 0) states can be represented by two 
%    audio tones of which the frequencies do not share a comman factor. 
%    standard fre5quencies for modern equipments:
%    1500 Hz for '1' (mark), 1670 Hz for '0' (space) (170 Hz shift).
%    This method is known as Audio Frequency Shift Keying, or AFSK.     
%
%   Inputs:
%       telegraphCode : A string of bits like '010011001100...'
%       waveformType  : 'sin', 'square', or 'sawtooth'
%
%   Outputs:
%       TelegraphSound : Audio waveform vector
%       count          : Number of bits processed

    fs = 8000;            % Sampling frequency
    bitDuration = 0.02;   % Duration of each bit (in seconds)
    pauseDuration = 0.5; % Short pause between bits

    % Time vectors
    t = 0:1/fs:bitDuration;
    pauseBit = zeros(1, round(pauseDuration * fs));

    % Standard frequencies
    freq0 = 1670;  % Space (bit 0)
    freq1 = 1500;  % Mark  (bit 1)

    % Generate basic waveforms
    switch waveformType
        case "sin"
            bit0 = sin(2 * pi * freq0 * t);
            bit1 = sin(2 * pi * freq1 * t);
        case "square"
            bit0 = square(2 * pi * freq0 * t);
            bit1 = square(2 * pi * freq1 * t);
        otherwise % sawtooth
            bit0 = sawtooth(2 * pi * freq0 * t);
            bit1 = sawtooth(2 * pi * freq1 * t);
    end

    % Construct signal
    TelegraphSound = [];
    count = 0;

    for i = 1:length(telegraphCode)
        bit = telegraphCode(i);
        if bit == '0'
            TelegraphSound = [TelegraphSound, bit0, pauseBit];
            count = count + 1;
        elseif bit == '1'
            TelegraphSound = [TelegraphSound, bit1, pauseBit];
            count = count + 1;
        end
    end
end
