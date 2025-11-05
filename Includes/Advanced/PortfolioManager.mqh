//+------------------------------------------------------------------+
//|                                             PortfolioManager.mqh |
//|                                   Advanced Portfolio Management  |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Advanced Portfolio Management Class                            |
//+------------------------------------------------------------------+
class CPortfolioManager
{
private:
    //--- Portfolio structure
    struct PortfolioPosition
    {
        string symbol;
        ENUM_ORDER_TYPE orderType;
        double lotSize;
        double entryPrice;
        double currentPrice;
        double stopLoss;
        double takeProfit;
        double profit;
        double profitPercent;
        datetime openTime;
        int ticket;
        double riskAmount;
        double maxRisk;
        bool isActive;
    };
    
    PortfolioPosition m_positions[100];
    int m_positionCount;
    
    //--- Portfolio metrics
    struct PortfolioMetrics
    {
        double totalEquity;
        double totalProfit;
        double totalLoss;
        double maxDrawdown;
        double currentDrawdown;
        double profitFactor;
        double sharpeRatio;
        double totalRisk;
        double riskUtilization;
        int winningTrades;
        int losingTrades;
        double winRate;
        double avgWin;
        double avgLoss;
        double maxConsecutiveWins;
        double maxConsecutiveLosses;
    };
    
    PortfolioMetrics m_metrics;
    
    //--- Risk parameters
    double m_maxRiskPerTrade;
    double m_maxPortfolioRisk;
    double m_maxCorrelationRisk;
    double m_maxDrawdownLimit;
    bool m_enableRiskManagement;
    
    //--- Correlation matrix
    double m_correlationMatrix[20][20];
    string m_symbols[20];
    int m_symbolCount;
    
    //--- Performance tracking
    struct DailyPerformance
    {
        datetime date;
        double equity;
        double profit;
        double drawdown;
        int trades;
    };
    
    DailyPerformance m_dailyPerformance[365];
    int m_performanceDays;

public:
    //--- Constructor
    CPortfolioManager();
    
    //--- Initialization
    bool Initialize(double maxRiskPerTrade = 2.0, double maxPortfolioRisk = 10.0);
    void SetRiskParameters(double riskPerTrade, double portfolioRisk, double correlationRisk = 0.7);
    
    //--- Position management
    bool AddPosition(string symbol, ENUM_ORDER_TYPE orderType, double lotSize, 
                    double entryPrice, double stopLoss, double takeProfit, int ticket);
    bool RemovePosition(int ticket);
    bool UpdatePosition(int ticket, double currentPrice);
    void CloseAllPositions();
    void ClosePositionsBySymbol(string symbol);
    
    //--- Portfolio analysis
    void UpdatePortfolioMetrics();
    double CalculatePortfolioValue();
    double CalculatePortfolioRisk();
    double CalculateMaxDrawdown();
    double CalculatePortfolioVolatility();
    double CalculateSharpeRatio();
    
    //--- Risk management
    bool ValidateNewPosition(string symbol, ENUM_ORDER_TYPE orderType, double lotSize);
    double CalculateOptimalLotSize(string symbol, double riskPercent);
    bool CheckRiskLimits();
    bool IsCorrelationRiskAcceptable(string symbol, ENUM_ORDER_TYPE orderType);
    void ImplementStopLoss();
    
    //--- Correlation analysis
    void UpdateCorrelationMatrix();
    double CalculatePortfolioCorrelation(string newSymbol, ENUM_ORDER_TYPE orderType);
    bool IsHighCorrelationRisk(string symbol1, string symbol2);
    void DiversifyPortfolio();
    
    //--- Performance analysis
    void UpdateDailyPerformance();
    double CalculateMonthlyReturn();
    double CalculateAnnualizedReturn();
    double CalculateMaxConsecutiveDrawdown();
    void AnalyzePerformanceMetrics();
    
    //--- Rebalancing
    void RebalancePortfolio();
    bool ShouldReduceExposure(string symbol);
    bool ShouldIncreaseExposure(string symbol);
    void OptimizePortfolioWeights();
    
    //--- Advanced features
    void ImplementTrailingStops();
    void ScaleOutWinningPositions();
    void HedgePortfolioRisk();
    bool DetectMarketRegimeChange();
    void AdjustRiskBasedOnVolatility();
    
    //--- Information functions
    PortfolioMetrics GetMetrics() { return m_metrics; }
    int GetActivePositions() { return m_positionCount; }
    double GetTotalRisk() { return m_metrics.totalRisk; }
    double GetProfitFactor() { return m_metrics.profitFactor; }
    double GetWinRate() { return m_metrics.winRate; }
    
    //--- Position queries
    PortfolioPosition GetPosition(int index);
    int FindPositionByTicket(int ticket);
    int GetPositionsBySymbol(string symbol);
    double GetSymbolExposure(string symbol);
    
    //--- Reporting
    void PrintPortfolioSummary();
    void PrintDetailedReport();
    void ExportPerformanceReport();
    string GetPortfolioStatus();
    
    //--- Monte Carlo simulation
    void RunMonteCarloSimulation(int iterations = 1000);
    double CalculateValueAtRisk(double confidence = 0.95);
    double CalculateExpectedShortfall(double confidence = 0.95);
    
    //--- Machine learning integration
    void TrainRiskModel();
    double PredictPortfolioVolatility();
    void OptimizePortfolioWithML();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPortfolioManager::CPortfolioManager()
{
    m_positionCount = 0;
    m_symbolCount = 0;
    m_performanceDays = 0;
    
    //--- Initialize risk parameters
    m_maxRiskPerTrade = 2.0;
    m_maxPortfolioRisk = 10.0;
    m_maxCorrelationRisk = 0.7;
    m_maxDrawdownLimit = 15.0;
    m_enableRiskManagement = true;
    
    //--- Initialize metrics
    m_metrics.totalEquity = AccountInfoDouble(ACCOUNT_BALANCE);
    m_metrics.totalProfit = 0.0;
    m_metrics.totalLoss = 0.0;
    m_metrics.maxDrawdown = 0.0;
    m_metrics.currentDrawdown = 0.0;
    m_metrics.totalRisk = 0.0;
    m_metrics.winningTrades = 0;
    m_metrics.losingTrades = 0;
    
    Print("💼 Portfolio Manager initialized with ", m_positionCount, " positions");
}

//+------------------------------------------------------------------+
//| Initialize portfolio manager                                    |
//+------------------------------------------------------------------+
bool CPortfolioManager::Initialize(double maxRiskPerTrade = 2.0, double maxPortfolioRisk = 10.0)
{
    m_maxRiskPerTrade = maxRiskPerTrade;
    m_maxPortfolioRisk = maxPortfolioRisk;
    
    //--- Load existing positions (MQL5 style)
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionSelectByIndex(i))
        {
            if(m_positionCount < 100)
            {
                m_positions[m_positionCount].symbol = PositionGetString(POSITION_SYMBOL);
                m_positions[m_positionCount].orderType = (ENUM_ORDER_TYPE)PositionGetInteger(POSITION_TYPE);
                m_positions[m_positionCount].lotSize = PositionGetDouble(POSITION_VOLUME);
                m_positions[m_positionCount].entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
                m_positions[m_positionCount].stopLoss = PositionGetDouble(POSITION_SL);
                m_positions[m_positionCount].takeProfit = PositionGetDouble(POSITION_TP);
                m_positions[m_positionCount].openTime = (datetime)PositionGetInteger(POSITION_TIME);
                m_positions[m_positionCount].ticket = PositionGetInteger(POSITION_TICKET);
                m_positions[m_positionCount].profit = PositionGetDouble(POSITION_PROFIT);
                m_positions[m_positionCount].isActive = true;
                
                m_positionCount++;
            }
        }
    }
    
    //--- Update initial metrics
    UpdatePortfolioMetrics();
    
    Print("✅ Portfolio Manager initialized: Risk per trade=", maxRiskPerTrade, 
          "%, Portfolio risk=", maxPortfolioRisk, "%, Positions=", m_positionCount);
    
    return true;
}

//+------------------------------------------------------------------+
//| Set risk parameters                                            |
//+------------------------------------------------------------------+
void CPortfolioManager::SetRiskParameters(double riskPerTrade, double portfolioRisk, double correlationRisk = 0.7)
{
    m_maxRiskPerTrade = riskPerTrade;
    m_maxPortfolioRisk = portfolioRisk;
    m_maxCorrelationRisk = correlationRisk;
    
    Print("⚙️ Risk parameters updated: Trade=", riskPerTrade, "%, Portfolio=", portfolioRisk, 
          "%, Correlation=", correlationRisk);
}

//+------------------------------------------------------------------+
//| Add new position to portfolio                                  |
//+------------------------------------------------------------------+
bool CPortfolioManager::AddPosition(string symbol, ENUM_ORDER_TYPE orderType, double lotSize,
                                   double entryPrice, double stopLoss, double takeProfit, int ticket)
{
    if(m_positionCount >= 100)
    {
        Print("❌ Portfolio full - cannot add more positions");
        return false;
    }
    
    //--- Validate position against risk limits
    if(m_enableRiskManagement && !ValidateNewPosition(symbol, orderType, lotSize))
    {
        Print("❌ Position rejected due to risk limits");
        return false;
    }
    
    //--- Add position
    m_positions[m_positionCount].symbol = symbol;
    m_positions[m_positionCount].orderType = orderType;
    m_positions[m_positionCount].lotSize = lotSize;
    m_positions[m_positionCount].entryPrice = entryPrice;
    m_positions[m_positionCount].currentPrice = entryPrice;
    m_positions[m_positionCount].stopLoss = stopLoss;
    m_positions[m_positionCount].takeProfit = takeProfit;
    m_positions[m_positionCount].openTime = TimeCurrent();
    m_positions[m_positionCount].ticket = ticket;
    m_positions[m_positionCount].profit = 0.0;
    m_positions[m_positionCount].isActive = true;
    
    //--- Calculate risk
    double riskAmount = MathAbs(entryPrice - stopLoss) * lotSize * SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
    m_positions[m_positionCount].riskAmount = riskAmount;
    m_positions[m_positionCount].maxRisk = (riskAmount / AccountInfoDouble(ACCOUNT_BALANCE)) * 100;
    
    m_positionCount++;
    
    //--- Update metrics
    UpdatePortfolioMetrics();
    
    Print("➕ Position added: ", symbol, " ", EnumToString(orderType), " Lots=", lotSize, 
          " Risk=", DoubleToString(m_positions[m_positionCount-1].maxRisk, 2), "%");
    
    return true;
}

//+------------------------------------------------------------------+
//| Remove position from portfolio                                 |
//+------------------------------------------------------------------+
bool CPortfolioManager::RemovePosition(int ticket)
{
    int index = FindPositionByTicket(ticket);
    if(index == -1)
        return false;
    
    //--- Mark position as inactive
    m_positions[index].isActive = false;
    
    //--- Update metrics based on final result
    if(m_positions[index].profit > 0)
    {
        m_metrics.winningTrades++;
        m_metrics.totalProfit += m_positions[index].profit;
    }
    else
    {
        m_metrics.losingTrades++;
        m_metrics.totalLoss += MathAbs(m_positions[index].profit);
    }
    
    //--- Compact array
    for(int i = index; i < m_positionCount - 1; i++)
    {
        m_positions[i] = m_positions[i + 1];
    }
    m_positionCount--;
    
    //--- Update metrics
    UpdatePortfolioMetrics();
    
    Print("➖ Position removed: Ticket=", ticket, " Final P&L=", m_positions[index].profit);
    
    return true;
}

//+------------------------------------------------------------------+
//| Update portfolio metrics                                       |
//+------------------------------------------------------------------+
void CPortfolioManager::UpdatePortfolioMetrics()
{
    m_metrics.totalEquity = AccountEquity();
    m_metrics.totalRisk = CalculatePortfolioRisk();
    m_metrics.riskUtilization = (m_metrics.totalRisk / m_maxPortfolioRisk) * 100;
    
    //--- Calculate win rate
    int totalTrades = m_metrics.winningTrades + m_metrics.losingTrades;
    if(totalTrades > 0)
    {
        m_metrics.winRate = ((double)m_metrics.winningTrades / totalTrades) * 100;
        m_metrics.avgWin = m_metrics.winningTrades > 0 ? m_metrics.totalProfit / m_metrics.winningTrades : 0;
        m_metrics.avgLoss = m_metrics.losingTrades > 0 ? m_metrics.totalLoss / m_metrics.losingTrades : 0;
        m_metrics.profitFactor = m_metrics.totalLoss > 0 ? m_metrics.totalProfit / m_metrics.totalLoss : 0;
    }
    
    //--- Calculate drawdown
    m_metrics.currentDrawdown = CalculateMaxDrawdown();
    if(m_metrics.currentDrawdown > m_metrics.maxDrawdown)
        m_metrics.maxDrawdown = m_metrics.currentDrawdown;
    
    //--- Update daily performance
    UpdateDailyPerformance();
}

//+------------------------------------------------------------------+
//| Calculate portfolio risk                                       |
//+------------------------------------------------------------------+
double CPortfolioManager::CalculatePortfolioRisk()
{
    double totalRisk = 0.0;
    
    for(int i = 0; i < m_positionCount; i++)
    {
        if(m_positions[i].isActive)
        {
            totalRisk += m_positions[i].maxRisk;
        }
    }
    
    return totalRisk;
}

//+------------------------------------------------------------------+
//| Validate new position against risk limits                     |
//+------------------------------------------------------------------+
bool CPortfolioManager::ValidateNewPosition(string symbol, ENUM_ORDER_TYPE orderType, double lotSize)
{
    //--- Check individual trade risk limit
    double tradeRisk = (lotSize * 100) / (AccountInfoDouble(ACCOUNT_BALANCE) / 1000); // Simplified risk calculation
    if(tradeRisk > m_maxRiskPerTrade)
    {
        Print("❌ Trade risk (", DoubleToString(tradeRisk, 2), "%) exceeds limit (", m_maxRiskPerTrade, "%)");
        return false;
    }
    
    //--- Check portfolio risk limit
    double newPortfolioRisk = m_metrics.totalRisk + tradeRisk;
    if(newPortfolioRisk > m_maxPortfolioRisk)
    {
        Print("❌ Portfolio risk (", DoubleToString(newPortfolioRisk, 2), "%) would exceed limit (", m_maxPortfolioRisk, "%)");
        return false;
    }
    
    //--- Check correlation risk
    if(!IsCorrelationRiskAcceptable(symbol, orderType))
    {
        Print("❌ High correlation risk detected for ", symbol);
        return false;
    }
    
    //--- Check drawdown limit
    if(m_metrics.currentDrawdown > m_maxDrawdownLimit)
    {
        Print("❌ Drawdown limit exceeded: ", DoubleToString(m_metrics.currentDrawdown, 2), "%");
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Check correlation risk                                         |
//+------------------------------------------------------------------+
bool CPortfolioManager::IsCorrelationRiskAcceptable(string symbol, ENUM_ORDER_TYPE orderType)
{
    double totalCorrelation = 0.0;
    int correlatedPositions = 0;
    
    for(int i = 0; i < m_positionCount; i++)
    {
        if(m_positions[i].isActive && m_positions[i].orderType == orderType)
        {
            //--- Calculate correlation (simplified)
            double correlation = CalculatePortfolioCorrelation(symbol, orderType);
            
            if(correlation > m_maxCorrelationRisk)
            {
                correlatedPositions++;
                totalCorrelation += correlation;
            }
        }
    }
    
    //--- Reject if too many highly correlated positions
    if(correlatedPositions >= 3)
    {
        Print("❌ Too many correlated positions: ", correlatedPositions);
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate portfolio correlation                                |
//+------------------------------------------------------------------+
double CPortfolioManager::CalculatePortfolioCorrelation(string newSymbol, ENUM_ORDER_TYPE orderType)
{
    //--- Simplified correlation calculation based on currency pairs
    double maxCorrelation = 0.0;
    
    for(int i = 0; i < m_positionCount; i++)
    {
        if(m_positions[i].isActive && m_positions[i].orderType == orderType)
        {
            string existingSymbol = m_positions[i].symbol;
            
            //--- Check for same base or quote currency
            string newBase = StringSubstr(newSymbol, 0, 3);
            string newQuote = StringSubstr(newSymbol, 3, 3);
            string existingBase = StringSubstr(existingSymbol, 0, 3);
            string existingQuote = StringSubstr(existingSymbol, 3, 3);
            
            double correlation = 0.0;
            
            //--- Same pair = 100% correlation
            if(newSymbol == existingSymbol)
                correlation = 1.0;
            //--- Same base currency = high correlation
            else if(newBase == existingBase)
                correlation = 0.8;
            //--- Same quote currency = moderate correlation
            else if(newQuote == existingQuote)
                correlation = 0.6;
            //--- Related currencies (USD pairs) = low correlation
            else if((newBase == "USD" || newQuote == "USD") && 
                   (existingBase == "USD" || existingQuote == "USD"))
                correlation = 0.3;
            
            if(correlation > maxCorrelation)
                maxCorrelation = correlation;
        }
    }
    
    return maxCorrelation;
}

//+------------------------------------------------------------------+
//| Calculate optimal lot size                                     |
//+------------------------------------------------------------------+
double CPortfolioManager::CalculateOptimalLotSize(string symbol, double riskPercent)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (riskPercent / 100.0);
    
    //--- Get symbol specifications
    double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
    double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    
    //--- Calculate lot size based on risk
    double stopLossPips = 50; // Default stop loss
    double lotSize = riskAmount / (stopLossPips * tickValue / tickSize);
    
    //--- Normalize to valid lot size
    lotSize = MathMax(minLot, MathMin(maxLot, lotSize));
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    return lotSize;
}

//+------------------------------------------------------------------+
//| Update daily performance                                       |
//+------------------------------------------------------------------+
void CPortfolioManager::UpdateDailyPerformance()
{
    datetime today = TimeCurrent();
    datetime todayDate = today - (today % 86400); // Start of day
    
    //--- Check if we already have today's data
    bool found = false;
    for(int i = 0; i < m_performanceDays; i++)
    {
        if(m_dailyPerformance[i].date == todayDate)
        {
            //--- Update existing entry
            m_dailyPerformance[i].equity = AccountEquity();
            m_dailyPerformance[i].profit = AccountProfit();
            m_dailyPerformance[i].drawdown = m_metrics.currentDrawdown;
            m_dailyPerformance[i].trades = m_positionCount;
            found = true;
            break;
        }
    }
    
    //--- Add new entry if not found
    if(!found && m_performanceDays < 365)
    {
        m_dailyPerformance[m_performanceDays].date = todayDate;
        m_dailyPerformance[m_performanceDays].equity = AccountEquity();
        m_dailyPerformance[m_performanceDays].profit = AccountProfit();
        m_dailyPerformance[m_performanceDays].drawdown = m_metrics.currentDrawdown;
        m_dailyPerformance[m_performanceDays].trades = m_positionCount;
        m_performanceDays++;
    }
}

//+------------------------------------------------------------------+
//| Print portfolio summary                                        |
//+------------------------------------------------------------------+
void CPortfolioManager::PrintPortfolioSummary()
{
    Print("═══════════════════════════════════════");
    Print("💼 PORTFOLIO SUMMARY");
    Print("═══════════════════════════════════════");
    Print("💰 Total Equity: $", DoubleToString(m_metrics.totalEquity, 2));
    Print("📊 Active Positions: ", m_positionCount);
    Print("⚠️ Total Risk: ", DoubleToString(m_metrics.totalRisk, 2), "%");
    Print("📈 Risk Utilization: ", DoubleToString(m_metrics.riskUtilization, 1), "%");
    Print("🎯 Win Rate: ", DoubleToString(m_metrics.winRate, 1), "%");
    Print("💹 Profit Factor: ", DoubleToString(m_metrics.profitFactor, 2));
    Print("📉 Max Drawdown: ", DoubleToString(m_metrics.maxDrawdown, 2), "%");
    Print("📊 Current Drawdown: ", DoubleToString(m_metrics.currentDrawdown, 2), "%");
    Print("🏆 Winning Trades: ", m_metrics.winningTrades);
    Print("📉 Losing Trades: ", m_metrics.losingTrades);
    Print("💵 Avg Win: $", DoubleToString(m_metrics.avgWin, 2));
    Print("💸 Avg Loss: $", DoubleToString(m_metrics.avgLoss, 2));
    Print("═══════════════════════════════════════");
}

//+------------------------------------------------------------------+
//| Find position by ticket                                        |
//+------------------------------------------------------------------+
int CPortfolioManager::FindPositionByTicket(int ticket)
{
    for(int i = 0; i < m_positionCount; i++)
    {
        if(m_positions[i].ticket == ticket && m_positions[i].isActive)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Calculate maximum drawdown                                     |
//+------------------------------------------------------------------+
double CPortfolioManager::CalculateMaxDrawdown()
{
    double maxEquity = AccountInfoDouble(ACCOUNT_BALANCE);
    double currentEquity = AccountEquity();
    
    //--- Find historical peak
    for(int i = 0; i < m_performanceDays; i++)
    {
        if(m_dailyPerformance[i].equity > maxEquity)
            maxEquity = m_dailyPerformance[i].equity;
    }
    
    //--- Calculate drawdown from peak
    double drawdown = ((maxEquity - currentEquity) / maxEquity) * 100;
    
    return MathMax(0, drawdown);
}

//+------------------------------------------------------------------+
//| Get portfolio status                                           |
//+------------------------------------------------------------------+
string CPortfolioManager::GetPortfolioStatus()
{
    string status = "Portfolio Status: ";
    
    if(m_metrics.currentDrawdown > m_maxDrawdownLimit)
        status += "HIGH RISK - Drawdown limit exceeded";
    else if(m_metrics.totalRisk > m_maxPortfolioRisk * 0.8)
        status += "MODERATE RISK - High risk utilization";
    else if(m_positionCount == 0)
        status += "IDLE - No active positions";
    else
        status += "HEALTHY - Normal operation";
    
    return status;
}
