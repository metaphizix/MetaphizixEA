//+------------------------------------------------------------------+
//|                                            OrderBlockDetector.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Order block structure                                            |
//+------------------------------------------------------------------+
struct SOrderBlock
{
    string            symbol;
    datetime          time;
    double            high;
    double            low;
    double            open;
    double            close;
    ENUM_TIMEFRAMES   timeframe;
    bool              is_bullish;
    bool              is_confirmed;
    double            strength;
    int               touch_count;
    datetime          last_touch;
};

//+------------------------------------------------------------------+
//| Order block detector class                                       |
//| Responsible for detecting and managing order blocks              |
//+------------------------------------------------------------------+
class COrderBlockDetector
{
private:
    SOrderBlock       m_orderBlocks[];
    datetime          m_lastAnalysis[];
    
public:
    //--- Constructor/Destructor
    COrderBlockDetector();
    ~COrderBlockDetector();
    
    //--- Initialization
    bool Initialize();
    
    //--- Main functions
    bool AnalyzePair(string symbol);
    bool HasNewOrderBlock(string symbol);
    bool GetOrderBlocks(string symbol, SOrderBlock &blocks[]);
    bool GetLatestOrderBlock(string symbol, SOrderBlock &block);
    
    //--- Utility functions
    void ClearOrderBlocks(string symbol = "");
    int GetOrderBlockCount(string symbol = "");
    
private:
    //--- Order block detection methods
    bool DetectOrderBlocks(string symbol, ENUM_TIMEFRAMES timeframe);
    bool IsOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool ValidateOrderBlock(string symbol, const SOrderBlock &block);
    double CalculateOrderBlockStrength(string symbol, const SOrderBlock &block);
    bool IsOrderBlockConfirmed(string symbol, const SOrderBlock &block);
    
    //--- Helper functions
    bool IsBreakOfStructure(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool IsLiquidityZone(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    double GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14);
    bool IsBullishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool IsBearishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    
    //--- Array management
    int FindOrderBlockIndex(string symbol, datetime time);
    void AddOrderBlock(const SOrderBlock &block);
    void UpdateOrderBlock(int index, const SOrderBlock &block);
    void RemoveOldOrderBlocks(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COrderBlockDetector::COrderBlockDetector()
{
    ArrayResize(m_orderBlocks, 0);
    ArrayResize(m_lastAnalysis, 0);
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
COrderBlockDetector::~COrderBlockDetector()
{
    ArrayFree(m_orderBlocks);
    ArrayFree(m_lastAnalysis);
}

//+------------------------------------------------------------------+
//| Initialize order block detector                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::Initialize()
{
    CConfig::LogInfo("Initializing Order Block Detector");
    
    //--- Clear existing data
    ClearOrderBlocks();
    
    //--- Initialize last analysis times for all trading pairs
    string pairs[];
    CConfig::GetTradingPairs(pairs);
    
    ArrayResize(m_lastAnalysis, ArraySize(pairs));
    
    for(int i = 0; i < ArraySize(pairs); i++)
    {
        m_lastAnalysis[i] = 0;
    }
    
    CConfig::LogInfo("Order Block Detector initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Analyze pair for order blocks                                    |
//+------------------------------------------------------------------+
bool COrderBlockDetector::AnalyzePair(string symbol)
{
    //--- Check if symbol is valid
    if(!CConfig::IsValidSymbol(symbol))
    {
        CConfig::LogError("Invalid symbol for analysis: " + symbol);
        return false;
    }
    
    //--- Get current time
    datetime currentTime = TimeCurrent();
    
    //--- Check if enough time has passed since last analysis
    string pairs[];
    CConfig::GetTradingPairs(pairs);
    
    int pairIndex = -1;
    for(int i = 0; i < ArraySize(pairs); i++)
    {
        if(pairs[i] == symbol)
        {
            pairIndex = i;
            break;
        }
    }
    
    if(pairIndex >= 0 && pairIndex < ArraySize(m_lastAnalysis))
    {
        if(currentTime - m_lastAnalysis[pairIndex] < 60) // Minimum 1 minute between analyses
            return true;
            
        m_lastAnalysis[pairIndex] = currentTime;
    }
    
    //--- Remove old order blocks for this symbol
    RemoveOldOrderBlocks(symbol);
    
    //--- Detect order blocks on multiple timeframes
    ENUM_TIMEFRAMES timeframes[] = {PERIOD_M15, PERIOD_H1, PERIOD_H4, PERIOD_D1};
    
    bool foundNew = false;
    
    for(int i = 0; i < ArraySize(timeframes); i++)
    {
        if(DetectOrderBlocks(symbol, timeframes[i]))
            foundNew = true;
    }
    
    if(foundNew)
        CConfig::LogDebug("Found new order blocks for " + symbol);
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if there are new order blocks for symbol                   |
//+------------------------------------------------------------------+
bool COrderBlockDetector::HasNewOrderBlock(string symbol)
{
    datetime currentTime = TimeCurrent();
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && 
           currentTime - m_orderBlocks[i].time < 300) // New within 5 minutes
        {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Get all order blocks for symbol                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::GetOrderBlocks(string symbol, SOrderBlock &blocks[])
{
    ArrayResize(blocks, 0);
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol)
        {
            ArrayResize(blocks, ArraySize(blocks) + 1);
            blocks[ArraySize(blocks) - 1] = m_orderBlocks[i];
        }
    }
    
    return ArraySize(blocks) > 0;
}

//+------------------------------------------------------------------+
//| Get latest order block for symbol                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::GetLatestOrderBlock(string symbol, SOrderBlock &block)
{
    datetime latestTime = 0;
    bool found = false;
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time > latestTime)
        {
            latestTime = m_orderBlocks[i].time;
            block = m_orderBlocks[i];
            found = true;
        }
    }
    
    return found;
}

//+------------------------------------------------------------------+
//| Detect order blocks on specific timeframe                        |
//+------------------------------------------------------------------+
bool COrderBlockDetector::DetectOrderBlocks(string symbol, ENUM_TIMEFRAMES timeframe)
{
    int lookback = CConfig::GetOrderBlockLookback();
    bool foundNew = false;
    
    //--- Analyze candles
    for(int i = 1; i <= lookback; i++)
    {
        if(IsOrderBlock(symbol, timeframe, i))
        {
            SOrderBlock block;
            block.symbol = symbol;
            block.time = iTime(symbol, timeframe, i);
            block.high = iHigh(symbol, timeframe, i);
            block.low = iLow(symbol, timeframe, i);
            block.open = iOpen(symbol, timeframe, i);
            block.close = iClose(symbol, timeframe, i);
            block.timeframe = timeframe;
            block.is_bullish = IsBullishOrderBlock(symbol, timeframe, i);
            block.is_confirmed = IsOrderBlockConfirmed(symbol, block);
            block.strength = CalculateOrderBlockStrength(symbol, block);
            block.touch_count = 0;
            block.last_touch = 0;
            
            //--- Validate order block
            if(ValidateOrderBlock(symbol, block))
            {
                //--- Check if this order block already exists
                int existingIndex = FindOrderBlockIndex(symbol, block.time);
                if(existingIndex >= 0)
                {
                    UpdateOrderBlock(existingIndex, block);
                }
                else
                {
                    AddOrderBlock(block);
                    foundNew = true;
                }
            }
        }
    }
    
    return foundNew;
}

//+------------------------------------------------------------------+
//| Check if candle forms an order block                             |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Basic order block criteria
    if(!IsBreakOfStructure(symbol, timeframe, shift))
        return false;
        
    if(!IsLiquidityZone(symbol, timeframe, shift))
        return false;
    
    //--- Check for minimum size requirement
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    double sizePips = CConfig::PointToPips(symbol, high - low);
    
    if(sizePips < CConfig::GetMinOrderBlockSize())
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Validate order block                                             |
//+------------------------------------------------------------------+
bool COrderBlockDetector::ValidateOrderBlock(string symbol, const SOrderBlock &block)
{
    //--- Check minimum size
    double sizePips = CConfig::PointToPips(symbol, block.high - block.low);
    if(sizePips < CConfig::GetMinOrderBlockSize())
        return false;
    
    //--- Check strength threshold
    if(block.strength < 0.3) // Minimum strength of 30%
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate order block strength                                   |
//+------------------------------------------------------------------+
double COrderBlockDetector::CalculateOrderBlockStrength(string symbol, const SOrderBlock &block)
{
    double strength = 0.0;
    
    //--- Volume factor (if available)
    double volume = iVolume(symbol, block.timeframe, 0);
    if(volume > 0)
    {
        double avgVolume = 0;
        for(int i = 1; i <= 20; i++)
        {
            avgVolume += iVolume(symbol, block.timeframe, i);
        }
        avgVolume /= 20.0;
        
        if(volume > avgVolume * 1.5)
            strength += 0.3;
    }
    
    //--- Size factor
    double atr = GetATR(symbol, block.timeframe);
    if(atr > 0)
    {
        double relativeSize = (block.high - block.low) / atr;
        strength += MathMin(relativeSize / 2.0, 0.4);
    }
    
    //--- Time factor (fresher blocks are stronger)
    double hoursSince = (double)(TimeCurrent() - block.time) / 3600.0;
    if(hoursSince < 24)
        strength += 0.3;
    else if(hoursSince < 168) // 1 week
        strength += 0.2;
    
    return MathMin(strength, 1.0);
}

//+------------------------------------------------------------------+
//| Check if order block is confirmed                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsOrderBlockConfirmed(string symbol, const SOrderBlock &block)
{
    int confirmationBars = CConfig::GetOrderBlockConfirmation();
    
    //--- Check if price has moved away from the order block
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    if(block.is_bullish)
    {
        return currentPrice > block.high;
    }
    else
    {
        return currentPrice < block.low;
    }
}

//+------------------------------------------------------------------+
//| Check for break of structure                                     |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBreakOfStructure(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Look for significant price movement
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    double close = iClose(symbol, timeframe, shift);
    double open = iOpen(symbol, timeframe, shift);
    
    //--- Check for strong candle
    double bodySize = MathAbs(close - open);
    double candleSize = high - low;
    
    return bodySize > candleSize * 0.7; // Strong body relative to total range
}

//+------------------------------------------------------------------+
//| Check if area is a liquidity zone                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsLiquidityZone(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Look for previous touches at this level
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    
    int touches = 0;
    for(int i = shift + 1; i < shift + 20; i++)
    {
        double testHigh = iHigh(symbol, timeframe, i);
        double testLow = iLow(symbol, timeframe, i);
        
        if((testHigh >= low && testHigh <= high) || (testLow >= low && testLow <= high))
            touches++;
    }
    
    return touches >= 2; // At least 2 previous touches
}

//+------------------------------------------------------------------+
//| Get Average True Range                                           |
//+------------------------------------------------------------------+
double COrderBlockDetector::GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14)
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
//| Check if order block is bullish                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBullishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    double open = iOpen(symbol, timeframe, shift);
    double close = iClose(symbol, timeframe, shift);
    
    return close > open;
}

//+------------------------------------------------------------------+
//| Check if order block is bearish                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBearishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    return !IsBullishOrderBlock(symbol, timeframe, shift);
}

//+------------------------------------------------------------------+
//| Find order block index by symbol and time                        |
//+------------------------------------------------------------------+
int COrderBlockDetector::FindOrderBlockIndex(string symbol, datetime time)
{
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time == time)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Add new order block                                              |
//+------------------------------------------------------------------+
void COrderBlockDetector::AddOrderBlock(const SOrderBlock &block)
{
    ArrayResize(m_orderBlocks, ArraySize(m_orderBlocks) + 1);
    m_orderBlocks[ArraySize(m_orderBlocks) - 1] = block;
}

//+------------------------------------------------------------------+
//| Update existing order block                                      |
//+------------------------------------------------------------------+
void COrderBlockDetector::UpdateOrderBlock(int index, const SOrderBlock &block)
{
    if(index >= 0 && index < ArraySize(m_orderBlocks))
        m_orderBlocks[index] = block;
}

//+------------------------------------------------------------------+
//| Remove old order blocks                                          |
//+------------------------------------------------------------------+
void COrderBlockDetector::RemoveOldOrderBlocks(string symbol)
{
    datetime cutoffTime = TimeCurrent() - (7 * 24 * 3600); // 1 week old
    
    for(int i = ArraySize(m_orderBlocks) - 1; i >= 0; i--)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time < cutoffTime)
        {
            ArrayRemove(m_orderBlocks, i, 1);
        }
    }
}

//+------------------------------------------------------------------+
//| Clear all order blocks                                           |
//+------------------------------------------------------------------+
void COrderBlockDetector::ClearOrderBlocks(string symbol = "")
{
    if(symbol == "")
    {
        ArrayResize(m_orderBlocks, 0);
    }
    else
    {
        for(int i = ArraySize(m_orderBlocks) - 1; i >= 0; i--)
        {
            if(m_orderBlocks[i].symbol == symbol)
            {
                ArrayRemove(m_orderBlocks, i, 1);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Get order block count                                            |
//+------------------------------------------------------------------+
int COrderBlockDetector::GetOrderBlockCount(string symbol = "")
{
    if(symbol == "")
        return ArraySize(m_orderBlocks);
    
    int count = 0;
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol)
            count++;
    }
    
    return count;
}