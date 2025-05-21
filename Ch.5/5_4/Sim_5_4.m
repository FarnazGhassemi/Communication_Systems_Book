%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Illustrating Chapter 5 Exponential Modulation :        %
%                                 FM Modulation                %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 5                           %
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
%                              FM Modulation                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0=3;                               	% signal duration
ts=0.001;                            	% sampling interval
fs=1/ts;                             	% sampling frequency
t=[0:ts:t0];                         	% time vector
df=0.2;                              	% required frequency resolution

% message signal
fm=2;
m=cos(2*pi*fm*t);                     % Message signal
m_n=(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(M));	% frequency vector

% carrier signal
fc=30;                              	% carrier frequency
Ac=1;
c=Ac*cos(2*pi*fc.*t);                   % carrier signal
C = fftshift(fft(c) / length(c));       % Fourier transform 

% FM Modulated signal
F_Delta=2;                              % FM Modulation Index
int_m = cumsum(m)/fs;
u=cos(2*pi*fc.*t+2*pi*F_Delta*int_m);   % FM Modulated signal
% fdev = 0.1;
% u=fmmod(m,fc,fs,fdev);
U = fftshift(fft(u) / length(u));       % Fourier transform 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=(fc+fm)*1.2;

% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The message signal')
grid on
subplot(2,1,2)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 2: Carrier Signal
figure
subplot(2,1,1)
plot(t,c,'Color', colors(4,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The carrier signal') 
grid on
subplot(2,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 3: FM Modulated Signal
figure
subplot(2,1,1)
plot(t,u,'Color', colors(3,:),'LineWidth', 2)
%axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The FM Modulated signal')
grid on
hold on
%plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
%plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)
subplot(2,1,2)
plot(f,abs(U),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on

% Figure 4: Time Signals
figure
subplot(3,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The Message Signal') 
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
title('The FM Modulated Signal')
grid on
hold on
% plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
% plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)
% legend('Am Modulated Signal','Message Signal with DC Offset','Message Signal')

% Figure 5: Frequency Signals
figure
subplot(3,1,1)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlim([-fp fp])
xlabel('Frequency')
ylabel('Magnitude')
title('The Message Signal') 
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
title('The FM Modulated Signal')
grid on
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              MultiTone                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fm1=2;fm2=5;fm3=7;
% m=8*cos(2*pi*fm1*t)+4*cos(2*pi*fm2*t)+10*cos(2*pi*fm3*t);
fm1=2;fm2=10;
m=1*cos(2*pi*fm1*t)+10*cos(2*pi*fm2*t)

m_n=(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(M));	% frequency vector

% carrier signal
fc=50;                              	% carrier frequency
c=cos(2*pi*fc.*t);                   	% carrier signal
C = fftshift(fft(c) / length(c));       % Fourier transform 

% FM Modulated signal
F_Delta=1;                              % FM Modulation Index
int_m = cumsum(m)/fs;
u=cos(2*pi*fc.*t+2*pi*F_Delta*int_m);   % FM Modulated signal
% fdev = 0.1;
% u=fmmod(m,fc,fs,fdev);
U = fftshift(fft(u) / length(u));       % Fourier transform 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=(fc+fm2)*1.5;

% Figure 6: Message Signal
figure
subplot(2,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The message signal')
grid on
subplot(2,1,2)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 7: Carrier Signal
figure
subplot(2,1,1)
plot(t,c(1:length(t)),'Color', colors(4,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The carrier signal') 
grid on
subplot(2,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 8: FM Modulated Signal
figure
subplot(2,1,1)
plot(t,u(1:length(t)),'Color', colors(3,:),'LineWidth', 2)
%axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The FM Modulated signal')
grid on
hold on
%plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
%plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)
subplot(2,1,2)
plot(f,abs(U),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on

figure
plot(f,abs(U),'Color', colors(3,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
title('Spectrum of the WBFM Modulated signal')
xlim([-fp fp])
grid on

% Figure 9: Time Signals
figure
subplot(3,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The Message Signal') 
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
title('The FM Modulated Signal')
grid on
hold on
% plot(t,envelope(u(1:length(t))),'Color', colors(7,:),'LineStyle',marks{2},'LineWidth', 2)
% plot(t,envelope(u(1:length(t)))-mean(envelope(u(1:length(t)))),'Color', colors(12,:),'LineStyle',marks{2},'LineWidth', 2)
% legend('Am Modulated Signal','Message Signal with DC Offset','Message Signal')

% Figure 10: Frequency Signals
figure
subplot(3,1,1)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlim([-fp fp])
xlabel('Frequency')
ylabel('Magnitude')
title('The Message Signal') 
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
title('The FM Modulated Signal')
grid on
hold on

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                            Save Figures                                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PM=cd;
% FolderName = [PM,'\PNG\']   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   set(gcf, 'Position', [100, 100, 1200, 800]); % Set size again
%   %FigName   = [num2str(iFig)]%;get(FigHandle, 'Name');
%   FigName   = num2str(get(FigHandle, 'Number'))
%   set(0, 'CurrentFigure', FigHandle);
%   savefig(gcf, [FolderName, FigName, '.fig']);
%   print(gcf, [FolderName, FigName, '.png'], '-dpng', '-r300');
%   % close(gcf)
% end

