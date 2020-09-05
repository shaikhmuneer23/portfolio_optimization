format long

%Import price data from Excel
history = xlsread('price10MAC.xlsx','A2:K249');
data = xlsread('price10MAC.xlsx','B2:K249');
n = size(data, 2); %no. of assets
[num,assetNames,raw] = xlsread('price10MAC.xlsx','B1:K1');
colorVec=hsv(n);

%Import price data from Excel
dataEquity = xlsread('price6AllEquity.xlsx','B2:G249');
nEquity = size(dataEquity, 2); %no. of assets
[num,assetNamesEquity,raw] = xlsread('price6AllEquity.xlsx','B1:G1');

%Risk Free rate (Long term Govt. bond)
rf=0.08;


%MULTI CLASS ASSET PORTFOLIO FRONTIER WITH 10 ASSETS
   %log return
    ret = log(data(2:end, :)./data(1:end-1,:));
    ret = ret*250; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu=mean(ret);
   sigma=cov(ret);
   corr=corrcoef(ret);
   sd = sqrt([diag(sigma)]');

   
        muP = min(mu);
        i=1;
        while muP <= max(mu)
            wP=quadprog(sigma,[],[-mu;-eye(n)],[-(muP);zeros(n,1)],ones(1,n),1);
            sPort(i)=sqrt(wP'*sigma*wP);
            muPort(i)=muP;
            muP=muP+0.001; %increment muP;
            i=i+1;
        end
      
        hold on;
        
        %FINDING MIN-VAR INDEX
        sPortT=sPort';  %sPort to COLUMN vector
        sPortTMin=sPortT(1:end-1, :)./sPortT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVarIndexSize=size(find(round(sPortTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarIndex=MinVarIndexSize(1)+1; %size where minimum SD occurs
        plot(sPort(MinVarIndex),muPort(MinVarIndex),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort(MinVarIndex)+0.045,muPort(MinVarIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wPMinVar=quadprog(sigma,[],[-mu;-eye(n)],[-(muPort(MinVarIndex));zeros(n,1)],ones(1,n),1);
        
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        [MaxSharpe MaxSharpeIndex]=max( (muPort-rf) ./ sPort );
        x=0:0.001:5;
        plot(x, MaxSharpe*x + rf)
        plot(sPort(MaxSharpeIndex),muPort(MaxSharpeIndex),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPort(MaxSharpeIndex)+0.045,muPort(MaxSharpeIndex),'Tangency Portfolio','FontSize', 6,'Color','r')
        %COMPUTING MAX-SHARPE OPTIMUM WEIGHTS
        wPMaxSharpe=quadprog(sigma,[],[-mu;-eye(n)],[-(muPort(MaxSharpeIndex));zeros(n,1)],ones(1,n),1);
        
        
    L1 = plot(sPort(MinVarIndex:end),muPort(MinVarIndex:end),sd,mu,'.','MarkerSize',10);
    set(L1(1),'linewidth',2);
    
    for t=1:n
        text(sd(t),mu(t),assetNames(t),'FontSize', 5,'Color','g');
    end

    
%{
  p(i) = Portfolio;
  p(i) = Portfolio(p(i), 'LowerBound', zeros(size(mu)), 'LowerBudget', 1, 'UpperBudget', 1, 'AssetMean', mu, 'AssetCovar', sigma);
  
  hold on;
  plotFrontier(p(i));
  legendInfo{i}=([num2str(noAssets), ' assets']);
  i=i+1;
%}

   

title('DIVERSIFIED vs. RISKY PORTFOLIO','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');




%EQUAL WEIGHTED MULTI ASSET PORTFOLIO (1/N)
wEq(1:n,1)=1/n;  %column vector with equal weights
muPortEq=sum(wEq.*mu'); %equal weighted portfolio return (mu/n)
sPortEq=sqrt(wEq'*sigma*wEq); %SD of equal weighted portfolio
plot(sPortEq,muPortEq,'p','MarkerSize',10,'MarkerFaceColor','b','Color','b');
text(sPortEq+0.045,muPortEq,'Equal Weighted Multi-Class','FontSize', 6,'Color','b'); %+0.05 to offset text


%ALL EQUITY PORTFOLIO 6 ASSETS
   %log return
    retEquity = log(dataEquity(2:end, :)./dataEquity(1:end-1,:));
    retEquity = retEquity*250; %---TO BE CORRECTED!---%
   
   %mean & co-var
   muEquity=mean(retEquity);
   sigmaEquity=cov(retEquity);
   corrEquity=corrcoef(retEquity);
   sdEquity = sqrt([diag(sigmaEquity)]');

   
        muPEquity = min(muEquity);
        j=1;
        while muPEquity <= max(muEquity)
            wPEquity=quadprog(sigmaEquity,[],[-muEquity;-eye(nEquity)],[-(muPEquity);zeros(nEquity,1)],ones(1,nEquity),1);
            sPortEquity(j)=sqrt(wPEquity'*sigmaEquity*wPEquity);
            muPortEquity(j)=muPEquity;
            muPEquity=muPEquity+0.005; %increment muP;
            j=j+1;
        end
        
        
        %FINDING MIN-VAR INDEX
        
        sPortEquityT=sPortEquity';  %sPort to COLUMN vector
        sPortEquityTMin=sPortEquityT(1:end-1, :)./sPortEquityT(2:end,:); %sPortT that has min SD repeated will all be flagged '1'
        MinVarEquityIndexSize=size(find(round(sPortEquityTMin*10^4)/(10^4)==1)); %counting the number of 1
        MinVarEquityIndex=MinVarEquityIndexSize(1)+1; %size where minimum SD occurs
        plot(sPortEquity(MinVarEquityIndex),muPortEquity(MinVarEquityIndex),'d','MarkerSize',10,'MarkerFaceColor','c','Color','r')
        text(sPortEquity(MinVarEquityIndex)+0.045,muPortEquity(MinVarEquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %COMPUTING MIN-VAR OPTIMUM WEIGHTS
        wPMinVar=quadprog(sigmaEquity,[],[-muEquity;-eye(nEquity)],[-(muPortEquity(MinVarEquityIndex));zeros(nEquity,1)],ones(1,nEquity),1);
        
        
    L2 = plot(sPortEquity(MinVarEquityIndex:end),muPortEquity(MinVarEquityIndex:end),sdEquity,muEquity,'.','MarkerSize',10,'Color','r');
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    for t=1:nEquity
        text(sdEquity(t),muEquity(t),assetNamesEquity(t),'FontSize', 5,'Color','r');
    end

%EQUAL WEIGHTED EQUITY PORTFOLIO (1/N)
wEqEquity(1:nEquity,1)=1/nEquity;  %column vector with equal weights
muPortEqEquity=sum(wEqEquity.*muEquity'); %equal weighted portfolio return (mu/n)
sPortEqEquity=sqrt(wEqEquity'*sigmaEquity*wEqEquity); %SD of equal weighted portfolio
plot(sPortEqEquity,muPortEqEquity,'p','MarkerSize',10,'MarkerFaceColor','r','Color','r');
text(sPortEqEquity+0.045,muPortEqEquity,'Equal Weighted Equity','FontSize', 6,'Color','r'); %+0.05 to offset text

grid on;
set(gca,'Xcolor',[0.5 0.5 0.5]);
set(gca,'Ycolor',[0.5 0.5 0.5]);
hold off;