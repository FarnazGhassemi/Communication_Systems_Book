%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GUI for Signal Quantization and Delta Modulation Comparison %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                     By: Dr.Farnaz Ghassemi                   %
%                   Chapter 9 - Chapter                        %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Arash Haeri Moghadam as an activity for the related course.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This MATLAB function simulates the process of quantizing an analog 
%   signal and computes the Signal-to-Noise Ratio (SNR) for both normal 
%   quantization and delta modulation. It also allows the user to select 
%   various types of analog signals, modify signal parameters, and 
%   visualize the results using a GUI. The user can choose the type of 
%   analog signal, frequency, duration, number of quantization bits, and 
%   other parameters, and the function will calculate and display the SNR 
%   for both quantization methods.
%   Inputs:
%   - Numeric Edit Fields to enter parameters: (Analog Signal Frequency (Hz), 
%   Analog Signal Duration (seconds), Number of Quantization Bits, 
%   Initial Delta for Delta Modulation).
%   - Dropdown List To Select An Analog Signal Type: (e.g., Sine, Cosine, Rectangular, etc.).
%   - Check Box To Add Noise: The user can check this box to add Gaussian noise to the analog signal.
%   Outputs:
%   - Quantization: The function plots four figures showing:
%       - The original analog signal.
%       - The normal quantized signal.
%       - The delta modulated signal.
%       - A comparison of the quantized points from normal quantization and 
%         delta modulation.
%   - SNR Calculation: The function calculates the SNR for both the normal 
%   quantized signal and the delta modulated signal and displays the 
%   results in a pop-up message.
%%---------------------------------------------------------------
%%
function GUI_Quantization_vs_DM()

    % GUI
    fig = uifigure('Name', 'Quantization and SNR', 'Position', [100 100 500 450]);
    function_label = uilabel(fig, 'Text', 'Analog Signal Type:', 'Position', [50 370 200 22]);
    function_choice = uidropdown(fig, 'Items', {'Sine', 'Cosine', 'Rectangular', 'Triangular', 'Exponential', 'Square Pulse', 'Sawtooth', 'Linear'}, 'Position', [200 370 150 22]);
    frequency_label = uilabel(fig, 'Text', 'Analog Signal Frequency (Hz):', 'Position', [50 330 200 22]);
    frequency_entry = uieditfield(fig, 'numeric', 'Position', [250 330 150 22] , 'Value',10 );
    duration_label = uilabel(fig, 'Text', 'Analog Signal Duration (seconds):', 'Position', [50 290 200 22]);
    duration_entry = uieditfield(fig, 'numeric', 'Position', [250 290 150 22], 'Value',5);
    num_bits_label = uilabel(fig, 'Text', 'Number of Quantization Bits:', 'Position', [50 250 200 22]);
    num_bits_entry = uieditfield(fig, 'numeric', 'Position', [250 250 150 22], 'Value',8);
    initial_delta_label = uilabel(fig, 'Text', 'Initial Delta for Delta Modulation:', 'Position', [50 210 200 22]);
    initial_delta_entry = uieditfield(fig, 'numeric', 'Position', [250 210 150 22], 'Value', 0.5);
    noise_checkbox = uicheckbox(fig, 'Text', 'Add Noise', 'Position', [50 170 200 22]);
    calculate_button = uibutton(fig, 'push', 'Text', 'Quantization and SNR', 'Position', [170 120 160 30], 'ButtonPushedFcn', @(btn,event) calculate_snr());
   
    % User Input
    function calculate_snr()
       
        func_type = function_choice.Value;
        frequency = frequency_entry.Value;
        duration = duration_entry.Value;
        num_bits = num_bits_entry.Value;
        initial_delta = initial_delta_entry.Value;
        add_noise = noise_checkbox.Value;

        % Validatation
        if frequency <= 0
            uialert(fig, 'Frequency must be greater than 0', 'Input Error', 'Icon', 'error');
            return;
        end
        if duration <= 0
            uialert(fig, 'Duration must be greater than 0', 'Input Error', 'Icon', 'error');
            return;
        end
        if num_bits <= 0
            uialert(fig, 'Number of quantization bits must be greater than 0', 'Input Error', 'Icon', 'error');
            return;
        end
        if initial_delta <= 0
            uialert(fig, 'Initial delta must be greater than 0', 'Input Error', 'Icon', 'error');
            return;
        end

        Fs = 10 * frequency; % sampling rate
        t = 0:1/Fs:duration-1/Fs;

        % Analog signal
        switch func_type
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

        if add_noise
            noise = 0.1 * randn(size(t)); % white Gaussian noise
            x_analog = x_analog + noise;
        end

        % Normal Quantization
        L = 2^num_bits; % Quantization levels
        x_min = min(x_analog);
        x_max = max(x_analog);
        delta = (x_max - x_min) / (L-1); % Quantization step size
        x_digital = round((x_analog - x_min) / delta) * delta + x_min;
        noise_normal = x_analog - x_digital;
        SNR_quantized_normal = snr(x_digital, noise_normal);

        % Delta Modulation
        x_delta = zeros(1, length(t));
        x_delta(1) = x_analog(1);
        delta = initial_delta;
       
        for i = 2:length(t)
            if x_analog(i) > x_delta(i-1)
                x_delta(i) = x_delta(i-1) + delta;
            else
                x_delta(i) = x_delta(i-1) - delta;
            end

            % Adaptive delta
            delta = delta * 1.2 * (abs(x_analog(i) - x_delta(i-1)) / delta);
        end

        noise_delta = x_analog - x_delta;
        SNR_quantized_delta = snr(x_delta, noise_delta);

        % Plotting
        figure;
        subplot(4, 1, 1);
        plot(t, x_analog);
        title(['Original Analog Signal (' func_type ')']);
        xlabel('Time (seconds)');
        ylabel('Signal Value');
        xlim([0 1]); %x-axis limit to 1 second
        grid on;

        subplot(4, 1, 2);
        plot(t, x_analog, 'b', 'LineWidth', 1);
        hold on;
        stem(t, x_digital, 'r', 'LineWidth', 1, 'MarkerSize', 4); % Plot quantized signal
        title(['Normal Quantized Signal (' num2str(num_bits) ' bits)']);
        xlabel('Time (seconds)');
        ylabel('Quantized Signal Value');
        legend('Analog Signal', 'Quantized Signal');
        xlim([0 1]); %x-axis limit to 1 second
        hold off;
        grid on;

        subplot(4, 1, 3);
        plot(t, x_analog, 'b', 'LineWidth', 1);
        hold on;
        stem(t, x_delta, 'r', 'LineWidth', 1, 'MarkerSize', 4); % Plot delta modulated signal
        title('Delta Modulated Signal');
        xlabel('Time (seconds)');
        ylabel('Delta Signal Value');
        legend('Analog Signal', 'Delta Modulated Signal');
        xlim([0 1]); %x-axis limit to 1 second
        hold off;
        grid on;

        subplot(4, 1, 4);
        stem(t, x_digital, 'r', 'LineWidth', 1.5, 'MarkerSize', 4);
        hold on;
        stem(t, x_delta, 'g', 'LineWidth', 1.5, 'MarkerSize', 4);
        title('Quantized Points Comparison');
        xlabel('Time (seconds)');
        ylabel('Quantized Signal Value');
        legend('Normal Quantization', 'Delta Modulation');
        xlim([0 1]); %x-axis limit to 1 second
        hold off;
        grid on;

        %zoom and pan
        h = zoom;
        set(h,'Motion','horizontal','Enable','on');

        h = pan;
        set(h,'Motion','horizontal','Enable','on');

        % Display SNR
        msg = sprintf('SNR for Normal Quantized Signal: %.2f dB\nSNR for Delta Modulated Signal: %.2f dB', SNR_quantized_normal, SNR_quantized_delta);
        uialert(fig, msg, 'Result', 'Icon', 'info');
    end
end