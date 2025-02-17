%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Illustrating Definition 3_11 trough 3-14:           %
%                     Channel Effects                          %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3-Section 3-2                      %
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
%                           Attenuation                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PM=cd;
load([PM,'\BioSigs.mat'])

alpha=5;
d1=6;
d2=d1*2;
l1=1/10^(d1*alpha/10);
l2=1/10^(d2*alpha/10);
figure;
subplot(3,1,1)
plot(benchcicbar(4,1:1500),'Color', colors(2,:),'LineWidth', 2)
title('Original ECG Signal')
hold on
ylim([-3, 9])
grid on
subplot(3,1,2)
plot(benchcicbar(4,1:1500)*l1,'Color', colors(3,:),'LineWidth', 2)
title(['ECG Signal-Attenuated with ',num2str(d1),'m cable(\alpha=5)'])
hold on
ylim([-3, 9])
grid on
subplot(3,1,3)
plot(benchcicbar(4,1:1500)*l2,'Color', colors(4,:),'LineWidth', 2)
title(['ECG Signal-Attenuated with ',num2str(d2),'m cable(\alpha=5)'])
ylim([-3, 9])
hold on
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Inteference                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1=1;
n2=8;
Int1 =n1*benchcicbar(5,1:1500);
Int2 =n2*benchcicbar(5,1:1500);
figure;
subplot(4,1,1)
plot(benchcicbar(4,1:1500),'Color', colors(2,:),'LineWidth', 2)
title('Original ECG Signal')
hold on
ylim([-3, 9])
grid on
subplot(4,1,2)
plot(benchcicbar(5,1:1500),'Color', colors(3,:),'LineWidth', 2)
title('Respiratory Artifact')
hold on
ylim([-2.5, 2])
grid on

subplot(4,1,3)
plot(benchcicbar(4,1:1500)+Int1,'Color', colors(4,:),'LineWidth', 2)
title(['ECG Signal + Low Interfernce of Breathing signal'])
hold on
ylim([-5, 10])
grid on
subplot(4,1,4)
plot(benchcicbar(4,1:1500)+Int2,'Color', colors(5,:),'LineWidth', 2)
title(['ECG Signal + High Interfernce of Breathing signal'])
hold on
ylim([-15, 20])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Noise                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n1=0.1;
n2=5;
noise1 = wgn( 1, 1500 , n1 );
noise2 = wgn( 1, 1500 , n2 );
figure;
subplot(3,1,1)
plot(benchcicbar(4,1:1500),'Color', colors(2,:),'LineWidth', 2)
title('Original ECG Signal')
hold on
ylim([-3, 9])
grid on
subplot(3,1,2)
plot(benchcicbar(4,1:1500)+noise1,'Color', colors(3,:),'LineWidth', 2)
title(['ECG Signal + Noise(',num2str(n1),'dBW)'])
hold on
ylim([-3, 9])
grid on
subplot(3,1,3)
plot(benchcicbar(4,1:1500)+noise2,'Color', colors(4,:),'LineWidth', 2)
title(['ECG Signal + Noise(',num2str(n2),'dBW)'])
hold on
ylim([-3, 9])
grid on
