//+------------------------------------------------------------------+
//|                                                       Config.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

//+------------------------------------------------------------------+
//| Configuration manager class                                      |
//| Handles all EA configuration and global settings                 |
//+------------------------------------------------------------------+
class CConfig
{
private:
    static string        m_tradingPairs[];
    static int           m_maxConcurrentPairs;
    static int           m_orderBlockLookback;
    static double        m_minOrderBlockSize;
    static int           m_orderBlockConfirmation;
    static int           m_timerInterval;
    static bool          m_enableLogging;
    
public:
    //--- Initialization
    static bool Initialize(string pairs, int maxPairs, int lookback, double minSize, 
                          int confirmation, int timer, bool logging);
    
    //--- Getters
    static void GetTradingPairs(string &pairs[]) { ArrayCopy(pairs, m_tradingPairs); }
    static int GetMaxConcurrentPairs() { return m_maxConcurrentPairs; }
    static int GetOrderBlockLookback() { return m_orderBlockLookback; }
    static double GetMinOrderBlockSize() { return m_minOrderBlockSize; }
    static int GetOrderBlockConfirmation() { return m_orderBlockConfirmation; }
    static int GetTimerInterval() { return m_timerInterval; }
    static bool IsLoggingEnabled() { return m_enableLogging; }
    
    //--- Utility functions
    static double PointToPips(string symbol, double points);
    static double PipsToPoints(string symbol, double pips);
    static bool IsValidSymbol(string symbol);
    static void LogInfo(string message);
    static void LogError(string message);
    static void LogDebug(string message);
    
private:
    static bool ParseTradingPairs(string pairsString);
};

//--- Static member definitions
string CConfig::m_tradingPairs[];
int CConfig::m_maxConcurrentPairs = 3;
int CConfig::m_orderBlockLookback = 50;
double CConfig::m_minOrderBlockSize = 10.0;
int CConfig::m_orderBlockConfirmation = 3;
int CConfig::m_timerInterval = 5;
bool CConfig::m_enableLogging = true;

//+------------------------------------------------------------------+
//| Initialize configuration                                          |
//+------------------------------------------------------------------+
bool CConfig::Initialize(string pairs, int maxPairs, int lookback, double minSize, 
                        int confirmation, int timer, bool logging)
{
    //--- Set configuration values
    m_maxConcurrentPairs = maxPairs;
    m_orderBlockLookback = lookback;
    m_minOrderBlockSize = minSize;
    m_orderBlockConfirmation = confirmation;
    m_timerInterval = timer;
    m_enableLogging = logging;
    
    //--- Parse trading pairs
    if(!ParseTradingPairs(pairs))
    {
        LogError("Failed to parse trading pairs: " + pairs);
        return false;
    }
    
    LogInfo(StringFormat("Configuration initialized - Pairs: %d, Max concurrent: %d", 
                        ArraySize(m_tradingPairs), m_maxConcurrentPairs));
    
    return true;
}

//+------------------------------------------------------------------+
//| Parse trading pairs string                                       |
//+------------------------------------------------------------------+
bool CConfig::ParseTradingPairs(string pairsString)
{
    ArrayResize(m_tradingPairs, 0);
    
    string pairs[];
    int count = StringSplit(pairsString, ',', pairs);
    
    for(int i = 0; i < count; i++)
    {
        string pair = StringTrimLeft(StringTrimRight(pairs[i]));
        StringToUpper(pair);
        
        if(StringLen(pair) >= 6 && IsValidSymbol(pair))
        {
            ArrayResize(m_tradingPairs, ArraySize(m_tradingPairs) + 1);
            m_tradingPairs[ArraySize(m_tradingPairs) - 1] = pair;
        }
        else
        {
            LogError("Invalid trading pair: " + pair);
        }
    }
    
    return ArraySize(m_tradingPairs) > 0;
}

//+------------------------------------------------------------------+
//| Convert points to pips                                           |
//+------------------------------------------------------------------+
double CConfig::PointToPips(string symbol, double points)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    if(digits == 2 || digits == 3)
        return points;
    else if(digits == 4 || digits == 5)
        return points / 10.0;
    
    return points;
}

//+------------------------------------------------------------------+
//| Convert pips to points                                           |
//+------------------------------------------------------------------+
double CConfig::PipsToPoints(string symbol, double pips)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    if(digits == 2 || digits == 3)
        return pips;
    else if(digits == 4 || digits == 5)
        return pips * 10.0;
    
    return pips;
}

//+------------------------------------------------------------------+
//| Check if symbol is valid                                         |
//+------------------------------------------------------------------+
bool CConfig::IsValidSymbol(string symbol)
{
    return SymbolSelect(symbol, true);
}

//+------------------------------------------------------------------+
//| Log information message                                          |
//+------------------------------------------------------------------+
void CConfig::LogInfo(string message)
{
    if(m_enableLogging)
        Print("[INFO] ", message);
}

//+------------------------------------------------------------------+
//| Log error message                                                |
//+------------------------------------------------------------------+
void CConfig::LogError(string message)
{
    if(m_enableLogging)
        Print("[ERROR] ", message);
}

//+------------------------------------------------------------------+
//| Log debug message                                                |
//+------------------------------------------------------------------+
void CConfig::LogDebug(string message)
{
    if(m_enableLogging)
        Print("[DEBUG] ", message);
}