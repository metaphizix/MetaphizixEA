//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"
#include "OrderBlockDetector.mqh"

//+------------------------------------------------------------------+
//| Signal types                                                     |
//+------------------------------------------------------------------+
enum ENUM_SIGNAL_TYPE
{
    SIGNAL_NONE = 0,
    SIGNAL_BUY_ENTRY = 1,
    SIGNAL_SELL_ENTRY = 2,
    SIGNAL_BUY_EXIT = 3,
    SIGNAL_SELL_EXIT = 4
};

//+------------------------------------------------------------------+
//| Signal structure                                                 |
//+------------------------------------------------------------------+
struct SSignal
{
    string               symbol;
    ENUM_SIGNAL_TYPE     type;
    double               entry_price;
    double               stop_loss;
    double               take_profit;
    double               confidence;
    datetime             time;
    string               reason;
    bool                 is_processed;
};

//+------------------------------------------------------------------+
//| Signal manager class                                             |
//| Processes order block signals and generates entry/exit points    |
//+------------------------------------------------------------------+
class CSignalManager
{
private:
    SSignal           m_signals[];
    COrderBlockDetector* m_orderBlockDetector;
    
public:
    //--- Constructor/Destructor
    CSignalManager();
    ~CSignalManager();
    
    //--- Initialization
    bool Initialize();
    void SetOrderBlockDetector(COrderBlockDetector* detector);
    
    //--- Main functions
    bool ProcessSignal(string symbol);
    bool GetLatestSignal(string symbol, SSignal &signal);
    bool GetSignals(string symbol, SSignal &signals[]);
    bool HasNewSignal(string symbol);
    
    //--- Signal processing
    void ClearSignals(string symbol = "");
    int GetSignalCount(string symbol = "");
    
private:
    //--- Signal generation methods
    bool GenerateEntrySignal(string symbol, const SOrderBlock &orderBlock);
    bool GenerateExitSignal(string symbol, const SOrderBlock &orderBlock);
    double CalculateStopLoss(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType);
    double CalculateTakeProfit(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType);
    double CalculateSignalConfidence(string symbol, const SOrderBlock &orderBlock);
    
    //--- Validation methods
    bool ValidateSignal(const SSignal &signal);
    bool IsSignalRelevant(string symbol, const SOrderBlock &orderBlock);
    bool CheckEntryConditions(string symbol, const SOrderBlock &orderBlock);
    bool CheckExitConditions(string symbol, const SOrderBlock &orderBlock);
    
    //--- Helper functions
    double GetCurrentPrice(string symbol, ENUM_SIGNAL_TYPE signalType);
    double GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14);
    bool IsNearOrderBlock(string symbol, const SOrderBlock &orderBlock, double tolerance = 0.5);
    
    //--- Array management
    void AddSignal(const SSignal &signal);
    void RemoveOldSignals(string symbol);
    int FindLatestSignalIndex(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalManager::CSignalManager()
{
    ArrayResize(m_signals, 0);
    m_orderBlockDetector = NULL;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalManager::~CSignalManager()
{
    ArrayFree(m_signals);
}

//+------------------------------------------------------------------+
//| Initialize signal manager                                        |
//+------------------------------------------------------------------+
bool CSignalManager::Initialize()
{
    CConfig::LogInfo("Initializing Signal Manager");
    
    //--- Clear existing signals
    ClearSignals();
    
    CConfig::LogInfo("Signal Manager initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Set order block detector reference                               |
//+------------------------------------------------------------------+
void CSignalManager::SetOrderBlockDetector(COrderBlockDetector* detector)
{
    m_orderBlockDetector = detector;
}

//+------------------------------------------------------------------+
//| Process signals for symbol                                       |
//+------------------------------------------------------------------+
bool CSignalManager::ProcessSignal(string symbol)
{
    if(m_orderBlockDetector == NULL)
    {
        CConfig::LogError("Order block detector not set");
        return false;
    }
    
    //--- Remove old signals first
    RemoveOldSignals(symbol);
    
    //--- Get order blocks for this symbol
    SOrderBlock orderBlocks[];
    if(!m_orderBlockDetector.GetOrderBlocks(symbol, orderBlocks))
        return true; // No order blocks, but not an error
    
    bool signalGenerated = false;
    
    //--- Process each order block
    for(int i = 0; i < ArraySize(orderBlocks); i++)
    {
        //--- Check if order block is relevant
        if(!IsSignalRelevant(symbol, orderBlocks[i]))
            continue;
        
        //--- Generate entry signals
        if(CheckEntryConditions(symbol, orderBlocks[i]))
        {
            if(GenerateEntrySignal(symbol, orderBlocks[i]))
                signalGenerated = true;
        }
        
        //--- Generate exit signals
        if(CheckExitConditions(symbol, orderBlocks[i]))
        {
            if(GenerateExitSignal(symbol, orderBlocks[i]))
                signalGenerated = true;
        }
    }
    
    if(signalGenerated)
        CConfig::LogDebug("Generated new signals for " + symbol);
    
    return true;
}

//+------------------------------------------------------------------+
//| Generate entry signal                                            |
//+------------------------------------------------------------------+
bool CSignalManager::GenerateEntrySignal(string symbol, const SOrderBlock &orderBlock)
{
    SSignal signal;
    signal.symbol = symbol;
    signal.time = TimeCurrent();
    signal.is_processed = false;
    
    //--- Determine signal type based on order block direction
    if(orderBlock.is_bullish)
    {
        signal.type = SIGNAL_BUY_ENTRY;
        signal.entry_price = orderBlock.high;
        signal.reason = "Bullish order block entry at " + DoubleToString(orderBlock.high, _Digits);
    }
    else
    {
        signal.type = SIGNAL_SELL_ENTRY;
        signal.entry_price = orderBlock.low;
        signal.reason = "Bearish order block entry at " + DoubleToString(orderBlock.low, _Digits);
    }
    
    //--- Calculate stop loss and take profit
    signal.stop_loss = CalculateStopLoss(symbol, orderBlock, signal.type);
    signal.take_profit = CalculateTakeProfit(symbol, orderBlock, signal.type);
    signal.confidence = CalculateSignalConfidence(symbol, orderBlock);
    
    //--- Validate signal
    if(!ValidateSignal(signal))
        return false;
    
    //--- Add signal
    AddSignal(signal);
    
    CConfig::LogInfo(StringFormat("Entry signal generated for %s: %s at %.5f", 
                     symbol, EnumToString(signal.type), signal.entry_price));
    
    return true;
}

//+------------------------------------------------------------------+
//| Generate exit signal                                             |
//+------------------------------------------------------------------+
bool CSignalManager::GenerateExitSignal(string symbol, const SOrderBlock &orderBlock)
{
    SSignal signal;
    signal.symbol = symbol;
    signal.time = TimeCurrent();
    signal.is_processed = false;
    
    //--- Determine exit based on current price position relative to order block
    double currentPrice = GetCurrentPrice(symbol, SIGNAL_BUY_EXIT);
    
    if(orderBlock.is_bullish && currentPrice < orderBlock.low)
    {
        signal.type = SIGNAL_BUY_EXIT;
        signal.entry_price = currentPrice;
        signal.reason = "Exit long position - price below bullish order block";
    }
    else if(!orderBlock.is_bullish && currentPrice > orderBlock.high)
    {
        signal.type = SIGNAL_SELL_EXIT;
        signal.entry_price = currentPrice;
        signal.reason = "Exit short position - price above bearish order block";
    }
    else
    {
        return false; // No exit condition met
    }
    
    signal.stop_loss = 0; // No stop loss for exit signals
    signal.take_profit = 0; // No take profit for exit signals
    signal.confidence = CalculateSignalConfidence(symbol, orderBlock);
    
    //--- Validate signal
    if(!ValidateSignal(signal))
        return false;
    
    //--- Add signal
    AddSignal(signal);
    
    CConfig::LogInfo(StringFormat("Exit signal generated for %s: %s at %.5f", 
                     symbol, EnumToString(signal.type), signal.entry_price));
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate stop loss                                              |
//+------------------------------------------------------------------+
double CSignalManager::CalculateStopLoss(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType)
{
    double atr = GetATR(symbol, orderBlock.timeframe);
    double stopDistance = atr * 1.5; // 1.5 x ATR
    
    if(signalType == SIGNAL_BUY_ENTRY)
    {
        return orderBlock.low - stopDistance;
    }
    else if(signalType == SIGNAL_SELL_ENTRY)
    {
        return orderBlock.high + stopDistance;
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate take profit                                            |
//+------------------------------------------------------------------+
double CSignalManager::CalculateTakeProfit(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType)
{
    double atr = GetATR(symbol, orderBlock.timeframe);
    double targetDistance = atr * 3.0; // 3 x ATR (2:1 risk-reward)
    
    if(signalType == SIGNAL_BUY_ENTRY)
    {
        return orderBlock.high + targetDistance;
    }
    else if(signalType == SIGNAL_SELL_ENTRY)
    {
        return orderBlock.low - targetDistance;
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate signal confidence                                      |
//+------------------------------------------------------------------+
double CSignalManager::CalculateSignalConfidence(string symbol, const SOrderBlock &orderBlock)
{
    double confidence = 0.0;
    
    //--- Base confidence from order block strength
    confidence += orderBlock.strength * 0.4;
    
    //--- Confirmation bonus
    if(orderBlock.is_confirmed)
        confidence += 0.3;
    
    //--- Timeframe bonus (higher timeframes = higher confidence)
    switch(orderBlock.timeframe)
    {
        case PERIOD_D1: confidence += 0.2; break;
        case PERIOD_H4: confidence += 0.15; break;
        case PERIOD_H1: confidence += 0.1; break;
        case PERIOD_M15: confidence += 0.05; break;
    }
    
    //--- Freshness bonus (newer blocks = higher confidence)
    double hoursSince = (double)(TimeCurrent() - orderBlock.time) / 3600.0;
    if(hoursSince < 4)
        confidence += 0.1;
    else if(hoursSince < 24)
        confidence += 0.05;
    
    return MathMin(confidence, 1.0);
}

//+------------------------------------------------------------------+
//| Validate signal                                                  |
//+------------------------------------------------------------------+
bool CSignalManager::ValidateSignal(const SSignal &signal)
{
    //--- Check confidence threshold
    if(signal.confidence < 0.4)
        return false;
    
    //--- Check price validity
    if(signal.entry_price <= 0)
        return false;
    
    //--- Check stop loss validity (for entry signals)
    if((signal.type == SIGNAL_BUY_ENTRY || signal.type == SIGNAL_SELL_ENTRY) && signal.stop_loss <= 0)
        return false;
    
    //--- Check risk-reward ratio
    if(signal.type == SIGNAL_BUY_ENTRY)
    {
        double risk = signal.entry_price - signal.stop_loss;
        double reward = signal.take_profit - signal.entry_price;
        if(reward / risk < 1.5) // Minimum 1.5:1 risk-reward
            return false;
    }
    else if(signal.type == SIGNAL_SELL_ENTRY)
    {
        double risk = signal.stop_loss - signal.entry_price;
        double reward = signal.entry_price - signal.take_profit;
        if(reward / risk < 1.5) // Minimum 1.5:1 risk-reward
            return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if signal is relevant                                      |
//+------------------------------------------------------------------+
bool CSignalManager::IsSignalRelevant(string symbol, const SOrderBlock &orderBlock)
{
    //--- Check if order block is confirmed
    if(!orderBlock.is_confirmed)
        return false;
    
    //--- Check if order block is not too old
    double hoursSince = (double)(TimeCurrent() - orderBlock.time) / 3600.0;
    if(hoursSince > 168) // Older than 1 week
        return false;
    
    //--- Check if price is near the order block
    if(!IsNearOrderBlock(symbol, orderBlock, 2.0)) // Within 2 ATR
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check entry conditions                                           |
//+------------------------------------------------------------------+
bool CSignalManager::CheckEntryConditions(string symbol, const SOrderBlock &orderBlock)
{
    double currentPrice = GetCurrentPrice(symbol, SIGNAL_BUY_ENTRY);
    
    if(orderBlock.is_bullish)
    {
        //--- For bullish order block, price should be near or touching the block
        return (currentPrice >= orderBlock.low && currentPrice <= orderBlock.high + GetATR(symbol, orderBlock.timeframe));
    }
    else
    {
        //--- For bearish order block, price should be near or touching the block
        return (currentPrice <= orderBlock.high && currentPrice >= orderBlock.low - GetATR(symbol, orderBlock.timeframe));
    }
}

//+------------------------------------------------------------------+
//| Check exit conditions                                            |
//+------------------------------------------------------------------+
bool CSignalManager::CheckExitConditions(string symbol, const SOrderBlock &orderBlock)
{
    double currentPrice = GetCurrentPrice(symbol, SIGNAL_BUY_EXIT);
    
    //--- Exit conditions based on order block violation
    if(orderBlock.is_bullish)
    {
        return currentPrice < orderBlock.low; // Price broke below bullish block
    }
    else
    {
        return currentPrice > orderBlock.high; // Price broke above bearish block
    }
}

//+------------------------------------------------------------------+
//| Get current price based on signal type                          |
//+------------------------------------------------------------------+
double CSignalManager::GetCurrentPrice(string symbol, ENUM_SIGNAL_TYPE signalType)
{
    if(signalType == SIGNAL_BUY_ENTRY || signalType == SIGNAL_BUY_EXIT)
        return SymbolInfoDouble(symbol, SYMBOL_ASK);
    else
        return SymbolInfoDouble(symbol, SYMBOL_BID);
}

//+------------------------------------------------------------------+
//| Get Average True Range                                           |
//+------------------------------------------------------------------+
double CSignalManager::GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14)
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
//| Check if price is near order block                              |
//+------------------------------------------------------------------+
bool CSignalManager::IsNearOrderBlock(string symbol, const SOrderBlock &orderBlock, double tolerance = 0.5)
{
    double currentPrice = GetCurrentPrice(symbol, SIGNAL_BUY_ENTRY);
    double atr = GetATR(symbol, orderBlock.timeframe);
    double distance = atr * tolerance;
    
    return (currentPrice >= orderBlock.low - distance && currentPrice <= orderBlock.high + distance);
}

//+------------------------------------------------------------------+
//| Add signal to array                                              |
//+------------------------------------------------------------------+
void CSignalManager::AddSignal(const SSignal &signal)
{
    ArrayResize(m_signals, ArraySize(m_signals) + 1);
    m_signals[ArraySize(m_signals) - 1] = signal;
}

//+------------------------------------------------------------------+
//| Remove old signals                                               |
//+------------------------------------------------------------------+
void CSignalManager::RemoveOldSignals(string symbol)
{
    datetime cutoffTime = TimeCurrent() - (24 * 3600); // 24 hours old
    
    for(int i = ArraySize(m_signals) - 1; i >= 0; i--)
    {
        if(m_signals[i].symbol == symbol && m_signals[i].time < cutoffTime)
        {
            ArrayRemove(m_signals, i, 1);
        }
    }
}

//+------------------------------------------------------------------+
//| Find latest signal index                                         |
//+------------------------------------------------------------------+
int CSignalManager::FindLatestSignalIndex(string symbol)
{
    datetime latestTime = 0;
    int latestIndex = -1;
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol && m_signals[i].time > latestTime)
        {
            latestTime = m_signals[i].time;
            latestIndex = i;
        }
    }
    
    return latestIndex;
}

//+------------------------------------------------------------------+
//| Get latest signal                                                |
//+------------------------------------------------------------------+
bool CSignalManager::GetLatestSignal(string symbol, SSignal &signal)
{
    int index = FindLatestSignalIndex(symbol);
    if(index >= 0)
    {
        signal = m_signals[index];
        return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Get all signals for symbol                                       |
//+------------------------------------------------------------------+
bool CSignalManager::GetSignals(string symbol, SSignal &signals[])
{
    ArrayResize(signals, 0);
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol)
        {
            ArrayResize(signals, ArraySize(signals) + 1);
            signals[ArraySize(signals) - 1] = m_signals[i];
        }
    }
    
    return ArraySize(signals) > 0;
}

//+------------------------------------------------------------------+
//| Check if there are new signals                                   |
//+------------------------------------------------------------------+
bool CSignalManager::HasNewSignal(string symbol)
{
    datetime currentTime = TimeCurrent();
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol && 
           currentTime - m_signals[i].time < 300 && // New within 5 minutes
           !m_signals[i].is_processed)
        {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Clear signals                                                    |
//+------------------------------------------------------------------+
void CSignalManager::ClearSignals(string symbol = "")
{
    if(symbol == "")
    {
        ArrayResize(m_signals, 0);
    }
    else
    {
        for(int i = ArraySize(m_signals) - 1; i >= 0; i--)
        {
            if(m_signals[i].symbol == symbol)
            {
                ArrayRemove(m_signals, i, 1);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Get signal count                                                 |
//+------------------------------------------------------------------+
int CSignalManager::GetSignalCount(string symbol = "")
{
    if(symbol == "")
        return ArraySize(m_signals);
    
    int count = 0;
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol)
            count++;
    }
    
    return count;
}