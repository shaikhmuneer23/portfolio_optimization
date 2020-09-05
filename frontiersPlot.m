%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% replace 14,15 and 16 to obtain graphs
% Initial Portfolio 2013 - 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%MAC 2013-2014
        hold all
        format long
        
        %min-var
        figure(1)
        plot(sPort14MAC(MinVar14MACIndex),muPort14MAC(MinVar14MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14MAC(MinVar14MACIndex)+0.0020,muPort14MAC(MinVar14MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %tangency
        x=0:.01:sPort14MAC(MaxSharpeIndex14MAC);
        figure(1)
        plot(x, MaxSharpe14MAC*x + rf14)
        plot(sPort14MAC(MaxSharpeIndex14MAC),muPort14MAC(MaxSharpeIndex14MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14MAC(MaxSharpeIndex14MAC)+0.0020,muPort14MAC(MaxSharpeIndex14MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %PLOTTING EFFICIENT FRONTIER ONLY    
    L1 = plot(sPort14MAC(MinVar14MACIndex:end),muPort14MAC(MinVar14MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    for t=1:n14MAC
        text(sd14MAC(t),mu14MAC(t),assetNames14MAC(t),'FontSize', 5,'Color','r');
    end
    %EQUAL WEIGHTED 14MAC PORTFOLIO (1/N)
        LEqMAC14 = plot(sPortEq14MAC,muPortEq14MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
    %FTSE100 Benchmark    
        figure(1)
        LBench14 = plot(sd14FTSEB,mu14FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
 
   
         title('Efficient Frontier (MAC 2014)','FontSize',14,'FontWeight','bold','Color','r');
         xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
         ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
         figure(1)
         legend([L1(1),LEqMAC14,LBench14],'MAC ETF 13-14','1/N MAC','FTSE Bench','Location','northwest')
         hold off;

    
    hold all
    %All-Equity 2013-2014   
    %min-var
        figure(2)
        plot(sPort14Equity(MinVar14EquityIndex),muPort14Equity(MinVar14EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14Equity(MinVar14EquityIndex)+0.0020,muPort14Equity(MinVar14EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort14Equity(MaxSharpeIndex14Equity);
        figure(2);hold all;
        plot(x, MaxSharpe14Equity*x + rf14)
        figure(2);hold all;
        plot(sPort14Equity(MaxSharpeIndex14Equity),muPort14Equity(MaxSharpeIndex14Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14Equity(MaxSharpeIndex14Equity)+0.0020,muPort14Equity(MaxSharpeIndex14Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(2);hold all;
        L2 = plot(sPort14Equity(MinVar14EquityIndex:end),muPort14Equity(MinVar14EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    for t=1:n14Equity
        text(sd14Equity(t),mu14Equity(t),assetNames14Equity(t),'FontSize', 5,'Color','r');
    end
        %1/N
        figure(2);hold all;
        LEqEquity14 = plot(sPortEq14Equity,muPortEq14Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');

%FTSE100 Benchmark    
        figure(2);hold all;
        LBench14 = plot(sd14FTSEB,mu14FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
        figure(2);hold all;

     title('Efficient Frontier (All-Equity 2014)','FontSize',14,'FontWeight','bold','Color','r');
    xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
    ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    legend([L2(1),LEqEquity14,LBench14],'Equity ETF 13-14','1/N Equity','FTSE Bench','Location','northwest')

    hold off
    
    
    hold all
    %FTSE95 2013-2014
       
    %min-var
        figure(3);hold all;
        plot(sPort14FTSE(MinVarIndex14FTSE),mu14FTSEPort(MinVarIndex14FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14FTSE(MinVarIndex14FTSE)+0.0020,mu14FTSEPort(MinVarIndex14FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort14FTSE(MaxSharpeIndex14FTSE);
        figure(3);hold all;
        plot(x, MaxSharpe14FTSE*x + rf14)
        figure(3);hold all;
        plot(sPort14FTSE(MaxSharpeIndex14FTSE),mu14FTSEPort(MaxSharpeIndex14FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort14FTSE(MaxSharpeIndex14FTSE)+0.0020,mu14FTSEPort(MaxSharpeIndex14FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(3);hold all;
        L3 = plot(sPort14FTSE(MinVarIndex14FTSE:end),mu14FTSEPort(MinVarIndex14FTSE:end));
        L3(1).LineWidth = 3;
        set(L3(1),'Color','b');
         for t=1:n14FTSE
                text(sd14FTSE(t),mu14FTSE(t),assetNames14FTSE(t),'FontSize', 5,'Color','g');
         end
         %1/N
         figure(3);hold all;
         LEqFTSE14 = plot(sPortEq14FTSE,muPortEq14FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');

%FTSE100 Benchmark    
        figure(3);hold all;
        LBench14 = plot(sd14FTSEB,mu14FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
       
        legend([L3(1),LEqFTSE14,LBench14],'FTSE100 13-14','1/N FTSE','FTSE Bench','Location','northwest')
    
        title('Efficient Frontier (FTSE100 2014)','FontSize',14,'FontWeight','bold','Color','r');
        xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
        ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    

        
        
hold off        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rebalanced Portfolio 2015 - 2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%MAC 2014-2015
        hold all
        format long
        
        %min-var
        figure(4);hold all;
        plot(sPort15MAC(MinVar15MACIndex),muPort15MAC(MinVar15MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15MAC(MinVar15MACIndex)+0.0020,muPort15MAC(MinVar15MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %tangency
        x=0:.01:sPort15MAC(MaxSharpeIndex15MAC);
        figure(4);hold all;
        plot(x, MaxSharpe15MAC*x + rf15)
        figure(4);hold all;
        plot(sPort15MAC(MaxSharpeIndex15MAC),muPort15MAC(MaxSharpeIndex15MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15MAC(MaxSharpeIndex15MAC)+0.0020,muPort15MAC(MaxSharpeIndex15MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %PLOTTING EFFICIENT FRONTIER ONLY
        figure(4);hold all;
    L1 = plot(sPort15MAC(MinVar15MACIndex:end),muPort15MAC(MinVar15MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    for t=1:n15MAC
        text(sd15MAC(t),mu15MAC(t),assetNames15MAC(t),'FontSize', 5,'Color','r');
    end
    %EQUAL WEIGHTED 15MAC PORTFOLIO (1/N)
    figure(4);hold all;    
    LEqMAC15 = plot(sPortEq15MAC,muPortEq15MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
    %FTSE100 Benchmark    
        figure(4);hold all;
        LBench15 = plot(sd15FTSEB,mu15FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
 
   
         title('Efficient Frontier (MAC 2015)','FontSize',15,'FontWeight','bold','Color','r');
         xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
         ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
         figure(4);hold all;
         legend([L1(1),LEqMAC15,LBench15],'MAC ETF 13-15','1/N MAC','FTSE Bench','Location','northwest')
         hold off;

    
    hold all
    %All-Equity 2014-2015   
    %min-var
        figure(5);hold all
        plot(sPort15Equity(MinVar15EquityIndex),muPort15Equity(MinVar15EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15Equity(MinVar15EquityIndex)+0.0020,muPort15Equity(MinVar15EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort15Equity(MaxSharpeIndex15Equity);
        figure(5);hold all;
        plot(x, MaxSharpe15Equity*x + rf15)
        figure(5);hold all;
        plot(sPort15Equity(MaxSharpeIndex15Equity),muPort15Equity(MaxSharpeIndex15Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15Equity(MaxSharpeIndex15Equity)+0.0020,muPort15Equity(MaxSharpeIndex15Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(5);hold all;
        L2 = plot(sPort15Equity(MinVar15EquityIndex:end),muPort15Equity(MinVar15EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    for t=1:n15Equity
        text(sd15Equity(t),mu15Equity(t),assetNames15Equity(t),'FontSize', 5,'Color','r');
    end
        %1/N
        figure(5);hold all;
        LEqEquity15 = plot(sPortEq15Equity,muPortEq15Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');

%FTSE100 Benchmark    
        figure(5);hold all;
        LBench15 = plot(sd15FTSEB,mu15FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
        figure(5);hold all;

     title('Efficient Frontier (All-Equity 2015)','FontSize',15,'FontWeight','bold','Color','r');
    xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
    ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    legend([L2(1),LEqEquity15,LBench15],'Equity ETF 13-15','1/N Equity','FTSE Bench','Location','northwest')

    hold off
    
    
    hold all
    %FTSE95 2014-2015
       
    %min-var
        figure(6);hold all;
        plot(sPort15FTSE(MinVarIndex15FTSE),mu15FTSEPort(MinVarIndex15FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15FTSE(MinVarIndex15FTSE)+0.0020,mu15FTSEPort(MinVarIndex15FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort15FTSE(MaxSharpeIndex15FTSE);
        figure(6);hold all;
        plot(x, MaxSharpe15FTSE*x + rf15)
        figure(6);hold all;
        plot(sPort15FTSE(MaxSharpeIndex15FTSE),mu15FTSEPort(MaxSharpeIndex15FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort15FTSE(MaxSharpeIndex15FTSE)+0.0020,mu15FTSEPort(MaxSharpeIndex15FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(6);hold all;
        L3 = plot(sPort15FTSE(MinVarIndex15FTSE:end),mu15FTSEPort(MinVarIndex15FTSE:end));
        L3(1).LineWidth = 3;
        set(L3(1),'Color','b');
         for t=1:n15FTSE
                text(sd15FTSE(t),mu15FTSE(t),assetNames15FTSE(t),'FontSize', 5,'Color','g');
         end
         %1/N
         figure(6);hold all;
         LEqFTSE15 = plot(sPortEq15FTSE,muPortEq15FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');

%FTSE100 Benchmark    
        figure(6);hold all;
        LBench15 = plot(sd15FTSEB,mu15FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
       
        legend([L3(1),LEqFTSE15,LBench15],'FTSE100 13-15','1/N FTSE','FTSE Bench','Location','northwest')
    
        title('Efficient Frontier (FTSE100 2015)','FontSize',15,'FontWeight','bold','Color','r');
        xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
        ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    
        
        
        
        
       hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Rebalanced Portfolio 2015 - 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%MAC 2015-2016
        hold all
        format long
        
        %min-var
        figure(7);hold all;
        plot(sPort16MAC(MinVar16MACIndex),muPort16MAC(MinVar16MACIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16MAC(MinVar16MACIndex)+0.0020,muPort16MAC(MinVar16MACIndex),'Min-Var','FontSize', 6,'Color','r')
        %tangency
        x=0:.01:sPort16MAC(MaxSharpeIndex16MAC);
        figure(7);hold all;
        plot(x, MaxSharpe16MAC*x + rf16)
        figure(7);hold all;
        plot(sPort16MAC(MaxSharpeIndex16MAC),muPort16MAC(MaxSharpeIndex16MAC),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16MAC(MaxSharpeIndex16MAC)+0.0020,muPort16MAC(MaxSharpeIndex16MAC),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %PLOTTING EFFICIENT FRONTIER ONLY
        figure(7);hold all;
    L1 = plot(sPort16MAC(MinVar16MACIndex:end),muPort16MAC(MinVar16MACIndex:end));
    set(L1(1),'linewidth',2);
    set(L1(1),'Color','g');
    for t=1:n16MAC
        text(sd16MAC(t),mu16MAC(t),assetNames16MAC(t),'FontSize', 5,'Color','r');
    end
    %EQUAL WEIGHTED 16MAC PORTFOLIO (1/N)
    figure(7);hold all;    
    LEqMAC16 = plot(sPortEq16MAC,muPortEq16MAC,'p','MarkerSize',7,'MarkerFaceColor','g','Color','g');
    %FTSE100 Benchmark    
        figure(7);hold all;
        LBench16 = plot(sd16FTSEB,mu16FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
 
   
         title('Efficient Frontier (MAC 2016)','FontSize',16,'FontWeight','bold','Color','r');
         xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
         ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
         figure(7);hold all;
         legend([L1(1),LEqMAC16,LBench16],'MAC ETF 13-16','1/N MAC','FTSE Bench','Location','northwest')
         hold off;

    
    hold all
    %All-Equity 2014-2016   
    %min-var
        figure(8);hold all
        plot(sPort16Equity(MinVar16EquityIndex),muPort16Equity(MinVar16EquityIndex),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16Equity(MinVar16EquityIndex)+0.0020,muPort16Equity(MinVar16EquityIndex),'Min-Var','FontSize', 6,'Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort16Equity(MaxSharpeIndex16Equity);
        figure(8);hold all;
        plot(x, MaxSharpe16Equity*x + rf16)
        figure(8);hold all;
        plot(sPort16Equity(MaxSharpeIndex16Equity),muPort16Equity(MaxSharpeIndex16Equity),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16Equity(MaxSharpeIndex16Equity)+0.0020,muPort16Equity(MaxSharpeIndex16Equity),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(8);hold all;
        L2 = plot(sPort16Equity(MinVar16EquityIndex:end),muPort16Equity(MinVar16EquityIndex:end));
    set(L2(1),'linewidth',2);
    set(L2(1),'Color','r');
    for t=1:n16Equity
        text(sd16Equity(t),mu16Equity(t),assetNames16Equity(t),'FontSize', 5,'Color','r');
    end
        %1/N
        figure(8);hold all;
        LEqEquity16 = plot(sPortEq16Equity,muPortEq16Equity,'p','MarkerSize',7,'MarkerFaceColor','r','Color','r');

%FTSE100 Benchmark    
        figure(8);hold all;
        LBench16 = plot(sd16FTSEB,mu16FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
        figure(8);hold all;

     title('Efficient Frontier (All-Equity 2016)','FontSize',16,'FontWeight','bold','Color','r');
    xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
    ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    legend([L2(1),LEqEquity16,LBench16],'Equity ETF 13-16','1/N Equity','FTSE Bench','Location','northwest')

    hold off
    
    
    hold all
    %FTSE95 2014-2016
       
    %min-var
        figure(9);hold all;
        plot(sPort16FTSE(MinVarIndex16FTSE),mu16FTSEPort(MinVarIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MinVarIndex16FTSE)+0.0020,mu16FTSEPort(MinVarIndex16FTSE),'Min-Var','FontSize', 7,'FontWeight', 'bold','Color','r')
        %FINDING MAX-SHARPE INDEX & CML(TANGENCY PORTFOLIO)
        x=0:.01:sPort16FTSE(MaxSharpeIndex16FTSE);
        figure(9);hold all;
        plot(x, MaxSharpe16FTSE*x + rf16)
        figure(9);hold all;
        plot(sPort16FTSE(MaxSharpeIndex16FTSE),mu16FTSEPort(MaxSharpeIndex16FTSE),'d','MarkerSize',7,'MarkerFaceColor','c','Color','r')
        text(sPort16FTSE(MaxSharpeIndex16FTSE)+0.0020,mu16FTSEPort(MaxSharpeIndex16FTSE),'Tangency Portfolio','FontSize', 7,'FontWeight', 'bold','Color','r')
        %frontier
        figure(9);hold all;
        L3 = plot(sPort16FTSE(MinVarIndex16FTSE:end),mu16FTSEPort(MinVarIndex16FTSE:end));
        L3(1).LineWidth = 3;
        set(L3(1),'Color','b');
         for t=1:n16FTSE
                text(sd16FTSE(t),mu16FTSE(t),assetNames16FTSE(t),'FontSize', 5,'Color','g');
         end
         %1/N
         figure(9);hold all;
         LEqFTSE16 = plot(sPortEq16FTSE,muPortEq16FTSE,'p','MarkerSize',7,'MarkerFaceColor','b','Color','b');

%FTSE100 Benchmark    
        figure(9);hold all;
        LBench16 = plot(sd16FTSEB,mu16FTSEB,'o','MarkerSize',7,'MarkerFaceColor','r','Color','b');
       
        legend([L3(1),LEqFTSE16,LBench16],'FTSE100 13-16','1/N FTSE','FTSE Bench','Location','northwest')
    
        title('Efficient Frontier (FTSE100 2016)','FontSize',16,'FontWeight','bold','Color','r');
        xlabel('Standard Deviation [RISK]','FontSize',12,'FontWeight','bold','Color','b');
        ylabel('Expected Return [REWARD]','FontSize',12,'FontWeight','bold','Color','b');
    

