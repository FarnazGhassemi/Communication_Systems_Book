%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 10-5:              %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 10-Section                       %
%                                                              %
%                                                              %
%   Version.1:             03/03/30                            %
%   The first version Contributed voluntarily by               %
%   Faranak Rezaie and Amirsadra Khodadadi.                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% FSK / PSK / ASK Modulations and Demodulations 

classdef ModandDemod
    
    %{
    in this class, we modulate and demodualte our binary input signal 
    obtained from the Humfman class using 3 different modulations
    %}

    properties
        %Defining our parameters
        data
        f    % Carrier frequency (Hz)
        M    % Number of periods for each bit
        T    % Carrier period (s)
        fs   % Sampling frequency (Hz)
        Ts   % Sampling period (s)
        n    % Total number of periods for the entire data sequence
        t    % Time vector for the carrier signal
        car  % Carrier signal
        tp   % Time vector for one bit period
    end

    methods
        function obj = ModandDemod(data,f,M)
            fs=f*10;
            Ts=1/fs;
            T=1/f;
            n=M*length(data);
            t=0:Ts:n*T;
            car=sin(2*pi*t*f);
            tp = 0:Ts:M*T;   
            obj.data = data;
            obj.f = f;
            obj.M = M;
            obj.fs = fs;
            obj.Ts = Ts;
            obj.T = T;
            obj.n = n;
            obj.t = t;
            obj.car = car;
            obj.tp = tp;   
        end

        function exData = CreateSignal(obj)
            % Converting data bits into a pulse sequence
            
            exData=[];
            
            % Expand each bit in data to match the length of tp
            for i=1:length(obj.data)
                for j=1:length(obj.tp)-1
                    exData=[exData obj.data(i)];
                end
            end
            exData(1,size(exData)+1)=exData(1,size(exData));
        end

        function modfsk = FSKModulation(obj)
            obj.t = 0:obj.Ts:(obj.T*obj.M);
            
            % Generate carriers for data bits
            deltaf = .4;                  % Frequency deviation factor
            
            fh = obj.f + (obj.f*deltaf);  % High frequency for data bit 1
            carh = sin(2*pi*obj.t*fh);    % High frequency carrier for data bit 1
            
            fl = obj.f - (obj.f*deltaf);  % Low frequency for data bit 0
            carl = sin(2*pi*obj.t*fl);    % Low frequency carrier for data bit 0
              
            modfsk=[];
            
            % Modulate the data sequence 
            for i=1:length(obj.data)
                if(obj.data(i)==1)
                    modfsk=[modfsk carh];
                else
                    modfsk=[modfsk carl];
                end
            end
        end

        function demodfsk = FSKDemodulation(obj, rx)

            deltaf = .4;
            demodfsk=[];
            fh = obj.f + (obj.f*deltaf);
            fl = obj.f - (obj.f*deltaf);
             
            obj.t = 0:obj.Ts:(obj.T*obj.M);
             
            car1=sin(2*pi*obj.t*fh);       %High frequency carrier for data bit 1
            car0=sin(2*pi*obj.t*fl);       %Low frequency carrier for data bit 0

            for i = 1:length(obj.data)
                startIdx = (i-1)*length(obj.tp) + 1;
                endIdx = i*length(obj.tp);
                segment = rx(startIdx:endIdx);
                
                % Correlate with the reference carriers
                corr1 = sum(segment .* car1);
                corr0 = sum(segment .* car0);
                
                if corr1 > corr0
                    demodfsk = [demodfsk 1];
                else
                    demodfsk = [demodfsk 0];
                end
            end

        end
             

        function modpsk = PSKModulation(obj)
            obj.t = 0:obj.Ts:(obj.T*obj.M);

            % Generate carriers for data bits
            car1 = sin(2*pi*obj.t*obj.f);        % Carrier for data bit 1 (0 phase shift)          
            car0 = sin(2*pi*obj.t*obj.f + pi);   % Carrier for data bit 0 (pi phase shift)
            
            modpsk = [];
            
            % Modulate the data sequence
            for i = 1:length(obj.data)
                if(obj.data(i) == 1)
                    modpsk = [modpsk car1];
                else
                    modpsk = [modpsk car0];
                end
            end
        end

        function demodpsk = PSKDemodulation(obj, rx)
            demodpsk = [];
            obj.t = 0:obj.Ts:(obj.T*obj.M);
            car1 = sin(2*pi*obj.t*obj.f);
            car0 = sin(2*pi*obj.t*obj.f + pi);

            % Demodulate the received signal
            for i = 1:length(obj.data)
                startIdx = (i-1)*length(obj.tp)+1; % Start index for each bit period
                endIdx = i*length(obj.tp);         % End index for each bit period
                segment = rx(startIdx:endIdx);     % Extract the segment corresponding to the current bit
                
                % Correlate with the reference carriers
                corr1 = sum(segment .* car1);
                corr0 = sum(segment .* car0);
                
                % Decide the bit based on the correlation results
                if corr1 > corr0
                    demodpsk = [demodpsk 1];
                else
                    demodpsk = [demodpsk 0];
                end
            end
        end

        function modask = ASKModulation(obj)
            obj.t = 0:obj.Ts:(obj.T*obj.M);
            
            % Generate carriers for data bits
            A1 = 1;
            car1 = A1 * sin(2*pi*obj.t*obj.f); % Carrier for data bit 1 (amplitude A1)
            
            A0 = 0.2;
            car0 = A0 * sin(2*pi*obj.t*obj.f); % Carrier for data bit 0 (amplitude A0)
            
            modask = [];
            
            % Modulate the data sequence
            for i = 1:length(obj.data)
                if(obj.data(i) == 1)
                    modask = [modask car1];
                else
                    modask = [modask car0];
                end
            end
        end
        
        function demodask = ASKDemodulation(obj, rx)
            obj.t = 0:obj.Ts:(obj.T*obj.M);
            A1 = 1;            
            A0 = 0.2;            
            demodask = [];

            % Demodulate the received signal
            for i = 1:length(obj.data)
                startIdx = (i-1)*length(obj.tp)+1; % Start index for each bit period
                endIdx = i*length(obj.tp);         % End index for each bit period
                segment = rx(startIdx:endIdx);     % Extract the segment corresponding to the current bit
                
                % Calculate the average power of the segment
                avgPower = mean(segment.^2);
                
                % Compare average power with threshold to determine bit value
                threshold = (A1^2 + A0^2) / 2;  % Midpoint threshold
                if avgPower > threshold
                    demodask = [demodask 1];
                else
                    demodask = [demodask 0];
                end
            end
        end

        function [BER, NOR] = BitRateError(obj, Data, demodData)
            %Finding Bit Error Rate
            [BER, NOR] = biterr(Data, demodData);
        end

    end
end
   