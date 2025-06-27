%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            GUI for Simulating Matched Filter Response        %
%                   In The Presence Of Noise                   %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 10 - Section                       %
%                                                              %
%                                                              %
%   Version1:             03/03/30                             %
%   The first version Contributed voluntarily by               %
%   Arsalan Abdalvand as an activity for the related course.   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code is designed to simulate the effect of a matched filter on 
%    received signals in the presence of Gaussian noise. The input signal 
%    consists of a combination of positive and negative pulses, which are
%    mixed with noise at a specified Signal-to-Noise Ratio (SNR). 
%    The matched filter is used to detect and extract the desired signal 
%    from the noisy data.
%
%   GUI Components:
%       Input Signal Selection: Users can choose from various signal types,
%        including square, sinusoidal, sinc, triangular, and right-angled 
%        triangular pulses.
%       Adding Gaussian Noise: Noise is added to the received signal to 
%         simulate real-world conditions.
%       Adjustable Parameters:
%           Position of positive and negative pulses
%           Pulse width (T)
%           Signal frequency (for sinusoidal signals)
%           Signal-to-Noise Ratio (SNR)
%           Animation speed and rate of changes in the simulation
%   Outputs:
%       Noisy Received Signal Plot: The original signal combined with noise
%        is displayed in real-time.
%       Shifted Matched Filter Plot: The position of the matched filter 
%        relative to the input signal is visualized.
%       Matched Filter Output Plot: The filter's response, representing 
%        the time-domain convolution between the noisy signal and 
%        the matched filter, is computed and displayed.
%   
%%---------------------------------------------------------------
%%
classdef Sim_10_1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        rAmpSlider            matlab.ui.control.Slider
        rAmpSliderLabel       matlab.ui.control.Label
        AnimateSlider_3       matlab.ui.control.Slider
        AnimateSlider_3Label  matlab.ui.control.Label
        pulseSlider           matlab.ui.control.Slider
        pulseSliderLabel      matlab.ui.control.Label
        SNREditField          matlab.ui.control.EditField
        SNREditFieldLabel     matlab.ui.control.Label
        FreqEditField         matlab.ui.control.EditField
        FreqEditFieldLabel    matlab.ui.control.Label
        TEditField            matlab.ui.control.EditField
        TEditFieldLabel       matlab.ui.control.Label
        pulseSlider_2         matlab.ui.control.Slider
        pulseSlider_2Label    matlab.ui.control.Label
        signalDropDown        matlab.ui.control.DropDown
        signalDropDownLabel   matlab.ui.control.Label
        UIAxes_5              matlab.ui.control.UIAxes
        UIAxes_4              matlab.ui.control.UIAxes
        UIAxes_3              matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        Signal  %% basic waveform of a pulse
        RSn     %% Input signal + Noise
        step    %% Step size for waveforms, plots, ...
        itr     %% Iteration Counter / How many times the loop function is called
        ti      %% Timer 
        t       %% Time vector
        h       %% plot
        Shift   %% used as a buffer for shifting the signal and convolution 
        Output  %% matched filter output
        h2      %% plot 2
        ts      %% Size of the time vector
        litr    %% To save the last teration Counter's value
        lout    %% To save the last output of the matched filter (used for interpolation)
    end
    
    methods (Access = private)
        
        function results = main(app)
            app.FreqEditField.Enable = 'off';       
            app.FreqEditFieldLabel.Enable = 'off';
            app.step=0.05;   %% set step size
            
            app.t=-10:app.step:10; %% Create time vector
            app.ts=size(app.t,2); %% get size of time vector
            
            switch app.signalDropDown.Value
                case 'Square'
                    app.Signal=rectpuls(app.t-str2num(app.TEditField.Value)/2,str2num(app.TEditField.Value)); %% make rectangular pulse
                case 'Triangle'
                    app.Signal=tripuls(app.t-str2num(app.TEditField.Value)/2,str2num(app.TEditField.Value)); %% make triangular pulse
                case 'Right Triangle'
                    app.Signal=tripuls(app.t-str2num(app.TEditField.Value)/2,str2num(app.TEditField.Value),-0.99); %% make right triangle pulse
                case 'Sinc'
                    app.Signal=sinc(app.t/(0.5*str2num(app.TEditField.Value))-1); %% make sinc pulse
                case 'Sine'
                    app.FreqEditField.Enable = 'on';
                    app.FreqEditFieldLabel.Enable = 'on';
                    app.Signal=rectpuls(app.t-str2num(app.TEditField.Value)/2,str2num(app.TEditField.Value)).*sin(2*pi*str2num(app.FreqEditField.Value)*app.t);  %% make limited sine pulse 
            end 

            RS=(circshift(app.Signal,int32(app.pulseSlider_2.Value/app.step))-circshift(app.Signal,int32(app.pulseSlider.Value/app.step)))*app.rAmpSlider.Value; %% shift and create a + and a - pulse for demonstration
            app.RSn=awgn(RS,str2num(app.SNREditField.Value),'measured'); %% add White Gussian Noise to the signal
            
            plot(app.UIAxes_4,app.t,app.RSn,'r-'); %% plotting
            hold(app.UIAxes_4,'on')
            plot(app.UIAxes_4,app.t,RS,'k--','LineWidth',1);
            hold(app.UIAxes_4,'off')
            app.itr=1;
            
            n=int32((-10-str2num(app.TEditField.Value))/app.step); %% shift to the start of the convolution
            app.Shift = circshift(app.Signal,n);
            if n>0
                app.Shift(1:n) = 0
            else
                app.Shift(end+n+1:end) = 0
            end

            app.h=plot(app.UIAxes_5,app.t,app.Shift,'r-'); %% plotting shifted pulse
            %linkdata on
            app.Output=zeros(1,size(app.t,2)); %% create empty output vector
            app.h2=plot(app.UIAxes_3,app.t,app.Output,'r-'); %% plotting output
            app.litr=1;
            app.lout=0;
        end
        
        function results = loop(app)
            n=int32((-10-str2num(app.TEditField.Value))/app.step)+app.itr; %% shift to the start of the convolution + itr frames
            app.Shift = circshift(app.Signal,n);
            if n>0
                app.Shift(1:n) = 0
            else
                app.Shift(end+n+1:end) = 0
            end
            
            set(app.h,'YData',app.Shift); %% update shifted plot
            
            out=trapz(app.t,app.RSn.*app.Shift); %% integrate for convolution
            app.Output(app.litr:app.itr)=linspace(app.lout,out,app.itr-app.litr+1); %% linear interpolation to increase the speed 
            app.lout=out;
            set(app.h2,'YData',app.Output); %% update output plot

            app.litr=app.itr; %% save iteration counter for next loop -> used in interpolation
            app.itr=app.itr+int32(10*app.AnimateSlider_3.Value); %% increase iteration counter for next loop // skip some iterations to increase the speed 
            if app.itr > (app.ts) %% if iteration counter is larger than time vector size it's the end of the cycle
                app.itr=1;
                pause(4);  %% pause at the end of the cycle
                app.Output=zeros(1,size(app.t,2)); %% reset output
            end
            
            
        end

    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.ti = timer;
            main(app);
            app.ti.TimerFcn = @(~,thisEvent)loop(app);
            app.ti.ExecutionMode = 'fixedRate';
            app.ti.Period=0.2;
            start(app.ti)  %% set and start the timer
           
        end

        % Value changed function: signalDropDown
        function signalDropDownValueChanged(app, event)
            value = app.signalDropDown.Value;
            main(app);
           
        end

        % Value changed function: TEditField
        function TEditFieldValueChanged(app, event)
            value = app.TEditField.Value;
            main(app);
            
        end

        % Value changed function: FreqEditField
        function FreqEditFieldValueChanged(app, event)
            value = app.FreqEditField.Value;
            main(app);
            
        end

        % Value changed function: SNREditField
        function SNREditFieldValueChanged(app, event)
            value = app.SNREditField.Value;
            main(app);
            
        end

        % Value changed function: pulseSlider
        function pulseSliderValueChanged(app, event)
            value = app.pulseSlider.Value;
            main(app);
        end

        % Value changed function: pulseSlider_2
        function pulseSlider_2ValueChanged(app, event)
            value = app.pulseSlider_2.Value;
            main(app);
        end

        % Value changed function: AnimateSlider_3
        function AnimateSlider_3ValueChanged(app, event)
            value = app.AnimateSlider_3.Value;
            main(app);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app.ti) %% delete the timer and exit
            delete(app)
            
        end

        % Value changed function: rAmpSlider
        function rAmpSliderValueChanged(app, event)
            value = app.rAmpSlider.Value;
            main(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 932 645];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.UIFigure);
            title(app.UIAxes_3, 'Match filter Output')
            xlabel(app.UIAxes_3, 'time')
            ylabel(app.UIAxes_3, 'amp')
            zlabel(app.UIAxes_3, 'Z')
            app.UIAxes_3.XGrid = 'on';
            app.UIAxes_3.YGrid = 'on';
            app.UIAxes_3.Position = [18 21 607 204];

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.UIFigure);
            title(app.UIAxes_4, 'Recieved Signal')
            xlabel(app.UIAxes_4, 'time')
            ylabel(app.UIAxes_4, 'amp')
            zlabel(app.UIAxes_4, 'Z')
            app.UIAxes_4.XGrid = 'on';
            app.UIAxes_4.YGrid = 'on';
            app.UIAxes_4.Position = [18 224 607 203];

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.UIFigure);
            title(app.UIAxes_5, 'Matched filter Shift')
            xlabel(app.UIAxes_5, 'time')
            ylabel(app.UIAxes_5, 'amp')
            zlabel(app.UIAxes_5, 'Z')
            app.UIAxes_5.XGrid = 'on';
            app.UIAxes_5.YGrid = 'on';
            app.UIAxes_5.Position = [17 426 608 203];

            % Create signalDropDownLabel
            app.signalDropDownLabel = uilabel(app.UIFigure);
            app.signalDropDownLabel.HorizontalAlignment = 'right';
            app.signalDropDownLabel.Position = [666 582 36 22];
            app.signalDropDownLabel.Text = 'signal';

            % Create signalDropDown
            app.signalDropDown = uidropdown(app.UIFigure);
            app.signalDropDown.Items = {'Square', 'Triangle', 'Right Triangle', 'Sinc', 'Sine'};
            app.signalDropDown.ValueChangedFcn = createCallbackFcn(app, @signalDropDownValueChanged, true);
            app.signalDropDown.Position = [717 582 100 22];
            app.signalDropDown.Value = 'Square';

            % Create pulseSlider_2Label
            app.pulseSlider_2Label = uilabel(app.UIFigure);
            app.pulseSlider_2Label.HorizontalAlignment = 'right';
            app.pulseSlider_2Label.Position = [657 287 38 22];
            app.pulseSlider_2Label.Text = '-pulse';

            % Create pulseSlider_2
            app.pulseSlider_2 = uislider(app.UIFigure);
            app.pulseSlider_2.Limits = [-10 10];
            app.pulseSlider_2.ValueChangedFcn = createCallbackFcn(app, @pulseSlider_2ValueChanged, true);
            app.pulseSlider_2.Position = [716 296 183 3];
            app.pulseSlider_2.Value = -3.33;

            % Create TEditFieldLabel
            app.TEditFieldLabel = uilabel(app.UIFigure);
            app.TEditFieldLabel.HorizontalAlignment = 'right';
            app.TEditFieldLabel.Position = [666 537 25 22];
            app.TEditFieldLabel.Text = 'T';

            % Create TEditField
            app.TEditField = uieditfield(app.UIFigure, 'text');
            app.TEditField.ValueChangedFcn = createCallbackFcn(app, @TEditFieldValueChanged, true);
            app.TEditField.Position = [706 537 113 22];
            app.TEditField.Value = '2';

            % Create FreqEditFieldLabel
            app.FreqEditFieldLabel = uilabel(app.UIFigure);
            app.FreqEditFieldLabel.HorizontalAlignment = 'right';
            app.FreqEditFieldLabel.Enable = 'off';
            app.FreqEditFieldLabel.Position = [659 426 33 22];
            app.FreqEditFieldLabel.Text = 'Freq.';

            % Create FreqEditField
            app.FreqEditField = uieditfield(app.UIFigure, 'text');
            app.FreqEditField.ValueChangedFcn = createCallbackFcn(app, @FreqEditFieldValueChanged, true);
            app.FreqEditField.Enable = 'off';
            app.FreqEditField.Position = [707 426 113 22];
            app.FreqEditField.Value = '1';

            % Create SNREditFieldLabel
            app.SNREditFieldLabel = uilabel(app.UIFigure);
            app.SNREditFieldLabel.HorizontalAlignment = 'right';
            app.SNREditFieldLabel.Position = [662 481 30 22];
            app.SNREditFieldLabel.Text = 'SNR';

            % Create SNREditField
            app.SNREditField = uieditfield(app.UIFigure, 'text');
            app.SNREditField.ValueChangedFcn = createCallbackFcn(app, @SNREditFieldValueChanged, true);
            app.SNREditField.Position = [707 481 113 22];
            app.SNREditField.Value = '2';

            % Create pulseSliderLabel
            app.pulseSliderLabel = uilabel(app.UIFigure);
            app.pulseSliderLabel.HorizontalAlignment = 'right';
            app.pulseSliderLabel.Position = [657 359 41 22];
            app.pulseSliderLabel.Text = '+pulse';

            % Create pulseSlider
            app.pulseSlider = uislider(app.UIFigure);
            app.pulseSlider.Limits = [-10 10];
            app.pulseSlider.ValueChangedFcn = createCallbackFcn(app, @pulseSliderValueChanged, true);
            app.pulseSlider.Position = [719 368 180 3];
            app.pulseSlider.Value = 3.33;

            % Create AnimateSlider_3Label
            app.AnimateSlider_3Label = uilabel(app.UIFigure);
            app.AnimateSlider_3Label.HorizontalAlignment = 'right';
            app.AnimateSlider_3Label.Position = [666 158 49 22];
            app.AnimateSlider_3Label.Text = 'Animate';

            % Create AnimateSlider_3
            app.AnimateSlider_3 = uislider(app.UIFigure);
            app.AnimateSlider_3.Limits = [0 1];
            app.AnimateSlider_3.ValueChangedFcn = createCallbackFcn(app, @AnimateSlider_3ValueChanged, true);
            app.AnimateSlider_3.Position = [736 167 167 3];
            app.AnimateSlider_3.Value = 0.5;

            % Create rAmpSliderLabel
            app.rAmpSliderLabel = uilabel(app.UIFigure);
            app.rAmpSliderLabel.HorizontalAlignment = 'right';
            app.rAmpSliderLabel.Position = [666 218 34 22];
            app.rAmpSliderLabel.Text = 'rAmp';

            % Create rAmpSlider
            app.rAmpSlider = uislider(app.UIFigure);
            app.rAmpSlider.Limits = [0 5];
            app.rAmpSlider.ValueChangedFcn = createCallbackFcn(app, @rAmpSliderValueChanged, true);
            app.rAmpSlider.Position = [721 227 182 3];
            app.rAmpSlider.Value = 1;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Sim_10_1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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