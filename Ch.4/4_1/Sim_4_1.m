%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Illustrating Chapter 4 Modulation Signals:          %
%                                                              %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 4                           %
%                                                              %
%                                                              %
%   Version.1:             03/10/27---Dr.Ghassemi              %
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
%                              Mixer                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % am.m
% % Matlab demonstration script for DSB-AM modulation. The message signal
% % is +1 for 0 < t < t0/3, -2 for t0/3 < t < 2t0/3 and zero otherwise.

t0=3;                               	% signal duration
ts=0.001;                            	% sampling interval
fs=1/ts;                             	% sampling frequency
t=[0:ts:t0];                         	% time vector
df=0.2;                              	% required frequency resolution

% message signal
fm=2;
m=8*cos(2*pi*fm*t);
%m=[ones(1,t0/(3*ts)),-2*ones(1,t0/(3*ts)),zeros(1,t0/(3*ts)+1)];
m_n=m/max(abs(m));                   	% normalized message signal
[M,m,df1]=fftseq(m,ts,df);           	% Fourier transform 
M=M/fs;                              	% scaling
M(find(real(M)<2.5))=0;                 % This is for optimixation in showing signal
f=[0:df1:df1*(length(m)-1)]-fs/2;    	% frequency vector

figure
subplot(2,1,1)
plot(t,m(1:length(t)),'Color', colors(2,:),'LineWidth', 2)
axis([0 t0 -10 10])
xlabel('Time')
ylabel('Amplitude')
title('The message signal')
grid on
subplot(2,1,2)
plot(f,abs(fftshift(M)),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([-20 20 0 12])
grid on

% carrier signal
fc=15;                              	% carrier frequency
c=cos(2*pi*fc.*t);                   	% carrier signal
c_n=c/max(abs(c));                   	% normalized message signal
[C,c,df2]=fftseq(c,ts,df);           	% Fourier transform 
C=C/fs;                              	% scaling
C(find(real(C)<0.34))=0;                 % This is for optimixation in showing signal

figure
subplot(2,1,1)
plot(t,c(1:length(t)),'Color', colors(4,:),'LineWidth', 2)
axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The carrier signal') 
grid on
subplot(2,1,2)
plot(f,abs(fftshift(C)),'Color', colors(4,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([-20 20 0 2])
grid on

% mixed signal
u=m_n.*c_n;                     	    % mixed signal
[U,u,df1]=fftseq(u,ts,df);           	% Fourier transform 
U=U/fs;                              	% scaling
U(find(abs((U))<0.34))=0;               % This is for optimixation in showing signal

figure
subplot(2,1,1)
plot(t,u(1:length(t)),'Color', colors(3,:),'LineWidth', 2)
axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The mixed signal')
grid on
hold on
%plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
%plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)

subplot(2,1,2)
plot(f,abs(fftshift(U)),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([-20 20 0 2])
grid on
%%%------------------- Multitone Signal----------------------------------
% PM=cd;
% load([PM,'\ECG_Sample.mat'])
% t0=t0/5;
% m=data(1:length(t));
%m=[ones(1,t0/(3*ts)),-2*ones(1,t0/(3*ts)),zeros(1,t0/(3*ts)+1)];
fm1=2;fm2=5;fm3=7;
m=8*cos(2*pi*fm1*t)+4*cos(2*pi*fm2*t)+10*cos(2*pi*fm3*t);
m_n=m/max(abs(m));                   	% normalized message signal
[M,m,df1]=fftseq(m,ts,df);           	% Fourier transform 
M=M/fs;                              	% scaling
M(find(real(M)<2))=0;                 % This is for optimixation in showing signal
f=[0:df1:df1*(length(m)-1)]-fs/2;    	% frequency vector

figure
subplot(2,1,1)
plot(t,m(1:length(t)),'Color', colors(2,:),'LineWidth', 2)
axis([0 t0 -25 25])
xlabel('Time')
ylabel('Amplitude')
title('The message signal')
grid on
subplot(2,1,2)
plot(f,abs(fftshift(M)),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([0 20 0 15])
grid on

% carrier signal
fc=30;                              	% carrier frequency
c=cos(2*pi*fc.*t);                   	% carrier signal
c_n=c/max(abs(c));                   	% normalized message signal
[C,c,df2]=fftseq(c,ts,df);           	% Fourier transform 
C=C/fs;                              	% scaling
C(find(real(C)<0.34))=0;                 % This is for optimixation in showing signal

figure
subplot(2,1,1)
plot(t,c(1:length(t)),'Color', colors(4,:),'LineWidth', 2)
axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The carrier signal') 
grid on
subplot(2,1,2)
plot(f,abs(fftshift(C)),'Color', colors(4,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([0 20 0 2])
grid on

% mixed signal
u=m_n.*c_n;                     	    % mixed signal
[U,u,df1]=fftseq(u,ts,df);           	% Fourier transform 
U=U/fs;                              	% scaling
U(find(abs((U))<0.1))=0;               % This is for optimixation in showing signal

figure
subplot(2,1,1)
plot(t,u(1:length(t)),'Color', colors(3,:),'LineWidth', 2)
axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The mixed signal')
grid on
hold on
%plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
%plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)

subplot(2,1,2)
plot(f,abs(fftshift(U)),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Signal Power')
%title('Spectrum of the message signal')
axis([0 40 0 0.5])
grid on

%%%-------------------------------------------------------
figure
subplot(3,1,1)
plot(t,m(1:length(t)),'Color', colors(2,:),'LineWidth', 2)
axis([0 t0 -15 22])
xlabel('Time')
ylabel('Amplitude')
title('The Message Signal') 
grid on
subplot(3,1,2)
plot(t,c(1:length(t)),'Color', colors(4,:),'LineWidth', 2)
axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The Carrier Signal') 
grid on
subplot(3,1,3)
plot(t,u(1:length(t)),'Color', colors(3,:),'LineWidth', 2)
axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The Mixed Signals')
grid on
hold on
% plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
% plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)
% legend('Am Modulated Signal','Message Signal with DC Offset','Message Signal')

figure
subplot(3,1,1)
plot(f,abs(fftshift(M)),'Color', colors(2,:),'LineWidth', 2) 
axis([0 40 0 15])
xlabel('Time')
ylabel('Signal Power')
title('The Message Signal') 
grid on
subplot(3,1,2)
plot(f,abs(fftshift(C)),'Color', colors(4,:),'LineWidth', 2) 
axis([0 40 0 1.6])
xlabel('Time')
ylabel('Signal Power')
title('The Carrier Signal') 
grid on
subplot(3,1,3)
plot(f,abs(fftshift(U)),'Color', colors(3,:),'LineWidth', 2) 
axis([0 40 0 0.5])
xlabel('Time')
ylabel('Signal Power')
title('The Mixed Signals')
grid on
hold on