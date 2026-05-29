%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Figure 3-4:                  %
%     Types of Adverse Effects of Channel On Message Signal    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 3-Section 3                      %
%                                                              %
%                                                              %
%   Version.2:             03/09/03---Dr.Ghassemi              %
%   Version.1:             03/08/14                            %
%   The first version Contributed voluntarily by               %
%   Fatemeh Yazdani as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%   This code generates and visualizes a series of signals based on a 
%     predefined bit pattern (Original signal) and illustrates types of 
%     adverse channel effects on original signal: Distortion, Interference and Noise. 
%     It illustrates four signal variations in subplots:
%
%    signal_a: Original signal, a square wave signal based on the bit pattern.
%    signal_b: Attenuated version of signal_a.
%    signal_c: A smoothed version of signal_a, implying distortion.
%    signal_d: a sine wave added to signal_a, indicating interference.
%    signal_e: signal_a with added white Gaussian noise.
%%---------------------------------------------------------------
%%

% Define bit pattern and original signal
bit_pattern = [1 1 0 1 0 0 1 0 0];
signal_a = repelem(bit_pattern, 100);

% Adjust `t` to match the length of `signal_a`
t = linspace(0, 9, length(signal_a));


% Ensure that signal_a matches the length of t
signal_a = signal_a(1:length(t));

% Attenuate the original signal
signal_b = 0.1*(signal_a); % Attenuated signal

% smooth the original signal
signal_c = smoothdata(signal_a, 'gaussian', 50); % Smoothed signal

% Add sine wave to original signal
signal_d = signal_a + 0.1*sin(2 * pi * 5 * t);

% Add white gaussian noise to original signal
signal_e = awgn(signal_a, 10); % Adding noise

% Plot the subplots
figure;
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

% Subplot (a)
subplot(5, 1, 1);
plot(t, signal_a,'Color',colors(1,:), 'LineWidth', 1.5);
%title('(a)');
ylim([-0.2 1.2]);
grid on;

% Subplot (b)
subplot(5, 1, 2);
plot(t, signal_b,'Color',colors(2,:), 'LineWidth', 1.5);
%title('(b)');
ylim([-0.2 1.2]);
grid on;

% Subplot (c)
subplot(5, 1, 3);
plot(t, signal_c,'Color',colors(3,:), 'LineWidth', 1.5);
%title('(c)');
ylim([-0.2 1.2]);
grid on;

% Subplot (d)
subplot(5, 1, 4);
plot(t, signal_d,'Color',colors(4,:), 'LineWidth', 1.5);
%title('(d)');
grid on;

% Subplot (e)
subplot(5, 1, 5);
plot(t, signal_e,'Color',colors(5,:), 'LineWidth', 1.5);
%title('(e)');
grid on;
