function demod = delta_mod_demod(mod_data, delta, f, fs)
%   DELTA_MOD_DEMOD Implements the demodulation process for a signal 
%    encoded using Delta Modulation. It takes in a binary modulated signal 
%    and reconstructs the original analog signal by applying an accumulator 
%    and a low-pass filter for interpolation.
%
%   Inputs:
%       mod_data: The binary modulated data (sequence of 0s and 1s).
%       delta: The step size used during the quantization process.
%       f: The frequency of the input analog signal and the cutoff frequency 
%        for the low-pass filter.(used for smoothing the reconstructed signal). 
%       fs: The sampling frequency of the signal.
%   Output:
%       demod: The reconstructed (demodulated) analog signal.
%
len = length(mod_data);
x_dem = zeros(1,len);

% conversion of encoded data to analog data
for i=2:len
    if mod_data(i) == 0
        e_hat = -delta;
    else
        e_hat = delta;
    end
    
    x_dem(i) = e_hat + x_dem(i-1);
end

%Interpolation using LPF
demod = lowpass(x_dem, f, fs);