%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  GUI for Modeling of an analog baseband transmission system  %
%                   in the presence of noise                   %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                  Chapter 3 - Section 3-3                     %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntirely by               %
%   Alireza Saadati as an activity for the related course.     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code creates an interactive Graphical User Interface (GUI) to 
%    simulates the processing of an audio signal through several 
%    stages of communication, such as gain adjustment, channel effects, 
%    noise addition, and filtering while observing the signal in frequency 
%    domain.
%   
%   GUI Components:
%       List Box (First Voice): To select audio signal from three
%        audio files (obama1, obama2, obama3).
%       List Box (Second Voice): To select audio signal from three
%        audio files (obama1, obama2, obama3) that can be mixed with the 
%        first audio signal.
%       Edit Field (First voise gain): Input field to adjust the gain of 
%        the first voice (0 to 1).
%       Edit Field (Second voise gain): Input field to adjust the gain of 
%        the second voice (0 to 1).
%       NOTE : If the interference of signals is not desired,set one of   
%       the gains to zero.
%       Button (Load Signals): Button to load the selected audio signals.
%       Button (Play Audio): Plays the loaded audio signal.
%       List Box (Channels): Allows the user to select a transmission 
%        channel type.
%       Edit Field (Trasmitter Gain): Input field to set transmitter gain.
%       Edit Field (Loss): Input field to set channel loss.
%       Button (Apply Channel): Applies the selected channel effect to
%        the audio signal.
%       Button (Play Distorted Audio): Plays the distorted audio signal 
%        after applying the channel.
%       Slider (Noise): Adjusts the noise level to be added to the signal.
%       Button (Add Noise): Adds noise to the transmitted signal.
%       Button (Play Noisy Audio): Plays the noisy audio signal.
%       Button (Apply Filter): Applies a Low Pass filter to remove noise 
%        from the signal.
%       Button (Play Filtered Audio): Plays the filtered audio signal.
%       UIAxes: A graph for visualizing frequency domain data.
%
%%---------------------------------------------------------------
%%

classdef Audio_Transmission_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        UIAxes2                        matlab.ui.control.UIAxes
        PlayAudioButton                matlab.ui.control.Button
        ChannelsListBoxLabel           matlab.ui.control.Label
        ChannelsListBox                matlab.ui.control.ListBox
        ApplyChannelButton             matlab.ui.control.Button
        TrasmitterGainEditFieldLabel   matlab.ui.control.Label
        TrasmitterGainEditField        matlab.ui.control.NumericEditField
        LossEditFieldLabel             matlab.ui.control.Label
        LossEditField                  matlab.ui.control.NumericEditField
        PlayDistortedAudioButton       matlab.ui.control.Button
        NoiseSliderLabel               matlab.ui.control.Label
        NoiseSlider                    matlab.ui.control.Slider
        AddNoiseButton                 matlab.ui.control.Button
        PlayNoisyAudioButton           matlab.ui.control.Button
        ApplyFilterButton              matlab.ui.control.Button
        PlayFilteredAudioButton        matlab.ui.control.Button
        LoadSignalsButton              matlab.ui.control.Button
        FirstvoisegainEditFieldLabel   matlab.ui.control.Label
        FirstvoisegainEditField        matlab.ui.control.NumericEditField
        SecondvoisegainEditFieldLabel  matlab.ui.control.Label
        SecondvoisegainEditField       matlab.ui.control.NumericEditField
        FirstvoiceListBoxLabel         matlab.ui.control.Label
        FirstvoiceListBox              matlab.ui.control.ListBox
        SecondvoiceListBoxLabel        matlab.ui.control.Label
        SecondvoiceListBox             matlab.ui.control.ListBox
    end

    
    properties (Access = private)
        origialSignal1;
        origialSignal2;
        main;
        frequencySignal;
        Fs;
        tvec;
        fvec;
        loss;
        gainLinear;
        Transmitteroutput;
        channelRespose;
        channelOutput;
        channelOutputFre;
        noise;
        noisySignal;
        tn;
        fn;
        sig_ff;
        filteredSignal;
    end
    

    methods (Access = private)

        % Callback function
        function LoadButtonPushed(app, event)
            
        end

        % Button pushed function: PlayAudioButton
        function PlayAudioButtonPushed(app, event)
            sound(app.main, app.Fs);
        end

        % Value changed function: ChannelsListBox
        function ChannelsListBoxValueChanged(app, event)

        end

        % Button pushed function: ApplyChannelButton
        function ApplyChannelButtonPushed(app, event)
            t = linspace(0,0.5,0.5*app.Fs);
            switch app.ChannelsListBox.Value
                case 'sinc(2pi100t)'
                    app.channelRespose = sinc(2*pi*100*t);
                case 'exp(-2pi5000t)'
                    app.channelRespose = exp(-2*pi*5000*t);
                case 'exp(-2pi1000t)'
                    app.channelRespose = exp(-2*pi*1000*t);
                case '2delta(t)+0.5delta(t+1)'
                    app.channelRespose = [2 zeros(1,0.5*app.Fs) 0.5];
            end
            app.gainLinear = 10^(app.TrasmitterGainEditField.Value / 10);
            app.loss = 0.1^(app.LossEditField.Value / 10);
            app.Transmitteroutput = app.main * app.gainLinear * app.loss;            
            app.channelOutput = conv(app.Transmitteroutput,app.channelRespose,"same");
            app.channelOutputFre = abs(fftshift(fft(app.channelOutput)));
            f = linspace(-app.Fs/4,app.Fs/4,length(app.channelOutputFre));
            plot(app.UIAxes2,f,app.channelOutputFre);

        end

        % Value changed function: TrasmitterGainEditField
        function TrasmitterGainEditFieldValueChanged(app, event)
            value = app.TrasmitterGainEditField.Value;
        end

        % Value changed function: LossEditField
        function LossEditFieldValueChanged(app, event)
            value = app.LossEditField.Value;
        end

        % Button pushed function: PlayDistortedAudioButton
        function PlayDistortedAudioButtonPushed(app, event)
            sound(app.channelOutput,app.Fs);
        end

        % Callback function
        function AddChannelEditFieldValueChanging(app, event)
            
        end

        % Value changing function: NoiseSlider
        function NoiseSliderValueChanging(app, event)
            changingValue = event.Value;
            app.noise = changingValue*randn(size(app.channelOutput));
            app.noisySignal = app.channelOutput + app.noise;
        end

        % Button pushed function: AddNoiseButton
        function AddNoiseButtonPushed(app, event)
            app.tn = linspace(0,length(app.noisySignal)/app.Fs,length(app.noisySignal));
            app.sig_ff = abs(fftshift(fft(app.noisySignal)));
            app.fn = linspace(-app.Fs/2,app.Fs/2,length(app.sig_ff));
            plot(app.UIAxes2,app.fn,app.sig_ff);
        end

        % Button pushed function: PlayNoisyAudioButton
        function PlayNoisyAudioButtonPushed(app, event)
            sound(app.noisySignal,app.Fs);
        end

        % Button pushed function: ApplyFilterButton
        function ApplyFilterButtonPushed(app, event)
            fc = 3000;
            n_order = 3;
            [b,a] = butter(n_order, fc/(app.Fs/2));
            app.filteredSignal = filtfilt(b,a,app.noisySignal);
            sig_filtered_f = abs(fftshift(fft(app.filteredSignal)));
            plot(app.UIAxes2,app.fn,sig_filtered_f);
        end

        % Button pushed function: PlayFilteredAudioButton
        function PlayFilteredAudioButtonPushed(app, event)
            sound(app.filteredSignal,app.Fs);
        end

        % Button pushed function: LoadSignalsButton
        function LoadSignalsButtonPushed(app, event)

            switch app.FirstvoiceListBox.Value
                case 'obama1'
                    [app.origialSignal1,app.Fs] = audioread('obama1.wav');
                case 'obama2'
                    [app.origialSignal1,app.Fs] = audioread('obama2.wav');
                case 'obama3'
                    [app.origialSignal1,app.Fs] = audioread('obama3.wav');
                
                   
            end
            switch app.SecondvoiceListBox.Value
                case 'obama1'
                    [app.origialSignal2,app.Fs] = audioread('obama1.wav');
                case 'obama2'
                    [app.origialSignal2,app.Fs] = audioread('obama2.wav');
                case 'obama3'
                    [app.origialSignal2,app.Fs] = audioread('obama3.wav');
             
            end

            app.main = app.origialSignal1(1:69632) * app.FirstvoisegainEditField.Value + app.origialSignal2(1:69632) * app.SecondvoisegainEditField.Value;
            app.tvec = linspace(0,length(app.main)/app.Fs,length(app.main));
            app.frequencySignal = abs(fftshift(fft(app.main)));
            app.fvec = linspace(-app.Fs/4,app.Fs/4,length(app.frequencySignal));
            plot(app.UIAxes2,app.fvec,app.frequencySignal);
        end

        % Value changed function: FirstvoisegainEditField
        function FirstvoisegainEditFieldValueChanged(app, event)
            value = app.FirstvoisegainEditField.Value;
            
        end

        % Value changed function: SecondvoisegainEditField
        function SecondvoisegainEditFieldValueChanged(app, event)
            value = app.SecondvoisegainEditField.Value;
            
        end

        % Value changed function: FirstvoiceListBox
        function FirstvoiceListBoxValueChanged(app, event)
            value = app.FirstvoiceListBox.Value;
            
        end

        % Value changed function: SecondvoiceListBox
        function SecondvoiceListBoxValueChanged(app, event)
            value = app.SecondvoiceListBox.Value;
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 921 715];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Frequency Domain')
            xlabel(app.UIAxes2, 'Freq (Hz)')
            ylabel(app.UIAxes2, 'Amplitude')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [3 350 921 366];

            % Create PlayAudioButton
            app.PlayAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayAudioButtonPushed, true);
            app.PlayAudioButton.FontWeight = 'bold';
            app.PlayAudioButton.FontColor = [0.851 0.3255 0.098];
            app.PlayAudioButton.Position = [61 203 100 22];
            app.PlayAudioButton.Text = 'Play Audio';

            % Create ChannelsListBoxLabel
            app.ChannelsListBoxLabel = uilabel(app.UIFigure);
            app.ChannelsListBoxLabel.HorizontalAlignment = 'right';
            app.ChannelsListBoxLabel.FontWeight = 'bold';
            app.ChannelsListBoxLabel.FontColor = [0.0745 0.6235 1];
            app.ChannelsListBoxLabel.Position = [414 315 60 22];
            app.ChannelsListBoxLabel.Text = 'Channels';

            % Create ChannelsListBox
            app.ChannelsListBox = uilistbox(app.UIFigure);
            app.ChannelsListBox.Items = {'sinc(2pi100t)', 'exp(-2pi5000t)', 'exp(-2pi1000t)', '2delta(t)+0.5delta(t+1)'};
            app.ChannelsListBox.ValueChangedFcn = createCallbackFcn(app, @ChannelsListBoxValueChanged, true);
            app.ChannelsListBox.FontWeight = 'bold';
            app.ChannelsListBox.FontColor = [0.0745 0.6235 1];
            app.ChannelsListBox.Position = [489 246 156 93];
            app.ChannelsListBox.Value = 'sinc(2pi100t)';

            % Create ApplyChannelButton
            app.ApplyChannelButton = uibutton(app.UIFigure, 'push');
            app.ApplyChannelButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyChannelButtonPushed, true);
            app.ApplyChannelButton.FontWeight = 'bold';
            app.ApplyChannelButton.FontColor = [0.0745 0.6235 1];
            app.ApplyChannelButton.Position = [449 125 100 22];
            app.ApplyChannelButton.Text = 'Apply Channel';

            % Create TrasmitterGainEditFieldLabel
            app.TrasmitterGainEditFieldLabel = uilabel(app.UIFigure);
            app.TrasmitterGainEditFieldLabel.HorizontalAlignment = 'right';
            app.TrasmitterGainEditFieldLabel.FontWeight = 'bold';
            app.TrasmitterGainEditFieldLabel.FontColor = [0.0745 0.6235 1];
            app.TrasmitterGainEditFieldLabel.Position = [441 161 94 22];
            app.TrasmitterGainEditFieldLabel.Text = 'Trasmitter Gain';

            % Create TrasmitterGainEditField
            app.TrasmitterGainEditField = uieditfield(app.UIFigure, 'numeric');
            app.TrasmitterGainEditField.ValueChangedFcn = createCallbackFcn(app, @TrasmitterGainEditFieldValueChanged, true);
            app.TrasmitterGainEditField.FontWeight = 'bold';
            app.TrasmitterGainEditField.FontColor = [0.0745 0.6235 1];
            app.TrasmitterGainEditField.Position = [541 161 100 22];
            app.TrasmitterGainEditField.Value = 1;

            % Create LossEditFieldLabel
            app.LossEditFieldLabel = uilabel(app.UIFigure);
            app.LossEditFieldLabel.HorizontalAlignment = 'right';
            app.LossEditFieldLabel.FontWeight = 'bold';
            app.LossEditFieldLabel.FontColor = [0.0745 0.6235 1];
            app.LossEditFieldLabel.Position = [448 203 34 22];
            app.LossEditFieldLabel.Text = 'Loss';

            % Create LossEditField
            app.LossEditField = uieditfield(app.UIFigure, 'numeric');
            app.LossEditField.ValueChangedFcn = createCallbackFcn(app, @LossEditFieldValueChanged, true);
            app.LossEditField.FontWeight = 'bold';
            app.LossEditField.FontColor = [0.0745 0.6235 1];
            app.LossEditField.Position = [497 203 149 22];

            % Create PlayDistortedAudioButton
            app.PlayDistortedAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayDistortedAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayDistortedAudioButtonPushed, true);
            app.PlayDistortedAudioButton.FontWeight = 'bold';
            app.PlayDistortedAudioButton.FontColor = [0.0745 0.6235 1];
            app.PlayDistortedAudioButton.Position = [450 90 133 22];
            app.PlayDistortedAudioButton.Text = 'Play Distorted Audio';

            % Create NoiseSliderLabel
            app.NoiseSliderLabel = uilabel(app.UIFigure);
            app.NoiseSliderLabel.HorizontalAlignment = 'right';
            app.NoiseSliderLabel.FontWeight = 'bold';
            app.NoiseSliderLabel.FontColor = [1 0.0745 0.651];
            app.NoiseSliderLabel.Position = [688 326 38 22];
            app.NoiseSliderLabel.Text = 'Noise';

            % Create NoiseSlider
            app.NoiseSlider = uislider(app.UIFigure);
            app.NoiseSlider.Limits = [0.01 10];
            app.NoiseSlider.MajorTicks = [0.01 2 4 6 8 10];
            app.NoiseSlider.ValueChangingFcn = createCallbackFcn(app, @NoiseSliderValueChanging, true);
            app.NoiseSlider.FontWeight = 'bold';
            app.NoiseSlider.FontColor = [1 0.0745 0.651];
            app.NoiseSlider.Position = [747 335 150 3];
            app.NoiseSlider.Value = 0.01;

            % Create AddNoiseButton
            app.AddNoiseButton = uibutton(app.UIFigure, 'push');
            app.AddNoiseButton.ButtonPushedFcn = createCallbackFcn(app, @AddNoiseButtonPushed, true);
            app.AddNoiseButton.FontWeight = 'bold';
            app.AddNoiseButton.FontColor = [1 0.0745 0.651];
            app.AddNoiseButton.Position = [670 241 100 22];
            app.AddNoiseButton.Text = 'Add Noise';

            % Create PlayNoisyAudioButton
            app.PlayNoisyAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayNoisyAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayNoisyAudioButtonPushed, true);
            app.PlayNoisyAudioButton.FontWeight = 'bold';
            app.PlayNoisyAudioButton.FontColor = [1 0.0745 0.651];
            app.PlayNoisyAudioButton.Position = [786 241 113 22];
            app.PlayNoisyAudioButton.Text = 'Play Noisy Audio';

            % Create ApplyFilterButton
            app.ApplyFilterButton = uibutton(app.UIFigure, 'push');
            app.ApplyFilterButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyFilterButtonPushed, true);
            app.ApplyFilterButton.FontWeight = 'bold';
            app.ApplyFilterButton.FontColor = [1 0.0745 0.651];
            app.ApplyFilterButton.Position = [671 203 100 22];
            app.ApplyFilterButton.Text = 'Apply Filter';

            % Create PlayFilteredAudioButton
            app.PlayFilteredAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayFilteredAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayFilteredAudioButtonPushed, true);
            app.PlayFilteredAudioButton.FontWeight = 'bold';
            app.PlayFilteredAudioButton.FontColor = [1 0.0745 0.651];
            app.PlayFilteredAudioButton.Position = [786 203 124 22];
            app.PlayFilteredAudioButton.Text = 'Play Filtered Audio';

            % Create LoadSignalsButton
            app.LoadSignalsButton = uibutton(app.UIFigure, 'push');
            app.LoadSignalsButton.ButtonPushedFcn = createCallbackFcn(app, @LoadSignalsButtonPushed, true);
            app.LoadSignalsButton.FontWeight = 'bold';
            app.LoadSignalsButton.FontColor = [0.851 0.3255 0.098];
            app.LoadSignalsButton.Position = [60 241 100 22];
            app.LoadSignalsButton.Text = 'Load Signals';

            % Create FirstvoisegainEditFieldLabel
            app.FirstvoisegainEditFieldLabel = uilabel(app.UIFigure);
            app.FirstvoisegainEditFieldLabel.HorizontalAlignment = 'right';
            app.FirstvoisegainEditFieldLabel.FontWeight = 'bold';
            app.FirstvoisegainEditFieldLabel.FontColor = [1 0.0745 0.651];
            app.FirstvoisegainEditFieldLabel.Position = [8 319 94 22];
            app.FirstvoisegainEditFieldLabel.Text = 'First voise gain';

            % Create FirstvoisegainEditField
            app.FirstvoisegainEditField = uieditfield(app.UIFigure, 'numeric');
            app.FirstvoisegainEditField.Limits = [0 1];
            app.FirstvoisegainEditField.ValueChangedFcn = createCallbackFcn(app, @FirstvoisegainEditFieldValueChanged, true);
            app.FirstvoisegainEditField.FontWeight = 'bold';
            app.FirstvoisegainEditField.FontColor = [1 0.0745 0.651];
            app.FirstvoisegainEditField.Position = [117 319 100 22];
            app.FirstvoisegainEditField.Value = 1;

            % Create SecondvoisegainEditFieldLabel
            app.SecondvoisegainEditFieldLabel = uilabel(app.UIFigure);
            app.SecondvoisegainEditFieldLabel.HorizontalAlignment = 'right';
            app.SecondvoisegainEditFieldLabel.FontWeight = 'bold';
            app.SecondvoisegainEditFieldLabel.FontColor = [0.851 0.3255 0.098];
            app.SecondvoisegainEditFieldLabel.Position = [3 285 111 22];
            app.SecondvoisegainEditFieldLabel.Text = 'Second voise gain';

            % Create SecondvoisegainEditField
            app.SecondvoisegainEditField = uieditfield(app.UIFigure, 'numeric');
            app.SecondvoisegainEditField.Limits = [0 1];
            app.SecondvoisegainEditField.ValueChangedFcn = createCallbackFcn(app, @SecondvoisegainEditFieldValueChanged, true);
            app.SecondvoisegainEditField.FontColor = [0.851 0.3255 0.098];
            app.SecondvoisegainEditField.Position = [129 285 100 22];

            % Create FirstvoiceListBoxLabel
            app.FirstvoiceListBoxLabel = uilabel(app.UIFigure);
            app.FirstvoiceListBoxLabel.HorizontalAlignment = 'right';
            app.FirstvoiceListBoxLabel.FontWeight = 'bold';
            app.FirstvoiceListBoxLabel.FontColor = [0.851 0.3255 0.098];
            app.FirstvoiceListBoxLabel.Position = [231 317 66 22];
            app.FirstvoiceListBoxLabel.Text = 'First voice';

            % Create FirstvoiceListBox
            app.FirstvoiceListBox = uilistbox(app.UIFigure);
            app.FirstvoiceListBox.Items = {'obama1', 'obama2', 'obama3'};
            app.FirstvoiceListBox.ValueChangedFcn = createCallbackFcn(app, @FirstvoiceListBoxValueChanged, true);
            app.FirstvoiceListBox.FontWeight = 'bold';
            app.FirstvoiceListBox.FontColor = [0.851 0.3255 0.098];
            app.FirstvoiceListBox.Position = [312 267 100 74];
            app.FirstvoiceListBox.Value = 'obama1';

            % Create SecondvoiceListBoxLabel
            app.SecondvoiceListBoxLabel = uilabel(app.UIFigure);
            app.SecondvoiceListBoxLabel.HorizontalAlignment = 'right';
            app.SecondvoiceListBoxLabel.FontWeight = 'bold';
            app.SecondvoiceListBoxLabel.FontColor = [0.851 0.3255 0.098];
            app.SecondvoiceListBoxLabel.Position = [213 232 83 22];
            app.SecondvoiceListBoxLabel.Text = 'Second voice';

            % Create SecondvoiceListBox
            app.SecondvoiceListBox = uilistbox(app.UIFigure);
            app.SecondvoiceListBox.Items = {'obama1', 'obama2', 'obama3'};
            app.SecondvoiceListBox.ValueChangedFcn = createCallbackFcn(app, @SecondvoiceListBoxValueChanged, true);
            app.SecondvoiceListBox.FontWeight = 'bold';
            app.SecondvoiceListBox.FontColor = [0.851 0.3255 0.098];
            app.SecondvoiceListBox.Position = [311 182 100 74];
            app.SecondvoiceListBox.Value = 'obama1';
        end
    end

    methods (Access = public)

        % Construct app
        function app = Audio_Transmission_GUI

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end