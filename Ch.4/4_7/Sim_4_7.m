%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Deep Brain Stimulation Modeling Based On Wave Interference  %
%          And Detecting Stimulation Signal In Target Area     % 
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                  Chapter 4 - Section 4-5                     %
%                                                              %
%                                                              %
%   Version.2:             03/08/21                            %
%   Version.1:             03/03/30                            %
%   The first version contributed voluntarily by               %
%   Taha Towhidkhah as an activity for the related course.     %
%   The second version modified voluntarily by Fatemeh Yazdani %
%   as an activity for the related course.                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code simulates a novel method for transcranial deep brain 
%    stimulation (tDBS) based on wave interference and amplitude modulation 
%    of stimulation signals in target area. The code generates a low-frequency 
%    stimulation signal, which is then modulated by a higher-frequency 
%    sinusoidal carrier signal. The code also incorporates the detection of
%    the low-frequency stimulation signal by simulating the nonlinear 
%    properties of neuron membranes and their demodulating behavior which 
%    acts as a simple demodulator consiting of a rectifier and lowpass filter.
%    The filtered output represents how the brain might respond to such a 
%    stimulation, based on the neuronal membrane's response. Visualizations 
%    of the stimulation current, carrier signal, modulated current, and 
%    demodulated signal are provided.
%   
%   Inputs:
%       fc = Carrier frequency (1000 Hz)
%       fs = Stimulation frequency (20 Hz)
%       a1 = Amplitude value for Carrier signal
%       as = Amplitude value for Stimulation signal
%   Outputs:
%       Plots of stimulation current, carrier signal, modulated current, and 
%        demodulated current in target area are provided.
%
%%---------------------------------------------------------------
close all;
clear all;
clc;
%% Deep Brain stimulation Using tDCS
fc=1000;
fs=20;
t=0:0.0001:0.15;
a1=1;
a2=1;
as=0.5;
Ic=a1*cos(2*pi*fc*t);
Is=as*cos(2*pi*fs*t);
figure(1);
plot(t,Is);
grid;
title('Stimulation Current 20Hz');
figure(2);
plot(t,Ic);
grid;
title('Carrier Current 1000Hz');
Im=(1+Is).*Ic; % Modulated Current
figure(3);
plot(t,Im);
grid;title('Modulated Current');
for i=1:1501
           if Im(i)<0
               Im(i)=0;
           end
end
fnum=1;
fden=[0.01 1];
sys=tf(fnum,fden);
sys = 1/(0.01*sys + 1);
y=lsim(sys,Im,t);
figure(4);
plot(t,y);
grid;
title('Demodulated current in the target area');
%% END