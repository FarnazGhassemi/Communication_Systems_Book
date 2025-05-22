%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        GUI for Analog Modulation and Demodulation            %
%                       of Audio Signals                       %
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
%%  This code geneartes a GUI for performing the modulation and 
%    demodulation of audio signals using various techniques, including AM, 
%    DSB, SSB, PM, and FM. It allows users to record a voice by specifying 
%    the desired recording time and process the recorded sound or use a
%    predefined sound (piano recording).
%   
%   GUI Components:
%       Edit Field: To set the time duration for recording.
%       Button (Start Modulation): Initiates the modulation process based 
%        on the previously selected modulation type, then performs 
%        demodulation, and saves the resulting file as "modulation_type.m4a" 
%        in the project folder.
%       Button (Recording): By pressing thid button, the program starts 
%        recording the user's voice for the time specified by the user, 
%        and saves the user's voice file as "voice.m4a" in the project 
%        folder. This file will be used in the next steps of processing.
%       Button (Add Noise): Performs modulation and then demodulation by 
%        adding a Gaussian white noise to the original signal and saves 
%        the file as "Noisy_modulation_type.m4a" in the project folder.
%       Button (Play Input): Plays the recorded audio signal.
%       Button (Play Demodulated Signal): Plays the audio signal after 
%        demodulation (without noise).
%       Button (Play Noisy Demodulated Signal): Plays the audio signal 
%        after demodulation, including the added noise.
%       Button (Close): Closes the GUI window.
%       Axes (Input(t)): Displays the original audio signal in the time 
%        domain.
%       Axes (Input Spectrum): Shows the frequency spectrum of the original
%        audio signal.
%       Axes (Modulated/Noisy Spectrum): Displays the frequency spectrum of 
%        the modulated signal.
%       Axes (Demodulated Spectrum): Displays the frequency spectrum of the 
%         demodulated signal, with or without noise.
%%---------------------------------------------------------------
%%

function varargout = Project(varargin)
% PROJECT MATLAB code for Project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project

% Last Modified by GUIDE v2.5 03-Jun-2019 16:11:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Project is made visible.
function Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project (see VARARGIN)

% Choose default command line output for Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Type=get(handles.popupmenu1,'Value');
m4AFilename = 'voice.m4a';
[Dual_Channel_voice,Fs] = audioread(m4AFilename);
Single_Channel_voice = transpose(Dual_Channel_voice(:,1));
t = 1:length(Single_Channel_voice);
mu = 0.9;
Ac = 3;
fc = 250;
frequency_deviation = 100;
phase_deviation = pi/4;
N=length(Single_Channel_voice);
f1=[0 : N-1];
switch(Type)
    case(1)
      % AM modulation
      AM = Ac .* (1 + mu.*Single_Channel_voice) .* cos(2*pi*fc*t);
      AM_hilbert = imag(hilbert(AM));
      envelop_AM = sqrt(AM_hilbert.^2 + AM.^2)/10;
      AM_Dualband = zeros(length(Single_Channel_voice),2);
      AM_Dualband(:,1) = envelop_AM;
      AM_Dualband(:,2) = envelop_AM;
      AM_File = 'AM.m4a';
      audiowrite(AM_File,AM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_AM = fftshift(fft(AM));
      axes(handles.axes2);
      plot(f1,abs(fft_AM))
      fft_envelop_AM=fftshift(fft(envelop_AM));
      axes(handles.axes3);
      plot(f1,abs(fft_envelop_AM))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
     
    case(2)
      % DSB modulation
      DSB = Ac .* Single_Channel_voice .* cos(2*pi*fc*t);
      [b,a] = butter(5,fc/(3000/2)); % Butterworth filter of order 5
      DSB_Demodulated = 2*filter(b,a,DSB .* cos(2*pi*fc*t))./Ac;
      DSB_Dualband = zeros(length(Single_Channel_voice),2);
      DSB_Dualband(:,1) = DSB_Demodulated;
      DSB_Dualband(:,2) = DSB_Demodulated;
      DSB_File = 'DSB.m4a';
      audiowrite(DSB_File,DSB_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_DSB = fftshift(fft(DSB));
      axes(handles.axes2);
      plot(f1,abs(fft_DSB))
      fft_DSB_Demodulated=fftshift(fft(DSB_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_DSB_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(3)
      % SSB modulation
      Single_Channel_voice_Hilbert = imag(hilbert(Single_Channel_voice));
      SSB = 0.5 .* Ac .* (Single_Channel_voice .* cos(2*pi*fc*t) + Single_Channel_voice_Hilbert .* sin(2*pi*fc*t));
      [b,a] = butter(5,fc/(3000/2)); % Butterworth filter of order 5
      SSB_Demodulated = 4*filter(b,a,SSB .* cos(2*pi*fc*t))./Ac;
      SSB_Dualband = zeros(length(Single_Channel_voice),2);
      SSB_Dualband(:,1) = SSB_Demodulated;
      SSB_Dualband(:,2) = SSB_Demodulated;
      SSB_File = 'SSB.m4a';
      audiowrite(SSB_File,SSB_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_SSB = fftshift(fft(SSB));
      axes(handles.axes2);
      plot(f1,abs(fft_SSB))
      fft_SSB_Demodulated=fftshift(fft(SSB_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_SSB_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
 
    case(4)
      % PM modulation
      PM_1 = Ac*cos(2*pi*fc*t + phase_deviation * Single_Channel_voice);
      PM = pmmod(Single_Channel_voice,fc, 600, phase_deviation);
      PM_Demodulated = pmdemod(PM,fc,600,phase_deviation);
      PM_Dualband = zeros(length(Single_Channel_voice),2);
      PM_Dualband(:,1) = PM_Demodulated;
      PM_Dualband(:,2) = PM_Demodulated;
      PM_File = 'PM.m4a';
      audiowrite(PM_File,PM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_PM = fftshift(fft(PM));
      axes(handles.axes2);
      plot(f1,abs(fft_PM))
      fft_PM_Demodulated=fftshift(fft(PM_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_PM_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(5)
      % FM modulation
      FM_1 = Ac*cos(2*pi*fc*t + 2*pi*frequency_deviation * Single_Channel_voice);
      FM = fmmod(Single_Channel_voice,fc, 600, frequency_deviation);
      FM_Demodulated = fmdemod(FM,fc,600,frequency_deviation);
      FM_Dualband = zeros(length(Single_Channel_voice),2);
      FM_Dualband(:,1) = FM_Demodulated;
      FM_Dualband(:,2) = FM_Demodulated;
      FM_File = 'FM.m4a';
      audiowrite(FM_File,FM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_FM = fftshift(fft(FM));
      axes(handles.axes2);
      plot(f1,abs(fft_FM))
      fft_FM_Demodulated=fftshift(fft(FM_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_FM_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Type=get(handles.popupmenu1,'value');
m4AFilename = 'voice.m4a';
[Dual_Channel_voice,Fs] = audioread(m4AFilename);
Single_Channel_voice = transpose(Dual_Channel_voice(:,1));
t = 1:length(Single_Channel_voice);
mu = 0.9;
Ac = 3;
fc = 250;
frequency_deviation = 100;
phase_deviation = pi/4;
N=length(Single_Channel_voice);
f1=[0 : N-1];
switch(Type)
    case(1)
      % AM modulation
      AM = Ac .* (1 + mu.*Single_Channel_voice) .* cos(2*pi*fc*t);
      noisy_AM = wgn(1, length(Single_Channel_voice), -35) + AM;
      AM_hilbert_noisy = imag(hilbert(noisy_AM));
      envelop_AM_noisy = sqrt(AM_hilbert_noisy.^2 + noisy_AM.^2)/10;
      AM_Dualband = zeros(length(Single_Channel_voice),2);
      AM_Dualband(:,1) = envelop_AM_noisy;
      AM_Dualband(:,2) = envelop_AM_noisy;
      AM_File = 'AM_Noisy.m4a';
      audiowrite(AM_File,AM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_noisy_AM = fftshift(fft(noisy_AM));
      axes(handles.axes2);
      plot(f1,abs(fft_noisy_AM))
      fft_envelop_AM_noisy=fftshift(fft(envelop_AM_noisy));
      axes(handles.axes3);
      plot(f1,abs(fft_envelop_AM_noisy))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(2)
      % DSB modulation
      DSB = Ac .* Single_Channel_voice .* cos(2*pi*fc*t);
      [b,a] = butter(5,fc/(3000/2)); % Butterworth filter of order 5
      noisy_DSB = wgn(1, length(Single_Channel_voice), -30) + DSB;
      DSB_Demodulated = 2*filter(b,a,noisy_DSB .* cos(2*pi*fc*t))./Ac;
      DSB_Dualband = zeros(length(Single_Channel_voice),2);
      DSB_Dualband(:,1) = DSB_Demodulated;
      DSB_Dualband(:,2) = DSB_Demodulated;
      DSB_File = 'DSB_Noisy.m4a';
      audiowrite(DSB_File,DSB_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_noisy_DSB = fftshift(fft(noisy_DSB));
      axes(handles.axes2);
      plot(f1,abs(fft_noisy_DSB))
      fft_DSB_Demodulated=fftshift(fft(DSB_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_DSB_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(3)
      % SSB modulation
      Single_Channel_voice_Hilbert = imag(hilbert(Single_Channel_voice));
      SSB = 0.5 .* Ac .* (Single_Channel_voice .* cos(2*pi*fc*t) + Single_Channel_voice_Hilbert .* sin(2*pi*fc*t));
      [b,a] = butter(5,fc/(3000/2)); % Butterworth filter of order 5
      noisy_SSB = wgn(1, length(Single_Channel_voice), -35) + SSB;
      SSB_Demodulated = 4*filter(b,a,noisy_SSB .* cos(2*pi*fc*t))./Ac;
      SSB_Dualband = zeros(length(Single_Channel_voice),2);
      SSB_Dualband(:,1) = SSB_Demodulated;
      SSB_Dualband(:,2) = SSB_Demodulated;
      SSB_File = 'SSB_Noisy.m4a';
      audiowrite(SSB_File,SSB_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_noisy_SSB = fftshift(fft(noisy_SSB));
      axes(handles.axes2);
      plot(f1,abs(fft_noisy_SSB))
      fft_SSB_Demodulated=fftshift(fft(SSB_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_SSB_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(4)
      % PM modulation
      frequency_deviation = 100;
      phase_deviation = pi/4;
      PM_1 = Ac*cos(2*pi*fc*t + phase_deviation * Single_Channel_voice);
      PM = pmmod(Single_Channel_voice,fc, 600, phase_deviation);
      noisy_PM = wgn(1, length(Single_Channel_voice), -50) + PM;
      PM_Demodulated = pmdemod(noisy_PM,fc,600,phase_deviation);
      PM_Dualband = zeros(length(Single_Channel_voice),2);
      PM_Dualband(:,1) = PM_Demodulated;
      PM_Dualband(:,2) = PM_Demodulated;
      PM_File = 'PM_Noisy.m4a';
      audiowrite(PM_File,PM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_noisy_PM = fftshift(fft(noisy_PM));
      axes(handles.axes2);
      plot(f1,abs(fft_noisy_PM))
      fft_PM_Demodulated=fftshift(fft(PM_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_PM_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
    case(5)
      % FM modulation
      FM_1 = Ac*cos(2*pi*fc*t + 2*pi*frequency_deviation * Single_Channel_voice);
      FM = fmmod(Single_Channel_voice,fc, 600, frequency_deviation);
      noisy_FM = wgn(1, length(Single_Channel_voice), -50) + FM;
      FM_Demodulated = fmdemod(noisy_FM,fc,600,frequency_deviation);
      FM_Dualband = zeros(length(Single_Channel_voice),2);
      FM_Dualband(:,1) = FM_Demodulated;
      FM_Dualband(:,2) = FM_Demodulated;
      FM_File = 'FM_Noisy.m4a';
      audiowrite(FM_File,FM_Dualband,Fs)
      fft_Single_Channel_voice=fftshift(fft(Single_Channel_voice));
      axes(handles.axes1);
      plot(f1,abs(fft_Single_Channel_voice))
      fft_noisy_FM = fftshift(fft(noisy_FM));
      axes(handles.axes2);
      plot(f1,abs(fft_noisy_FM))
      fft_FM_Demodulated=fftshift(fft(FM_Demodulated));
      axes(handles.axes3);
      plot(f1,abs(fft_FM_Demodulated))
      axes(handles.axes5);
      plot(t,Single_Channel_voice)
      
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[a,fs]=audioread('voice.m4a');
sound(a,fs)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Type=get(handles.popupmenu1,'value');
switch(Type)
    case(1)
        [c,fs3]=audioread('AM.m4a');
        sound(c,fs3)
        
    case(2)
        [c,fs3]=audioread('DSB.m4a');
        sound(c,fs3)
        
    case(3)
        [c,fs3]=audioread('SSB.m4a');
        sound(c,fs3)
        
    case(4)
        [c,fs3]=audioread('PM.m4a');
        sound(c,fs3)
        
    case(5)
        [c,fs3]=audioread('FM.m4a');
        sound(c,fs3)
end 


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Type=get(handles.popupmenu1,'value');
switch(Type)
    case(1)
        [d,fs4]=audioread('AM_Noisy.m4a');
        sound(d,fs4)
        
    case(2)
        [d,fs4]=audioread('DSB_Noisy.m4a');
        sound(d,fs4)
        
    case(3)
        [d,fs4]=audioread('SSB_Noisy.m4a');
        sound(d,fs4)
        
    case(4)
        [d,fs4]=audioread('PM_Noisy.m4a');
        sound(d,fs4)
        
    case(5)
        [d,fs4]=audioread('FM_Noisy.m4a');
        sound(d,fs4)
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x=str2double(get(handles.edit1,'String'));
recObj = audiorecorder(48000,16,1)
%disp('Start speaking.')
recordblocking(recObj, x);
%disp('End of Recording.');
myRecording = getaudiodata(recObj);
audiowrite('voice.m4a',myRecording,48000);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
