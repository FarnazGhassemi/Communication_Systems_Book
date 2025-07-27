%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           GUI for Comparison of Delta Modulation             %
%                and Adaptive Delta Modulation                 %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                  Chapter 10 - Section 10-2                   %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntirely by Fatemeh       %
%   Yazdani as an activity for the related course.             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code generates a graphical user-interface (GUI) that allows users 
%    to compare Delta Modulation (DM) and Adaptive Delta Modulation (ADM) 
%    techniques for an input signal. Users can import or generate a sample 
%    signal, apply noise, and analyze the modulation and demodulation 
%    results through plots.
%   
%   Functions:
%       [encoded, pred] = delta_mod(data, delta) Implements a basic Delta 
%       Modulation algorithm. It encodes an input signal (data) into a binary 
%       sequence (encoded) and generates a predicted signal (pred) using a 
%       specified step size (delta).
%   
%       demod = delta_mod_demod(encoded, delta, f, fs) Implements the 
%       demodulation process for a signal encoded using Delta Modulation. 
%       It takes in a binary modulated signal and reconstructs the original 
%        analog signal by applying an accumulator and a low-pass filter for 
%       interpolation.
%
%       [y, pred] = adm_modulator(x, delta, k) Implements an Adaptive Delta 
%       Modulation (ADM) system using the Jayant Algorithm, which adapts 
%       the step size (Delta) dynamically based on the input signal 
%       characteristics to improve performance.
%
%       [z] = adm_demodulator(y, delta, k, f, Fs) Implements the Adaptive Delta
%       Modulation (ADM) Demodulator, which reconstructs the analog signal 
%       from its binary modulated form using the Jayant Algorithm. It adapts
%       the step size (delta) dynamically to improve signal reconstruction accuracy.
%
%    GUI Properties:
%       Two UIAxes: Display plots for modulation and demodulation comparisons.
%       - Zoom & grid has been enabled for both axes.
%       Check Box (Noise): Toggle to add noise to the input signal.
%       Edit Field (Delta): Field to adjust step size (Delta).
%       Edit Field (K): Field to adjust ADM modifier factor (K).
%       Edit Field (Input Signal): Displays the current input signal name.
%        Note: One CANNOT enter an signal function through this field.
%       Edit Field (Fs): Set sampling frequency.
%       Edit Field (f): Set the frequency of the example input signal. It is used
%        as the cutoff frecuency for lowpass filters used in demodulation
%        process.
%       Button (Example): Generates a sample sinusoidal-exponential signal
%        for quick testing.
%       Button (Import): Button to import a signal.
%       Drop Down (Modulation): Dropdown to select between DM and ADM.
%       Button (Run): Executes modulation and demodulation processes.
%       Button (Export): Button to export the results of predicted and 
%        demodulated signals into Workspace.
%
%%---------------------------------------------------------------
%%

classdef DeltaModulationApp_mfile < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        ExapleInput5sin2piftexptLabel  matlab.ui.control.Label
        PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel  matlab.ui.control.Label
        fEditField                     matlab.ui.control.NumericEditField
        fEditFieldLabel                matlab.ui.control.Label
        FsEditField                    matlab.ui.control.NumericEditField
        FsEditFieldLabel               matlab.ui.control.Label
        ModulationDropDown             matlab.ui.control.DropDown
        ModulationDropDownLabel        matlab.ui.control.Label
        ExampleButton                  matlab.ui.control.Button
        RunButton                      matlab.ui.control.Button
        ImportButton                   matlab.ui.control.Button
        ExportButton_2                 matlab.ui.control.Button
        ExportButton                   matlab.ui.control.Button
        InputSignalEditField           matlab.ui.control.EditField
        KEditField                     matlab.ui.control.NumericEditField
        KEditFieldLabel                matlab.ui.control.Label
        DeltaEditField                 matlab.ui.control.NumericEditField
        DeltaEditFieldLabel            matlab.ui.control.Label
        NoiseCheckBox                  matlab.ui.control.CheckBox
        UIAxes2                        matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
    end

   
    properties (Access = private)
        S               % input signal
        f=2;            % input signal frequency
        Fs=50;          % sampling frequency
        t               % time vector
        Delta=1;        % step size
        K=2             % Delta modifier for ADM
        predict         % prediction output of Modulation
        demod           % demodulation output
        
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: NoiseCheckBox
        function NoiseCheckBoxValueChanged(app, event)
            value = app.NoiseCheckBox.Value;
        end

        % Button pushed function: ImportButton
        function ImportButtonPushed(app, event)
            % getting input from user
            [file, path] = uigetfile('*.mat', 'Select Signal File');
            if isequal(file, 0)
                disp('User selected Cancel');
            else
                % loading and reading input
                signalData = load(fullfile(path, file));
                signalName = fieldnames(signalData);
                app.S = signalData.(signalName{1});
        
                len = length(app.S);                   % length of input signal
                app.t = linspace(0, len/app.Fs, len);  % time vector
                app.InputSignalEditField.Value = signalName{1};
                
            end
            figure(app.UIFigure);
        end

        % Value changed function: InputSignalEditField
        function InputSignalEditFieldValueChanged(app, event)
            value = app.InputSignalEditField.Value;
        end

        % Button pushed function: ExampleButton
        function ExampleButtonPushed(app, event)
            %Sin*exp function
            len = 500;                      % length of signal
            app.t = linspace(0, 10, len);   % time vector
            app.Fs = 50;                    % sampling frequency
            amp = 5;                        % amplitude of signal
            app.f = 2;                      % frequency of signal
            app.S = amp*sin(2*pi*app.f*app.t).*exp(-app.t);
            app.Delta = 1;
            app.InputSignalEditField.Value = "5*sin(2*pi*2t).*exp(-t)";
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
                        
            x = app.S;
            delta = app.Delta;
            k = app.K;
            
            % Adding Noise
            ckb = app.NoiseCheckBox.Value;
            if (ckb == 1) 
                x = x + 0.05*randn(size(x));
            else
                x = app.S;
            end
            
            % Delta Modulation
            [dm_out, dm_pred] = delta_mod(x, delta);

            % Demodulation
            dm_demod = delta_mod_demod(dm_out, delta, app.f, app.Fs);

            
            % ADM - Jayant Algorithm
            [adm_out, adm_pred] = adm_modulator(x, delta, app.K);

            % Demodulation
            adm_demod = adm_demodulator(adm_out, delta, app.K, app.f, app.Fs);
            
            val = app.ModulationDropDown.Value;
            if (strcmpi(val,'DM')==1)
                
                app.predict = dm_pred;
                app.demod = dm_demod;
                
                
                % plotting Delta Modulation
                plot(app.UIAxes, app.t, x,'b', 'LineWidth', 2); % plot input
                hold(app.UIAxes, 'on');
                stairs(app.UIAxes, app.t, dm_pred,'r', 'LineWidth', 1); % plot DM pred
                legend(app.UIAxes, 'Input', 'DM predicted');
                grid(app.UIAxes, 'on');     % enable grid
                zoom(app.UIAxes, 'on');     % enable zoom
                hold(app.UIAxes, 'off');

                %Input and Demodulation Comparison
                plot(app.UIAxes2, app.t, x,'b', 'LineWidth', 2); % plot input
                hold(app.UIAxes2, 'on');
                plot(app.UIAxes2, app.t, dm_demod,'color', [56/255,166/255,165/255], 'LineWidth', 2); % plot DM dem
                legend(app.UIAxes2, 'Input', 'Demodulation');
                grid(app.UIAxes2, 'on');    % enable grid
                zoom(app.UIAxes2, 'on');    % enable zoom
                hold(app.UIAxes2, 'off');

            else
                
                app.predict = adm_pred;    % assigning outputs for ExportButton
                app.demod = adm_demod;  % assigning outputs for ExportButton2
                
                % plotting ADM
                plot(app.UIAxes, app.t, x,'b', 'LineWidth', 2); % plot imput
                hold(app.UIAxes, 'on');
                stairs(app.UIAxes, app.t, adm_pred','r', 'LineWidth', 1); % plot ADM pred
                legend(app.UIAxes, 'Input', 'ADM predicted');
                grid(app.UIAxes, 'on');     % sets the grid on
                zoom(app.UIAxes, 'on');     % enable zoom
                hold(app.UIAxes, 'off');

                %Input and Demodulation Comparison
                plot(app.UIAxes2, app.t, x,'b', 'LineWidth', 2); % plot input
                hold(app.UIAxes2, 'on');                
                plot(app.UIAxes2, app.t, adm_demod,'color', [56/255,166/255,165/255], 'LineWidth', 2); %plot ADM dem
                legend(app.UIAxes2, 'Input', 'Demodulation');
                grid(app.UIAxes2, 'on');    % enbale grid
                zoom(app.UIAxes2, 'on');    % enable zoom
                hold(app.UIAxes2, 'off');                
            end
        end

        % Value changed function: ModulationDropDown
        function ModulationDropDownValueChanged(app, event)
            value = app.ModulationDropDown.Value;
        end

        % Value changed function: FsEditField
        function FsEditFieldValueChanged(app, event)
            value = app.FsEditField.Value;
            app.Fs = app.FsEditField.Value;
        end

        % Value changed function: fEditField
        function fEditFieldValueChanged(app, event)
            value = app.fEditField.Value;
            app.f = app.fEditField.Value;
        end

        % Value changed function: DeltaEditField
        function DeltaEditFieldValueChanged(app, event)
            value = app.DeltaEditField.Value;
            app.Delta = app.DeltaEditField.Value;
        end

        % Value changed function: KEditField
        function KEditFieldValueChanged(app, event)
            value = app.KEditField.Value;
            app.K =app.KEditField.Value;
        end

        % Button pushed function: ExportButton
        function ExportButtonPushed(app, event)
            assignin('base','predict', app.predict);
            saveas(app.UIAxes, 'Mod', 'fig')
        end

        % Button pushed function: ExportButton_2
        function ExportButton_2Pushed(app, event)
            assignin('base','demod', app.demod)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 682 500];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Modulation')
            xlabel(app.UIAxes, 'Time(s)')
            ylabel(app.UIAxes, 'Amlitude(V)')
            app.UIAxes.FontName = 'Times New Roman';
            app.UIAxes.TitleFontSizeMultiplier = 1.1;
            app.UIAxes.Box = 'off';
            app.UIAxes.Position = [1 250 484 151];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Demodulation')
            xlabel(app.UIAxes2, 'Time(s)')
            ylabel(app.UIAxes2, 'Amlitude(V)')
            app.UIAxes2.FontName = 'Times New Roman';
            app.UIAxes2.TitleFontSizeMultiplier = 1.1;
            app.UIAxes2.Box = 'off';
            app.UIAxes2.Position = [1 51 484 150];

            % Create NoiseCheckBox
            app.NoiseCheckBox = uicheckbox(app.UIFigure);
            app.NoiseCheckBox.ValueChangedFcn = createCallbackFcn(app, @NoiseCheckBoxValueChanged, true);
            app.NoiseCheckBox.Text = 'Noise';
            app.NoiseCheckBox.FontName = 'Times New Roman';
            app.NoiseCheckBox.FontWeight = 'bold';
            app.NoiseCheckBox.Position = [511 169 50 22];

            % Create DeltaEditFieldLabel
            app.DeltaEditFieldLabel = uilabel(app.UIFigure);
            app.DeltaEditFieldLabel.HorizontalAlignment = 'center';
            app.DeltaEditFieldLabel.Position = [511 95 50 22];
            app.DeltaEditFieldLabel.Text = 'Delta';

            % Create DeltaEditField
            app.DeltaEditField = uieditfield(app.UIFigure, 'numeric');
            app.DeltaEditField.Limits = [0 10];
            app.DeltaEditField.ValueDisplayFormat = '%.2f';
            app.DeltaEditField.ValueChangedFcn = createCallbackFcn(app, @DeltaEditFieldValueChanged, true);
            app.DeltaEditField.HorizontalAlignment = 'center';
            app.DeltaEditField.Position = [597 95 44 22];
            app.DeltaEditField.Value = 1;

            % Create KEditFieldLabel
            app.KEditFieldLabel = uilabel(app.UIFigure);
            app.KEditFieldLabel.HorizontalAlignment = 'center';
            app.KEditFieldLabel.Position = [531 60 27 22];
            app.KEditFieldLabel.Text = 'K';

            % Create KEditField
            app.KEditField = uieditfield(app.UIFigure, 'numeric');
            app.KEditField.Limits = [1 2];
            app.KEditField.ValueDisplayFormat = '%.2f';
            app.KEditField.ValueChangedFcn = createCallbackFcn(app, @KEditFieldValueChanged, true);
            app.KEditField.HorizontalAlignment = 'center';
            app.KEditField.Position = [597 60 44 22];
            app.KEditField.Value = 2;

            % Create InputSignalEditField
            app.InputSignalEditField = uieditfield(app.UIFigure, 'text');
            app.InputSignalEditField.ValueChangedFcn = createCallbackFcn(app, @InputSignalEditFieldValueChanged, true);
            app.InputSignalEditField.Position = [501 309 120 22];

            % Create ExportButton
            app.ExportButton = uibutton(app.UIFigure, 'push');
            app.ExportButton.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.ExportButton.Position = [211 219 100 22];
            app.ExportButton.Text = 'Export';

            % Create ExportButton_2
            app.ExportButton_2 = uibutton(app.UIFigure, 'push');
            app.ExportButton_2.ButtonPushedFcn = createCallbackFcn(app, @ExportButton_2Pushed, true);
            app.ExportButton_2.Position = [211 9 100 22];
            app.ExportButton_2.Text = 'Export';

            % Create ImportButton
            app.ImportButton = uibutton(app.UIFigure, 'push');
            app.ImportButton.ButtonPushedFcn = createCallbackFcn(app, @ImportButtonPushed, true);
            app.ImportButton.Position = [511 279 100 22];
            app.ImportButton.Text = 'Import';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.Position = [521 19 100 22];
            app.RunButton.Text = 'Run';

            % Create ExampleButton
            app.ExampleButton = uibutton(app.UIFigure, 'push');
            app.ExampleButton.ButtonPushedFcn = createCallbackFcn(app, @ExampleButtonPushed, true);
            app.ExampleButton.Position = [511 369 100 22];
            app.ExampleButton.Text = 'Example';

            % Create ModulationDropDownLabel
            app.ModulationDropDownLabel = uilabel(app.UIFigure);
            app.ModulationDropDownLabel.HorizontalAlignment = 'right';
            app.ModulationDropDownLabel.Position = [501 139 64 22];
            app.ModulationDropDownLabel.Text = 'Modulation';

            % Create ModulationDropDown
            app.ModulationDropDown = uidropdown(app.UIFigure);
            app.ModulationDropDown.Items = {'DM', 'ADM'};
            app.ModulationDropDown.ValueChangedFcn = createCallbackFcn(app, @ModulationDropDownValueChanged, true);
            app.ModulationDropDown.Position = [581 139 50 22];
            app.ModulationDropDown.Value = 'ADM';

            % Create FsEditFieldLabel
            app.FsEditFieldLabel = uilabel(app.UIFigure);
            app.FsEditFieldLabel.HorizontalAlignment = 'center';
            app.FsEditFieldLabel.Position = [531 239 25 22];
            app.FsEditFieldLabel.Text = 'Fs';

            % Create FsEditField
            app.FsEditField = uieditfield(app.UIFigure, 'numeric');
            app.FsEditField.Limits = [0 Inf];
            app.FsEditField.ValueChangedFcn = createCallbackFcn(app, @FsEditFieldValueChanged, true);
            app.FsEditField.HorizontalAlignment = 'center';
            app.FsEditField.Position = [561 239 40 22];
            app.FsEditField.Value = 50;

            % Create fEditFieldLabel
            app.fEditFieldLabel = uilabel(app.UIFigure);
            app.fEditFieldLabel.HorizontalAlignment = 'center';
            app.fEditFieldLabel.Position = [521 209 25 22];
            app.fEditFieldLabel.Text = 'f';

            % Create fEditField
            app.fEditField = uieditfield(app.UIFigure, 'numeric');
            app.fEditField.Limits = [0 Inf];
            app.fEditField.ValueChangedFcn = createCallbackFcn(app, @fEditFieldValueChanged, true);
            app.fEditField.HorizontalAlignment = 'center';
            app.fEditField.Position = [561 209 40 22];
            app.fEditField.Value = 2;

            % Create PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel = uilabel(app.UIFigure);
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.HorizontalAlignment = 'center';
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.FontSize = 16;
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.FontWeight = 'bold';
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.FontAngle = 'italic';
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.FontColor = [0.6392 0.0784 0.1804];
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.Position = [11 459 650 22];
            app.PleasenotetochangethefrequencyandsamplingratetoyoursignalLabel.Text = '* Please note to change the frequency and sampling rate according to your signal *';

            % Create ExapleInput5sin2piftexptLabel
            app.ExapleInput5sin2piftexptLabel = uilabel(app.UIFigure);
            app.ExapleInput5sin2piftexptLabel.HorizontalAlignment = 'center';
            app.ExapleInput5sin2piftexptLabel.FontWeight = 'bold';
            app.ExapleInput5sin2piftexptLabel.FontAngle = 'italic';
            app.ExapleInput5sin2piftexptLabel.Position = [471 399 210 22];
            app.ExapleInput5sin2piftexptLabel.Text = 'Exaple Input : 5*sin(2*pi*f*t).*exp(-t)';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DeltaModulationApp_mfile

            % Create UIFigure and components
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