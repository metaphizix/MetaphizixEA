//+------------------------------------------------------------------+
//|                                                 ExitStrategy.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Enumerations for exit strategy                                  |
//+------------------------------------------------------------------+
enum ENUM_EXIT_TYPE
{
    EXIT_TYPE_BREAK_EVEN,     // Move to break-even
    EXIT_TYPE_TRAILING_STOP,  // Trailing stop loss
    EXIT_TYPE_PARTIAL_EXIT,   // Partial position closure
    EXIT_TYPE_FULL_EXIT,      // Full position closure
    EXIT_TYPE_TIME_EXIT,      // Time-based exit
    EXIT_TYPE_OPPOSITE_SIGNAL,// Exit on opposite signal
    EXIT_TYPE_VOLATILITY,     // Volatility-based exit
    EXIT_TYPE_PROFIT_TARGET   // Fixed profit target reached
};

enum ENUM_EXIT_CONDITION
{
    EXIT_CONDITION_PROFIT,    // Profit-based conditions
    EXIT_CONDITION_LOSS,      // Loss-based conditions
    EXIT_CONDITION_TIME,      // Time-based conditions
    EXIT_CONDITION_TECHNICAL, // Technical analysis conditions
    EXIT_CONDITION_NEWS,      // News/fundamental conditions
    EXIT_CONDITION_VOLATILITY // Volatility conditions
};

//+------------------------------------------------------------------+
//| Exit strategy configuration structure                           |
//+------------------------------------------------------------------+
struct SExitConfig
{
    // Trailing stop settings
    double            atrMultiplier;
    bool              trailingStopEnabled;
    double            minTrailDistance;
    double            trailStepSize;
    
    // Break-even settings
    double            breakEvenBuffer;
    bool              breakEvenEnabled;
    double            breakEvenTriggerRR;
    
    // Partial exit settings
    double            partialExitRR;
    bool              partialExitEnabled;
    double            partialExitPercent;
    int               maxPartialExits;
    
    // Time-based exit settings
    bool              timeExitEnabled;
    int               maxHoldingPeriod;
    int               sessionExitHour;
    
    // Volatility-based exit
    bool              volatilityExitEnabled;
    double            maxVolatilityThreshold;
    double            minVolatilityThreshold;
    
    // Signal-based exit
    bool              oppositeSignalExit;
    bool              weakSignalExit;
    double            signalStrengthThreshold;
};

//+------------------------------------------------------------------+
//| Exit strategy class                                              |
//| Advanced modular exit management with multiple exit conditions  |
//+------------------------------------------------------------------+
class CExitStrategy
{
private:
    // Configuration
    SExitConfig       m_config;
    
    // State tracking
    double            m_originalVolumes[];
    ulong             m_trackedTickets[];
    int               m_partialExitCount[];
    datetime          m_entryTimes[];
    double            m_highestProfit[];
    double            m_lowestProfit[];
    
    // Performance tracking
    int               m_totalExits;
    int               m_profitableExits;
    double            m_totalExitProfit;
    
    // Risk management integration
    bool              m_emergencyExitMode;
    double            m_maxDrawdownThreshold;
    
public:
    //--- Constructor/Destructor
    CExitStrategy();
    ~CExitStrategy();
    
    //--- Initialization and configuration
    bool Initialize(const SExitConfig &config);
    bool Initialize(double atrMultiplier = 1.5, double breakEvenBuffer = 10, double partialExitRR = 2.0);
    void SetConfiguration(const SExitConfig &config);
    SExitConfig GetConfiguration() const { return m_config; }
    
    //--- Main exit processing methods
    void ProcessAllExits();
    void ProcessPositionExits(ulong ticket);
    void ProcessEmergencyExits();
    
    //--- Individual exit strategies
    bool ApplyTrailingStop(ulong ticket, double atrValue = 0);
    bool ApplyBreakEven(ulong ticket);
    bool ApplyPartialExit(ulong ticket, double riskReward = 0);
    bool ApplyTimeBasedExit(ulong ticket);
    bool ApplyVolatilityExit(ulong ticket, double currentVolatility);
    bool ApplyOppositeSignalExit(ulong ticket, ENUM_SIGNAL_TYPE oppositeSignal);
    bool ApplyFullExit(ulong ticket, ENUM_EXIT_TYPE reason);
    
    //--- Exit condition evaluators
    bool ShouldMoveToBreakEven(ulong ticket);
    bool ShouldPartialExit(ulong ticket, double riskReward = 0);
    bool ShouldTrailStop(ulong ticket, double atrValue = 0);
    bool ShouldTimeExit(ulong ticket);
    bool ShouldVolatilityExit(ulong ticket, double currentVolatility);
    bool ShouldEmergencyExit(ulong ticket);
    
    //--- Advanced exit logic
    bool EvaluateMultiFactorExit(ulong ticket, double &exitScore);
    bool CheckCorrelationBasedExit(ulong ticket, const string &correlatedSymbols[]);
    bool CheckNewsBasedExit(ulong ticket, int newsImpact);
    bool CheckSessionBasedExit(ulong ticket);
    
    //--- Calculation methods
    double CalculateTrailingStopLevel(ulong ticket, double atrValue = 0);
    double CalculateBreakEvenLevel(ulong ticket);
    double CalculatePartialExitPrice(ulong ticket);
    double CalculatePartialExitVolume(ulong ticket);
    double CalculateOptimalExitPrice(ulong ticket, ENUM_EXIT_TYPE exitType);
    double CalculateExitPriority(ulong ticket);
    
    //--- Position tracking and management
    bool RegisterPosition(ulong ticket, double originalVolume);
    bool UnregisterPosition(ulong ticket);
    bool IsPositionTracked(ulong ticket);
    void UpdatePositionMetrics(ulong ticket);
    
    //--- Risk and performance management
    void SetEmergencyExitMode(bool enabled) { m_emergencyExitMode = enabled; }
    bool IsEmergencyExitMode() const { return m_emergencyExitMode; }
    void SetMaxDrawdownThreshold(double threshold) { m_maxDrawdownThreshold = threshold; }
    
    //--- Performance analytics
    double GetExitSuccessRate() const;
    double GetAverageExitProfit() const;
    int GetTotalExits() const { return m_totalExits; }
    void ResetPerformanceMetrics();
    
    //--- Utility and execution methods
    bool ModifyStopLoss(ulong ticket, double newStopLoss);
    bool ModifyTakeProfit(ulong ticket, double newTakeProfit);
    bool ClosePartialPosition(ulong ticket, double volume);
    bool CloseFullPosition(ulong ticket, const string reason = "");
    
    //--- Advanced utility methods
    double GetCurrentProfit(ulong ticket);
    double GetCurrentRiskReward(ulong ticket);
    double GetUnrealizedPnL(ulong ticket);
    double GetPositionDuration(ulong ticket);
    double GetPositionHighestProfit(ulong ticket);
    double GetPositionLowestProfit(ulong ticket);
    
    //--- Configuration getters/setters
    void SetATRMultiplier(double multiplier) { m_config.atrMultiplier = multiplier; }
    void SetBreakEvenBuffer(double buffer) { m_config.breakEvenBuffer = buffer; }
    void SetPartialExitRR(double rr) { m_config.partialExitRR = rr; }
    void SetTrailingStopEnabled(bool enabled) { m_config.trailingStopEnabled = enabled; }
    void SetBreakEvenEnabled(bool enabled) { m_config.breakEvenEnabled = enabled; }
    void SetPartialExitEnabled(bool enabled) { m_config.partialExitEnabled = enabled; }
    
    double GetATRMultiplier() const { return m_config.atrMultiplier; }
    double GetBreakEvenBuffer() const { return m_config.breakEvenBuffer; }
    double GetPartialExitRR() const { return m_config.partialExitRR; }
    bool IsTrailingStopEnabled() const { return m_config.trailingStopEnabled; }
    bool IsBreakEvenEnabled() const { return m_config.breakEvenEnabled; }
    bool IsPartialExitEnabled() const { return m_config.partialExitEnabled; }
    
private:
    //--- Internal helper methods
    bool IsLongPosition(ulong ticket);
    bool IsShortPosition(ulong ticket);
    double GetPositionOpenPrice(ulong ticket);
    double GetPositionStopLoss(ulong ticket);
    double GetPositionTakeProfit(ulong ticket);
    double GetPositionVolume(ulong ticket);
    string GetPositionSymbol(ulong ticket);
    datetime GetPositionOpenTime(ulong ticket);
    
    //--- Advanced calculation helpers
    double CalculateATR(const string symbol, int period = 14, ENUM_TIMEFRAMES timeframe = PERIOD_H1);
    double CalculateVolatility(const string symbol, int period = 20, ENUM_TIMEFRAMES timeframe = PERIOD_H1);
    double NormalizeStopLevel(const string symbol, double price);
    double GetMinStopLevel(const string symbol);
    
    //--- Array management helpers
    int FindTicketIndex(ulong ticket);
    bool AddTicketToArrays(ulong ticket, double originalVolume);
    bool RemoveTicketFromArrays(ulong ticket);
    void ResizeArrays(int newSize);
    
    //--- Validation and safety
    bool ValidateExitRequest(ulong ticket, ENUM_EXIT_TYPE exitType);
    bool CheckMarketConditions(const string symbol);
    bool IsWithinTradingHours(const string symbol);
    
    //--- Logging and analytics
    void LogExitDecision(ulong ticket, ENUM_EXIT_TYPE exitType, const string reason);
    void LogPerformanceMetrics();
    void UpdateExitStatistics(ulong ticket, double exitProfit, ENUM_EXIT_TYPE exitType);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExitStrategy::CExitStrategy()
{
    // Initialize default configuration
    m_config.atrMultiplier = 1.5;
    m_config.trailingStopEnabled = true;
    m_config.minTrailDistance = 10.0;
    m_config.trailStepSize = 5.0;
    
    m_config.breakEvenBuffer = 10.0;
    m_config.breakEvenEnabled = true;
    m_config.breakEvenTriggerRR = 1.0;
    
    m_config.partialExitRR = 2.0;
    m_config.partialExitEnabled = true;
    m_config.partialExitPercent = 50.0;
    m_config.maxPartialExits = 2;
    
    m_config.timeExitEnabled = false;
    m_config.maxHoldingPeriod = 24 * 3600; // 24 hours in seconds
    m_config.sessionExitHour = 23;
    
    m_config.volatilityExitEnabled = false;
    m_config.maxVolatilityThreshold = 200.0;
    m_config.minVolatilityThreshold = 10.0;
    
    m_config.oppositeSignalExit = true;
    m_config.weakSignalExit = true;
    m_config.signalStrengthThreshold = 0.6;
    
    // Initialize state variables
    ArrayResize(m_trackedTickets, 0);
    ArrayResize(m_originalVolumes, 0);
    ArrayResize(m_partialExitCount, 0);
    ArrayResize(m_entryTimes, 0);
    ArrayResize(m_highestProfit, 0);
    ArrayResize(m_lowestProfit, 0);
    
    // Initialize performance tracking
    m_totalExits = 0;
    m_profitableExits = 0;
    m_totalExitProfit = 0.0;
    
    // Initialize risk management
    m_emergencyExitMode = false;
    m_maxDrawdownThreshold = 10.0; // 10% max drawdown
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExitStrategy::~CExitStrategy()
{
    // Log final performance metrics
    if(m_totalExits > 0)
    {
        LogPerformanceMetrics();
    }
    
    // Clean up arrays
    ArrayFree(m_trackedTickets);
    ArrayFree(m_originalVolumes);
    ArrayFree(m_partialExitCount);
    ArrayFree(m_entryTimes);
    ArrayFree(m_highestProfit);
    ArrayFree(m_lowestProfit);
}

//+------------------------------------------------------------------+
//| Initialize exit strategy with configuration structure           |
//+------------------------------------------------------------------+
bool CExitStrategy::Initialize(const SExitConfig &config)
{
    m_config = config;
    
    CConfig::LogInfo(StringFormat("Exit Strategy initialized with advanced configuration - ATR Multiplier: %.1f, Break-even buffer: %.1f, Partial exit R:R: %.1f", 
                     m_config.atrMultiplier, m_config.breakEvenBuffer, m_config.partialExitRR));
    
    return true;
}

//+------------------------------------------------------------------+
//| Initialize exit strategy with basic parameters (backward compatibility) |
//+------------------------------------------------------------------+
bool CExitStrategy::Initialize(double atrMultiplier = 1.5, double breakEvenBuffer = 10, double partialExitRR = 2.0)
{
    m_config.atrMultiplier = atrMultiplier;
    m_config.breakEvenBuffer = breakEvenBuffer;
    m_config.partialExitRR = partialExitRR;
    
    CConfig::LogInfo(StringFormat("Exit Strategy initialized - ATR Multiplier: %.1f, Break-even buffer: %.1f, Partial exit R:R: %.1f", 
                     atrMultiplier, breakEvenBuffer, partialExitRR));
    
    return true;
}

//+------------------------------------------------------------------+
//| Set configuration                                               |
//+------------------------------------------------------------------+
void CExitStrategy::SetConfiguration(const SExitConfig &config)
{
    m_config = config;
    CConfig::LogInfo("Exit Strategy configuration updated");
}

//+------------------------------------------------------------------+
//| Register a new position for tracking                            |
//+------------------------------------------------------------------+
bool CExitStrategy::RegisterPosition(ulong ticket, double originalVolume)
{
    if(IsPositionTracked(ticket))
    {
        CConfig::LogDebug(StringFormat("Position %d already tracked", ticket));
        return true;
    }
    
    if(!AddTicketToArrays(ticket, originalVolume))
    {
        CConfig::LogError(StringFormat("Failed to register position %d", ticket));
        return false;
    }
    
    CConfig::LogDebug(StringFormat("Position %d registered for exit tracking", ticket));
    return true;
}

//+------------------------------------------------------------------+
//| Unregister a position from tracking                             |
//+------------------------------------------------------------------+
bool CExitStrategy::UnregisterPosition(ulong ticket)
{
    if(!IsPositionTracked(ticket))
    {
        return true; // Already unregistered
    }
    
    if(!RemoveTicketFromArrays(ticket))
    {
        CConfig::LogError(StringFormat("Failed to unregister position %d", ticket));
        return false;
    }
    
    CConfig::LogDebug(StringFormat("Position %d unregistered from exit tracking", ticket));
    return true;
}

//+------------------------------------------------------------------+
//| Check if position is being tracked                              |
//+------------------------------------------------------------------+
bool CExitStrategy::IsPositionTracked(ulong ticket)
{
    return FindTicketIndex(ticket) >= 0;
}

//+------------------------------------------------------------------+
//| Process all exits for all tracked positions                     |
//+------------------------------------------------------------------+
void CExitStrategy::ProcessAllExits()
{
    // Handle emergency exits first
    if(m_emergencyExitMode)
    {
        ProcessEmergencyExits();
        return;
    }
    
    // Process individual position exits
    for(int i = ArraySize(m_trackedTickets) - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(m_trackedTickets[i]))
        {
            UpdatePositionMetrics(m_trackedTickets[i]);
            ProcessPositionExits(m_trackedTickets[i]);
        }
        else
        {
            // Position no longer exists, remove from tracking
            RemoveTicketFromArrays(m_trackedTickets[i]);
        }
    }
}

//+------------------------------------------------------------------+
//| Process exits for a specific position                           |
//+------------------------------------------------------------------+
void CExitStrategy::ProcessPositionExits(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return;
    
    string symbol = GetPositionSymbol(ticket);
    
    // Calculate current metrics
    double atrValue = CalculateATR(symbol);
    double currentVolatility = CalculateVolatility(symbol);
    double riskReward = GetCurrentRiskReward(ticket);
    
    // Check for emergency exit conditions
    if(ShouldEmergencyExit(ticket))
    {
        ApplyFullExit(ticket, EXIT_TYPE_FULL_EXIT);
        LogExitDecision(ticket, EXIT_TYPE_FULL_EXIT, "Emergency exit triggered");
        return;
    }
    
    // Check time-based exit
    if(m_config.timeExitEnabled && ShouldTimeExit(ticket))
    {
        ApplyTimeBasedExit(ticket);
        return;
    }
    
    // Check volatility-based exit
    if(m_config.volatilityExitEnabled && ShouldVolatilityExit(ticket, currentVolatility))
    {
        ApplyVolatilityExit(ticket, currentVolatility);
        return;
    }
    
    // Apply trailing stop
    if(m_config.trailingStopEnabled)
    {
        ApplyTrailingStop(ticket, atrValue);
    }
    
    // Apply break-even
    if(m_config.breakEvenEnabled)
    {
        ApplyBreakEven(ticket);
    }
    
    // Apply partial exit
    if(m_config.partialExitEnabled)
    {
        ApplyPartialExit(ticket, riskReward);
    }
}

//+------------------------------------------------------------------+
//| Apply trailing stop                                             |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyTrailingStop(ulong ticket, double atrValue = 0)
{
    if(!m_config.trailingStopEnabled || !PositionSelectByTicket(ticket))
        return false;
    
    if(atrValue == 0)
    {
        string symbol = GetPositionSymbol(ticket);
        atrValue = CalculateATR(symbol);
    }
    
    if(ShouldTrailStop(ticket, atrValue))
    {
        double newStopLoss = CalculateTrailingStopLevel(ticket, atrValue);
        
        if(newStopLoss > 0 && ValidateExitRequest(ticket, EXIT_TYPE_TRAILING_STOP))
        {
            if(ModifyStopLoss(ticket, newStopLoss))
            {
                LogExitDecision(ticket, EXIT_TYPE_TRAILING_STOP, 
                               StringFormat("Trailing stop applied: %.5f (ATR: %.5f)", newStopLoss, atrValue));
                return true;
            }
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply break-even                                                |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyBreakEven(ulong ticket)
{
    if(!m_config.breakEvenEnabled || !PositionSelectByTicket(ticket))
        return false;
    
    if(ShouldMoveToBreakEven(ticket))
    {
        double breakEvenLevel = CalculateBreakEvenLevel(ticket);
        
        if(breakEvenLevel > 0 && ValidateExitRequest(ticket, EXIT_TYPE_BREAK_EVEN))
        {
            if(ModifyStopLoss(ticket, breakEvenLevel))
            {
                LogExitDecision(ticket, EXIT_TYPE_BREAK_EVEN, 
                               StringFormat("Break-even applied: %.5f", breakEvenLevel));
                return true;
            }
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply partial exit                                              |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyPartialExit(ulong ticket, double riskReward = 0)
{
    if(!m_config.partialExitEnabled || !PositionSelectByTicket(ticket))
        return false;
    
    if(riskReward == 0)
        riskReward = GetCurrentRiskReward(ticket);
    
    if(ShouldPartialExit(ticket, riskReward))
    {
        double partialVolume = CalculatePartialExitVolume(ticket);
        
        if(partialVolume > 0 && ValidateExitRequest(ticket, EXIT_TYPE_PARTIAL_EXIT))
        {
            if(ClosePartialPosition(ticket, partialVolume))
            {
                // Update partial exit count
                int index = FindTicketIndex(ticket);
                if(index >= 0)
                    m_partialExitCount[index]++;
                
                LogExitDecision(ticket, EXIT_TYPE_PARTIAL_EXIT, 
                               StringFormat("Partial exit: Volume %.2f at R:R %.2f", partialVolume, riskReward));
                return true;
            }
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply time-based exit                                           |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyTimeBasedExit(ulong ticket)
{
    if(!m_config.timeExitEnabled || !PositionSelectByTicket(ticket))
        return false;
    
    if(ShouldTimeExit(ticket))
    {
        if(ApplyFullExit(ticket, EXIT_TYPE_TIME_EXIT))
        {
            LogExitDecision(ticket, EXIT_TYPE_TIME_EXIT, "Time-based exit executed");
            return true;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply volatility-based exit                                     |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyVolatilityExit(ulong ticket, double currentVolatility)
{
    if(!m_config.volatilityExitEnabled || !PositionSelectByTicket(ticket))
        return false;
    
    if(ShouldVolatilityExit(ticket, currentVolatility))
    {
        if(ApplyFullExit(ticket, EXIT_TYPE_VOLATILITY))
        {
            LogExitDecision(ticket, EXIT_TYPE_VOLATILITY, 
                           StringFormat("Volatility exit: Current volatility %.2f", currentVolatility));
            return true;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply opposite signal exit                                      |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyOppositeSignalExit(ulong ticket, ENUM_SIGNAL_TYPE oppositeSignal)
{
    if(!m_config.oppositeSignalExit || !PositionSelectByTicket(ticket))
        return false;
    
    ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    
    bool shouldExit = false;
    if(posType == POSITION_TYPE_BUY && oppositeSignal == SIGNAL_SELL)
        shouldExit = true;
    else if(posType == POSITION_TYPE_SELL && oppositeSignal == SIGNAL_BUY)
        shouldExit = true;
    
    if(shouldExit)
    {
        if(ApplyFullExit(ticket, EXIT_TYPE_OPPOSITE_SIGNAL))
        {
            LogExitDecision(ticket, EXIT_TYPE_OPPOSITE_SIGNAL, "Opposite signal exit executed");
            return true;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Apply full exit                                                 |
//+------------------------------------------------------------------+
bool CExitStrategy::ApplyFullExit(ulong ticket, ENUM_EXIT_TYPE reason)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    if(ValidateExitRequest(ticket, reason))
    {
        string reasonStr = EnumToString(reason);
        if(CloseFullPosition(ticket, reasonStr))
        {
            // Update exit statistics
            double exitProfit = GetCurrentProfit(ticket);
            UpdateExitStatistics(ticket, exitProfit, reason);
            
            // Unregister from tracking
            UnregisterPosition(ticket);
            
            LogExitDecision(ticket, reason, "Full position closed");
            return true;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Process all exits for all positions                             |
//+------------------------------------------------------------------+
void CExitStrategy::ProcessAllExits()
{
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionSelectByIndex(i))
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            string symbol = PositionGetString(POSITION_SYMBOL);
            
            // Auto-register position if not already tracked
            if(!IsPositionTracked(ticket))
            {
                RegisterPosition(ticket, GetPositionVolume(ticket));
            }
            
            // Calculate ATR for trailing stop
            double atr = 0;
            for(int j = 1; j <= 14; j++)
            {
                double high = iHigh(symbol, PERIOD_H1, j);
                double low = iLow(symbol, PERIOD_H1, j);
                double prevClose = iClose(symbol, PERIOD_H1, j + 1);
                
                double tr = MathMax(high - low, MathMax(MathAbs(high - prevClose), MathAbs(low - prevClose)));
                atr += tr;
            }
            atr /= 14.0;
            
            // Process exits for this position
            ProcessPositionExits(ticket);
        }
    }
}

//+------------------------------------------------------------------+
//| Process emergency exits                                         |
//+------------------------------------------------------------------+
void CExitStrategy::ProcessEmergencyExits()
{
    CConfig::LogInfo("Emergency exit mode active - closing all positions");
    
    for(int i = ArraySize(m_trackedTickets) - 1; i >= 0; i--)
    {
        if(PositionSelectByTicket(m_trackedTickets[i]))
        {
            ApplyFullExit(m_trackedTickets[i], EXIT_TYPE_FULL_EXIT);
        }
    }
    
    // Also close any untracked positions
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionSelectByIndex(i))
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            CloseFullPosition(ticket, "Emergency exit");
        }
    }
}

//+------------------------------------------------------------------+
//| Evaluate multi-factor exit decision                             |
//+------------------------------------------------------------------+
bool CExitStrategy::EvaluateMultiFactorExit(ulong ticket, double &exitScore)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    exitScore = 0.0;
    double totalWeight = 0.0;
    
    string symbol = GetPositionSymbol(ticket);
    double currentProfit = GetCurrentProfit(ticket);
    double riskReward = GetCurrentRiskReward(ticket);
    double duration = GetPositionDuration(ticket);
    
    // Factor 1: Profit/Loss situation (weight: 30%)
    double profitWeight = 30.0;
    if(currentProfit > 0)
        exitScore += (riskReward >= m_config.partialExitRR ? 80.0 : 40.0) * profitWeight / 100.0;
    else
        exitScore += (MathAbs(currentProfit) > 100 ? 70.0 : 20.0) * profitWeight / 100.0;
    totalWeight += profitWeight;
    
    // Factor 2: Time-based (weight: 20%)
    double timeWeight = 20.0;
    if(duration > m_config.maxHoldingPeriod * 0.8)
        exitScore += 60.0 * timeWeight / 100.0;
    else if(duration > m_config.maxHoldingPeriod * 0.5)
        exitScore += 30.0 * timeWeight / 100.0;
    totalWeight += timeWeight;
    
    // Factor 3: Volatility (weight: 25%)
    double volatilityWeight = 25.0;
    double currentVol = CalculateVolatility(symbol);
    if(currentVol > m_config.maxVolatilityThreshold)
        exitScore += 80.0 * volatilityWeight / 100.0;
    else if(currentVol < m_config.minVolatilityThreshold)
        exitScore += 40.0 * volatilityWeight / 100.0;
    totalWeight += volatilityWeight;
    
    // Factor 4: Technical conditions (weight: 25%)
    double technicalWeight = 25.0;
    // Add technical analysis factors here
    exitScore += 30.0 * technicalWeight / 100.0; // Placeholder
    totalWeight += technicalWeight;
    
    // Normalize score
    exitScore = exitScore * 100.0 / totalWeight;
    
    return exitScore >= 60.0; // Exit if score >= 60%
}

//+------------------------------------------------------------------+
//| Check correlation-based exit                                    |
//+------------------------------------------------------------------+
bool CExitStrategy::CheckCorrelationBasedExit(ulong ticket, const string &correlatedSymbols[])
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    bool isLong = IsLongPosition(ticket);
    
    // Check if correlated pairs are moving against us
    int negativeCount = 0;
    int totalPairs = ArraySize(correlatedSymbols);
    
    for(int i = 0; i < totalPairs; i++)
    {
        if(correlatedSymbols[i] == symbol)
            continue;
            
        double current = SymbolInfoDouble(correlatedSymbols[i], SYMBOL_BID);
        double prev = iClose(correlatedSymbols[i], PERIOD_M15, 1);
        
        bool pairMovingUp = current > prev;
        
        // If we're long and correlated pair is moving down, or vice versa
        if((isLong && !pairMovingUp) || (!isLong && pairMovingUp))
            negativeCount++;
    }
    
    // Exit if more than 70% of correlated pairs are moving against us
    return (totalPairs > 0 && (double)negativeCount / totalPairs >= 0.7);
}

//+------------------------------------------------------------------+
//| Check news-based exit                                           |
//+------------------------------------------------------------------+
bool CExitStrategy::CheckNewsBasedExit(ulong ticket, int newsImpact)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    // Exit if high-impact news is imminent and we're in profit
    if(newsImpact >= 3 && GetCurrentProfit(ticket) > 0)
    {
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check session-based exit                                        |
//+------------------------------------------------------------------+
bool CExitStrategy::CheckSessionBasedExit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    MqlDateTime time;
    TimeToStruct(TimeCurrent(), time);
    
    // Exit at session close if enabled
    if(time.hour >= m_config.sessionExitHour)
    {
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should move to break-even                              |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldMoveToBreakEven(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double riskReward = GetCurrentRiskReward(ticket);
    if(riskReward < m_config.breakEvenTriggerRR)
        return false;
    
    double openPrice = GetPositionOpenPrice(ticket);
    double currentSL = GetPositionStopLoss(ticket);
    string symbol = GetPositionSymbol(ticket);
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    // Convert buffer from pips to price
    double bufferPoints = CConfig::PipsToPoints(symbol, m_config.breakEvenBuffer);
    
    if(IsLongPosition(ticket))
    {
        // For long positions, price should be above open + buffer
        if(currentPrice >= openPrice + bufferPoints)
        {
            // Only move to break-even if current SL is below break-even level
            return (currentSL < openPrice + (bufferPoints * 0.1)); // Small buffer above open
        }
    }
    else if(IsShortPosition(ticket))
    {
        // For short positions, price should be below open - buffer
        if(currentPrice <= openPrice - bufferPoints)
        {
            // Only move to break-even if current SL is above break-even level
            return (currentSL > openPrice - (bufferPoints * 0.1)); // Small buffer below open
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should partial exit                                    |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldPartialExit(ulong ticket, double riskReward = 0)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    if(riskReward == 0)
        riskReward = GetCurrentRiskReward(ticket);
    
    // Check if we've reached the R:R target
    if(riskReward < m_config.partialExitRR)
        return false;
    
    // Check if we haven't exceeded max partial exits
    int index = FindTicketIndex(ticket);
    if(index >= 0 && m_partialExitCount[index] >= m_config.maxPartialExits)
        return false;
    
    // Check minimum volume requirements
    double currentVolume = GetPositionVolume(ticket);
    double minVolume = SymbolInfoDouble(GetPositionSymbol(ticket), SYMBOL_VOLUME_MIN);
    double partialVolume = currentVolume * m_config.partialExitPercent / 100.0;
    
    return (partialVolume >= minVolume && (currentVolume - partialVolume) >= minVolume);
}

//+------------------------------------------------------------------+
//| Check if should trail stop                                      |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldTrailStop(ulong ticket, double atrValue = 0)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    if(atrValue == 0)
    {
        string symbol = GetPositionSymbol(ticket);
        atrValue = CalculateATR(symbol);
    }
    
    double newStopLoss = CalculateTrailingStopLevel(ticket, atrValue);
    double currentSL = GetPositionStopLoss(ticket);
    
    if(newStopLoss <= 0)
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    double minDistance = CConfig::PipsToPoints(symbol, m_config.minTrailDistance);
    
    if(IsLongPosition(ticket))
    {
        return (newStopLoss > currentSL && (newStopLoss - currentSL) >= minDistance);
    }
    else if(IsShortPosition(ticket))
    {
        return (newStopLoss < currentSL && (currentSL - newStopLoss) >= minDistance);
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should time exit                                       |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldTimeExit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double duration = GetPositionDuration(ticket);
    
    // Exit if holding period exceeded
    if(duration >= m_config.maxHoldingPeriod)
        return true;
    
    // Exit at session close
    if(CheckSessionBasedExit(ticket))
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should volatility exit                                 |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldVolatilityExit(ulong ticket, double currentVolatility)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    // Exit if volatility is too high (risk management)
    if(currentVolatility > m_config.maxVolatilityThreshold)
        return true;
    
    // Exit if volatility is too low (lack of momentum)
    if(currentVolatility < m_config.minVolatilityThreshold && GetCurrentProfit(ticket) > 0)
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should emergency exit                                  |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldEmergencyExit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double currentProfit = GetCurrentProfit(ticket);
    
    // Exit if individual position loss exceeds threshold
    if(currentProfit < -1000.0) // Configurable threshold
        return true;
    
    // Exit if account drawdown exceeds threshold
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double accountEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double drawdownPercent = ((accountBalance - accountEquity) / accountBalance) * 100.0;
    
    if(drawdownPercent > m_maxDrawdownThreshold)
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Calculate trailing stop level                                   |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateTrailingStopLevel(ulong ticket, double atrValue = 0)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    string symbol = GetPositionSymbol(ticket);
    
    if(atrValue == 0)
        atrValue = CalculateATR(symbol);
    
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double stopDistance = atrValue * m_config.atrMultiplier;
    
    // Apply minimum trail distance
    double minDistance = CConfig::PipsToPoints(symbol, m_config.minTrailDistance);
    stopDistance = MathMax(stopDistance, minDistance);
    
    if(IsLongPosition(ticket))
    {
        return NormalizeStopLevel(symbol, currentPrice - stopDistance);
    }
    else if(IsShortPosition(ticket))
    {
        return NormalizeStopLevel(symbol, currentPrice + stopDistance);
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate break-even level                                      |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateBreakEvenLevel(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double openPrice = GetPositionOpenPrice(ticket);
    string symbol = GetPositionSymbol(ticket);
    double bufferPoints = CConfig::PipsToPoints(symbol, m_config.breakEvenBuffer * 0.1); // Small buffer
    
    if(IsLongPosition(ticket))
    {
        return NormalizeStopLevel(symbol, openPrice + bufferPoints);
    }
    else if(IsShortPosition(ticket))
    {
        return NormalizeStopLevel(symbol, openPrice - bufferPoints);
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate partial exit price                                    |
//+------------------------------------------------------------------+
double CExitStrategy::CalculatePartialExitPrice(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    string symbol = GetPositionSymbol(ticket);
    
    if(IsLongPosition(ticket))
    {
        return SymbolInfoDouble(symbol, SYMBOL_BID);
    }
    else
    {
        return SymbolInfoDouble(symbol, SYMBOL_ASK);
    }
}

//+------------------------------------------------------------------+
//| Calculate partial exit volume                                   |
//+------------------------------------------------------------------+
double CExitStrategy::CalculatePartialExitVolume(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double totalVolume = GetPositionVolume(ticket);
    double partialVolume = totalVolume * (m_config.partialExitPercent / 100.0);
    
    string symbol = GetPositionSymbol(ticket);
    double minVolume = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double volumeStep = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    
    // Normalize to volume step
    partialVolume = MathFloor(partialVolume / volumeStep) * volumeStep;
    
    // Ensure minimum volume
    return MathMax(partialVolume, minVolume);
}

//+------------------------------------------------------------------+
//| Calculate optimal exit price based on exit type                 |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateOptimalExitPrice(ulong ticket, ENUM_EXIT_TYPE exitType)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    string symbol = GetPositionSymbol(ticket);
    double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
    bool isLong = IsLongPosition(ticket);
    
    switch(exitType)
    {
        case EXIT_TYPE_BREAK_EVEN:
            return GetPositionOpenPrice(ticket);
        
        case EXIT_TYPE_TRAILING_STOP:
            return isLong ? bid : ask;
        
        case EXIT_TYPE_PARTIAL_EXIT:
            return CalculatePartialExitPrice(ticket);
        
        case EXIT_TYPE_PROFIT_TARGET:
            return GetPositionTakeProfit(ticket);
        
        default:
            return isLong ? bid : ask;
    }
}

//+------------------------------------------------------------------+
//| Calculate exit priority score                                   |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateExitPriority(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double priority = 0.0;
    
    // Factor 1: Current profit/loss (higher loss = higher priority)
    double currentProfit = GetCurrentProfit(ticket);
    if(currentProfit < 0)
        priority += MathAbs(currentProfit) / 100.0; // Normalize
    
    // Factor 2: Position duration (older positions = higher priority)
    double duration = GetPositionDuration(ticket);
    priority += duration / 3600.0; // Convert to hours
    
    // Factor 3: Volatility (higher volatility = higher priority)
    string symbol = GetPositionSymbol(ticket);
    double volatility = CalculateVolatility(symbol);
    priority += volatility / 100.0;
    
    return priority;
}

//+------------------------------------------------------------------+
//| Update position metrics                                         |
//+------------------------------------------------------------------+
void CExitStrategy::UpdatePositionMetrics(ulong ticket)
{
    int index = FindTicketIndex(ticket);
    if(index < 0)
        return;
    
    double currentProfit = GetCurrentProfit(ticket);
    
    // Update highest profit
    if(currentProfit > m_highestProfit[index])
        m_highestProfit[index] = currentProfit;
    
    // Update lowest profit
    if(currentProfit < m_lowestProfit[index])
        m_lowestProfit[index] = currentProfit;
}

//+------------------------------------------------------------------+
//| Get exit success rate                                           |
//+------------------------------------------------------------------+
double CExitStrategy::GetExitSuccessRate() const
{
    if(m_totalExits == 0)
        return 0.0;
    
    return ((double)m_profitableExits / m_totalExits) * 100.0;
}

//+------------------------------------------------------------------+
//| Get average exit profit                                         |
//+------------------------------------------------------------------+
double CExitStrategy::GetAverageExitProfit() const
{
    if(m_totalExits == 0)
        return 0.0;
    
    return m_totalExitProfit / m_totalExits;
}

//+------------------------------------------------------------------+
//| Reset performance metrics                                       |
//+------------------------------------------------------------------+
void CExitStrategy::ResetPerformanceMetrics()
{
    m_totalExits = 0;
    m_profitableExits = 0;
    m_totalExitProfit = 0.0;
    
    CConfig::LogInfo("Exit strategy performance metrics reset");
}

//+------------------------------------------------------------------+
//| Modify stop loss                                                |
//+------------------------------------------------------------------+
bool CExitStrategy::ModifyStopLoss(ulong ticket, double newStopLoss)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    double normalizedSL = NormalizeStopLevel(symbol, newStopLoss);
    
    // Check minimum stop level
    double minStopLevel = GetMinStopLevel(symbol);
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    if(IsLongPosition(ticket))
    {
        if(normalizedSL > currentPrice - minStopLevel)
        {
            CConfig::LogDebug(StringFormat("Stop loss too close to market for ticket %d", ticket));
            return false;
        }
    }
    else
    {
        if(normalizedSL < currentPrice + minStopLevel)
        {
            CConfig::LogDebug(StringFormat("Stop loss too close to market for ticket %d", ticket));
            return false;
        }
    }
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.sl = normalizedSL;
    request.tp = GetPositionTakeProfit(ticket);
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to modify stop loss for ticket %d: Error %d", ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Modify take profit                                              |
//+------------------------------------------------------------------+
bool CExitStrategy::ModifyTakeProfit(ulong ticket, double newTakeProfit)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    double normalizedTP = NormalizeStopLevel(symbol, newTakeProfit);
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.sl = GetPositionStopLoss(ticket);
    request.tp = normalizedTP;
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to modify take profit for ticket %d: Error %d", ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Close partial position                                          |
//+------------------------------------------------------------------+
bool CExitStrategy::ClosePartialPosition(ulong ticket, double volume)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    double normalizedVolume = NormalizeDouble(volume, 2);
    
    // Validate volume
    double minVolume = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double maxVolume = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    double currentVolume = GetPositionVolume(ticket);
    
    if(normalizedVolume < minVolume || normalizedVolume > currentVolume || 
       (currentVolume - normalizedVolume) < minVolume)
    {
        CConfig::LogError(StringFormat("Invalid partial exit volume for ticket %d: %.2f", ticket, normalizedVolume));
        return false;
    }
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.volume = normalizedVolume;
    request.type = (IsLongPosition(ticket)) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = (IsLongPosition(ticket)) ? 
                    SymbolInfoDouble(symbol, SYMBOL_BID) : 
                    SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.comment = "Partial Exit - MetaphizixEA";
    request.magic = 12345; // Should match EA magic number
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to close partial position for ticket %d: Error %d", ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Close full position                                             |
//+------------------------------------------------------------------+
bool CExitStrategy::CloseFullPosition(ulong ticket, const string reason = "")
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    double volume = GetPositionVolume(ticket);
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.volume = volume;
    request.type = (IsLongPosition(ticket)) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = (IsLongPosition(ticket)) ? 
                    SymbolInfoDouble(symbol, SYMBOL_BID) : 
                    SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.comment = (reason != "") ? reason : "Full Exit - MetaphizixEA";
    request.magic = 12345; // Should match EA magic number
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to close full position for ticket %d: Error %d", ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Get current profit                                              |
//+------------------------------------------------------------------+
double CExitStrategy::GetCurrentProfit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
}

//+------------------------------------------------------------------+
//| Get unrealized PnL                                              |
//+------------------------------------------------------------------+
double CExitStrategy::GetUnrealizedPnL(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_PROFIT);
}

//+------------------------------------------------------------------+
//| Get position duration in seconds                                |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionDuration(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    datetime openTime = GetPositionOpenTime(ticket);
    return (double)(TimeCurrent() - openTime);
}

//+------------------------------------------------------------------+
//| Get position highest profit                                     |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionHighestProfit(ulong ticket)
{
    int index = FindTicketIndex(ticket);
    if(index >= 0)
        return m_highestProfit[index];
    
    return GetCurrentProfit(ticket); // Fallback
}

//+------------------------------------------------------------------+
//| Get position lowest profit                                      |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionLowestProfit(ulong ticket)
{
    int index = FindTicketIndex(ticket);
    if(index >= 0)
        return m_lowestProfit[index];
    
    return GetCurrentProfit(ticket); // Fallback
}

//+------------------------------------------------------------------+
//| Get current risk-reward ratio                                   |
//+------------------------------------------------------------------+
double CExitStrategy::GetCurrentRiskReward(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double openPrice = GetPositionOpenPrice(ticket);
    double currentSL = GetPositionStopLoss(ticket);
    string symbol = GetPositionSymbol(ticket);
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    if(currentSL == 0)
        return 0;
    
    double risk = MathAbs(openPrice - currentSL);
    double reward = MathAbs(currentPrice - openPrice);
    
    return (risk > 0) ? reward / risk : 0;
}

//+------------------------------------------------------------------+
//| Calculate ATR for a symbol                                      |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateATR(const string symbol, int period = 14, ENUM_TIMEFRAMES timeframe = PERIOD_H1)
{
    double atr = 0;
    
    for(int i = 1; i <= period; i++)
    {
        double high = iHigh(symbol, timeframe, i);
        double low = iLow(symbol, timeframe, i);
        double prevClose = iClose(symbol, timeframe, i + 1);
        
        double tr = MathMax(high - low, MathMax(MathAbs(high - prevClose), MathAbs(low - prevClose)));
        atr += tr;
    }
    
    return atr / period;
}

//+------------------------------------------------------------------+
//| Calculate volatility for a symbol                               |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateVolatility(const string symbol, int period = 20, ENUM_TIMEFRAMES timeframe = PERIOD_H1)
{
    double sum = 0;
    double sumSquared = 0;
    
    for(int i = 1; i <= period; i++)
    {
        double close = iClose(symbol, timeframe, i);
        double prevClose = iClose(symbol, timeframe, i + 1);
        
        if(prevClose > 0)
        {
            double logReturn = MathLog(close / prevClose);
            sum += logReturn;
            sumSquared += logReturn * logReturn;
        }
    }
    
    double mean = sum / period;
    double variance = (sumSquared / period) - (mean * mean);
    
    return MathSqrt(variance) * 10000; // Convert to pips
}

//+------------------------------------------------------------------+
//| Find ticket index in arrays                                     |
//+------------------------------------------------------------------+
int CExitStrategy::FindTicketIndex(ulong ticket)
{
    for(int i = 0; i < ArraySize(m_trackedTickets); i++)
    {
        if(m_trackedTickets[i] == ticket)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Add ticket to tracking arrays                                   |
//+------------------------------------------------------------------+
bool CExitStrategy::AddTicketToArrays(ulong ticket, double originalVolume)
{
    int size = ArraySize(m_trackedTickets);
    
    if(ArrayResize(m_trackedTickets, size + 1) <= 0 ||
       ArrayResize(m_originalVolumes, size + 1) <= 0 ||
       ArrayResize(m_partialExitCount, size + 1) <= 0 ||
       ArrayResize(m_entryTimes, size + 1) <= 0 ||
       ArrayResize(m_highestProfit, size + 1) <= 0 ||
       ArrayResize(m_lowestProfit, size + 1) <= 0)
    {
        return false;
    }
    
    m_trackedTickets[size] = ticket;
    m_originalVolumes[size] = originalVolume;
    m_partialExitCount[size] = 0;
    m_entryTimes[size] = GetPositionOpenTime(ticket);
    m_highestProfit[size] = 0;
    m_lowestProfit[size] = 0;
    
    return true;
}

//+------------------------------------------------------------------+
//| Remove ticket from tracking arrays                              |
//+------------------------------------------------------------------+
bool CExitStrategy::RemoveTicketFromArrays(ulong ticket)
{
    int index = FindTicketIndex(ticket);
    if(index < 0)
        return true; // Not found, consider success
    
    int size = ArraySize(m_trackedTickets);
    
    // Shift elements
    for(int i = index; i < size - 1; i++)
    {
        m_trackedTickets[i] = m_trackedTickets[i + 1];
        m_originalVolumes[i] = m_originalVolumes[i + 1];
        m_partialExitCount[i] = m_partialExitCount[i + 1];
        m_entryTimes[i] = m_entryTimes[i + 1];
        m_highestProfit[i] = m_highestProfit[i + 1];
        m_lowestProfit[i] = m_lowestProfit[i + 1];
    }
    
    // Resize arrays
    return (ArrayResize(m_trackedTickets, size - 1) >= 0 &&
            ArrayResize(m_originalVolumes, size - 1) >= 0 &&
            ArrayResize(m_partialExitCount, size - 1) >= 0 &&
            ArrayResize(m_entryTimes, size - 1) >= 0 &&
            ArrayResize(m_highestProfit, size - 1) >= 0 &&
            ArrayResize(m_lowestProfit, size - 1) >= 0);
}

//+------------------------------------------------------------------+
//| Validate exit request                                           |
//+------------------------------------------------------------------+
bool CExitStrategy::ValidateExitRequest(ulong ticket, ENUM_EXIT_TYPE exitType)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = GetPositionSymbol(ticket);
    
    // Check market conditions
    if(!CheckMarketConditions(symbol))
        return false;
    
    // Check trading hours
    if(!IsWithinTradingHours(symbol))
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check market conditions                                         |
//+------------------------------------------------------------------+
bool CExitStrategy::CheckMarketConditions(const string symbol)
{
    // Check if market is open
    if(!SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE))
        return false;
    
    // Check spread
    double spread = SymbolInfoInteger(symbol, SYMBOL_SPREAD) * SymbolInfoDouble(symbol, SYMBOL_POINT);
    double maxSpread = 50 * SymbolInfoDouble(symbol, SYMBOL_POINT); // 5 pips max
    
    return spread <= maxSpread;
}

//+------------------------------------------------------------------+
//| Check if within trading hours                                   |
//+------------------------------------------------------------------+
bool CExitStrategy::IsWithinTradingHours(const string symbol)
{
    MqlDateTime time;
    TimeToStruct(TimeCurrent(), time);
    
    // Basic check - avoid weekends
    if(time.day_of_week == 0 || time.day_of_week == 6)
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Log exit decision                                               |
//+------------------------------------------------------------------+
void CExitStrategy::LogExitDecision(ulong ticket, ENUM_EXIT_TYPE exitType, const string reason)
{
    string typeStr = EnumToString(exitType);
    CConfig::LogInfo(StringFormat("Exit Decision - Ticket: %d, Type: %s, Reason: %s", ticket, typeStr, reason));
}

//+------------------------------------------------------------------+
//| Log performance metrics                                         |
//+------------------------------------------------------------------+
void CExitStrategy::LogPerformanceMetrics()
{
    double successRate = GetExitSuccessRate();
    double avgProfit = GetAverageExitProfit();
    
    CConfig::LogInfo(StringFormat("Exit Strategy Performance - Total Exits: %d, Success Rate: %.1f%%, Average Profit: %.2f", 
                     m_totalExits, successRate, avgProfit));
}

//+------------------------------------------------------------------+
//| Update exit statistics                                          |
//+------------------------------------------------------------------+
void CExitStrategy::UpdateExitStatistics(ulong ticket, double exitProfit, ENUM_EXIT_TYPE exitType)
{
    m_totalExits++;
    m_totalExitProfit += exitProfit;
    
    if(exitProfit > 0)
        m_profitableExits++;
}

//+------------------------------------------------------------------+
//| Check if long position                                          |
//+------------------------------------------------------------------+
bool CExitStrategy::IsLongPosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    return PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY;
}

//+------------------------------------------------------------------+
//| Check if short position                                         |
//+------------------------------------------------------------------+
bool CExitStrategy::IsShortPosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    return PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL;
}

//+------------------------------------------------------------------+
//| Get position open price                                         |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionOpenPrice(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_PRICE_OPEN);
}

//+------------------------------------------------------------------+
//| Get position stop loss                                          |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionStopLoss(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_SL);
}

//+------------------------------------------------------------------+
//| Get position take profit                                        |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionTakeProfit(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_TP);
}

//+------------------------------------------------------------------+
//| Get position volume                                             |
//+------------------------------------------------------------------+
double CExitStrategy::GetPositionVolume(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return PositionGetDouble(POSITION_VOLUME);
}

//+------------------------------------------------------------------+
//| Get position symbol                                             |
//+------------------------------------------------------------------+
string CExitStrategy::GetPositionSymbol(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return "";
    
    return PositionGetString(POSITION_SYMBOL);
}

//+------------------------------------------------------------------+
//| Get position open time                                          |
//+------------------------------------------------------------------+
datetime CExitStrategy::GetPositionOpenTime(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    return (datetime)PositionGetInteger(POSITION_TIME);
}

//+------------------------------------------------------------------+
//| Normalize stop level                                            |
//+------------------------------------------------------------------+
double CExitStrategy::NormalizeStopLevel(const string symbol, double price)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    return NormalizeDouble(price, digits);
}

//+------------------------------------------------------------------+
//| Get minimum stop level distance                                 |
//+------------------------------------------------------------------+
double CExitStrategy::GetMinStopLevel(const string symbol)
{
    double stopLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
    return stopLevel * SymbolInfoDouble(symbol, SYMBOL_POINT);
}

//+------------------------------------------------------------------+
//| Signal enumeration for exit strategy integration               |
//+------------------------------------------------------------------+
enum ENUM_SIGNAL_TYPE
{
    SIGNAL_NONE,      // No signal
    SIGNAL_BUY,       // Buy signal
    SIGNAL_SELL,      // Sell signal
    SIGNAL_CLOSE_BUY, // Close buy signal
    SIGNAL_CLOSE_SELL // Close sell signal
};

//+------------------------------------------------------------------+
//| End of ExitStrategy class implementation                        |
//+------------------------------------------------------------------+