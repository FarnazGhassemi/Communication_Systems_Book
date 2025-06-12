%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 8-5:               %
%           Entropy of Biosignals comparing to noise           %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 8-Section                        %
%                                                              %
%                                                              %
%   Version.1:             04/03/03---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------------------------------------------
close all;
clear;
clc;
clc
clear all
close all
m=input('Mannual=0/Auto=1  ???');
%---------Input data-------------------------
if (m==0)
    I=input('Number of Symbols?');
    %p=zeros(1:I);
    symbols=[1:I];
    for i=1:(I-1)
        p(i)=input(['p(',num2str(i),')=?']);
    end
    p(I)=1-sum(p);
    if or((p(I)<0),(p(I)>1))
        disp('Error in probability!!!')
        return;
    end
else
    disp('Number of Auto-Coding? (1 to 4)')
    disp('1: Full English Alphabet')
    disp('2: Full Nunbers')
    disp('3: A T SH K L M v')
    disp('4: b i o e n g r')
    k=input('?');
    switch k
        case 1
            symbols = {'a' , 'b' , 'c' , 'd' , 'e' , 'f' , 'g' , 'h' , 'i' , 'j' , 'k' , 'l' , 'm' , 'n' , 'o' , 'p' , 'q' , 'r' , 's' , 't' , 'u' , 'v' , 'w' , 'x' , 'y' , 'z'};
            p = [36 , 35 , 34 , 32 , 31 , 30 , 29 , 28 , 27 , 26 , 25 , 24 , 22 , 21 , 20 , 19 , 17 , 16 , 14 , 13 , 12 , 11 , 8 , 4 , 2 , 1 ]/537; % Probability distribution
        case 2
            symbols = {' ','0','1','2','3','4','5','6','7','8','9','.'};
            p = [36 , 35 , 34 , 32 , 31 , 30 , 29 , 28 , 27 , 26 , 25 , 24 ]/sum([36 , 35 , 34 , 32 , 31 , 30 , 29 , 28 , 27 , 26 , 25 , 24 ]); % Probability distribution
        case 3
            symbols ={'A','T','SH','K','L','M','v'};
            %p = [64,4,8,1,2,16,32]/127;
            p = [64,4,8,1,2,16,32]/127;
        case 4
            symbols = {'b' 'i' 'o' 'e' 'n' 'g' 'r'}; % Distinct symbols that data source can produce

            p = [100,6,12,1,3,25,50]/197;
            %     symbols = =[1:6];
    end  
    
    I=length(symbols);
    disp(['Number of Alphabets: ',num2str(I)])
    disp(['Sum of Probabilities: ',num2str(sum(p))])
    disp(['Probabilities: ',num2str(p)])
end
%---------------------------------------------
%---------Coding data-------------------------
[dict,avglen] = huffmandict(symbols,p); % Create dictionary.
disp('The Dictionary is:')
disp(['      Symbol   Code    Probability'])
for i=1:I
     disp([dict(i,1),num2str(cell2mat(dict(i,2))),num2str(p(i))])
end
disp('The Average Length is:')
disp(avglen)
disp('###################################################################')
%disp('-------------------------------------------------------------------')
%---------------------------------------------
%---------Output data-------------------------
i=1;
if (m==0)
    actualsig =input('symbols in numbers for coding? (ex. [1 2 1 3]/exit: -100 )');
    if (actualsig==-100)
        return;
    end
    while (actualsig~=-100)
        comp = huffmanenco(actualsig,dict)
        actualsig =input('symbols in numbers for coding? (ex. [1 2 1 3]/exit: -100 )');
        if (actualsig==-100)
           return;
        end
    end   
else   
    switch k
        case 1
            actualsig={'h' 'a' 'p' 'p' 'y'};
            comp = huffmanenco(actualsig,dict); % Encode the data.
            disp(['Encoded Data:'])
            disp(num2str(comp))
%     actualsig={'a' 'p' 'p' 'l' 'e'};
%     comp = huffmanenco(actualsig,dict) % Encode the data.
%     actualsig={'h' 'u' 'r' 'a' 'y'};
%     comp = huffmanenco(actualsig,dict) % Encode the data.
%     actualsig={'s' 'm' 'a' 'r' 't'};
%     comp = huffmanenco(actualsig,dict) % Encode the data.
        case 2
            symbols = {'1','3','5','9'};
            comp = huffmanenco(symbols,dict); % Encode the data.
            disp(['Encoded Data:'])
            disp(num2str(comp))
             % load('MATLAB.mat')
             % actualsig =1;
             % while (i<= length(A))
             %    actualsig =num2str(A(i,1));
             %    comp = num2str(huffmanenco(actualsig,dict));
             %    T(i,1)={comp};
             %    actualsig =num2str(A(i,2));
             %    comp= num2str(huffmanenco(actualsig,dict));
             %    T(i,2)={comp};
             %    i=i+1;
             % end
             % disp(['Encoded Data:'])
             % disp(T)
        case 3
            actualsig={'T' 'A' 'L' 'A' 'SH'};
            comp = huffmanenco(actualsig,dict); % Encode the data.
            disp(['Encoded Data:'])
            disp(num2str(comp))
        case 4
            actualsig={'b' 'i' 'o' 'e' 'n' 'g' 'i' 'n' 'e' 'e' 'r' 'i' 'n' 'g'};
            comp = huffmanenco(actualsig,dict);
            disp(['Encoded Data:'])
            disp(num2str(comp))
            %     actualsig = randsrc(100,1,[symbols; p]); % Create data using p.
%     actualsig=[11110001110100100100001101011000001001];

    end     
 
%      actualsig =num2str(input('symbol? '))
%      comp = huffmanenco(actualsig,dict) 
end

%---------Decode user data-------------------------
% actualsig=[];
switch k
    case 1
        actualsig =input('Symbols for Coding?(ex.: [''t'' ''e'' ''l'']/exit: -100)');
        if (actualsig==-100)
           return;
        end
         while (actualsig ~= -100)
             comp = huffmanenco(actualsig,dict);
             dsig = huffmandeco(comp,dict); % Decode the Huffman code
             %     str2num((char(dsig))')
            disp(dict)
            disp(['Message:'])
            disp(['     ',actualsig ])
            disp(['Encoded Data:'])
            disp(['     ',num2str(comp)])
            disp(['Dencoded Data:'])
            disp([char (dsig)])
            actualsig =num2str(input('Symbols for Coding?(ex.: [''t'' ''e'' ''l'']/exit: -100)'));
            if (str2num(actualsig)==-100)
               return;
            end
         end
    case 2
        actualsig =input('Symbols for Coding?(ex.: 9311018/exit: -100)');
        if (actualsig==-100)
           return;
        end
        while (actualsig ~= -100)
            comp = huffmanenco(num2str(actualsig),dict) ;
            %  x=[];
            % for i=1:length(A) 
            %     if(strmatch(str2num(char(T(i,1)))',comp))
            %         x=i;
            %     end
            % end
            % dsig = huffmandeco(str2num(char(T(x,2)))',dict); % Decode the Huffman code.
        %     str2num((char(dsig))')
            % disp([num2str(actualsig) ,'     ',(char(dsig))'])
            dsig = huffmandeco(comp,dict); % Decode the Huffman code.
            disp(dict)
            disp(['Message:'])
            disp(['     ',num2str(actualsig)])
            disp(['Encoded Data:'])
            disp(['     ',num2str(comp)])
            disp(['Dencoded Data:'])
            disp(['     ',cell2mat(dsig)])
            actualsig=[];
            actualsig =input('Symbols for Coding?(ex.: 9311018 /exit: -100)');
            if (actualsig == -100)
               return;
            end
        end
    case 3
        actualsig =input('Symbols for Coding?(ex.: [ ''A''  ''T'' ''S'' ''K'' ''L'' ''M'' ''v'']/exit: -100)');
        if (actualsig==-100)
           return;
        end
        while (actualsig ~= -100)
            comp = huffmanenco(actualsig,dict) % Encode the data.
            dsig = huffmandeco(comp,dict) % Decode the Huffman code.
            disp(dict)
            disp(['Message:'])
            disp(['     ',num2str(actualsig)])
            disp(['Encoded Data:'])
            disp(['     ',num2str(comp)])
            disp(['Dencoded Data:'])
            disp(['     ',cell2mat(dsig)])
            actualsig=[];
            actualsig =input('Symbols for Coding?(ex.: [ ''A''  ''T'' ''S'' ''K'' ''L'' ''M'' ''v'']/exit: -100)');
            if (actualsig == -100)
               return;
            end
        end
        case 4
            actualsig =input('Symbols for Coding?(ex.: [ ''b'' ''i'' ''o'' ''e'' ''n'' ''g'' ''r'']/exit: -100)');
            if (actualsig==-100)
               return;
            end
            while (actualsig ~= -100)
                comp = huffmanenco(actualsig,dict); % Encode the data.
                dsig = huffmandeco(comp,dict); % Decode the Huffman code.
                disp(dict)
                disp(['Message:'])
                disp(['     ',num2str(actualsig)])
                disp(['Encoded Data:'])
                disp(['     ',num2str(comp)])
                disp(['Dencoded Data:'])
                disp(['     ',cell2mat(dsig)])
                actualsig=[];
                actualsig =input('Symbols for Coding?(ex.: [ ''b'' ''i'' ''o'' ''e'' ''n'' ''g'' ''r'']/exit: -100)');
                if (actualsig == -100)
                   return;
                end
            end
end