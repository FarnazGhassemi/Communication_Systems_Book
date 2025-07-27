%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Time Division Multiplexing (TDM) of Sinusoidal Signals    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                 Chapter 9 - Section                          %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Anahita Narimani and Faezeh Ghanbari.                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code simulates the process of Time Division Multiplexing (TDM) for
%    three sinusoidal signals. The code generates three different sinusoidal 
%    signals with varying frequencies, samples them, multiplexes them into 
%    a single TDM signal, and then demultiplexes the TDM signal back into 
%    the original signals. The process is visualized using several plots.
%
%   Input:
%       Signal 1: 8*sin(2*x)
%       Signal 2: 8*sin(x)
%       Signal 3: 8*sin(0.5*x)
%   Output:
%       First figure: Three sinusoidal signals 
%        (Signal 1, Signal 2, Signal 3) are plotted in separate subplots.
%       Second figure: The sampled versions of these signals 
%        (Signal 1, Signal 2, Signal 3) are plotted using the stem function. 
%        The TDM signal is created by combining all three signals and 
%        visualized in the same plot.
%       Third figure: The TDM signal is demultiplexed, and the original 
%        three signals are recovered and plotted again.
%%---------------------------------------------------------------
%%

clc;
close all;
clear all;
x=0:.16:4*pi;                             
sig1=8*sin(2*x);                           
sig2=8*sin(x);
sig3=8*sin(0.5*x);

figure (1);
subplot(2,3,1);                          
plot(sig1);
title('Signal 1');
ylabel('Amplitude');
xlabel('Time');
subplot(2,3,2);
plot(sig2,'r');
title( 'Signal 2');
ylabel('Amplitude');
xlabel('Time');
subplot(2,3,3);
plot(sig3,'g');
title( 'Signal 3');
ylabel('Amplitude');
xlabel('Time');

figure(2)
subplot(5,1,1);
stem(sig1);
title('Sampled Signal 1');
ylabel('Amplitude');
xlabel('Time');
subplot(5,1,2);
stem(sig2,'r');
title('Sampled Signal 2');
ylabel('Amplitude');
xlabel('Time');
subplot(5,1,3);
stem(sig3,'g');
title('Sampled Signal 3');
ylabel('Amplitude');
xlabel('Time');
l1=length(sig1);

subplot(5,1,4);
t=1/3:1:l1;
stem(t,sig1,'.');hold on;
t2=2/3:1:l1;
stem(t2,sig2,'r.');hold on;
t3=1:1:l1;
stem(t3,sig3,'g.');
title('TDM Signal');
ylabel('Amplitude');
xlabel('Time');

 for i=1:l1
  sig(1,i)=sig1(i);                        
  sig(2,i)=sig2(i);
  sig(3,i)=sig3(i);
 end  
 
tdmsig=reshape(sig,1,[]); 
t=1/3:1/3:l1;
subplot(5,1,5);
stem(t,tdmsig,'.');
title('TDM Signal');
ylabel('Amplitude');
xlabel('Time');
demux=reshape(tdmsig,3,[]);
 for i=1:l1
  sig4(i)=demux(1,i);                
  sig5(i)=demux(2,i);
  sig6(i)=demux(3,i);
 end  
 
 figure(1)
 subplot(2,3,4)
 plot(sig4);
 title('Recovere Signal 1');
 ylabel('Amplitude');
 xlabel('Time');
 subplot(2,3,5)
 plot(sig5,'r');
 title('Recovered Signal 2');
 ylabel('Amplitude');
 xlabel('Time');
 subplot(2,3,6)
 plot(sig6,'g');
 title('Recovered Signal 3');
 ylabel('Amplitude');
 xlabel('Time');