//+------------------------------------------------------------------+
//|                                             CorrelationAnalyzer.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Correlation analysis enumerations                               |
//+------------------------------------------------------------------+
enum ENUM_CORRELATION_TYPE
{
    CORRELATION_PEARSON,     // Pearson correlation coefficient
    CORRELATION_SPEARMAN,    // Spearman rank correlation
    CORRELATION_KENDALL,     // Kendall's tau correlation
    CORRELATION_ROLLING,     // Rolling correlation
    CORRELATION_DYNAMIC,     // Dynamic conditional correlation
    CORRELATION_COPULA       // Copula-based correlation
};

enum ENUM_CORRELATION_STRENGTH
{
    CORR_STRENGTH_NONE,      // No correlation (|r| < 0.1)
    CORR_STRENGTH_WEAK,      // Weak correlation (0.1 <= |r| < 0.3)
    CORR_STRENGTH_MODERATE,  // Moderate correlation (0.3 <= |r| < 0.7)
    CORR_STRENGTH_STRONG,    // Strong correlation (0.7 <= |r| < 0.9)
    CORR_STRENGTH_VERY_STRONG // Very strong correlation (|r| >= 0.9)
};

enum ENUM_CORRELATION_REGIME
{
    CORR_REGIME_STABLE,      // Stable correlation
    CORR_REGIME_INCREASING,  // Correlation increasing
    CORR_REGIME_DECREASING,  // Correlation decreasing
    CORR_REGIME_VOLATILE,    // Volatile correlation
    CORR_REGIME_BREAKDOWN    // Correlation breakdown
};

//+------------------------------------------------------------------+
//| Correlation analysis structures                                 |
//+------------------------------------------------------------------+
struct SCorrelationConfig
{
    int calculationPeriod;      // Period for correlation calculation
    int rollingWindow;          // Rolling window size
    double significanceLevel;   // Statistical significance level
    bool enableDynamicCorr;     // Enable dynamic correlation
    bool trackRegimeChanges;    // Track correlation regime changes
    ENUM_TIMEFRAMES timeframe;  // Timeframe for analysis
    ENUM_CORRELATION_TYPE corrType; // Type of correlation to calculate
};

struct SCorrelationPair
{
    string symbol1;
    string symbol2;
    double correlation;
    double pValue;              // Statistical significance
    ENUM_CORRELATION_STRENGTH strength;
    ENUM_CORRELATION_REGIME regime;
    datetime lastUpdate;
    double rollingCorr[];       // Rolling correlation history
    bool isStatisticallySignificant;
};

struct SCorrelationMatrix
{
    string symbols[];
    double correlationMatrix[][]; // [i][j] = correlation between symbols[i] and symbols[j]
    datetime lastUpdate;
    double eigenValues[];       // For principal component analysis
    double eigenVectors[][];    // Eigenvectors for PCA
};

struct SPortfolioCorrelation
{
    string symbols[];
    double weights[];
    double portfolioVariance;
    double diversificationRatio;
    double concentrationRisk;
    double maxCorrelation;
    double avgCorrelation;
    datetime lastUpdate;
};

//+------------------------------------------------------------------+
//| Advanced Correlation Analyzer class                             |
//| Analyzes correlations between currency pairs for risk management |
//+------------------------------------------------------------------+
class CCorrelationAnalyzer
{
private:
    // Configuration
    SCorrelationConfig m_config;
    
    // Correlation data
    SCorrelationPair m_correlationPairs[];
    SCorrelationMatrix m_correlationMatrix;
    SPortfolioCorrelation m_portfolioStats;
    
    // Price data storage for correlation calculation
    double m_priceData[][]; // [symbol_index][time_index]
    datetime m_timeStamps[];
    string m_trackedSymbols[];
    
    // Dynamic correlation tracking
    double m_dynamicCorrelations[][];
    datetime m_lastCorrelationUpdate[];
    
    // Regime detection
    ENUM_CORRELATION_REGIME m_correlationRegimes[][];
    double m_regimeChangeThreshold;
    
public:
    //--- Constructor/Destructor
    CCorrelationAnalyzer();
    ~CCorrelationAnalyzer();
    
    //--- Initialization
    bool Initialize(const SCorrelationConfig &config);
    bool AddSymbolPair(const string symbol1, const string symbol2);
    bool AddSymbols(const string symbols[]);
    void SetConfiguration(const SCorrelationConfig &config);
    
    //--- Main correlation analysis
    bool UpdateCorrelations();
    bool CalculateCorrelationMatrix();
    bool AnalyzePortfolioCorrelations(const string symbols[], const double weights[]);
    
    //--- Correlation calculation methods
    double CalculatePearsonCorrelation(const string symbol1, const string symbol2, int period = 0);
    double CalculateSpearmanCorrelation(const string symbol1, const string symbol2, int period = 0);
    double CalculateRollingCorrelation(const string symbol1, const string symbol2, int window = 20);
    double CalculateDynamicCorrelation(const string symbol1, const string symbol2);
    
    //--- Correlation strength and significance
    ENUM_CORRELATION_STRENGTH DetermineCorrelationStrength(double correlation);
    bool IsCorrelationSignificant(double correlation, int sampleSize, double alpha = 0.05);
    double CalculateCorrelationPValue(double correlation, int sampleSize);
    
    //--- Regime detection and analysis
    ENUM_CORRELATION_REGIME DetectCorrelationRegime(const string symbol1, const string symbol2);
    bool IsCorrelationBreakdown(const string symbol1, const string symbol2);
    bool IsCorrelationStable(const string symbol1, const string symbol2);
    double GetCorrelationVolatility(const string symbol1, const string symbol2);
    
    //--- Risk management applications
    bool IsExcessiveCorrelation(const string symbols[]);
    double CalculateConcentrationRisk(const string symbols[], const double volumes[]);
    bool ShouldLimitExposure(const string symbol1, const string symbol2, double proposedVolume);
    double GetMaxAllowedExposure(const string symbol, const string correlatedSymbols[]);
    
    //--- Portfolio optimization
    double CalculateDiversificationRatio(const string symbols[], const double weights[]);
    double CalculatePortfolioVariance(const string symbols[], const double weights[]);
    void OptimizePortfolioWeights(const string symbols[], double weights[]);
    bool IsPortfolioDiversified(const string symbols[], const double weights[]);
    
    //--- Principal Component Analysis
    bool PerformPCA();
    double GetFirstPrincipalComponent();
    int GetEffectiveNumberOfAssets();
    double GetExplainedVarianceRatio(int component);
    
    //--- Correlation forecasting
    double ForecastCorrelation(const string symbol1, const string symbol2, int periodsAhead = 1);
    bool IsCorrelationMeanReverting(const string symbol1, const string symbol2);
    double CalculateCorrelationHalfLife(const string symbol1, const string symbol2);
    
    //--- Event analysis
    bool DetectCorrelationSurge(const string symbols[]);
    bool IsStressCorrelation(const string symbols[]);
    bool DetectDecoupling(const string symbol1, const string symbol2);
    
    //--- Cross-asset correlations
    double CalculateFXEquityCorrelation(const string fxPair, const string equityIndex);
    double CalculateFXBondCorrelation(const string fxPair, const string bondIndex);
    double CalculateIntermarketCorrelation(const string symbols[], const string markets[]);
    
    //--- Getters and utilities
    double GetCorrelation(const string symbol1, const string symbol2);
    SCorrelationPair GetCorrelationPair(const string symbol1, const string symbol2);
    SCorrelationMatrix GetCorrelationMatrix() { return m_correlationMatrix; }
    double GetAverageCorrelation(const string symbols[]);
    double GetMaxCorrelation(const string symbols[]);
    
    //--- Risk metrics
    double GetPortfolioConcentrationRisk() { return m_portfolioStats.concentrationRisk; }
    double GetDiversificationRatio() { return m_portfolioStats.diversificationRatio; }
    bool IsCorrelationRiskElevated();
    
    //--- Configuration getters/setters
    void SetCalculationPeriod(int period) { m_config.calculationPeriod = period; }
    void SetRollingWindow(int window) { m_config.rollingWindow = window; }
    void SetSignificanceLevel(double level) { m_config.significanceLevel = level; }
    
private:
    //--- Internal calculation helpers
    bool UpdatePriceData();
    double CalculateReturns(const string symbol, int period);
    void GetPriceReturns(const string symbol, double returns[], int period);
    
    //--- Statistical functions
    double CalculateCovariance(const double data1[], const double data2[], int size);
    double CalculateVariance(const double data[], int size);
    double CalculateMean(const double data[], int size);
    double CalculateStandardDeviation(const double data[], int size);
    
    //--- Array management
    int FindSymbolIndex(const string symbol);
    int FindCorrelationPairIndex(const string symbol1, const string symbol2);
    void ResizePriceDataArrays(int symbolCount, int timeCount);
    void UpdateCorrelationHistory(const string symbol1, const string symbol2, double correlation);
    
    //--- Matrix operations
    bool InvertMatrix(double matrix[][], int size);
    void MultiplyMatrices(const double matrix1[][], const double matrix2[][], double result[][], int size);
    bool CalculateEigenValues(const double matrix[][], double eigenValues[], int size);
    
    //--- PCA implementation
    void StandardizeData(double data[][], int rows, int cols);
    void CalculateCovarianceMatrix(const double data[][], double covMatrix[][], int rows, int cols);
    bool SolveEigenProblem(const double matrix[][], double eigenValues[], double eigenVectors[][], int size);
    
    //--- Regime detection helpers
    void UpdateRegimeHistory(const string symbol1, const string symbol2, ENUM_CORRELATION_REGIME regime);
    double CalculateRegimeTransitionProbability(const string symbol1, const string symbol2);
    
    //--- Validation and diagnostics
    bool ValidateCorrelationData();
    void LogCorrelationUpdate(const string symbol1, const string symbol2, double correlation);
    void LogCorrelationMatrix();
    void LogPortfolioStats();
};