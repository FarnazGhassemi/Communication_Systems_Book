%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    visualization of both time-domain and frequency-domain    %
%       representations of common mathematical functions       %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 2-Section 2-2                    %
%                                                              %
%                                                              %
%   Version.1:             1403/08/15                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code provides a visualization of both time-domain 
%    and frequency-domain representations of common mathematical functions 
%    and their Fourier Transforms, plotting both their time-domain  
%    representation and their frequency-domain magnitude and phase spectra 
%    in seperate figures.
%
%   The code defines various mathematical functions: constant, Dirac delta, 
%    Heaviside step function, rectangular pulse, triangular pulse, sign, 
%    sine, and cosine functions.
%%---------------------------------------------------------------
%%

clear
clc
close all

L = 2;
TimeColor = 'b';
FreqMagColor = 'k';
FreqPhColor = 'r';
x = [-5 5];
syms t w f

%% Constant Function
f_signal = 1;
f_ft = fourier(f_signal, t, w);

% Substitute w = 2*pi*f to get the Fourier Transform with respect to f
f_FT = subs(f_ft, w, 2*pi*f);

mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Constant Function in Time Domain');
% Keep the grid and tick style of the second image
xticks(-5:1:5);  % Set specific x-axis tick positions
yticks(-1.5:0.5:1.5);  % Set specific y-axis tick positions

% Set y-axis limits to include negative values
ylim([-1.45 1.45]);

% Increase font size of axis titles and tick labels
xlabel('Time', 'FontSize', 15);    % Set font size for x-axis label
ylabel('Amplitude', 'FontSize', 15); % Set font size for y-axis label
set(gca, 'FontSize', 15);          % Set font size for tick labels

% Add darker lines at x=0 and y=0
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); % Darker y=0 line
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); % Darker x=0 line

% Enable the grid with your preferred style
grid on;

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)

% Automatically plot Dirac delta by checking the symbolic expression
if has(f_FT, dirac(f))
    % Here, we can extract and plot the coefficient of the delta function
    delta_magnitude = coeffs(f_FT, dirac(f)); 
    
    % Draw an arrow to represent the Dirac delta function
    line([0, 0], [0, double(delta_magnitude)], 'Color', FreqMagColor, 'LineWidth', L, 'LineStyle', '--')
    plot(0, double(delta_magnitude), 'r^', 'MarkerSize', 10, 'MarkerFaceColor', FreqMagColor);
end

% title('Magnitude and Phase Spectrum of Constant Function in Frequency Domain');
% Keep the grid and tick style of the second image
xticks(-5:1:5);  % Set specific x-axis tick positions
yticks(-4:1:4);  % Set specific y-axis tick positions

ylim([-pi-0.1,pi+0.1])

% Increase font size of axis titles and tick labels
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);          % Set font size for tick labels

% Add darker lines at x=0 and y=0
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); % Darker y=0 line
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); % Darker x=0 line

legend('Magnitude', 'Phase')
grid on

%% Dirac function with a delay

f_signal = dirac(t-1);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)

if has(f_signal, dirac(t-1))
    % Identify the delay
    delta_positions = double(solve(t - 1, t));
    delta_magnitude = 1; % Magnitude of the Dirac delta

    line([delta_positions, delta_positions], [0, delta_magnitude], 'Color', TimeColor, 'LineWidth', L, 'LineStyle', '--');
    hold on
    plot(delta_positions, delta_magnitude, 'b^', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
end

% title('Dirac Delta Function \delta(t - 1) in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 


figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of \delta(t - 1) in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on
hold on;
 

%% heaviside function (u(t))

f_signal = heaviside(t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Heaviside Step Function u(t) in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor ,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)


% title('Magnitude and Phase Spectrum of u(t) in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Rectangular function (T=1)

f_signal = rectangularPulse(t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Rectangular Function in Time Domain (T=1)');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Rectangular Function in Frequency Domain (T=1)');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on

%% Triangle Function (T=1)

f_signal = triangularPulse(t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Triangle Function in Time Domain (T=1)');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.1 1.1]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Triangle Function in Frequency Domain (T=1)');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);  
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on

%% Sign function

f_signal = sign(t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Sign Function in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Sign Function in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);  
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Sine function (sin(2*pi*t))

f_signal = sin(2*pi*t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Sine Function in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)

% Visualize Dirac delta functions in the magnitude plot
% The Fourier transform of sin(t) is represented by two Dirac delta functions:
% \0.5*[delta(f - 1) - delta(f + 1)]
delta_positions = [-1, 1]; % Positions of Dirac delta functions
delta_magnitude = 0.5; % Magnitude of Dirac delta functions

for pos = delta_positions
    line([pos, pos], [0, delta_magnitude], 'Color', FreqMagColor, 'LineWidth', L, 'LineStyle', '--');
    plot(pos, delta_magnitude, 'r^', 'MarkerSize', 10, 'MarkerFaceColor', FreqMagColor);
end

% The phase should be -pi/2 at f = 1 and pi/2 at f = -1
plot(-1, pi/2, 'go', 'MarkerSize', 10, 'MarkerFaceColor', FreqPhColor);
plot(1, -pi/2, 'go', 'MarkerSize', 10, 'MarkerFaceColor', FreqPhColor);
line([-1, -1], [0, pi/2], 'Color', FreqPhColor, 'LineWidth', L, 'LineStyle', '-');
line([1, 1], [0, -pi/2], 'Color', FreqPhColor, 'LineWidth', L, 'LineStyle', '-');

% title('Magnitude and Phase Spectrum of Sine Function in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15); 
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Cosine function (cos(2*pi*t))

f_signal = cos(2*pi*t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Cosine Function in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)

% The Fourier transform of cos(2*pi*t) is represented by two Dirac delta functions:
% 0.5* [delta(f - 1) + delta(f + 1)]
delta_positions = [-1, 1]; 
delta_magnitude = 0.5; 

for pos = delta_positions
    line([pos, pos], [0, delta_magnitude], 'Color', FreqMagColor, 'LineWidth', 2, 'LineStyle', '--');
    plot(pos, delta_magnitude, 'r^', 'MarkerSize', 10, 'MarkerFaceColor', FreqMagColor);
end

% title('Magnitude and Phase Spectrum of Cosine Function in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);  
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Sinc Function

f_signal = sin(pi*t)/(pi*t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Sinc Function in Time Domain');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Sinc Function in Frequency Domain');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15); 
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Right-sided Exponential (a=1)

f_signal = exp(-t)*heaviside(t);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Right-sided Exponential Function in Time Domain (a=1)');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Right-sided Exponential Function in Frequency Domain (a=1)');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15); 
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Double-sided Exponential a=1

f_signal = exp(-abs(t));
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Double-sided Exponential Function in Time Domain (a=1)');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Double-sided Exponential Function in Frequency Domain (a=1)');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15); 
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% Gaussian a=1

f_signal=exp(-t^2);
f_ft = fourier(f_signal,t,w);
f_FT = subs(f_ft, w, 2*pi*f);
mag = abs(f_FT);
ang = angle(f_FT);

figure
fplot(f_signal,x,'color',TimeColor,'LineWidth',L)
% title('Gaussian Function in Time Domain (a=1)');
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
fplot(mag,x,'Color',FreqMagColor,'LineWidth',L)
hold on
fplot(ang,x,'Color',FreqPhColor,'LineWidth',L)
% title('Magnitude and Phase Spectrum of Gaussian Function in Frequency Domain (a=1)');
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15); 
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on


%% train of dirac functions (T_0=1)

figure
for i=-5:5
    line([i, i], [0, 1], 'Color', TimeColor, 'LineWidth', L, 'LineStyle', '--')
    hold on
    plot(i, 1, 'r^', 'MarkerSize', 10, 'MarkerFaceColor', TimeColor);
end
xticks(-5:1:5);  
yticks(-1.5:0.5:1.5); 
ylim([-1.45 1.45]);
xlabel('Time', 'FontSize', 15);  
ylabel('Amplitude', 'FontSize', 15); 
set(gca, 'FontSize', 15);          
grid on;
hold on;
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);

figure
ang=0;
fplot(ang,[-5.5 5.5],'Color',FreqPhColor,'LineWidth',L)
for i=-5:5
    line([i, i], [0, 1], 'Color', FreqMagColor, 'LineWidth', L, 'LineStyle', '--')
    hold on
    plot(i, 1, 'r^', 'MarkerSize', 10, 'MarkerFaceColor', FreqMagColor);
end
xticks(-5:1:5);  
yticks(-4:1:4); 
ylim([-pi-0.1,pi+0.1])
xlabel('Frequency', 'FontSize', 15);
ylabel('Magnitude and Phase', 'FontSize', 15);
set(gca, 'FontSize', 15);
plot(xlim, [0 0], 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8); 
plot([0 0], ylim, 'Color', [0.3 0.3 0.3], 'LineWidth', 0.8);
legend('Magnitude', 'Phase')
grid on