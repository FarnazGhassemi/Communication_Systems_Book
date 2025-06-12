%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              LZW Compression and Decompression               %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 8                           %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Kian Mobasheri and Nima Delbari as an activity for the     %
%   related course.                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This script implements the Lempel-Ziv-Welch (LZW) compression algorithm 
%    to compress and decompress a text file provided by the user. 
%   It verifies the accuracy of the process by comparing the original 
%    content with the decompressed output.
%
%   Functions :
%       norm2lzw : compresses the file content using the LZW algorithm. 
%        returns also the table that the algorithm produces.
%       lzw2norm : Decompresses the compressed data using the LZW
%        algorithm. returns also the table that the algorithm produces.
%   Inputs:
%       File Input: Prompts the user to input the full path of a text file.
%   Outputs:
%       Displays the entropy of the original data.
%       isOK : Checks if the decompressed text matches the original content.
%       Displays the original content and the decompressed data in the command window.
%       Also displays the table that the algorithm produces.
%%---------------------------------------------------------------
%%

clc, clear, close
% Ask user for input text file path
filePath = input('Enter the full path of the text file (including its directory): ', 's');

% Debugging print to verify input
disp(['File path entered: ', filePath]);

% Check if the file exists
if exist(filePath, 'file') ~= 2
    error(['File does not exist at path: ', filePath]);
end

% Read from the user-specified file
fileID = fopen(filePath, 'r');
format = '%c';
% Get string of text from file
data = fscanf(fileID, format);

% --- Entropy calculation ---
symbols = unique(data);
counts = histc(data, symbols);
probabilities = counts / sum(counts);
entropy = -sum(probabilities .* log2(probabilities));
fprintf('\nEntropy of the original data: %.4f bits/symbol\n', entropy);


LZW_content = data;
fclose(fileID);
%disp(LZW_content);
% pack it
[packed,table]=norm2lzw(uint8(LZW_content));
% unpack it
[decoded,table]=lzw2norm(packed);
% transfor it back to char array
decoded = char(decoded);
% test
isOK = strcmp(LZW_content,decoded)

% -------------------------------
% Compression efficiency section
% -------------------------------

original_size = length(LZW_content);      % characters (each = 8 bits)
compressed_size = length(packed);         % elements (each = 16 bits)

original_bits = original_size * 8;
compressed_bits = compressed_size * 16;

compression_ratio = compressed_bits / original_bits;
compression_percent = (1 - compression_ratio) * 100;

fprintf('\n--- Compression Stats ---\n');
fprintf('Original size     : %d bits (%d bytes)\n', original_bits, original_bits/8);
fprintf('Compressed size   : %d bits (%d bytes)\n', compressed_bits, compressed_bits/8);
fprintf('Compression ratio : %.2f%% reduction\n', compression_percent);

% show new table elements
strvcat(table{257:end})
LZW_content
decoded
