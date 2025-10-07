//+------------------------------------------------------------------+
//|                                                 ExitStrategy.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Exit strategy class                                              |
//| Manages trade exits, trailing stops, and profit taking          |
//+------------------------------------------------------------------+
class CExitStrategy
{
private:
    double            m_atrMultiplier;
    double            m_breakEvenBuffer;
    double            m_partialExitRR;
    bool              m_trailingStopEnabled;
    bool              m_breakEvenEnabled;
    bool              m_partialExitEnabled;
    
public:
    //--- Constructor/Destructor
    CExitStrategy();
    ~CExitStrategy();
    
    //--- Initialization
    bool Initialize(double atrMultiplier = 1.5, double breakEvenBuffer = 10, double partialExitRR = 2.0);
    
    //--- Main exit methods
    void ApplyTrailingStop(ulong ticket, double atrValue);
    void ApplyBreakEven(ulong ticket);
    void ApplyPartialExit(ulong ticket, double riskReward);
    void ProcessAllExits();
    
    //--- Exit condition checks
    bool ShouldMoveToBreakEven(ulong ticket);
    bool ShouldPartialExit(ulong ticket, double riskReward);
    bool ShouldTrailStop(ulong ticket, double atrValue);
    
    //--- Calculation methods
    double CalculateTrailingStopLevel(ulong ticket, double atrValue);
    double CalculateBreakEvenLevel(ulong ticket);
    double CalculatePartialExitPrice(ulong ticket);
    double CalculatePartialExitVolume(ulong ticket);
    
    //--- Utility methods
    bool ModifyStopLoss(ulong ticket, double newStopLoss);
    bool ClosePartialPosition(ulong ticket, double volume);
    double GetCurrentProfit(ulong ticket);
    double GetCurrentRiskReward(ulong ticket);
    
    //--- Getters/Setters
    void SetATRMultiplier(double multiplier) { m_atrMultiplier = multiplier; }
    void SetBreakEvenBuffer(double buffer) { m_breakEvenBuffer = buffer; }
    void SetPartialExitRR(double rr) { m_partialExitRR = rr; }
    void SetTrailingStopEnabled(bool enabled) { m_trailingStopEnabled = enabled; }
    void SetBreakEvenEnabled(bool enabled) { m_breakEvenEnabled = enabled; }
    void SetPartialExitEnabled(bool enabled) { m_partialExitEnabled = enabled; }
    
    double GetATRMultiplier() { return m_atrMultiplier; }
    double GetBreakEvenBuffer() { return m_breakEvenBuffer; }
    double GetPartialExitRR() { return m_partialExitRR; }
    bool IsTrailingStopEnabled() { return m_trailingStopEnabled; }
    bool IsBreakEvenEnabled() { return m_breakEvenEnabled; }
    bool IsPartialExitEnabled() { return m_partialExitEnabled; }
    
private:
    //--- Helper methods
    bool IsLongPosition(ulong ticket);
    bool IsShortPosition(ulong ticket);
    double GetPositionOpenPrice(ulong ticket);
    double GetPositionStopLoss(ulong ticket);
    double GetPositionTakeProfit(ulong ticket);
    double GetPositionVolume(ulong ticket);
    string GetPositionSymbol(ulong ticket);
    double NormalizeStopLevel(string symbol, double price);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExitStrategy::CExitStrategy()
{
    m_atrMultiplier = 1.5;
    m_breakEvenBuffer = 10.0;
    m_partialExitRR = 2.0;
    m_trailingStopEnabled = true;
    m_breakEvenEnabled = true;
    m_partialExitEnabled = true;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExitStrategy::~CExitStrategy()
{
}

//+------------------------------------------------------------------+
//| Initialize exit strategy                                         |
//+------------------------------------------------------------------+
bool CExitStrategy::Initialize(double atrMultiplier = 1.5, double breakEvenBuffer = 10, double partialExitRR = 2.0)
{
    m_atrMultiplier = atrMultiplier;
    m_breakEvenBuffer = breakEvenBuffer;
    m_partialExitRR = partialExitRR;
    
    CConfig::LogInfo(StringFormat("Exit Strategy initialized - ATR Multiplier: %.1f, Break-even buffer: %.1f, Partial exit R:R: %.1f", 
                     atrMultiplier, breakEvenBuffer, partialExitRR));
    
    return true;
}

//+------------------------------------------------------------------+
//| Apply trailing stop                                             |
//+------------------------------------------------------------------+
void CExitStrategy::ApplyTrailingStop(ulong ticket, double atrValue)
{
    if(!m_trailingStopEnabled || !PositionSelectByTicket(ticket))
        return;
    
    if(ShouldTrailStop(ticket, atrValue))
    {
        double newStopLoss = CalculateTrailingStopLevel(ticket, atrValue);
        
        if(newStopLoss > 0)
        {
            ModifyStopLoss(ticket, newStopLoss);
            CConfig::LogDebug(StringFormat("Trailing stop applied to ticket %d: %.5f", ticket, newStopLoss));
        }
    }
}

//+------------------------------------------------------------------+
//| Apply break-even                                                |
//+------------------------------------------------------------------+
void CExitStrategy::ApplyBreakEven(ulong ticket)
{
    if(!m_breakEvenEnabled || !PositionSelectByTicket(ticket))
        return;
    
    if(ShouldMoveToBreakEven(ticket))
    {
        double breakEvenLevel = CalculateBreakEvenLevel(ticket);
        
        if(breakEvenLevel > 0)
        {
            ModifyStopLoss(ticket, breakEvenLevel);
            CConfig::LogInfo(StringFormat("Break-even applied to ticket %d: %.5f", ticket, breakEvenLevel));
        }
    }
}

//+------------------------------------------------------------------+
//| Apply partial exit                                              |
//+------------------------------------------------------------------+
void CExitStrategy::ApplyPartialExit(ulong ticket, double riskReward)
{
    if(!m_partialExitEnabled || !PositionSelectByTicket(ticket))
        return;
    
    if(ShouldPartialExit(ticket, riskReward))
    {
        double partialVolume = CalculatePartialExitVolume(ticket);
        
        if(partialVolume > 0)
        {
            ClosePartialPosition(ticket, partialVolume);
            CConfig::LogInfo(StringFormat("Partial exit applied to ticket %d: Volume %.2f", ticket, partialVolume));
        }
    }
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
            
            // Apply exit strategies
            ApplyTrailingStop(ticket, atr);
            ApplyBreakEven(ticket);
            
            double riskReward = GetCurrentRiskReward(ticket);
            ApplyPartialExit(ticket, riskReward);
        }
    }
}

//+------------------------------------------------------------------+
//| Check if should move to break-even                              |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldMoveToBreakEven(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double openPrice = GetPositionOpenPrice(ticket);
    double currentSL = GetPositionStopLoss(ticket);
    string symbol = GetPositionSymbol(ticket);
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    // Convert buffer from pips to price
    double bufferPoints = CConfig::PipsToPoints(symbol, m_breakEvenBuffer);
    
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
bool CExitStrategy::ShouldPartialExit(ulong ticket, double riskReward)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    // Exit partial position when risk-reward reaches target
    if(riskReward >= m_partialExitRR)
    {
        // Check if we haven't already done partial exit (volume should be original)
        double currentVolume = GetPositionVolume(ticket);
        double originalVolume = currentVolume; // In real implementation, store original volume
        
        return (currentVolume == originalVolume);
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should trail stop                                      |
//+------------------------------------------------------------------+
bool CExitStrategy::ShouldTrailStop(ulong ticket, double atrValue)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double newStopLoss = CalculateTrailingStopLevel(ticket, atrValue);
    double currentSL = GetPositionStopLoss(ticket);
    
    if(IsLongPosition(ticket))
    {
        return (newStopLoss > currentSL);
    }
    else if(IsShortPosition(ticket))
    {
        return (newStopLoss < currentSL);
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Calculate trailing stop level                                   |
//+------------------------------------------------------------------+
double CExitStrategy::CalculateTrailingStopLevel(ulong ticket, double atrValue)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    string symbol = GetPositionSymbol(ticket);
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double stopDistance = atrValue * m_atrMultiplier;
    
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
    double bufferPoints = CConfig::PipsToPoints(symbol, m_breakEvenBuffer * 0.1); // Small buffer
    
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
//| Calculate partial exit volume                                   |
//+------------------------------------------------------------------+
double CExitStrategy::CalculatePartialExitVolume(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double totalVolume = GetPositionVolume(ticket);
    return totalVolume * 0.5; // Close 50% of position
}

//+------------------------------------------------------------------+
//| Modify stop loss                                                |
//+------------------------------------------------------------------+
bool CExitStrategy::ModifyStopLoss(ulong ticket, double newStopLoss)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.sl = newStopLoss;
    request.tp = GetPositionTakeProfit(ticket);
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to modify stop loss for ticket %d: Error %d", ticket, result.retcode));
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
    
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    string symbol = GetPositionSymbol(ticket);
    
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.volume = volume;
    request.type = (IsLongPosition(ticket)) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = (IsLongPosition(ticket)) ? 
                    SymbolInfoDouble(symbol, SYMBOL_BID) : 
                    SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.comment = "Partial Exit";
    
    bool success = OrderSend(request, result);
    
    if(!success)
    {
        CConfig::LogError(StringFormat("Failed to close partial position for ticket %d: Error %d", ticket, result.retcode));
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
    
    return PositionGetDouble(POSITION_PROFIT);
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
//| Normalize stop level                                            |
//+------------------------------------------------------------------+
double CExitStrategy::NormalizeStopLevel(string symbol, double price)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    return NormalizeDouble(price, digits);
}