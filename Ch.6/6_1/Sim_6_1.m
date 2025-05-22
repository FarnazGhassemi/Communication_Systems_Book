%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Illustrating Chapter 6 Stochastic Processes and Noise:    %
%                                    Correlation               %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 6                           %
%                                                              %
%                                                              %
%   Version.1:             03/12/30---Dr.Ghassemi              %
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


t0=3;                               	% signal duration
ts=0.001;                            	% sampling interval
fs=1/ts;                             	% sampling frequency
t=[0:ts:t0];                         	% time vector

fv=2;
v=cos(2*pi*fv*t);                       % Message signal
fw=6;
w=cos(2*pi*fw*t);                     % Message signal

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 1                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=zeros(size(t));
v(2250:2750)=1;
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=zeros(size(t));
w(1250:1750)=1;
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector

v2=zeros(size(t));
v2(500:1000)=1;
V2 = fftshift(fft(v2) / length(v2));       % Fourier transform 

R2=xcorr(v2,w);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(3,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(3,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(3,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on

% fp=25;
% % Figure 2: Frequency Signals
% figure
% subplot(3,1,1)
% plot(f,abs(V),'Color', colors(2,:),'LineWidth', 2) 
% xlim([-fp fp])
% xlabel('Frequency')
% ylabel('Magnitude')
% title(['V(f)'])
% grid on
% subplot(3,1,2)
% plot(f,abs(W),'Color', colors(4,:),'LineWidth', 2) 
% xlim([-fp fp])
% xlabel('Frequency')
% ylabel('Magnitude')
% title('W(f)') 
% grid on
% subplot(3,1,3)
% plot(f2,abs(G),'Color', colors(3,:),'LineWidth', 2) 
% xlim([-fp fp])
% xlabel('Frequency')
% ylabel('Magnitude')
% title('G_v_w(f)')
% grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 1-B                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=zeros(size(t));
v(500:1000)=1;
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=zeros(size(t));
w(1250:1750)=1;
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 3: Message Signal
figure
subplot(3,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(3,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(3,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 1-C                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=zeros(size(t));
v(1500:2500)=1;
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=zeros(size(t));
w(1250:1750)=1;
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 5: Message Signal
figure
subplot(3,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(3,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(3,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 2_A                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v=zeros(size(t));
v(2500:3000)=1;
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=zeros(size(t));
w(1250:1750)=0:0.1:50;
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
R2=xcorr(w,v);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G2));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(4,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(4,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(4,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['Cross-Correlation'])
grid on
hold on
plot([-t0:ts:t0],R2,'Color', colors(3,:),'LineWidth', 2,'LineStyle','--')
legend('R_w_v (t_1,t_2)','R_v_w (t_1,t_2)')

subplot(4,1,4)
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(5,:),'LineWidth', 1.25)
xlabel('Time')
ylabel('Amplitude')
title(['Coonvolution'])
grid on
hold on
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(1,:),'LineWidth', 2,'LineStyle','--')
legend('v(t)*w(t)','w(t)*v(t)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 3                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v=zeros(size(t));
% t1=[2500:3000];
fm=5;
v=sin(2*pi*fm*t);
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=zeros(size(t));
w(1250:1750)=1;
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
R2=xcorr(w,v);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G2));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(5,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(5,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(5,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on
subplot(5,1,4)
plot([-t0:ts:t0],R2,'Color', colors(7,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_w_v (t_1,t_2)'])
grid on
subplot(5,1,5)
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(5,:),'LineWidth', 1.25)
xlabel('Time')
ylabel('Amplitude')
title(['Coonvolution'])
grid on
hold on
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(1,:),'LineWidth', 2,'LineStyle','--')
legend('v(t)*w(t)','w(t)*v(t)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 4                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fm=5;
v=sin(2*pi*fm*t);
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=cos(2*pi*fm*t);
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
R2=xcorr(w,v);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G2));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(5,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(5,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(5,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on
subplot(5,1,4)
plot([-t0:ts:t0],R2,'Color', colors(7,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_w_v (t_1,t_2)'])
grid on
subplot(5,1,5)
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(5,:),'LineWidth', 1.25)
xlabel('Time')
ylabel('Amplitude')
title(['Coonvolution'])
grid on
hold on
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(1,:),'LineWidth', 2,'LineStyle','--')
legend('v(t)*w(t)','w(t)*v(t)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 5                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fm=5;
v=sin(2*pi*fm*t);
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=cos(2*pi*fm*t+3*pi/4);
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
R2=xcorr(w,v);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G2));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(5,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(5,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(5,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on
subplot(5,1,4)
plot([-t0:ts:t0],R2,'Color', colors(7,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_w_v (t_1,t_2)'])
grid on
subplot(5,1,5)
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(5,:),'LineWidth', 1.25)
xlabel('Time')
ylabel('Amplitude')
title(['Coonvolution'])
grid on
hold on
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(1,:),'LineWidth', 2,'LineStyle','--')
legend('v(t)*w(t)','w(t)*v(t)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                Case 6                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fm=5;fm2=11;
v=sin(2*pi*fm*t);
V = fftshift(fft(v) / length(v));       % Fourier transform 
f = linspace(-fs/2, fs/2, length(V));	% frequency vector

w=cos(2*pi*fm2*t);
W = fftshift(fft(w) / length(w));   % Fourier transform 
f = linspace(-fs/2, fs/2, length(W));	% frequency vector

R=xcorr(v,w);                       % Correlation of two Signals
G = fftshift(fft(R) / length(R));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G));	% frequency vector
R2=xcorr(w,v);                       % Correlation of two Signals
G2 = fftshift(fft(R2) / length(R2));   % Fourier transform 
f2 = linspace(-fs/2, fs/2, length(G2));	% frequency vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Plot Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Figure 1: Message Signal
figure
subplot(5,1,1)
plot(t,v,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['v(t)'])
grid on
subplot(5,1,2)
plot(t,w,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['w(t)'])
grid on
subplot(5,1,3)
plot([-t0:ts:t0],R,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_v_w (t_1,t_2)'])
grid on
subplot(5,1,4)
plot([-t0:ts:t0],R2,'Color', colors(7,:),'LineWidth', 2)
xlabel('Time')
ylabel('Amplitude')
title(['R_w_v (t_1,t_2)'])
grid on
subplot(5,1,5)
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(5,:),'LineWidth', 1.25)
xlabel('Time')
ylabel('Amplitude')
title(['Coonvolution'])
grid on
hold on
plot([-t0:ts:t0], conv(v,w) ,'Color', colors(1,:),'LineWidth', 2,'LineStyle','--')
legend('v(t)*w(t)','w(t)*v(t)')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                            Save Figures                                 %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PM=cd;
% FolderName = [PM,'\PNG\']   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   FigName   = num2str(get(FigHandle, 'Number'))
%   set(0, 'CurrentFigure', FigHandle);
%   set(gcf, 'Position', [100, 100, 1200, 800]); % Set size again
%   savefig(gcf, [FolderName, FigName, '.fig']);
%   print(gcf, [FolderName, FigName, '.png'], '-dpng', '-r300');
%   % close(gcf)
% end

