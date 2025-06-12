%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Shannon-Fano Encoding and Decoding for Text Compression    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 8                           %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Khaleghi.                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This script implements Shannon-Fano encoding, a data compression 
%    technique that assigns variable-length binary codes to characters 
%    based on their frequency. It encodes a given input text, saves 
%    the encoded string to a file, and decodes it back to the original 
%    text using the generated codebook.
%
%   Functions :
%       shanon_fano_encoding : Generates a codebook (character-to-binary mapping) 
%        and the encoded string (coded_str).
%       decode_shanon_fano : Decodes the encoded string (coded_str) back 
%        to the original text using the generated codebook.

%   Inputs:
%       Reads a text file (input_text.txt) from the current directory.
%   Outputs:
%       Prints the character codes and the encoded string.
%       Writes the encoded string to a new file (encoded_text.txt).
%       Prints the decoded string to confirm it matches the original input.
%%---------------------------------------------------------------
%%

% Read input string from a text file in the current directory
file_name = 'input_text.txt';
input_str = fileread(file_name);

% Encode the input string using Shanon-Fano encoding
[codebook, coded_str] = shanon_fano_encoding(input_str);

% Display the coded symbols
disp('Character codes:');
keys = codebook.keys;
for i = 1:length(keys)
    fprintf('%c: %s\n', keys{i}, codebook(keys{i}));
end

% Display the coded string
disp(['Coded string: ' coded_str]);

% Write the encoded string to a text file
encoded_file_name = 'encoded_text.txt';
fid = fopen(encoded_file_name, 'w');
fprintf(fid, '%s', coded_str);
fclose(fid);

% Decode the coded string using the generated codebook
decoded_str = decode_shanon_fano(coded_str, codebook);

% Display the decoded string
disp(['Decoded string: ' decoded_str]);