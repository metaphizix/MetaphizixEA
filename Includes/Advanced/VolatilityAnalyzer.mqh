//+------------------------------------------------------------------+
//|                                               VolatilityAnalyzer.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Volatility analysis enumerations                                |
//+------------------------------------------------------------------+
enum ENUM_VOLATILITY_REGIME
{
    VOLATILITY_VERY_LOW,    // Very low volatility (< 20th percentile)
    VOLATILITY_LOW,         // Low volatility (20-40th percentile)
    VOLATILITY_NORMAL,      // Normal volatility (40-60th percentile)
    VOLATILITY_HIGH,        // High volatility (60-80th percentile)
    VOLATILITY_VERY_HIGH,   // Very high volatility (> 80th percentile)
    VOLATILITY_EXTREME      // Extreme volatility (> 95th percentile)
};

enum ENUM_VOLATILITY_TREND
{
    VOL_TREND_DECREASING,   // Volatility decreasing
    VOL_TREND_STABLE,       // Volatility stable
    VOL_TREND_INCREASING,   // Volatility increasing
    VOL_TREND_VOLATILE      // Volatility of volatility
};

enum ENUM_VOLATILITY_TYPE
{
    VOL_TYPE_HISTORICAL,    // Historical volatility
    VOL_TYPE_REALIZED,      // Realized volatility
    VOL_TYPE_IMPLIED,       // Implied volatility (if available)
    VOL_TYPE_GARCH,         // GARCH model volatility
    VOL_TYPE_PARKINSON,     // Parkinson estimator
    VOL_TYPE_YANG_ZHANG     // Yang-Zhang estimator
};

//+------------------------------------------------------------------+
//| Volatility analysis structures                                  |
//+------------------------------------------------------------------+
struct SVolatilityConfig
{
    int historicalPeriod;      // Period for historical volatility
    int shortTermPeriod;       // Short-term volatility period
    int longTermPeriod;        // Long-term volatility period
    double thresholdLow;       // Low volatility threshold
    double thresholdHigh;      // High volatility threshold
    bool enableGARCH;          // Enable GARCH modeling
    bool enableRegimeDetection; // Enable regime detection
    ENUM_TIMEFRAMES timeframe;  // Primary timeframe for analysis
};

struct SVolatilityMetrics
{
    string symbol;
    double currentVolatility;   // Current volatility level
    double averageVolatility;   // Average volatility
    double volatilityPercentile; // Percentile ranking
    ENUM_VOLATILITY_REGIME regime; // Current volatility regime
    ENUM_VOLATILITY_TREND trend;   // Volatility trend
    double garchForecast;       // GARCH forecast (if enabled)
    datetime lastUpdate;
    double realized1D;          // 1-day realized volatility
    double realized1W;          // 1-week realized volatility
    double realized1M;          // 1-month realized volatility
};

struct SVolatilityBreakout
{
    string symbol;
    datetime time;
    double oldVolatility;
    double newVolatility;
    double breakoutRatio;
    ENUM_VOLATILITY_REGIME newRegime;
    bool isUpBreakout;
};

//+------------------------------------------------------------------+
//| Advanced Volatility Analyzer class                              |
//| Measures and analyzes market volatility for adaptive trading    |
//+------------------------------------------------------------------+
class CVolatilityAnalyzer
{
private:
    // Configuration
    SVolatilityConfig m_config;
    
    // Volatility data storage
    SVolatilityMetrics m_metrics[];
    string m_trackedSymbols[];
    
    // Historical volatility data
    double m_volatilityHistory[][]; // [symbol_index][time_index]
    datetime m_timeHistory[];
    
    // Volatility breakout detection
    SVolatilityBreakout m_recentBreakouts[];
    
    // GARCH model parameters (simplified)
    double m_garchAlpha;
    double m_garchBeta;
    double m_garchOmega;
    
    // Regime detection
    double m_regimeThresholds[];
    int m_regimeHistory[][]; // Historical regime data
    
public:
    //--- Constructor/Destructor
    CVolatilityAnalyzer();
    ~CVolatilityAnalyzer();
    
    //--- Initialization
    bool Initialize(const SVolatilityConfig &config);
    bool AddSymbol(const string symbol);
    void RemoveSymbol(const string symbol);
    void SetConfiguration(const SVolatilityConfig &config);
    
    //--- Main analysis methods
    bool UpdateVolatilityMetrics(const string symbol);
    SVolatilityMetrics GetVolatilityMetrics(const string symbol);
    bool AnalyzeAllSymbols();
    
    //--- Volatility calculation methods
    double CalculateHistoricalVolatility(const string symbol, int period = 20, ENUM_VOLATILITY_TYPE type = VOL_TYPE_HISTORICAL);
    double CalculateRealizedVolatility(const string symbol, int period = 20);
    double CalculateParkinsonVolatility(const string symbol, int period = 20);
    double CalculateYangZhangVolatility(const string symbol, int period = 20);
    double CalculateIntrabarVolatility(const string symbol);
    
    //--- Volatility regime analysis
    ENUM_VOLATILITY_REGIME DetermineVolatilityRegime(const string symbol);
    ENUM_VOLATILITY_TREND DetermineVolatilityTrend(const string symbol);
    bool DetectVolatilityBreakout(const string symbol);
    double GetVolatilityPercentile(const string symbol, int lookbackPeriod = 252);
    
    //--- GARCH modeling (simplified implementation)
    bool InitializeGARCH(const string symbol);
    double CalculateGARCHForecast(const string symbol);
    void UpdateGARCHParameters(const string symbol);
    
    //--- Volatility-based trading signals
    bool IsVolatilityExpansion(const string symbol);
    bool IsVolatilityContraction(const string symbol);
    bool IsOptimalVolatilityForEntry(const string symbol);
    bool ShouldAvoidTrading(const string symbol);
    
    //--- Risk adjustment based on volatility
    double CalculateVolatilityAdjustedRisk(const string symbol, double baseRisk);
    double CalculateVolatilityScaledStopLoss(const string symbol, double baseStopLoss);
    double GetVolatilityMultiplier(const string symbol);
    
    //--- Market regime detection
    bool IsHighVolatilityRegime(const string symbol);
    bool IsLowVolatilityRegime(const string symbol);
    bool IsVolatilityTransition(const string symbol);
    double GetRegimeStability(const string symbol);
    
    //--- Correlation and cross-asset volatility
    double CalculateVolatilityCorrelation(const string symbol1, const string symbol2);
    bool IsVolatilitySpillover(const string symbols[]);
    double GetPortfolioVolatility(const string symbols[], const double weights[]);
    
    //--- Volatility forecasting
    double ForecastVolatility(const string symbol, int periodsAhead = 1);
    bool IsVolatilityMeanReverting(const string symbol);
    double CalculateVolatilityHalfLife(const string symbol);
    
    //--- Event detection
    bool DetectVolatilityCluster(const string symbol);
    bool DetectVolatilityJump(const string symbol);
    bool IsNewsRelatedVolatility(const string symbol, datetime newsTime);
    
    //--- Performance and validation
    double CalculateVolatilityForecastAccuracy(const string symbol);
    void ValidateVolatilityModel(const string symbol);
    void RecalibrateModel(const string symbol);
    
    //--- Getters and utilities
    double GetCurrentVolatility(const string symbol);
    double GetAverageVolatility(const string symbol, int period = 20);
    ENUM_VOLATILITY_REGIME GetCurrentRegime(const string symbol);
    SVolatilityBreakout GetLatestBreakout(const string symbol);
    
    //--- Configuration getters/setters
    void SetHistoricalPeriod(int period) { m_config.historicalPeriod = period; }
    void SetVolatilityThresholds(double low, double high);
    void EnableGARCH(bool enable) { m_config.enableGARCH = enable; }
    
private:
    //--- Internal calculation helpers
    double CalculateLogReturns(const string symbol, int period);
    double CalculateReturnVariance(const string symbol, int period);
    void UpdateVolatilityHistory(const string symbol, double volatility);
    
    //--- Array management
    int FindSymbolIndex(const string symbol);
    void ResizeArrays(int newSymbolCount);
    void ShiftHistoryArrays();
    
    //--- Statistical functions
    double CalculatePercentile(const double data[], double percentile);
    double CalculateMovingAverage(const double data[], int period);
    double CalculateStandardDeviation(const double data[], int period);
    
    //--- GARCH implementation helpers
    void InitializeGARCHParameters();
    double CalculateGARCHVariance(const string symbol, double previousVariance, double previousReturn);
    void EstimateGARCHParameters(const string symbol, const double returns[]);
    
    //--- Regime detection helpers
    void UpdateRegimeHistory(const string symbol, ENUM_VOLATILITY_REGIME regime);
    double CalculateRegimeTransitionProbability(const string symbol);
    
    //--- Validation and diagnostics
    bool ValidateVolatilityData(const string symbol);
    void LogVolatilityMetrics(const string symbol);
    void LogVolatilityBreakout(const SVolatilityBreakout &breakout);
};