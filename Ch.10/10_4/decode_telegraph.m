function char_out = decode_telegraph(bin_input)
% DECODE_TELEGRAPH decodes an apostrophe-separated Telegraph string where each character
% is encoded as: start bit (0) + 5-bit Baudot code + two stop bits (11).
% It checks the 5-bit data code and returns its decoded character,
% a space for a word gap (00100), or an asterisk if the binary code is unsupported.

    % Baudot code table (inverse map)
    codeTable = containers.Map( ...
        {'00011','11001','01110','01001','00001','01101','11010','10100','00110','01011', ...
         '01111','10010','11100','01100','11000','10110','10111','01010','00101','10000', ...
         '00111','11110','10011','11101','10101','10001','00100'}, ...
        {'A','B','C','D','E','F','G','H','I','J', ...
         'K','L','M','N','O','P','Q','R','S','T', ...
         'U','V','W','X','Y','Z',' '} ...
    );

    % Split the input by apostrophe
    segments = split(bin_input, "'");
    
    char_out = '';

    for i = 1:length(segments)
        segment = segments{i}; % get the i-th 8-bit segment

        if length(segment) ~= 8
            char_out = [char_out '*']; % corrupted segment
            continue;
        end

        start_bit = segment(1);
        data_bits = segment(2:6);
        stop_bits = segment(7:8);

        if start_bit ~= '0' || stop_bits ~= "11"
            char_out = [char_out '*']; % invalid start or stop bits
            continue;
        end

        if isKey(codeTable, data_bits)
            char_out = [char_out codeTable(data_bits)];
        else
            char_out = [char_out '*']; % unknown 5-bit code
        end
    end
end
