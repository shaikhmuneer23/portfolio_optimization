format long
%Import price data from Excel
data = xlsread('price10MAC.xlsx','B2:K249');
n = size(data, 2); %no. of assets
[num,txt,raw] = xlsread('price10MAC.xlsx','B1:K1');
assetNames = txt;
colorVec=hsv(n);

l=1; %index for noAssets legend 
for noAssets=2:10 %PLOTTING EFFICIENT FRONTIER : start with 2 assets in portfolio
   prices=data(:,1:noAssets); %first n columns from data i.e. n assets
   size(prices)
   
   %log return
    ret = log(prices(2:end, :)./prices(1:end-1,:));
    ret = ret*250; %---TO BE CORRECTED!---%
   
   %mean & co-var
   mu=mean(ret);
   sigma=cov(ret);
   corr=corrcoef(ret);
   sd = sqrt([diag(sigma)]');
   
        muP = min(mu);
        i=1;
        while muP <= max(mu)
            wP=quadprog(sigma,[],[-mu;-eye(noAssets)],[-(muP);zeros(noAssets,1)],ones(1,noAssets),1);
            sPort(i)=sqrt(wP'*sigma*wP);
            muPort(i)=muP;
            muP=muP+0.001; %increment muP;
            i=i+1;
        end
        
    hold on;
    plot(sPort,muPort,'Color',colorVec(l,:))
    legendInfo{l}=([num2str(noAssets), ' assets']);
    l=l+1;
    
%{
  p(i) = Portfolio;
  p(i) = Portfolio(p(i), 'LowerBound', zeros(size(mu)), 'LowerBudget', 1, 'UpperBudget', 1, 'AssetMean', mu, 'AssetCovar', sigma);
  
  hold on;
  plotFrontier(p(i));
  legendInfo{i}=([num2str(noAssets), ' assets']);
  i=i+1;
%}
end
plot(sd,mu,'x') %individual assets position
for t=1:n
    text(sd(t),mu(t),assetNames(t));
end
title('ETF ASSET DIVERSIFICATION','FontSize',15,'FontWeight','bold','Color','r');
xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
legend(legendInfo);


%EQUAL WEIGHTED PORTFOLIO (1/N)
wEq(1:n,1)=1/n;  %column vector with equal weights
muPortEq=sum(wEq.*mu'); %equal weighted portfolio return (mu/n)
sPortEq=sqrt(wEq'*sigma*wEq); %SD of equal weighted portfolio
plot(sPortEq,muPortEq,'p','MarkerSize',10,'MarkerFaceColor','r','Color','r');
text(sPortEq+0.05,muPortEq,'Equal weighted','Color','r'); %+0.05 to offset text


hold off;