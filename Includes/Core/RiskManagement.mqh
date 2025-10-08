//+------------------------------------------------------------------+
//|                                               RiskManagement.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Risk management enumerations                                    |
//+------------------------------------------------------------------+
enum ENUM_RISK_LEVEL
{
    RISK_LEVEL_VERY_LOW,    // Conservative risk
    RISK_LEVEL_LOW,         // Low risk
    RISK_LEVEL_MODERATE,    // Moderate risk
    RISK_LEVEL_HIGH,        // High risk
    RISK_LEVEL_VERY_HIGH    // Aggressive risk
};

enum ENUM_POSITION_SIZING
{
    SIZING_FIXED_LOT,       // Fixed lot size
    SIZING_RISK_BASED,      // Risk percentage based
    SIZING_KELLY,           // Kelly criterion
    SIZING_OPTIMAL_F,       // Optimal F
    SIZING_VOLATILITY_ADJ,  // Volatility adjusted
    SIZING_ML_OPTIMIZED     // ML-optimized sizing
};

enum ENUM_DRAWDOWN_ACTION
{
    DD_ACTION_NONE,         // No action
    DD_ACTION_REDUCE_RISK,  // Reduce position sizes
    DD_ACTION_PAUSE_TRADING,// Pause new trades
    DD_ACTION_CLOSE_ALL,    // Close all positions
    DD_ACTION_EMERGENCY     // Emergency shutdown
};

//+------------------------------------------------------------------+
//| Risk management structures                                       |
//+------------------------------------------------------------------+
struct SRiskConfig
{
    double            baseRiskPercent;
    double            maxRiskPercent;
    int               maxOpenTrades;
    double            correlationThreshold;
    double            maxDrawdownPercent;
    double            dailyLossLimit;
    ENUM_POSITION_SIZING sizingMethod;
    bool              dynamicSizing;
    bool              correlationControl;
    bool              volatilityAdjustment;
};

struct SRiskMetrics
{
    double            currentDrawdown;
    double            maxDrawdown;
    double            dailyPnL;
    double            weeklyPnL;
    double            monthlyPnL;
    double            sharpeRatio;
    double            sortinioRatio;
    double            maxConsecutiveLosses;
    double            currentRiskExposure;
    datetime          lastUpdate;
};

struct SCorrelationData
{
    string            symbol1;
    string            symbol2;
    double            correlation;
    datetime          lastCalculated;
};

//+------------------------------------------------------------------+
//| Advanced Risk management class                                  |
//| Handles dynamic position sizing, correlation, and risk control  |
//+------------------------------------------------------------------+
class CRiskManagement
{
private:
    // Core risk settings
    SRiskConfig       m_config;
    SRiskMetrics      m_metrics;
    
    // Correlation management
    SCorrelationData  m_correlations[];
    datetime          m_lastCorrelationUpdate;
    
    // Drawdown management
    double            m_peakEquity;
    double            m_currentEquity;
    ENUM_DRAWDOWN_ACTION m_drawdownAction;
    
    // Dynamic risk adjustment
    double            m_riskMultiplier;
    double            m_volatilityFactor;
    bool              m_emergencyMode;
    
    // Performance tracking
    double            m_winningTrades[];
    double            m_losingTrades[];
    double            m_tradePnL[];
    datetime          m_tradeHistory[];
    
    // Portfolio analysis
    string            m_activeSymbols[];
    double            m_symbolExposures[];
    double            m_symbolVolatilities[];
    
public:
    //--- Constructor/Destructor
    CRiskManagement();
    ~CRiskManagement();
    
    //--- Initialization and configuration
    bool Initialize(double riskPercent, int maxTrades, double correlationThreshold);
    bool Initialize(const SRiskConfig &config);
    void SetConfiguration(const SRiskConfig &config);
    SRiskConfig GetConfiguration() const { return m_config; }
    
    //--- Advanced position sizing methods
    double CalculatePositionSize(const string symbol, double stopLossDistance, double confidence = 1.0);
    double CalculateKellySize(const string symbol, double winRate, double avgWin, double avgLoss);
    double CalculateOptimalF(const string symbol);
    double CalculateVolatilityAdjustedSize(const string symbol, double baseSize);
    double CalculateDynamicRiskSize(const string symbol, double stopLossDistance);
    
    //--- Risk validation and control
    bool IsRiskAcceptable(const string symbol, double positionSize, double confidence = 1.0);
    bool CanOpenNewTrade(const string symbol = "");
    bool ValidateTradeRisk(const string symbol, double volume, double stopLoss, double takeProfit);
    ENUM_RISK_LEVEL GetCurrentRiskLevel();
    
    //--- Portfolio and correlation management
    double GetPortfolioRisk();
    double GetSymbolExposure(const string symbol);
    double GetCorrelation(const string symbol1, const string symbol2);
    bool IsOverexposed(const string symbol);
    bool CheckCorrelationLimits(const string symbol);
    void UpdateCorrelations();
    
    //--- Drawdown and loss management
    void UpdateDrawdownMetrics();
    bool CheckDrawdownLimits();
    void HandleDrawdownEvent(double currentDD);
    bool CheckDailyLossLimits();
    ENUM_DRAWDOWN_ACTION GetDrawdownAction() const { return m_drawdownAction; }
    
    //--- Dynamic risk adjustment
    void UpdateRiskMultiplier();
    void AdjustRiskBasedOnPerformance();
    void SetEmergencyMode(bool enabled);
    bool IsEmergencyMode() const { return m_emergencyMode; }
    
    //--- Performance analytics
    void RecordTrade(double pnl, const string symbol);
    double CalculateSharpeRatio();
    double CalculateSortinoRatio();
    double GetWinRate();
    double GetProfitFactor();
    SRiskMetrics GetRiskMetrics() const { return m_metrics; }
    
    //--- Portfolio analysis
    void AnalyzePortfolio();
    double GetPortfolioHeatIndex();
    double GetDiversificationRatio();
    bool IsPortfolioBalanced();
    
    //--- Setters for backward compatibility
    void SetAccountRiskPercent(double riskPercent) { m_config.baseRiskPercent = riskPercent; }
    void SetMaxOpenTrades(int maxTrades) { m_config.maxOpenTrades = maxTrades; }
    void SetCorrelationThreshold(double threshold) { m_config.correlationThreshold = threshold; }
    
    //--- Getters for backward compatibility
    double GetAccountRiskPercent() const { return m_config.baseRiskPercent; }
    int GetMaxOpenTrades() const { return m_config.maxOpenTrades; }
    double GetCorrelationThreshold() const { return m_config.correlationThreshold; }
    
    //--- Advanced getters
    double GetMaxDrawdownPercent() const { return m_config.maxDrawdownPercent; }
    double GetCurrentDrawdown() const { return m_metrics.currentDrawdown; }
    double GetRiskMultiplier() const { return m_riskMultiplier; }
    double GetVolatilityFactor() const { return m_volatilityFactor; }
    
private:
    //--- Internal calculation methods
    double GetAccountBalance();
    double GetAccountEquity();
    double CalculateRiskAmount(double riskPercent = 0);
    int GetCurrentOpenTrades();
    double GetSymbolVolume(const string symbol);
    double GetSymbolVolatility(const string symbol, int periods = 20);
    
    //--- Correlation calculations
    double CalculateCorrelation(const string symbol1, const string symbol2, int periods = 50);
    void UpdateSymbolCorrelations();
    int FindCorrelationIndex(const string symbol1, const string symbol2);
    
    //--- Portfolio analysis helpers
    void UpdateActiveSymbols();
    void CalculateSymbolExposures();
    void CalculateSymbolVolatilities();
    
    //--- Risk metrics calculations
    void UpdatePerformanceMetrics();
    double CalculateMaxConsecutiveLosses();
    double CalculateCurrentRiskExposure();
    
    //--- Validation and safety
    bool ValidatePositionSize(const string symbol, double size);
    bool CheckMarginRequirements(const string symbol, double volume);
    bool CheckLiquidityRequirements(const string symbol);
    
    //--- Array management
    void AddTradeToHistory(double pnl, const string symbol);
    void ResizeHistoryArrays(int newSize);
    void CleanupOldHistory();
    
    //--- Logging and diagnostics
    void LogRiskDecision(const string symbol, const string decision, const string reason);
    void LogRiskMetrics();
    void LogCorrelationMatrix();
};
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CRiskManagement::CRiskManagement()
{
    m_accountRiskPercent = 1.0;
    m_maxOpenTrades = 10;
    m_correlationThreshold = 0.8;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CRiskManagement::~CRiskManagement()
{
}

//+------------------------------------------------------------------+
//| Initialize risk management                                       |
//+------------------------------------------------------------------+
bool CRiskManagement::Initialize(double riskPercent, int maxTrades, double correlationThreshold)
{
    m_accountRiskPercent = riskPercent;
    m_maxOpenTrades = maxTrades;
    m_correlationThreshold = correlationThreshold;
    
    CConfig::LogInfo(StringFormat("Risk Management initialized - Risk: %.1f%%, Max Trades: %d, Correlation: %.2f", 
                     riskPercent, maxTrades, correlationThreshold));
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate position size based on risk                           |
//+------------------------------------------------------------------+
double CRiskManagement::CalculatePositionSize(string symbol, double stopLossDistance)
{
    if(stopLossDistance <= 0)
        return 0;
    
    double riskAmount = CalculateRiskAmount();
    double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
    double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    if(tickValue <= 0 || tickSize <= 0 || point <= 0)
        return 0;
    
    // Calculate position size
    double positionSize = (riskAmount * tickSize) / (stopLossDistance * tickValue);
    
    // Apply lot size constraints
    double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    
    // Normalize lot size
    positionSize = MathMax(positionSize, minLot);
    positionSize = MathMin(positionSize, maxLot);
    positionSize = NormalizeDouble(positionSize / lotStep, 0) * lotStep;
    
    return positionSize;
}

//+------------------------------------------------------------------+
//| Calculate risk amount in account currency                       |
//+------------------------------------------------------------------+
double CRiskManagement::CalculateRiskAmount()
{
    double accountBalance = GetAccountBalance();
    return accountBalance * (m_accountRiskPercent / 100.0);
}

//+------------------------------------------------------------------+
//| Check if risk is acceptable                                      |
//+------------------------------------------------------------------+
bool CRiskManagement::IsRiskAcceptable(string symbol, double positionSize)
{
    // Check if we can open new trade
    if(!CanOpenNewTrade())
        return false;
    
    // Check symbol exposure
    if(IsOverexposed(symbol))
        return false;
    
    // Check overall portfolio risk
    double portfolioRisk = GetPortfolioRisk();
    if(portfolioRisk > m_accountRiskPercent * 3) // Max 3x base risk
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if we can open new trade                                  |
//+------------------------------------------------------------------+
bool CRiskManagement::CanOpenNewTrade()
{
    return GetCurrentOpenTrades() < m_maxOpenTrades;
}

//+------------------------------------------------------------------+
//| Get current portfolio risk                                       |
//+------------------------------------------------------------------+
double CRiskManagement::GetPortfolioRisk()
{
    double totalRisk = 0;
    double accountBalance = GetAccountBalance();
    
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionSelectByIndex(i))
        {
            double positionProfit = PositionGetDouble(POSITION_PROFIT);
            double positionVolume = PositionGetDouble(POSITION_VOLUME);
            
            // Calculate potential loss if stopped out
            totalRisk += MathAbs(positionProfit) / accountBalance * 100;
        }
    }
    
    return totalRisk;
}

//+------------------------------------------------------------------+
//| Get symbol exposure                                              |
//+------------------------------------------------------------------+
double CRiskManagement::GetSymbolExposure(string symbol)
{
    double totalVolume = 0;
    
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionSelectByIndex(i))
        {
            if(PositionGetString(POSITION_SYMBOL) == symbol)
            {
                totalVolume += PositionGetDouble(POSITION_VOLUME);
            }
        }
    }
    
    return totalVolume;
}

//+------------------------------------------------------------------+
//| Check if symbol is overexposed                                  |
//+------------------------------------------------------------------+
bool CRiskManagement::IsOverexposed(string symbol)
{
    double exposure = GetSymbolExposure(symbol);
    double maxExposure = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX) * 0.3; // Max 30% of max lot
    
    return exposure >= maxExposure;
}

//+------------------------------------------------------------------+
//| Get account balance                                              |
//+------------------------------------------------------------------+
double CRiskManagement::GetAccountBalance()
{
    return AccountInfoDouble(ACCOUNT_BALANCE);
}

//+------------------------------------------------------------------+
//| Get account equity                                               |
//+------------------------------------------------------------------+
double CRiskManagement::GetAccountEquity()
{
    return AccountInfoDouble(ACCOUNT_EQUITY);
}

//+------------------------------------------------------------------+
//| Get current open trades count                                   |
//+------------------------------------------------------------------+
int CRiskManagement::GetCurrentOpenTrades()
{
    return PositionsTotal();
}

//+------------------------------------------------------------------+
//| Get symbol volume                                               |
//+------------------------------------------------------------------+
double CRiskManagement::GetSymbolVolume(string symbol)
{
    return GetSymbolExposure(symbol);
}