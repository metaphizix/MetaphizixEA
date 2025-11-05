//+------------------------------------------------------------------+
//|                                          TechnicalIndicators.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "../Core/Config.mqh"

//+------------------------------------------------------------------+
//| Enhanced Technical Indicators Class                             |
//| Comprehensive collection of missing essential indicators        |
//+------------------------------------------------------------------+

//--- Extended indicator types
enum ENUM_ENHANCED_INDICATOR_TYPE
{
    // Missing oscillators
    ENHANCED_WILLIAMS_R,         // Williams %R
    ENHANCED_COMMODITY_CHANNEL,  // Commodity Channel Index (CCI)
    ENHANCED_MOMENTUM,           // Momentum Oscillator
    ENHANCED_ROC,                // Rate of Change
    ENHANCED_STOCH_RSI,          // Stochastic RSI
    ENHANCED_TRUE_STRENGTH,      // True Strength Index (TSI)
    ENHANCED_ULTIMATE_OSC,       // Ultimate Oscillator
    ENHANCED_AWESOME_OSC,        // Awesome Oscillator
    
    // Missing trend indicators
    ENHANCED_PARABOLIC_SAR,      // Parabolic SAR
    ENHANCED_SUPERTREND,         // SuperTrend
    ENHANCED_AROON,              // Aroon Indicator
    ENHANCED_VORTEX,             // Vortex Indicator
    ENHANCED_DMI,                // Directional Movement Index
    ENHANCED_MASS_INDEX,         // Mass Index
    ENHANCED_TRIX,               // TRIX
    
    // Missing volume indicators
    ENHANCED_OBV,                // On-Balance Volume
    ENHANCED_VOLUME_OSC,         // Volume Oscillator
    ENHANCED_CHAIKIN_MF,         // Chaikin Money Flow
    ENHANCED_ACCUMULATION_DIST,  // Accumulation/Distribution Line
    ENHANCED_VOLUME_PROFILE,     // Volume Profile
    ENHANCED_VWAP,               // Volume Weighted Average Price
    ENHANCED_MONEY_FLOW_INDEX,   // Money Flow Index
    
    // Missing volatility indicators
    ENHANCED_KELTNER_CHANNELS,   // Keltner Channels
    ENHANCED_DONCHIAN_CHANNELS,  // Donchian Channels
    ENHANCED_VOLATILITY_STOP,    // Volatility Stop
    ENHANCED_CHOPPINESS_INDEX,   // Choppiness Index
    
    // Japanese candlestick patterns
    ENHANCED_HEIKEN_ASHI,        // Heiken Ashi
    ENHANCED_RENKO,              // Renko Charts
    
    // Fibonacci-based indicators
    ENHANCED_FIBONACCI_RETRACEMENT, // Fibonacci Retracements
    ENHANCED_FIBONACCI_EXTENSION,   // Fibonacci Extensions
    ENHANCED_FIBONACCI_FANS,        // Fibonacci Fans
    
    // Market microstructure
    ENHANCED_ORDER_FLOW,         // Order Flow Analysis
    ENHANCED_MARKET_PROFILE,     // Market Profile
    ENHANCED_DELTA,              // Delta Analysis
    
    // Advanced composites
    ENHANCED_ICHIMOKU_FULL,      // Complete Ichimoku Cloud
    ENHANCED_ELDER_RAY,          // Elder Ray Index
    ENHANCED_SCHAFF_TREND,       // Schaff Trend Cycle
    ENHANCED_KLINGER_OSC         // Klinger Volume Oscillator
};

//--- Indicator calculation structures
struct SWilliamsR
{
    double value;
    bool isBullish;
    bool isBearish;
    double signalStrength;
};

struct SParabolicSAR
{
    double value;
    bool isBullish;
    double acceleration;
    double extremePoint;
};

struct SOBVData
{
    double value;
    double trend;
    bool isAccumulation;
    bool isDistribution;
};

struct SVWAPData
{
    double vwap;
    double upperBand;
    double lowerBand;
    bool isPriceAbove;
    bool isPriceBelow;
};

struct SIchimokuComplete
{
    double tenkanSen;        // Conversion Line
    double kijunSen;         // Base Line
    double senkouSpanA;      // Leading Span A
    double senkouSpanB;      // Leading Span B
    double chikouSpan;       // Lagging Span
    bool isBullishCloud;     // Kumo cloud bullish
    bool isPriceAboveCloud;  // Price above cloud
    bool isTenkanAboveKijun; // Tenkan above Kijun
};

struct SAroonData
{
    double aroonUp;
    double aroonDown;
    double aroonOscillator;
    bool isBullish;
    bool isBearish;
};

struct SKeltnerChannels
{
    double upper;
    double middle;
    double lower;
    bool isPriceAbove;
    bool isPriceBelow;
    double position; // Price position within bands (0-1)
};

struct SChaikinMoneyFlow
{
    double cmf;
    bool isAccumulation;
    bool isDistribution;
    double strength;
};

struct STrueStrengthIndex
{
    double tsi;
    double signal;
    bool isBullish;
    bool isBearish;
    double momentum;
};

//+------------------------------------------------------------------+
//| Enhanced Technical Indicators Class                             |
//+------------------------------------------------------------------+
class CTechnicalIndicators
{
private:
    // Indicator buffers
    double m_williamsR[];
    double m_parabolicSAR[];
    double m_obv[];
    double m_vwap[];
    double m_aroonUp[];
    double m_aroonDown[];
    double m_keltnerUpper[];
    double m_keltnerMiddle[];
    double m_keltnerLower[];
    double m_chaikinMF[];
    double m_tsi[];
    double m_tsiSignal[];
    
    // Ichimoku components
    double m_tenkanSen[];
    double m_kijunSen[];
    double m_senkouSpanA[];
    double m_senkouSpanB[];
    double m_chikouSpan[];
    
    // Configuration
    string m_symbol;
    ENUM_TIMEFRAMES m_timeframe;
    bool m_initialized;
    
public:
    //--- Constructor/Destructor
    CTechnicalIndicators();
    ~CTechnicalIndicators();
    
    //--- Initialization
    bool Initialize(string symbol, ENUM_TIMEFRAMES timeframe);
    void Deinitialize();
    
    //--- Williams %R
    double CalculateWilliamsR(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    SWilliamsR GetWilliamsRData(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    bool IsWilliamsROverbought(double williamsR, double threshold = -20.0);
    bool IsWilliamsROversold(double williamsR, double threshold = -80.0);
    
    //--- Parabolic SAR
    double CalculateParabolicSAR(string symbol, ENUM_TIMEFRAMES tf, double step = 0.02, double maximum = 0.2, int shift = 0);
    SParabolicSAR GetParabolicSARData(string symbol, ENUM_TIMEFRAMES tf);
    bool IsParabolicSARBullish(string symbol, ENUM_TIMEFRAMES tf);
    ENUM_ORDER_TYPE GetParabolicSARSignal(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- On-Balance Volume (OBV)
    double CalculateOBV(string symbol, ENUM_TIMEFRAMES tf, int shift = 0);
    SOBVData GetOBVData(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    bool IsOBVConfirmingTrend(string symbol, ENUM_TIMEFRAMES tf);
    bool DetectOBVDivergence(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    
    //--- Volume Weighted Average Price (VWAP)
    double CalculateVWAP(string symbol, ENUM_TIMEFRAMES tf, int period = 20, int shift = 0);
    SVWAPData GetVWAPData(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    bool IsVWAPBullish(string symbol, ENUM_TIMEFRAMES tf);
    double GetVWAPBias(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Aroon Indicator
    double CalculateAroonUp(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    double CalculateAroonDown(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    SAroonData GetAroonData(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    bool IsAroonBullish(const SAroonData &aroon);
    double GetAroonOscillator(const SAroonData &aroon);
    
    //--- Keltner Channels
    double CalculateKeltnerUpper(string symbol, ENUM_TIMEFRAMES tf, int period = 20, double multiplier = 2.0, int shift = 0);
    double CalculateKeltnerLower(string symbol, ENUM_TIMEFRAMES tf, int period = 20, double multiplier = 2.0, int shift = 0);
    SKeltnerChannels GetKeltnerChannels(string symbol, ENUM_TIMEFRAMES tf, int period = 20, double multiplier = 2.0);
    bool IsKeltnerBreakout(string symbol, ENUM_TIMEFRAMES tf);
    double GetKeltnerPosition(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Chaikin Money Flow
    double CalculateChaikinMF(string symbol, ENUM_TIMEFRAMES tf, int period = 20, int shift = 0);
    SChaikinMoneyFlow GetChaikinMFData(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    bool IsChaikinAccumulation(const SChaikinMoneyFlow &cmf);
    bool IsChaikinDistribution(const SChaikinMoneyFlow &cmf);
    
    //--- True Strength Index (TSI)
    double CalculateTSI(string symbol, ENUM_TIMEFRAMES tf, int r = 25, int s = 13, int shift = 0);
    STrueStrengthIndex GetTSIData(string symbol, ENUM_TIMEFRAMES tf, int r = 25, int s = 13);
    bool IsTSIBullish(const STrueStrengthIndex &tsi);
    bool IsTSIMomentumPositive(const STrueStrengthIndex &tsi);
    
    //--- Complete Ichimoku Cloud
    SIchimokuComplete CalculateIchimoku(string symbol, ENUM_TIMEFRAMES tf, int tenkan = 9, int kijun = 26, int senkou = 52);
    bool IsIchimokuBullish(const SIchimokuComplete &ichimoku);
    bool IsPriceAboveCloud(const SIchimokuComplete &ichimoku, double currentPrice);
    double GetIchimokuSignalStrength(const SIchimokuComplete &ichimoku, double currentPrice);
    
    //--- Money Flow Index (MFI)
    double CalculateMFI(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    bool IsMFIOverbought(double mfi, double threshold = 80.0);
    bool IsMFIOversold(double mfi, double threshold = 20.0);
    bool DetectMFIDivergence(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    
    //--- Rate of Change (ROC)
    double CalculateROC(string symbol, ENUM_TIMEFRAMES tf, int period = 12, int shift = 0);
    bool IsROCPositive(double roc);
    double GetROCMomentum(string symbol, ENUM_TIMEFRAMES tf, int period = 12);
    
    //--- Stochastic RSI
    double CalculateStochRSI(string symbol, ENUM_TIMEFRAMES tf, int rsiPeriod = 14, int stochPeriod = 14, int kPeriod = 3, int dPeriod = 3, int shift = 0);
    bool IsStochRSIOverbought(double stochRSI, double threshold = 0.8);
    bool IsStochRSIOversold(double stochRSI, double threshold = 0.2);
    
    //--- Ultimate Oscillator
    double CalculateUltimateOscillator(string symbol, ENUM_TIMEFRAMES tf, int period1 = 7, int period2 = 14, int period3 = 28, int shift = 0);
    bool IsUltimateOscBullish(double uo);
    bool IsUltimateOscBearish(double uo);
    
    //--- Awesome Oscillator
    double CalculateAwesomeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 34, int shift = 0);
    bool IsAwesomeOscBullish(string symbol, ENUM_TIMEFRAMES tf);
    bool DetectAwesomeOscSaucer(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Commodity Channel Index (Enhanced)
    double CalculateEnhancedCCI(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    bool IsCCIOverbought(double cci, double threshold = 100.0);
    bool IsCCIOversold(double cci, double threshold = -100.0);
    bool DetectCCIDivergence(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    
    //--- Donchian Channels
    double CalculateDonchianUpper(string symbol, ENUM_TIMEFRAMES tf, int period = 20, int shift = 0);
    double CalculateDonchianLower(string symbol, ENUM_TIMEFRAMES tf, int period = 20, int shift = 0);
    bool IsDonchianBreakout(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    double GetDonchianPosition(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    
    //--- Supertrend
    double CalculateSupertrendUpper(string symbol, ENUM_TIMEFRAMES tf, int period = 10, double multiplier = 3.0, int shift = 0);
    double CalculateSupertrendLower(string symbol, ENUM_TIMEFRAMES tf, int period = 10, double multiplier = 3.0, int shift = 0);
    bool IsSupertrendBullish(string symbol, ENUM_TIMEFRAMES tf);
    ENUM_ORDER_TYPE GetSupertrendSignal(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Vortex Indicator
    double CalculateVortexPositive(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    double CalculateVortexNegative(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    bool IsVortexBullish(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    double GetVortexDifference(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    
    //--- TRIX
    double CalculateTRIX(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    bool IsTRIXBullish(string symbol, ENUM_TIMEFRAMES tf, int period = 14);
    bool DetectTRIXSignalLine(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int signalPeriod = 9);
    
    //--- Mass Index
    double CalculateMassIndex(string symbol, ENUM_TIMEFRAMES tf, int period = 25, int shift = 0);
    bool IsMassIndexReversalSignal(double massIndex, double threshold = 27.0);
    
    //--- Choppiness Index
    double CalculateChoppinessIndex(string symbol, ENUM_TIMEFRAMES tf, int period = 14, int shift = 0);
    bool IsMarketChopping(double choppiness, double threshold = 61.8);
    bool IsMarketTrending(double choppiness, double threshold = 38.2);
    
    //--- Volume Oscillator
    double CalculateVolumeOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 5, int longPeriod = 10, int shift = 0);
    bool IsVolumeOscillatorPositive(double vo);
    bool DetectVolumeOscillatorDivergence(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Accumulation/Distribution Line
    double CalculateAccumulationDistribution(string symbol, ENUM_TIMEFRAMES tf, int shift = 0);
    bool IsAccumulationDistributionBullish(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    bool DetectADLineDivergence(string symbol, ENUM_TIMEFRAMES tf, int period = 20);
    
    //--- Elder Ray Index
    double CalculateElderRayBullPower(string symbol, ENUM_TIMEFRAMES tf, int period = 13, int shift = 0);
    double CalculateElderRayBearPower(string symbol, ENUM_TIMEFRAMES tf, int period = 13, int shift = 0);
    bool IsElderRayBullish(string symbol, ENUM_TIMEFRAMES tf, int period = 13);
    double GetElderRayBalance(string symbol, ENUM_TIMEFRAMES tf, int period = 13);
    
    //--- Schaff Trend Cycle
    double CalculateSchaffTrend(string symbol, ENUM_TIMEFRAMES tf, int period = 10, int shortMA = 23, int longMA = 50, int shift = 0);
    bool IsSchaffTrendBullish(double stc);
    bool IsSchaffTrendOverbought(double stc, double threshold = 75.0);
    bool IsSchaffTrendOversold(double stc, double threshold = 25.0);
    
    //--- Klinger Volume Oscillator
    double CalculateKlingerOscillator(string symbol, ENUM_TIMEFRAMES tf, int shortPeriod = 34, int longPeriod = 55, int shift = 0);
    bool IsKlingerBullish(string symbol, ENUM_TIMEFRAMES tf);
    bool DetectKlingerDivergence(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Composite Indicator Analysis
    double CalculateCompositeOscillator(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateCompositeTrend(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateCompositeVolume(string symbol, ENUM_TIMEFRAMES tf);
    double CalculateCompositeVolatility(string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Multi-Indicator Signals
    ENUM_ORDER_TYPE GetCompositeSignal(string symbol, ENUM_TIMEFRAMES tf);
    double GetCompositeSignalStrength(string symbol, ENUM_TIMEFRAMES tf);
    bool ValidateWithMultipleIndicators(ENUM_ORDER_TYPE signal, string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Indicator Screening
    void ScreenAllIndicators(string symbol, ENUM_TIMEFRAMES tf, double &bullishScore, double &bearishScore);
    string GetStrongestIndicatorSignal(string symbol, ENUM_TIMEFRAMES tf);
    bool AreIndicatorsAligned(string symbol, ENUM_TIMEFRAMES tf, double threshold = 70.0);
    
    //--- Utility functions
    bool IsIndicatorDivergence(double &indicatorArray[], double &priceArray[], int period);
    double NormalizeIndicatorValue(double value, double min, double max);
    bool IsIndicatorCrossover(double current, double previous, double level);
    double CalculateIndicatorSlope(double &array[], int period, int shift = 0);
    
    //--- Information functions
    string GetIndicatorStatus(ENUM_ENHANCED_INDICATOR_TYPE indicator, string symbol, ENUM_TIMEFRAMES tf);
    void PrintAllIndicators(string symbol, ENUM_TIMEFRAMES tf);
    bool IsIndicatorReliable(ENUM_ENHANCED_INDICATOR_TYPE indicator, string symbol, ENUM_TIMEFRAMES tf);
    
private:
    //--- Helper functions
    void InitializeBuffers();
    void ClearBuffers();
    double CalculateTypicalPrice(string symbol, ENUM_TIMEFRAMES tf, int shift);
    double CalculateTrueRange(string symbol, ENUM_TIMEFRAMES tf, int shift);
    double CalculateEMA(double &array[], int period, int index);
    double CalculateSMA(double &array[], int period, int index);
    double CalculateStandardDeviation(double &array[], int period, int index);
    
    //--- Volume calculations
    long GetRealVolume(string symbol, ENUM_TIMEFRAMES tf, int shift);
    double EstimateVolume(string symbol, ENUM_TIMEFRAMES tf, int shift);
    bool IsVolumeReliable(string symbol);
    
    //--- Mathematical helpers
    double CalculateSlope(double &array[], int period, int shift);
    double CalculateCorrelation(double &array1[], double &array2[], int period);
    double CalculateLinearRegression(double &array[], int period, int shift);
    
    //--- Validation helpers
    bool ValidatePriceData(string symbol, ENUM_TIMEFRAMES tf, int period);
    bool ValidateIndicatorData(double &array[], int size);
    void HandleMissingData(double &array[], int size);
};

//+------------------------------------------------------------------+
//| Enhanced Indicator Factory Class                                |
//+------------------------------------------------------------------+
class CIndicatorFactory
{
public:
    //--- Factory methods for creating indicators
    static CTechnicalIndicators* CreateTechnicalIndicators(string symbol, ENUM_TIMEFRAMES timeframe);
    static bool ValidateIndicatorRequirements(ENUM_ENHANCED_INDICATOR_TYPE type, string symbol, ENUM_TIMEFRAMES tf);
    static string GetIndicatorDescription(ENUM_ENHANCED_INDICATOR_TYPE type);
    static double GetIndicatorDefaultPeriod(ENUM_ENHANCED_INDICATOR_TYPE type);
    
    //--- Indicator optimization
    static int OptimizeIndicatorPeriod(ENUM_ENHANCED_INDICATOR_TYPE type, string symbol, ENUM_TIMEFRAMES tf, int minPeriod = 5, int maxPeriod = 50);
    static double OptimizeIndicatorParameters(ENUM_ENHANCED_INDICATOR_TYPE type, string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Indicator combinations
    static double CalculateIndicatorComposite(ENUM_ENHANCED_INDICATOR_TYPE &indicators[], double &weights[], int count, string symbol, ENUM_TIMEFRAMES tf);
    static bool TestIndicatorCombination(ENUM_ENHANCED_INDICATOR_TYPE &indicators[], int count, string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Performance analysis
    static double CalculateIndicatorAccuracy(ENUM_ENHANCED_INDICATOR_TYPE type, string symbol, ENUM_TIMEFRAMES tf, int testPeriod = 100);
    static void AnalyzeIndicatorPerformance(ENUM_ENHANCED_INDICATOR_TYPE type, string symbol, ENUM_TIMEFRAMES tf);
};

//--- Global indicator instance
extern CTechnicalIndicators* g_enhancedIndicators;