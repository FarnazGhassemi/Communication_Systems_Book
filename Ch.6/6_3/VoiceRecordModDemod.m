%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Visualizing Analog Modulation and Demodulation        %
%             of Audio Signals for Recorded Audio              %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                  Chapter 4 - Section 4-3                     %
%                                                              %
%                                                              %
%   Version.1:             98/03/30                            %
%   The first version Contributed voluntirely by               %
%   Fatemeh Sadat Hosseini, Romina Hashemi and faezeh Safaei   %
%   as an activity for the related course.                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code allows the user to record an audio signal using the microphone 
%    for a specified duration, modulate the signal using different 
%    techniques (AM, DSB, SSB, PM, FM), and then demodulate the signal to
%    hear the effects of noise and modulation.
%   
%%---------------------------------------------------------------
%%

%m4AFilename = 'voice.m4a';
 clear
 clc
 close all
% 
 duration=2;
recObj = audiorecorder;
fprintf('Press any key to start %g seconds of recording... \n', duration); pause
fprintf('\n Recording...');
recordblocking(recObj, 5);
fprintf('\n Finished recording. \n');
file=recObj;
myRecording = getaudiodata(recObj);
fprintf('\n Press any Key to listen to Recording %h.', myRecording); pause
fprintf('\n Playing... \n');
play(recObj); pause

waveFile='Project.wav';
fprintf('\n Press any key to save the sound data to %s...', waveFile); pause
wavwrite(myRecording,'project.wav');
fprintf('\n Saved.. \n');
[y, fs, nbits]=wavread('project.wav'); % find out sampling rate,
Single_Channel_voice=transpose(y);
 %[Dual_Channel_voice,Fs] = audioread(m4AFilename);
 %Single_Channel_voice = transpose(Dual_Channel_voice(:,1));
 Ac=3;
 fc=250;
 t=linspace(0,length(y)/fs,length(y));
% AM
%t = 1:length(Single_Channel_voice);
mu = 0.9;
Ac = 3;
fc = 250;
AM = Ac .* (1 + mu.*Single_Channel_voice) .* cos(2*pi*fc*t);
noisy_AM = wgn(1, length(Single_Channel_voice), -35) + AM;
AM_hilbert_noisy = imag(hilbert(noisy_AM));
envelop_AM_noisy = sqrt(AM_hilbert_noisy.^2 + noisy_AM.^2)/10;
% AM_Dualband = zeros(length(Single_Channel_voice),2);
% AM_Dualband(:,1) = envelop_AM_noisy;
% AM_Dualband(:,2) = envelop_AM_noisy;
% AM_File = 'AM.m4a';
% audiowrite(AM_File,AM_Dualband,fs)
 disp(' Press any Key to Listen to Modulated Voice'); pause
 sound(AM )
disp(' Press any Key to Listen to Demodulated Voice'); pause
sound(envelop_AM_noisy);


% DSB
DSB = Ac .* Single_Channel_voice .* cos(2*pi*fc*t);
[b,a] = butter(5,fc/(3000/2)); % Butterworth filter of order 5
noisy_DSB = wgn(1, length(Single_Channel_voice), -30) + DSB;
DSB_Demodulated = 2*filter(b,a,noisy_DSB .* cos(2*pi*fc*t))./Ac;
% DSB_Dualband = zeros(length(Single_Channel_voice),2);
% DSB_Dualband(:,1) = DSB_Demodulated;
% DSB_Dualband(:,2) = DSB_Demodulated;
% DSB_File = 'DSB.m4a';
% audiowrite(DSB_File,DSB_Dualband,Fs)
disp(' Press any Key to Listen to Modulated Voice'); pause
 sound(noisy_DSB )
disp(' Press any Key to Listen to Demodulated Voice'); pause
sound(DSB_Demodulated);


% SSB
Single_Channel_voice_Hilbert = imag(hilbert(Single_Channel_voice));
SSB = 0.5 .* Ac .* (Single_Channel_voice .* cos(2*pi*fc*t) + Single_Channel_voice_Hilbert .* sin(2*pi*fc*t));
noisy_SSB = wgn(1, length(Single_Channel_voice), -35) + SSB;
SSB_Demodulated = 4*filter(b,a,noisy_SSB .* cos(2*pi*fc*t))./Ac;
% SSB_Dualband = zeros(length(Single_Channel_voice),2);
% SSB_Dualband(:,1) = SSB_Demodulated;
% SSB_Dualband(:,2) = SSB_Demodulated;
% SSB_File = 'SSB.m4a';
% audiowrite(SSB_File,SSB_Dualband,Fs)
disp(' Press any Key to Listen to Modulated Voice'); pause
 sound(noisy_SSB )
disp(' Press any Key to Listen to Demodulated Voice'); pause
sound(SSB_Demodulated);


% PM
frequency_deviation = 100;
phase_deviation = pi/4;
PM_1 = Ac*cos(2*pi*fc*t + phase_deviation * Single_Channel_voice);
PM = pmmod(Single_Channel_voice,fc, 600, phase_deviation);
noisy_PM = wgn(1, length(Single_Channel_voice), -50) + PM;
PM_Demodulated = pmdemod(noisy_PM,fc,600,phase_deviation);
% PM_Dualband = zeros(length(Single_Channel_voice),2);
% PM_Dualband(:,1) = PM_Demodulated;
% PM_Dualband(:,2) = PM_Demodulated;
% PM_File = 'PM.m4a';
% audiowrite(PM_File,PM_Dualband,Fs)
disp(' Press any Key to Listen to Modulated Voice'); pause
 sound(noisy_PM )
disp(' Press any Key to Listen to Demodulated Voice'); pause
sound(PM_Demodulated);

% FM
FM_1 = Ac*cos(2*pi*fc*t + 2*pi*frequency_deviation * Single_Channel_voice);
FM = fmmod(Single_Channel_voice,fc, 600, frequency_deviation);
noisy_FM = wgn(1, length(Single_Channel_voice), -50) + FM;
FM_Demodulated = fmdemod(noisy_FM,fc,600,frequency_deviation);
% FM_Dualband = zeros(length(Single_Channel_voice),2);
% FM_Dualband(:,1) = FM_Demodulated;
% FM_Dualband(:,2) = FM_Demodulated;
% FM_File = 'FM.m4a';
% audiowrite(FM_File,FM_Dualband,Fs)
disp(' Press any Key to Listen to Modulated Voice'); pause
 sound(noisy_FM )
disp(' Press any Key to Listen to Demodulated Voice'); pause
sound(FM_Demodulated);