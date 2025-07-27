%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 10-5:              %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 10-Section                       %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Faranak Rezaie and Amirsadra Khodadadi.                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Huffman Encoder/Decoder

classdef Huffman
    
    %{
    in this class, we define decoder/encoder functions to convert the users input 
    to binary values and convert it back to its original string value using Huffman coding. 
    %}
    
    properties
        Dict        % Huffman dictionary
        UniqueChars % Unique characters in the input text
    end
    
    methods
        function obj = Huffman(inputText)
            % Convert input text to a cell array of characters
            symbols = cellstr(inputText(:))';
            
            % Calculate the frequency of each character in the input text
            uniqueChars = unique(symbols);
            freq = cellfun(@(c) sum(strcmp(symbols, c)), uniqueChars);
            
            % Calculate the probability of each unique character
            p = freq / sum(freq);
            
            % Build the Huffman dictionary
            dict = huffmandict(uniqueChars, p);
            
            % Store the dictionary and unique characters in the object
            obj.Dict = dict;
            obj.UniqueChars = uniqueChars;
        end
        
        function binaryString = encode(obj, inputText)
            % Convert input text to a cell array of characters
            symbols = cellstr(inputText(:))';
            
            % Encode the input text using the Huffman dictionary
            encodedText = huffmanenco(symbols, obj.Dict);
            
            % Convert the encoded text to a binary string
            binaryString = '';
            for i = 1:length(encodedText)
                binaryString = strcat(binaryString, num2str(encodedText(i)));
                binaryString = binaryString(binaryString ~= ' ');
            end
        end
        
        function decodedText = decode(obj, binaryString)
            % Convert binary string to numeric array
            encodedText = arrayfun(@(x) str2double(x), binaryString);
            
            % Decode the numeric array using the Huffman dictionary
            decodedSymbols = huffmandeco(encodedText, obj.Dict);
            
            % Convert cell array of characters to string
            decodedText = strjoin(decodedSymbols, '');
        end
    end
end

