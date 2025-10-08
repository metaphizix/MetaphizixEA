//+------------------------------------------------------------------+
//|                                               RiskAdjuster.mqh |
//|                                   Advanced Risk Adjustment EA   |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Dynamic Risk Adjustment Class                                  |
//+------------------------------------------------------------------+
class CRiskAdjuster
{
private:
    //--- Risk adjustment parameters
    struct RiskParameters
    {
        double baseRiskPercent;
        double currentRiskPercent;
        double maxRiskPercent;
        double minRiskPercent;
        double volatilityMultiplier;
        double correlationAdjustment;
        double marketRegimeAdjustment;
        double drawdownAdjustment;
        double winRateAdjustment;
        datetime lastAdjustment;
    };
    
    RiskParameters m_riskParams;
    
    //--- Market conditions
    struct MarketConditions
    {
        double currentVolatility;
        double avgVolatility;
        double volatilityRatio;
        double marketTrend;
        double liquidity;
        double spread;
        string marketRegime;
        bool isHighVolatility;
        bool isLowLiquidity;
        bool isNewsTime;
    };
    
    MarketConditions m_marketConditions;
    
    //--- Performance metrics
    struct PerformanceMetrics
    {
        double currentDrawdown;
        double maxDrawdown;
        double winRate;
        double profitFactor;
        double sharpeRatio;
        double calmarRatio;
        int consecutiveLosses;
        int totalTrades;
        double avgWin;
        double avgLoss;
        double recentPerformance;
    };
    
    PerformanceMetrics m_performance;
    
    //--- Risk adjustment rules
    struct AdjustmentRule
    {
        string condition;
        double multiplier;
        string description;
        bool isActive;
        int priority;
    };
    
    AdjustmentRule m_rules[20];
    int m_ruleCount;
    
    //--- Volatility analysis
    double m_volatilityHistory[100];
    int m_volatilityCount;
    
    //--- Risk events
    struct RiskEvent
    {
        datetime timestamp;
        string eventType;
        double riskBefore;
        double riskAfter;
        string reason;
        double impact;
    };
    
    RiskEvent m_riskEvents[50];
    int m_eventCount;

public:
    //--- Constructor
    CRiskAdjuster();
    
    //--- Initialization
    bool Initialize(double baseRisk = 2.0, double maxRisk = 5.0, double minRisk = 0.5);
    void SetBaseRiskParameters(double base, double max, double min);
    
    //--- Core risk adjustment
    double CalculateAdjustedRisk(string symbol);
    double AdjustForVolatility(string symbol, double baseRisk);
    double AdjustForMarketConditions(string symbol, double baseRisk);
    double AdjustForPerformance(double baseRisk);
    double AdjustForDrawdown(double baseRisk);
    double AdjustForCorrelation(string symbol, double baseRisk);
    
    //--- Market condition analysis
    void UpdateMarketConditions(string symbol);
    double CalculateCurrentVolatility(string symbol);
    double GetVolatilityRatio(string symbol);
    string DetermineMarketRegime(string symbol);
    bool IsHighVolatilityPeriod(string symbol);
    bool IsLowLiquidityPeriod(string symbol);
    bool IsNewsTime();
    
    //--- Performance-based adjustments
    void UpdatePerformanceMetrics();
    double CalculateCurrentDrawdown();
    double CalculateWinRate();
    double CalculateProfitFactor();
    double CalculateSharpeRatio();
    int GetConsecutiveLosses();
    
    //--- Volatility management
    void UpdateVolatilityHistory(string symbol);
    double GetAverageVolatility();
    double GetVolatilityStandardDeviation();
    bool IsVolatilitySpike(string symbol);
    double GetVolatilityPercentile(double currentVol);
    
    //--- Dynamic risk rules
    void CreateAdjustmentRules();
    void AddCustomRule(string condition, double multiplier, string description);
    void ProcessAdjustmentRules(string symbol);
    void UpdateRuleStatus();
    
    //--- Risk regime detection
    string GetCurrentRiskRegime();
    bool IsLowRiskRegime();
    bool IsHighRiskRegime();
    bool IsStressedMarket();
    void AdjustForRiskRegime();
    
    //--- Position sizing
    double CalculateOptimalLotSize(string symbol, double riskPercent);
    double AdjustLotSizeForConditions(string symbol, double baseLotSize);
    double GetMaxPositionSize(string symbol);
    bool ValidatePositionSize(string symbol, double lotSize);
    
    //--- Advanced features
    void ImplementVolatilityTargeting(string symbol);
    void AdjustForTimeOfDay();
    void AdjustForDayOfWeek();
    void AdjustForSeasonality();
    void ImplementRiskBudgeting();
    
    //--- Risk monitoring
    void MonitorRiskLimits();
    bool IsRiskLimitBreached();
    void TriggerRiskReduction();
    void ImplementEmergencyRiskReduction();
    
    //--- Machine learning integration
    void TrainRiskModel();
    double PredictOptimalRisk(string symbol);
    void OptimizeRiskParameters();
    void ImplementAdaptiveRisk();
    
    //--- Event handling
    void HandleVolatilitySpike(string symbol);
    void HandleDrawdownEvent();
    void HandleLossStreak();
    void HandleLowLiquidity();
    void LogRiskEvent(string eventType, double riskBefore, double riskAfter, string reason);
    
    //--- Information functions
    double GetCurrentRisk() { return m_riskParams.currentRiskPercent; }
    MarketConditions GetMarketConditions() { return m_marketConditions; }
    PerformanceMetrics GetPerformanceMetrics() { return m_performance; }
    string GetRiskStatus();
    
    //--- Reporting
    void PrintRiskSummary();
    void PrintDetailedRiskReport();
    void ExportRiskAnalysis();
    string GetRiskAdjustmentHistory();
    
    //--- Validation
    bool ValidateRiskParameters();
    bool IsRiskWithinLimits(double risk);
    void EnforceRiskLimits();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRiskAdjuster::CRiskAdjuster()
{
    //--- Initialize risk parameters
    m_riskParams.baseRiskPercent = 2.0;
    m_riskParams.currentRiskPercent = 2.0;
    m_riskParams.maxRiskPercent = 5.0;
    m_riskParams.minRiskPercent = 0.5;
    m_riskParams.volatilityMultiplier = 1.0;
    m_riskParams.correlationAdjustment = 1.0;
    m_riskParams.marketRegimeAdjustment = 1.0;
    m_riskParams.drawdownAdjustment = 1.0;
    m_riskParams.winRateAdjustment = 1.0;
    m_riskParams.lastAdjustment = TimeCurrent();
    
    //--- Initialize market conditions
    m_marketConditions.currentVolatility = 0.0;
    m_marketConditions.avgVolatility = 0.0;
    m_marketConditions.volatilityRatio = 1.0;
    m_marketConditions.marketRegime = "NORMAL";
    m_marketConditions.isHighVolatility = false;
    m_marketConditions.isLowLiquidity = false;
    m_marketConditions.isNewsTime = false;
    
    //--- Initialize performance metrics
    m_performance.currentDrawdown = 0.0;
    m_performance.maxDrawdown = 0.0;
    m_performance.winRate = 50.0;
    m_performance.profitFactor = 1.0;
    m_performance.consecutiveLosses = 0;
    m_performance.totalTrades = 0;
    
    //--- Initialize counters
    m_ruleCount = 0;
    m_volatilityCount = 0;
    m_eventCount = 0;
    
    //--- Create default adjustment rules
    CreateAdjustmentRules();
    
    Print("⚖️ Risk Adjuster initialized with base risk: ", m_riskParams.baseRiskPercent, "%");
}

//+------------------------------------------------------------------+
//| Initialize risk adjuster                                       |
//+------------------------------------------------------------------+
bool CRiskAdjuster::Initialize(double baseRisk = 2.0, double maxRisk = 5.0, double minRisk = 0.5)
{
    SetBaseRiskParameters(baseRisk, maxRisk, minRisk);
    
    //--- Validate parameters
    if(!ValidateRiskParameters())
    {
        Print("❌ Invalid risk parameters");
        return false;
    }
    
    Print("✅ Risk Adjuster initialized: Base=", baseRisk, "%, Max=", maxRisk, "%, Min=", minRisk, "%");
    return true;
}

//+------------------------------------------------------------------+
//| Set base risk parameters                                       |
//+------------------------------------------------------------------+
void CRiskAdjuster::SetBaseRiskParameters(double base, double max, double min)
{
    m_riskParams.baseRiskPercent = base;
    m_riskParams.maxRiskPercent = max;
    m_riskParams.minRiskPercent = min;
    m_riskParams.currentRiskPercent = base;
    
    Print("⚙️ Risk parameters updated: Base=", base, "%, Max=", max, "%, Min=", min, "%");
}

//+------------------------------------------------------------------+
//| Calculate adjusted risk                                        |
//+------------------------------------------------------------------+
double CRiskAdjuster::CalculateAdjustedRisk(string symbol)
{
    //--- Start with base risk
    double adjustedRisk = m_riskParams.baseRiskPercent;
    
    //--- Update market conditions
    UpdateMarketConditions(symbol);
    
    //--- Update performance metrics
    UpdatePerformanceMetrics();
    
    //--- Apply adjustments
    adjustedRisk = AdjustForVolatility(symbol, adjustedRisk);
    adjustedRisk = AdjustForMarketConditions(symbol, adjustedRisk);
    adjustedRisk = AdjustForPerformance(adjustedRisk);
    adjustedRisk = AdjustForDrawdown(adjustedRisk);
    adjustedRisk = AdjustForCorrelation(symbol, adjustedRisk);
    
    //--- Process adjustment rules
    ProcessAdjustmentRules(symbol);
    
    //--- Enforce limits
    adjustedRisk = MathMax(m_riskParams.minRiskPercent, 
                          MathMin(m_riskParams.maxRiskPercent, adjustedRisk));
    
    //--- Log significant changes
    if(MathAbs(adjustedRisk - m_riskParams.currentRiskPercent) > 0.2)
    {
        LogRiskEvent("RISK_ADJUSTMENT", m_riskParams.currentRiskPercent, adjustedRisk, 
                     "Dynamic adjustment based on market conditions");
    }
    
    m_riskParams.currentRiskPercent = adjustedRisk;
    m_riskParams.lastAdjustment = TimeCurrent();
    
    return adjustedRisk;
}

//+------------------------------------------------------------------+
//| Adjust for volatility                                         |
//+------------------------------------------------------------------+
double CRiskAdjuster::AdjustForVolatility(string symbol, double baseRisk)
{
    double currentVol = CalculateCurrentVolatility(symbol);
    double avgVol = GetAverageVolatility();
    
    if(avgVol == 0) return baseRisk;
    
    double volRatio = currentVol / avgVol;
    m_marketConditions.volatilityRatio = volRatio;
    
    double adjustment = 1.0;
    
    //--- Reduce risk when volatility is high
    if(volRatio > 2.0)
        adjustment = 0.5;  // 50% risk reduction for very high volatility
    else if(volRatio > 1.5)
        adjustment = 0.7;  // 30% risk reduction for high volatility
    else if(volRatio > 1.2)
        adjustment = 0.85; // 15% risk reduction for moderate high volatility
    else if(volRatio < 0.5)
        adjustment = 1.3;  // 30% risk increase for very low volatility
    else if(volRatio < 0.8)
        adjustment = 1.15; // 15% risk increase for low volatility
    
    m_riskParams.volatilityMultiplier = adjustment;
    
    double adjustedRisk = baseRisk * adjustment;
    
    Print("📊 Volatility adjustment: Ratio=", DoubleToString(volRatio, 2), 
          ", Multiplier=", DoubleToString(adjustment, 2), 
          ", Risk: ", DoubleToString(baseRisk, 2), "% → ", DoubleToString(adjustedRisk, 2), "%");
    
    return adjustedRisk;
}

//+------------------------------------------------------------------+
//| Adjust for market conditions                                  |
//+------------------------------------------------------------------+
double CRiskAdjuster::AdjustForMarketConditions(string symbol, double baseRisk)
{
    double adjustment = 1.0;
    
    //--- Market regime adjustment
    string regime = DetermineMarketRegime(symbol);
    m_marketConditions.marketRegime = regime;
    
    if(regime == "TRENDING")
        adjustment *= 1.2;      // Increase risk in trending markets
    else if(regime == "RANGING")
        adjustment *= 0.9;      // Reduce risk in ranging markets
    else if(regime == "VOLATILE")
        adjustment *= 0.7;      // Reduce risk in volatile markets
    else if(regime == "CRISIS")
        adjustment *= 0.5;      // Significantly reduce risk in crisis
    
    //--- Liquidity adjustment
    if(IsLowLiquidityPeriod(symbol))
        adjustment *= 0.8;      // Reduce risk during low liquidity
    
    //--- News time adjustment
    if(IsNewsTime())
        adjustment *= 0.6;      // Reduce risk during news events
    
    //--- Spread adjustment
    double spread = SymbolInfoInteger(symbol, SYMBOL_SPREAD);
    double avgSpread = 20; // Simplified average
    if(spread > avgSpread * 2)
        adjustment *= 0.8;      // Reduce risk for high spreads
    
    m_riskParams.marketRegimeAdjustment = adjustment;
    
    return baseRisk * adjustment;
}

//+------------------------------------------------------------------+
//| Adjust for performance                                         |
//+------------------------------------------------------------------+
double CRiskAdjuster::AdjustForPerformance(double baseRisk)
{
    double adjustment = 1.0;
    
    //--- Win rate adjustment
    if(m_performance.winRate > 70)
        adjustment *= 1.1;      // Slightly increase risk for high win rate
    else if(m_performance.winRate < 30)
        adjustment *= 0.8;      // Reduce risk for low win rate
    
    //--- Profit factor adjustment
    if(m_performance.profitFactor > 2.0)
        adjustment *= 1.15;     // Increase risk for good profit factor
    else if(m_performance.profitFactor < 1.0)
        adjustment *= 0.7;      // Reduce risk for poor profit factor
    else if(m_performance.profitFactor < 1.2)
        adjustment *= 0.85;     // Moderately reduce risk
    
    //--- Consecutive losses adjustment
    if(m_performance.consecutiveLosses >= 5)
        adjustment *= 0.5;      // Significantly reduce risk after 5 losses
    else if(m_performance.consecutiveLosses >= 3)
        adjustment *= 0.7;      // Reduce risk after 3 losses
    
    //--- Sharpe ratio adjustment
    if(m_performance.sharpeRatio > 1.5)
        adjustment *= 1.1;      // Increase risk for good risk-adjusted returns
    else if(m_performance.sharpeRatio < 0.5)
        adjustment *= 0.8;      // Reduce risk for poor risk-adjusted returns
    
    m_riskParams.winRateAdjustment = adjustment;
    
    return baseRisk * adjustment;
}

//+------------------------------------------------------------------+
//| Adjust for drawdown                                           |
//+------------------------------------------------------------------+
double CRiskAdjuster::AdjustForDrawdown(double baseRisk)
{
    double adjustment = 1.0;
    double currentDD = CalculateCurrentDrawdown();
    
    //--- Progressive risk reduction based on drawdown
    if(currentDD > 15.0)
        adjustment = 0.3;       // Severe risk reduction for large drawdown
    else if(currentDD > 10.0)
        adjustment = 0.5;       // Significant risk reduction
    else if(currentDD > 7.0)
        adjustment = 0.7;       // Moderate risk reduction
    else if(currentDD > 5.0)
        adjustment = 0.85;      // Slight risk reduction
    else if(currentDD < 2.0 && m_performance.totalTrades > 10)
        adjustment = 1.1;       // Slight risk increase for low drawdown
    
    m_riskParams.drawdownAdjustment = adjustment;
    
    if(currentDD > 5.0)
    {
        Print("⚠️ Drawdown adjustment: DD=", DoubleToString(currentDD, 1), 
              "%, Risk multiplier=", DoubleToString(adjustment, 2));
    }
    
    return baseRisk * adjustment;
}

//+------------------------------------------------------------------+
//| Update market conditions                                       |
//+------------------------------------------------------------------+
void CRiskAdjuster::UpdateMarketConditions(string symbol)
{
    //--- Update volatility
    m_marketConditions.currentVolatility = CalculateCurrentVolatility(symbol);
    UpdateVolatilityHistory(symbol);
    m_marketConditions.avgVolatility = GetAverageVolatility();
    
    //--- Update other conditions
    m_marketConditions.isHighVolatility = IsHighVolatilityPeriod(symbol);
    m_marketConditions.isLowLiquidity = IsLowLiquidityPeriod(symbol);
    m_marketConditions.isNewsTime = IsNewsTime();
    
    //--- Update spread
    m_marketConditions.spread = SymbolInfoInteger(symbol, SYMBOL_SPREAD);
}

//+------------------------------------------------------------------+
//| Calculate current volatility                                  |
//+------------------------------------------------------------------+
double CRiskAdjuster::CalculateCurrentVolatility(string symbol)
{
    //--- Use ATR as volatility measure
    double atr = iATR(symbol, PERIOD_H1, 24, 0); // 24-hour ATR
    double price = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    //--- Convert to percentage volatility
    double volatility = (atr / price) * 100;
    
    return volatility;
}

//+------------------------------------------------------------------+
//| Update volatility history                                     |
//+------------------------------------------------------------------+
void CRiskAdjuster::UpdateVolatilityHistory(string symbol)
{
    double currentVol = m_marketConditions.currentVolatility;
    
    //--- Add to history
    if(m_volatilityCount < 100)
    {
        m_volatilityHistory[m_volatilityCount] = currentVol;
        m_volatilityCount++;
    }
    else
    {
        //--- Shift array and add new value
        for(int i = 0; i < 99; i++)
        {
            m_volatilityHistory[i] = m_volatilityHistory[i + 1];
        }
        m_volatilityHistory[99] = currentVol;
    }
}

//+------------------------------------------------------------------+
//| Get average volatility                                         |
//+------------------------------------------------------------------+
double CRiskAdjuster::GetAverageVolatility()
{
    if(m_volatilityCount == 0) return 0.0;
    
    double sum = 0;
    for(int i = 0; i < m_volatilityCount; i++)
    {
        sum += m_volatilityHistory[i];
    }
    
    return sum / m_volatilityCount;
}

//+------------------------------------------------------------------+
//| Determine market regime                                        |
//+------------------------------------------------------------------+
string CRiskAdjuster::DetermineMarketRegime(string symbol)
{
    double volatilityRatio = m_marketConditions.volatilityRatio;
    double atr = iATR(symbol, PERIOD_D1, 14, 0);
    double adx = iADX(symbol, PERIOD_D1, 14, PRICE_CLOSE, MODE_MAIN, 0);
    
    //--- Crisis conditions
    if(volatilityRatio > 3.0)
        return "CRISIS";
    
    //--- High volatility
    if(volatilityRatio > 2.0 || atr > SymbolInfoDouble(symbol, SYMBOL_BID) * 0.02)
        return "VOLATILE";
    
    //--- Trending market
    if(adx > 30)
        return "TRENDING";
    
    //--- Ranging market
    if(adx < 20)
        return "RANGING";
    
    return "NORMAL";
}

//+------------------------------------------------------------------+
//| Check if high volatility period                               |
//+------------------------------------------------------------------+
bool CRiskAdjuster::IsHighVolatilityPeriod(string symbol)
{
    return m_marketConditions.volatilityRatio > 1.5;
}

//+------------------------------------------------------------------+
//| Check if low liquidity period                                 |
//+------------------------------------------------------------------+
bool CRiskAdjuster::IsLowLiquidityPeriod(string symbol)
{
    //--- Check time of day (simplified)
    datetime currentTime = TimeCurrent();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);
    
    //--- Low liquidity periods (simplified)
    int hour = timeStruct.hour;
    
    //--- Asian session lunch time or overlap gaps
    return (hour >= 4 && hour <= 6) || (hour >= 22 && hour <= 23);
}

//+------------------------------------------------------------------+
//| Check if news time                                            |
//+------------------------------------------------------------------+
bool CRiskAdjuster::IsNewsTime()
{
    //--- Simplified news time detection
    //--- In real implementation, this would check economic calendar
    datetime currentTime = TimeCurrent();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);
    
    //--- Major news times (simplified)
    int hour = timeStruct.hour;
    int minute = timeStruct.min;
    
    //--- Common news release times
    return ((hour == 8 || hour == 10 || hour == 14 || hour == 16) && minute >= 25 && minute <= 35);
}

//+------------------------------------------------------------------+
//| Update performance metrics                                     |
//+------------------------------------------------------------------+
void CRiskAdjuster::UpdatePerformanceMetrics()
{
    //--- Calculate current metrics from account
    m_performance.currentDrawdown = CalculateCurrentDrawdown();
    m_performance.winRate = CalculateWinRate();
    m_performance.profitFactor = CalculateProfitFactor();
    m_performance.consecutiveLosses = GetConsecutiveLosses();
    
    //--- Update max drawdown
    if(m_performance.currentDrawdown > m_performance.maxDrawdown)
        m_performance.maxDrawdown = m_performance.currentDrawdown;
}

//+------------------------------------------------------------------+
//| Calculate current drawdown                                     |
//+------------------------------------------------------------------+
double CRiskAdjuster::CalculateCurrentDrawdown()
{
    double currentEquity = AccountEquity();
    double balance = AccountBalance();
    
    //--- Calculate drawdown as percentage of balance
    double drawdown = ((balance - currentEquity) / balance) * 100;
    
    return MathMax(0, drawdown);
}

//+------------------------------------------------------------------+
//| Calculate win rate                                            |
//+------------------------------------------------------------------+
double CRiskAdjuster::CalculateWinRate()
{
    int totalDeals = OrdersHistoryTotal();
    if(totalDeals == 0) return 50.0; // Default
    
    int winningTrades = 0;
    
    for(int i = 0; i < totalDeals; i++)
    {
        if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
        {
            if(OrderProfit() > 0)
                winningTrades++;
        }
    }
    
    return totalDeals > 0 ? ((double)winningTrades / totalDeals) * 100 : 50.0;
}

//+------------------------------------------------------------------+
//| Create adjustment rules                                        |
//+------------------------------------------------------------------+
void CRiskAdjuster::CreateAdjustmentRules()
{
    //--- High volatility rule
    AddCustomRule("HIGH_VOLATILITY", 0.7, "Reduce risk during high volatility periods");
    
    //--- Low liquidity rule
    AddCustomRule("LOW_LIQUIDITY", 0.8, "Reduce risk during low liquidity");
    
    //--- News event rule
    AddCustomRule("NEWS_EVENT", 0.6, "Reduce risk during major news events");
    
    //--- Drawdown rule
    AddCustomRule("HIGH_DRAWDOWN", 0.5, "Reduce risk during high drawdown periods");
    
    //--- Loss streak rule
    AddCustomRule("LOSS_STREAK", 0.6, "Reduce risk after consecutive losses");
    
    //--- Weekend rule
    AddCustomRule("WEEKEND_RISK", 0.9, "Slightly reduce risk before weekends");
    
    Print("📋 Created ", m_ruleCount, " risk adjustment rules");
}

//+------------------------------------------------------------------+
//| Add custom adjustment rule                                     |
//+------------------------------------------------------------------+
void CRiskAdjuster::AddCustomRule(string condition, double multiplier, string description)
{
    if(m_ruleCount < 20)
    {
        m_rules[m_ruleCount].condition = condition;
        m_rules[m_ruleCount].multiplier = multiplier;
        m_rules[m_ruleCount].description = description;
        m_rules[m_ruleCount].isActive = true;
        m_rules[m_ruleCount].priority = m_ruleCount + 1;
        
        m_ruleCount++;
    }
}

//+------------------------------------------------------------------+
//| Log risk event                                                |
//+------------------------------------------------------------------+
void CRiskAdjuster::LogRiskEvent(string eventType, double riskBefore, double riskAfter, string reason)
{
    if(m_eventCount < 50)
    {
        m_riskEvents[m_eventCount].timestamp = TimeCurrent();
        m_riskEvents[m_eventCount].eventType = eventType;
        m_riskEvents[m_eventCount].riskBefore = riskBefore;
        m_riskEvents[m_eventCount].riskAfter = riskAfter;
        m_riskEvents[m_eventCount].reason = reason;
        m_riskEvents[m_eventCount].impact = MathAbs(riskAfter - riskBefore);
        
        m_eventCount++;
        
        Print("📝 Risk event logged: ", eventType, " - Risk: ", DoubleToString(riskBefore, 2), 
              "% → ", DoubleToString(riskAfter, 2), "% (", reason, ")");
    }
}

//+------------------------------------------------------------------+
//| Validate risk parameters                                       |
//+------------------------------------------------------------------+
bool CRiskAdjuster::ValidateRiskParameters()
{
    if(m_riskParams.minRiskPercent >= m_riskParams.maxRiskPercent)
    {
        Print("❌ Invalid risk limits: min >= max");
        return false;
    }
    
    if(m_riskParams.baseRiskPercent < m_riskParams.minRiskPercent ||
       m_riskParams.baseRiskPercent > m_riskParams.maxRiskPercent)
    {
        Print("❌ Base risk outside limits");
        return false;
    }
    
    if(m_riskParams.maxRiskPercent > 20.0)
    {
        Print("⚠️ Warning: Maximum risk is very high (", m_riskParams.maxRiskPercent, "%)");
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Get risk status                                               |
//+------------------------------------------------------------------+
string CRiskAdjuster::GetRiskStatus()
{
    string status = "Risk Status: ";
    
    if(m_performance.currentDrawdown > 10.0)
        status += "HIGH RISK - Large drawdown";
    else if(m_marketConditions.isHighVolatility)
        status += "ELEVATED RISK - High volatility";
    else if(m_performance.consecutiveLosses >= 3)
        status += "CAUTION - Loss streak detected";
    else if(m_riskParams.currentRiskPercent < m_riskParams.baseRiskPercent * 0.8)
        status += "DEFENSIVE - Risk reduced";
    else if(m_riskParams.currentRiskPercent > m_riskParams.baseRiskPercent * 1.1)
        status += "AGGRESSIVE - Risk increased";
    else
        status += "NORMAL - Standard risk level";
    
    return status;
}

//+------------------------------------------------------------------+
//| Print risk summary                                            |
//+------------------------------------------------------------------+
void CRiskAdjuster::PrintRiskSummary()
{
    Print("═══════════════════════════════════════");
    Print("⚖️ RISK ADJUSTMENT SUMMARY");
    Print("═══════════════════════════════════════");
    Print("🎯 Current Risk: ", DoubleToString(m_riskParams.currentRiskPercent, 2), "%");
    Print("📊 Base Risk: ", DoubleToString(m_riskParams.baseRiskPercent, 2), "%");
    Print("📈 Max Risk: ", DoubleToString(m_riskParams.maxRiskPercent, 2), "%");
    Print("📉 Min Risk: ", DoubleToString(m_riskParams.minRiskPercent, 2), "%");
    Print("🌪️ Volatility Ratio: ", DoubleToString(m_marketConditions.volatilityRatio, 2));
    Print("🏢 Market Regime: ", m_marketConditions.marketRegime);
    Print("📉 Current Drawdown: ", DoubleToString(m_performance.currentDrawdown, 2), "%");
    Print("🎯 Win Rate: ", DoubleToString(m_performance.winRate, 1), "%");
    Print("📊 Consecutive Losses: ", m_performance.consecutiveLosses);
    Print("⚠️ Status: ", GetRiskStatus());
    Print("═══════════════════════════════════════");
}