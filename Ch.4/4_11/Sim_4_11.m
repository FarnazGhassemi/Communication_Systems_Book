%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Illustrating Chapter 4 Amplitude Modulation :        %
%                                 VSB Modulation               %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                          Chapter 4                           %
%                                                              %
%                                                              %
%   Version.3:             03/12/15---Dr.Ghassemi              %
%   Version.2:             03/12/14---Dr.Tabanfar              %
%   Version.1:             03/10/27---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
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
%                          DSB Modulation                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = 3; 
ts = 0.001; 
fs = 1/ts; 
t = (0:ts:t0); 
df = 0.2; % Time parameters

% Message signal
fm = 2;
m = 8 * cos(2 * pi * fm * t);
m_n = (m - mean(m)) / max(abs(m)); % Normalized message signal
M = fftshift(fft(m_n) / length(m_n)); % Fourier Transform
f = linspace(-fs/2, fs/2, length(M)); % Frequency vector

% Carrier signal
fc = 15;
c = cos(2 * pi * fc * t);
C = fftshift(fft(c) / length(c));

% DSB Modulated signal
u = m_n .* c;
U = fftshift(fft(u) / length(u));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Apply Upper VSB Filter                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.5; % Bandwidth factor
steepness = 0.95; % Filter steepness

% Call the VSB Filter function
H1 = vsb_usb_filter(fc-fm, beta, steepness, f); % Use 'f' as frequency vector input

% Apply VSB filter in the frequency domain
U1 = U .* H1;

% Convert back to the time domain
u1 = ifft(ifftshift(U1) * length(U1), 'symmetric');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Apply Lower VSB Filter                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

beta = 0.5; 
steepness = 0.95; 
H2 = vsb_lsb_filter(fc+fm, beta, steepness, f);
U2 = U .* H2;
u2 = ifft(ifftshift(U2) * length(U2), 'symmetric');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Plot Figures                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp = (fc + fm) * 1.2;

% Figure 1: Message Signal
figure
subplot(2,1,1)
plot(t, m, 'Color', colors(2,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Message Signal'); grid on;
subplot(2,1,2)
plot(f, abs(M), 'Color', colors(2,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;

% Figure 2: Message Signal
figure
subplot(2,1,1)
plot(t, c, 'Color', colors(4,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Carrier Signal'); grid on;
subplot(2,1,2)
plot(f, abs(C), 'Color', colors(4,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;

% Figure 3: Upper-VSB Modulated Signal 
figure
subplot(2,1,1)
plot(t, u1, 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Upper-VSB Modulated Signal'); grid on;
subplot(2,1,2)
plot(f, abs(U1), 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
hold on; 
plot(f, abs(U),'--', 'Color', colors(8,:), 'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
legend('Upper-VSB Modulated Signal', 'DSB Modulated Signal');


% Figure 4: Lower-VSB Modulated Signal 
figure
subplot(2,1,1)
plot(t, u2, 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Lower-VSB Modulated Signal'); grid on;
subplot(2,1,2)
plot(f, abs(U2), 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
hold on; 
plot(f, abs(U),'--', 'Color', colors(10,:), 'LineWidth', 1);
xlabel('Frequency (Hz)');ylabel('Magnitude');xlim([-fp fp]); grid on;
legend('Lower-VSB Modulated Signal', 'DSB Modulated Signal');


% Figure 5: Time Signals
figure
subplot(4,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The Message Signal'); grid on
subplot(4,1,2)
plot(t,c,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The Carrier Signal'); grid on
subplot(4,1,3)
plot(t,u1,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude');title('The UVSB Signal'); grid on
subplot(4,1,4)
plot(t,u2,'Color', colors(6,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The LVSB Signal'); grid on

% Figure 6: Frequency Signals
figure
subplot(4,1,1)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The Message Signal'); grid on
subplot(4,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The Carrier Signal'); grid on
subplot(4,1,3)
plot(f,abs(U1),'Color', colors(3,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The UVSB Signal'); grid on
subplot(4,1,4)
plot(f,abs(U2),'Color', colors(6,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The LVSB Signal'); grid on

% Figure 7: Upper-VSB Filter Response
figure
plot(f, abs(H1), 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); title('Upper-VSB Filter Response');
xlim([-fp fp]); grid on;

% Figure 8: Lower-VSB Filter Response
figure
plot(f, abs(H2), 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); title('Lower-VSB Filter Response');
xlim([-fp fp]); grid on;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          MultiTone Modulation                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = 3; 
ts = 0.001; 
fs = 1/ts; 
t = (0:ts:t0); 
fm1=2; fm2=5; fm3=7;
m = 8*cos(2*pi*fm1*t) + 4*cos(2*pi*fm2*t) + 10*cos(2*pi*fm3*t);
m_n = (m - mean(m)) / max(abs(m)); 
M = fftshift(fft(m_n) / length(m_n));
f = linspace(-fs/2, fs/2, length(M));

% Carrier signal
fc = 30;
c = cos(2*pi*fc*t);
C = fftshift(fft(c) / length(c));

% DSB Modulated signal
u = m_n .* c;
U = fftshift(fft(u) / length(u));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Apply Upper VSB Filter                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

beta = 1; 
steepness = 0.95; 
H1 = vsb_usb_filter(fc-fm1-1, beta, steepness, f);
U1 = U .* H1;
u1 = ifft(ifftshift(U1) * length(U1), 'symmetric');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Apply Lower VSB Filter                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

beta = 1; 
steepness = 0.95; 
H2 = vsb_lsb_filter(fc+fm1+1, beta, steepness, f);
U2 = U .* H2;
u2 = ifft(ifftshift(U2) * length(U2), 'symmetric');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Plot Figures                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fp = (fc + fm3) * 1.2;

% Figure 9: Message Signal
figure
subplot(2,1,1)
plot(t, m, 'Color', colors(2,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Message Signal'); grid on;
subplot(2,1,2)
plot(f, abs(M), 'Color', colors(2,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;

% Figure 10: Message Signal
figure
subplot(2,1,1)
plot(t, c, 'Color', colors(4,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Carrier Signal'); grid on;
subplot(2,1,2)
plot(f, abs(C), 'Color', colors(4,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;

% Figure 11: Upper-VSB Modulated Signal 
figure
subplot(2,1,1)
plot(t, u1, 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Upper-VSB Modulated Signal'); grid on;
subplot(2,1,2)
plot(f, abs(U1), 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
hold on; 
plot(f, abs(U),'--', 'Color', colors(8,:), 'LineWidth', 1);
xlabel('Frequency (Hz)'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
legend('Upper-VSB Modulated Signal', 'DSB Modulated Signal');


% Figure 12: Lower-VSB Modulated Signal 
figure
subplot(2,1,1)
plot(t, u2, 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Time'); ylabel('Amplitude'); title('Lower-VSB Modulated Signal'); grid on;
subplot(2,1,2)
plot(f, abs(U2), 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); xlim([-fp fp]); grid on;
hold on; 
plot(f, abs(U),'--', 'Color', colors(10,:), 'LineWidth', 1);
xlabel('Frequency (Hz)');ylabel('Magnitude');xlim([-fp fp]); grid on;
legend('Lower-VSB Modulated Signal', 'DSB Modulated Signal');


% Figure 13: Time Signals
figure
subplot(4,1,1)
plot(t,m,'Color', colors(2,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The Message Signal'); grid on
subplot(4,1,2)
plot(t,c,'Color', colors(4,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The Carrier Signal'); grid on
subplot(4,1,3)
plot(t,u1,'Color', colors(3,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude');title('The UVSB Signal'); grid on
subplot(4,1,4)
plot(t,u2,'Color', colors(6,:),'LineWidth', 2)
xlabel('Time'); ylabel('Amplitude'); title('The LVSB Signal'); grid on

% Figure 14: Frequency Signals
figure
subplot(4,1,1)
plot(f,abs(M),'Color', colors(2,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The Message Signal'); grid on
subplot(4,1,2)
plot(f,abs(C),'Color', colors(4,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The Carrier Signal'); grid on
subplot(4,1,3)
plot(f,abs(U1),'Color', colors(3,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The UVSB Signal'); grid on
subplot(4,1,4)
plot(f,abs(U2),'Color', colors(6,:),'LineWidth', 2) 
xlim([-fp fp]); xlabel('Frequency'); ylabel('Magnitude'); title('The LVSB Signal'); grid on

% Figure 15: Upper-VSB Filter Response
figure
plot(f, abs(H1), 'Color', colors(3,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); title('Upper-VSB Filter Response');
xlim([-fp fp]); grid on;

% Figure 16: Lower-VSB Filter Response
figure
plot(f, abs(H2), 'Color', colors(6,:), 'LineWidth', 2);
xlabel('Frequency'); ylabel('Magnitude'); title('Lower-VSB Filter Response');
xlim([-fp fp]); grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Save Figures                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM=cd;
FolderName=[PM,'\PNG\']   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName = num2str(get(FigHandle, 'Number'))
  set(0, 'CurrentFigure', FigHandle);
  set(gcf, 'Position', [100, 100, 1100, 600]); % Set size again
  savefig(gcf, [FolderName, FigName, '.fig']);
  print(gcf, [FolderName, FigName, '.png'], '-dpng', '-r300');
  %close(gcf)
end