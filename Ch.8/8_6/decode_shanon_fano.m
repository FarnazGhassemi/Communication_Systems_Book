function decoded_str = decode_shanon_fano(coded_str, codebook)
    %   DECODE_SHANON_FANO Returns decoded_str: A string representing 
    %    the original text decoded from the coded string using the provided codebook.
    
    %   coded_str: A string representing the encoded data using Shannon-Fano codes.
    %   codebook: A containers.Map that maps characters to their 
    %    corresponding Shannon-Fano codes.
    
    
    % Invert the codebook to get a map from codes to characters
    inv_codebook = containers.Map('KeyType', 'char', 'ValueType', 'char');
    keys = codebook.keys;
    for i = 1:length(keys)
        inv_codebook(codebook(keys{i})) = keys{i};
    end
    
    % Decode the coded string
    decoded_str = '';
    buffer = '';
    for i = 1:length(coded_str)
        buffer = [buffer coded_str(i)];
        if isKey(inv_codebook, buffer)
            decoded_str = [decoded_str inv_codebook(buffer)];
            buffer = '';
        end
    end
    
    % Handle any leftover bits in buffer if decoding was incomplete
    if ~isempty(buffer)
        warning('Decoding incomplete, leftover bits in buffer: %s', buffer);
    end
end