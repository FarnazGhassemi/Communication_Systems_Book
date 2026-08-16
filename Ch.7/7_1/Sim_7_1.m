%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 7-1                 %
%       Effect of Sampling Rate and Reconstruction Method      %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr. Farnaz Ghassemi                    %
%                     Chapter 7                                %
%                                                              %
%   Version.5:             05/05/22---Revised GPT              %
%   Version.4:             04/03/03---Dr.Ghassemi              %
%   Version.3:             04/02/22---Dr.Ghassemi              %
%   Version.2:             03/09/03---Dr.Ghassemi              %
%   Version.1:             96/06/30---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear;
clc;

%% ------------------------------------------------------------------------
% Display settings
cBlue   = [0, 0, 0.75];
cRed    = [214, 39, 40]/255;
cGreen  = [15, 133, 84]/255;
cPurple = [118, 78, 159]/255;
cGray   = [0.55, 0.55, 0.55];

fontName = 'Helvetica';
fontSize = 13;

%% ------------------------------------------------------------------------
% Load IPG signal
dataFile = 'IP.mat';

if exist(dataFile,'file') ~= 2
    error(['File "', dataFile, '" was not found. ', ...
           'Place IP.mat in the current MATLAB folder.']);
end

S = load(dataFile);

if ~isfield(S,'IP')
    error('The MAT-file must contain a variable named IP.');
end

IPraw = S.IP(:);              % Force a column vector
fs0 = 125;                    % Original recording rate (Hz)
N = numel(IPraw);
t0 = (0:N-1).' / fs0;

% Effective bandwidth used in the textbook example
B = 3.5;                      % Hz
fsNyquist = 2*B;              % Nyquist rate = 7 Hz

% Sampling rates used in Figs. 7-7(1) to 7-7(3)
fsList = [2, 7, 15];          % Hz

%% ------------------------------------------------------------------------
% Spectrum of the recorded IPG and effective bandwidth
%
% The recorded physiological signal is not mathematically band-limited.
% To make the sampling-theorem demonstration precise, a band-limited
% reference signal is formed with an IDEAL low-pass filter at B = 3.5 Hz.
% This ideal filter is used only for illustrating the theorem.

% Spectrum used for display and bandwidth-energy calculation
IPraw0 = IPraw - mean(IPraw);
XrawShift = fftshift(fft(IPraw0))/N;
f = ((-floor(N/2)):(ceil(N/2)-1)).' * (fs0/N);

spectralEnergy = abs(XrawShift).^2;
energyFraction = sum(spectralEnergy(abs(f) <= B)) / sum(spectralEnergy);

% Ideal frequency-domain low-pass filter (DC is preserved)
fUnshift = (0:N-1).' * (fs0/N);
fUnshift(fUnshift > fs0/2) = fUnshift(fUnshift > fs0/2) - fs0;

Xfull = fft(IPraw);
Haa = double(abs(fUnshift) <= B);
IP = real(ifft(Xfull .* Haa));    % Band-limited reference signal

% Spectrum of the band-limited reference
IP0 = IP - mean(IP);
XrefShift = fftshift(fft(IP0))/N;

%% ------------------------------------------------------------------------
% Figure 7-6: IPG signal used in the simulation
figure('Color','w','Name','Simulation 7-1: IPG signal');

subplot(2,1,1);
plot(t0, IPraw, 'Color', cGray, 'LineWidth', 0.9);
hold on;
plot(t0, IP, 'Color', cBlue, 'LineWidth', 1.5);
grid on; box on;
xlabel('Time (s)', 'FontName',fontName,'FontSize',fontSize);
ylabel('Amplitude', 'FontName',fontName,'FontSize',fontSize);
title('Recorded IPG and the 3.5-Hz band-limited reference', ...
    'FontName',fontName,'FontSize',fontSize+1,'FontWeight','bold');
legend('Recorded IPG','Band-limited reference','Location','best');
set(gca,'FontName',fontName,'FontSize',fontSize);
xlim([t0(1), t0(end)]);

subplot(2,1,2);
plot(f, abs(XrawShift), 'Color', cGray, 'LineWidth', 0.9);
hold on;
plot(f, abs(XrefShift), 'Color', cBlue, 'LineWidth', 1.5);
xline(B,  '--', 'B_{eff}=3.5 Hz', 'Color', cGray, ...
    'LabelVerticalAlignment','bottom');
xline(-B, '--', 'Color', cGray);
grid on; box on;
xlabel('Frequency (Hz)', 'FontName',fontName,'FontSize',fontSize);
ylabel('Magnitude', 'FontName',fontName,'FontSize',fontSize);
title('Magnitude spectrum', ...
    'FontName',fontName,'FontSize',fontSize+1,'FontWeight','bold');
legend('Recorded IPG','Band-limited reference','Location','best');
set(gca,'FontName',fontName,'FontSize',fontSize);
xlim([-6, 6]);

fprintf('\nSimulation 7-1\n');
fprintf('Fraction of non-DC spectral energy within +/- %.1f Hz: %.4f %%\n', ...
    B, 100*energyFraction);
fprintf('Nyquist rate corresponding to B = %.1f Hz: %.1f Hz\n\n', ...
    B, fsNyquist);

%% ------------------------------------------------------------------------
% Sampling and reconstruction
%
% IMPORTANT:
% 1) Impulse sampling is represented by its sample values using STEM.
%    A Dirac impulse train is a mathematical model, not a reconstructed
%    continuous-time waveform.
%
% 2) Sinc interpolation is a RECONSTRUCTION method, not a sampling method.
%    The cardinal sinc form below corresponds to an ideal reconstruction
%    LPF with cutoff fs/2. For fs >= 2B, it contains the complete signal
%    spectrum; for fs < 2B, aliasing prevents exact reconstruction.
%
% 3) Sample-and-hold is represented by zero-order hold (ZOH).

nRates = numel(fsList);
NRMSE_Sinc = zeros(nRates,1);
NRMSE_ZOH  = zeros(nRates,1);
Status     = cell(nRates,1);

% A small edge region is excluded from the numerical error measure because
% finite-record sinc reconstruction lacks samples outside the record.
edgeGuard = 2; % seconds
valid = (t0 >= t0(1)+edgeGuard) & (t0 <= t0(end)-edgeGuard);
if ~any(valid)
    valid = true(size(t0));
end

refRMS = sqrt(mean((IP(valid) - mean(IP(valid))).^2));

% Common y-limits make visual comparison between panels easier.
yMin = min([IP; 0]);
yMax = max([IP; 0]);
yPad = 0.05 * max(yMax-yMin, eps);
commonYLim = [yMin-yPad, yMax+yPad];

for ii = 1:nRates

    fs = fsList(ii);
    Ts = 1/fs;

    % Sampling instants. The last instant never exceeds t0(end).
    ts = (0:Ts:t0(end)).';

    % The 125-Hz band-limited reference is used as a high-rate approximation
    % of the continuous-time signal. Linear interpolation estimates x(kTs).
    xs = interp1(t0, IP, ts, 'linear');

    %% Ideal sinc reconstruction
    % MATLAB sinc(x) = sin(pi*x)/(pi*x):
    % x_hat(t) = sum_k x(kTs) sinc(fs*(t-kTs))
    xSinc = zeros(size(t0));
    for k = 1:numel(ts)
        xSinc = xSinc + xs(k) .* sinc(fs*(t0-ts(k)));
    end

    %% Sample-and-hold (zero-order hold)
    xZOH = interp1(ts, xs, t0, 'previous', 'extrap');

    %% Quantitative reconstruction error
    if refRMS > 0
        NRMSE_Sinc(ii) = sqrt(mean((IP(valid)-xSinc(valid)).^2)) / refRMS;
        NRMSE_ZOH(ii)  = sqrt(mean((IP(valid)-xZOH(valid)).^2))  / refRMS;
    else
        NRMSE_Sinc(ii) = NaN;
        NRMSE_ZOH(ii)  = NaN;
    end

    %% Nyquist status
    tol = 100*eps(max(fs,fsNyquist));
    if fs < fsNyquist-tol
        Status{ii} = 'Below Nyquist';
    elseif abs(fs-fsNyquist) <= tol
        Status{ii} = 'Nyquist limit';
    else
        Status{ii} = 'Above Nyquist';
    end

    %% Plot results for this sampling rate
    figure('Color','w', ...
        'Name',sprintf('Simulation 7-1: f_s = %g Hz',fs));

    % 1) Band-limited reference signal
    subplot(4,1,1);
    plot(t0, IP, 'Color', cBlue, 'LineWidth', 1.35);
    grid on; box on;
    xlim([t0(1), t0(end)]); ylim(commonYLim);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(sprintf('Reference IPG signal   (f_s = %g Hz: %s)',fs,Status{ii}));
    set(gca,'FontName',fontName,'FontSize',fontSize);

    % 2) Ideal sinc reconstruction
    subplot(4,1,2);
    plot(t0, xSinc, 'Color', cRed, 'LineWidth', 1.5);
    hold on;
    plot(t0, IP, 'Color', cBlue, 'LineWidth', 0.9);
    grid on; box on;
    xlim([t0(1), t0(end)]); ylim(commonYLim);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(sprintf('Ideal sinc reconstruction   NRMSE = %.4f',NRMSE_Sinc(ii)));
    legend('Sinc reconstruction','Reference signal','Location','best');
    set(gca,'FontName',fontName,'FontSize',fontSize);

    % 3) Ideal impulse sampling: display the sample values with stems
    subplot(4,1,3);
    plot(t0, IP, 'Color', cGray, 'LineWidth', 0.9);
    hold on;
    stem(ts, xs, 'Color', cPurple, 'LineWidth', 1.15, ...
        'Marker','o','MarkerSize',3,'MarkerFaceColor',cPurple);
    grid on; box on;
    xlim([t0(1), t0(end)]); ylim(commonYLim);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Ideal impulse sampling (displayed as sample values)');
    legend('Reference signal','Samples x(kT_s)','Location','best');
    set(gca,'FontName',fontName,'FontSize',fontSize);

    % 4) Sample-and-hold / zero-order hold
    subplot(4,1,4);
    stairs(t0, xZOH, 'Color', cGreen, 'LineWidth', 1.45);
    hold on;
    plot(t0, IP, 'Color', cBlue, 'LineWidth', 0.9);
    grid on; box on;
    xlim([t0(1), t0(end)]); ylim(commonYLim);
    xlabel('Time (s)');
    ylabel('Amplitude');
    title(sprintf('Sample-and-hold (ZOH)   NRMSE = %.4f',NRMSE_ZOH(ii)));
    legend('ZOH output','Reference signal','Location','best');
    set(gca,'FontName',fontName,'FontSize',fontSize);
end

%% ------------------------------------------------------------------------
% Summary table
SamplingRate_Hz = fsList(:);
NyquistStatus   = Status;
Results = table(SamplingRate_Hz, NyquistStatus, NRMSE_Sinc, NRMSE_ZOH);

fprintf('\nReconstruction-error summary\n');
disp(Results);

fprintf(['NRMSE is evaluated after excluding %.1f s from each record edge ', ...
         'to reduce finite-record sinc boundary effects.\n'], edgeGuard);
