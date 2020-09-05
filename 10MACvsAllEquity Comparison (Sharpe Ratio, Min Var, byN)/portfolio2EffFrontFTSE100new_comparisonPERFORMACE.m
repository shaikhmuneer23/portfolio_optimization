format long

%------------------------  JULY2013 TO JULY2014 ---------------------------%
   
%Import price data from Excel
data14 = xlsread('price_3year_95assets.xlsx','July13 - July14','B2:CR263');
data14FTSE = xlsread('price_3year_95assets','July13 - July14','CS2:CS263');
n14 = size(data14, 2); %no. of assets
[num,assetNames14,raw] = xlsread('price_3year_95assets.xlsx','July13 - July14','B1:CR1');
%colorVec=hsv(n14);

%Risk Free rate (Long term Govt. bond)
rf=0.08;

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
   %log return
    ret14 = log(data14(2:end, :)./data14(1:end-1,:));
    ret14 = ret14*263; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu14=mean(ret14);
   sigma14=cov(ret14);
   corr14=corrcoef(ret14);
   sd14 = sqrt([diag(sigma14)]');

   
        mu14P = min(mu14);
        i=1;
        while mu14P <= max(mu14)
            wP14=quadprog(sigma14,[],[-mu14;-eye(n14)],[-(mu14P);zeros(n14,1)],ones(1,n14),1);
            sPort14(i)=sqrt(wP14'*sigma14*wP14);
            mu14Port(i)=mu14P;
            mu14P=mu14P+0.005; %increment muP;
            i=i+1;
        end
      
        
        hold all;
        
        %FINDING MIN-VAR INDEX
        sPort14T=sPort14';  %sPort to COLUMN vector
        sPort14TMin=sPort14T(1:end-1, :)./sPort14T(2:end,:); %sPortT that has min sd14 repeated will all be flagged '1'
        MinVarIndexSize14=size(find(round(sPort14TMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex14=MinVarIndexSize14(1)+1; %size where minimum sd14 occurs
        figure(1)
        plot(sPort14(MinVarIndex14),mu14Port(MinVarIndex14),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort14(MinVarIndex14)+0.045,mu14Port(MinVarIndex14),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14(MinVarIndex14)+0.045,mu14Port(MinVarIndex14)-0.02,strcat('\sigma=', num2str(sPort14(MinVarIndex14)),'  \mu=',num2str(mu14Port(MinVarIndex14))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP14MinVar=quadprog(sigma14,[],[-mu14;-eye(n14)],[-(mu14Port(MinVarIndex14));zeros(n14,1)],ones(1,n14),1);
        wP14MinVar=wP14MinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe14 MaxSharpeIndex14]=max( (mu14Port-rf) ./ sPort14 );
        x=0:3;
        plot(x, MaxSharpe14*x + rf)
        plot(sPort14(MaxSharpeIndex14),mu14Port(MaxSharpeIndex14),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort14(MaxSharpeIndex14)+0.045,mu14Port(MaxSharpeIndex14),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14(MaxSharpeIndex14)+0.045,mu14Port(MaxSharpeIndex14)-0.02,strcat('\sigma=', num2str(sPort14(MaxSharpeIndex14)),'  \mu=',num2str(mu14Port(MaxSharpeIndex14))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP14MaxSharpe=quadprog(sigma14,[],[-mu14;-eye(n14)],[-(mu14Port(MaxSharpeIndex14));zeros(n14,1)],ones(1,n14),1);
        wP14MaxSharpe=wP14MaxSharpe.*100;
        
    L1 = plot(sPort14(MinVarIndex14:end),mu14Port(MinVarIndex14:end));
    L1(1).LineWidth = 3;
    %legend('July 13 - July 14')
    %for t=1:n14
    %    text(sd14(t),mu14(t),assetNames14(t),'FontSize', 5,'Color','g');
    %end

    
%{
  p(i) = Portfolio;
  p(i) = Portfolio(p(i), 'LowerBound', zeros(size(mu)), 'LowerBudget', 1, 'UpperBudget', 1, 'AssetMean', mu, 'AssetCovar', sigma);
  
  hold on;
  plotFrontier(p(i));
  legendInfo{i}=([num2str(noAssets), ' assets']);
  i=i+1;
%}

   

title('FTSE 100','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');



%{
%EQUAL WEIGHTED MULTI ASSET PORTFOLIO (1/N)
wEq(1:n,1)=1/n;  %column vector with equal weights
muPortEq=sum(wEq.*mu'); %equal weighted portfolio return (mu/n)
sPortEq=sqrt(wEq'*sigma*wEq); %SD of equal weighted portfolio
plot(sPortEq,muPortEq,'p','MarkerSize',10,'MarkerFaceColor','b','Color','b');
text(sPortEq+0.045,muPortEq,'Equal Weighted FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text
%}

%FTSE100 Index
   %log return
    ret14FTSE = log(data14FTSE(2:end, :)./data14FTSE(1:end-1,:));
    ret14FTSE = ret14FTSE*263; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu14FTSE=mean(ret14FTSE);
   sigma14FTSE=cov(ret14FTSE);
   corr14FTSE=corrcoef(ret14FTSE);
   sd14FTSE = sqrt([diag(sigma14FTSE)]');
   
    plot(sd14FTSE,mu14FTSE,'p','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd14FTSE+0.05,mu14FTSE,'FTSE100 2014','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd14FTSE+0.05,mu14FTSE-0.02,strcat('\sigma=', num2str(sd14FTSE),'  \mu=',num2str(mu14FTSE)),'FontSize', 6,'Color','r')
    
    %FTSE100 MIN-VAR WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(2)
    subplot(3,1,1)
    h = bar([wP14MinVar wP14MaxSharpe]);
    title('FTSE100 2014 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames14,'XTick',1:numel(assetNames14))
    %ax.XTickLabelRotation = 45;
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);
%--------------------------------------------------------------------------%



%------------------------  JULY2014 TO JULY2015 ---------------------------%
   
%Import price data from Excel
data15 = xlsread('price_3year_95assets','July14 - July15','B2:CR263');
data15FTSE = xlsread('price_3year_95assets.xlsx','July14 - July15','CS2:CS263');
n15 = size(data15, 2); %no. of assets
[num,assetNames15,raw] = xlsread('price_3year_95assets.xlsx','July14 - July15','B1:CR1');
%colorVec=hsv(n15);

% Import the data, extracting spreadsheet dates in Excel serial date format
%Imported dates are starting from 2nd row, to reflect the return dates
[~, ~, raw, dates] = xlsread('C:\Users\Muneer\Documents\MATLAB\price_3year_95assets.xlsx','July14 - July15','A3:A263','',@convertSpreadsheetExcelDates);
dates15 = dates(:,1);
Date15 = datetime([dates15{:,1}].', 'ConvertFrom', 'Excel', 'Format', 'dd/MM/yyyy');
% Clear temporary variables
clearvars raw dates;

%Risk Free rate (Long term Govt. bond)
rf=0.08;

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
   %log return
    ret15 = log(data15(2:end, :)./data15(1:end-1,:));
    ret15 = ret15*263; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu15=mean(ret15);
   sigma15=cov(ret15);
   corr15=corrcoef(ret15);
   sd15 = sqrt([diag(sigma15)]');

   
        mu15P = min(mu15);
        i=1;
        while mu15P <= max(mu15)
            wP15=quadprog(sigma15,[],[-mu15;-eye(n15)],[-(mu15P);zeros(n15,1)],ones(1,n15),1);
            sPort15(i)=sqrt(wP15'*sigma15*wP15);
            mu15Port(i)=mu15P;
            mu15P=mu15P+0.005; %increment muP;
            i=i+1;
        end
      
        
        %hold all;
        
        %FINDING MIN-VAR INDEX
        sPort15T=sPort15';  %sPort to COLUMN vector
        sPort15TMin=sPort15T(1:end-1, :)./sPort15T(2:end,:); %sPortT that has min sd15 repeated will all be flagged '1'
        MinVarIndexSize15=size(find(round(sPort15TMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex15=MinVarIndexSize15(1)+1; %size where minimum sd15 occurs
        figure(1)
        plot(sPort15(MinVarIndex15),mu15Port(MinVarIndex15),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort15(MinVarIndex15)+0.045,mu15Port(MinVarIndex15),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15(MinVarIndex15)+0.045,mu15Port(MinVarIndex15)-0.02,strcat('\sigma=', num2str(sPort15(MinVarIndex15)),'  \mu=',num2str(mu15Port(MinVarIndex15))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP15MinVar=quadprog(sigma15,[],[-mu15;-eye(n15)],[-(mu15Port(MinVarIndex15));zeros(n15,1)],ones(1,n15),1);
        wP15MinVar=wP15MinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe15 MaxSharpeIndex15]=max( (mu15Port-rf) ./ sPort15 );
        x=0:3;
        figure(1)
        plot(x, MaxSharpe15*x + rf)
        plot(sPort15(MaxSharpeIndex15),mu15Port(MaxSharpeIndex15),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort15(MaxSharpeIndex15)+0.045,mu15Port(MaxSharpeIndex15),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15(MaxSharpeIndex15)+0.045,mu15Port(MaxSharpeIndex15)-0.02,strcat('\sigma=', num2str(sPort15(MaxSharpeIndex15)),'  \mu=',num2str(mu15Port(MaxSharpeIndex15))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP15MaxSharpe=quadprog(sigma15,[],[-mu15;-eye(n15)],[-(mu15Port(MaxSharpeIndex15));zeros(n15,1)],ones(1,n15),1);
        wP15MaxSharpe=wP15MaxSharpe.*100;
        
    figure(1)    
    L2 = plot(sPort15(MinVarIndex15:end),mu15Port(MinVarIndex15:end));
    L2(1).LineWidth = 3;
   
    %for t=1:n15
     %   text(sd15(t),mu15(t),assetNames15(t),'FontSize', 5,'Color','g');
    %end

    
%{
  p(i) = Portfolio;
  p(i) = Portfolio(p(i), 'LowerBound', zeros(size(mu)), 'LowerBudget', 1, 'UpperBudget', 1, 'AssetMean', mu, 'AssetCovar', sigma);
  
  hold on;
  plotFrontier(p(i));
  legendInfo{i}=([num2str(noAssets), ' assets']);
  i=i+1;
%}

   

title('FTSE 100','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');



%{
%EQUAL WEIGHTED MULTI ASSET PORTFOLIO (1/N)
wEq(1:n,1)=1/n;  %column vector with equal weights
muPortEq=sum(wEq.*mu'); %equal weighted portfolio return (mu/n)
sPortEq=sqrt(wEq'*sigma*wEq); %SD of equal weighted portfolio
plot(sPortEq,muPortEq,'p','MarkerSize',10,'MarkerFaceColor','b','Color','b');
text(sPortEq+0.045,muPortEq,'Equal Weighted FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text
%}

%FTSE100 Index
   %log return
    ret15FTSE = log(data15FTSE(2:end, :)./data15FTSE(1:end-1,:));
    ret15FTSE = ret15FTSE*263; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu15FTSE=mean(ret15FTSE);
   sigma15FTSE=cov(ret15FTSE);
   corr15FTSE=corrcoef(ret15FTSE);
   sd15FTSE = sqrt([diag(sigma15FTSE)]');
   
    figure(1)
    plot(sd15FTSE,mu15FTSE,'p','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd15FTSE+0.05,mu15FTSE,'FTSE100 2015','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd15FTSE+0.05,mu15FTSE-0.02,strcat('\sigma=', num2str(sd15FTSE),'  \mu=',num2str(mu15FTSE)),'FontSize', 6,'Color','r')
        
    %FTSE100 MIN-VAR WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(2)
    subplot(3,1,2)
    h = bar([wP15MinVar wP15MaxSharpe]);
    title('FTSE100 2015 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames15,'XTick',1:numel(assetNames15))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);
%----------------------------------------------------------------------------%
   
%------------------------  JULY2015 TO JULY2016 ---------------------------%
   
%Import price data from Excel
data16 = xlsread('price_3year_95assets.xlsx','July15 - July16','B2:CR261');
data16FTSE = xlsread('price_3year_95assets.xlsx','July15 - July16','CS2:CS261');
n16 = size(data16, 2); %no. of assets
[num,assetNames16,raw] = xlsread('price_3year_95assets.xlsx','July15 - July16','B1:CR1');
%colorVec=hsv(n16);

% Import the data, extracting spreadsheet dates in Excel serial date format
%Imported dates are starting from 2nd row, to reflect the return dates
[~, ~, raw, dates] = xlsread('C:\Users\Muneer\Documents\MATLAB\price_3year_95assets.xlsx','July15 - July16','A3:A261','',@convertSpreadsheetExcelDates);
dates16 = dates(:,1);
Date16 = datetime([dates16{:,1}].', 'ConvertFrom', 'Excel', 'Format', 'dd/MM/yyyy');
% Clear temporary variables
clearvars raw dates;

%Risk Free rate (Long term Govt. bond)
rf=0.08;

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
   %log return
    ret16 = log(data16(2:end, :)./data16(1:end-1,:));
    ret16 = ret16*261; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu16=mean(ret16);
   sigma16=cov(ret16);
   corr16=corrcoef(ret16);
   sd16 = sqrt([diag(sigma16)]');

   
        mu16P = min(mu16);
        i=1;
        while mu16P <= max(mu16)
            wP16=quadprog(sigma16,[],[-mu16;-eye(n16)],[-(mu16P);zeros(n16,1)],ones(1,n16),1);
            sPort16(i)=sqrt(wP16'*sigma16*wP16);
            mu16Port(i)=mu16P;
            mu16P=mu16P+0.005; %increment muP;
            i=i+1;
        end
      
        
        %hold all;
        
        %FINDING MIN-VAR INDEX
        sPort16T=sPort16';  %sPort to COLUMN vector
        sPort16TMin=sPort16T(1:end-1, :)./sPort16T(2:end,:); %sPortT that has min sd16 repeated will all be flagged '1'
        MinVarIndexSize16=size(find(round(sPort16TMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex16=MinVarIndexSize16(1)+1; %size where minimum sd16 occurs
        figure(1)
        plot(sPort16(MinVarIndex16),mu16Port(MinVarIndex16),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort16(MinVarIndex16)+0.045,mu16Port(MinVarIndex16),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16(MinVarIndex16)+0.045,mu16Port(MinVarIndex16)-0.02,strcat('\sigma=', num2str(sPort16(MinVarIndex16)),'  \mu=',num2str(mu16Port(MinVarIndex16))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP16MinVar=quadprog(sigma16,[],[-mu16;-eye(n16)],[-(mu16Port(MinVarIndex16));zeros(n16,1)],ones(1,n16),1);
        wP16MinVar=wP16MinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16 MaxSharpeIndex16]=max( (mu16Port-rf) ./ sPort16 );
        x=0:3;
        figure(1)
        plot(x, MaxSharpe16*x + rf)
        plot(sPort16(MaxSharpeIndex16),mu16Port(MaxSharpeIndex16),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort16(MaxSharpeIndex16)+0.045,mu16Port(MaxSharpeIndex16),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16(MaxSharpeIndex16)+0.045,mu16Port(MaxSharpeIndex16)-0.02,strcat('\sigma=', num2str(sPort16(MaxSharpeIndex16)),'  \mu=',num2str(mu16Port(MaxSharpeIndex16))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP16MaxSharpe=quadprog(sigma16,[],[-mu16;-eye(n16)],[-(mu16Port(MaxSharpeIndex16));zeros(n16,1)],ones(1,n16),1);
        wP16MaxSharpe=wP16MaxSharpe.*100;
        
    figure(1)    
    L3 = plot(sPort16(MinVarIndex16:end),mu16Port(MinVarIndex16:end),sd16,mu16,'.','MarkerSize',10);
    L3(1).LineWidth = 3;
    legend([L1,L2,L3(1)],'Year 2014','Year 2015','Year 2016')
    for t=1:n16
        text(sd16(t),mu16(t),assetNames16(t),'FontSize', 5,'Color','g');
    end

title('FTSE 100','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');



%{
%EQUAL WEIGHTED MULTI ASSET PORTFOLIO (1/N)
wEq(1:n,1)=1/n;  %column vector with equal weights
muPortEq=sum(wEq.*mu'); %equal weighted portfolio return (mu/n)
sPortEq=sqrt(wEq'*sigma*wEq); %SD of equal weighted portfolio
plot(sPortEq,muPortEq,'p','MarkerSize',10,'MarkerFaceColor','b','Color','b');
text(sPortEq+0.045,muPortEq,'Equal Weighted FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text
%}

%FTSE100 Index
   %log return
    ret16FTSE = log(data16FTSE(2:end, :)./data16FTSE(1:end-1,:));
    ret16FTSE = ret16FTSE*258; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu16FTSE=mean(ret16FTSE);
   sigma16FTSE=cov(ret16FTSE);
   corr16FTSE=corrcoef(ret16FTSE);
   sd16FTSE = sqrt([diag(sigma16FTSE)]');
   
    figure(1)
    plot(sd16FTSE,mu16FTSE,'p','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd16FTSE+0.05,mu16FTSE,'FTSE100 2016','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd16FTSE+0.05,mu16FTSE-0.02,strcat('\sigma=', num2str(sd16FTSE),'  \mu=',num2str(mu16FTSE)),'FontSize', 6,'Color','r')
        
    %FTSE100 MIN-VAR WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(2)
    subplot(3,1,3)
    h = bar([wP16MinVar wP16MaxSharpe]);
    title('FTSE100 2016 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames16,'XTick',1:numel(assetNames16))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);
%----------------------------------------------------------------------------%    













%------------------------ PORTFOLIO PERFORMANCE ---------------------------%
%Actual Rate of return of the following year 2014-2015
%Weights from 2013-2014 estimates - wP14

%Cumulative Return of ex-Post
ret15cumFTSE=log(data15FTSE(2:end)/data15FTSE(1));
for i=1:n15
ret15cum(:,i)=log(data15(2:end,i)/data15(1,i));
end
%Weights of ex-Ante
wP14MinVar; wP14MaxSharpe;

%Actual Cumlative Return of Individual Stock in Portfolio
for i=1:n15
ActualCumMinVar_ret15(:,i)=wP14MinVar(i)*ret15cum(1:end,i);
ActualCumMaxSharpe_ret15(:,i)=wP14MaxSharpe(i)*ret15cum(1:end,i);
end

%Portfolio Cumulative Return over the year
ActualPortCumMinVar_ret15=sum(ActualCumMinVar_ret15,2);
ActualPortCumMaxSharpe_ret15=sum(ActualCumMaxSharpe_ret15,2);

figure(4)
subplot(2,1,1)
PP15MinVar = plot(Date15, ActualPortCumMinVar_ret15);
hold all
subplot(2,1,1)
PP15MaxSharpe = plot(Date15, ActualPortCumMaxSharpe_ret15);
subplot(2,1,1)
PP15Benchmark = plot(Date15, ret15cumFTSE);
legend([PP15MinVar,PP15MaxSharpe,PP15Benchmark],'Min-Var Performance 2014-2015','Max-Sharpe Performance 2014-2015','FTSE 100 Benchmark')
title('Portfolio Performance (Cumulative Return)','FontSize',15,'FontWeight','bold','Color','r');
ylabel('% Change in Return','FontSize',12,'FontWeight','bold','Color','b');

%------------------------ PORTFOLIO PERFORMANCE ---------------------------%
%Actual Rate of return of the following year 2014-2015
%Weights from 2014-2015 estimates - wP15

%Cumulative Return of ex-Post
ret16cumFTSE=log(data16FTSE(2:end)/data16FTSE(1));
for i=1:n16
ret16cum(:,i)=log(data16(2:end,i)/data16(1,i));
end

%Weights of ex-Ante
wP15MinVar; wP15MaxSharpe;

%Actual Cumlative Return of Individual Stock in Portfolio
for i=1:n15
ActualCumMinVar_ret16(:,i)=wP15MinVar(i)*ret16cum(1:end,i);
ActualCumMaxSharpe_ret16(:,i)=wP15MaxSharpe(i)*ret16cum(1:end,i);
end

%Portfolio Cumulative Return over the year
ActualPortCumMinVar_ret16=sum(ActualCumMinVar_ret16,2);
ActualPortCumMaxSharpe_ret16=sum(ActualCumMaxSharpe_ret16,2);
figure(4)
subplot(2,1,2)
PP16MinVar = plot(Date16, ActualPortCumMinVar_ret16);
hold all
subplot(2,1,2)
PP16MaxSharpe = plot(Date16, ActualPortCumMaxSharpe_ret16);
subplot(2,1,2)
PP16Benchmark = plot(Date16, ret16cumFTSE);
legend([PP16MinVar,PP16MaxSharpe,PP16Benchmark],'Min-Var Performance 2015-2016','Max-Sharpe Performance 2015-2016','FTSE100 Benchmark')
ylabel('% Change in Return','FontSize',12,'FontWeight','bold','Color','b');



%-------PORTFOLIO RETURN WITH REFERENCE TO BEGINING OF PORTFOLIO-------------------%
%Actual Rate of return of the following year 2014-2016
%Weights from 2014-2015 & 2015-2016 estimates - wP15,wP16

data14to16 = xlsread('price_3year_95assets.xlsx','July14 - July16','B2:CR522');
data14to16FTSE = xlsread('price_3year_95assets','July14 - July16','CS2:CS522');
% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread('C:\Users\Muneer\Documents\MATLAB\price_3year_95assets.xlsx','July14 - July16','A3:A522','',@convertSpreadsheetExcelDates);
dates = dates(:,1);
Date = datetime([dates{:,1}].', 'ConvertFrom', 'Excel', 'Format', 'dd/MM/yyyy');
clearvars raw dates;


%ChangeInReturn of ex-Post
retcumFTSE=log(data14to16FTSE(2:end)/data14to16FTSE(1));
for i=1:n16
retcum(:,i)=log(data14to16(2:end,i)/data14to16(1,i));
end

%Weights of ex-Ante
wP14MinVar; wP14MaxSharpe;
wP15MinVar; wP15MaxSharpe;

%Actual %ChangeInReturn Return of Individual Stock in Portfolio
for i=1:n16
ActualCumMinVar(1:size(ret15cum),i)=wP14MinVar(i)*retcum(1:size(ret15cum),i);
ActualCumMinVar(size(ret15cum)+1:size(retcum),i)=wP15MinVar(i)*retcum(size(ret15cum)+1:size(retcum),i);

ActualCumMaxSharpe(1:size(ret15cum),i)=wP14MaxSharpe(i)*retcum(1:size(ret15cum),i);
ActualCumMaxSharpe(size(ret15cum)+1:size(retcum),i)=wP15MaxSharpe(i)*retcum(size(ret15cum)+1:size(retcum),i);
end

%Portfolio Cumulative Return over 2 years
ActualPortCumMinVar=sum(ActualCumMinVar,2);
ActualPortCumMaxSharpe=sum(ActualCumMaxSharpe,2);

figure(5)
PPMinVar = plot(Date, ActualPortCumMinVar);
hold all
PPMaxSharpe = plot(Date, ActualPortCumMaxSharpe);
PPBenchmark = plot(Date, retcumFTSE);
legend([PPMinVar,PPMaxSharpe,PPBenchmark],'Min-Var Performance 2014-2016','Max-Sharpe Performance 2014-2016','FTSE 100 Benchmark')
y1=get(gca,'ylim');
hold on
BL = plot([Date(261) Date(261)],y1);
BL.LineWidth = 2;
title('Portfolio Performance (Cumulative Return)','FontSize',15,'FontWeight','bold','Color','r');
ylabel('% Change in Return','FontSize',12,'FontWeight','bold','Color','b');


%grid on;
%set(gca,'Xcolor',[0.5 0.5 0.5]);
%set(gca,'Ycolor',[0.5 0.5 0.5]);
%hold off;