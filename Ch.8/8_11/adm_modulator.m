function [y, pred] = adm_modulator(x, delta, k)
%   ADM_MODULATOR Implements an Adaptive Delta Modulation (ADM) system 
%    using the Jayant Algorithm, which adapts the step size (Delta) 
%    dynamically based on the input signal characteristics to improve performance.
%
%   Source  - Adaptive Delta Modulation Techniques, Niranjan U, M.N. Suma
%
%   Inputs:
%       x: The input analog signal.
%       delta: Initial step size for quantization.
%       k: Multiplication factor to adjust delta adaptively.
%   Outputs:
%       y: Binary modulated output. 1 for positive steps (+delta) and 
%        0 for negative steps (-delta).
%       pred: Predicted (reconstructed) signal values at each step.
%
    N = length(x);
    y = zeros(N,1);
    pred = zeros(N,1);
    
    % LIMIT DELTA
    max_delta = delta*16;
    min_delta = delta/16;
    
    curr = 0;
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
        
        % COMPARING WITH THE CURRENT SAMPLE VALUE
        % SETTING DELTA POSITIVE OR NEGATIVE
        if( x(i) >= curr)
            y(i) = 1;
            curr = curr + delta;
        else
            y(i) = 0;
            curr = curr - delta;
        end 
        if(y(i) == 0) 
            err = -1;
        else
            err = 1;
        end
        pred(i) = pred(i-1) + err*delta; 
    end
end