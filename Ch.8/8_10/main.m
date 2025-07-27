%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison of Delta Modulation and Adaptive Delta Modulation %
%      for a Test Signal under Clean and Noisy Conditions      %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                         Chapter 9 -                          %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by Fatemeh       %
%   Yazdani as an activity for the related course.             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code compares Delta Modulation (DM) and 
%    Adaptive Delta Modulation (ADM) for encoding and decoding a clean 
%    and noisy sine-exponential signal.
%       
%   Input:
%       Clean Signal: Sine-exponential function.
%       Noisy Signal: Clean signal with added Gaussian noise.
%       Delta step size (delta) of 1 for DM.
%       Starting Step size of 0.05 and adaptation factor (k) of 2 for ADM.
%   Output:
%       Encoded Signals: Outputs of Delta Modulation (dm_out) and 
%        Adaptive Delta Modulation (adm_out).
%       Decoded Signals: Reconstructed signals from demodulation of DM 
%        and ADM outputs.
%       Figure 1: Comparison of the Original and Modulated signals using 
%        DM and ADM for clean signal.
%       Figure 2: Comparison of the Original and Demodulated signals using 
%        DM and ADM for clean signal.
%       Figure 3: Comparison of the Original and Modulated signals using 
%        DM and ADM for Noisy signal.
%       Figure 4: Comparison of the Original and Demodulated signals using 
%        DM and ADM for Noisy signal.
%
%   Functions:
%       [encoded, pred] = delta_mod(data, delta) Implements a basic Delta 
%       Modulation algorithm. It encodes an input signal (data) into a binary 
%       sequence (encoded) and generates a predicted signal (pred) using a 
%       specified step size (delta).
%   
%       demod = delta_mod_demod(encoded, delta, f, fs) Implements the 
%       demodulation process for a signal encoded using Delta Modulation. 
%       It takes in a binary modulated signal and reconstructs the original 
%        analog signal by applying an accumulator and a low-pass filter for 
%       interpolation.
%
%       [y, pred] = adm_modulator(x, delta, k) Implements an Adaptive Delta 
%       Modulation (ADM) system using the Jayant Algorithm, which adapts 
%       the step size (Delta) dynamically based on the input signal 
%       characteristics to improve performance.
%
%       [z] = adm_demodulator(y, delta, k, f, Fs) Implements the Adaptive Delta
%       Modulation (ADM) Demodulator, which reconstructs the analog signal 
%       from its binary modulated form using the Jayant Algorithm. It adapts
%       the step size (delta) dynamically to improve signal reconstruction accuracy.
%
%%---------------------------------------------------------------
%%

% Set Text Font
set(0, 'DefaultTextFontName', 'Helvetica', 'DefaultTextFontSize', 18, 'DefaultTextFontWeight', 'bold', 'DefaultTextColor', 'black');

% Set default properties for titles, labels, and axes
set(groot, 'DefaultAxesFontName', 'Helvetica'); % Default font for axes
set(groot, 'DefaultAxesFontSize', 12); % Default font size for axes
set(groot, 'DefaultAxesTitleFontWeight', 'bold'); % Default title weight (optional)

% Set default properties for title font specifically
set(groot, 'DefaultAxesTitleFontSizeMultiplier', 1.2); % Adjust title font size relative to axes font size
set(groot, 'DefaultTextFontName', 'Helvetica'); % Default font for text objects

% Set default properties for all axes
set(groot, 'DefaultAxesFontSize', 14); % Set font size for all axes' tick labels
set(groot, 'DefaultAxesFontName', 'Helvetica'); % Set font for all axes' tick labels
%set(groot, 'DefaultAxesFontWeight', 'bold'); % Set font weight for all axes' tick labels
set(groot, 'DefaultAxesXColor', 'black'); % Set X-axis color
set(groot, 'DefaultAxesYColor', 'black'); % Set Y-axis color

% Set default properties for axes
set(groot, 'DefaultAxesGridLineStyle', '-'); % Default grid line style
set(groot, 'DefaultAxesGridColor', [0 0 0]); % Default grid color (black)
set(groot, 'DefaultAxesGridAlpha', 0.5); % Default grid opacity (fully opaque)
set(groot, 'DefaultAxesLineWidth', 0.5); % Default axes line width (affects grid lines too)

% Box Style for Axe
set(groot, 'DefaultAxesBox', 'on'); % Default: 'on' means axes have a box

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ax = gca;
%ax.XTick = -5:1:5; % Adjust the x-axis grid spacing
%ax.YTick = -1:0.2:2; % Adjust the y-axis grid spacing

% input

%Sin*exp function
len = 500;                      
t = linspace(0, 10, len);       % Time vector
Fs = 50;                        % Sampling frequency in Hz
amp = 5;                        % Amplitude of the sine wave
f = 2;                          % Frequency of the sine wave in Hz
x = amp*sin(2*pi*f*t).*exp(-t);

% Adding noise
noisy_signal = x + 0.05*randn(size(x));


% Delta Modulation
    
delta = 1;
[dm_out, dm_pred] = delta_mod(x, delta);
[dm_out1, dm_pred1] = delta_mod(noisy_signal, delta);

% Demodulation
dm_demod = delta_mod_demod(dm_out, delta, f, Fs);
dm_demod1 = delta_mod_demod(dm_out1, delta, f, Fs);



% ADM - Jayant Algorithm

k=2;
delta=0.05;
[adm_out, adm_pred] = adm_modulator(x,delta,k);
[adm_out1, adm_pred1] = adm_modulator(noisy_signal,delta,k);

% Demodulation
adm_demod = adm_demodulator(adm_out,delta, k, f, Fs);
adm_demod1 = adm_demodulator(adm_out1,delta, k, f, Fs);


% plotting and comparing the outputs

%Input and Predictor Output Comparison for clean signal
figure(1);
subplot(2,1,1);
plot(t,x,'b', 'LineWidth', 2);
title('Delta Modulation');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
stairs(t,dm_pred,'r', 'LineWidth', 1);
legend('Input', 'DM predicted');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

subplot(2,1,2);
plot(t,x,'b', 'LineWidth', 2);
title('Adaptive Delta Modulation');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
stairs(t,adm_pred,'r', 'LineWidth', 1);
legend('Input', 'ADM predicted');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing


%%
% Input and Demodulation Comparison

figure(2);
subplot(2,1,1);
plot(t,x,'b', 'LineWidth', 2);
title('Delta Demodulation');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
plot(t, dm_demod,'color', [56/255,166/255,165/255], 'LineWidth', 2);
legend('Input', 'Demodulation');
grid on; 
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

subplot(2,1,2);
plot(t,x,'b', 'LineWidth', 2);
title('Adaptive Delta Demodulation');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
plot(t, adm_demod,'color', [56/255,166/255,165/255], 'LineWidth', 2);
legend('Input', 'Demodulation');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

%%
% Plotting noisy outputs
%Input and Predictor Output Comparison for noisy signal

figure(3);
subplot(2,1,1);
plot(t,noisy_signal,'b', 'LineWidth', 2);
title('Delta Modulation (Noisy)');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
stairs(t,dm_pred1,'r', 'LineWidth', 1);
legend('Input', 'DM predicted');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

subplot(2,1,2);
plot(t,noisy_signal,'b', 'LineWidth', 2);
title('Adaptive Delta Modulation (Noisy)');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
stairs(t,adm_pred1,'r', 'LineWidth', 1);
legend('Input', 'ADM predicted');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

%%
%Input and Demodulation Comparison for noisy signal

figure(4);
subplot(2,1,1);
plot(t,noisy_signal,'b', 'LineWidth', 2);
title('Delta Demodulation (Noisy)');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
plot(t, dm_demod1,'color', [56/255,166/255,165/255], 'LineWidth', 2);
legend('Input', 'Demodulation');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing

subplot(2,1,2);
plot(t,noisy_signal,'b', 'LineWidth', 2);
title('Adaptive Delta Demodulation (Noisy)');
xlabel('Time(s)');
ylabel('Amplitude(V)');
hold on;
plot(t, adm_demod1,'color', [56/255,166/255,165/255], 'LineWidth', 2);
legend('Input', 'Demodulation');
grid on;
ax = gca;
ax.YTick = -4:2:6; % Adjust the x-axis grid spacing
ax.XTick = 0:1:10; % Adjust the y-axis grid spacing