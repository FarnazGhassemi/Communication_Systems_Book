%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Shannon-Fano Encoding and Decoding for Text Compression    %
%                      TESTING A STRING                        %
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
%       input string : 'this is a test string'
%   Outputs:
%       Prints the character codes and the encoded string.
%       Prints the decoded string to confirm it matches the original input.
%%---------------------------------------------------------------
%%

% Input string
input_str = 'this is a test string';

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

% Decode the coded string using the generated codebook
decoded_str = decode_shanon_fano(coded_str, codebook);

% Display the decoded string
disp(['Decoded string: ' decoded_str]);