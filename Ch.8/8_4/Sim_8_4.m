%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GUI for Morse Code Encoder/Decoder              %
%             with Audio Playback and Visualization            %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                  Chapter 8 -                                 %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Sara Khamseh.                                              %
%   Version.2:             04/01/27                            %
%   The second version Contributed voluntarily by              %
%   Fatemeh Yazdani.                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%------------------------- Discription ------------------------
%%  This code generates a graphical user interface (GUI) designed to 
%    encode and decode text into either Morse code or 5-bit Telegraph 
%    code (Baudot-style). The app allows users to input text, Morse code, 
%    or Telegraph code, convert between these formats, visualize the 
%    code waveform, and play the corresponding code audio. 
%    Users can also adjust the playback speed and select from different 
%    waveform types (sine, sawtooth, or square) for sound generation.
%
%   Supported Formats:
%       - Morse Code: Uses '.' and '-' (or '_') for dots and dashes.
%          Letters are separated by spaces, words by '/'.
%       - Telegraph Code: Encodes letters into 5-bit binary strings 
%          where each character is encoded as: 
%               start bit (0) + 5-bit Baudot code + two stop bits (11). 
%          Aplphabets and space (00100) are supported. It returns 5 asterisks 
%          if the binary code is unsupported.
%
%   Functions:
%       encode: uses a binary tree and depth-first search to map each character 
%           to Morse code.
%       decode: traverses a binary Morse code tree from the root for each Morse sequence, 
%           where a dot (.) moves left and a dash (-) moves right, to reconstruct 
%           the original English character.
%       telegraph_code: uses a fixed mapping of letters to 5-bit binary strings 
%           based on the Baudot (ITA2) code in Letters mode.
%       decode_telegraph: uses the inverse of the Baudot code mapping to convert 
%           5-bit binary strings back into their corresponding letters.
%       AudioMorse: generates audio signal corresponding to the Morse code.
%        the dashes 
%       AudioTelegraph: the Mark (bit 1) and Space (bit 0) states are represented by two 
%        audio tones of which the frequencies do not share a comman factor. 
%        1500 Hz for '1' (mark), 1670 Hz for '0' (space) (170 Hz shift).
%
%   GUI Components:
%       EditField: fields for text, Morse code, or Telegraph code.
%       DropDown: DropDown to select between "Encode" and "Decode Morse" or "Decode Telegraph" modes.
%       Button (convert): Button to start encoding or decoding of input.
%       DropDown: DropDown to select between "Display Morse" and "Display Telegraph" modes.
%       DropDown (waveform): Dropdown to select the waveform type (sin, sawtooth, square) for audio generator.
%       Slider (speed): Slider to set the speed for the audio playback.
%       Button (Play Audio): Button to play the code sound.
%       Button (Display Audio): Button to display the Audio lines.
%       UIAxes (Audio Lines): Area for plotting the code waveform.
%
%%---------------------------------------------------------------
%%

classdef Sim_8_4 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        DisplayAudioButton     matlab.ui.control.Button
        DisplayAudioDropDown   matlab.ui.control.DropDown
        TelegraphLabel         matlab.ui.control.Label
        MorseCodeLabel         matlab.ui.control.Label
        TextLabel              matlab.ui.control.Label
        EditField_Telegraph    matlab.ui.control.EditField
        EditField_3Label       matlab.ui.control.Label
        speedSlider            matlab.ui.control.Slider
        speedSliderLabel       matlab.ui.control.Label
        waveformDropDown       matlab.ui.control.DropDown
        waveformDropDownLabel  matlab.ui.control.Label
        ConvertButton          matlab.ui.control.Button
        convertDropDown        matlab.ui.control.DropDown
        PlayAudioButton        matlab.ui.control.Button
        EditField_2            matlab.ui.control.EditField
        EditField              matlab.ui.control.EditField
        UIAxes                 matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: PlayAudioButton
        function PlayAudioButtonPushed(app, event)
            mode = app.DisplayAudioDropDown.Value;
            switch mode
                case "Display Morse"
                    [MorseSound, ~] = AudioMorse(app.EditField_2.Value, app.waveformDropDown.Value);
                    Audio = audioplayer(MorseSound, round(app.speedSlider.Value));
                case "Display Telegraph"
                    [TelegraphSound, ~] = AudioTelegraph(app.EditField_Telegraph.Value, app.waveformDropDown.Value);
                    Audio = audioplayer(TelegraphSound, round(app.speedSlider.Value));
            end
            pause(0.25);
            play(Audio)
            while isplaying(Audio)
                pause(0.00001);
            end
        end

        % Button pushed function: ConvertButton
        function ConvertButtonPushed(app, event)
            mode = app.convertDropDown.Value;
        
            switch mode
                case "Encode Text"
                    inputText = upper(app.EditField.Value); % String input
                    morseResult = encode(inputText);        % Convert to Morse
                    codes = strings(1, length(inputText));  % Convert to Telegraph
        
                    for i = 1:length(inputText)
                        codes(i) = "0" + telegraph_code(inputText(i)) + "11";
                    end
                    telegraphResult = join(codes, "");  % Start bit + data + two stop bits
        
                    app.EditField_2.Value = morseResult;
                    app.EditField_Telegraph.Value = telegraphResult;
        
                case "Decode Morse"
                    morseInput = app.EditField_2.Value;      % Morse input
                    decodedText = decode(morseInput);        % Morse → String
                    codes = strings(1, length(decodedText));  % Convert to Telegraph
        
                    for i = 1:length(decodedText)
                        codes(i) = "0" + telegraph_code(decodedText(i)) + "11";
                    end
                    telegraphResult = join(codes, "");  % Start bit + data + two stop bits
        
                    app.EditField.Value = decodedText;
                    app.EditField_Telegraph.Value = telegraphResult;
        
                case "Decode Telegraph"
                    telegraphInput = app.EditField_Telegraph.Value;  % Telegraph input
                    decodedText = decode_telegraph(telegraphInput);  % Telegraph → String
                    morseResult = encode(decodedText);               % String → Morse
        
                    app.EditField.Value = decodedText;
                    app.EditField_2.Value = morseResult;
            end
        end

        % Value changed function: EditField_Telegraph, convertDropDown
        function EditField_TelegraphValueChanged(app, event)
            value = app.EditField_Telegraph.Value;
        end

        % Value changed function: DisplayAudioDropDown
        function DisplayAudioDropDownValueChanged(app, event)
            value = app.DisplayAudioDropDown.Value;
        end

        % Button pushed function: DisplayAudioButton
        function DisplayAudioButtonPushed(app, event)
            mode = app.DisplayAudioDropDown.Value;
            switch mode
                case "Display Morse"
                    [Sound, ~] = AudioMorse(app.EditField_2.Value, app.waveformDropDown.Value);
                case "Display Telegraph"
                    [Sound, ~] = AudioTelegraph(app.EditField_Telegraph.Value, app.waveformDropDown.Value);
            end
            
            plot(Sound, 'Parent', app.UIAxes);
            ylim(app.UIAxes, [-inf inf]);
            xlim(app.UIAxes, [0 length(Sound)]);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.2824 0.4667 0.6];
            app.UIFigure.Position = [100 100 696 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Scrollable = 'on';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Audio Lines')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.FontName = 'Arial';
            app.UIAxes.FontAngle = 'italic';
            app.UIAxes.FontUnits = 'points';
            app.UIAxes.Position = [91 36 299 195];

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.FontSize = 18;
            app.EditField.Tooltip = {'Type text using alphabets and space between words.'};
            app.EditField.Position = [37 387 452 47];
            app.EditField.Value = 'SOS';

            % Create EditField_2
            app.EditField_2 = uieditfield(app.UIFigure, 'text');
            app.EditField_2.FontSize = 18;
            app.EditField_2.Tooltip = {'Type Morse code using ''.'', ''-'' or ''_'', using spaces between letters and ''/'' between words.'};
            app.EditField_2.Position = [37 319 452 42];
            app.EditField_2.Value = '... --- ...';

            % Create PlayAudioButton
            app.PlayAudioButton = uibutton(app.UIFigure, 'push');
            app.PlayAudioButton.ButtonPushedFcn = createCallbackFcn(app, @PlayAudioButtonPushed, true);
            app.PlayAudioButton.FontName = 'Arial';
            app.PlayAudioButton.FontWeight = 'bold';
            app.PlayAudioButton.FontAngle = 'italic';
            app.PlayAudioButton.Position = [529 251 84 26];
            app.PlayAudioButton.Text = 'Play Audio';

            % Create convertDropDown
            app.convertDropDown = uidropdown(app.UIFigure);
            app.convertDropDown.Items = {'Encode Text', 'Decode Morse', 'Decode Telegraph'};
            app.convertDropDown.ValueChangedFcn = createCallbackFcn(app, @EditField_TelegraphValueChanged, true);
            app.convertDropDown.FontWeight = 'bold';
            app.convertDropDown.FontAngle = 'italic';
            app.convertDropDown.Position = [508 409 128 25];
            app.convertDropDown.Value = 'Encode Text';

            % Create ConvertButton
            app.ConvertButton = uibutton(app.UIFigure, 'push');
            app.ConvertButton.ButtonPushedFcn = createCallbackFcn(app, @ConvertButtonPushed, true);
            app.ConvertButton.FontName = 'Arial';
            app.ConvertButton.FontWeight = 'bold';
            app.ConvertButton.FontAngle = 'italic';
            app.ConvertButton.Position = [537 371 67 26];
            app.ConvertButton.Text = 'Convert';

            % Create waveformDropDownLabel
            app.waveformDropDownLabel = uilabel(app.UIFigure);
            app.waveformDropDownLabel.HorizontalAlignment = 'right';
            app.waveformDropDownLabel.FontSize = 14;
            app.waveformDropDownLabel.FontWeight = 'bold';
            app.waveformDropDownLabel.FontAngle = 'italic';
            app.waveformDropDownLabel.Position = [483 209 71 22];
            app.waveformDropDownLabel.Text = 'waveform';

            % Create waveformDropDown
            app.waveformDropDown = uidropdown(app.UIFigure);
            app.waveformDropDown.Items = {'sin', 'sawtooth', 'square'};
            app.waveformDropDown.FontWeight = 'bold';
            app.waveformDropDown.FontAngle = 'italic';
            app.waveformDropDown.Position = [482 186 83 22];
            app.waveformDropDown.Value = 'sin';

            % Create speedSliderLabel
            app.speedSliderLabel = uilabel(app.UIFigure);
            app.speedSliderLabel.HorizontalAlignment = 'right';
            app.speedSliderLabel.FontWeight = 'bold';
            app.speedSliderLabel.FontAngle = 'italic';
            app.speedSliderLabel.Position = [445 61 39 22];
            app.speedSliderLabel.Text = 'speed';

            % Create speedSlider
            app.speedSlider = uislider(app.UIFigure);
            app.speedSlider.Limits = [5000 30000];
            app.speedSlider.MajorTicks = [10000 20000 30000];
            app.speedSlider.Orientation = 'vertical';
            app.speedSlider.FontWeight = 'bold';
            app.speedSlider.FontAngle = 'italic';
            app.speedSlider.Position = [505 70 3 104];
            app.speedSlider.Value = 10000;

            % Create EditField_3Label
            app.EditField_3Label = uilabel(app.UIFigure);
            app.EditField_3Label.HorizontalAlignment = 'right';
            app.EditField_3Label.FontSize = 18;
            app.EditField_3Label.Position = [37 260 80 22];
            app.EditField_3Label.Text = 'Edit Field';

            % Create EditField_Telegraph
            app.EditField_Telegraph = uieditfield(app.UIFigure, 'text');
            app.EditField_Telegraph.ValueChangedFcn = createCallbackFcn(app, @EditField_TelegraphValueChanged, true);
            app.EditField_Telegraph.FontSize = 18;
            app.EditField_Telegraph.Tooltip = {'Type Telegraph code according to ITA2 protocl for Baudot code (Supports Alphabets and space (00100)) such that each character consists of 5 data bits, preceeded by one start bit (0) and succeeded by two stop bits (11).'};
            app.EditField_Telegraph.Position = [38 251 451 40];
            app.EditField_Telegraph.Value = '000101110110001100010111';

            % Create TextLabel
            app.TextLabel = uilabel(app.UIFigure);
            app.TextLabel.FontSize = 16;
            app.TextLabel.FontWeight = 'bold';
            app.TextLabel.Position = [38 433 79 31];
            app.TextLabel.Text = 'Text:';

            % Create MorseCodeLabel
            app.MorseCodeLabel = uilabel(app.UIFigure);
            app.MorseCodeLabel.FontSize = 16;
            app.MorseCodeLabel.FontWeight = 'bold';
            app.MorseCodeLabel.Position = [37 359 102 28];
            app.MorseCodeLabel.Text = 'Morse Code:';

            % Create TelegraphLabel
            app.TelegraphLabel = uilabel(app.UIFigure);
            app.TelegraphLabel.FontSize = 16;
            app.TelegraphLabel.FontWeight = 'bold';
            app.TelegraphLabel.Position = [37 290 133 29];
            app.TelegraphLabel.Text = 'Telegraph:';

            % Create DisplayAudioDropDown
            app.DisplayAudioDropDown = uidropdown(app.UIFigure);
            app.DisplayAudioDropDown.Items = {'Display Morse', 'Display Telegraph'};
            app.DisplayAudioDropDown.ValueChangedFcn = createCallbackFcn(app, @DisplayAudioDropDownValueChanged, true);
            app.DisplayAudioDropDown.FontWeight = 'bold';
            app.DisplayAudioDropDown.FontAngle = 'italic';
            app.DisplayAudioDropDown.Position = [507 328 128 25];
            app.DisplayAudioDropDown.Value = 'Display Morse';

            % Create DisplayAudioButton
            app.DisplayAudioButton = uibutton(app.UIFigure, 'push');
            app.DisplayAudioButton.ButtonPushedFcn = createCallbackFcn(app, @DisplayAudioButtonPushed, true);
            app.DisplayAudioButton.FontName = 'Arial';
            app.DisplayAudioButton.FontWeight = 'bold';
            app.DisplayAudioButton.FontAngle = 'italic';
            app.DisplayAudioButton.Position = [524 290 95 26];
            app.DisplayAudioButton.Text = 'Display Audio';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Sim_8_4

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