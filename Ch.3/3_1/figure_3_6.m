%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Figure 3-6:                  %
%     Types of Adverse Effects of Channel On Message Signal    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 3-Section 3                      %
%                                                              %
%                                                              %
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
%    signal_b: A smoothed version of signal_a, implying distortion.
%    signal_c: a sine wave added to signal_a, indicating interference.
%    signal_d: signal_a with added white Gaussian noise.
%%---------------------------------------------------------------
%%

% Define bit pattern and original signal
bit_pattern = [1 1 0 1 0 0 1 0 0];
signal_a = repelem(bit_pattern, 100);

% Adjust `t` to match the length of `signal_a`
t = linspace(0, 9, length(signal_a));


% Ensure that signal_a matches the length of t
signal_a = signal_a(1:length(t));

% smooth the original signal
signal_b = smoothdata(signal_a, 'gaussian', 50); % Smoothed signal

% Add sine wave to original signal
signal_c = signal_a + 0.1*sin(2 * pi * 5 * t);

% Add white gaussian noise to original signal
signal_d = awgn(signal_a, 10); % Adding noise

% Plot the subplots
figure;

% Subplot (a)
subplot(4, 1, 1);
plot(t, signal_a,'Color',[0,0,0.75], 'LineWidth', 1.5);
title('(a)');
ylim([-0.2 1.2]);
grid on;

% Subplot (b)
subplot(4, 1, 2);
plot(t, signal_b,'Color',[0,0,0], 'LineWidth', 1.5);
title('(b)');
ylim([-0.2 1.2]);
grid on;

% Subplot (c)
subplot(4, 1, 3);
plot(t, signal_c,'Color',[0.75,0,0.25], 'LineWidth', 1.5);
title('(c)');
grid on;

% Subplot (d)
subplot(4, 1, 4);
plot(t, signal_d,'Color',[0,0.5,0.25], 'LineWidth', 1.5);
title('(d)');
grid on;
