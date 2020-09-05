format long

%Risk Free rate (Long term Govt. bond)
rf14=0.3127/100; %2012 - Annual average 3m T-Bill, BoE

%ALL 10 MAC PORTFOLIO ASSETS
data14MAC = xlsread('price10MAC.xlsx','July13 - July14','B2:K263');
n14MAC = size(data14MAC, 2); %no. of assets
[num,assetNames14MAC,raw] = xlsread('price10MAC.xlsx','July13 - July14','B1:K1');
   %log return
    ret14MAC = log(data14MAC(2:end, :)./data14MAC(1:end-1,:));
    ret14MAC = ret14MAC*262; %---TO BE CORRECTED!---%
   
    hold all
   %mean & co-var
   mu14MAC=mean(ret14MAC);
   sigma14MAC=cov(ret14MAC);
   corr14MAC=corrcoef(ret14MAC);
   sd14MAC = sqrt([diag(sigma14MAC)]');

   
        muP14MAC = min(mu14MAC);
        j=1;
        while muP14MAC <= max(mu14MAC)
            wP14MAC=quadprog(sigma14MAC,[],[-mu14MAC;-eye(n14MAC)],[-(muP14MAC);zeros(n14MAC,1)],ones(1,n14MAC),1);
            sPort14MAC(j)=sqrt(wP14MAC'*sigma14MAC*wP14MAC);
            muPort14MAC(j)=muP14MAC;
            muP14MAC=muP14MAC+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort14MACT=sPort14MAC';  %sPort to COLUMN vector
        sPort14MACTMin=sPort14MACT(1:end-1, :)./sPort14MACT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar14MACIndexSize=size(find(round(sPort14MACTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar14MACIndex=MinVar14MACIndexSize(1)+1; %size where minimum SD occurs
        figure(1)
        hold all
        plot(sPort14MAC(MinVar14MACIndex),muPort14MAC(MinVar14MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14MAC(MinVar14MACIndex)+0.045,muPort14MAC(MinVar14MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP14MACMinVar=quadprog(sigma14MAC,[],[-mu14MAC;-eye(n14MAC)],[-(muPort14MAC(MinVar14MACIndex));zeros(n14MAC,1)],ones(1,n14MAC),1);
        wP14MACMinVar=wP14MACMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe14MAC MaxSharpeIndex14MAC]=max( (muPort14MAC-rf14) ./ sPort14MAC );
        x=0:.01:sPort14MAC(MaxSharpeIndex14MAC);
        figure(1)
        plot(x, MaxSharpe14MAC*x + rf14)
        plot(sPort14MAC(MaxSharpeIndex14MAC),muPort14MAC(MaxSharpeIndex14MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14MAC(MaxSharpeIndex14MAC)+0.045,muPort14MAC(MaxSharpeIndex14MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14MAC(MaxSharpeIndex14MAC)+0.045,muPort14MAC(MaxSharpeIndex14MAC)-0.02,strcat('\sigma=', num2str(sPort14MAC(MaxSharpeIndex14MAC)),'  \mu=',num2str(muPort14MAC(MaxSharpeIndex14MAC))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP14MACMaxSharpe=quadprog(sigma14MAC,[],[-mu14MAC;-eye(n14MAC)],[-(muPort14MAC(MaxSharpeIndex14MAC));zeros(n14MAC,1)],ones(1,n14MAC),1);
        wP14MACMaxSharpe=wP14MACMaxSharpe.*100;
        
        
    %L1 = plot(sPort14MAC(MinVar14MACIndex:end),muPort14MAC(MinVar14MACIndex:end),sd14MAC,mu14MAC,'.','MarkerSize',7,'Color','r');
    L1 = plot(sPort14MAC(MinVar14MACIndex:end),muPort14MAC(MinVar14MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    %for t=1:n14MAC
     %   text(sd14MAC(t),mu14MAC(t),assetNames14MAC(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 14MAC PORTFOLIO (1/N)
wEq14MAC(1:n14MAC,1)=1/n14MAC;  %column vector with equal weights
muPortEq14MAC=sum(wEq14MAC.*mu14MAC'); %equal weighted portfolio return (mu/n)
sPortEq14MAC=sqrt(wEq14MAC'*sigma14MAC*wEq14MAC); %SD of equal weighted portfolio
plot(sPortEq14MAC,muPortEq14MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
text(sPortEq14MAC+0.05,muPortEq14MAC,'1/N MAC','FontSize', 6,'Color','g'); %+0.05 to offset text

%------------------------------------------------------------------------%

%ALL 14Equity PORTFOLIO 6 ASSETS
data14Equity = xlsread('price6AllEquity.xlsx','July13 - July14','B2:G263');
n14Equity = size(data14Equity, 2); %no. of assets
[num,assetNames14Equity,raw] = xlsread('price6AllEquity.xlsx','July13 - July14','B1:G1');
   %log return
    ret14Equity = log(data14Equity(2:end, :)./data14Equity(1:end-1,:));
    ret14Equity = ret14Equity*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu14Equity=mean(ret14Equity);
   sigma14Equity=cov(ret14Equity);
   corr14Equity=corrcoef(ret14Equity);
   sd14Equity = sqrt([diag(sigma14Equity)]');

   
        muP14Equity = min(mu14Equity);
        j=1;
        while muP14Equity <= max(mu14Equity)
            wP14Equity=quadprog(sigma14Equity,[],[-mu14Equity;-eye(n14Equity)],[-(muP14Equity);zeros(n14Equity,1)],ones(1,n14Equity),1);
            sPort14Equity(j)=sqrt(wP14Equity'*sigma14Equity*wP14Equity);
            muPort14Equity(j)=muP14Equity;
            muP14Equity=muP14Equity+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort14EquityT=sPort14Equity';  %sPort to COLUMN vector
        sPort14EquityTMin=sPort14EquityT(1:end-1, :)./sPort14EquityT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar14EquityIndexSize=size(find(round(sPort14EquityTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar14EquityIndex=MinVar14EquityIndexSize(1)+1; %size where minimum SD occurs
        plot(sPort14Equity(MinVar14EquityIndex),muPort14Equity(MinVar14EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14Equity(MinVar14EquityIndex)+0.045,muPort14Equity(MinVar14EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP14EquityMinVar=quadprog(sigma14Equity,[],[-mu14Equity;-eye(n14Equity)],[-(muPort14Equity(MinVar14EquityIndex));zeros(n14Equity,1)],ones(1,n14Equity),1);
        wP14EquityMinVar=wP14EquityMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe14Equity MaxSharpeIndex14Equity]=max( (muPort14Equity-rf14) ./ sPort14Equity );
        x=0:.01:sPort14Equity(MaxSharpeIndex14Equity);
        figure(1)
        plot(x, MaxSharpe14Equity*x + rf14)
        plot(sPort14Equity(MaxSharpeIndex14Equity),muPort14Equity(MaxSharpeIndex14Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14Equity(MaxSharpeIndex14Equity)+0.045,muPort14Equity(MaxSharpeIndex14Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14Equity(MaxSharpeIndex14Equity)+0.045,muPort14Equity(MaxSharpeIndex14Equity)-0.02,strcat('\sigma=', num2str(sPort14Equity(MaxSharpeIndex14Equity)),'  \mu=',num2str(muPort14Equity(MaxSharpeIndex14Equity))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP14EquityMaxSharpe=quadprog(sigma14Equity,[],[-mu14Equity;-eye(n14Equity)],[-(muPort14Equity(MaxSharpeIndex14Equity));zeros(n14Equity,1)],ones(1,n14Equity),1);
        wP14EquityMaxSharpe=wP14EquityMaxSharpe.*100;
        
    %L2 = plot(sPort14Equity(MinVar14EquityIndex:end),muPort14Equity(MinVar14EquityIndex:end),sd14Equity,mu14Equity,'.','MarkerSize',7,'Color','r');
    L2 = plot(sPort14Equity(MinVar14EquityIndex:end),muPort14Equity(MinVar14EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    %for t=1:n14Equity
     %   text(sd14Equity(t),mu14Equity(t),assetNames14Equity(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 14Equity PORTFOLIO (1/N)
wEq14Equity(1:n14Equity,1)=1/n14Equity;  %column vector with equal weights
muPortEq14Equity=sum(wEq14Equity.*mu14Equity'); %equal weighted portfolio return (mu/n)
sPortEq14Equity=sqrt(wEq14Equity'*sigma14Equity*wEq14Equity); %SD of equal weighted portfolio
plot(sPortEq14Equity,muPortEq14Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');
text(sPortEq14Equity+0.05,muPortEq14Equity,'1/N Equity','FontSize', 6,'Color','r'); %+0.05 to offset text

%------------------------------------------------------------------------%

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
data14FTSE = xlsread('price_3year_95assets.xlsx','July13 - July14','B2:CR263');
dataFTSE14_Benchmark = xlsread('price_3year_95assets.xlsx','July13 - July14','CS2:CS263');
n14FTSE = size(data14FTSE, 2); %no. of assets
[num,assetNames14FTSE,raw] = xlsread('price_3year_95assets.xlsx','July13 - July14','B1:CR1');
   %log return
    ret14FTSE = log(data14FTSE(2:end, :)./data14FTSE(1:end-1,:));
    ret14FTSE = ret14FTSE*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu14FTSE=mean(ret14FTSE);
   sigma14FTSE=cov(ret14FTSE);
   corr14FTSE=corrcoef(ret14FTSE);
   sd14FTSE = sqrt([diag(sigma14FTSE)]');

        mu14FTSEP = min(mu14FTSE);
        i=1;
        while mu14FTSEP <= max(mu14FTSE)
            wP14FTSE=quadprog(sigma14FTSE,[],[-mu14FTSE;-eye(n14FTSE)],[-(mu14FTSEP);zeros(n14FTSE,1)],ones(1,n14FTSE),1);
            sPort14FTSE(i)=sqrt(wP14FTSE'*sigma14FTSE*wP14FTSE);
            mu14FTSEPort(i)=mu14FTSEP;
            mu14FTSEP=mu14FTSEP+0.005; %increment muP;
            i=i+1;
        end
              
        %FINDING MIN-VAR INDEX
        sPort14FTSET=sPort14FTSE';  %sPort to COLUMN vector
        sPort14FTSETMin=sPort14FTSET(1:end-1, :)./sPort14FTSET(2:end,:); %sPortT that has min sd14 repeated will all be flagged '1'
        MinVarIndexSize14FTSE=size(find(round(sPort14FTSETMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex14FTSE=MinVarIndexSize14FTSE(1)+1; %size where minimum sd14 occurs
        figure(1)
        plot(sPort14FTSE(MinVarIndex14FTSE),mu14FTSEPort(MinVarIndex14FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14FTSE(MinVarIndex14FTSE)+0.045,mu14FTSEPort(MinVarIndex14FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14FTSE(MinVarIndex14FTSE)+0.045,mu14FTSEPort(MinVarIndex14FTSE)-0.02,strcat('\sigma=', num2str(sPort14FTSE(MinVarIndex14FTSE)),'  \mu=',num2str(mu14FTSEPort(MinVarIndex14FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP14FTSEMinVar=quadprog(sigma14FTSE,[],[-mu14FTSE;-eye(n14FTSE)],[-(mu14FTSEPort(MinVarIndex14FTSE));zeros(n14FTSE,1)],ones(1,n14FTSE),1);
        wP14FTSEMinVar=wP14FTSEMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe14FTSE MaxSharpeIndex14FTSE]=max( (mu14FTSEPort-rf14) ./ sPort14FTSE );
        x=0:.01:sPort14FTSE(MaxSharpeIndex14FTSE);
        figure(1)
        plot(x, MaxSharpe14FTSE*x + rf14)
        plot(sPort14FTSE(MaxSharpeIndex14FTSE),mu14FTSEPort(MaxSharpeIndex14FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14FTSE(MaxSharpeIndex14FTSE)+0.045,mu14FTSEPort(MaxSharpeIndex14FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort14FTSE(MaxSharpeIndex14FTSE)+0.045,mu14FTSEPort(MaxSharpeIndex14FTSE)-0.02,strcat('\sigma=', num2str(sPort14FTSE(MaxSharpeIndex14FTSE)),'  \mu=',num2str(mu14FTSEPort(MaxSharpeIndex14FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP14FTSEMaxSharpe=quadprog(sigma14FTSE,[],[-mu14FTSE;-eye(n14FTSE)],[-(mu14FTSEPort(MaxSharpeIndex14FTSE));zeros(n14FTSE,1)],ones(1,n14FTSE),1);
        wP14FTSEMaxSharpe=wP14FTSEMaxSharpe.*100;
        
    figure(1)    
    %L3 = plot(sPort14FTSE(MinVarIndex14FTSE:end),mu14FTSEPort(MinVarIndex14FTSE:end),sd14FTSE,mu14FTSE,'.','MarkerSize',7);
    L3 = plot(sPort14FTSE(MinVarIndex14FTSE:end),mu14FTSEPort(MinVarIndex14FTSE:end));
    L3(1).LineWidth = 3;
    set(L3(1),'Color','b');
    
    legend([L1(1),L2(1),L3(1)],'MAC ETF 13-14','Equity ETF 13-14','FTSE100 13-14')
    %for t=1:n14FTSE
     %   text(sd14FTSE(t),mu14FTSE(t),assetNames14FTSE(t),'FontSize', 5,'Color','g');
    %end

title('FTSE 100','FontSize',14,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');

%EQUAL WEIGHTED FTSE100 PORTFOLIO (1/N)
wEq14FTSE(1:n14FTSE,1)=1/n14FTSE;  %column vector with equal weights
muPortEq14FTSE=sum(wEq14FTSE.*mu14FTSE'); %equal weighted portfolio return (mu/n)
sPortEq14FTSE=sqrt(wEq14FTSE'*sigma14FTSE*wEq14FTSE); %SD of equal weighted portfolio
plot(sPortEq14FTSE,muPortEq14FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');
text(sPortEq14FTSE+0.05,muPortEq14FTSE,'1/N FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text

%FTSE100 Index - 2014
data14FTSEB = xlsread('price_3year_95assets.xlsx','July13 - July14','CS2:CS263');
   %log return
    ret14FTSEB = log(data14FTSEB(2:end, :)./data14FTSEB(1:end-1,:));
    ret14FTSEB = ret14FTSEB*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu14FTSEB=mean(ret14FTSEB);
   sigma14FTSEB=cov(ret14FTSEB);
   corr14FTSEB=corrcoef(ret14FTSEB);
   sd14FTSEB = sqrt([diag(sigma14FTSEB)]');
  
    figure(1)
    plot(sd14FTSEB,mu14FTSEB,'o','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd14FTSEB+0.05,mu14FTSEB,'FTSEB100 2014','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd14FTSEB+0.05,mu14FTSEB-0.02,strcat('\sigma=', num2str(sd14FTSEB),'  \mu=',num2str(mu14FTSEB)),'FontSize', 6,'Color','r')
    

grid on;
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
hold off;




















%Risk Free rate (Long term Govt. bond)
rf15=0.2999/100; %2013 - Annual average 3m T-Bill, BoE

%ALL 10 MAC PORTFOLIO ASSETS
data15MAC = xlsread('price10MAC.xlsx','July14 - July15','B2:K263');
n15MAC = size(data15MAC, 2); %no. of assets
[num,assetNames15MAC,raw] = xlsread('price10MAC.xlsx','July14 - July15','B1:K1');
   %log return
    ret15MAC = log(data15MAC(2:end, :)./data15MAC(1:end-1,:));
    ret15MAC = ret15MAC*262; %---TO BE CORRECTED!---%
   
    hold all
   %mean & co-var
   mu15MAC=mean(ret15MAC);
   sigma15MAC=cov(ret15MAC);
   corr15MAC=corrcoef(ret15MAC);
   sd15MAC = sqrt([diag(sigma15MAC)]');

   
        muP15MAC = min(mu15MAC);
        j=1;
        while muP15MAC <= max(mu15MAC)
            wP15MAC=quadprog(sigma15MAC,[],[-mu15MAC;-eye(n15MAC)],[-(muP15MAC);zeros(n15MAC,1)],ones(1,n15MAC),1);
            sPort15MAC(j)=sqrt(wP15MAC'*sigma15MAC*wP15MAC);
            muPort15MAC(j)=muP15MAC;
            muP15MAC=muP15MAC+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort15MACT=sPort15MAC';  %sPort to COLUMN vector
        sPort15MACTMin=sPort15MACT(1:end-1, :)./sPort15MACT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar15MACIndexSize=size(find(round(sPort15MACTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar15MACIndex=MinVar15MACIndexSize(1)+1; %size where minimum SD occurs
        figure(2)
        hold all
        plot(sPort15MAC(MinVar15MACIndex),muPort15MAC(MinVar15MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15MAC(MinVar15MACIndex)+0.045,muPort15MAC(MinVar15MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP15MACMinVar=quadprog(sigma15MAC,[],[-mu15MAC;-eye(n15MAC)],[-(muPort15MAC(MinVar15MACIndex));zeros(n15MAC,1)],ones(1,n15MAC),1);
        wP15MACMinVar=wP15MACMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe15MAC MaxSharpeIndex15MAC]=max( (muPort15MAC-rf15) ./ sPort15MAC );
        x=0:.01:sPort15MAC(MaxSharpeIndex15MAC);
        figure(2)
        plot(x, MaxSharpe15MAC*x + rf15)
        plot(sPort15MAC(MaxSharpeIndex15MAC),muPort15MAC(MaxSharpeIndex15MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15MAC(MaxSharpeIndex15MAC)+0.045,muPort15MAC(MaxSharpeIndex15MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15MAC(MaxSharpeIndex15MAC)+0.045,muPort15MAC(MaxSharpeIndex15MAC)-0.02,strcat('\sigma=', num2str(sPort15MAC(MaxSharpeIndex15MAC)),'  \mu=',num2str(muPort15MAC(MaxSharpeIndex15MAC))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP15MACMaxSharpe=quadprog(sigma15MAC,[],[-mu15MAC;-eye(n15MAC)],[-(muPort15MAC(MaxSharpeIndex15MAC));zeros(n15MAC,1)],ones(1,n15MAC),1);
        wP15MACMaxSharpe=wP15MACMaxSharpe.*100;
        
        
    %L1 = plot(sPort15MAC(MinVar15MACIndex:end),muPort15MAC(MinVar15MACIndex:end),sd15MAC,mu15MAC,'.','MarkerSize',7,'Color','r');
    L1 = plot(sPort15MAC(MinVar15MACIndex:end),muPort15MAC(MinVar15MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    %for t=1:n15MAC
     %   text(sd15MAC(t),mu15MAC(t),assetNames15MAC(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 15MAC PORTFOLIO (1/N)
wEq15MAC(1:n15MAC,1)=1/n15MAC;  %column vector with equal weights
muPortEq15MAC=sum(wEq15MAC.*mu15MAC'); %equal weighted portfolio return (mu/n)
sPortEq15MAC=sqrt(wEq15MAC'*sigma15MAC*wEq15MAC); %SD of equal weighted portfolio
plot(sPortEq15MAC,muPortEq15MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
text(sPortEq15MAC+0.05,muPortEq15MAC,'1/N MAC','FontSize', 6,'Color','g'); %+0.05 to offset text

%------------------------------------------------------------------------%

%ALL 15Equity PORTFOLIO 6 ASSETS
data15Equity = xlsread('price6AllEquity.xlsx','July14 - July15','B2:G263');
n15Equity = size(data15Equity, 2); %no. of assets
[num,assetNames15Equity,raw] = xlsread('price6AllEquity.xlsx','July14 - July15','B1:G1');
   %log return
    ret15Equity = log(data15Equity(2:end, :)./data15Equity(1:end-1,:));
    ret15Equity = ret15Equity*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu15Equity=mean(ret15Equity);
   sigma15Equity=cov(ret15Equity);
   corr15Equity=corrcoef(ret15Equity);
   sd15Equity = sqrt([diag(sigma15Equity)]');

   
        muP15Equity = min(mu15Equity);
        j=1;
        while muP15Equity <= max(mu15Equity)
            wP15Equity=quadprog(sigma15Equity,[],[-mu15Equity;-eye(n15Equity)],[-(muP15Equity);zeros(n15Equity,1)],ones(1,n15Equity),1);
            sPort15Equity(j)=sqrt(wP15Equity'*sigma15Equity*wP15Equity);
            muPort15Equity(j)=muP15Equity;
            muP15Equity=muP15Equity+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort15EquityT=sPort15Equity';  %sPort to COLUMN vector
        sPort15EquityTMin=sPort15EquityT(1:end-1, :)./sPort15EquityT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar15EquityIndexSize=size(find(round(sPort15EquityTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar15EquityIndex=MinVar15EquityIndexSize(1)+1; %size where minimum SD occurs
        plot(sPort15Equity(MinVar15EquityIndex),muPort15Equity(MinVar15EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15Equity(MinVar15EquityIndex)+0.045,muPort15Equity(MinVar15EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP15EquityMinVar=quadprog(sigma15Equity,[],[-mu15Equity;-eye(n15Equity)],[-(muPort15Equity(MinVar15EquityIndex));zeros(n15Equity,1)],ones(1,n15Equity),1);
        wP15EquityMinVar=wP15EquityMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe15Equity MaxSharpeIndex15Equity]=max( (muPort15Equity-rf15) ./ sPort15Equity );
        x=0:.01:sPort15Equity(MaxSharpeIndex15Equity);
        figure(2)
        plot(x, MaxSharpe15Equity*x + rf15)
        plot(sPort15Equity(MaxSharpeIndex15Equity),muPort15Equity(MaxSharpeIndex15Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15Equity(MaxSharpeIndex15Equity)+0.045,muPort15Equity(MaxSharpeIndex15Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15Equity(MaxSharpeIndex15Equity)+0.045,muPort15Equity(MaxSharpeIndex15Equity)-0.02,strcat('\sigma=', num2str(sPort15Equity(MaxSharpeIndex15Equity)),'  \mu=',num2str(muPort15Equity(MaxSharpeIndex15Equity))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP15EquityMaxSharpe=quadprog(sigma15Equity,[],[-mu15Equity;-eye(n15Equity)],[-(muPort15Equity(MaxSharpeIndex15Equity));zeros(n15Equity,1)],ones(1,n15Equity),1);
        wP15EquityMaxSharpe=wP15EquityMaxSharpe.*100;
        
    %L2 = plot(sPort15Equity(MinVar15EquityIndex:end),muPort15Equity(MinVar15EquityIndex:end),sd15Equity,mu15Equity,'.','MarkerSize',7,'Color','r');
    L2 = plot(sPort15Equity(MinVar15EquityIndex:end),muPort15Equity(MinVar15EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    %for t=1:n15Equity
     %   text(sd15Equity(t),mu15Equity(t),assetNames15Equity(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 15Equity PORTFOLIO (1/N)
wEq15Equity(1:n15Equity,1)=1/n15Equity;  %column vector with equal weights
muPortEq15Equity=sum(wEq15Equity.*mu15Equity'); %equal weighted portfolio return (mu/n)
sPortEq15Equity=sqrt(wEq15Equity'*sigma15Equity*wEq15Equity); %SD of equal weighted portfolio
plot(sPortEq15Equity,muPortEq15Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');
text(sPortEq15Equity+0.05,muPortEq15Equity,'1/N Equity','FontSize', 6,'Color','r'); %+0.05 to offset text

%------------------------------------------------------------------------%

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
data15FTSE = xlsread('price_3year_95assets.xlsx','July14 - July15','B2:CR263');
dataFTSE15_Benchmark = xlsread('price_3year_95assets.xlsx','July14 - July15','CS2:CS263');
n15FTSE = size(data15FTSE, 2); %no. of assets
[num,assetNames15FTSE,raw] = xlsread('price_3year_95assets.xlsx','July14 - July15','B1:CR1');
   %log return
    ret15FTSE = log(data15FTSE(2:end, :)./data15FTSE(1:end-1,:));
    ret15FTSE = ret15FTSE*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu15FTSE=mean(ret15FTSE);
   sigma15FTSE=cov(ret15FTSE);
   corr15FTSE=corrcoef(ret15FTSE);
   sd15FTSE = sqrt([diag(sigma15FTSE)]');

        mu15FTSEP = min(mu15FTSE);
        i=1;
        while mu15FTSEP <= max(mu15FTSE)
            wP15FTSE=quadprog(sigma15FTSE,[],[-mu15FTSE;-eye(n15FTSE)],[-(mu15FTSEP);zeros(n15FTSE,1)],ones(1,n15FTSE),1);
            sPort15FTSE(i)=sqrt(wP15FTSE'*sigma15FTSE*wP15FTSE);
            mu15FTSEPort(i)=mu15FTSEP;
            mu15FTSEP=mu15FTSEP+0.005; %increment muP;
            i=i+1;
        end
              
        %FINDING MIN-VAR INDEX
        sPort15FTSET=sPort15FTSE';  %sPort to COLUMN vector
        sPort15FTSETMin=sPort15FTSET(1:end-1, :)./sPort15FTSET(2:end,:); %sPortT that has min sd15 repeated will all be flagged '1'
        MinVarIndexSize15FTSE=size(find(round(sPort15FTSETMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex15FTSE=MinVarIndexSize15FTSE(1)+1; %size where minimum sd15 occurs
        figure(2)
        plot(sPort15FTSE(MinVarIndex15FTSE),mu15FTSEPort(MinVarIndex15FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15FTSE(MinVarIndex15FTSE)+0.045,mu15FTSEPort(MinVarIndex15FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15FTSE(MinVarIndex15FTSE)+0.045,mu15FTSEPort(MinVarIndex15FTSE)-0.02,strcat('\sigma=', num2str(sPort15FTSE(MinVarIndex15FTSE)),'  \mu=',num2str(mu15FTSEPort(MinVarIndex15FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP15FTSEMinVar=quadprog(sigma15FTSE,[],[-mu15FTSE;-eye(n15FTSE)],[-(mu15FTSEPort(MinVarIndex15FTSE));zeros(n15FTSE,1)],ones(1,n15FTSE),1);
        wP15FTSEMinVar=wP15FTSEMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe15FTSE MaxSharpeIndex15FTSE]=max( (mu15FTSEPort-rf15) ./ sPort15FTSE );
        x=0:.01:sPort15FTSE(MaxSharpeIndex15FTSE);
        figure(2)
        plot(x, MaxSharpe15FTSE*x + rf15)
        plot(sPort15FTSE(MaxSharpeIndex15FTSE),mu15FTSEPort(MaxSharpeIndex15FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15FTSE(MaxSharpeIndex15FTSE)+0.045,mu15FTSEPort(MaxSharpeIndex15FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort15FTSE(MaxSharpeIndex15FTSE)+0.045,mu15FTSEPort(MaxSharpeIndex15FTSE)-0.02,strcat('\sigma=', num2str(sPort15FTSE(MaxSharpeIndex15FTSE)),'  \mu=',num2str(mu15FTSEPort(MaxSharpeIndex15FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP15FTSEMaxSharpe=quadprog(sigma15FTSE,[],[-mu15FTSE;-eye(n15FTSE)],[-(mu15FTSEPort(MaxSharpeIndex15FTSE));zeros(n15FTSE,1)],ones(1,n15FTSE),1);
        wP15FTSEMaxSharpe=wP15FTSEMaxSharpe.*100;
        
    figure(2)    
    %L3 = plot(sPort15FTSE(MinVarIndex15FTSE:end),mu15FTSEPort(MinVarIndex15FTSE:end),sd15FTSE,mu15FTSE,'.','MarkerSize',7);
    L3 = plot(sPort15FTSE(MinVarIndex15FTSE:end),mu15FTSEPort(MinVarIndex15FTSE:end));
    L3(1).LineWidth = 3;
    set(L3(1),'Color','b');
    
    legend([L1(1),L2(1),L3(1)],'MAC ETF 14-15','Equity ETF 14-15','FTSE100 14-15')
    %for t=1:n15FTSE
     %   text(sd15FTSE(t),mu15FTSE(t),assetNames15FTSE(t),'FontSize', 5,'Color','g');
    %end

title('FTSE 100','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');

%EQUAL WEIGHTED FTSE100 PORTFOLIO (1/N)
wEq15FTSE(1:n15FTSE,1)=1/n15FTSE;  %column vector with equal weights
muPortEq15FTSE=sum(wEq15FTSE.*mu15FTSE'); %equal weighted portfolio return (mu/n)
sPortEq15FTSE=sqrt(wEq15FTSE'*sigma15FTSE*wEq15FTSE); %SD of equal weighted portfolio
plot(sPortEq15FTSE,muPortEq15FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');
text(sPortEq15FTSE+0.05,muPortEq15FTSE,'1/N FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text


%FTSE100 Index - 2015
data15FTSEB = xlsread('price_3year_95assets.xlsx','July14 - July15','CS2:CS263');
   %log return
    ret15FTSEB = log(data15FTSEB(2:end, :)./data15FTSEB(1:end-1,:));
    ret15FTSEB = ret15FTSEB*262; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu15FTSEB=mean(ret15FTSEB);
   sigma15FTSEB=cov(ret15FTSEB);
   corr15FTSEB=corrcoef(ret15FTSEB);
   sd15FTSEB = sqrt([diag(sigma15FTSEB)]');
   
    figure(2)
    plot(sd15FTSEB,mu15FTSEB,'o','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd15FTSEB+0.05,mu15FTSEB,'FTSEB100 2015','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd15FTSEB+0.05,mu15FTSEB-0.02,strcat('\sigma=', num2str(sd15FTSEB),'  \mu=',num2str(mu15FTSEB)),'FontSize', 6,'Color','r')
    

grid on;
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
hold off;





















format long

%Risk Free rate (Long term Govt. bond)
rf16=0.3789/100;  %2014 - Annual average 3m T-Bill, BoE

%ALL 10 MAC PORTFOLIO 6 ASSETS
data16MAC = xlsread('price10MAC.xlsx','July15 - July16','B2:K261');
n16MAC = size(data16MAC, 2); %no. of assets
[num,assetNames16MAC,raw] = xlsread('price10MAC.xlsx','July15 - July16','B1:K1');
   %log return
    ret16MAC = log(data16MAC(2:end, :)./data16MAC(1:end-1,:));
    ret16MAC = ret16MAC*260; %---TO BE CORRECTED!---%
   
    hold all
   %mean & co-var
   mu16MAC=mean(ret16MAC);
   sigma16MAC=cov(ret16MAC);
   corr16MAC=corrcoef(ret16MAC);
   sd16MAC = sqrt([diag(sigma16MAC)]');

   
        muP16MAC = min(mu16MAC);
        j=1;
        while muP16MAC <= max(mu16MAC)
            wP16MAC=quadprog(sigma16MAC,[],[-mu16MAC;-eye(n16MAC)],[-(muP16MAC);zeros(n16MAC,1)],ones(1,n16MAC),1);
            sPort16MAC(j)=sqrt(wP16MAC'*sigma16MAC*wP16MAC);
            muPort16MAC(j)=muP16MAC;
            muP16MAC=muP16MAC+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort16MACT=sPort16MAC';  %sPort to COLUMN vector
        sPort16MACTMin=sPort16MACT(1:end-1, :)./sPort16MACT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar16MACIndexSize=size(find(round(sPort16MACTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar16MACIndex=MinVar16MACIndexSize(1)+1; %size where minimum SD occurs
        figure(3)
        hold all
        plot(sPort16MAC(MinVar16MACIndex),muPort16MAC(MinVar16MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16MAC(MinVar16MACIndex)+0.045,muPort16MAC(MinVar16MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP16MACMinVar=quadprog(sigma16MAC,[],[-mu16MAC;-eye(n16MAC)],[-(muPort16MAC(MinVar16MACIndex));zeros(n16MAC,1)],ones(1,n16MAC),1);
        wP16MACMinVar=wP16MACMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16MAC MaxSharpeIndex16MAC]=max( (muPort16MAC-rf16) ./ sPort16MAC );
        x=0:0.01:sPort16MAC(MaxSharpeIndex16MAC);
        figure(3)
        plot(x, MaxSharpe16MAC*x + rf16)
        plot(sPort16MAC(MaxSharpeIndex16MAC),muPort16MAC(MaxSharpeIndex16MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16MAC(MaxSharpeIndex16MAC)+0.045,muPort16MAC(MaxSharpeIndex16MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16MAC(MaxSharpeIndex16MAC)+0.045,muPort16MAC(MaxSharpeIndex16MAC)-0.02,strcat('\sigma=', num2str(sPort16MAC(MaxSharpeIndex16MAC)),'  \mu=',num2str(muPort16MAC(MaxSharpeIndex16MAC))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP16MACMaxSharpe=quadprog(sigma16MAC,[],[-mu16MAC;-eye(n16MAC)],[-(muPort16MAC(MaxSharpeIndex16MAC));zeros(n16MAC,1)],ones(1,n16MAC),1);
        wP16MACMaxSharpe=wP16MACMaxSharpe.*100;
        
        
    %L1 = plot(sPort16MAC(MinVar16MACIndex:end),muPort16MAC(MinVar16MACIndex:end),sd16MAC,mu16MAC,'.','MarkerSize',7,'Color','r');
    L1 = plot(sPort16MAC(MinVar16MACIndex:end),muPort16MAC(MinVar16MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    %for t=1:n16MAC
     %   text(sd16MAC(t),mu16MAC(t),assetNames16MAC(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 16MAC PORTFOLIO (1/N)
wEq16MAC(1:n16MAC,1)=1/n16MAC;  %column vector with equal weights
muPortEq16MAC=sum(wEq16MAC.*mu16MAC'); %equal weighted portfolio return (mu/n)
sPortEq16MAC=sqrt(wEq16MAC'*sigma16MAC*wEq16MAC); %SD of equal weighted portfolio
plot(sPortEq16MAC,muPortEq16MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
text(sPortEq16MAC+0.05,muPortEq16MAC,'1/N MAC','FontSize', 6,'Color','g')

%------------------------------------------------------------------------%

%ALL 16Equity PORTFOLIO 6 ASSETS
data16Equity = xlsread('price6AllEquity.xlsx','July15 - July16','B2:G261');
n16Equity = size(data16Equity, 2); %no. of assets
[num,assetNames16Equity,raw] = xlsread('price6AllEquity.xlsx','July15 - July16','B1:G1');
   %log return
    ret16Equity = log(data16Equity(2:end, :)./data16Equity(1:end-1,:));
    ret16Equity = ret16Equity*260; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu16Equity=mean(ret16Equity);
   sigma16Equity=cov(ret16Equity);
   corr16Equity=corrcoef(ret16Equity);
   sd16Equity = sqrt([diag(sigma16Equity)]');

   
        muP16Equity = min(mu16Equity);
        j=1;
        while muP16Equity <= max(mu16Equity)
            wP16Equity=quadprog(sigma16Equity,[],[-mu16Equity;-eye(n16Equity)],[-(muP16Equity);zeros(n16Equity,1)],ones(1,n16Equity),1);
            sPort16Equity(j)=sqrt(wP16Equity'*sigma16Equity*wP16Equity);
            muPort16Equity(j)=muP16Equity;
            muP16Equity=muP16Equity+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        sPort16EquityT=sPort16Equity';  %sPort to COLUMN vector
        sPort16EquityTMin=sPort16EquityT(1:end-1, :)./sPort16EquityT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVar16EquityIndexSize=size(find(round(sPort16EquityTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVar16EquityIndex=MinVar16EquityIndexSize(1)+1; %size where minimum SD occurs
        plot(sPort16Equity(MinVar16EquityIndex),muPort16Equity(MinVar16EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16Equity(MinVar16EquityIndex)+0.045,muPort16Equity(MinVar16EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP16EquityMinVar=quadprog(sigma16Equity,[],[-mu16Equity;-eye(n16Equity)],[-(muPort16Equity(MinVar16EquityIndex));zeros(n16Equity,1)],ones(1,n16Equity),1);
        wP16EquityMinVar=wP16EquityMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16Equity MaxSharpeIndex16Equity]=max( (muPort16Equity-rf16) ./ sPort16Equity );
        x=0:0.01:sPort16Equity(MaxSharpeIndex16Equity);
        figure(3)
        plot(x, MaxSharpe16Equity*x + rf16)
        plot(sPort16Equity(MaxSharpeIndex16Equity),muPort16Equity(MaxSharpeIndex16Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16Equity(MaxSharpeIndex16Equity)+0.045,muPort16Equity(MaxSharpeIndex16Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16Equity(MaxSharpeIndex16Equity)+0.045,muPort16Equity(MaxSharpeIndex16Equity)-0.02,strcat('\sigma=', num2str(sPort16Equity(MaxSharpeIndex16Equity)),'  \mu=',num2str(muPort16Equity(MaxSharpeIndex16Equity))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP16EquityMaxSharpe=quadprog(sigma16Equity,[],[-mu16Equity;-eye(n16Equity)],[-(muPort16Equity(MaxSharpeIndex16Equity));zeros(n16Equity,1)],ones(1,n16Equity),1);
        wP16EquityMaxSharpe=wP16EquityMaxSharpe.*100;
        
    %L2 = plot(sPort16Equity(MinVar16EquityIndex:end),muPort16Equity(MinVar16EquityIndex:end),sd16Equity,mu16Equity,'.','MarkerSize',7,'Color','r');
    L2 = plot(sPort16Equity(MinVar16EquityIndex:end),muPort16Equity(MinVar16EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    %for t=1:n16Equity
     %   text(sd16Equity(t),mu16Equity(t),assetNames16Equity(t),'FontSize', 5,'Color','r');
    %end

%EQUAL WEIGHTED 16Equity PORTFOLIO (1/N)
wEq16Equity(1:n16Equity,1)=1/n16Equity;  %column vector with equal weights
muPortEq16Equity=sum(wEq16Equity.*mu16Equity'); %equal weighted portfolio return (mu/n)
sPortEq16Equity=sqrt(wEq16Equity'*sigma16Equity*wEq16Equity); %SD of equal weighted portfolio
plot(sPortEq16Equity,muPortEq16Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');
text(sPortEq16Equity+0.05,muPortEq16Equity,'1/N Equity','FontSize', 6,'Color','r'); %+0.05 to offset text

%------------------------------------------------------------------------%

%FTSE100 PORTFOLIO FRONTIER WITH 95 ASSETS
data16FTSE = xlsread('price_3year_95assets.xlsx','July15 - July16','B2:CR261');
data16FTSEB = xlsread('price_3year_95assets.xlsx','July15 - July16','CS2:CS261');
n16FTSE = size(data16FTSE, 2); %no. of assets
[num,assetNames16FTSE,raw] = xlsread('price_3year_95assets.xlsx','July15 - July16','B1:CR1');
   %log return
    ret16FTSE = log(data16FTSE(2:end, :)./data16FTSE(1:end-1,:));
    ret16FTSE = ret16FTSE*260; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu16FTSE=mean(ret16FTSE);
   sigma16FTSE=cov(ret16FTSE);
   corr16FTSE=corrcoef(ret16FTSE);
   sd16FTSE = sqrt([diag(sigma16FTSE)]');

        mu16FTSEP = min(mu16FTSE);
        i=1;
        while mu16FTSEP <= max(mu16FTSE)
            wP16FTSE=quadprog(sigma16FTSE,[],[-mu16FTSE;-eye(n16FTSE)],[-(mu16FTSEP);zeros(n16FTSE,1)],ones(1,n16FTSE),1);
            sPort16FTSE(i)=sqrt(wP16FTSE'*sigma16FTSE*wP16FTSE);
            mu16FTSEPort(i)=mu16FTSEP;
            mu16FTSEP=mu16FTSEP+0.005; %increment muP;
            i=i+1;
        end
              
        %FINDING MIN-VAR INDEX
        sPort16FTSET=sPort16FTSE';  %sPort to COLUMN vector
        sPort16FTSETMin=sPort16FTSET(1:end-1, :)./sPort16FTSET(2:end,:); %sPortT that has min sd16 repeated will all be flagged '1'
        MinVarIndexSize16FTSE=size(find(round(sPort16FTSETMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex16FTSE=MinVarIndexSize16FTSE(1)+1; %size where minimum sd16 occurs
        figure(3)
        plot(sPort16FTSE(MinVarIndex16FTSE),mu16FTSEPort(MinVarIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MinVarIndex16FTSE)+0.045,mu16FTSEPort(MinVarIndex16FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16FTSE(MinVarIndex16FTSE)+0.045,mu16FTSEPort(MinVarIndex16FTSE)-0.02,strcat('\sigma=', num2str(sPort16FTSE(MinVarIndex16FTSE)),'  \mu=',num2str(mu16FTSEPort(MinVarIndex16FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP16FTSEMinVar=quadprog(sigma16FTSE,[],[-mu16FTSE;-eye(n16FTSE)],[-(mu16FTSEPort(MinVarIndex16FTSE));zeros(n16FTSE,1)],ones(1,n16FTSE),1);
        wP16FTSEMinVar=wP16FTSEMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16FTSE MaxSharpeIndex16FTSE]=max( (mu16FTSEPort-rf16) ./ sPort16FTSE );
        x=0:0.01:sPort16FTSE(MaxSharpeIndex16FTSE);
        figure(3)
        plot(x, MaxSharpe16FTSE*x + rf16)
        plot(sPort16FTSE(MaxSharpeIndex16FTSE),mu16FTSEPort(MaxSharpeIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MaxSharpeIndex16FTSE)+0.045,mu16FTSEPort(MaxSharpeIndex16FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16FTSE(MaxSharpeIndex16FTSE)+0.045,mu16FTSEPort(MaxSharpeIndex16FTSE)-0.02,strcat('\sigma=', num2str(sPort16FTSE(MaxSharpeIndex16FTSE)),'  \mu=',num2str(mu16FTSEPort(MaxSharpeIndex16FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP16FTSEMaxSharpe=quadprog(sigma16FTSE,[],[-mu16FTSE;-eye(n16FTSE)],[-(mu16FTSEPort(MaxSharpeIndex16FTSE));zeros(n16FTSE,1)],ones(1,n16FTSE),1);
        wP16FTSEMaxSharpe=wP16FTSEMaxSharpe.*100;
        
    figure(3)    
    %L3 = plot(sPort16FTSE(MinVarIndex16FTSE:end),mu16FTSEPort(MinVarIndex16FTSE:end),sd16FTSE,mu16FTSE,'.','MarkerSize',7);
    L3 = plot(sPort16FTSE(MinVarIndex16FTSE:end),mu16FTSEPort(MinVarIndex16FTSE:end));
    L3(1).LineWidth = 3;
    set(L3(1),'Color','b');
    
    legend([L1(1),L2(1),L3(1)],'MAC ETF 15-16','Equity ETF 15-16','FTSE100')
    %for t=1:n16FTSE
     %   text(sd16FTSE(t),mu16FTSE(t),assetNames16FTSE(t),'FontSize', 5,'Color','g');
    %end

title('FTSE 100','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');

%EQUAL WEIGHTED FTSE100 PORTFOLIO (1/N)
wEq16FTSE(1:n16FTSE,1)=1/n16FTSE;  %column vector with equal weights
muPortEq16FTSE=sum(wEq16FTSE.*mu16FTSE'); %equal weighted portfolio return (mu/n)
sPortEq16FTSE=sqrt(wEq16FTSE'*sigma16FTSE*wEq16FTSE); %SD of equal weighted portfolio
plot(sPortEq16FTSE,muPortEq16FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');
text(sPortEq16FTSE+0.05,muPortEq16FTSE,'1/N FTSE','FontSize', 6,'Color','b'); %+0.05 to offset text

%FTSE100 Index  - 2016
data16FTSEB = xlsread('price_3year_95assets.xlsx','July15 - July16','CS2:CS261');
   %log return
    ret16FTSEB = log(data16FTSEB(2:end, :)./data16FTSEB(1:end-1,:));
    ret16FTSEB = ret16FTSEB*260; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu16FTSEB=mean(ret16FTSEB);
   sigma16FTSEB=cov(ret16FTSEB);
   corr16FTSEB=corrcoef(ret16FTSEB);
   sd16FTSEB = sqrt([diag(sigma16FTSEB)]');
   
    figure(3)
    plot(sd16FTSEB,mu16FTSEB,'o','MarkerSize',10,'MarkerFaceColor','r','Color','b');
    text(sd16FTSEB+0.05,mu16FTSEB,'FTSEB100 2016','FontSize', 7,'FontWeight', 'bold','Color','r'); %+0.05 to offset text
    text(sd16FTSEB+0.05,mu16FTSEB-0.02,strcat('\sigma=', num2str(sd16FTSEB),'  \mu=',num2str(mu16FTSEB)),'FontSize', 6,'Color','r')
    
grid on;
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
hold off;
grid off;



%--------------- ASSET WEIGHTS BAR PLOT ----------------------------------%


 %MAC WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(4)
    subplot(3,1,1)
    h = bar([wP14MACMinVar wP14MACMaxSharpe]);
    title('MAC 2014 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames14MAC,'XTick',1:numel(assetNames14MAC))
    %ax.XTickLabelRotation = 45;
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(4)
    subplot(3,1,2)
    h = bar([wP15MACMinVar wP15MACMaxSharpe]);
    title('MAC 2015 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames15MAC,'XTick',1:numel(assetNames15MAC))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(4)
    subplot(3,1,3)
    h = bar([wP16MACMinVar wP16MACMaxSharpe]);
    title('MAC 2016 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames16MAC,'XTick',1:numel(assetNames16MAC))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);
    
     %Equity WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(5)
    subplot(3,1,1)
    h = bar([wP14EquityMinVar wP14EquityMaxSharpe]);
    title('All Equity 2014 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames14Equity,'XTick',1:numel(assetNames14Equity))
    %ax.XTickLabelRotation = 45;
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(5)
    subplot(3,1,2)
    h = bar([wP15EquityMinVar wP15EquityMaxSharpe]);
    title('All Equity 2015 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames15Equity,'XTick',1:numel(assetNames15Equity))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(5)
    subplot(3,1,3)
    h = bar([wP16EquityMinVar wP16EquityMaxSharpe]);
    title('All Equity 2016 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames16Equity,'XTick',1:numel(assetNames16Equity))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);
    
    
     %FTSE WEIGHTS BAR PLOT
    %Format from Axes Properties for visual presentation
    figure(6)
    subplot(3,1,1)
    h = bar([wP14FTSEMinVar wP14FTSEMaxSharpe]);
    title('FTSE100 2014 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames14FTSE,'XTick',1:numel(assetNames14FTSE))
    %ax.XTickLabelRotation = 45;
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(6)
    subplot(3,1,2)
    h = bar([wP15FTSEMinVar wP15FTSEMaxSharpe]);
    title('FTSE100 2015 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames15FTSE,'XTick',1:numel(assetNames15FTSE))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    figure(6)
    subplot(3,1,3)
    h = bar([wP16FTSEMinVar wP16FTSEMaxSharpe]);
    title('FTSE100 2016 Weights','FontSize',12,'FontWeight','bold','Color','r');
    ax=gca;
    set(ax,'XTickLabel', assetNames16FTSE,'XTick',1:numel(assetNames16FTSE))
    ax.XTickLabelRotation = 90;
    l={'Min-Var' 'Max-Sharpe'};
    legend(h,l);

    
    hold off;
    
    
    
    
    
    
%----------------------------- PORTFOLIO PERFORMANCE ----------------------%  
    
    
  hold on  
%Import FTSE benchmark for 2 years    
data14to16FTSE = xlsread('price_3year_95assets','July14 - July16','CS2:CS522');
retcumFTSE=log(data14to16FTSE(2:end)/data14to16FTSE(1));
% Import the data, extracting spreadsheet dates in Excel serial date format
[~, ~, raw, dates] = xlsread('C:\Users\Muneer\Documents\MATLAB\price_3year_95assets.xlsx','July14 - July16','A3:A522','',@convertSpreadsheetExcelDates);
dates = dates(:,1);
Date = datetime([dates{:,1}].', 'ConvertFrom', 'Excel', 'Format', 'dd/MM/yyyy');
clearvars raw dates;

    %-------MAC PORTFOLIO RETURN WITH REFERENCE TO BEGINING OF PORTFOLIO-------------------%
%Actual Rate of return of the following year 2014-2016
%Weights from 2014-2015 & 2015-2016 estimates - wP15,wP16

data14to16MAC = xlsread('price10MAC.xlsx','July14 - July16','B2:K522');
%ChangeInReturn of ex-Post
for i=1:n16MAC
retMACcum(:,i)=log(data14to16MAC(2:end,i)/data14to16MAC(1,i));
end
%Weights of ex-Ante
wP14MACMinVar; wP14MACMaxSharpe;
wP15MACMinVar; wP15MACMaxSharpe;
%Actual %ChangeInReturn Return of Individual Stock in Portfolio
for i=1:n16MAC
ActualCumMinVarMAC(1:261,i)=wP14MACMinVar(i)*retMACcum(1:261,i);
ActualCumMinVarMAC(262:size(retMACcum),i)=wP15MACMinVar(i)*retMACcum(262:size(retMACcum),i);
ActualCumMaxSharpeMAC(1:261,i)=wP14MACMaxSharpe(i)*retMACcum(1:261,i);
ActualCumMaxSharpeMAC(262:size(retMACcum),i)=wP15MACMaxSharpe(i)*retMACcum(262:size(retMACcum),i);
ActualCumEqWeightMAC(1:261,i)=wEq14MAC(i)*retMACcum(1:261,i);
ActualCumEqWeightMAC(262:size(retMACcum),i)=wEq15MAC(i)*retMACcum(262:size(retMACcum),i);
end

%Portfolio Cumulative Return over 2 years
ActualPortCumMinVarMAC=sum(ActualCumMinVarMAC,2);
ActualPortCumMaxSharpeMAC=sum(ActualCumMaxSharpeMAC,2);
ActualCumEqWeightMAC=sum(ActualCumEqWeightMAC,2);

figure(7)
PPMinVarMAC = plot(Date, ActualPortCumMinVarMAC);
hold all
PPMaxSharpeMAC = plot(Date, ActualPortCumMaxSharpeMAC);
PPEqWeightMAC = plot(Date, ActualCumEqWeightMAC);


    %-------Equity PORTFOLIO RETURN WITH REFERENCE TO BEGINING OF PORTFOLIO-------------------%
%Actual Rate of return of the following year 2014-2016
%Weights from 2014-2015 & 2015-2016 estimates - wP15,wP16

data14to16Equity = xlsread('price6AllEquity.xlsx','July14 - July16','B2:G522');
%ChangeInReturn of ex-Post
for i=1:n16Equity
retEquitycum(:,i)=log(data14to16Equity(2:end,i)/data14to16Equity(1,i));
end

%Weights of ex-Ante
wP14EquityMinVar; wP14EquityMaxSharpe;
wP15EquityMinVar; wP15EquityMaxSharpe;

%Actual %ChangeInReturn Return of Individual Stock in Portfolio
for i=1:n16Equity
ActualCumMinVarEquity(1:261,i)=wP14EquityMinVar(i)*retEquitycum(1:261,i);
ActualCumMinVarEquity(262:size(retEquitycum),i)=wP15EquityMinVar(i)*retEquitycum(262:size(retEquitycum),i);
ActualCumMaxSharpeEquity(1:261,i)=wP14EquityMaxSharpe(i)*retEquitycum(1:261,i);
ActualCumMaxSharpeEquity(262:size(retEquitycum),i)=wP15EquityMaxSharpe(i)*retEquitycum(262:size(retEquitycum),i);
ActualCumEqWeightEquity(1:261,i)=wEq14Equity(i)*retEquitycum(1:261,i);
ActualCumEqWeightEquity(262:size(retEquitycum),i)=wEq15Equity(i)*retEquitycum(262:size(retEquitycum),i);
end

%Portfolio Cumulative Return over 2 years
ActualPortCumMinVarEquity=sum(ActualCumMinVarEquity,2);
ActualPortCumMaxSharpeEquity=sum(ActualCumMaxSharpeEquity,2);
ActualCumEqWeightEquity=sum(ActualCumEqWeightEquity,2);

figure(7)
PPMinVarEquity = plot(Date, ActualPortCumMinVarEquity);
hold all
PPMaxSharpeEquity = plot(Date, ActualPortCumMaxSharpeEquity);
PPEqWeightEquity = plot(Date, ActualCumEqWeightEquity);


    %-------FTSE PORTFOLIO RETURN WITH REFERENCE TO BEGINING OF PORTFOLIO-------------------%
%Actual Rate of return of the following year 2014-2016
%Weights from 2014-2015 & 2015-2016 estimates - wP15,wP16

data14to16FTSE = xlsread('price_3year_95assets.xlsx','July14 - July16','B2:CR522');
%ChangeInReturn of ex-Post
for i=1:n16FTSE
retFTSEcum(:,i)=log(data14to16FTSE(2:end,i)/data14to16FTSE(1,i));
end

%Weights of ex-Ante
wP14FTSEMinVar; wP14FTSEMaxSharpe;
wP15FTSEMinVar; wP15FTSEMaxSharpe;

%Actual %ChangeInReturn Return of Individual Stock in Portfolio
for i=1:n16FTSE
ActualCumMinVarFTSE(1:261,i)=wP14FTSEMinVar(i)*retFTSEcum(1:261,i);
ActualCumMinVarFTSE(262:size(retFTSEcum),i)=wP15FTSEMinVar(i)*retFTSEcum(262:size(retFTSEcum),i);
ActualCumMaxSharpeFTSE(1:261,i)=wP14FTSEMaxSharpe(i)*retFTSEcum(1:261,i);
ActualCumMaxSharpeFTSE(262:size(retFTSEcum),i)=wP15FTSEMaxSharpe(i)*retFTSEcum(262:size(retFTSEcum),i);
ActualCumEqWeightFTSE(1:261,i)=wEq14FTSE(i)*retFTSEcum(1:261,i);
ActualCumEqWeightFTSE(262:size(retFTSEcum),i)=wEq15FTSE(i)*retFTSEcum(262:size(retFTSEcum),i);
end

%Portfolio Cumulative Return over 2 years
ActualPortCumMinVarFTSE=sum(ActualCumMinVarFTSE,2);
ActualPortCumMaxSharpeFTSE=sum(ActualCumMaxSharpeFTSE,2);
ActualCumEqWeightFTSE=sum(ActualCumEqWeightFTSE,2);

figure(7)
PPMinVarFTSE = plot(Date, ActualPortCumMinVarFTSE);
hold all
PPMaxSharpeFTSE = plot(Date, ActualPortCumMaxSharpeFTSE);
PPEqWeightFTSE = plot(Date, ActualCumEqWeightFTSE);






PPBenchmark = plot(Date, retcumFTSE);
legend([PPMinVarMAC,PPMaxSharpeMAC,PPEqWeightMAC,PPMinVarEquity,PPMaxSharpeEquity,PPEqWeightEquity,PPMinVarFTSE,PPMaxSharpeFTSE,PPEqWeightFTSE,PPBenchmark],'MAC Min-Var','MAC MaxSharpe','MAC (I/N)','Equity Min-Var','Equity MaxSharpe','Equity (I/N)','FTSE100 Min-Var','FTSE100 MaxSharpe','FTSE100 (I/N)','FTSE 100 Benchmark')
y1=get(gca,'ylim');
hold on
BL = plot([Date(261) Date(261)],y1);
BL.LineWidth = 2;
title('Portfolio Performance','FontSize',15,'FontWeight','bold','Color','r');
ylabel('% Change in Return','FontSize',12,'FontWeight','bold','Color','b');


