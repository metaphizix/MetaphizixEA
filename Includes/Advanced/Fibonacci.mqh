//+------------------------------------------------------------------+
//|                                                    Fibonacci.mqh |
//|                                   Advanced Fibonacci Analysis EA |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Fibonacci Analysis and Pattern Recognition Class                |
//+------------------------------------------------------------------+
class CFibonacci
{
private:
    //--- Fibonacci levels
    double m_fibLevels[13];
    string m_fibLabels[13];
    
    //--- Chart objects
    string m_objectPrefix;
    color m_levelColors[13];
    
    //--- Analysis parameters
    int m_swingHighPeriod;
    int m_swingLowPeriod;
    double m_minSwingSize;
    bool m_showLabels;
    bool m_extendLines;
    
    //--- Pattern recognition
    struct FibonacciPattern
    {
        string symbol;
        ENUM_TIMEFRAMES timeframe;
        datetime swingHighTime;
        datetime swingLowTime;
        double swingHigh;
        double swingLow;
        double currentPrice;
        double supportLevel;
        double resistanceLevel;
        int patternStrength;
        ENUM_ORDER_TYPE suggestedDirection;
        double entryLevel;
        double stopLoss;
        double takeProfit;
        bool isValid;
    };
    
    FibonacciPattern m_currentPattern;
    
    //--- Time-based analysis
    struct FibonacciTimeZone
    {
        datetime startTime;
        datetime projectedTimes[8];
        bool isActive;
        int strength;
    };
    
    FibonacciTimeZone m_timeZones[10];
    int m_activeTimeZones;

public:
    //--- Constructor
    CFibonacci();
    
    //--- Initialization
    bool Initialize(string symbol, ENUM_TIMEFRAMES timeframe);
    void SetParameters(int swingPeriod = 20, double minSwing = 50.0, bool showLabels = true);
    
    //--- Core Fibonacci calculations
    bool CalculateRetracementLevels(double high, double low, datetime highTime, datetime lowTime);
    bool CalculateExtensionLevels(double point1, double point2, double point3);
    bool CalculateProjectionLevels(double swing1High, double swing1Low, double swing2High);
    
    //--- Advanced analysis
    bool AnalyzeFibonacciPattern(string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectFibonacciCluster(double price, double tolerance = 5.0);
    bool ValidateFibonacciSupport(double level, int lookbackBars = 50);
    bool ValidateFibonacciResistance(double level, int lookbackBars = 50);
    
    //--- Pattern recognition
    bool DetectHarmonicPattern(string symbol);
    bool DetectGartleyPattern(double xA, double aB, double bC, double cD);
    bool DetectButterflyPattern(double xA, double aB, double bC, double cD);
    bool DetectBatPattern(double xA, double aB, double bC, double cD);
    bool DetectCrabPattern(double xA, double aB, double bC, double cD);
    
    //--- Time zone analysis
    bool CalculateFibonacciTimeZones(datetime startTime, datetime endTime);
    bool CheckTimeZoneSignal(datetime currentTime);
    
    //--- Multi-timeframe analysis
    bool AnalyzeMultiTimeframeFib(string symbol);
    double GetTimeframeConfluence(double price);
    
    //--- Drawing functions
    void DrawFibonacciLevels(string symbol, double high, double low, datetime highTime, datetime lowTime);
    void DrawFibonacciExtensions(double point1, double point2, double point3);
    void DrawFibonacciTimeZones(datetime startTime, datetime endTime);
    void DrawFibonacciArcs(double centerPrice, datetime centerTime, double radius);
    void DrawFibonacciFan(double startPrice, datetime startTime, double endPrice, datetime endTime);
    
    //--- Signal generation
    ENUM_ORDER_TYPE GetFibonacciSignal(string symbol);
    double GetOptimalEntry(ENUM_ORDER_TYPE orderType);
    double GetFibonacciStopLoss(ENUM_ORDER_TYPE orderType, double entryPrice);
    double GetFibonacciTakeProfit(ENUM_ORDER_TYPE orderType, double entryPrice);
    
    //--- Utility functions
    bool IsAtFibonacciLevel(double price, double tolerance = 3.0);
    double GetNearestFibonacciLevel(double price);
    int GetFibonacciStrength(double level);
    bool IsFibonacciBreakout(double price, double level);
    
    //--- Risk management
    double CalculateFibonacciRisk(double entryPrice, double stopLoss);
    double CalculateFibonacciReward(double entryPrice, double takeProfit);
    double GetRiskRewardRatio();
    
    //--- Information functions
    FibonacciPattern GetCurrentPattern() { return m_currentPattern; }
    string GetFibonacciLevelName(int index);
    double GetFibonacciLevel(int index);
    bool IsPatternValid() { return m_currentPattern.isValid; }
    
    //--- Cleanup
    void RemoveAllFibonacciObjects();
    void RemoveFibonacciObjects(string prefix);
    
    //--- Advanced features
    bool DetectFibonacciDivergence(string symbol, int period = 14);
    bool AnalyzeFibonacciMomentum(string symbol);
    double GetFibonacciVolatilityFilter();
    bool ValidateWithVolumeProfile(double fibLevel);
    
    //--- Machine learning integration
    bool TrainFibonacciModel(string symbol, int trainingPeriod = 1000);
    double PredictFibonacciAccuracy(double level);
    bool OptimizeFibonacciLevels(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CFibonacci::CFibonacci()
{
    //--- Initialize Fibonacci levels
    m_fibLevels[0] = 0.0;      m_fibLabels[0] = "0.0%";
    m_fibLevels[1] = 0.236;    m_fibLabels[1] = "23.6%";
    m_fibLevels[2] = 0.382;    m_fibLabels[2] = "38.2%";
    m_fibLevels[3] = 0.5;      m_fibLabels[3] = "50.0%";
    m_fibLevels[4] = 0.618;    m_fibLabels[4] = "61.8%";
    m_fibLevels[5] = 0.786;    m_fibLabels[5] = "78.6%";
    m_fibLevels[6] = 1.0;      m_fibLabels[6] = "100.0%";
    m_fibLevels[7] = 1.272;    m_fibLabels[7] = "127.2%";
    m_fibLevels[8] = 1.414;    m_fibLabels[8] = "141.4%";
    m_fibLevels[9] = 1.618;    m_fibLabels[9] = "161.8%";
    m_fibLevels[10] = 2.0;     m_fibLabels[10] = "200.0%";
    m_fibLevels[11] = 2.618;   m_fibLabels[11] = "261.8%";
    m_fibLevels[12] = 4.236;   m_fibLabels[12] = "423.6%";
    
    //--- Initialize colors
    m_levelColors[0] = clrSilver;
    m_levelColors[1] = clrDodgerBlue;
    m_levelColors[2] = clrLimeGreen;
    m_levelColors[3] = clrGold;
    m_levelColors[4] = clrOrange;
    m_levelColors[5] = clrTomato;
    m_levelColors[6] = clrRed;
    m_levelColors[7] = clrMagenta;
    m_levelColors[8] = clrBlueViolet;
    m_levelColors[9] = clrIndigo;
    m_levelColors[10] = clrDarkSlateGray;
    m_levelColors[11] = clrMaroon;
    m_levelColors[12] = clrDarkRed;
    
    //--- Initialize parameters
    m_objectPrefix = "Fib_" + IntegerToString(GetTickCount());
    m_swingHighPeriod = 20;
    m_swingLowPeriod = 20;
    m_minSwingSize = 50.0;
    m_showLabels = true;
    m_extendLines = true;
    m_activeTimeZones = 0;
    
    //--- Initialize pattern
    m_currentPattern.isValid = false;
    m_currentPattern.patternStrength = 0;
}

//+------------------------------------------------------------------+
//| Initialize Fibonacci analyzer                                   |
//+------------------------------------------------------------------+
bool CFibonacci::Initialize(string symbol, ENUM_TIMEFRAMES timeframe)
{
    m_currentPattern.symbol = symbol;
    m_currentPattern.timeframe = timeframe;
    
    Print("🔢 Fibonacci Analyzer initialized for ", symbol, " ", EnumToString(timeframe));
    return true;
}

//+------------------------------------------------------------------+
//| Set analysis parameters                                         |
//+------------------------------------------------------------------+
void CFibonacci::SetParameters(int swingPeriod = 20, double minSwing = 50.0, bool showLabels = true)
{
    m_swingHighPeriod = swingPeriod;
    m_swingLowPeriod = swingPeriod;
    m_minSwingSize = minSwing;
    m_showLabels = showLabels;
    
    Print("📊 Fibonacci parameters: Swing=", swingPeriod, ", MinSize=", minSwing, ", Labels=", showLabels);
}

//+------------------------------------------------------------------+
//| Calculate Fibonacci retracement levels                         |
//+------------------------------------------------------------------+
bool CFibonacci::CalculateRetracementLevels(double high, double low, datetime highTime, datetime lowTime)
{
    if(high <= low || high - low < m_minSwingSize * Point())
        return false;
    
    m_currentPattern.swingHigh = high;
    m_currentPattern.swingLow = low;
    m_currentPattern.swingHighTime = highTime;
    m_currentPattern.swingLowTime = lowTime;
    
    double range = high - low;
    m_currentPattern.currentPrice = SymbolInfoDouble(m_currentPattern.symbol, SYMBOL_BID);
    
    //--- Calculate support and resistance levels
    for(int i = 0; i < 13; i++)
    {
        double level = low + (range * m_fibLevels[i]);
        
        if(i == 4) // 61.8% level often acts as strong support/resistance
        {
            if(m_currentPattern.currentPrice > level)
                m_currentPattern.supportLevel = level;
            else
                m_currentPattern.resistanceLevel = level;
        }
    }
    
    m_currentPattern.isValid = true;
    m_currentPattern.patternStrength = GetFibonacciStrength(m_currentPattern.supportLevel);
    
    Print("✅ Fibonacci retracement calculated: High=", high, ", Low=", low, ", Range=", range);
    return true;
}

//+------------------------------------------------------------------+
//| Analyze current Fibonacci pattern                              |
//+------------------------------------------------------------------+
bool CFibonacci::AnalyzeFibonacciPattern(string symbol, ENUM_TIMEFRAMES timeframe)
{
    //--- Find swing high and low
    int highestBar = iHighest(symbol, timeframe, MODE_HIGH, m_swingHighPeriod, 0);
    int lowestBar = iLowest(symbol, timeframe, MODE_LOW, m_swingLowPeriod, 0);
    
    if(highestBar == -1 || lowestBar == -1)
        return false;
    
    double swingHigh = iHigh(symbol, timeframe, highestBar);
    double swingLow = iLow(symbol, timeframe, lowestBar);
    datetime highTime = iTime(symbol, timeframe, highestBar);
    datetime lowTime = iTime(symbol, timeframe, lowestBar);
    
    //--- Calculate retracement levels
    if(!CalculateRetracementLevels(swingHigh, swingLow, highTime, lowTime))
        return false;
    
    //--- Determine trend direction and signals
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    if(highTime > lowTime) // Uptrend
    {
        if(currentPrice <= m_currentPattern.supportLevel)
        {
            m_currentPattern.suggestedDirection = ORDER_TYPE_BUY;
            m_currentPattern.entryLevel = m_currentPattern.supportLevel;
            m_currentPattern.stopLoss = swingLow - (50 * Point());
            m_currentPattern.takeProfit = swingHigh;
        }
    }
    else // Downtrend
    {
        if(currentPrice >= m_currentPattern.resistanceLevel)
        {
            m_currentPattern.suggestedDirection = ORDER_TYPE_SELL;
            m_currentPattern.entryLevel = m_currentPattern.resistanceLevel;
            m_currentPattern.stopLoss = swingHigh + (50 * Point());
            m_currentPattern.takeProfit = swingLow;
        }
    }
    
    Print("📈 Fibonacci pattern analyzed: Direction=", EnumToString(m_currentPattern.suggestedDirection),
          ", Strength=", m_currentPattern.patternStrength);
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect Fibonacci cluster                                       |
//+------------------------------------------------------------------+
bool CFibonacci::DetectFibonacciCluster(double price, double tolerance = 5.0)
{
    int levelCount = 0;
    double range = m_currentPattern.swingHigh - m_currentPattern.swingLow;
    
    for(int i = 0; i < 13; i++)
    {
        double level = m_currentPattern.swingLow + (range * m_fibLevels[i]);
        
        if(MathAbs(price - level) <= tolerance * Point())
        {
            levelCount++;
        }
    }
    
    bool isCluster = levelCount >= 2;
    
    if(isCluster)
    {
        Print("🎯 Fibonacci cluster detected at ", price, " with ", levelCount, " levels");
    }
    
    return isCluster;
}

//+------------------------------------------------------------------+
//| Detect Gartley harmonic pattern                               |
//+------------------------------------------------------------------+
bool CFibonacci::DetectGartleyPattern(double xA, double aB, double bC, double cD)
{
    //--- Gartley pattern ratios
    double abRetracement = aB / xA;
    double bcRetracement = bC / aB;
    double cdExtension = cD / bC;
    double adRetracement = (xA - cD) / xA;
    
    //--- Validate Gartley ratios
    bool isValidAB = (abRetracement >= 0.58 && abRetracement <= 0.65);
    bool isValidBC = (bcRetracement >= 0.38 && bcRetracement <= 0.90);
    bool isValidCD = (cdExtension >= 1.13 && cdExtension <= 1.618);
    bool isValidAD = (adRetracement >= 0.75 && adRetracement <= 0.85);
    
    bool isGartley = isValidAB && isValidBC && isValidCD && isValidAD;
    
    if(isGartley)
    {
        Print("🦋 Gartley pattern detected: AB=", abRetracement, ", BC=", bcRetracement, 
              ", CD=", cdExtension, ", AD=", adRetracement);
    }
    
    return isGartley;
}

//+------------------------------------------------------------------+
//| Get Fibonacci signal                                           |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CFibonacci::GetFibonacciSignal(string symbol)
{
    if(!m_currentPattern.isValid)
        return -1;
    
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    //--- Check for bounce from Fibonacci levels
    if(IsAtFibonacciLevel(currentPrice, 5.0))
    {
        //--- Additional confirmation with momentum
        if(AnalyzeFibonacciMomentum(symbol))
        {
            return m_currentPattern.suggestedDirection;
        }
    }
    
    return -1;
}

//+------------------------------------------------------------------+
//| Check if price is at Fibonacci level                          |
//+------------------------------------------------------------------+
bool CFibonacci::IsAtFibonacciLevel(double price, double tolerance = 3.0)
{
    double range = m_currentPattern.swingHigh - m_currentPattern.swingLow;
    
    for(int i = 0; i < 13; i++)
    {
        double level = m_currentPattern.swingLow + (range * m_fibLevels[i]);
        
        if(MathAbs(price - level) <= tolerance * Point())
        {
            Print("📍 Price at Fibonacci level: ", m_fibLabels[i], " (", level, ")");
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Get Fibonacci level strength                                   |
//+------------------------------------------------------------------+
int CFibonacci::GetFibonacciStrength(double level)
{
    int strength = 0;
    
    //--- Check historical bounces
    strength += ValidateFibonacciSupport(level, 100) ? 2 : 0;
    strength += ValidateFibonacciResistance(level, 100) ? 2 : 0;
    
    //--- Check confluence with other levels
    strength += DetectFibonacciCluster(level, 10.0) ? 3 : 0;
    
    //--- Check volume at level
    strength += ValidateWithVolumeProfile(level) ? 2 : 0;
    
    return strength;
}

//+------------------------------------------------------------------+
//| Validate Fibonacci support                                     |
//+------------------------------------------------------------------+
bool CFibonacci::ValidateFibonacciSupport(double level, int lookbackBars = 50)
{
    int bounces = 0;
    
    for(int i = 1; i <= lookbackBars; i++)
    {
        double low = iLow(m_currentPattern.symbol, m_currentPattern.timeframe, i);
        double close = iClose(m_currentPattern.symbol, m_currentPattern.timeframe, i);
        
        if(low <= level && close > level)
        {
            bounces++;
        }
    }
    
    return bounces >= 2;
}

//+------------------------------------------------------------------+
//| Validate Fibonacci resistance                                  |
//+------------------------------------------------------------------+
bool CFibonacci::ValidateFibonacciResistance(double level, int lookbackBars = 50)
{
    int rejections = 0;
    
    for(int i = 1; i <= lookbackBars; i++)
    {
        double high = iHigh(m_currentPattern.symbol, m_currentPattern.timeframe, i);
        double close = iClose(m_currentPattern.symbol, m_currentPattern.timeframe, i);
        
        if(high >= level && close < level)
        {
            rejections++;
        }
    }
    
    return rejections >= 2;
}

//+------------------------------------------------------------------+
//| Analyze Fibonacci momentum                                     |
//+------------------------------------------------------------------+
bool CFibonacci::AnalyzeFibonacciMomentum(string symbol)
{
    //--- Use RSI to confirm momentum
    double rsi = iRSI(symbol, m_currentPattern.timeframe, 14, PRICE_CLOSE, 0);
    
    if(m_currentPattern.suggestedDirection == ORDER_TYPE_BUY)
    {
        return rsi < 50 && rsi > 30; // Oversold but recovering
    }
    else if(m_currentPattern.suggestedDirection == ORDER_TYPE_SELL)
    {
        return rsi > 50 && rsi < 70; // Overbought but weakening
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Draw Fibonacci retracement levels                             |
//+------------------------------------------------------------------+
void CFibonacci::DrawFibonacciLevels(string symbol, double high, double low, datetime highTime, datetime lowTime)
{
    if(!m_showLabels)
        return;
    
    string objName = m_objectPrefix + "_Retracement";
    
    //--- Create Fibonacci retracement object
    if(ObjectCreate(objName, OBJ_FIBO, 0, lowTime, low, highTime, high))
    {
        //--- Set Fibonacci levels
        ObjectSetInteger(0, objName, OBJPROP_LEVELS, 13);
        
        for(int i = 0; i < 13; i++)
        {
            ObjectSetDouble(0, objName, OBJPROP_LEVELVALUE, i, m_fibLevels[i]);
            ObjectSetString(0, objName, OBJPROP_LEVELTEXT, i, m_fibLabels[i]);
            ObjectSetInteger(0, objName, OBJPROP_LEVELCOLOR, i, m_levelColors[i]);
            ObjectSetInteger(0, objName, OBJPROP_LEVELSTYLE, i, STYLE_SOLID);
            ObjectSetInteger(0, objName, OBJPROP_LEVELWIDTH, i, 1);
        }
        
        ObjectSetInteger(0, objName, OBJPROP_RAY_RIGHT, m_extendLines);
        ObjectSetInteger(0, objName, OBJPROP_BACK, false);
        
        Print("📊 Fibonacci levels drawn for ", symbol);
    }
}

//+------------------------------------------------------------------+
//| Calculate optimal entry level                                  |
//+------------------------------------------------------------------+
double CFibonacci::GetOptimalEntry(ENUM_ORDER_TYPE orderType)
{
    if(!m_currentPattern.isValid)
        return 0.0;
    
    return m_currentPattern.entryLevel;
}

//+------------------------------------------------------------------+
//| Calculate Fibonacci stop loss                                  |
//+------------------------------------------------------------------+
double CFibonacci::GetFibonacciStopLoss(ENUM_ORDER_TYPE orderType, double entryPrice)
{
    if(!m_currentPattern.isValid)
        return 0.0;
    
    return m_currentPattern.stopLoss;
}

//+------------------------------------------------------------------+
//| Calculate Fibonacci take profit                               |
//+------------------------------------------------------------------+
double CFibonacci::GetFibonacciTakeProfit(ENUM_ORDER_TYPE orderType, double entryPrice)
{
    if(!m_currentPattern.isValid)
        return 0.0;
    
    return m_currentPattern.takeProfit;
}

//+------------------------------------------------------------------+
//| Get risk-reward ratio                                          |
//+------------------------------------------------------------------+
double CFibonacci::GetRiskRewardRatio()
{
    if(!m_currentPattern.isValid)
        return 0.0;
    
    double risk = MathAbs(m_currentPattern.entryLevel - m_currentPattern.stopLoss);
    double reward = MathAbs(m_currentPattern.takeProfit - m_currentPattern.entryLevel);
    
    return risk > 0 ? reward / risk : 0.0;
}

//+------------------------------------------------------------------+
//| Validate with volume profile                                   |
//+------------------------------------------------------------------+
bool CFibonacci::ValidateWithVolumeProfile(double fibLevel)
{
    //--- Simple volume validation - check if average volume is higher at this level
    int volumeCount = 0;
    long totalVolume = 0;
    
    for(int i = 1; i <= 20; i++)
    {
        double close = iClose(m_currentPattern.symbol, m_currentPattern.timeframe, i);
        
        if(MathAbs(close - fibLevel) <= 10 * Point())
        {
            totalVolume += iVolume(m_currentPattern.symbol, m_currentPattern.timeframe, i);
            volumeCount++;
        }
    }
    
    if(volumeCount > 0)
    {
        long avgVolume = totalVolume / volumeCount;
        long currentVolume = iVolume(m_currentPattern.symbol, m_currentPattern.timeframe, 0);
        
        return avgVolume > currentVolume * 1.2; // 20% higher volume at level
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Remove all Fibonacci objects                                   |
//+------------------------------------------------------------------+
void CFibonacci::RemoveAllFibonacciObjects()
{
    int totalObjects = ObjectsTotal();
    
    for(int i = totalObjects - 1; i >= 0; i--)
    {
        string objName = ObjectName(i);
        
        if(StringFind(objName, "Fib_") == 0)
        {
            ObjectDelete(objName);
        }
    }
    
    Print("🧹 All Fibonacci objects removed");
}

//+------------------------------------------------------------------+
//| Get Fibonacci level name                                       |
//+------------------------------------------------------------------+
string CFibonacci::GetFibonacciLevelName(int index)
{
    if(index >= 0 && index < 13)
        return m_fibLabels[index];
    
    return "Unknown";
}

//+------------------------------------------------------------------+
//| Get Fibonacci level value                                      |
//+------------------------------------------------------------------+
double CFibonacci::GetFibonacciLevel(int index)
{
    if(index >= 0 && index < 13)
        return m_fibLevels[index];
    
    return 0.0;
}