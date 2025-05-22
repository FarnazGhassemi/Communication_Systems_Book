%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GUI for Illustrating SNR vs. Gamma in Analog Modulation    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 6 - Section 6-4                    %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Hannaneh Hajiloo as an activity for the related course.    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%    visualizing Signal-to-Noise Ratio (SNR) versus Gamma for different 
%    modulation techniques. Users can input various parameters, such as 
%    modulation index (mio), signal power (Sx), phase sensitivity (phi), 
%    and frequency deviation (D), and view the resulting SNR plots for each 
%    modulation type.
%
%   For better understanding, the the signal-to-noise ratio (SNR) equations 
%    for different modulation methods are provided below:
%       DSB, SNR = Gamma
%       SSB, SNR = Gamma
%       AM, SNR = (mio^2 * Sx) / ( 1 + mio^2 * Sx) * Gamma
%       PM, SNR = phi^2 * Sx * Gamma
%       FM, SNR = 3 * D^2 * Sx * Gamma
%   
%%---------------------------------------------------------------
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


gamma_dB = 0:2:60;                  % Gamma values in dB
gamma = 10.^(gamma_dB / 10);        % Convert dB to linear scale 
figure
% For Base-Band, an ideal DSB-SC and SSB demodulator output SNR is the same as input SNR
snr_output = gamma; % Output SNR (linear scale) 
snr_output_dB = 10 * log10(snr_output); % Convert to dB
plot(gamma_dB, snr_output_dB, '-o', 'Color',colors(2,:),'LineWidth',2,'MarkerIndices',1:5:length(gamma_dB)); 
grid on;
hold on;

% For an ideal AM demodulator, output SNR is the same as input SNR
a=7;
mio =1;
Sx = 1;
if isempty(mio) || mio <= 0 
    uialert(app.UIAxes.Parent, 'Please enter a positive value for the modulation index.', 'Invalid Input'); 
    return; 
end
if isempty(Sx) || Sx <= 0 
    uialert(app.UIAxes.Parent, 'Please enter a positive value for the signal power.', 'Invalid Input'); 
    return; 
end
snr_output = ((mio^2)*Sx ./ (1 + (mio^2)*Sx)) * gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(4,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(4,:),'MarkerSize',8,'MarkerEdgeColor',colors(4,:)); 

mio = 0.5;
snr_output = ((mio^2)*Sx ./ (1 + (mio^2)*Sx)) * gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(9,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(9,:),'MarkerSize',8,'MarkerEdgeColor',colors(9,:)); 

mio = 0.25;
snr_output = ((mio^2)*Sx ./ (1 + (mio^2)*Sx)) * gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(13,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(13,:),'MarkerSize',8,'MarkerEdgeColor',colors(13,:)); 


% For an ideal Phase demodulator, output SNR is the same as input SNR
a=10;
phi=1;
Sx=1;
if isempty(phi) || isempty(Sx) || phi <= 0 || Sx <= 0 
    uialert(app.UIAxes.Parent, 'Please enter positive values for all inputs.', 'Invalid Input');
    return; 
end 
snr_output = (phi^2 * Sx) .* gamma;
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(12,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(12,:),'MarkerSize',8,'MarkerEdgeColor',colors(12,:)); 
grid on;

phi=5;
snr_output = (phi^2 * Sx) .* gamma;
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(11,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(11,:),'MarkerSize',8,'MarkerEdgeColor',colors(11,:)); 
grid on;

phi=10;
a=12;
snr_output = (phi^2 * Sx) .* gamma;
snr_output_dB = 10 * log10(snr_output); % Convert to dB 
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(5,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(5,:),'MarkerSize',8,'MarkerEdgeColor',colors(5,:)); 
grid on;
% For an ideal FM demodulator, output SNR is the same as input SNR
a=10;
D = 1;
Sx=1;
if isempty(D) || isempty(Sx) || D <= 0 || Sx <= 0 
    uialert(app.UIAxes.Parent, 'Please enter positive values for all inputs.', 'Invalid Input'); 
    return; 
end 
snr_output = (3 * D^2 * Sx) .* gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB  
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(3,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(3,:),'MarkerSize',8,'MarkerEdgeColor',colors(3,:)); 

D=5;
snr_output = (3 * D^2 * Sx) .* gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB  
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(6,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(6,:),'MarkerSize',8,'MarkerEdgeColor',colors(6,:)); 

D=10;
a=12;
snr_output = (3 * D^2 * Sx) .* gamma; 
snr_output_dB = 10 * log10(snr_output); % Convert to dB  
plot(gamma_dB(a:end), snr_output_dB(a:end), 'Color',colors(6,:),'LineWidth',2); 
plot(gamma_dB(a), snr_output_dB(a),'o','MarkerFaceColor',colors(10,:),'MarkerSize',8,'MarkerEdgeColor',colors(10,:)); 

legend('Base Band, DSB, SSB','AM-\mu=1','','AM-\mu=0.5','','AM-\mu=0.25','','PM-\Delta\phi=1','','PM-\Delta\phi=5','','PM-\Delta\phi=10','','FM-D=1','','FM-D=5','','FM-D=10',''); 
grid on
title('SNR-Gamma')
       

            
            
      