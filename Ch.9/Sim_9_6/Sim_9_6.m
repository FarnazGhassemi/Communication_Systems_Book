%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Illustrating Chapter 9 Digital Modulation :          %
%                                 FSK Modulation               %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 9                           %
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              DSB Modulation                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0=10;                               	% signal duration
ts=0.001;                            	% sampling interval
fs=1/ts;                             	% sampling frequency
t=[0:ts:t0-ts];                         % time vector
df=0.2;                              	% required frequency resolution



% message signal

p=[1 1 0 1 0 1 1 0 0 0];                % Message signal
m=[];
for i=1: length(p)
    m=[m,p(i)*ones(1,fs)];
end
m_n=m;%(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(M));	% frequency vector



% carrier signal
fc1=5;                              	% carrier frequency
c1=cos(2*pi*fc1.*t);                   	% carrier signal
C1 = fftshift(fft(c1) / length(c1));       % Fourier transform 

fc2=7;                              	% carrier frequency
c2=cos(2*pi*fc2.*t);                   	% carrier signal
C2 = fftshift(fft(c2) / length(c2));       % Fourier transform 

% DSB Modulated signal
u=[];
for i=1:length(p)
    if p(i)==1
        u=[u,ones(1,fs).*c1(1:fs)];                       % DSB Modulated signal
    else
        u=[u,ones(1,fs).*c2(1:fs)];                       % DSB Modulated signal
    end
end
U = fftshift(fft(u) / length(u));      % Fourier transform 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=(fc2+5)*1.2;

% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t*length(p),m,'Color', colors(2,:),'LineWidth', 2)
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
subplot(3,1,1)
plot(t*length(p),c1,'Color', colors(4,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The first carrier signal') 
grid on

subplot(3,1,2)
plot(t*length(p),c2,'Color', colors(9,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The second carrier signal') 
grid on
subplot(3,1,3)
plot(f,abs(C1),'Color', colors(4,:),'LineWidth', 2) 
hold on
plot(f,abs(C2),'Color', colors(9,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
legend('First Carrier','Second Carrier')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 3: DSB Modulated Signal
figure
subplot(2,1,1)
plot(t*length(p),u,'Color', colors(3,:),'LineWidth', 2)
%axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The FSK Modulated signal')
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
subplot(4,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The Message Signal') 
grid on
subplot(4,1,2)
plot(t,c1,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The first Carrier Signal') 
grid on
subplot(4,1,3)
plot(t,c2,'Color', colors(9,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The second Carrier Signal') 
grid on
subplot(4,1,4)
plot(t,u,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The FSK Modulated Signal')
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
plot(f,abs(C1),'Color', colors(4,:),'LineWidth', 2) 
xlim([-fp fp])
hold on
plot(f,abs(C2),'Color', colors(9,:),'LineWidth', 2) 
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
title('The ASK Modulated Signal')
grid on
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Bipolar FSK                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% message signal

p=[1 1 -1 1 -1 1 1 -1 -1 -1];                % Message signal
m=[];
for i=1: length(p)
    m=[m,p(i)*ones(1,fs)];
end
m_n=m;%(m-mean(m))/max(abs(m));            % normalized message signal
M = fftshift(fft(m_n) / length(m_n));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(M));	% frequency vector



% carrier signal
fc1=5;                              	% carrier frequency
c1=cos(2*pi*fc1.*t);                   	% carrier signal
C1 = fftshift(fft(c1) / length(c1));       % Fourier transform 

fc2=7;                              	% carrier frequency
c2=cos(2*pi*fc2.*t);                   	% carrier signal
C2 = fftshift(fft(c2) / length(c2));       % Fourier transform 

% DSB Modulated signal
u=[];
for i=1:length(p)
    if p(i)==1
        u=[u,ones(1,fs).*c1(1:fs)];                       % DSB Modulated signal
    else
        u=[u,ones(1,fs).*c2(1:fs)];                       % DSB Modulated signal
    end
end
U = fftshift(fft(u) / length(u));      % Fourier transform 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp=(fc2+5)*1.2;

% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t*length(p),m,'Color', colors(2,:),'LineWidth', 2)
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
subplot(3,1,1)
plot(t*length(p),c1,'Color', colors(4,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The first carrier signal') 
grid on

subplot(3,1,2)
plot(t*length(p),c2,'Color', colors(9,:),'LineWidth', 2)
%axis([0 t0 -1.2 1.2])
xlabel('Time')
ylabel('Amplitude')
title('The second carrier signal') 
grid on
subplot(3,1,3)
plot(f,abs(C1),'Color', colors(4,:),'LineWidth', 2) 
hold on
plot(f,abs(C2),'Color', colors(9,:),'LineWidth', 2) 
xlabel('Frequency')
ylabel('Magnitude')
legend('First Carrier','Second Carrier')
%title('Spectrum of the message signal')
xlim([-fp fp])
grid on
% Figure 3: DSB Modulated Signal
figure
subplot(2,1,1)
plot(t*length(p),u,'Color', colors(3,:),'LineWidth', 2)
%axis([0 t0 -2 2])
xlabel('Time')
ylabel('Amplitude')
title('The FSK Modulated signal')
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
subplot(4,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The Message Signal') 
grid on
subplot(4,1,2)
plot(t,c1,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The first Carrier Signal') 
grid on
subplot(4,1,3)
plot(t,c2,'Color', colors(9,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The second Carrier Signal') 
grid on
subplot(4,1,4)
plot(t,u,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title('The FSK Modulated Signal')
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
plot(f,abs(C1),'Color', colors(4,:),'LineWidth', 2) 
xlim([-fp fp])
hold on
plot(f,abs(C2),'Color', colors(9,:),'LineWidth', 2) 
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
title('The ASK Modulated Signal')
grid on
hold on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Save Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM=cd;
FolderName = [PM,'\PNG\']   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  set(gcf, 'Position', [100, 100, 1200, 800]); % Set size again
  %FigName   = [num2str(iFig)]%;get(FigHandle, 'Name');
  FigName   = num2str(get(FigHandle, 'Number'))
  set(0, 'CurrentFigure', FigHandle);
  savefig(gcf, [FolderName, FigName, '.fig']);
  print(gcf, [FolderName, FigName, '.png'], '-dpng', '-r300');
  %close(gcf)
end

