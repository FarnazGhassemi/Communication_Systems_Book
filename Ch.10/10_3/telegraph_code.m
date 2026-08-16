function code = telegraph_code(letter)
%   TELEGRAPH_CODE uses a static lookup table that maps each uppercase English 
%    letter to its corresponding 5-bit Baudot (ITA2) code. It checks the 
%    character and returns its encoded binary sequence, 00100 for a word 
%    gap, or 5 asterisks if the character is unsupported.

  
    % Convert letter to uppercase
    letter = upper(letter);
    % Baudot (ITA2) code table
    table = containers.Map( ...
        {'A','B','C','D','E','F','G','H','I','J','K','L','M', ...
         'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',' '}, ...
        {'00011','11001','01110','01001','00001','01101','11010','10100','00110','01011', ...
         '01111','10010','11100','01100','11000','10110','10111','01010','00101','10000', ...
         '00111','11110','10011','11101','10101','10001','00100'} ...
    );

    if isKey(table, letter)
        code = table(letter);
    else
        code = '*****';  % For unsupported characters
    end
end
