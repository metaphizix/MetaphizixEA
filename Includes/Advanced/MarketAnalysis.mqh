//+------------------------------------------------------------------+
//|                                               MarketAnalysis.mqh |
//|                                   Advanced Market Analysis EA   |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

#include "../Core/Config.mqh"  // Must come first for ENUM_SIGNAL_TYPE and other enums

//+------------------------------------------------------------------+
//| Comprehensive Market Analysis Class                            |
//+------------------------------------------------------------------+
class CMarketAnalysis
{
private:
    //--- Market structure analysis
    struct MarketStructure
    {
        double swingHighs[50];
        double swingLows[50];
        datetime swingHighTimes[50];
        datetime swingLowTimes[50];
        int highCount;
        int lowCount;
        ENUM_TIMEFRAMES timeframe;
        string trendDirection;
        double trendStrength;
        bool isRanging;
        double rangeTop;
        double rangeBottom;
    };
    
    MarketStructure m_structure;
    
    //--- Technical indicators
    struct TechnicalIndicators
    {
        // Moving averages
        double sma20, sma50, sma200;
        double ema20, ema50, ema200;
        
        // Bands and channels
        double bollinger_upper, bollinger_lower, bollinger_middle;
        double keltner_upper, keltner_lower, keltner_middle;
        double donchian_upper, donchian_lower;
        
        // Oscillators
        double rsi, stochastic, macd_main, macd_signal;
        double cci, williams, momentum, roc, stoch_rsi;
        double mfi, ultimate_osc, awesome_osc, tsi;
        
        // Trend indicators
        double atr, adx, parabolic_sar;
        double supertrend, aroon_up, aroon_down, vortex_pos, vortex_neg;
        double dmi_plus, dmi_minus, trix, mass_index;
        
        // Volume indicators
        double obv, volume_osc, chaikin_mf, ad_line, vwap, klinger;
        
        // Volatility indicators
        double volatility_stop, choppiness_index;
        
        // Composite indicators
        double elder_ray_bull, elder_ray_bear, schaff_trend;
        
        // Alignment flags
        bool bullish_ma_alignment;
        bool bearish_ma_alignment;
        bool bullish_oscillator_alignment;
        bool bearish_oscillator_alignment;
        bool bullish_trend_alignment;
        bool bearish_trend_alignment;
        bool bullish_volume_alignment;
        bool bearish_volume_alignment;
    };
    
    TechnicalIndicators m_indicators;
    
    //--- Market phases
    enum ENUM_MARKET_PHASE
    {
        MARKET_ACCUMULATION,
        MARKET_MARKUP,
        MARKET_DISTRIBUTION,
        MARKET_MARKDOWN,
        MARKET_CONSOLIDATION
    };
    
    ENUM_MARKET_PHASE m_currentPhase;
    
    //--- Support and resistance levels
    struct SupportResistance
    {
        double levels[20];
        int touchCount[20];
        datetime lastTouch[20];
        bool isSupport[20];
        double strength[20];
        int totalLevels;
    };
    
    SupportResistance m_srLevels;
    
    //--- Price action patterns
    struct PriceActionPattern
    {
        string patternName;
        ENUM_ORDER_TYPE direction;
        double confidence;
        double entryPrice;
        double stopLoss;
        double takeProfit;
        bool isValid;
    };
    
    PriceActionPattern m_currentPattern;

public:
    //--- Constructor
    CMarketAnalysis();
    
    //--- Initialization
    bool Initialize(string symbol, ENUM_TIMEFRAMES timeframe);
    
    //--- Market structure analysis
    bool AnalyzeMarketStructure(string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectTrendDirection(string symbol, ENUM_TIMEFRAMES timeframe);
    double CalculateTrendStrength(string symbol);
    bool IsMarketRanging(string symbol, int period = 50);
    
    //--- Technical indicator analysis
    bool UpdateTechnicalIndicators(string symbol, ENUM_TIMEFRAMES timeframe);
    bool AnalyzeMovingAverages(string symbol);
    bool AnalyzeOscillators(string symbol);
    bool AnalyzeBollingerBands(string symbol);
    bool AnalyzeMACD(string symbol);
    
    //--- Support and resistance
    bool DetectSupportResistance(string symbol, ENUM_TIMEFRAMES timeframe, int period = 100);
    bool ValidateSRLevel(double level, string symbol, ENUM_TIMEFRAMES timeframe);
    double GetNearestSupport(double currentPrice);
    double GetNearestResistance(double currentPrice);
    int GetSRStrength(double level);
    
    //--- Price action patterns
    bool DetectPriceActionPatterns(string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectPinBar(string symbol, int bar = 1);
    bool DetectInsideBar(string symbol, int bar = 1);
    bool DetectOutsideBar(string symbol, int bar = 1);
    bool DetectDoji(string symbol, int bar = 1);
    bool DetectHammer(string symbol, int bar = 1);
    bool DetectShootingStar(string symbol, int bar = 1);
    bool DetectEngulfingPattern(string symbol, int bar = 1);
    
    //--- Market phases
    ENUM_MARKET_PHASE DetermineMarketPhase(string symbol);
    bool IsAccumulationPhase(string symbol);
    bool IsMarkupPhase(string symbol);
    bool IsDistributionPhase(string symbol);
    bool IsMarkdownPhase(string symbol);
    
    //--- Advanced analysis
    bool AnalyzeMarketSentiment(string symbol);
    bool DetectMarketManipulation(string symbol);
    bool AnalyzeInstitutionalActivity(string symbol);
    bool DetectOrderBlocks(string symbol, ENUM_TIMEFRAMES timeframe);
    bool AnalyzeLiquidity(string symbol);
    
    //--- Multi-timeframe analysis
    bool AnalyzeMultiTimeframe(string symbol);
    bool GetTimeframeAlignment(string symbol);
    double GetTimeframeConfluence(string symbol);
    
    //--- Volume analysis
    bool AnalyzeVolumeProfile(string symbol, int period = 100);
    bool DetectVolumeSpike(string symbol, double threshold = 2.0);
    bool ValidateWithVolume(double priceLevel, string symbol);
    
    //--- Divergence analysis
    bool DetectPriceMomentumDivergence(string symbol, int period = 20);
    bool DetectBullishDivergence(string symbol);
    bool DetectBearishDivergence(string symbol);
    
    //--- Signal generation
    ENUM_ORDER_TYPE GetMarketSignal(string symbol);
    double GetSignalConfidence();
    double GetOptimalEntry(ENUM_ORDER_TYPE orderType, string symbol);
    double GetOptimalStopLoss(ENUM_ORDER_TYPE orderType, double entryPrice, string symbol);
    double GetOptimalTakeProfit(ENUM_ORDER_TYPE orderType, double entryPrice, string symbol);
    
    //--- Risk assessment
    double AssessMarketRisk(string symbol);
    double GetVolatilityFactor(string symbol);
    bool IsHighRiskEnvironment(string symbol);
    
    //--- Information functions
    string GetTrendDirection() { return m_structure.trendDirection; }
    double GetTrendStrength() { return m_structure.trendStrength; }
    ENUM_MARKET_PHASE GetCurrentPhase() { return m_currentPhase; }
    PriceActionPattern GetCurrentPattern() { return m_currentPattern; }
    TechnicalIndicators GetIndicators() { return m_indicators; }
    
    //--- Missing indicator calculation methods
    double CalculateStochRSI(string symbol, ENUM_TIMEFRAMES tf, int rsiPeriod, int stochPeriod);
    double CalculateUltimateOscillator(string symbol, ENUM_TIMEFRAMES tf, int period1 = 7, int period2 = 14, int period3 = 28);
    double CalculateAwesomeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 34);
    double CalculateTSI(string symbol, ENUM_TIMEFRAMES tf, int r = 25, int s = 13);
    double CalculateSupertrend(string symbol, ENUM_TIMEFRAMES tf, int period = 10, double multiplier = 3.0);
    double CalculateAroonUp(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateAroonDown(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateVortexPositive(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateVortexNegative(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateTRIX(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateMassIndex(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateOBV(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateVolumeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 10);
    double CalculateChaikinMF(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateADLine(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateVWAP(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateKlingerOscillator(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateKeltnerUpper(string symbol, ENUM_TIMEFRAMES tf, int period, double multiplier);
    double CalculateKeltnerLower(string symbol, ENUM_TIMEFRAMES tf, int period, double multiplier);
    double CalculateVolatilityStop(string symbol, ENUM_TIMEFRAMES tf, int period = 20, double factor = 2.0);
    double CalculateChoppinessIndex(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateElderRayBull(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateElderRayBear(string symbol, ENUM_TIMEFRAMES tf, int period);
    double CalculateSchaffTrend(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Enhanced alignment analysis
    void AnalyzeOscillatorAlignment(string symbol);
    void AnalyzeTrendAlignment(string symbol);
    void AnalyzeVolumeAlignment(string symbol);
    
    //--- Utility functions
    void PrintMarketAnalysis(string symbol);
    void DrawSupportResistanceLevels(string symbol);
    void RemoveAnalysisObjects();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMarketAnalysis::CMarketAnalysis()
{
    //--- Initialize structure
    m_structure.highCount = 0;
    m_structure.lowCount = 0;
    m_structure.trendDirection = "NEUTRAL";
    m_structure.trendStrength = 0.0;
    m_structure.isRanging = false;
    
    //--- Initialize SR levels
    m_srLevels.totalLevels = 0;
    
    //--- Initialize pattern
    m_currentPattern.isValid = false;
    m_currentPattern.confidence = 0.0;
    
    //--- Initialize phase
    m_currentPhase = MARKET_CONSOLIDATION;
    
    Print("📊 Market Analysis module initialized");
}

//+------------------------------------------------------------------+
//| Initialize market analysis                                      |
//+------------------------------------------------------------------+
bool CMarketAnalysis::Initialize(string symbol, ENUM_TIMEFRAMES timeframe)
{
    m_structure.timeframe = timeframe;
    
    //--- Initial market structure analysis
    if(!AnalyzeMarketStructure(symbol, timeframe))
    {
        Print("❌ Failed to initialize market structure for ", symbol);
        return false;
    }
    
    //--- Update technical indicators
    if(!UpdateTechnicalIndicators(symbol, timeframe))
    {
        Print("❌ Failed to update technical indicators for ", symbol);
        return false;
    }
    
    //--- Detect support and resistance
    if(!DetectSupportResistance(symbol, timeframe))
    {
        Print("❌ Failed to detect support/resistance for ", symbol);
        return false;
    }
    
    Print("✅ Market analysis initialized for ", symbol, " ", EnumToString(timeframe));
    return true;
}

//+------------------------------------------------------------------+
//| Analyze market structure                                       |
//+------------------------------------------------------------------+
bool CMarketAnalysis::AnalyzeMarketStructure(string symbol, ENUM_TIMEFRAMES timeframe)
{
    //--- Find swing highs and lows
    m_structure.highCount = 0;
    m_structure.lowCount = 0;
    
    int lookback = 100;
    
    for(int i = 2; i < lookback; i++)
    {
        double high = iHigh(symbol, timeframe, i);
        double low = iLow(symbol, timeframe, i);
        double prevHigh = iHigh(symbol, timeframe, i+1);
        double nextHigh = iHigh(symbol, timeframe, i-1);
        double prevLow = iLow(symbol, timeframe, i+1);
        double nextLow = iLow(symbol, timeframe, i-1);
        
        //--- Detect swing highs
        if(high > prevHigh && high > nextHigh && m_structure.highCount < 50)
        {
            m_structure.swingHighs[m_structure.highCount] = high;
            m_structure.swingHighTimes[m_structure.highCount] = iTime(symbol, timeframe, i);
            m_structure.highCount++;
        }
        
        //--- Detect swing lows
        if(low < prevLow && low < nextLow && m_structure.lowCount < 50)
        {
            m_structure.swingLows[m_structure.lowCount] = low;
            m_structure.swingLowTimes[m_structure.lowCount] = iTime(symbol, timeframe, i);
            m_structure.lowCount++;
        }
    }
    
    //--- Determine trend direction
    DetectTrendDirection(symbol, timeframe);
    
    //--- Calculate trend strength
    m_structure.trendStrength = CalculateTrendStrength(symbol);
    
    //--- Check if market is ranging
    m_structure.isRanging = IsMarketRanging(symbol, 50);
    
    Print("📈 Market structure analyzed: Highs=", m_structure.highCount, 
          ", Lows=", m_structure.lowCount, ", Trend=", m_structure.trendDirection);
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect trend direction                                         |
//+------------------------------------------------------------------+
bool CMarketAnalysis::DetectTrendDirection(string symbol, ENUM_TIMEFRAMES timeframe)
{
    if(m_structure.highCount < 3 || m_structure.lowCount < 3)
    {
        m_structure.trendDirection = "NEUTRAL";
        return false;
    }
    
    //--- Analyze recent swing points
    bool higherHighs = true;
    bool lowerLows = true;
    bool lowerHighs = true;
    bool higherLows = true;
    
    for(int i = 1; i < MathMin(3, m_structure.highCount); i++)
    {
        if(m_structure.swingHighs[i] <= m_structure.swingHighs[i-1])
            higherHighs = false;
        if(m_structure.swingHighs[i] >= m_structure.swingHighs[i-1])
            lowerHighs = false;
    }
    
    for(int i = 1; i < MathMin(3, m_structure.lowCount); i++)
    {
        if(m_structure.swingLows[i] >= m_structure.swingLows[i-1])
            lowerLows = false;
        if(m_structure.swingLows[i] <= m_structure.swingLows[i-1])
            higherLows = false;
    }
    
    //--- Determine trend
    if(higherHighs && higherLows)
        m_structure.trendDirection = "BULLISH";
    else if(lowerHighs && lowerLows)
        m_structure.trendDirection = "BEARISH";
    else
        m_structure.trendDirection = "NEUTRAL";
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate trend strength                                       |
//+------------------------------------------------------------------+
double CMarketAnalysis::CalculateTrendStrength(string symbol)
{
    //--- Use ADX for trend strength
    int adxHandle = iADX(symbol, m_structure.timeframe, 14);
    if(adxHandle == INVALID_HANDLE) 
    {
        Print("❌ Error: Failed to create ADX indicator handle");
        return 0.0;
    }
    
    double adxBuffer[];
    ArraySetAsSeries(adxBuffer, true);
    if(!CopyBuffer(adxHandle, 0, 0, 1, adxBuffer))
    {
        Print("❌ Error: Failed to copy ADX buffer data");
        IndicatorRelease(adxHandle);
        return 0.0;
    }
    double adx = adxBuffer[0];
    IndicatorRelease(adxHandle);
    
    //--- Normalize ADX to 0-100 scale
    double strength = adx;
    
    if(strength >= 50)
        strength = 100.0; // Very strong trend
    else if(strength >= 25)
        strength = 75.0;  // Strong trend
    else if(strength >= 15)
        strength = 50.0;  // Moderate trend
    else
        strength = 25.0;  // Weak trend
    
    return strength;
}

//+------------------------------------------------------------------+
//| Check if market is ranging                                     |
//+------------------------------------------------------------------+
bool CMarketAnalysis::IsMarketRanging(string symbol, int period = 50)
{
    //--- Calculate highest high and lowest low
    int highestBar = iHighest(symbol, m_structure.timeframe, MODE_HIGH, period, 0);
    int lowestBar = iLowest(symbol, m_structure.timeframe, MODE_LOW, period, 0);
    
    double highest = iHigh(symbol, m_structure.timeframe, highestBar);
    double lowest = iLow(symbol, m_structure.timeframe, lowestBar);
    
    m_structure.rangeTop = highest;
    m_structure.rangeBottom = lowest;
    
    //--- Check if price is contained within range
    double range = highest - lowest;
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    //--- Calculate how much price has moved compared to range
    double priceMovement = 0;
    for(int i = 1; i <= 20; i++)
    {
        double close1 = iClose(symbol, m_structure.timeframe, i);
        double close2 = iClose(symbol, m_structure.timeframe, i+1);
        priceMovement += MathAbs(close1 - close2);
    }
    
    double avgMovement = priceMovement / 20;
    
    //--- Market is ranging if average movement is small compared to range
    bool isRanging = (avgMovement < range * 0.3) && (range < (currentPrice * 0.05));
    
    return isRanging;
}

//+------------------------------------------------------------------+
//| Update technical indicators                                    |
//+------------------------------------------------------------------+
bool CMarketAnalysis::UpdateTechnicalIndicators(string symbol, ENUM_TIMEFRAMES timeframe)
{
    //--- Moving averages
    double maBuffer[];
    ArraySetAsSeries(maBuffer, true);
    
    //--- 20 SMA
    int sma20Handle = iMA(symbol, timeframe, 20, 0, MODE_SMA, PRICE_CLOSE);
    if(sma20Handle == INVALID_HANDLE)
    {
        Print("❌ Error: Failed to create 20 SMA indicator handle");
        return false;
    }
    
    if(!CopyBuffer(sma20Handle, 0, 0, 1, maBuffer))
    {
        Print("❌ Error: Failed to copy 20 SMA buffer data");
        IndicatorRelease(sma20Handle);
        return false;
    }
    m_indicators.sma20 = maBuffer[0];
    IndicatorRelease(sma20Handle);
    
    //--- 50 SMA
    int sma50Handle = iMA(symbol, timeframe, 50, 0, MODE_SMA, PRICE_CLOSE);
    if(sma50Handle == INVALID_HANDLE)
    {
        Print("❌ Error: Failed to create 50 SMA indicator handle");
        return false;
    }
    CopyBuffer(sma50Handle, 0, 0, 1, maBuffer);
    m_indicators.sma50 = maBuffer[0];
    
    int sma200Handle = iMA(symbol, timeframe, 200, 0, MODE_SMA, PRICE_CLOSE);
    CopyBuffer(sma200Handle, 0, 0, 1, maBuffer);
    m_indicators.sma200 = maBuffer[0];
    
    int ema20Handle = iMA(symbol, timeframe, 20, 0, MODE_EMA, PRICE_CLOSE);
    CopyBuffer(ema20Handle, 0, 0, 1, maBuffer);
    m_indicators.ema20 = maBuffer[0];
    
    int ema50Handle = iMA(symbol, timeframe, 50, 0, MODE_EMA, PRICE_CLOSE);
    CopyBuffer(ema50Handle, 0, 0, 1, maBuffer);
    m_indicators.ema50 = maBuffer[0];
    
    int ema200Handle = iMA(symbol, timeframe, 200, 0, MODE_EMA, PRICE_CLOSE);
    CopyBuffer(ema200Handle, 0, 0, 1, maBuffer);
    m_indicators.ema200 = maBuffer[0];
    
    //--- Bollinger Bands
    int bandsHandle = iBands(symbol, timeframe, 20, 2, 0);
    if(bandsHandle != INVALID_HANDLE)
    {
        double bandsBuffer[];
        ArraySetAsSeries(bandsBuffer, true);
        if(CopyBuffer(bandsHandle, 1, 0, 1, bandsBuffer) > 0) m_indicators.bollinger_upper = bandsBuffer[0];
        if(CopyBuffer(bandsHandle, 0, 0, 1, bandsBuffer) > 0) m_indicators.bollinger_middle = bandsBuffer[0];
        if(CopyBuffer(bandsHandle, 2, 0, 1, bandsBuffer) > 0) m_indicators.bollinger_lower = bandsBuffer[0];
    }
    
    //--- Oscillators
    int rsiHandle = iRSI(symbol, timeframe, 14);
    if(rsiHandle != INVALID_HANDLE)
    {
        double rsiBuffer[];
        ArraySetAsSeries(rsiBuffer, true);
        if(CopyBuffer(rsiHandle, 0, 0, 1, rsiBuffer) > 0) m_indicators.rsi = rsiBuffer[0];
    }
    
    int stochasticHandle = iStochastic(symbol, timeframe, 14, 3, 3, MODE_EMA, STO_LOWHIGH);
    if(stochasticHandle != INVALID_HANDLE)
    {
        double stocBuffer[];
        ArraySetAsSeries(stocBuffer, true);
        if(CopyBuffer(stochasticHandle, 0, 0, 1, stocBuffer) > 0) m_indicators.stochastic = stocBuffer[0];
    }
    
    //--- MACD
    int macdHandle = iMACD(symbol, timeframe, 12, 26, 9);
    if(macdHandle != INVALID_HANDLE)
    {
        double macdBuffer[];
        ArraySetAsSeries(macdBuffer, true);
        if(CopyBuffer(macdHandle, 0, 0, 1, macdBuffer) > 0) m_indicators.macd_main = macdBuffer[0];
        if(CopyBuffer(macdHandle, 1, 0, 1, macdBuffer) > 0) m_indicators.macd_signal = macdBuffer[0];
    }
    
    //--- Other existing indicators
    int atrHandle = iATR(symbol, timeframe, 14);
    if(atrHandle != INVALID_HANDLE)
    {
        double atrBuffer[];
        ArraySetAsSeries(atrBuffer, true);
        if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) > 0) m_indicators.atr = atrBuffer[0];
    }
    
    int adxHandle2 = iADX(symbol, timeframe, 14);
    if(adxHandle2 != INVALID_HANDLE)
    {
        double adxBuffer2[];
        ArraySetAsSeries(adxBuffer2, true);
        if(CopyBuffer(adxHandle2, 0, 0, 1, adxBuffer2) > 0) m_indicators.adx = adxBuffer2[0];
    }
    
    int cciHandle = iCCI(symbol, timeframe, 14, PRICE_TYPICAL);
    if(cciHandle != INVALID_HANDLE)
    {
        double cciBuffer[];
        ArraySetAsSeries(cciBuffer, true);
        if(CopyBuffer(cciHandle, 0, 0, 1, cciBuffer) > 0) m_indicators.cci = cciBuffer[0];
    }
    
    int wprHandle = iWPR(symbol, timeframe, 14);
    if(wprHandle != INVALID_HANDLE)
    {
        double wprBuffer[];
        ArraySetAsSeries(wprBuffer, true);
        if(CopyBuffer(wprHandle, 0, 0, 1, wprBuffer) > 0) m_indicators.williams = wprBuffer[0];
    }
    
    //--- Missing oscillators
    int mfiHandle = iMFI(symbol, timeframe, 14);
    if(mfiHandle != INVALID_HANDLE)
    {
        double mfiBuffer[];
        ArraySetAsSeries(mfiBuffer, true);
        if(CopyBuffer(mfiHandle, 0, 0, 1, mfiBuffer) > 0) m_indicators.mfi = mfiBuffer[0];
    }
    m_indicators.awesome_osc = 0.0;  // Placeholder for AO
    m_indicators.tsi = 0.0;  // Placeholder for TSI
    
    //--- Missing trend indicators (using placeholders)
    m_indicators.parabolic_sar = iClose(symbol, timeframe, 0);  // Use current close as placeholder
    m_indicators.supertrend = 0.0;
    m_indicators.aroon_up = 0.0;
    m_indicators.aroon_down = 0.0;
    m_indicators.vortex_pos = 0.0;
    m_indicators.vortex_neg = 0.0;  // Placeholder for Vortex Negative
    
    // DMI+ and DMI- from ADX
    int adxHandle3 = iADX(symbol, timeframe, 14);
    if(adxHandle3 != INVALID_HANDLE)
    {
        double plusDIBuffer[], minusDIBuffer[];
        ArraySetAsSeries(plusDIBuffer, true);
        ArraySetAsSeries(minusDIBuffer, true);
        if(CopyBuffer(adxHandle3, 1, 0, 1, plusDIBuffer) > 0) m_indicators.dmi_plus = plusDIBuffer[0];
        if(CopyBuffer(adxHandle3, 2, 0, 1, minusDIBuffer) > 0) m_indicators.dmi_minus = minusDIBuffer[0];
    }
    
    m_indicators.trix = 0.0;  // Placeholder for TRIX
    m_indicators.mass_index = 0.0;  // Placeholder for Mass Index
    
    //--- Missing volume indicators
    m_indicators.obv = CalculateOBV(symbol, timeframe);
    m_indicators.volume_osc = CalculateVolumeOscillator(symbol, timeframe);
    m_indicators.chaikin_mf = CalculateChaikinMF(symbol, timeframe, 20);
    m_indicators.ad_line = CalculateADLine(symbol, timeframe);
    m_indicators.vwap = CalculateVWAP(symbol, timeframe, 20);
    m_indicators.klinger = CalculateKlingerOscillator(symbol, timeframe);
    
    //--- Missing bands/channels
    m_indicators.keltner_upper = CalculateKeltnerUpper(symbol, timeframe, 20, 2.0);
    
    // Keltner middle - get MA value
    int keltnerMaHandle = iMA(symbol, timeframe, 20, 0, MODE_EMA, PRICE_CLOSE);
    if(keltnerMaHandle != INVALID_HANDLE)
    {
        double keltnerBuffer[];
        ArraySetAsSeries(keltnerBuffer, true);
        if(CopyBuffer(keltnerMaHandle, 0, 0, 1, keltnerBuffer) > 0)
            m_indicators.keltner_middle = keltnerBuffer[0];
        IndicatorRelease(keltnerMaHandle);
    }
    
    m_indicators.keltner_lower = CalculateKeltnerLower(symbol, timeframe, 20, 2.0);
    m_indicators.donchian_upper = iHighest(symbol, timeframe, MODE_HIGH, 20, 0);
    m_indicators.donchian_lower = iLowest(symbol, timeframe, MODE_LOW, 20, 0);
    
    //--- Missing volatility indicators
    m_indicators.volatility_stop = CalculateVolatilityStop(symbol, timeframe);
    m_indicators.choppiness_index = CalculateChoppinessIndex(symbol, timeframe, 14);
    
    //--- Missing composite indicators
    m_indicators.elder_ray_bull = CalculateElderRayBull(symbol, timeframe, 13);
    m_indicators.elder_ray_bear = CalculateElderRayBear(symbol, timeframe, 13);
    m_indicators.schaff_trend = CalculateSchaffTrend(symbol, timeframe);
    
    //--- Calculate momentum and ROC
    double currentPrice = iClose(symbol, timeframe, 0);
    double prevPrice = iClose(symbol, timeframe, 10);
    m_indicators.momentum = ((currentPrice - prevPrice) / prevPrice) * 100;
    
    double rocPrice = iClose(symbol, timeframe, 12);
    m_indicators.roc = ((currentPrice - rocPrice) / rocPrice) * 100;
    
    //--- Check all alignments
    AnalyzeMovingAverages(symbol);
    AnalyzeOscillatorAlignment(symbol);
    AnalyzeTrendAlignment(symbol);
    AnalyzeVolumeAlignment(symbol);
    
    return true;
}

//+------------------------------------------------------------------+
//| Analyze moving averages                                        |
//+------------------------------------------------------------------+
bool CMarketAnalysis::AnalyzeMovingAverages(string symbol)
{
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    //--- Check bullish alignment
    m_indicators.bullish_ma_alignment = 
        (currentPrice > m_indicators.ema20) &&
        (m_indicators.ema20 > m_indicators.ema50) &&
        (m_indicators.ema50 > m_indicators.ema200);
    
    //--- Check bearish alignment
    m_indicators.bearish_ma_alignment = 
        (currentPrice < m_indicators.ema20) &&
        (m_indicators.ema20 < m_indicators.ema50) &&
        (m_indicators.ema50 < m_indicators.ema200);
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect support and resistance levels                          |
//+------------------------------------------------------------------+
bool CMarketAnalysis::DetectSupportResistance(string symbol, ENUM_TIMEFRAMES timeframe, int period = 100)
{
    m_srLevels.totalLevels = 0;
    
    //--- Use swing highs and lows as potential SR levels
    for(int i = 0; i < m_structure.highCount && m_srLevels.totalLevels < 20; i++)
    {
        double level = m_structure.swingHighs[i];
        
        if(ValidateSRLevel(level, symbol, timeframe))
        {
            m_srLevels.levels[m_srLevels.totalLevels] = level;
            m_srLevels.isSupport[m_srLevels.totalLevels] = false; // Resistance
            m_srLevels.touchCount[m_srLevels.totalLevels] = GetSRStrength(level);
            m_srLevels.lastTouch[m_srLevels.totalLevels] = m_structure.swingHighTimes[i];
            m_srLevels.strength[m_srLevels.totalLevels] = m_srLevels.touchCount[m_srLevels.totalLevels];
            m_srLevels.totalLevels++;
        }
    }
    
    for(int i = 0; i < m_structure.lowCount && m_srLevels.totalLevels < 20; i++)
    {
        double level = m_structure.swingLows[i];
        
        if(ValidateSRLevel(level, symbol, timeframe))
        {
            m_srLevels.levels[m_srLevels.totalLevels] = level;
            m_srLevels.isSupport[m_srLevels.totalLevels] = true; // Support
            m_srLevels.touchCount[m_srLevels.totalLevels] = GetSRStrength(level);
            m_srLevels.lastTouch[m_srLevels.totalLevels] = m_structure.swingLowTimes[i];
            m_srLevels.strength[m_srLevels.totalLevels] = m_srLevels.touchCount[m_srLevels.totalLevels];
            m_srLevels.totalLevels++;
        }
    }
    
    Print("🎯 Support/Resistance detected: ", m_srLevels.totalLevels, " levels found");
    return true;
}

//+------------------------------------------------------------------+
//| Get market signal                                              |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CMarketAnalysis::GetMarketSignal(string symbol)
{
    int bullishSignals = 0;
    int bearishSignals = 0;
    
    //--- Moving average signals
    if(m_indicators.bullish_ma_alignment) bullishSignals += 2;
    if(m_indicators.bearish_ma_alignment) bearishSignals += 2;
    
    //--- RSI signals
    if(m_indicators.rsi < 30) bullishSignals++;
    if(m_indicators.rsi > 70) bearishSignals++;
    
    //--- MACD signals
    if(m_indicators.macd_main > m_indicators.macd_signal && m_indicators.macd_main > 0) bullishSignals++;
    if(m_indicators.macd_main < m_indicators.macd_signal && m_indicators.macd_main < 0) bearishSignals++;
    
    //--- Trend signals
    if(m_structure.trendDirection == "BULLISH" && m_structure.trendStrength > 50) bullishSignals += 2;
    if(m_structure.trendDirection == "BEARISH" && m_structure.trendStrength > 50) bearishSignals += 2;
    
    //--- Support/Resistance signals
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double nearestSupport = GetNearestSupport(currentPrice);
    double nearestResistance = GetNearestResistance(currentPrice);
    
    if(MathAbs(currentPrice - nearestSupport) < 20 * Point()) bullishSignals++;
    if(MathAbs(currentPrice - nearestResistance) < 20 * Point()) bearishSignals++;
    
    //--- Determine signal
    if(bullishSignals >= bearishSignals + 2)
        return ORDER_TYPE_BUY;
    else if(bearishSignals >= bullishSignals + 2)
        return ORDER_TYPE_SELL;
    
    return -1; // No signal
}

//+------------------------------------------------------------------+
//| Get nearest support level                                      |
//+------------------------------------------------------------------+
double CMarketAnalysis::GetNearestSupport(double currentPrice)
{
    double nearestSupport = 0;
    double minDistance = DBL_MAX;
    
    for(int i = 0; i < m_srLevels.totalLevels; i++)
    {
        if(m_srLevels.isSupport[i] && m_srLevels.levels[i] < currentPrice)
        {
            double distance = currentPrice - m_srLevels.levels[i];
            if(distance < minDistance)
            {
                minDistance = distance;
                nearestSupport = m_srLevels.levels[i];
            }
        }
    }
    
    return nearestSupport;
}

//+------------------------------------------------------------------+
//| Get nearest resistance level                                   |
//+------------------------------------------------------------------+
double CMarketAnalysis::GetNearestResistance(double currentPrice)
{
    double nearestResistance = 0;
    double minDistance = DBL_MAX;
    
    for(int i = 0; i < m_srLevels.totalLevels; i++)
    {
        if(!m_srLevels.isSupport[i] && m_srLevels.levels[i] > currentPrice)
        {
            double distance = m_srLevels.levels[i] - currentPrice;
            if(distance < minDistance)
            {
                minDistance = distance;
                nearestResistance = m_srLevels.levels[i];
            }
        }
    }
    
    return nearestResistance;
}

//+------------------------------------------------------------------+
//| Validate SR level                                              |
//+------------------------------------------------------------------+
bool CMarketAnalysis::ValidateSRLevel(double level, string symbol, ENUM_TIMEFRAMES timeframe)
{
    int touches = 0;
    
    //--- Count how many times price touched this level
    for(int i = 1; i <= 100; i++)
    {
        double high = iHigh(symbol, timeframe, i);
        double low = iLow(symbol, timeframe, i);
        double close = iClose(symbol, timeframe, i);
        
        //--- Check if price touched the level
        if((low <= level && close >= level) || (high >= level && close <= level))
        {
            touches++;
        }
    }
    
    return touches >= 2; // Level must have been touched at least twice
}

//+------------------------------------------------------------------+
//| Get SR level strength                                          |
//+------------------------------------------------------------------+
int CMarketAnalysis::GetSRStrength(double level)
{
    int strength = 0;
    
    //--- Count touches in recent history
    for(int i = 1; i <= 50; i++)
    {
        double high = iHigh(m_structure.timeframe, 0, i);
        double low = iLow(m_structure.timeframe, 0, i);
        
        if(MathAbs(high - level) <= 10 * Point() || MathAbs(low - level) <= 10 * Point())
        {
            strength++;
        }
    }
    
    return strength;
}

//+------------------------------------------------------------------+
//| Print market analysis summary                                  |
//+------------------------------------------------------------------+
void CMarketAnalysis::PrintMarketAnalysis(string symbol)
{
    Print("═══════════════════════════════════════");
    Print("📊 MARKET ANALYSIS SUMMARY - ", symbol);
    Print("═══════════════════════════════════════");
    Print("🔄 Trend Direction: ", m_structure.trendDirection);
    Print("💪 Trend Strength: ", DoubleToString(m_structure.trendStrength, 1), "%");
    Print("📈 Market Phase: ", EnumToString(m_currentPhase));
    Print("🎯 S/R Levels: ", m_srLevels.totalLevels);
    Print("📊 RSI: ", DoubleToString(m_indicators.rsi, 2));
    Print("📈 ADX: ", DoubleToString(m_indicators.adx, 2));
    Print("🔄 MACD: ", DoubleToString(m_indicators.macd_main, 5));
    Print("💹 MA Alignment: ", m_indicators.bullish_ma_alignment ? "BULLISH" : 
          (m_indicators.bearish_ma_alignment ? "BEARISH" : "NEUTRAL"));
    Print("═══════════════════════════════════════");
}

//+------------------------------------------------------------------+
//| Missing indicator calculation methods                           |
//+------------------------------------------------------------------+

//--- Stochastic RSI calculation
double CMarketAnalysis::CalculateStochRSI(string symbol, ENUM_TIMEFRAMES tf, int rsiPeriod, int stochPeriod)
{
    int rsiHandle = iRSI(symbol, tf, rsiPeriod);
    if(rsiHandle == INVALID_HANDLE) return 50.0;
    
    double rsi[];
    ArraySetAsSeries(rsi, true);
    
    if(CopyBuffer(rsiHandle, 0, 0, stochPeriod, rsi) <= 0) return 50.0;
    
    double maxRSI = ArrayMaximum(rsi);
    double minRSI = ArrayMinimum(rsi);
    
    if(maxRSI == minRSI) return 50.0;
    
    return ((rsi[0] - minRSI) / (maxRSI - minRSI)) * 100.0;
}

//--- Ultimate Oscillator calculation
double CMarketAnalysis::CalculateUltimateOscillator(string symbol, ENUM_TIMEFRAMES tf, int period1 = 7, int period2 = 14, int period3 = 28)
{
    double bp1 = 0, bp2 = 0, bp3 = 0;
    double tr1 = 0, tr2 = 0, tr3 = 0;
    
    for(int i = 0; i < period3; i++)
    {
        double high = iHigh(symbol, tf, i);
        double low = iLow(symbol, tf, i);
        double close = iClose(symbol, tf, i);
        double prevClose = iClose(symbol, tf, i + 1);
        
        double bp = close - MathMin(low, prevClose);
        double tr = MathMax(high, prevClose) - MathMin(low, prevClose);
        
        if(i < period1) { bp1 += bp; tr1 += tr; }
        if(i < period2) { bp2 += bp; tr2 += tr; }
        bp3 += bp; tr3 += tr;
    }
    
    double avg1 = (tr1 != 0) ? bp1 / tr1 : 0;
    double avg2 = (tr2 != 0) ? bp2 / tr2 : 0;
    double avg3 = (tr3 != 0) ? bp3 / tr3 : 0;
    
    return ((4 * avg1) + (2 * avg2) + avg3) / 7 * 100;
}

//--- Awesome Oscillator calculation
double CMarketAnalysis::CalculateAwesomeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 34)
{
    double sma5 = 0, sma34 = 0;
    
    for(int i = 0; i < longPeriod; i++)
    {
        double hl2 = (iHigh(symbol, tf, i) + iLow(symbol, tf, i)) / 2.0;
        
        if(i < shortPeriod) sma5 += hl2;
        sma34 += hl2;
    }
    
    sma5 /= shortPeriod;
    sma34 /= longPeriod;
    
    return sma5 - sma34;
}

//--- True Strength Index calculation
double CMarketAnalysis::CalculateTSI(string symbol, ENUM_TIMEFRAMES tf, int r = 25, int s = 13)
{
    double momentum = iClose(symbol, tf, 0) - iClose(symbol, tf, 1);
    double absMomentum = MathAbs(momentum);
    
    // Simplified TSI calculation
    double tsi = (momentum / absMomentum) * 100.0;
    return tsi;
}

//--- Supertrend calculation
double CMarketAnalysis::CalculateSupertrend(string symbol, ENUM_TIMEFRAMES tf, int period = 10, double multiplier = 3.0)
{
    int atrHandle = iATR(symbol, tf, period);
    if(atrHandle == INVALID_HANDLE) return 0.0;
    
    double atrBuffer[];
    ArraySetAsSeries(atrBuffer, true);
    if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) <= 0) return 0.0;
    double atr = atrBuffer[0];
    IndicatorRelease(atrHandle);
    
    double high = iHigh(symbol, tf, 0);
    double low = iLow(symbol, tf, 0);
    double hl2 = (high + low) / 2.0;
    
    double upperBand = hl2 + (multiplier * atr);
    double lowerBand = hl2 - (multiplier * atr);
    
    double currentPrice = iClose(symbol, tf, 0);
    
    return (currentPrice > hl2) ? lowerBand : upperBand;
}

//--- Aroon calculations
double CMarketAnalysis::CalculateAroonUp(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    int highestIndex = iHighest(symbol, tf, MODE_HIGH, period, 0);
    return ((period - highestIndex) / (double)period) * 100.0;
}

double CMarketAnalysis::CalculateAroonDown(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    int lowestIndex = iLowest(symbol, tf, MODE_LOW, period, 0);
    return ((period - lowestIndex) / (double)period) * 100.0;
}

//--- Vortex calculations
double CMarketAnalysis::CalculateVortexPositive(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double vm_plus = 0, tr_sum = 0;
    
    for(int i = 1; i <= period; i++)
    {
        double high = iHigh(symbol, tf, i - 1);
        double low = iLow(symbol, tf, i);
        vm_plus += MathAbs(high - low);
        
        double tr = iHigh(symbol, tf, i - 1) - iLow(symbol, tf, i - 1);
        tr_sum += tr;
    }
    
    return (tr_sum != 0) ? vm_plus / tr_sum : 1.0;
}

double CMarketAnalysis::CalculateVortexNegative(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double vm_minus = 0, tr_sum = 0;
    
    for(int i = 1; i <= period; i++)
    {
        double low = iLow(symbol, tf, i - 1);
        double high = iHigh(symbol, tf, i);
        vm_minus += MathAbs(low - high);
        
        double tr = iHigh(symbol, tf, i - 1) - iLow(symbol, tf, i - 1);
        tr_sum += tr;
    }
    
    return (tr_sum != 0) ? vm_minus / tr_sum : 1.0;
}

//--- TRIX calculation
double CMarketAnalysis::CalculateTRIX(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    int emaHandle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    if(emaHandle == INVALID_HANDLE) return 0;
    
    double emaBuffer[];
    ArraySetAsSeries(emaBuffer, true);
    if(CopyBuffer(emaHandle, 0, 0, 2, emaBuffer) <= 1)
    {
        IndicatorRelease(emaHandle);
        return 0;
    }
    
    double ema1 = emaBuffer[0];
    double ema1_prev = emaBuffer[1];
    IndicatorRelease(emaHandle);
    
    if(ema1_prev == 0) return 0;
    
    return ((ema1 - ema1_prev) / ema1_prev) * 10000.0;
}

//--- Mass Index calculation
double CMarketAnalysis::CalculateMassIndex(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double sum = 0;
    
    for(int i = 0; i < period; i++)
    {
        double high = iHigh(symbol, tf, i);
        double low = iLow(symbol, tf, i);
        double range = high - low;
        
        if(range > 0) sum += range;
    }
    
    return sum;
}

//--- Volume indicators
double CMarketAnalysis::CalculateOBV(string symbol, ENUM_TIMEFRAMES tf)
{
    double currentPrice = iClose(symbol, tf, 0);
    double prevPrice = iClose(symbol, tf, 1);
    long volume = iVolume(symbol, tf, 0);
    
    static double obv = 0;
    
    if(currentPrice > prevPrice) obv += volume;
    else if(currentPrice < prevPrice) obv -= volume;
    
    return obv;
}

double CMarketAnalysis::CalculateVolumeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 10)
{
    double shortVol = 0, longVol = 0;
    
    for(int i = 0; i < longPeriod; i++)
    {
        long vol = iVolume(symbol, tf, i);
        if(i < shortPeriod) shortVol += vol;
        longVol += vol;
    }
    
    shortVol /= shortPeriod;
    longVol /= longPeriod;
    
    return (longVol != 0) ? ((shortVol - longVol) / longVol) * 100.0 : 0;
}

double CMarketAnalysis::CalculateChaikinMF(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double mfv_sum = 0;
    long volume_sum = 0;
    
    for(int i = 0; i < period; i++)
    {
        double high = iHigh(symbol, tf, i);
        double low = iLow(symbol, tf, i);
        double close = iClose(symbol, tf, i);
        long volume = iVolume(symbol, tf, i);
        
        double mfm = ((close - low) - (high - close)) / (high - low);
        mfv_sum += mfm * volume;
        volume_sum += volume;
    }
    
    return (volume_sum != 0) ? mfv_sum / volume_sum : 0;
}

double CMarketAnalysis::CalculateADLine(string symbol, ENUM_TIMEFRAMES tf)
{
    double high = iHigh(symbol, tf, 0);
    double low = iLow(symbol, tf, 0);
    double close = iClose(symbol, tf, 0);
    long volume = iVolume(symbol, tf, 0);
    
    static double adLine = 0;
    
    if(high != low)
    {
        double mfm = ((close - low) - (high - close)) / (high - low);
        adLine += mfm * volume;
    }
    
    return adLine;
}

double CMarketAnalysis::CalculateVWAP(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double priceVolume = 0;
    long volumeSum = 0;
    
    for(int i = 0; i < period; i++)
    {
        double typical = (iHigh(symbol, tf, i) + iLow(symbol, tf, i) + iClose(symbol, tf, i)) / 3.0;
        long volume = iVolume(symbol, tf, i);
        
        priceVolume += typical * volume;
        volumeSum += volume;
    }
    
    return (volumeSum != 0) ? priceVolume / volumeSum : 0;
}

double CMarketAnalysis::CalculateKlingerOscillator(string symbol, ENUM_TIMEFRAMES tf)
{
    // Simplified Klinger calculation
    double high = iHigh(symbol, tf, 0);
    double low = iLow(symbol, tf, 0);
    double close = iClose(symbol, tf, 0);
    long volume = iVolume(symbol, tf, 0);
    
    double typical = (high + low + close) / 3.0;
    double prevTypical = (iHigh(symbol, tf, 1) + iLow(symbol, tf, 1) + iClose(symbol, tf, 1)) / 3.0;
    
    return (typical > prevTypical ? volume : -volume);
}

//--- Keltner Channels
double CMarketAnalysis::CalculateKeltnerUpper(string symbol, ENUM_TIMEFRAMES tf, int period, double multiplier)
{
    int emaHandle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    int atrHandle = iATR(symbol, tf, period);
    
    double emaBuffer[], atrBuffer[];
    ArraySetAsSeries(emaBuffer, true);
    ArraySetAsSeries(atrBuffer, true);
    
    double ema = 0, atr = 0;
    
    if(CopyBuffer(emaHandle, 0, 0, 1, emaBuffer) > 0) ema = emaBuffer[0];
    if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) > 0) atr = atrBuffer[0];
    
    IndicatorRelease(emaHandle);
    IndicatorRelease(atrHandle);
    
    return ema + (multiplier * atr);
}

double CMarketAnalysis::CalculateKeltnerLower(string symbol, ENUM_TIMEFRAMES tf, int period, double multiplier)
{
    int emaHandle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    int atrHandle = iATR(symbol, tf, period);
    
    double emaBuffer[], atrBuffer[];
    ArraySetAsSeries(emaBuffer, true);
    ArraySetAsSeries(atrBuffer, true);
    
    double ema = 0, atr = 0;
    
    if(CopyBuffer(emaHandle, 0, 0, 1, emaBuffer) > 0) ema = emaBuffer[0];
    if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) > 0) atr = atrBuffer[0];
    
    IndicatorRelease(emaHandle);
    IndicatorRelease(atrHandle);
    
    return ema - (multiplier * atr);
}

//--- Volatility indicators
double CMarketAnalysis::CalculateVolatilityStop(string symbol, ENUM_TIMEFRAMES tf, int period = 20, double factor = 2.0)
{
    int atrHandle = iATR(symbol, tf, period);
    if(atrHandle == INVALID_HANDLE) return 0.0;
    
    double atrBuffer[];
    ArraySetAsSeries(atrBuffer, true);
    double atr = 0;
    if(CopyBuffer(atrHandle, 0, 0, 1, atrBuffer) > 0) atr = atrBuffer[0];
    IndicatorRelease(atrHandle);
    
    return atr;
    double currentPrice = iClose(symbol, tf, 0);
    return currentPrice - (factor * atr);
}

double CMarketAnalysis::CalculateChoppinessIndex(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    double atr_sum = 0;
    
    int atrHandle = iATR(symbol, tf, 1);
    if(atrHandle == INVALID_HANDLE) return 50.0;
    
    double atrBuffer[];
    ArraySetAsSeries(atrBuffer, true);
    
    for(int i = 0; i < period; i++)
    {
        if(CopyBuffer(atrHandle, 0, i, 1, atrBuffer) > 0)
            atr_sum += atrBuffer[0];
    }
    IndicatorRelease(atrHandle);
    
    int highest_index = iHighest(symbol, tf, MODE_HIGH, period, 0);
    int lowest_index = iLowest(symbol, tf, MODE_LOW, period, 0);
    
    double highest = iHigh(symbol, tf, highest_index);
    double lowest = iLow(symbol, tf, lowest_index);
    double high_low_range = highest - lowest;
    
    if(high_low_range == 0) return 50;
    
    return 100.0 * MathLog10(atr_sum / high_low_range) / MathLog10(period);
}

//--- Elder Ray Index
double CMarketAnalysis::CalculateElderRayBull(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    int emaHandle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    if(emaHandle == INVALID_HANDLE) return 0.0;
    
    double emaBuffer[];
    ArraySetAsSeries(emaBuffer, true);
    double ema = 0;
    if(CopyBuffer(emaHandle, 0, 0, 1, emaBuffer) > 0) ema = emaBuffer[0];
    IndicatorRelease(emaHandle);
    
    double high = iHigh(symbol, tf, 0);
    return high - ema;
}

double CMarketAnalysis::CalculateElderRayBear(string symbol, ENUM_TIMEFRAMES tf, int period)
{
    int emaHandle = iMA(symbol, tf, period, 0, MODE_EMA, PRICE_CLOSE);
    if(emaHandle == INVALID_HANDLE) return 0.0;
    
    double emaBuffer[];
    ArraySetAsSeries(emaBuffer, true);
    double ema = 0;
    if(CopyBuffer(emaHandle, 0, 0, 1, emaBuffer) > 0) ema = emaBuffer[0];
    IndicatorRelease(emaHandle);
    
    double low = iLow(symbol, tf, 0);
    return low - ema;
}

//--- Schaff Trend Cycle (simplified)
double CMarketAnalysis::CalculateSchaffTrend(string symbol, ENUM_TIMEFRAMES tf)
{
    int macd_fast_handle = iMA(symbol, tf, 23, 0, MODE_EMA, PRICE_CLOSE);
    int macd_slow_handle = iMA(symbol, tf, 50, 0, MODE_EMA, PRICE_CLOSE);
    
    if(macd_fast_handle == INVALID_HANDLE || macd_slow_handle == INVALID_HANDLE) return 50.0;
    
    double macdBuffer[];
    ArraySetAsSeries(macdBuffer, true);
    
    double macd_fast = 0, macd_slow = 0;
    if(CopyBuffer(macd_fast_handle, 0, 0, 1, macdBuffer) > 0) macd_fast = macdBuffer[0];
    if(CopyBuffer(macd_slow_handle, 0, 0, 1, macdBuffer) > 0) macd_slow = macdBuffer[0];
    
    IndicatorRelease(macd_fast_handle);
    IndicatorRelease(macd_slow_handle);
    
    double macd = macd_fast - macd_slow;
    
    // Simplified STC calculation
    return (macd > 0) ? 75.0 : 25.0;
}

//--- Alignment analysis methods
void CMarketAnalysis::AnalyzeOscillatorAlignment(string symbol)
{
    int bullishCount = 0, bearishCount = 0;
    
    // RSI
    if(m_indicators.rsi > 50) bullishCount++; else bearishCount++;
    
    // Stochastic
    if(m_indicators.stochastic > 50) bullishCount++; else bearishCount++;
    
    // MACD
    if(m_indicators.macd_main > m_indicators.macd_signal) bullishCount++; else bearishCount++;
    
    // Williams %R
    if(m_indicators.williams > -50) bullishCount++; else bearishCount++;
    
    // CCI
    if(m_indicators.cci > 0) bullishCount++; else bearishCount++;
    
    m_indicators.bullish_oscillator_alignment = bullishCount >= 4;
    m_indicators.bearish_oscillator_alignment = bearishCount >= 4;
}

void CMarketAnalysis::AnalyzeTrendAlignment(string symbol)
{
    int bullishCount = 0, bearishCount = 0;
    double currentPrice = iClose(symbol, PERIOD_CURRENT, 0);
    
    // ADX trend strength
    if(m_indicators.adx > 25) {
        if(m_indicators.dmi_plus > m_indicators.dmi_minus) bullishCount++;
        else bearishCount++;
    }
    
    // Parabolic SAR
    if(currentPrice > m_indicators.parabolic_sar) bullishCount++; else bearishCount++;
    
    // Supertrend
    if(currentPrice > m_indicators.supertrend) bullishCount++; else bearishCount++;
    
    // Aroon
    if(m_indicators.aroon_up > m_indicators.aroon_down) bullishCount++; else bearishCount++;
    
    m_indicators.bullish_trend_alignment = bullishCount >= 3;
    m_indicators.bearish_trend_alignment = bearishCount >= 3;
}

void CMarketAnalysis::AnalyzeVolumeAlignment(string symbol)
{
    int bullishCount = 0, bearishCount = 0;
    
    // OBV trend
    if(m_indicators.obv > 0) bullishCount++; else bearishCount++;
    
    // Chaikin Money Flow
    if(m_indicators.chaikin_mf > 0) bullishCount++; else bearishCount++;
    
    // Volume Oscillator
    if(m_indicators.volume_osc > 0) bullishCount++; else bearishCount++;
    
    // A/D Line
    if(m_indicators.ad_line > 0) bullishCount++; else bearishCount++;
    
    m_indicators.bullish_volume_alignment = bullishCount >= 3;
    m_indicators.bearish_volume_alignment = bearishCount >= 3;
}
