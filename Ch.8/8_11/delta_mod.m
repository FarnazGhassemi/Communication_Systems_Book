function [encoded, pred] = delta_mod(data, delta)
%   DELTA_MOD Implements a basic Delta Modulation algorithm. It encodes an 
%    input signal (data) into a binary sequence (encoded) and generates 
%    a predicted signal (pred) using a specified step size (delta).
%
%   Inputs:
%       data: The input signal (a 1D array) to be modulated.
%       delta: The step size used in the modulation process.
%   Outputs:
%       pred: The predicted signal that approximates the input signal.
%       encoded: A binary sequence representing the quantized signal; 
%        1 for positive steps (+delta) and 0 for negative steps (-delta).
%
len = length(data);
pred = zeros(1,len); % Predicted Signal
e_hat = zeros(1,len); % Quantized Error

for i=2:len
    %Error
    e_n = data(i) - pred(i-1);
    %Quantizer
    if (e_n >= 0)
        e_hat(i) = delta;
    else
        e_hat(i) = -delta;
    end
    %Accumulator
    pred(i) = pred(i-1) + e_hat(i);
end

%Encoded data --> 0 for -1 and 1 for +1
encoded = e_hat >= 0;