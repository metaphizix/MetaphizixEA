//+------------------------------------------------------------------+
//|                                                  PairManager.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Pair analysis structure                                          |
//+------------------------------------------------------------------+
struct SPairAnalysis
{
    string            symbol;
    double            volatility;
    double            momentum;
    double            trend_strength;
    double            liquidity_score;
    double            opportunity_score;
    datetime          last_update;
    bool              is_trending;
    bool              has_opportunity;
};

//+------------------------------------------------------------------+
//| Pair manager class                                               |
//| Manages multiple currency pairs and selects best opportunities   |
//+------------------------------------------------------------------+
class CPairManager
{
private:
    SPairAnalysis     m_pairAnalysis[];
    string            m_activePairs[];
    datetime          m_lastFullAnalysis;
    
public:
    //--- Constructor/Destructor
    CPairManager();
    ~CPairManager();
    
    //--- Initialization
    bool Initialize();
    
    //--- Main functions
    bool AnalyzeAllPairs();
    bool AnalyzePair(string symbol);
    bool GetBestPairs(string &pairs[]);
    void OnTick(string symbol);
    
    //--- Getters
    bool GetPairAnalysis(string symbol, SPairAnalysis &analysis);
    bool IsActivePair(string symbol);
    int GetActivePairCount();
    void GetActivePairs(string &pairs[]);
    
    //--- Utility functions
    void ClearAnalysis();
    void UpdatePairStatus(string symbol, bool isActive);
    
private:
    //--- Analysis methods
    double CalculateVolatility(string symbol);
    double CalculateMomentum(string symbol);
    double CalculateTrendStrength(string symbol);
    double CalculateLiquidityScore(string symbol);
    double CalculateOpportunityScore(const SPairAnalysis &analysis);
    bool IsTrending(string symbol);
    bool HasOpportunity(const SPairAnalysis &analysis);
    
    //--- Helper functions
    double GetMA(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0);
    double GetRSI(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0);
    double GetADX(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0);
    double GetSpread(string symbol);
    bool IsMarketOpen(string symbol);
    
    //--- Array management
    int FindAnalysisIndex(string symbol);
    void AddPairAnalysis(const SPairAnalysis &analysis);
    void UpdatePairAnalysis(int index, const SPairAnalysis &analysis);
    void SortPairsByOpportunity();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPairManager::CPairManager()
{
    ArrayResize(m_pairAnalysis, 0);
    ArrayResize(m_activePairs, 0);
    m_lastFullAnalysis = 0;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPairManager::~CPairManager()
{
    ArrayFree(m_pairAnalysis);
    ArrayFree(m_activePairs);
}

//+------------------------------------------------------------------+
//| Initialize pair manager                                          |
//+------------------------------------------------------------------+
bool CPairManager::Initialize()
{
    CConfig::LogInfo("Initializing Pair Manager");
    
    //--- Clear existing data
    ClearAnalysis();
    
    //--- Get trading pairs from config and initialize pairs array
    string pairs[];
    int maxPairs = CConfig::GetMaxConcurrentPairs();
    if(maxPairs <= 0)
    {
        CConfig::LogError("Invalid max pairs value: " + IntegerToString(maxPairs));
        return false;
    }
    
    ArrayResize(pairs, maxPairs);
    CConfig::GetTradingPairs(pairs);
    
    //--- Initialize analysis for each pair
    for(int i = 0; i < ArraySize(pairs); i++)
    {
        if(StringLen(pairs[i]) > 0 && CConfig::IsValidSymbol(pairs[i]))
        {
            SPairAnalysis analysis;
            analysis.symbol = pairs[i];
            analysis.volatility = 0.0;
            analysis.momentum = 0.0;
            analysis.trend_strength = 0.0;
            analysis.liquidity_score = 0.0;
            analysis.opportunity_score = 0.0;
            analysis.last_update = 0;
            analysis.is_trending = false;
            analysis.has_opportunity = false;
            
            AddPairAnalysis(analysis);
        }
        else
        {
            CConfig::LogError("Invalid symbol in trading pairs: " + pairs[i]);
        }
    }
    
    CConfig::LogInfo(StringFormat("Pair Manager initialized with %d pairs", ArraySize(m_pairAnalysis)));
    return true;
}

//+------------------------------------------------------------------+
//| Analyze all trading pairs                                        |
//+------------------------------------------------------------------+
bool CPairManager::AnalyzeAllPairs()
{
    datetime currentTime = TimeCurrent();
    
    //--- Check if enough time has passed since last full analysis
    if(currentTime - m_lastFullAnalysis < 300) // 5 minutes minimum
        return true;
    
    m_lastFullAnalysis = currentTime;
    
    CConfig::LogDebug("Starting full pair analysis");
    
    //--- Analyze each pair
    for(int i = 0; i < ArraySize(m_pairAnalysis); i++)
    {
        if(!AnalyzePair(m_pairAnalysis[i].symbol))
        {
            CConfig::LogError("Failed to analyze pair: " + m_pairAnalysis[i].symbol);
        }
    }
    
    //--- Sort pairs by opportunity score
    SortPairsByOpportunity();
    
    //--- Update active pairs list
    ArrayResize(m_activePairs, 0);
    int maxPairs = CConfig::GetMaxConcurrentPairs();
    
    for(int i = 0; i < ArraySize(m_pairAnalysis) && ArraySize(m_activePairs) < maxPairs; i++)
    {
        if(m_pairAnalysis[i].has_opportunity && IsMarketOpen(m_pairAnalysis[i].symbol))
        {
            ArrayResize(m_activePairs, ArraySize(m_activePairs) + 1);
            m_activePairs[ArraySize(m_activePairs) - 1] = m_pairAnalysis[i].symbol;
        }
    }
    
    CConfig::LogInfo(StringFormat("Analysis complete. Active pairs: %d", ArraySize(m_activePairs)));
    
    return true;
}

//+------------------------------------------------------------------+
//| Analyze specific pair                                            |
//+------------------------------------------------------------------+
bool CPairManager::AnalyzePair(string symbol)
{
    if(!CConfig::IsValidSymbol(symbol))
        return false;
    
    //--- Find existing analysis
    int index = FindAnalysisIndex(symbol);
    if(index < 0)
        return false;
    
    //--- Calculate analysis metrics
    SPairAnalysis analysis = m_pairAnalysis[index];
    analysis.volatility = CalculateVolatility(symbol);
    analysis.momentum = CalculateMomentum(symbol);
    analysis.trend_strength = CalculateTrendStrength(symbol);
    analysis.liquidity_score = CalculateLiquidityScore(symbol);
    analysis.last_update = TimeCurrent();
    analysis.is_trending = IsTrending(symbol);
    
    //--- Calculate overall opportunity score
    analysis.opportunity_score = CalculateOpportunityScore(analysis);
    analysis.has_opportunity = HasOpportunity(analysis);
    
    //--- Update analysis
    UpdatePairAnalysis(index, analysis);
    
    return true;
}

//+------------------------------------------------------------------+
//| Get best pairs for trading                                       |
//+------------------------------------------------------------------+
bool CPairManager::GetBestPairs(string &pairs[])
{
    // Get the max pairs from config
    int maxPairs = CConfig::GetMaxConcurrentPairs();
    if(maxPairs <= 0)
    {
        CConfig::LogError("Invalid max pairs value in GetBestPairs: " + IntegerToString(maxPairs));
        return false;
    }
    
    // Ensure pairs array is sized properly
    if(ArraySize(pairs) < maxPairs)
        ArrayResize(pairs, maxPairs);
    
    // Initialize array with empty strings
    for(int i = 0; i < maxPairs; i++)
        pairs[i] = "";
        
    // Copy active pairs up to max limit
    int activePairsCount = MathMin(ArraySize(m_activePairs), maxPairs);
    for(int i = 0; i < activePairsCount; i++)
        pairs[i] = m_activePairs[i];
        
    return activePairsCount > 0;
}

//+------------------------------------------------------------------+
//| Handle tick for specific pair                                    |
//+------------------------------------------------------------------+
void CPairManager::OnTick(string symbol)
{
    //--- Update pair analysis if it's an active pair
    if(IsActivePair(symbol))
    {
        int index = FindAnalysisIndex(symbol);
        if(index >= 0)
        {
            //--- Quick update for tick-based metrics
            m_pairAnalysis[index].liquidity_score = CalculateLiquidityScore(symbol);
        }
    }
}

//+------------------------------------------------------------------+
//| Calculate volatility                                             |
//+------------------------------------------------------------------+
double CPairManager::CalculateVolatility(string symbol)
{
    double sum = 0.0;
    int period = 20;
    
    for(int i = 1; i <= period; i++)
    {
        double high = iHigh(symbol, PERIOD_H1, i);
        double low = iLow(symbol, PERIOD_H1, i);
        sum += (high - low);
    }
    
    double avgRange = sum / period;
    double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    return avgRange / point; // Return in points
}

//+------------------------------------------------------------------+
//| Calculate momentum                                               |
//+------------------------------------------------------------------+
double CPairManager::CalculateMomentum(string symbol)
{
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double ma10 = GetMA(symbol, PERIOD_H1, 10);
    double ma20 = GetMA(symbol, PERIOD_H1, 20);
    
    if(ma20 == 0)
        return 0.0;
    
    //--- Price momentum relative to moving averages
    double priceMomentum = (currentPrice - ma10) / ma10 * 100;
    double maMomentum = (ma10 - ma20) / ma20 * 100;
    
    return (priceMomentum + maMomentum) / 2.0;
}

//+------------------------------------------------------------------+
//| Calculate trend strength                                         |
//+------------------------------------------------------------------+
double CPairManager::CalculateTrendStrength(string symbol)
{
    double adx = GetADX(symbol, PERIOD_H1, 14);
    return adx / 100.0; // Normalize to 0-1 range
}

//+------------------------------------------------------------------+
//| Calculate liquidity score                                        |
//+------------------------------------------------------------------+
double CPairManager::CalculateLiquidityScore(string symbol)
{
    //--- Get spread
    double spread = GetSpread(symbol);
    double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
    double spreadPoints = spread / point;
    
    //--- Get tick volume (if available)
    double volume = iVolume(symbol, PERIOD_M1, 0);
    
    //--- Calculate liquidity score (lower spread + higher volume = better liquidity)
    double spreadScore = 1.0 / (1.0 + spreadPoints / 10.0); // Normalize spread impact
    double volumeScore = MathMin(volume / 1000.0, 1.0); // Normalize volume
    
    return (spreadScore + volumeScore) / 2.0;
}

//+------------------------------------------------------------------+
//| Calculate overall opportunity score                              |
//+------------------------------------------------------------------+
double CPairManager::CalculateOpportunityScore(const SPairAnalysis &analysis)
{
    //--- Weight factors
    double volatilityWeight = 0.25;
    double momentumWeight = 0.30;
    double trendWeight = 0.25;
    double liquidityWeight = 0.20;
    
    //--- Normalize volatility (higher is better up to a point)
    double volScore = MathMin(analysis.volatility / 100.0, 1.0);
    
    //--- Normalize momentum (absolute value, stronger momentum is better)
    double momScore = MathMin(MathAbs(analysis.momentum) / 50.0, 1.0);
    
    //--- Trend strength is already normalized
    double trendScore = analysis.trend_strength;
    
    //--- Liquidity score is already normalized
    double liqScore = analysis.liquidity_score;
    
    //--- Calculate weighted score
    double score = (volScore * volatilityWeight) + 
                   (momScore * momentumWeight) + 
                   (trendScore * trendWeight) + 
                   (liqScore * liquidityWeight);
    
    return MathMin(score, 1.0);
}

//+------------------------------------------------------------------+
//| Check if pair is trending                                        |
//+------------------------------------------------------------------+
bool CPairManager::IsTrending(string symbol)
{
    double adx = GetADX(symbol, PERIOD_H1, 14);
    return adx > 25.0; // ADX above 25 indicates trending market
}

//+------------------------------------------------------------------+
//| Check if pair has trading opportunity                            |
//+------------------------------------------------------------------+
bool CPairManager::HasOpportunity(const SPairAnalysis &analysis)
{
    //--- Minimum thresholds for opportunity
    return analysis.opportunity_score > 0.4 && 
           analysis.liquidity_score > 0.3 &&
           analysis.is_trending;
}

//+------------------------------------------------------------------+
//| Get moving average                                               |
//+------------------------------------------------------------------+
double CPairManager::GetMA(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0)
{
    double sum = 0.0;
    
    for(int i = shift; i < shift + period; i++)
    {
        sum += iClose(symbol, timeframe, i);
    }
    
    return sum / period;
}

//+------------------------------------------------------------------+
//| Get RSI                                                          |
//+------------------------------------------------------------------+
double CPairManager::GetRSI(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0)
{
    double gains = 0.0;
    double losses = 0.0;
    
    for(int i = shift + 1; i < shift + period + 1; i++)
    {
        double change = iClose(symbol, timeframe, i - 1) - iClose(symbol, timeframe, i);
        if(change > 0)
            gains += change;
        else
            losses += MathAbs(change);
    }
    
    if(losses == 0)
        return 100.0;
    
    double avgGain = gains / period;
    double avgLoss = losses / period;
    double rs = avgGain / avgLoss;
    
    return 100.0 - (100.0 / (1.0 + rs));
}

//+------------------------------------------------------------------+
//| Get ADX (simplified calculation)                                 |
//+------------------------------------------------------------------+
double CPairManager::GetADX(string symbol, ENUM_TIMEFRAMES timeframe, int period, int shift = 0)
{
    double sumDM = 0.0;
    double sumTR = 0.0;
    
    for(int i = shift + 1; i < shift + period + 1; i++)
    {
        double high = iHigh(symbol, timeframe, i);
        double low = iLow(symbol, timeframe, i);
        double prevHigh = iHigh(symbol, timeframe, i + 1);
        double prevLow = iLow(symbol, timeframe, i + 1);
        double prevClose = iClose(symbol, timeframe, i + 1);
        
        double dmPlus = (high > prevHigh) ? high - prevHigh : 0;
        double dmMinus = (low < prevLow) ? prevLow - low : 0;
        
        double tr = MathMax(high - low, MathMax(MathAbs(high - prevClose), MathAbs(low - prevClose)));
        
        sumDM += MathAbs(dmPlus - dmMinus);
        sumTR += tr;
    }
    
    if(sumTR == 0)
        return 0.0;
    
    return (sumDM / sumTR) * 100.0;
}

//+------------------------------------------------------------------+
//| Get current spread                                               |
//+------------------------------------------------------------------+
double CPairManager::GetSpread(string symbol)
{
    double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
    return ask - bid;
}

//+------------------------------------------------------------------+
//| Check if market is open for symbol                               |
//+------------------------------------------------------------------+
bool CPairManager::IsMarketOpen(string symbol)
{
    datetime currentTime = TimeCurrent();
    datetime from, to;
    
    //--- Get trading session info
    if(SymbolInfoSessionTrade(symbol, MONDAY, 0, from, to))
    {
        MqlDateTime dt;
        TimeToStruct(currentTime, dt);
        
        //--- Simple check - assume market is open during weekdays
        return (dt.day_of_week >= 1 && dt.day_of_week <= 5);
    }
    
    return true; // Default to open if can't determine
}

//+------------------------------------------------------------------+
//| Find analysis index for symbol                                   |
//+------------------------------------------------------------------+
int CPairManager::FindAnalysisIndex(string symbol)
{
    for(int i = 0; i < ArraySize(m_pairAnalysis); i++)
    {
        if(m_pairAnalysis[i].symbol == symbol)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Add pair analysis                                                |
//+------------------------------------------------------------------+
void CPairManager::AddPairAnalysis(const SPairAnalysis &analysis)
{
    ArrayResize(m_pairAnalysis, ArraySize(m_pairAnalysis) + 1);
    m_pairAnalysis[ArraySize(m_pairAnalysis) - 1] = analysis;
}

//+------------------------------------------------------------------+
//| Update pair analysis                                             |
//+------------------------------------------------------------------+
void CPairManager::UpdatePairAnalysis(int index, const SPairAnalysis &analysis)
{
    if(index >= 0 && index < ArraySize(m_pairAnalysis))
        m_pairAnalysis[index] = analysis;
}

//+------------------------------------------------------------------+
//| Sort pairs by opportunity score                                  |
//+------------------------------------------------------------------+
void CPairManager::SortPairsByOpportunity()
{
    //--- Simple bubble sort by opportunity score (descending)
    for(int i = 0; i < ArraySize(m_pairAnalysis) - 1; i++)
    {
        for(int j = 0; j < ArraySize(m_pairAnalysis) - 1 - i; j++)
        {
            if(m_pairAnalysis[j].opportunity_score < m_pairAnalysis[j + 1].opportunity_score)
            {
                SPairAnalysis temp = m_pairAnalysis[j];
                m_pairAnalysis[j] = m_pairAnalysis[j + 1];
                m_pairAnalysis[j + 1] = temp;
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Get pair analysis                                                |
//+------------------------------------------------------------------+
bool CPairManager::GetPairAnalysis(string symbol, SPairAnalysis &analysis)
{
    int index = FindAnalysisIndex(symbol);
    if(index >= 0)
    {
        analysis = m_pairAnalysis[index];
        return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Check if pair is active                                          |
//+------------------------------------------------------------------+
bool CPairManager::IsActivePair(string symbol)
{
    for(int i = 0; i < ArraySize(m_activePairs); i++)
    {
        if(m_activePairs[i] == symbol)
            return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Get active pair count                                            |
//+------------------------------------------------------------------+
int CPairManager::GetActivePairCount()
{
    return ArraySize(m_activePairs);
}

//+------------------------------------------------------------------+
//| Get active pairs                                                 |
//+------------------------------------------------------------------+
void CPairManager::GetActivePairs(string &pairs[])
{
    ArrayCopy(pairs, m_activePairs);
}

//+------------------------------------------------------------------+
//| Clear all analysis                                               |
//+------------------------------------------------------------------+
void CPairManager::ClearAnalysis()
{
    ArrayResize(m_pairAnalysis, 0);
    ArrayResize(m_activePairs, 0);
}

//+------------------------------------------------------------------+
//| Update pair status                                               |
//+------------------------------------------------------------------+
void CPairManager::UpdatePairStatus(string symbol, bool isActive)
{
    if(isActive && !IsActivePair(symbol))
    {
        ArrayResize(m_activePairs, ArraySize(m_activePairs) + 1);
        m_activePairs[ArraySize(m_activePairs) - 1] = symbol;
    }
    else if(!isActive && IsActivePair(symbol))
    {
        for(int i = 0; i < ArraySize(m_activePairs); i++)
        {
            if(m_activePairs[i] == symbol)
            {
                ArrayRemove(m_activePairs, i, 1);
                break;
            }
        }
    }
}