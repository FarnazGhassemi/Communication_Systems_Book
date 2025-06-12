%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      GUI for Comparative study of quantization schemes       %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                     By: Dr.Farnaz Ghassemi                   %
%                   Chapter 7                                  %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Zahra Mohammadifar and Nima Delbari as an activity for the %
%   related course.                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code implements a graphical user interface (GUI) that allows 
%   the user to perform different types of quantization (uniform  
%   and non-uniform quantization.) on various analog signals and calculate 
%   the Signal-to-Noise Ratio (SNR) and quantization error.
%   Inputs:
%   - Numeric Edit Fields to enter parameters: (Analog Signal Frequency (Hz), 
%   Analog Signal Duration (seconds), Number of Quantization Bits.
%   - Dropdown List To Select Quantization Type: "Uniform Quantization"  
%      or "Non-Uniform Quantization".
%   - Dropdown List To Select Analog Signal Type: Choose from various 
%      signal types like Sine, Cosine, etc.
%   Outputs:
%   A set of plots showing:
%      - The original analog signal.
%      - The quantized signal (for both types of quantization).
%      - The quantized points (for uniform quantization).
%   A message box displaying the SNR of the quantized signal (only for 
%    uniform quantization).
%%---------------------------------------------------------------
%%
function GUI_Comparative_Quantization()
    
    % GUI

    fig = uifigure('Name', 'Quantization and SNR', 'Position', [100 100 400 400]);

    function_label = uilabel(fig, 'Text', 'Quantization Type:', 'Position', [50 320 150 22]);
    function_choice_1 = uidropdown(fig, 'Items', {'Uniform Quantization', 'Non-Uniform Quantizaton'}, 'Position', [200 320 150 22]);

    function_label = uilabel(fig, 'Text', 'Analog Signal Type:', 'Position', [50 280 150 22]);
    function_choice_2 = uidropdown(fig, 'Items', {'Sine', 'Cosine', 'Rectangular', 'Triangular', 'Exponential', 'Square Pulse', 'Sawtooth',  'Linear'}, 'Position', [200 280 150 22]);

    frequency_label = uilabel(fig, 'Text', 'Analog Signal Frequency (Hz):', 'Position', [50 240 150 22]);
    frequency_entry = uieditfield(fig, 'numeric', 'Position', [200 240 150 22]);

    duration_label = uilabel(fig, 'Text', 'Analog Signal Duration (seconds):', 'Position', [50 200 150 22]);
    duration_entry = uieditfield(fig, 'numeric', 'Position', [200 200 150 22]);

    num_bits_label = uilabel(fig, 'Text', 'Number of Quantization Bits:', 'Position', [50 160 150 22]);
    num_bits_entry = uieditfield(fig, 'numeric', 'Position', [200 160 150 22]);

    calculate_button = uibutton(fig, 'push', 'Text', 'Quantization', 'Position', [120 80 160 30], 'ButtonPushedFcn', @(btn,event) calculate_snr());

    % User Input
    
    function calculate_snr()
        func_type_1 = function_choice_1.Value;
        func_type_2 = function_choice_2.Value;
        frequency = frequency_entry.Value;
        duration = duration_entry.Value;
        num_bits = num_bits_entry.Value;

        Fs = 10 * frequency; % sampling rate 
        t = 0:1/Fs:duration-1/Fs;
        % type of quantization
        switch func_type_1
            case 'Uniform Quantization'    
            % analog signal
                switch func_type_2
                    case 'Sine'
                        x_analog = sin(2*pi*frequency*t);
                    case 'Cosine'
                        x_analog = cos(2*pi*frequency*t);
                    case 'Rectangular'
                        x_analog = double(mod(floor(frequency*t), 2) == 0);
                    case 'Triangular'
                        x_analog = sawtooth(2*pi*frequency*t, 0.5); 
                    case 'Exponential'
                        x_analog = exp(-frequency*t); 
                    case 'Square Pulse'
                        x_analog = square(2*pi*frequency*t);
                    case 'Sawtooth'
                        x_analog = sawtooth(2*pi*frequency*t); 
                    case 'Linear'
                        x_analog = t; 
                end
                        % Quantize the analog signal
                L = 2^num_bits; % quantization levels
                x_min = min(x_analog); 
                x_max = max(x_analog); 
                delta = (x_max - x_min) / (L-1 ); % Quantization step size

                x_digital = round((x_analog - x_min) / delta) * delta + x_min;
        

                % noise and SNR
                noise = x_analog - x_digital;
                SNR_quantized = 10 * log10(var(x_digital) / var(noise));
                %SNR_quantized = snr(x_digital, noise);
        
                % Plot
                figure;
                subplot(3, 1, 1);
                plot(t, x_analog);
                title(['Original Analog Signal (' func_type_1 ')']);
                xlabel('Time (seconds)');
                ylabel('Signal Value');
                yline(0 , 'k--');
                axis tight;

                subplot(3, 1, 2);
                plot(t, x_analog, 'b' , 'LineWidth', 1 ); 
                hold on;
                stem(t, x_digital, 'r', 'LineWidth', 1, 'MarkerSize', 4); % Plot quantized signal
                title(['Quantized Signal (' num2str(num_bits) ' bits)']);
                xlabel('Time (seconds)');
                ylabel('Quantized Signal Value');
                legend('Analog Signal', 'Quantized Signal');
                hold off;

                subplot(3, 1, 3);
                stem(t, x_digital, 'r', 'LineWidth', 1.5, 'MarkerSize', 4 ); % Plot only quantized points
                title('Quantized Points');
                xlabel('Time (seconds)');
                ylabel('Quantized Signal Value');
        
                % Display SNR 
                msg = sprintf('SNR for Quantized Signal: %.2f dB', SNR_quantized);
                uialert(fig, msg, 'Result', 'Icon', 'info');
            case 'Non-Uniform Quantization'
                switch func_type_2
                    case 'Sine'
                        % Parameters
                        x_analog = sin(2*pi*frequency*t); % Sine signal

                        % Optimize partition and codebook (use the same initial guess as before)
                        ini_codebook = [0, 1];
                        [partition, codebook] = lloyds(x_analog, ini_codebook);

                        % Apply non-uniform quantization
                        [indices, quantized_signal] = quantiz(x_analog, partition, codebook);
                    case 'Cosine'
                        % Parameters
                        x_analog = cos(2*pi*frequency*t); % Cose signal

                        % Optimize partition and codebook (use the same initial guess as before)
                        ini_codebook = [0, 1];
                        [partition, codebook] = lloyds(x_analog, ini_codebook);

                        % Apply non-uniform quantization
                        [indices, quantized_signal] = quantiz(x_analog, partition, codebook);
                    case 'Triangular'
                        x_analog = sawtooth(2*pi*frequency*t, 0.5); 
                    case 'Exponential'
                        x_analog = exp(-frequency*t);                 
                    otherwise
                        error('Unsupported function type for Uniform Quantization')

                end
                figure;
                subplot(2,1,1);
                plot(t, x_analog);
                title('Original Analog Signal');
                xlabel('Time (s)');
                ylabel('Amplitude');

                subplot(2,1,2);
                stairs(t, quantized_signal); % Stair-step plot for quantized signal
                title('Quantized Analog Signal');
                xlabel('Time (s)');
                ylabel('Amplitude');
                % Overlay the codebook points
                hold on;
                stem(t, codebook(indices+1), 'r', 'Marker', 'o', 'MarkerSize', 5);
                legend('Quantized Signal', 'Codebook Points');
                hold off;



        end


    end
end
