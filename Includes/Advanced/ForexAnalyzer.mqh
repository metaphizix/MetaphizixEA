//+------------------------------------------------------------------+
//|                                                ForexAnalyzer.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "../Core/Config.mqh"

//+------------------------------------------------------------------+
//| Technical analysis enumerations                                 |
//+------------------------------------------------------------------+
enum ENUM_INDICATOR_TYPE
{
    INDICATOR_RSI,          // Relative Strength Index
    INDICATOR_MACD,         // MACD
    INDICATOR_SMA,          // Simple Moving Average
    INDICATOR_EMA,          // Exponential Moving Average
    INDICATOR_BOLLINGER,    // Bollinger Bands
    INDICATOR_ATR,          // Average True Range
    INDICATOR_STOCHASTIC,   // Stochastic Oscillator
    INDICATOR_ADX,          // Average Directional Index
    INDICATOR_ICHIMOKU,     // Ichimoku Cloud
    INDICATOR_FIBONACCI,    // Fibonacci Retracements
    INDICATOR_SUPPORT_RESISTANCE, // Support/Resistance levels
    INDICATOR_PIVOT_POINTS, // Pivot Points
    
    // Missing essential oscillators
    INDICATOR_WILLIAMS_R,   // Williams %R
    INDICATOR_CCI,          // Commodity Channel Index
    INDICATOR_MOMENTUM,     // Momentum Oscillator
    INDICATOR_ROC,          // Rate of Change
    INDICATOR_STOCH_RSI,    // Stochastic RSI
    INDICATOR_MFI,          // Money Flow Index
    INDICATOR_ULTIMATE_OSC, // Ultimate Oscillator
    INDICATOR_AWESOME_OSC,  // Awesome Oscillator
    INDICATOR_TSI,          // True Strength Index
    
    // Missing trend indicators
    INDICATOR_PARABOLIC_SAR, // Parabolic SAR
    INDICATOR_SUPERTREND,   // SuperTrend
    INDICATOR_AROON,        // Aroon Indicator
    INDICATOR_VORTEX,       // Vortex Indicator
    INDICATOR_DMI,          // Directional Movement Index
    INDICATOR_TRIX,         // TRIX
    INDICATOR_MASS_INDEX,   // Mass Index
    
    // Missing volume indicators
    INDICATOR_OBV,          // On-Balance Volume
    INDICATOR_VOLUME_OSC,   // Volume Oscillator
    INDICATOR_CHAIKIN_MF,   // Chaikin Money Flow
    INDICATOR_AD_LINE,      // Accumulation/Distribution Line
    INDICATOR_VWAP,         // Volume Weighted Average Price
    INDICATOR_KLINGER,      // Klinger Volume Oscillator
    
    // Missing volatility indicators
    INDICATOR_KELTNER,      // Keltner Channels
    INDICATOR_DONCHIAN,     // Donchian Channels
    INDICATOR_VOLATILITY_STOP, // Volatility Stop
    INDICATOR_CHOPPINESS,   // Choppiness Index
    
    // Advanced composite indicators
    INDICATOR_ELDER_RAY,    // Elder Ray Index
    INDICATOR_SCHAFF_TREND  // Schaff Trend Cycle
};

enum ENUM_MARKET_CONDITION
{
    MARKET_TRENDING_UP,     // Strong uptrend
    MARKET_TRENDING_DOWN,   // Strong downtrend
    MARKET_RANGING,         // Sideways/ranging market
    MARKET_VOLATILE,        // High volatility
    MARKET_QUIET,           // Low volatility
    MARKET_UNCERTAIN        // Mixed signals
};

enum ENUM_SIGNAL_STRENGTH
{
    SIGNAL_STRENGTH_WEAK,     // Weak signal (0-30%)
    SIGNAL_STRENGTH_MODERATE, // Moderate signal (30-60%)
    SIGNAL_STRENGTH_STRONG,   // Strong signal (60-80%)
    SIGNAL_STRENGTH_VERY_STRONG // Very strong signal (80-100%)
};

//+------------------------------------------------------------------+
//| Technical analysis structures                                   |
//+------------------------------------------------------------------+
struct SIndicatorConfig
{
    ENUM_INDICATOR_TYPE type;
    ENUM_TIMEFRAMES timeframe;
    int period;
    double weight;
    bool enabled;
    string parameters; // Additional parameters as string
};

struct STechnicalSignal
{
    string symbol;
    ENUM_SIGNAL_TYPE type;
    ENUM_SIGNAL_STRENGTH strength;
    double confidence;
    double entryPrice;
    double stopLoss;
    double takeProfit;
    string indicators[]; // Contributing indicators
    datetime signalTime;
    string analysis;
};

struct SMarketAnalysis
{
    string symbol;
    ENUM_MARKET_CONDITION condition;
    double trendStrength;
    double volatility;
    double momentum;
    double volume;
    double supportLevel;
    double resistanceLevel;
    datetime analysisTime;
};

//+------------------------------------------------------------------+
//| Advanced Forex Analyzer class                                   |
//| Performs comprehensive technical analysis using multiple indicators |
//+------------------------------------------------------------------+
class CForexAnalyzer
{
private:
    // Configuration
    SIndicatorConfig m_indicators[];
    ENUM_TIMEFRAMES m_primaryTimeframe;
    ENUM_TIMEFRAMES m_secondaryTimeframes[];
    
    // Analysis cache
    SMarketAnalysis m_marketAnalysis[];
    STechnicalSignal m_signals[];
    datetime m_lastAnalysisTime[];
    
    // Indicator handles
    int m_rsiHandle[];
    int m_macdHandle[];
    int m_smaHandle[];
    int m_emaHandle[];
    int m_bollingerHandle[];
    int m_atrHandle[];
    int m_stochasticHandle[];
    int m_adxHandle[];
    int m_ichimokuHandle[];
    
    // Missing indicator handles
    int m_williamsRHandle[];
    int m_cciHandle[];
    int m_momentumHandle[];
    int m_rocHandle[];
    int m_stochRSIHandle[];
    int m_mfiHandle[];
    int m_parabolicSARHandle[];
    int m_aroonHandle[];
    int m_vortexHandle[];
    int m_obvHandle[];
    int m_chaikinMFHandle[];
    int m_keltnerHandle[];
    int m_donchianHandle[];
    
    // Multi-timeframe analysis
    bool m_multiTimeframeEnabled;
    double m_timeframeWeights[];
    
public:
    //--- Constructor/Destructor
    CForexAnalyzer();
    ~CForexAnalyzer();
    
    //--- Initialization
    bool Initialize(ENUM_TIMEFRAMES primaryTF = PERIOD_H1);
    bool InitializeIndicators(const string symbol);
    void SetIndicatorConfiguration(SIndicatorConfig &configs[]);
    void EnableMultiTimeframeAnalysis(ENUM_TIMEFRAMES &timeframes[]);
    
    //--- Main analysis methods
    bool AnalyzeSymbol(const string symbol);
    STechnicalSignal GenerateSignal(const string symbol);
    SMarketAnalysis GetMarketCondition(const string symbol);
    bool IsSignalValid(const STechnicalSignal &signal);
    
    //--- Individual indicator analysis
    double AnalyzeRSI(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeMACD(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeBollinger(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeStochastic(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeADX(const string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Missing oscillator analysis
    double AnalyzeWilliamsR(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeCCI(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeMomentum(const string symbol, ENUM_TIMEFRAMES tf, int period = 10);
    double AnalyzeROC(const string symbol, ENUM_TIMEFRAMES tf, int period = 12);
    double AnalyzeStochRSI(const string symbol, ENUM_TIMEFRAMES tf, int rsiPeriod = 14, int stochPeriod = 14);
    double AnalyzeMFI(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeUltimateOscillator(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeAwesomeOscillator(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeTSI(const string symbol, ENUM_TIMEFRAMES tf, int r = 25, int s = 13);
    
    //--- Missing trend analysis
    double AnalyzeParabolicSAR(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeSupertrend(const string symbol, ENUM_TIMEFRAMES tf, int period = 10, double multiplier = 3.0);
    double AnalyzeAroon(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeVortex(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeDMI(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeTRIX(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double AnalyzeMassIndex(const string symbol, ENUM_TIMEFRAMES tf, int period = 25);
    
    //--- Missing volume analysis
    double AnalyzeOBV(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeVolumeOscillator(const string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 10);
    double AnalyzeChaikinMF(const string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    double AnalyzeADLine(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeVWAP(const string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    double AnalyzeKlinger(const string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Missing volatility analysis
    double AnalyzeKeltner(const string symbol, ENUM_TIMEFRAMES tf, int period = 20, double multiplier = 2.0);
    double AnalyzeDonchian(const string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    double AnalyzeVolatilityStop(const string symbol, ENUM_TIMEFRAMES tf);
    double AnalyzeChoppiness(const string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    
    //--- Advanced composite analysis
    double AnalyzeElderRay(const string symbol, ENUM_TIMEFRAMES tf, int period = 13);
    double AnalyzeSchaffTrend(const string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Trend analysis
    ENUM_MARKET_CONDITION DetermineTrend(const string symbol);
    double CalculateTrendStrength(const string symbol);
    bool IsTrendConfirmed(const string symbol);
    
    //--- Support/Resistance analysis
    double FindSupportLevel(const string symbol, int lookback = 50);
    double FindResistanceLevel(const string symbol, int lookback = 50);
    bool IsPriceNearSupport(const string symbol, double tolerance = 10);
    bool IsPriceNearResistance(const string symbol, double tolerance = 10);
    
    //--- Volume and momentum analysis
    double AnalyzeVolume(const string symbol);
    double CalculateMomentum(const string symbol, int period = 10);
    bool IsVolumeDivergence(const string symbol);
    
    //--- Multi-timeframe analysis
    double GetConsensusSignal(const string symbol);
    bool IsMultiTimeframeAligned(const string symbol);
    double CalculateTimeframeConsensus(const string symbol, ENUM_SIGNAL_TYPE signalType);
    
    //--- Pattern recognition
    bool DetectDoubleTop(const string symbol);
    bool DetectDoubleBottom(const string symbol);
    bool DetectHeadAndShoulders(const string symbol);
    bool DetectTriangle(const string symbol);
    bool DetectChannelBreakout(const string symbol);
    
    //--- Fibonacci analysis
    double CalculateFibonacciRetracement(const string symbol, double high, double low, double level);
    bool IsPriceAtFibLevel(const string symbol, double tolerance = 5);
    
    //--- Divergence analysis
    bool DetectBullishDivergence(const string symbol);
    bool DetectBearishDivergence(const string symbol);
    
    //--- Signal filtering and validation
    bool PassesSignalFilters(const STechnicalSignal &signal);
    double CalculateSignalConfidence(const string symbol, const STechnicalSignal &signal);
    bool ValidateWithPriceAction(const string symbol, const STechnicalSignal &signal);
    
    //--- Getters and configuration
    SMarketAnalysis GetLatestAnalysis(const string symbol);
    STechnicalSignal GetLatestSignal(const string symbol);
    void SetPrimaryTimeframe(ENUM_TIMEFRAMES tf) { m_primaryTimeframe = tf; }
    ENUM_TIMEFRAMES GetPrimaryTimeframe() const { return m_primaryTimeframe; }
    
private:
    //--- Helper methods
    bool CreateIndicatorHandles(const string symbol);
    void ReleaseIndicatorHandles();
    double NormalizeIndicatorValue(double value, ENUM_INDICATOR_TYPE type);
    
    //--- Cache management
    void UpdateAnalysisCache(const string symbol, const SMarketAnalysis &analysis);
    void UpdateSignalCache(const string symbol, const STechnicalSignal &signal);
    void CleanupOldData();
    
    //--- Technical calculations
    double CalculateMovingAverage(const string symbol, int period, ENUM_MA_METHOD method, ENUM_TIMEFRAMES tf);
    double CalculateATR(const string symbol, int period, ENUM_TIMEFRAMES tf);
    double CalculateVolatility(const string symbol, int period, ENUM_TIMEFRAMES tf);
    
    //--- Signal combination logic
    double CombineIndicatorSignals(const string symbol, double &signals[]);
    ENUM_SIGNAL_STRENGTH DetermineSignalStrength(double confidence);
    
    //--- Validation helpers
    bool IsEnoughHistoryData(const string symbol, int requiredBars);
    bool AreIndicatorsReady(const string symbol);
    
    //--- Logging and diagnostics
    void LogAnalysisResults(const string symbol, const SMarketAnalysis &analysis);
    void LogSignalGeneration(const string symbol, const STechnicalSignal &signal);
};