//+------------------------------------------------------------------+
//|                                               RiskManagement.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Risk management class                                            |
//| Handles position sizing and risk calculations                    |
//+------------------------------------------------------------------+
class CRiskManagement
{
private:
    double            m_accountRiskPercent;
    int               m_maxOpenTrades;
    double            m_correlationThreshold;
    
public:
    //--- Constructor/Destructor
    CRiskManagement();
    ~CRiskManagement();
    
    //--- Initialization
    bool Initialize(double riskPercent, int maxTrades, double correlationThreshold);
    
    //--- Risk calculation methods
    double CalculatePositionSize(string symbol, double stopLossDistance);
    double CalculateRiskAmount();
    bool IsRiskAcceptable(string symbol, double positionSize);
    bool CanOpenNewTrade();
    
    //--- Portfolio risk methods
    double GetPortfolioRisk();
    double GetSymbolExposure(string symbol);
    bool IsOverexposed(string symbol);
    
    //--- Getters/Setters
    void SetAccountRiskPercent(double riskPercent) { m_accountRiskPercent = riskPercent; }
    void SetMaxOpenTrades(int maxTrades) { m_maxOpenTrades = maxTrades; }
    void SetCorrelationThreshold(double threshold) { m_correlationThreshold = threshold; }
    
    double GetAccountRiskPercent() { return m_accountRiskPercent; }
    int GetMaxOpenTrades() { return m_maxOpenTrades; }
    double GetCorrelationThreshold() { return m_correlationThreshold; }
    
private:
    //--- Helper methods
    double GetAccountBalance();
    double GetAccountEquity();
    int GetCurrentOpenTrades();
    double GetSymbolVolume(string symbol);
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