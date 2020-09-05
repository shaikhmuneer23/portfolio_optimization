format long

%Risk Free rate (Long term Govt. bond)
rf=0.08;

%ALL 10 MAC PORTFOLIO 6 ASSETS
data16MAC = xlsread('price10MAC.xlsx','July15 - July16','B2:K261');
n16MAC = size(data16MAC, 2); %no. of assets
[num,assetNames16MAC,raw] = xlsread('price6AllEquity.xlsx','B1:K1');
   %log return
    ret16MAC = log(data16MAC(2:end, :)./data16MAC(1:end-1,:));
    ret16MAC = ret16MAC*261; %---TO BE CORRECTED!---%
   
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
        plot(sPort16MAC(MinVar16MACIndex),muPort16MAC(MinVar16MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16MAC(MinVar16MACIndex)+0.045,muPort16MAC(MinVar16MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wPMinVar=quadprog(sigma16MAC,[],[-mu16MAC;-eye(n16MAC)],[-(muPort16MAC(MinVar16MACIndex));zeros(n16MAC,1)],ones(1,n16MAC),1);
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16MAC MaxSharpeIndex16MAC]=max( (muPort16MAC-rf) ./ sPort16MAC );
        x=0:3;
        figure(1)
        plot(x, MaxSharpe16MAC*x + rf)
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
text(sPortEq16MAC+0.05,muPortEq16MAC,'1/N MAC','FontSize', 6,'Color','g'); %+0.05 to offset text






%------------------------------------------------------------------------%









%ALL 16Equity PORTFOLIO 6 ASSETS
data16Equity = xlsread('price6AllEquity.xlsx','July15 - July16','B2:G261');
n16Equity = size(data16Equity, 2); %no. of assets
[num,assetNames16Equity,raw] = xlsread('price6AllEquity.xlsx','B1:G1');
   %log return
    ret16Equity = log(data16Equity(2:end, :)./data16Equity(1:end-1,:));
    ret16Equity = ret16Equity*261; %---TO BE CORRECTED!---%
   
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
        wPMinVar=quadprog(sigma16Equity,[],[-mu16Equity;-eye(n16Equity)],[-(muPort16Equity(MinVar16EquityIndex));zeros(n16Equity,1)],ones(1,n16Equity),1);
        
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
dataFTSE16_Benchmark = xlsread('price_3year_95assets.xlsx','July15 - July16','CS2:CS261');
n16FTSE = size(data16FTSE, 2); %no. of assets
[num,assetNames16FTSE,raw] = xlsread('price_3year_95assets.xlsx','July15 - July16','B1:CR1');
   %log return
    ret16FTSE = log(data16FTSE(2:end, :)./data16FTSE(1:end-1,:));
    ret16FTSE = ret16FTSE*261; %---TO BE CORRECTED!---%
   
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
        figure(1)
        plot(sPort16FTSE(MinVarIndex16FTSE),mu16FTSEPort(MinVarIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MinVarIndex16FTSE)+0.045,mu16FTSEPort(MinVarIndex16FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16FTSE(MinVarIndex16FTSE)+0.045,mu16FTSEPort(MinVarIndex16FTSE)-0.02,strcat('\sigma=', num2str(sPort16FTSE(MinVarIndex16FTSE)),'  \mu=',num2str(mu16FTSEPort(MinVarIndex16FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wP16FTSEMinVar=quadprog(sigma16FTSE,[],[-mu16FTSE;-eye(n16FTSE)],[-(mu16FTSEPort(MinVarIndex16FTSE));zeros(n16FTSE,1)],ones(1,n16FTSE),1);
        wP16FTSEMinVar=wP16FTSEMinVar.*100;
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe16FTSE MaxSharpeIndex16FTSE]=max( (mu16FTSEPort-rf) ./ sPort16FTSE );
        x=0:3;
        figure(1)
        plot(x, MaxSharpe16FTSE*x + rf)
        plot(sPort16FTSE(MaxSharpeIndex16FTSE),mu16FTSEPort(MaxSharpeIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MaxSharpeIndex16FTSE)+0.045,mu16FTSEPort(MaxSharpeIndex16FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        text(sPort16FTSE(MaxSharpeIndex16FTSE)+0.045,mu16FTSEPort(MaxSharpeIndex16FTSE)-0.02,strcat('\sigma=', num2str(sPort16FTSE(MaxSharpeIndex16FTSE)),'  \mu=',num2str(mu16FTSEPort(MaxSharpeIndex16FTSE))),'FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wP16FTSEMaxSharpe=quadprog(sigma16FTSE,[],[-mu16FTSE;-eye(n16FTSE)],[-(mu16FTSEPort(MaxSharpeIndex16FTSE));zeros(n16FTSE,1)],ones(1,n16FTSE),1);
        wP16FTSEMaxSharpe=wP16FTSEMaxSharpe.*100;
        
    figure(1)    
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


grid on;
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
hold off;

