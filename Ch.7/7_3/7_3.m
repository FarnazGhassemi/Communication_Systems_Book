%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Signal Quantization for Different Types of Signals:      %
%                 Sine Wave, Voice, and Image                  %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                    By: Dr.Farnaz Ghassemi                    %
%                   Chapter 7 -                                %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Seyed Amirhossein Mohebbi as an activity for the related   %
%   course.                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code performs quantization on three different types of signals: 
%   a sine wave, voice signals, and images. It allows the user to choose 
%   which type of signal to quantize by entering a mode number. For each 
%   type, the user can adjust the quantization parameters such as frequency, 
%   bit depth or the number of quantization level. The code also visualizes the original 
%   and quantized signals, along with any quantization errors.
%   Sine Wave Quantization: The user can input the frequencies of two sine 
%       waves to create a mixed signal. Then, the signal is quantized based on 
%       the number of quantization levels, and both the original and quantized 
%       signals are displayed. A Fourier transform of the quantized signal is also plotted.

%   Voice Signal Quantization: The user can choose to quantize a 
%       pre-recorded voice or a custom voice recording. They can specify 
%       the bit depth (1–8) for the quantization. The original and  
%       quantized voice signals are plotted for comparison.

%   Image Quantization: The user can input an image (either a reference or 
%       custom image), and the code quantizes the image into the specified 
%       number of levels (1–16). It then displays the original and quantized image 
%       side by side for comparison.
%%---------------------------------------------------------------
%%

clear all
close all

flag = 1;
while(flag == 1)
mode = input('Please Choose the mode: For Quantize a Sin Wave Enter (1), For Quantiza a Voice Enter (2), For Quantize an Image Enter (3):');
if(mode == 1)
flag = 0;
Fs=1e3;
N=1000;
% Make 0.1 seconds sampled every 1/1000 of a second
t = 0 : 0.001 : 0.1;
% Define sine wave parameters.
%z1 = 50; % per second
z1 = input('Enter Frequency of First Signal(hz):');
 % period, seconds
amp1 = 1; % amplitude
%z2 = 60; % per second
z2 = input('Enter Frequency of Second Signal(hz):');
 % period, seconds
%amp2 = 1; % amplitude
z3=1000;
z4=0.1;
mixsig=add_sin(z1,z2,z3,z4);
%NLevel=2;
NLevel = input('Enter Level Number of Quantization:');
%open quantizer.m
resultsig=quantizationerror(mixsig,NLevel);
resultsig2=quantizer(mixsig,NLevel);
y=fftshift(fft(resultsig2,1000));
f=-Fs/2:Fs/N:Fs/2-Fs/N;
figure
plot(f,abs(y),'Displayname','Absolute');
xlim([0 inf]);
title('FFT for Quantized Signal:');
hold on
figure
subplot(3,1,1);
plot(t, resultsig, 'r.-', 'LineWidth', 2, 'MarkerSize', 16);
title('Quantization Error:');
hold on;
subplot(3,1,2);
plot(t, mixsig, 'b.-', 'LineWidth', 2, 'MarkerSize', 16);
title('Original Signal:');
grid on;
hold on;
subplot(3,1,3);
plot(t, resultsig2, 'g.-', 'LineWidth', 2, 'MarkerSize', 16);
title('Quantized Signal:');
grid on;
hold on;
end
if (mode==2)
flag = 0;
Length=3;

nBits=16;
bitinput = input('Enter Bit Number for Voice Quantization between 1 to 8:');
bitnumber=bitinput;
a = input('Number of Voice that you want to quantize (1 For Refrence Voice or 2 For Custom Voice):');
if(a == 1)
    open bluetooth_input.wav
    [y,fs] = audioread('bluetooth_input.wav');
end
if(a == 2)
    myStringVoice = input('Please Enter your Picture File name(full name): ', 's');
    open myStringVoice %or another voice that you want to quantize
    [y,fs] = audioread(myStringVoice);
    
end
%info = audioinfo('handel.wav')
%[y,Fs] = audioread('bluetooth_input.wav');
%info = audioinfo('bluetooth_input.wav')
dt = 1/(fs);
t = 0:dt:(length(y)*dt)-dt;
signal=wav_quantizer(bitnumber,y,fs);
soundsc(signal,fs);
figure
subplot(2,1,1);
plot(t, y, 'r.-', 'LineWidth', 2, 'MarkerSize', 16);
title('Original Signal:');
hold on;
grid on;
subplot(2,1,2);
plot(t, signal, 'b.-', 'LineWidth', 2, 'MarkerSize', 16);
title('Quantized Signal:')
hold on;
end
if(mode==3)
flag = 0;
%Level_number = 1;
Level_number = input('Enter Level Number for image between 1 to 16:');

Im=imread('flower.jpg');
%Im2=imread('flower2.jpg');
a = input('Number of Picture that you want to quantize (1 For Refrence Pic or 2 For Custom Pic):');
if(a==1)
    I=rgb2gray(Im);
end

if(a==2)
myStringPic = input('Please Enter your Picture File name(full name): ', 's');
Im2=imread(myStringPic);
I=rgb2gray(Im2); %or another voice that you want to quantize
end 
thresh = multithresh(I,Level_number);
[quant8_I_max, index] = imquantize(I,thresh);
title('Original Signal Vs Quantized Signal:')
imshowpair(I,quant8_I_max,'montage')
text(size(I, 2)/2 - 50, 10, 'Original Picture:', 'Color', 'red', 'FontSize', 14);
text(size(I, 2) + size(quant8_I_max, 2)/2 - 50, 10, 'Quantized Picture:', 'Color', 'blue', 'FontSize', 14);
end
if(mode ~= 1 && mode ~= 2 && mode ~= 3)
flag = 1;
end
end
function signal = add_sin(F1,F2,Fs,T)
    
    Ts=1/Fs;
    t = 0 : Ts : 0.1;
    T1 = 1/F1;
    T2 = 1/F2;
    t = 0 : Ts : T;
    signal1 =  sin(2*pi*t/T1);
    signal2 =  sin(2*pi*t/T2);
    signal = signal1 + signal2;
end
function Sq=quantizer(S,LevelNo)

%This function quantizes signal "s" in "LevelNo" levels.

 %A=max(abs(S));
 %S=S/A;

R=LevelNo;
%R=2^LevelNo;
%Q=2/R;
mn=min(S);
mx=max(S);

for l=1:R,
    level(l)=(mn+mx)/2+(mx-mn)*(-1+(2*l-1)/R)/2;
    %level(l)=(-1+(2*l-1)/R)/2;
end
for k=1:numel(S),
    diff=level-S(k);
   [E,I]= sort(abs(diff));
   Sq(k)=level(I(1));
end
end

function diffsig = quantizationerror(ss,NL)
    qsignal=quantizer(ss,NL)
    diffsig=ss-qsignal;
    x=var(diffsig)
    %histogram(x)
end
function Sq=wav_quantizer(BitNo,S,Fs)


A=max(abs(S));
S=S/A;

R=2^BitNo;
%Q=2/R;

for l=1:R,
    level(l)=-1+(2*l-1)/R;
end
for k=1:numel(S),
    diff=level-S(k);
   [E,I]= sort(abs(diff));
   Sq(k)=level(I(1));
end
end