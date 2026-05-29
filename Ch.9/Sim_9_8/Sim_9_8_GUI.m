%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       GUI for Simulating A Digital Communication System      %
%  Using Huffman Coding and Various Digital Modulation Methods %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                      Chapter 9                               %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Faranak Rezaie and Amirsadra Khodadadi.                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code implements a GUI for simulating the process of encoding, 
%    modulating, transmitting, and demodulating a text message using 
%    different modulation schemes.
%
%   GUI Components:
%       Text Area (input): A text area where the user enters the message
%        to be encoded.
%       Text Area (Binary Encoded Text): Displays the binary-encoded
%        version of the input text.
%       Text Area (Binary Decoded Text): Shows the binary string after
%        decoding from modulation.
%       Text Area (Decoded Text): Displays the decoded text after 
%        demodulation.
%       Button (Encode): A button that triggers the encoding of the input 
%        text.
%       Drop Down: A dropdown to choose between modulation schemes 
%        (FSK, PSK, ASK).
%       plot (Binary Encoded Signal): Displays the binary encoded signal.
%       plot (Modulated Signal): Displays the modulated signal.
%       plot (Recieved Signal (AWGN Channel)): Displays the received signal
%        after passing through an AWGN (Additive White Gaussian Noise) channel.
%       plot (Demodulated Signal): Displays the demodulated signal.
%       Text Area (Bit Rate Error): Displays the bit error rate (BER) 
%        during the demodulation process.
%
%%---------------------------------------------------------------
%%

close all
Gui1()
% Project GUI
function Gui1
    % Create the figure
    fig = uifigure('Name', 'Huffman', 'Position', [20 20 800 600],'Color','#eef2fd');
    
    % Create the input text area
    inputLabel = uilabel(fig, 'Position', [20 550 100 22], 'Text', 'Input Text:','FontWeight','bold', ...
        'FontColor','#020555');
    inputTextArea = uitextarea(fig, 'Position', [20 520 340 30],'FontColor','#020555');
    
    % Create the text area to display the binary encoded text
    binaryLabel = uilabel(fig, 'Position', [20 490 150 22], 'Text', 'Binary Encoded Text:', 'FontWeight','bold','FontColor','#020555');
    binaryTextArea = uitextarea(fig, 'Position', [20 460 340 30], 'Editable', 'off','FontColor','#020555','BackgroundColor','#fafcff');
    
    binarydecodedLabel = uilabel(fig, 'Position', [20 430 150 22], 'Text', 'Binary Decoded Text:', 'FontWeight','bold','FontColor','#020555');
    bindecodedTextArea = uitextarea(fig, 'Position', [20 400 340 30], 'Editable', 'off','FontColor','#020555','BackgroundColor','#fafcff');
    
    % Create the text area to display the decoded text
    decodedLabel = uilabel(fig, 'Position', [20 370 100 22], 'Text', 'Decoded Text:', 'FontWeight','bold','FontColor','#020555');
    decodedTextArea = uitextarea(fig, 'Position', [20 340 340 30], 'Editable', 'off','FontColor','#020555','BackgroundColor','#fafcff');
    
    % Create the button to encode the text
    encodeButton = uibutton(fig, 'Position', [60 300 80 22], 'Text', 'Encode', ...
        'ButtonPushedFcn', @(encodeButton, event) encodeText(), 'BackgroundColor','#3d5fbd', ...
        'FontColor','#eef2fd','FontWeight','bold');

    modulationDropDown = uidropdown(fig, 'Position', [240 300 80 22],'Items',{'FSK', 'PSK', 'ASK'}, ...
        'ItemsData',{'FSK', 'PSK', 'ASK'},'ValueChangedFcn',@(src, event) choose_modulation(src), ...
        'BackgroundColor','#3d5fbd','FontColor','#eef2fd','FontWeight','bold');
    
    encodeLabel = uilabel(fig, 'Position', [20 250 200 22], 'Text', 'Binary Encoded Signal:', 'FontWeight','bold','FontColor','#020555');
    encoded_plot = uiaxes(fig, 'Position', [20 100 340 150]);
    modLabel = uilabel(fig, 'Position', [410 550 200 22], 'Text', 'Modulated Signal:', 'FontWeight','bold','FontColor','#020555');
    modulation_plot = uiaxes(fig, 'Position', [410 400 340 150]);
    binaryLabel = uilabel(fig, 'Position', [410 370 200 22], 'Text', 'Recieved Signal (AWGN Channel):', ...
        'FontWeight','bold','FontColor','#020555');
    AWGNChannel_plot = uiaxes(fig, 'Position', [410 220 340 150]);
    demodLabel = uilabel(fig, 'Position', [400 190 200 22], 'Text', 'Demodulated Signal :', 'FontWeight','bold','FontColor','#020555');
    demodulation_plot = uiaxes(fig, 'Position', [410 40 340 150]);
    
    errorLabel = uilabel(fig, 'Position', [20 70 100 22], 'Text', 'Bit Rate Error:', 'FontWeight','bold','FontColor','#020555');
    errorTextArea = uitextarea(fig, 'Position', [20 40 340 30], 'Editable', 'off','FontColor','#020555','BackgroundColor','#fafcff');

    function encodeText()
        % Get the input text
        inputText = inputTextArea.Value;
        
        % Check if input text is empty
        if isempty(inputText)
            uialert(fig, 'Please enter some text to encode.', 'Input Error');
            return;
        end
        
        % Join the input text if it is in cell format
        if iscell(inputText)
            inputText = strjoin(inputText, '');
        end
        
        % Create Huffman encoder object
        encoder = Huffman(inputText);
        
        % Encode the input text
        binaryString = encoder.encode(inputText);
        
        % Display the binary string and decoded text
        binaryTextArea.Value = binaryString;

        data = binaryString - '0';
        f = 1000;
        M = 4;
        system = ModandDemod(data,f, M);
        signal = system.CreateSignal();
        plot(encoded_plot,signal,'Color','#17c1df', 'LineWidth', 2);
        axis(encoded_plot, 'tight');
    end

    function choose_modulation(src)
        val = src.Value;
        inputText = inputTextArea.Value;
        
        % Join the input text if it is in cell format
        if iscell(inputText)
            inputText = strjoin(inputText, '');
        end
        
        % Create Huffman encoder object
        encoder = Huffman(inputText);
        
        % Encode the input text
        binaryString = encoder.encode(inputText);

        % Modulating the encoded text
        data = binaryString - '0';
        f=1000;
        M=8;
        system = ModandDemod(data,f, M);
        fskmod_signal = system.FSKModulation();
        pskmod_signal = system.PSKModulation();
        askmod_signal = system.ASKModulation();
        
        % Transmitting over AWGN channel
        SNR = 13;
        rx_fsk = awgn(fskmod_signal, SNR);
        rx_psk = awgn(pskmod_signal, SNR);
        rx_ask = awgn(askmod_signal, SNR);
        
        % Demodulating the recieved signal
        fskdemod_signal = system.FSKDemodulation(rx_fsk);  
        pskdemod_signal = system.PSKDemodulation(rx_psk);
        askdemod_signal = system.ASKDemodulation(rx_ask);

        if (strcmp(val,'FSK') == 1)
            plot(modulation_plot,fskmod_signal,'Color','#d9052c');
            plot(AWGNChannel_plot,rx_fsk,'Color','#9a2fd7');
            stem(demodulation_plot,fskdemod_signal,'Color','#1d1bac','LineWidth', 1,'MarkerFaceColor','#1d1bac');

            [BER, NOR] = biterr(data, fskdemod_signal);
            errorTextArea.Value = num2str(BER);
            x = dec2bin(fskdemod_signal);
            x = x.';
            bindecodedTextArea.Value = x;
            %Decode the binary string back to the original text
            decodedText = encoder.decode(x);
            decodedTextArea.Value = decodedText;            
        end
        
        if (strcmp(val,'PSK') == 1)
            plot(modulation_plot,pskmod_signal,'Color','#d9052c');
            plot(AWGNChannel_plot,rx_psk,'Color','#9a2fd7');
            stem(demodulation_plot,pskdemod_signal,'Color','#1d1bac', 'LineWidth', 1,'MarkerFaceColor','#1d1bac');

            [BER, NOR] = biterr(data, pskdemod_signal);
            errorTextArea.Value = num2str(BER);
            
            x = dec2bin(pskdemod_signal);
            x = x.';
            bindecodedTextArea.Value = x;
            %Decode the binary string back to the original text
            decodedText = encoder.decode(x);
            decodedTextArea.Value = decodedText;           
        end
        
        if (strcmp(val,'ASK') == 1)
            plot(modulation_plot,askmod_signal,'Color','#d9052c');
            plot(AWGNChannel_plot,rx_ask,'Color','#9a2fd7');
            stem(demodulation_plot,askdemod_signal, 'Color','#1d1bac','LineWidth', 1 ,'MarkerFaceColor','#1d1bac');

            [BER, NOR] = biterr(data, askdemod_signal);
            errorTextArea.Value = num2str(BER);
            
            x = dec2bin(askdemod_signal);
            x = x.';
            bindecodedTextArea.Value = x;
            %Decode the binary string back to the original text
            decodedText = encoder.decode(x);
            decodedTextArea.Value = decodedText;
        end
        
        axis(modulation_plot, 'tight');
        axis(AWGNChannel_plot, 'tight');
        axis(demodulation_plot, 'tight');       
    end

end