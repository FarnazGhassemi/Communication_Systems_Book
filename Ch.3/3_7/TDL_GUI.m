%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      GUI for Simulation of Channel's Distortion Effect       %
%                Using Tapped Delay Line Filter                %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3 - Section 3-5                    %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by Mohammad Amin %
%   Nikravesh as an activity for the related course.           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code generates a graphical user interface (GUI) to simulate the 
%    effect of a Tapped Delay Line (TDL) filter on a sine wave signal. 
%    Users can input parameters like sampling frequency, signal length, 
%    frequency, channel gains, tap delays, SNR, and filter settings. 
%    The code generates a sine wave, applies channel distortion and noise, 
%    and then uses the TDL filter to compensate for these effects. the user 
%    can then choose to visualize different stages of the signal processing 
%    (original, distorted, noisy, or compensated signal).
%
%   GUI Components:
%       Numeric input field for entering the sampling frequency (e.g. 1000),  
%        Length of the Signal (e.g. 1000), Frequency of the Sine Wave (e.g 50), 
%        Channel Tap Gains (e.g. [0.8, 0.2]), Channel Tap Delays (e.g. [0, 5]), 
%        Signal-to-Noise Ratio (dB) (e.g. 20) , Number of Taps for TDL
%        Filter (e.g. 10), and Step Size for Adaptive Filtering (e.g. 0.01).
%       Submit Button: Triggers the simulation with the entered parameters.
%       Menu: Allows the user to select which signal to display 
%       (Original, Distorted, Noisy, or Compensated Signal) and displays
%        the signal in a figure window.
%       Prints Final Filter Weights in command window
%%---------------------------------------------------------------
%%

function TDL_GUI
    % Create a figure window
    fig = uifigure('Name', 'Input Parameters', 'Position', [100 100 400 400]);

    % Create labels and input fields for each parameter
    uilabel(fig, 'Position', [20 350 200 22], 'Text', 'Sampling Frequency (Hz):');
    fsField = uieditfield(fig, 'numeric', 'Position', [220 350 150 22]);

    uilabel(fig, 'Position', [20 310 200 22], 'Text', 'Length of the Signal:');
    LField = uieditfield(fig, 'numeric', 'Position', [220 310 150 22]);

    uilabel(fig, 'Position', [20 270 200 22], 'Text', 'Frequency of the Sine Wave (Hz):');
    fField = uieditfield(fig, 'numeric', 'Position', [220 270 150 22]);

    uilabel(fig, 'Position', [20 230 200 22], 'Text', 'Channel Tap Gains (e.g., [a1 a2 ...]):');
    alphaField = uieditfield(fig, 'text', 'Position', [220 230 150 22]);

    uilabel(fig, 'Position', [20 190 200 22], 'Text', 'Channel Tap Delays (samples) (e.g., [d1 d2 ...]):');
    delayField = uieditfield(fig, 'text', 'Position', [220 190 150 22]);

    uilabel(fig, 'Position', [20 150 200 22], 'Text', 'Signal-to-Noise Ratio (dB):');
    SNRField = uieditfield(fig, 'numeric', 'Position', [220 150 150 22]);

    uilabel(fig, 'Position', [20 110 200 22], 'Text', 'Number of Taps for the TDL Filter:');
    NField = uieditfield(fig, 'numeric', 'Position', [220 110 150 22]);

    uilabel(fig, 'Position', [20 70 200 22], 'Text', 'Step Size for Adaptive Filtering:');
    muField = uieditfield(fig, 'numeric', 'Position', [220 70 150 22]);

    % Create a button to submit the inputs
    btn = uibutton(fig, 'Position', [150 20 100 30], 'Text', 'Submit', 'ButtonPushedFcn', @(btn,event) submitInputs(fsField, LField, fField, alphaField, delayField, SNRField, NField, muField));
end

function submitInputs(fsField, LField, fField, alphaField, delayField, SNRField, NField, muField)
    % Retrieve user inputs
    fs = fsField.Value;
    L = LField.Value;
    f = fField.Value;
    alpha = str2num(alphaField.Value); %#ok<ST2NM>
    delay = str2num(delayField.Value); %#ok<ST2NM>
    SNR = SNRField.Value;
    N = NField.Value;
    mu = muField.Value;
    
    % Run the main function with the user inputs
    mainFunction(fs, L, f, alpha, delay, SNR, N, mu);
end

function mainFunction(fs, L, f, alpha, delay, SNR, N, mu)
    % Derived Parameters
    T = 1/fs;                % Sampling period (s)
    t = (0:L-1)*T;           % Time vector

    % Generate a test signal (sine wave)
    signal = sin(2*pi*f*t);  % Original signal

    % Add channel distortion (multipath effect)
    channel_signal = zeros(size(signal));
    for i = 1:length(alpha)
        channel_signal = channel_signal + [zeros(1, delay(i)), alpha(i)*signal(1:end-delay(i))];
    end

    % Additive White Gaussian Noise (AWGN)
    noisy_signal = awgn(channel_signal, SNR, 'measured');

    % Tapped Delay Line (TDL) filter parameters
    x = noisy_signal;
    d = signal;
    w = zeros(N, 1);         % Initial filter weights
    y = zeros(1, length(x)); % Filter output

    for n = N:length(x)
        x_vec = x(n:-1:n-N+1).';  % Input vector to the filter
        y(n) = w.' * x_vec;       % Filter output
        e = d(n) - y(n);          % Error signal
        w = w + mu * x_vec * e;   % Update filter weights
    end

    % Display the results separately based on user choice
    choice = menu('Choose the signal to display:', 'Original Signal', 'Channel Distorted Signal', 'Noisy Channel Signal', 'Compensated Signal using TDL Filter');

    figure;
    switch choice
        case 1
            plot(t, signal);
            title('Original Signal');
            xlabel('Time (s)');
            ylabel('Amplitude');
        case 2
            plot(t, channel_signal);
            title('Channel Distorted Signal');
            xlabel('Time (s)');
            ylabel('Amplitude');
        case 3
            plot(t, noisy_signal);
            title('Noisy Channel Signal');
            xlabel('Time (s)');
            ylabel('Amplitude');
        case 4
            plot(t, y);
            title('Compensated Signal using TDL Filter');
            xlabel('Time (s)');
            ylabel('Amplitude');
    end

    % Display filter weights
    disp('Final filter weights:');
    disp(w);
end