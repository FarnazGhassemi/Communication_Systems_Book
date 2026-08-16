%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Illustrating Chapter 4 Phase Modulation :          %
%                                  FM Modulation               %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 5                           %
%                                                              %
%                                                              %
%   Version.1:             03/12/24---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
colors=[0,0,0;                       %1-Black
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;     %5-Purple
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                 ECG                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load Message Signal
load('ECG.mat');  % Contains 'ECG' (time-domain signal)
fs = 150;         % Sampling frequency
Ts = 1/fs;        % Sampling interval
m = ECG;
% Limit to first 3 seconds
t0 = 3;
N = min(length(m), t0 * fs);
t = (0:N-1) /fs;
m = ECG(1:N);

% Upsampling factor
upsample_factor = 10;
new_fs = fs * upsample_factor;  % New sampling frequency
new_Ts = 1 / new_fs;            % New sampling interval
new_t = 0:new_Ts:(t(end));      % New time vector

% Interpolation (spline for smooth curve)
m = interp1(t, m, new_t, 'spline');


t=new_t;
fs=new_fs;

m_n=(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(M));	% frequency vector



% carrier signal
fc=500;                              	% carrier frequency
c=cos(2*pi*fc.*t);                   	% carrier signal
C = fftshift(fft(c) / length(c));       % Fourier transform 
s=sin(2*pi*fc.*t);                   	% carrier signal

% FM Modulated signal
F_Delta=5;                           % FM Modulation Index
int_m = cumsum(m)/fs;
u=cos(2*pi*fc.*t+2*pi*F_Delta*int_m);   % FM Modulated signal
% fdev = 0.1;
% u=fmmod(m,fc,fs,fdev);
% U = fftshift(fft(u) / length(u));     % Fourier transform 
U = fftshift(fft(u) / length(u));       % Fourier transform 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=(fc)*1.2;
BioSig_Type='ECG';

% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['The message signal - (',BioSig_Type,')'])
grid on
subplot(2,1,2)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
xlim([-fp fp])
grid on

% Figure 2: Carrier Signal
figure
subplot(2,1,1)
plot(t,c,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The carrier signal') 
grid on
subplot(2,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
xlim([-fp fp])
grid on

% Figure 3: Modulated Signal
figure
subplot(2,1,1)
plot(t,u,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['The FM Modulated signal'])
grid on
subplot(2,1,2)
plot(f,abs(U),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
xlim([-fp fp])
grid on

% Figure 4: Time Signals
figure
subplot(3,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['The message signal - (',BioSig_Type,')'])
grid on
subplot(3,1,2)
plot(t,c,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The Carrier Signal') 
grid on
subplot(3,1,3)
plot(t,u,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The FM Signal')
grid on


% Figure 5: Frequency Signals
figure
subplot(3,1,1)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlim([-fp fp])
xlabel('Frequency')
ylabel('Magnitude')
title(['The message signal - (',BioSig_Type,')'])
grid on
subplot(3,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlim([-fp fp])

xlabel('Frequency')
ylabel('Magnitude')
title('The Carrier Signal') 
grid on
subplot(3,1,3)
plot(f,abs(U),'Color', colors(3,:),'LineWidth', 2) 
xlim([-fp fp])
xlabel('Frequency')
ylabel('Magnitude')
title('The FM Signal')
grid on
