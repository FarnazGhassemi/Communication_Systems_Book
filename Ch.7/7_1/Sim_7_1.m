%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 7-1:               %
%                     Types of Sampling Method                 %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 7-Section                        %
%                                                              %
%   Version.4:             04/03/03---Dr.Ghassemi              % 
%   Version.3:             04/02/22---Dr.Ghassemi              %                                            %
%   Version.2:             03/09/03---Dr.Ghassemi              %
%   Version.1:             96/06/30---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------
close all;
clear;
clc;
colors=[0,0,0;                       %1-Black
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;      %5-Purple
        225/255,124/255,5/255;       %6-Orange
        56/255,166/255,165/255;      %7-Light Blue
        204/255,80/255,62/255;       %8-Light Red
        115/255,175/255,72/255;      %9-Light Green
        237/255,173/255,8/255;       %10-Light Orange
        148/255,52/255,110/255;      %11-Light Purple
        70/255,0,114/255;            %12-Dark Blue
        0,0.5,0.25                   %13-Green
        ];
grayColor = [0.5, 0.5, 0.5];
marks={'-';'--';':';'-.'};

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
%%---------------------------------------------------------------
%% Load signal
load('IP.mat'); 
fs0 = 125;       % Sampling frequency
t0 = (0:length(IP)-1)/fs0;
m=IP;
m_n=(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs0/2, fs0/2, length(M));	% frequency vector

fp=(5)*1.2;
BioSig_Type='IPG';
% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t0,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time'), ylabel('Amplitude'), title(['The message signal - (',BioSig_Type,')']), grid on
subplot(2,1,2)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency'), ylabel('Magnitude'), xlim([-fp fp]), grid on
%% Ask user for Sampling rate
fs = input('Enter the Sampling rate (in samples/sec (Hz), e.g.: 6; The signal band width is 3Hz): ');
Ts = 1/fs; 
t = 0:Ts:t0(end); 

%% Sample the signal 
IP_sampled = interp1(t0, IP, t, 'linear');

sampled_sinc = zeros(size(t0));
for n = 1:length(IP_sampled)
    sampled_sinc = sampled_sinc + IP_sampled(n) * sinc(fs*(t0 - t(n)));
    sampled_Impulse(1+n*fs)=IP_sampled(n);
end
sampled_Impulse = zeros(size(t));
for i = 1:length(t)
    sampled_Impulse(i) = IP_sampled(i);
end
sampled_Hold = zeros(size(t0));
for i = 1:length(t)-1
    idx = t0 >= t(i) & t0 < t(i+1);
    sampled_Hold(idx) = IP_sampled(i);
end
sampled_Hold(t0 >= t(end)) = IP_sampled(end);


%% Plotting
figure;
tlim = [0 t0(end)];

subplot(4,1,1);
plot(t0, IP, 'Color', colors(2,:), 'LineWidth', 2);
title('Original Signal');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
xlim(tlim);

subplot(4,1,2);
plot(t0, sampled_sinc, 'Color', colors(3,:), 'LineWidth', 2);
title(['Sinc Based Sampled Signal, f_s= ',num2str(fs),' Hz']);
xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim); hold on;
plot(t0, IP, 'Color', colors(2,:), 'LineWidth', 1);
legend ('Sampled Signal','Original Signal');

subplot(4,1,3);
plot(t, sampled_Impulse, 'Color', colors(5,:), 'LineWidth', 2);
title(['Ideal Impulse Based Sampled Signal, f_s= ',num2str(fs),' Hz']);
xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);hold on;
plot(t0, IP, 'Color', colors(2,:), 'LineWidth', 1);
legend ('Sampled Signal','Original Signal');

subplot(4,1,4);
plot(t0, sampled_Hold, 'Color', colors(4,:), 'LineWidth', 2);
title(['Sample & Hold Based Sampled Signal, f_s= ',num2str(fs),' Hz']);
xlabel('Time (s)'); ylabel('Amplitude'); grid on; xlim(tlim);hold on;
plot(t0, IP, 'Color', colors(2,:), 'LineWidth', 1);
legend ('Sampled Signal','Original Signal');


