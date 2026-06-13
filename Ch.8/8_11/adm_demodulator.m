function [z] = adm_demodulator(y, delta, k, f, Fs)
%   ADM_DEMODULATOR Implements the Adaptive Delta Modulation (ADM) Demodulator, 
%    which reconstructs the analog signal from its binary modulated form 
%    using the Jayant Algorithm. It adapts the step size (delta) dynamically 
%    to improve signal reconstruction accuracy.
%
%   Inputs:
%       y: The binary modulated input signal (output of an ADM modulator).
%       delta: Initial step size for demodulation.
%       k: Multiplication factor for adjusting delta.
%       f: Cutoff frequency of the low-pass filter (also corresponds to 
%        the frequency of the input signal).
%       Fs: Sampling frequency.
%   Output:
%       z: Reconstructed analog signal.
%
    N = length(y);
    z = zeros(N,1);
        
    % LIMIT DELTA
    max_delta = delta*16;
    min_delta = delta/16;
    
    for i=2:N
        if(i>4)
            % FOR SERIES OF 0000 OR 1111 INCREASE DELTA BY 2 TO OVERCOME SLOPE OVERLOAD
            if((y(i-3)==0 && y(i-4)==0 && y(i-2)==0 && y(i-1)==0) || (y(i-3)==1 && y(i-4)==1 && y(i-2)==1 && y(i-1)==1) )
                if(delta<max_delta)
                    delta = delta*k ;
                end
            % FOR SERIES OF 0101 OR 1010 REDUCE DELTA BY 2 TO AVOID GRANULAR NOISE
            elseif(xor(y(i-3),y(i-4)) && xor(y(i-3),y(i-2)) && xor(y(i-2),y(i-1)) )
                if(delta>min_delta)
                    delta = delta/k ;
                end
            end
        end
        % ADDING STEP SIZE TO THE PREDICTED OUTPUT
        if( y(i) == 1)
            z(i) = z(i-1) + delta;
        else
            z(i) = z(i-1) - delta;
        end 
    end
    
    % INTERPOLATION OF SAMPLES USING LOW-PASS
    z  =lowpass(z,f,Fs);
end