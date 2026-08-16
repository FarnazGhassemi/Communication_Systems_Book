function [codebook, coded_str] = shanon_fano_encoding(input_str)
    %   SHANON_FANO_ENCODING generates a codebook mapping each character to 
    %    a unique binary code based on character frequency and encodes 
    %    the input string into a compressed binary representation. 
    
    %   input_str: A string that contains the text to be encoded using 
    %    the Shannon-Fano algorithm.

    %   Returns:
    %       codebook:
    %           A containers.Map object where the keys are unique characters 
    %            from the input string and the values are their corresponding 
    %            Shannon-Fano binary codes.
    %       coded_str:
    %           A string representing the encoded version of the input string. 

    % Remove spaces from the input string
    input_str = regexprep(input_str, '\s+', '');
    
    % Get the unique characters and their frequencies
    chars = unique(input_str);
    freqs = histc(input_str, chars);
    
    % Sort characters by frequency in descending order
    [freqs, sort_idx] = sort(freqs, 'descend');
    chars = chars(sort_idx);
    
    % Initialize codebook
    codebook = containers.Map('KeyType', 'char', 'ValueType', 'any');
    
    % Recursively generate Shanon-Fano codes
    generate_codes(chars, freqs, '');
    
    % Convert the original string to its coded representation
    coded_str = '';
    for i = 1:length(input_str)
        coded_str = [coded_str codebook(input_str(i))];
    end
    
    function generate_codes(chars, freqs, prefix)
        % Base case: only one character
        if length(chars) == 1
            codebook(chars) = prefix;
            return;
        end
        
        % Find the split point
        split_idx = find_split_point(freqs);
        
        % Generate codes for the left half
        generate_codes(chars(1:split_idx), freqs(1:split_idx), [prefix '0']);
        
        % Generate codes for the right half
        generate_codes(chars(split_idx+1:end), freqs(split_idx+1:end), [prefix '1']);
    end

    function split_idx = find_split_point(freqs)
        % Find the split point where the sum of frequencies is nearly equal
        total = sum(freqs);
        cumulative = 0;
        split_idx = 0;
        for i = 1:length(freqs)
            cumulative = cumulative + freqs(i);
            if cumulative >= total / 2
                split_idx = i;
                break;
            end
        end
    end
end
