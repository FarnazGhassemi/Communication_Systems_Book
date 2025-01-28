%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Simulation 3_2:                       %
%                    Interference of EOG on EEG                %
%                                                              %
%        Book : Analog & Digital Communication Systems         %
%                   By: Dr.Farnaz Ghassemi                     %
%                   Chapter 3-Section 3-2                      %
%                                                              %
%                                                              %
%   Version.1:             03/10/27---Dr.Ghassemi              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc;
clear all;
close all;
propname={'FontAngle','FontName','FontSize','LineWidth','NextPlot','DrawMode'};
propval={'italic','Monotype Corsiva',12,.5,'new','fast'};
Fig_No=0;
colors=[.08 .16 .55
        .85 .16 0
        .17 .51 .34
        .75 0 .75
        .04 .14 .42
        1 .6 .78
        0 .5 0
        .68 .48 0];% 1:Dark Blue, 2:Red, 3:Green, 4:Purpul, 5:Light blue, 6:Pink, 7:Light Green
    
channels={'Fp1';'Fp2';'F3';'F4';'C3';'C4';'A2';'P3';'P4';'O1';'O2';'F7';'F8';...
    'T3';'T4';'T5';'T6';'Fz';'Cz';'Pz';'EOG';'ECG'};
[Dnamn pathn]=uigetfile('111_EEGLAB*.mat','Subject''s Data file');
Dfile=[pathn Dnamn];
load(Dfile)
filt_sig_new=filt_sig;


%------------------------ Adding his own EOG, Other one EOG and simulated EOG ------------------------------
PM=cd;
load([PM,'\ABio7.mat'])



ind_Art={281.3*200:285*200,651*200:652*200,160*200:163*200,697.5*200:699.2*200};% periods of good artifacts of his own, especially EOG

for j=1%[4,6]%1:length(ind)
    a=[];
    ind=ind_Art{j};
    index=ind(1):ind(1)+1000;
    a=filt_sig_new(1:21,index);
%     Fig_No=Fig_No+1;
%     figure(Fig_No)        
%     for i=1:7, subplot(7,1,i), plot(index(1)/200:0.005:index(end)/200,a(i,:)), end
%     Fig_No=Fig_No+1;
%     figure(Fig_No)
%     for i=8:14, subplot(7,1,i-7), plot(index(1)/200:0.005:index(end)/200,a(i,:)), end
%     Fig_No=Fig_No+1;
%     figure(Fig_No)
%     for i=15:21, subplot(7,1,i-14), plot(index(1)/200:0.005:index(end)/200,a(i,:)), end
    recos_EEG=a;
%         save(['Cons_EEG_',num2str(Dnamn(1:3)),'_',num2str(j),'_EOG',num2str(l),'.mat'],'recos_EEG')
%             figure
%             for i=1:7, subplot(7,1,i), plot(index(1)/200:0.005:index(end)/200,a(i,:),index(1)/200:0.005:index(end)/200,recos_EEG(i,:)), end
%             figure
%             for i=8:14, subplot(7,1,i-7), plot(index(1)/200:0.005:index(end)/200,a(i,:),index(1)/200:0.005:index(end)/200,recos_EEG(i,:)), end
%             figure
%             for i=15:21, subplot(7,1,i-14), plot(index(1)/200:0.005:index(end)/200,a(i,:),index(1)/200:0.005:index(end)/200,recos_EEG(i,:)), end
        
    Fig_No=Fig_No+1;
    figure(Fig_No)
    for i=1:21
        plot(index(1)/200:0.005:index(end)/200,a(i,:)-(i-1)*200,index(1)/200:0.005:index(end)/200,recos_EEG(i,:)-(i-1)*200)
        hold on
        text(index(1)/200+0.025,-(i-1)*200+75,channels{i})
        axis off
    end
   % i=22;
   % plot(index(1)/200:0.005:index(end)/200,benchcicbar(4,1:1001)*50-(i-1)*200)
        hold on
        text(index(1)/200+0.025,-(i-1)*200+75,channels{i})
        axis off
    title(['EEG: ',num2str(j)])
    save(['Real_EEG_',num2str(Dnamn(1:3)),'_',num2str(j),'.mat'],'recos_EEG')
end



sim_data=recos_EEG;
AR_order=10;
ortho=0;
[W, Wefica, Wwasobi, ISRwa, ISRef, metoda]= combi(sim_data,AR_order,ortho);  
invw=inv(W);
Y=W*sim_data;
Y_new=W*sim_data;

[R,P]=corr(sim_data(end,:)',Y_new')
ind_EOG=find(P<0.01 & abs(R)>0.8)
    if isempty(ind_EOG)
        [sorted_r,ind_r]=sort(abs(R),'descend');
        l=1;
        while P(ind_r(l))>0.05
            l=l+1;
        end
        ind_EOG=ind_r(l)  
        disp(['MAX Correlation for p300 was ',num2str(sorted_r(l))])
    end
Y_new(ind_EOG,:)=zeros(1,length(Y_new));
X_new=invw*Y_new;
%----------------- Wavelet ------------------------------
dec = mdwtdec('r',Y(ind_EOG,:),16,'db2');
[XD,decDEN,THRESH] = mswden('den',dec,'sqtwolog','sln');
Y_new_WT=Y;
Y_new_WT(ind_EOG,:)=Y(ind_EOG,:)-XD;
X_new_WT=invw*Y_new_WT;

Fig_No=Fig_No+1;
figure(Fig_No)
subplot(1,2,1)
for i=1:21
%     size(sim_data)
%     size(0:0.005:(length(sim_data)-1)/200)
    plot(0:0.005:(length(sim_data)-1)/200,sim_data(i,:)-(i-1)*200,'color',colors(1,:))
    hold on
    plot(0:0.005:(length(sim_data)-1)/200,X_new(i,:)-(i-1)*200,'color',colors(3,:))
    hold on
    plot(0:0.005:(length(sim_data)-1)/200,X_new_WT(i,:)-(i-1)*200,'color',colors(2,:))
    hold on
    text(0.025,-(i-1)*200+75,channels{i})
    axis off
end
legend('Noisy Data','Denoised Data/ICA','Denoised Data/W-ICA')
title(['Denoising Results for Real Data'])
l=0;
for i=[15:20]
    l=l+1;
    subplot(6,2,(l-1)*2+2)
%     size(sim_data)
%     size(0:0.005:(length(sim_data)-1)/200)
    plot(0:0.005:(length(sim_data)-1)/200,X_new(i,:)-(l-1)*200,'color',colors(3,:),'LineWidth',2)
    hold on
    plot(0:0.005:(length(sim_data)-1)/200,X_new_WT(i,:)-(l-1)*200,'color',colors(8,:))
    hold on
    text(0.025,-(l-1)*200+75,channels{i})
    axis off
end
legend('Denoised Data/ICA','Denoised Data/W-ICA')
Fig_No=Fig_No+1;
figure(Fig_No)
subplot(1,2,1)
for i=1:21
%     size(sim_data)
%     size(0:0.005:(length(sim_data)-1)/200)
    plot(0:0.005:(length(sim_data)-1)/200,sim_data(i,:)-(i-1)*200,'color',colors(1,:), 'LineWidth',1.5)
    hold on
    %plot(0:0.005:(length(sim_data)-1)/200,X_new(i,:)-(i-1)*200,'color',colors(3,:))
    %hold on
    text(0.025,-(i-1)*200+75,channels{i})
    axis off
end
%legend('Noisy Data','Denoised Data')
title(['21 EOG Interfered with EEG Data'])
subplot(1,2,2)
for i=1:20
    %plot(0:0.005:(length(sim_data)-1)/200,sim_data(i,:)-(i-1)*200,'color',colors(1,:))
    %hold on
    plot(0:0.005:(length(sim_data)-1)/200,X_new_WT(i,:)-(i-1)*200,'color',colors(3,:), 'LineWidth',1.5)
    hold on
    text(0.025,-(i-1)*200+75,channels{i})
    axis off
end
i=21;
plot(0:0.005:(length(sim_data)-1)/200,sim_data(i,:)-(i-1)*200,'color',colors(2,:), 'LineWidth',1.5)
hold on
text(0.025,-(i-1)*200+75,channels{i})
    axis off
%legend('Noisy Data','Denoised Data')
title(['21 EEG Data + EOG Data Separately'])

Fig_No=Fig_No+1;
figure(Fig_No)
l=0;
for i=[1,11,18,19,20,21]
    l=l+1;
    plot(recos_EEG(i,:)-(l-1)*200,'color',colors(1,:), 'LineWidth',1.5)
    hold on
    %plot(X_new(i,:)-(l-1)*200,'color',colors(5,:))
    %hold on
    plot(X_new_WT(i,:)-(l-1)*200,'color',colors(3,:), 'LineWidth',1.5)
    hold on
    

    text(0.025,-(l-1)*200+75,channels{i})
    axis off
end
legend('EEG Data interfered with EOG','EEG Data')
title(['5 EEG Data with & without EOG Interference'])


