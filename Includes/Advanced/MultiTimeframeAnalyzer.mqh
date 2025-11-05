//+------------------------------------------------------------------+
//|                                      MultiTimeframeAnalyzer.mqh |
//|                                   Advanced Multi-TF Analysis    |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Multi-TF Signal Structure                                       |
//+------------------------------------------------------------------+
struct MTFSignal
{
    ENUM_ORDER_TYPE direction;
    double confidence;
    string reasoning;
    int timeframesAligned;
    int totalTimeframes;
    double entryPrice;
    double stopLoss;
    double takeProfit;
    bool isValid;
};

//+------------------------------------------------------------------+
//| Multi-Timeframe Analysis Class                                 |
//+------------------------------------------------------------------+
class CMultiTimeframeAnalyzer
{
private:
    //--- Timeframe structure
    struct TimeframeData
    {
        ENUM_TIMEFRAMES timeframe;
        string trendDirection;
        double trendStrength;
        double momentum;
        double volatility;
        double support;
        double resistance;
        bool isBullish;
        bool isBearish;
        bool isNeutral;
        int signalStrength;
        datetime lastUpdate;
    };
    
    TimeframeData m_timeframes[9]; // M1, M5, M15, M30, H1, H4, D1, W1, MN1
    int m_timeframeCount;
    
    //--- Multi-TF signal instance
    MTFSignal m_signal;
    
    //--- Confluence analysis
    struct ConfluenceLevel
    {
        double price;
        int supportingTimeframes;
        string levelType; // "SUPPORT", "RESISTANCE", "PIVOT"
        double strength;
        bool isActive;
    };
    
    ConfluenceLevel m_confluenceLevels[50];
    int m_confluenceCount;
    
    //--- Timeframe weights
    double m_timeframeWeights[9];
    
    //--- Higher timeframe bias
    string m_higherTFBias;
    double m_higherTFStrength;

public:
    //--- Constructor
    CMultiTimeframeAnalyzer();
    
    //--- Initialization
    bool Initialize(string symbol);
    void SetTimeframeWeights();
    void ConfigureTimeframes();
    
    //--- Core analysis
    bool AnalyzeAllTimeframes(string symbol);
    bool AnalyzeTimeframe(string symbol, ENUM_TIMEFRAMES timeframe);
    string GetTimeframeTrend(string symbol, ENUM_TIMEFRAMES timeframe);
    double GetTimeframeMomentum(string symbol, ENUM_TIMEFRAMES timeframe);
    double GetTimeframeVolatility(string symbol, ENUM_TIMEFRAMES timeframe);
    
    //--- Trend analysis
    bool AnalyzeTrendAlignment(string symbol);
    int CountBullishTimeframes();
    int CountBearishTimeframes();
    double GetTrendConsensus();
    bool IsStrongTrendAlignment();
    
    //--- Signal generation
    MTFSignal GenerateMultiTimeframeSignal(string symbol);
    ENUM_ORDER_TYPE GetPrimarySignal(string symbol);
    double GetSignalConfidence(string symbol);
    bool ValidateSignalAcrossTimeframes(string symbol, ENUM_ORDER_TYPE signal);
    
    //--- Confluence analysis
    void DetectConfluenceLevels(string symbol);
    bool IsConfluenceSupport(double price);
    bool IsConfluenceResistance(double price);
    double GetNearestConfluenceLevel(double currentPrice);
    int GetConfluenceStrength(double price);
    
    //--- Higher timeframe analysis
    void AnalyzeHigherTimeframeBias(string symbol);
    string GetHigherTimeframeBias() { return m_higherTFBias; }
    bool IsHigherTFBullish();
    bool IsHigherTFBearish();
    bool ShouldFollowHigherTF();
    
    //--- Entry timing
    bool IsOptimalEntryTime(string symbol, ENUM_ORDER_TYPE direction);
    double GetOptimalEntry(string symbol, ENUM_ORDER_TYPE direction);
    bool WaitForLowerTimeframeConfirmation(string symbol, ENUM_ORDER_TYPE direction);
    
    //--- Risk management
    double CalculateMultiTFStopLoss(string symbol, ENUM_ORDER_TYPE direction);
    double CalculateMultiTFTakeProfit(string symbol, ENUM_ORDER_TYPE direction);
    double GetRiskBasedOnTimeframes(string symbol);
    
    //--- Momentum analysis
    bool AnalyzeMomentumAlignment(string symbol);
    bool IsPositiveMomentumAlignment();
    bool IsNegativeMomentumAlignment();
    double GetMomentumDivergence(string symbol);
    
    //--- Support/Resistance across timeframes
    void CalculateMultiTFSupportResistance(string symbol);
    double GetStrongestSupport(double currentPrice);
    double GetStrongestResistance(double currentPrice);
    bool IsMultiTFBreakout(string symbol, double level);
    
    //--- Pattern recognition
    bool DetectMultiTFPatterns(string symbol);
    bool IsMultiTFReversal(string symbol);
    bool IsMultiTFContinuation(string symbol);
    bool DetectDivergenceAcrossTimeframes(string symbol);
    
    //--- Advanced features
    void ImplementTimeframeFilter(string symbol);
    bool IsTimeframeAlignmentStrong(double threshold = 70.0);
    void CalculateTimeframePriority(string symbol);
    bool CheckForContradictorySignals(string symbol);
    
    //--- Volatility analysis
    bool AnalyzeVolatilityAlignment(string symbol);
    bool IsLowVolatilityEnvironment();
    bool IsHighVolatilityEnvironment();
    double GetVolatilityConsensus();
    
    //--- Information functions
    TimeframeData GetTimeframeData(ENUM_TIMEFRAMES tf);
    MTFSignal GetCurrentSignal() { return m_signal; }
    int GetTimeframeCount() { return m_timeframeCount; }
    
    //--- Utility functions
    string TimeframeToString(ENUM_TIMEFRAMES tf);
    ENUM_TIMEFRAMES GetTimeframeByIndex(int index);
    bool IsHigherTimeframe(ENUM_TIMEFRAMES tf1, ENUM_TIMEFRAMES tf2);
    
    //--- Reporting
    void PrintMultiTimeframeAnalysis(string symbol);
    void PrintTimeframeAlignment();
    void PrintConfluenceLevels();
    string GetAnalysisSummary(string symbol);
    
    //--- Optimization
    void OptimizeTimeframeWeights(string symbol);
    void BacktestTimeframeStrategy(string symbol);
    void CalibrateTrendDetection(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMultiTimeframeAnalyzer::CMultiTimeframeAnalyzer()
{
    ConfigureTimeframes();
    SetTimeframeWeights();
    
    //--- Initialize signal
    m_signal.isValid = false;
    m_signal.confidence = 0.0;
    m_signal.timeframesAligned = 0;
    
    //--- Initialize confluence
    m_confluenceCount = 0;
    
    //--- Initialize higher TF bias
    m_higherTFBias = "NEUTRAL";
    m_higherTFStrength = 0.0;
    
    Print("⏰ Multi-Timeframe Analyzer initialized with ", m_timeframeCount, " timeframes");
}

//+------------------------------------------------------------------+
//| Configure timeframes                                           |
//+------------------------------------------------------------------+
void CMultiTimeframeAnalyzer::ConfigureTimeframes()
{
    m_timeframes[0].timeframe = PERIOD_M1;
    m_timeframes[1].timeframe = PERIOD_M5;
    m_timeframes[2].timeframe = PERIOD_M15;
    m_timeframes[3].timeframe = PERIOD_M30;
    m_timeframes[4].timeframe = PERIOD_H1;
    m_timeframes[5].timeframe = PERIOD_H4;
    m_timeframes[6].timeframe = PERIOD_D1;
    m_timeframes[7].timeframe = PERIOD_W1;
    m_timeframes[8].timeframe = PERIOD_MN1;
    
    m_timeframeCount = 9;
    
    //--- Initialize each timeframe
    for(int i = 0; i < m_timeframeCount; i++)
    {
        m_timeframes[i].trendDirection = "NEUTRAL";
        m_timeframes[i].trendStrength = 0.0;
        m_timeframes[i].momentum = 0.0;
        m_timeframes[i].volatility = 0.0;
        m_timeframes[i].isBullish = false;
        m_timeframes[i].isBearish = false;
        m_timeframes[i].isNeutral = true;
        m_timeframes[i].signalStrength = 0;
    }
}

//+------------------------------------------------------------------+
//| Set timeframe weights                                          |
//+------------------------------------------------------------------+
void CMultiTimeframeAnalyzer::SetTimeframeWeights()
{
    //--- Higher timeframes have more weight
    m_timeframeWeights[0] = 0.05; // M1
    m_timeframeWeights[1] = 0.08; // M5
    m_timeframeWeights[2] = 0.10; // M15
    m_timeframeWeights[3] = 0.12; // M30
    m_timeframeWeights[4] = 0.15; // H1
    m_timeframeWeights[5] = 0.20; // H4
    m_timeframeWeights[6] = 0.15; // D1
    m_timeframeWeights[7] = 0.10; // W1
    m_timeframeWeights[8] = 0.05; // MN1
    
    Print("⚖️ Timeframe weights configured (H4 highest priority)");
}

//+------------------------------------------------------------------+
//| Initialize analyzer                                            |
//+------------------------------------------------------------------+
bool CMultiTimeframeAnalyzer::Initialize(string symbol)
{
    //--- Analyze all timeframes initially
    if(!AnalyzeAllTimeframes(symbol))
    {
        Print("❌ Failed to analyze timeframes for ", symbol);
        return false;
    }
    
    //--- Detect confluence levels
    DetectConfluenceLevels(symbol);
    
    //--- Analyze higher timeframe bias
    AnalyzeHigherTimeframeBias(symbol);
    
    Print("✅ Multi-Timeframe Analyzer initialized for ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Analyze all timeframes                                        |
//+------------------------------------------------------------------+
bool CMultiTimeframeAnalyzer::AnalyzeAllTimeframes(string symbol)
{
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(!AnalyzeTimeframe(symbol, m_timeframes[i].timeframe))
        {
            Print("⚠️ Failed to analyze ", TimeframeToString(m_timeframes[i].timeframe));
            continue;
        }
        
        m_timeframes[i].lastUpdate = TimeCurrent();
    }
    
    //--- Analyze trend alignment
    AnalyzeTrendAlignment(symbol);
    
    //--- Generate multi-timeframe signal
    m_signal = GenerateMultiTimeframeSignal(symbol);
    
    Print("📊 Analyzed ", m_timeframeCount, " timeframes for ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Analyze single timeframe                                      |
//+------------------------------------------------------------------+
bool CMultiTimeframeAnalyzer::AnalyzeTimeframe(string symbol, ENUM_TIMEFRAMES timeframe)
{
    int tfIndex = -1;
    
    //--- Find timeframe index
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(m_timeframes[i].timeframe == timeframe)
        {
            tfIndex = i;
            break;
        }
    }
    
    if(tfIndex == -1) return false;
    
    //--- Get trend direction
    m_timeframes[tfIndex].trendDirection = GetTimeframeTrend(symbol, timeframe);
    
    //--- Calculate momentum
    m_timeframes[tfIndex].momentum = GetTimeframeMomentum(symbol, timeframe);
    
    //--- Calculate volatility
    m_timeframes[tfIndex].volatility = GetTimeframeVolatility(symbol, timeframe);
    
    //--- Calculate trend strength using ADX
    int adxHandle = iADX(symbol, timeframe, 14);
    double adx = 50.0; // Default value
    if(adxHandle != INVALID_HANDLE)
    {
        double adxBuffer[];
        ArraySetAsSeries(adxBuffer, true);
        if(CopyBuffer(adxHandle, 0, 0, 1, adxBuffer) > 0)
            adx = adxBuffer[0];
    }
    m_timeframes[tfIndex].trendStrength = adx;
    
    //--- Determine trend bias
    if(m_timeframes[tfIndex].trendDirection == "BULLISH")
    {
        m_timeframes[tfIndex].isBullish = true;
        m_timeframes[tfIndex].isBearish = false;
        m_timeframes[tfIndex].isNeutral = false;
        m_timeframes[tfIndex].signalStrength = (int)(adx / 10);
    }
    else if(m_timeframes[tfIndex].trendDirection == "BEARISH")
    {
        m_timeframes[tfIndex].isBullish = false;
        m_timeframes[tfIndex].isBearish = true;
        m_timeframes[tfIndex].isNeutral = false;
        m_timeframes[tfIndex].signalStrength = (int)(adx / 10);
    }
    else
    {
        m_timeframes[tfIndex].isBullish = false;
        m_timeframes[tfIndex].isBearish = false;
        m_timeframes[tfIndex].isNeutral = true;
        m_timeframes[tfIndex].signalStrength = 0;
    }
    
    //--- Calculate support and resistance
    int highestBar = iHighest(symbol, timeframe, MODE_HIGH, 20, 0);
    int lowestBar = iLowest(symbol, timeframe, MODE_LOW, 20, 0);
    
    m_timeframes[tfIndex].resistance = iHigh(symbol, timeframe, highestBar);
    m_timeframes[tfIndex].support = iLow(symbol, timeframe, lowestBar);
    
    return true;
}

//+------------------------------------------------------------------+
//| Get timeframe trend                                           |
//+------------------------------------------------------------------+
string CMultiTimeframeAnalyzer::GetTimeframeTrend(string symbol, ENUM_TIMEFRAMES timeframe)
{
    //--- Use multiple indicators for trend determination
    // Get SMA20
    int sma20Handle = iMA(symbol, timeframe, 20, 0, MODE_SMA);
    double sma20 = 0.0;
    if(sma20Handle != INVALID_HANDLE)
    {
        double sma20Buffer[];
        ArraySetAsSeries(sma20Buffer, true);
        if(CopyBuffer(sma20Handle, 0, 0, 1, sma20Buffer) > 0)
            sma20 = sma20Buffer[0];
    }
    
    // Get SMA50
    int sma50Handle = iMA(symbol, timeframe, 50, 0, MODE_SMA);
    double sma50 = 0.0;
    if(sma50Handle != INVALID_HANDLE)
    {
        double sma50Buffer[];
        ArraySetAsSeries(sma50Buffer, true);
        if(CopyBuffer(sma50Handle, 0, 0, 1, sma50Buffer) > 0)
            sma50 = sma50Buffer[0];
    }
    
    // Get EMA20
    int ema20Handle = iMA(symbol, timeframe, 20, 0, MODE_EMA);
    double ema20 = 0.0;
    if(ema20Handle != INVALID_HANDLE)
    {
        double ema20Buffer[];
        ArraySetAsSeries(ema20Buffer, true);
        if(CopyBuffer(ema20Handle, 0, 0, 1, ema20Buffer) > 0)
            ema20 = ema20Buffer[0];
    }
    
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    int bullishSignals = 0;
    int bearishSignals = 0;
    
    //--- Price vs MA signals
    if(currentPrice > sma20) bullishSignals++;
    else bearishSignals++;
    
    if(currentPrice > sma50) bullishSignals++;
    else bearishSignals++;
    
    if(currentPrice > ema20) bullishSignals++;
    else bearishSignals++;
    
    //--- MA alignment
    if(sma20 > sma50) bullishSignals++;
    else bearishSignals++;
    
    //--- MACD signal
    int macdHandle = iMACD(symbol, timeframe, 12, 26, 9);
    double macd_main = 0.0;
    double macd_signal = 0.0;
    
    if(macdHandle != INVALID_HANDLE)
    {
        double macdMainBuffer[], macdSignalBuffer[];
        ArraySetAsSeries(macdMainBuffer, true);
        ArraySetAsSeries(macdSignalBuffer, true);
        if(CopyBuffer(macdHandle, 0, 0, 1, macdMainBuffer) > 0)
            macd_main = macdMainBuffer[0];
        if(CopyBuffer(macdHandle, 1, 0, 1, macdSignalBuffer) > 0)
            macd_signal = macdSignalBuffer[0];
    }
    
    if(macd_main > macd_signal) bullishSignals++;
    else bearishSignals++;
    
    //--- Determine trend
    if(bullishSignals >= 4)
        return "BULLISH";
    else if(bearishSignals >= 4)
        return "BEARISH";
    else
        return "NEUTRAL";
}

//+------------------------------------------------------------------+
//| Get timeframe momentum                                         |
//+------------------------------------------------------------------+
double CMultiTimeframeAnalyzer::GetTimeframeMomentum(string symbol, ENUM_TIMEFRAMES timeframe)
{
    //--- Use RSI and ROC for momentum
    double rsi = iRSI(symbol, timeframe, 14, 0);
    
    //--- Calculate Rate of Change
    double currentPrice = iClose(symbol, timeframe, 0);
    double pastPrice = iClose(symbol, timeframe, 10);
    double roc = ((currentPrice - pastPrice) / pastPrice) * 100;
    
    //--- Combine momentum indicators
    double momentum = (rsi - 50) + (roc * 10);
    
    return momentum;
}

//+------------------------------------------------------------------+
//| Get timeframe volatility                                      |
//+------------------------------------------------------------------+
double CMultiTimeframeAnalyzer::GetTimeframeVolatility(string symbol, ENUM_TIMEFRAMES timeframe)
{
    double atr = iATR(symbol, timeframe, 14);
    double price = iClose(symbol, timeframe, 0);
    
    //--- Convert to percentage volatility
    return (atr / price) * 100;
}

//+------------------------------------------------------------------+
//| Analyze trend alignment                                        |
//+------------------------------------------------------------------+
bool CMultiTimeframeAnalyzer::AnalyzeTrendAlignment(string symbol)
{
    int bullishCount = CountBullishTimeframes();
    int bearishCount = CountBearishTimeframes();
    int neutralCount = m_timeframeCount - bullishCount - bearishCount;
    
    Print("📈 Trend alignment: Bullish=", bullishCount, ", Bearish=", bearishCount, ", Neutral=", neutralCount);
    
    return true;
}

//+------------------------------------------------------------------+
//| Count bullish timeframes                                      |
//+------------------------------------------------------------------+
int CMultiTimeframeAnalyzer::CountBullishTimeframes()
{
    int count = 0;
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(m_timeframes[i].isBullish)
            count++;
    }
    return count;
}

//+------------------------------------------------------------------+
//| Count bearish timeframes                                      |
//+------------------------------------------------------------------+
int CMultiTimeframeAnalyzer::CountBearishTimeframes()
{
    int count = 0;
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(m_timeframes[i].isBearish)
            count++;
    }
    return count;
}

//+------------------------------------------------------------------+
//| Generate multi-timeframe signal                               |
//+------------------------------------------------------------------+
MTFSignal CMultiTimeframeAnalyzer::GenerateMultiTimeframeSignal(string symbol)
{
    MTFSignal signal;
    signal.isValid = false;
    signal.confidence = 0.0;
    signal.timeframesAligned = 0;
    signal.totalTimeframes = m_timeframeCount;
    
    int bullishCount = CountBullishTimeframes();
    int bearishCount = CountBearishTimeframes();
    
    //--- Calculate weighted signal strength
    double bullishWeight = 0.0;
    double bearishWeight = 0.0;
    
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(m_timeframes[i].isBullish)
        {
            bullishWeight += m_timeframeWeights[i] * m_timeframes[i].signalStrength;
        }
        else if(m_timeframes[i].isBearish)
        {
            bearishWeight += m_timeframeWeights[i] * m_timeframes[i].signalStrength;
        }
    }
    
    //--- Determine signal direction
    if(bullishWeight > bearishWeight && bullishCount >= 6)
    {
        signal.direction = ORDER_TYPE_BUY;
        signal.timeframesAligned = bullishCount;
        signal.confidence = (bullishWeight / (bullishWeight + bearishWeight)) * 100;
        signal.reasoning = "Strong bullish alignment across " + IntegerToString(bullishCount) + " timeframes";
        signal.isValid = true;
    }
    else if(bearishWeight > bullishWeight && bearishCount >= 6)
    {
        signal.direction = ORDER_TYPE_SELL;
        signal.timeframesAligned = bearishCount;
        signal.confidence = (bearishWeight / (bullishWeight + bearishWeight)) * 100;
        signal.reasoning = "Strong bearish alignment across " + IntegerToString(bearishCount) + " timeframes";
        signal.isValid = true;
    }
    else
    {
        signal.reasoning = "Insufficient timeframe alignment for signal";
    }
    
    //--- Set entry levels if signal is valid
    if(signal.isValid)
    {
        signal.entryPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
        signal.stopLoss = CalculateMultiTFStopLoss(symbol, signal.direction);
        signal.takeProfit = CalculateMultiTFTakeProfit(symbol, signal.direction);
    }
    
    return signal;
}

//+------------------------------------------------------------------+
//| Detect confluence levels                                      |
//+------------------------------------------------------------------+
void CMultiTimeframeAnalyzer::DetectConfluenceLevels(string symbol)
{
    m_confluenceCount = 0;
    
    //--- Collect all support and resistance levels
    double levels[100];
    int levelCount = 0;
    
    for(int i = 0; i < m_timeframeCount; i++)
    {
        if(levelCount < 98)
        {
            levels[levelCount] = m_timeframes[i].support;
            levels[levelCount + 1] = m_timeframes[i].resistance;
            levelCount += 2;
        }
    }
    
    //--- Find confluence zones (levels close to each other)
    for(int i = 0; i < levelCount && m_confluenceCount < 50; i++)
    {
        double currentLevel = levels[i];
        int supportingTFs = 1;
        
        //--- Count how many timeframes support this level
        for(int j = i + 1; j < levelCount; j++)
        {
            if(MathAbs(levels[j] - currentLevel) <= (currentLevel * 0.001)) // 0.1% tolerance
            {
                supportingTFs++;
                levels[j] = 0; // Mark as processed
            }
        }
        
        //--- Add to confluence if supported by multiple timeframes
        if(supportingTFs >= 3)
        {
            m_confluenceLevels[m_confluenceCount].price = currentLevel;
            m_confluenceLevels[m_confluenceCount].supportingTimeframes = supportingTFs;
            m_confluenceLevels[m_confluenceCount].strength = supportingTFs * 10;
            m_confluenceLevels[m_confluenceCount].isActive = true;
            
            double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
            if(currentLevel > currentPrice)
                m_confluenceLevels[m_confluenceCount].levelType = "RESISTANCE";
            else
                m_confluenceLevels[m_confluenceCount].levelType = "SUPPORT";
            
            m_confluenceCount++;
        }
        
        levels[i] = 0; // Mark as processed
    }
    
    Print("🎯 Detected ", m_confluenceCount, " confluence levels for ", symbol);
}

//+------------------------------------------------------------------+
//| Analyze higher timeframe bias                                 |
//+------------------------------------------------------------------+
void CMultiTimeframeAnalyzer::AnalyzeHigherTimeframeBias(string symbol)
{
    //--- Focus on H4, D1, W1 for higher timeframe bias
    int htfBullish = 0;
    int htfBearish = 0;
    double htfStrength = 0;
    
    for(int i = 5; i < 8; i++) // H4, D1, W1
    {
        if(m_timeframes[i].isBullish)
        {
            htfBullish++;
            htfStrength += m_timeframes[i].trendStrength;
        }
        else if(m_timeframes[i].isBearish)
        {
            htfBearish++;
            htfStrength += m_timeframes[i].trendStrength;
        }
    }
    
    if(htfBullish >= 2)
    {
        m_higherTFBias = "BULLISH";
        m_higherTFStrength = htfStrength / 3;
    }
    else if(htfBearish >= 2)
    {
        m_higherTFBias = "BEARISH";
        m_higherTFStrength = htfStrength / 3;
    }
    else
    {
        m_higherTFBias = "NEUTRAL";
        m_higherTFStrength = 0;
    }
    
    Print("📈 Higher TF bias: ", m_higherTFBias, " (Strength: ", DoubleToString(m_higherTFStrength, 1), ")");
}

//+------------------------------------------------------------------+
//| Calculate multi-TF stop loss                                  |
//+------------------------------------------------------------------+
double CMultiTimeframeAnalyzer::CalculateMultiTFStopLoss(string symbol, ENUM_ORDER_TYPE direction)
{
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double stopLoss = 0;
    
    if(direction == ORDER_TYPE_BUY)
    {
        //--- Find nearest support level across timeframes
        double nearestSupport = currentPrice - (currentPrice * 0.02); // Default 2%
        
        for(int i = 0; i < m_timeframeCount; i++)
        {
            if(m_timeframes[i].support > 0 && m_timeframes[i].support < currentPrice)
            {
                if(m_timeframes[i].support > nearestSupport)
                    nearestSupport = m_timeframes[i].support;
            }
        }
        
        stopLoss = nearestSupport - (50 * Point()); // Add buffer
    }
    else if(direction == ORDER_TYPE_SELL)
    {
        //--- Find nearest resistance level across timeframes
        double nearestResistance = currentPrice + (currentPrice * 0.02); // Default 2%
        
        for(int i = 0; i < m_timeframeCount; i++)
        {
            if(m_timeframes[i].resistance > 0 && m_timeframes[i].resistance > currentPrice)
            {
                if(m_timeframes[i].resistance < nearestResistance)
                    nearestResistance = m_timeframes[i].resistance;
            }
        }
        
        stopLoss = nearestResistance + (50 * Point()); // Add buffer
    }
    
    return stopLoss;
}

//+------------------------------------------------------------------+
//| Calculate multi-TF take profit                               |
//+------------------------------------------------------------------+
double CMultiTimeframeAnalyzer::CalculateMultiTFTakeProfit(string symbol, ENUM_ORDER_TYPE direction)
{
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double takeProfit = 0;
    
    //--- Use 2:1 or 3:1 risk/reward based on signal strength
    double stopLoss = CalculateMultiTFStopLoss(symbol, direction);
    double riskDistance = MathAbs(currentPrice - stopLoss);
    
    double rewardMultiplier = 2.0;
    if(m_signal.confidence > 80)
        rewardMultiplier = 3.0;
    
    if(direction == ORDER_TYPE_BUY)
    {
        takeProfit = currentPrice + (riskDistance * rewardMultiplier);
    }
    else if(direction == ORDER_TYPE_SELL)
    {
        takeProfit = currentPrice - (riskDistance * rewardMultiplier);
    }
    
    return takeProfit;
}

//+------------------------------------------------------------------+
//| Convert timeframe to string                                   |
//+------------------------------------------------------------------+
string CMultiTimeframeAnalyzer::TimeframeToString(ENUM_TIMEFRAMES tf)
{
    switch(tf)
    {
        case PERIOD_M1:  return "M1";
        case PERIOD_M5:  return "M5";
        case PERIOD_M15: return "M15";
        case PERIOD_M30: return "M30";
        case PERIOD_H1:  return "H1";
        case PERIOD_H4:  return "H4";
        case PERIOD_D1:  return "D1";
        case PERIOD_W1:  return "W1";
        case PERIOD_MN1: return "MN1";
        default:         return "UNKNOWN";
    }
}

//+------------------------------------------------------------------+
//| Print multi-timeframe analysis                               |
//+------------------------------------------------------------------+
void CMultiTimeframeAnalyzer::PrintMultiTimeframeAnalysis(string symbol)
{
    Print("═══════════════════════════════════════");
    Print("⏰ MULTI-TIMEFRAME ANALYSIS - ", symbol);
    Print("═══════════════════════════════════════");
    
    for(int i = 0; i < m_timeframeCount; i++)
    {
        Print(TimeframeToString(m_timeframes[i].timeframe), ": ", 
              m_timeframes[i].trendDirection, 
              " (Strength: ", DoubleToString(m_timeframes[i].trendStrength, 1), ")");
    }
    
    Print("───────────────────────────────────────");
    Print("📊 Bullish TFs: ", CountBullishTimeframes());
    Print("📉 Bearish TFs: ", CountBearishTimeframes());
    Print("📈 Higher TF Bias: ", m_higherTFBias);
    Print("🎯 Confluence Levels: ", m_confluenceCount);
    
    if(m_signal.isValid)
    {
        Print("🎯 MTF Signal: ", EnumToString(m_signal.direction));
        Print("💪 Confidence: ", DoubleToString(m_signal.confidence, 1), "%");
        Print("⚖️ Aligned TFs: ", m_signal.timeframesAligned, "/", m_signal.totalTimeframes);
        Print("📝 Reasoning: ", m_signal.reasoning);
    }
    else
    {
        Print("⚠️ No valid MTF signal");
    }
    
    Print("═══════════════════════════════════════");
}

//+------------------------------------------------------------------+
//| End of CMultiTimeframeAnalyzer class implementation             |
//+------------------------------------------------------------------+
