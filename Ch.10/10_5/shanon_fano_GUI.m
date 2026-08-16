    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          GUI for Shannon-Fano Encoding and Decoding          %
    %                                                              %
    %        Book : Analog & Digital Communication Systems         %
    %                   By: Dr.Farnaz Ghassemi                     %
    %                          Chapter 8                           %
    %                                                              %
    %                                                              %
    %   Version.1:             03/03/30                            %
    %   The first version Contributed voluntarily by               %
    %   Khaleghi.                                                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%------------------------- Discription ------------------------
    %%  The code implements the Shannon-Fano encoding and decoding 
    %    algorithm with a graphical user interface (GUI), allowing users to 
    %    encode and decode text. The app provides interactive components for 
    %    inputting text, encoding it, displaying the resulting encoded string 
    %    and symbol codes, and decoding the encoded string back to its original form.
    %
    %   GUI Components:
    %       Edit Field (input string): The user enters the input string in this
    %        field.
    %       Button (code): Clicking on this button automatically starts 
    %        the encoding process.
    %       Edit Field (coded string): The encoded string will be shown on this
    %        field.
    %       Text Area (Symbols): This area diplays the binary code correspond
    %        to each character.
    %       Edit Field (input coded string): The user should enter the coded 
    %        string as the input of decoder function into this field.
    %       Button (deode): Clicking on this button automatically starts 
    %        the decoding process.
    %       Edit Field (decoded string): The decoded string will be shown on this
    %        field.
    %%---------------------------------------------------------------
    %%


classdef shanon_fano_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        inputstringEditFieldLabel       matlab.ui.control.Label
        inputstringEditField            matlab.ui.control.EditField
        codedstringEditFieldLabel       matlab.ui.control.Label
        codedstringEditField            matlab.ui.control.EditField
        codeButton                      matlab.ui.control.Button
        inputcodedstringEditFieldLabel  matlab.ui.control.Label
        inputcodedstringEditField       matlab.ui.control.EditField
        decodedstringEditFieldLabel     matlab.ui.control.Label
        decodedstringEditField          matlab.ui.control.EditField
        decodeButton                    matlab.ui.control.Button
        SymbolsTextAreaLabel            matlab.ui.control.Label
        SymbolsTextArea                 matlab.ui.control.TextArea
        binarycodeTextArea              matlab.ui.control.TextArea
    end

    methods (Access = private)

        % Button pushed function: codeButton
        function codeButtonPushed(app, event)
                 input_str=app.inputstringEditField.Value;
                 global codebook ;
                 [codebook, coded_str] = shanon_fano_encoding(input_str);
                 app.codedstringEditField.Value=coded_str;
                 keys = codebook.keys;
                 for i = 1:length(keys)
                         app.SymbolsTextArea.Value{i} = keys{i} ;
                         app.binarycodeTextArea.Value{i} = codebook(keys{i}) ;
                 
                     
                 end

                 
            
        end

        % Button pushed function: decodeButton
        function decodeButtonPushed(app, event)
            coded_str=app.inputcodedstringEditField.Value;
             global codebook ;
            app.decodedstringEditField.Value = decode_shanon_fano(coded_str, codebook);
        end

        % Callback function
        function TextAreaValueChanged(app, event)
            value = app.SymbolsTextArea.Value;
            global codebook ;
            keys = codebook.keys;
                for i = 1:length(keys)
                     fprintf('%c: %s\n', keys{i}, codebook(keys{i}));
                end

        end

        % Callback function
        function TextAreaValueChanged2(app, event)
        
        end

        % Value changed function: SymbolsTextArea
        function SymbolsTextAreaValueChanged3(app, event)
            value = app.SymbolsTextArea.Value;
            
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 947 757];
            app.UIFigure.Name = 'MATLAB App';

            % Create inputstringEditFieldLabel
            app.inputstringEditFieldLabel = uilabel(app.UIFigure);
            app.inputstringEditFieldLabel.HorizontalAlignment = 'right';
            app.inputstringEditFieldLabel.FontName = 'Arial';
            app.inputstringEditFieldLabel.FontSize = 22;
            app.inputstringEditFieldLabel.FontWeight = 'bold';
            app.inputstringEditFieldLabel.Position = [56 674 126 27];
            app.inputstringEditFieldLabel.Text = 'input string';

            % Create inputstringEditField
            app.inputstringEditField = uieditfield(app.UIFigure, 'text');
            app.inputstringEditField.FontName = 'Arial';
            app.inputstringEditField.FontSize = 20;
            app.inputstringEditField.Position = [197 672 647 36];

            % Create codedstringEditFieldLabel
            app.codedstringEditFieldLabel = uilabel(app.UIFigure);
            app.codedstringEditFieldLabel.HorizontalAlignment = 'right';
            app.codedstringEditFieldLabel.FontName = 'Arial';
            app.codedstringEditFieldLabel.FontSize = 22;
            app.codedstringEditFieldLabel.FontWeight = 'bold';
            app.codedstringEditFieldLabel.Position = [53 623 138 27];
            app.codedstringEditFieldLabel.Text = 'coded string';

            % Create codedstringEditField
            app.codedstringEditField = uieditfield(app.UIFigure, 'text');
            app.codedstringEditField.FontName = 'Arial';
            app.codedstringEditField.FontSize = 20;
            app.codedstringEditField.Position = [198 620 647 39];

            % Create codeButton
            app.codeButton = uibutton(app.UIFigure, 'push');
            app.codeButton.ButtonPushedFcn = createCallbackFcn(app, @codeButtonPushed, true);
            app.codeButton.BackgroundColor = [1 0 0];
            app.codeButton.FontSize = 22;
            app.codeButton.Position = [422 561 106 40];
            app.codeButton.Text = 'code';

            % Create inputcodedstringEditFieldLabel
            app.inputcodedstringEditFieldLabel = uilabel(app.UIFigure);
            app.inputcodedstringEditFieldLabel.HorizontalAlignment = 'right';
            app.inputcodedstringEditFieldLabel.FontName = 'Arial';
            app.inputcodedstringEditFieldLabel.FontSize = 22;
            app.inputcodedstringEditFieldLabel.FontWeight = 'bold';
            app.inputcodedstringEditFieldLabel.Position = [39 479 198 27];
            app.inputcodedstringEditFieldLabel.Text = 'input coded string';

            % Create inputcodedstringEditField
            app.inputcodedstringEditField = uieditfield(app.UIFigure, 'text');
            app.inputcodedstringEditField.FontName = 'Arial';
            app.inputcodedstringEditField.FontSize = 20;
            app.inputcodedstringEditField.Position = [245 476 598 39];

            % Create decodedstringEditFieldLabel
            app.decodedstringEditFieldLabel = uilabel(app.UIFigure);
            app.decodedstringEditFieldLabel.HorizontalAlignment = 'right';
            app.decodedstringEditFieldLabel.FontName = 'Arial';
            app.decodedstringEditFieldLabel.FontSize = 22;
            app.decodedstringEditFieldLabel.FontWeight = 'bold';
            app.decodedstringEditFieldLabel.Position = [62 421 163 27];
            app.decodedstringEditFieldLabel.Text = 'decoded string';

            % Create decodedstringEditField
            app.decodedstringEditField = uieditfield(app.UIFigure, 'text');
            app.decodedstringEditField.FontName = 'Arial';
            app.decodedstringEditField.FontSize = 20;
            app.decodedstringEditField.Position = [245 418 599 38];

            % Create decodeButton
            app.decodeButton = uibutton(app.UIFigure, 'push');
            app.decodeButton.ButtonPushedFcn = createCallbackFcn(app, @decodeButtonPushed, true);
            app.decodeButton.BackgroundColor = [1 0 0];
            app.decodeButton.FontSize = 22;
            app.decodeButton.Position = [422 351 106 40];
            app.decodeButton.Text = 'decode';

            % Create SymbolsTextAreaLabel
            app.SymbolsTextAreaLabel = uilabel(app.UIFigure);
            app.SymbolsTextAreaLabel.HorizontalAlignment = 'right';
            app.SymbolsTextAreaLabel.FontSize = 22;
            app.SymbolsTextAreaLabel.FontWeight = 'bold';
            app.SymbolsTextAreaLabel.Position = [28 284 97 27];
            app.SymbolsTextAreaLabel.Text = 'Symbols';

            % Create SymbolsTextArea
            app.SymbolsTextArea = uitextarea(app.UIFigure);
            app.SymbolsTextArea.ValueChangedFcn = createCallbackFcn(app, @SymbolsTextAreaValueChanged3, true);
            app.SymbolsTextArea.FontSize = 20;
            app.SymbolsTextArea.Position = [140 64 62 249];

            % Create binarycodeTextArea
            app.binarycodeTextArea = uitextarea(app.UIFigure);
            app.binarycodeTextArea.FontSize = 20;
            app.binarycodeTextArea.Position = [201 64 198 249];
        end
    end

    methods (Access = public)

        % Construct app
        function app = shanon_fano_GUI

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