%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   Illustrating Simulation 3-5:               %
%     Types of Adverse Effects of Channel On Message Signal    %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                     Chapter 3-Section 5                      %
%                                                              %
%                                                              %
%   Version.2:             03/09/27---Dr.Ghassemi              %
%   Version.1:             96/06/30---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



close all;
clear all;
clc;

t=0:0.001:1;
w0=4;
fi=pi()/2;% change it to 2*pi()/2 and see the results
figure(1)
grid on
A=[1,-1/3,1/5];
colors=[0,0,0;                       %1-Black
        0,0,0.75;                    %2-Blue
        214/255,39/255,40/255;       %3-Red
        15/255,133/255,84/255;       %4-Green
        118/255,78/255,159/255;     %5-Purple
        225/255,124/255,5/255;       %6-Orange
        56/255,166/255,165/255;      %7-Light Blue
        204/255,80/255,62/255;       %8-Light Red
        115/255,175/255,72/255;      %9-Light Green
        237/255,173/255,8/255;       %10-Light Orange
        148/255,52/255,110/255;      %11-Light Purple
        70/255,0,114/255;            %12-Dark Blue
        0,0.5,0.25                   %13-Green
        ];
marks={'-';'--';':';'-.'};
nn=2;
kk=0;
for i=1:nn    
    a1=A(1)*cos(2*pi()*w0*t+fi);
    figure(i)
    j=1;
    kk=1;
    subplot(5,1,1)
    kk=kk+1;
    plot(t,a1,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',2)
    ylabel('(1)','FontWeight','bold')
    grid on,hold on
    
    a2=A(2)*cos(2*pi()*3*w0*t+fi);
    subplot(5,1,2)
    kk=kk+1;
    plot(t,a2,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',2)
    ylabel('(2)','FontWeight','bold')
    grid on,hold on
    
    a3=A(3)*cos(2*pi()*5*w0*t+fi);
    subplot(5,1,3)
    kk=kk+1;
    plot(t,a3,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',2)
    ylabel('(3)','FontWeight','bold')
    grid on,hold on
  
%     y=input('Press any key to continue:')
    kk=kk-3;
    %mod(i+2,length(colors))+1
    a4=a1+a2+a3;
    subplot(5,1,4)
    plot(t,a4,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',2)
    ylabel('(4)','FontWeight','bold')
    grid on,hold on

    subplot(5,1,5)
    plot(t,a4,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',2)
    grid on,hold on
    kk=kk+3;
    plot(t,a1,'color',colors(kk-2,:),'LineStyle',marks{j},'LineWidth',1.5)
    grid on,hold on
    plot(t,a2,'color',colors(kk-1,:),'LineStyle',marks{j},'LineWidth',1.5)
    grid on,hold on
    plot(t,a3,'color',colors(kk,:),'LineStyle',marks{j},'LineWidth',1.5)
    ylabel('(5)','FontWeight','bold')
    grid on
    
    if i<nn
        A=input('New coefficients(Default: [1,-1/3,1/5]?')
    end
%     if (A==0) 
%         i=3;
%     end
end

