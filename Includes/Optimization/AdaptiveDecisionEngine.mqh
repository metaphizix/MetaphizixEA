//+------------------------------------------------------------------+
//|                                      AdaptiveDecisionEngine.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "../Core/Config.mqh"
#include "../Advanced/TechnicalIndicators.mqh"
#include "../Advanced/MLPredictor.mqh"
#include "../Advanced/SentimentAnalyzer.mqh"

//+------------------------------------------------------------------+
//| Adaptive Decision Making System                                 |
//| Dynamic algorithm selection based on market conditions         |
//+------------------------------------------------------------------+

//--- Market state enumerations
enum ENUM_MARKET_STATE
{
    MARKET_STATE_TRENDING_BULL,      // Strong bullish trend
    MARKET_STATE_TRENDING_BEAR,      // Strong bearish trend
    MARKET_STATE_RANGE_BOUND,        // Sideways/ranging
    MARKET_STATE_HIGH_VOLATILITY,    // High volatility environment
    MARKET_STATE_LOW_VOLATILITY,     // Low volatility/quiet
    MARKET_STATE_BREAKOUT,           // Breakout scenario
    MARKET_STATE_REVERSAL,           // Potential reversal
    MARKET_STATE_NEWS_IMPACT,        // High-impact news period
    MARKET_STATE_SESSION_TRANSITION, // Session change period
    MARKET_STATE_UNCERTAIN           // Mixed/unclear signals
};

enum ENUM_DECISION_MODE
{
    DECISION_MODE_CONSERVATIVE,      // Low risk, high confidence required
    DECISION_MODE_MODERATE,          // Balanced risk/reward
    DECISION_MODE_AGGRESSIVE,        // Higher risk, more opportunities
    DECISION_MODE_SCALPING,          // High frequency, low risk per trade
    DECISION_MODE_SWING,             // Medium-term position holding
    DECISION_MODE_TREND_FOLLOWING,   // Follow established trends
    DECISION_MODE_MEAN_REVERSION,    // Counter-trend trading
    DECISION_MODE_BREAKOUT_HUNTER,   // Breakout-focused trading
    DECISION_MODE_NEWS_TRADER,       // News-based trading
    DECISION_MODE_ML_DRIVEN          // Machine learning primary
};

enum ENUM_CONFIDENCE_LEVEL
{
    CONFIDENCE_VERY_LOW,    // 0-20%
    CONFIDENCE_LOW,         // 20-40%
    CONFIDENCE_MODERATE,    // 40-60%
    CONFIDENCE_HIGH,        // 60-80%
    CONFIDENCE_VERY_HIGH    // 80-100%
};

//--- Dynamic configuration structures
struct SAdaptiveConfig
{
    ENUM_DECISION_MODE primaryMode;
    ENUM_DECISION_MODE fallbackMode;
    double modeConfidence;
    double adaptationSpeed;          // How quickly to adapt (0.1-1.0)
    bool enableMLAdaptation;
    bool enableSentimentAdaptation;
    bool enableVolatilityAdaptation;
    bool enableSeasonalAdaptation;
    datetime lastAdaptation;
    int adaptationPeriod;            // Minutes between adaptations
};

struct SMarketProfile
{
    ENUM_MARKET_STATE currentState;
    ENUM_MARKET_STATE previousState;
    double stateConfidence;
    double trendStrength;
    double volatilityLevel;
    double liquidityLevel;
    double sentimentScore;
    double newsImpactLevel;
    string dominantCurrency;
    string weakestCurrency;
    datetime profileTimestamp;
    bool isSessionTransition;
    bool isHighImpactNews;
};

struct SDecisionMetrics
{
    double signalStrength;
    double riskLevel;
    double opportunityScore;
    double confidenceLevel;
    double expectedReward;
    double maxDrawdownRisk;
    double winProbability;
    int requiredConfirmations;
    bool passesDynamicFilters;
    string decisionReasoning;
};

struct SAdaptivePerformanceMetrics  // Renamed to avoid conflict with Config.mqh
{
    double accuracyByMode[10];       // Accuracy per decision mode
    double profitabilityByState[10]; // Profitability per market state
    int tradesCountByMode[10];
    double avgHoldingTime[10];
    double maxDD[10];
    double sharpeRatio[10];
    datetime lastUpdate;
    bool isLearningEnabled;
};

//+------------------------------------------------------------------+
//| Adaptive Decision Engine Class                                  |
//+------------------------------------------------------------------+
class CAdaptiveDecisionEngine
{
private:
    // Core components
    SAdaptiveConfig m_config;
    SMarketProfile m_marketProfile;
    SDecisionMetrics m_lastDecision;
    SAdaptivePerformanceMetrics m_performance;
    
    // Market analysis components
    CTechnicalIndicators* m_indicators;
    CMLPredictor* m_mlPredictor;
    CSentimentAnalyzer* m_sentimentAnalyzer;
    
    // Dynamic parameters
    double m_dynamicRiskLevel;
    double m_adaptiveThresholds[20];
    double m_marketRegimeWeights[10];
    bool m_isAdaptationActive;
    
    // Learning and optimization
    double m_learningRate;
    double m_explorationFactor;
    int m_experienceBuffer[1000];
    double m_rewardHistory[1000];
    int m_bufferIndex;
    
    // Market timing
    datetime m_lastMarketAnalysis;
    datetime m_lastDecisionUpdate;
    datetime m_lastPerformanceReview;
    
public:
    //--- Constructor/Destructor
    CAdaptiveDecisionEngine();
    ~CAdaptiveDecisionEngine();
    
    //--- Initialization
    bool Initialize(CTechnicalIndicators* indicators, CMLPredictor* ml, CSentimentAnalyzer* sentiment);
    void SetAdaptiveConfig(const SAdaptiveConfig &config);
    bool StartAdaptiveMode();
    void StopAdaptiveMode();
    
    //--- Market State Analysis
    ENUM_MARKET_STATE AnalyzeMarketState(string symbol);
    SMarketProfile GetMarketProfile(string symbol);
    bool UpdateMarketProfile(string symbol);
    double CalculateMarketStateConfidence(ENUM_MARKET_STATE state, string symbol);
    
    //--- Dynamic Decision Making
    SDecisionMetrics MakeAdaptiveDecision(string symbol, ENUM_ORDER_TYPE suggestedDirection = -1);
    ENUM_DECISION_MODE SelectOptimalMode(string symbol);
    bool ShouldTakeSignal(const STechnicalSignal &signal, string symbol);
    double CalculateOptimalPositionSize(string symbol, double riskLevel);
    
    //--- Adaptive Algorithms
    void AdaptToMarketConditions(string symbol);
    void OptimizeDecisionParameters(string symbol);
    void UpdateStrategyWeights();
    bool ShouldSwitchStrategy(string symbol);
    
    //--- Real-time Optimization
    void UpdateRealTimeMetrics(string symbol);
    void AdjustRiskParameters(double currentDrawdown);
    void OptimizeEntryTiming(string symbol);
    void DynamicStopLossAdjustment(string symbol, int ticket);
    
    //--- Machine Learning Integration
    bool EnableMLDrivenDecisions();
    void TrainAdaptiveModel(string symbol);
    double GetMLConfidence(string symbol, ENUM_ORDER_TYPE direction);
    void UpdateMLFeedback(int ticket, double actualReturn);
    
    //--- Performance-Based Adaptation
    void AnalyzePerformanceByMode();
    void AnalyzePerformanceByMarketState();
    ENUM_DECISION_MODE GetBestPerformingMode();
    void AdaptBasedOnPerformance();
    
    //--- Dynamic Filters
    bool PassesDynamicVolatilityFilter(string symbol);
    bool PassesDynamicSpreadFilter(string symbol);
    bool PassesDynamicLiquidityFilter(string symbol);
    bool PassesDynamicCorrelationFilter(string symbol);
    bool PassesDynamicSentimentFilter(string symbol);
    
    //--- Market Regime Detection
    bool DetectRegimeChange(string symbol);
    void AdaptToNewRegime(ENUM_MARKET_STATE newRegime);
    double CalculateRegimeStability(string symbol);
    bool IsRegimeTransition();
    
    //--- Advanced Decision Logic
    double CalculateMultiFactorScore(string symbol, ENUM_ORDER_TYPE direction);
    double GetDynamicConfidenceThreshold(ENUM_MARKET_STATE state);
    bool ValidateSignalWithMultipleSources(const STechnicalSignal &signal, string symbol);
    double CalculateExpectedValue(string symbol, ENUM_ORDER_TYPE direction);
    
    //--- Risk-Adjusted Decision Making
    double CalculateRiskAdjustedScore(string symbol, const SDecisionMetrics &metrics);
    double GetDynamicRiskLimit(ENUM_MARKET_STATE state);
    bool IsWithinDynamicRiskLimits(string symbol, double positionSize);
    void AdjustRiskBasedOnPerformance();
    
    //--- Time-Based Adaptations
    void AdaptToTradingSession(string symbol);
    void AdjustForNewsEvents(string symbol);
    void OptimizeForTimeOfDay(string symbol);
    bool IsOptimalTradingTime(string symbol);
    
    //--- Portfolio-Level Decisions
    bool ShouldAddToPortfolio(string symbol, ENUM_ORDER_TYPE direction);
    void BalancePortfolioRisk();
    double CalculatePortfolioImpact(string symbol, double positionSize);
    bool CheckCorrelationLimits(string symbol);
    
    //--- Execution Optimization
    double GetOptimalEntryPrice(string symbol, ENUM_ORDER_TYPE direction);
    double GetDynamicSlippage(string symbol);
    bool ShouldDelayExecution(string symbol);
    ENUM_ORDER_TYPE_FILLING GetOptimalFillType(string symbol);
    
    //--- Learning and Improvement
    void LearnFromTrade(int ticket, double return_rate, double maxDD);
    void UpdateDecisionModel();
    void OptimizeHyperparameters();
    bool ValidateModelPerformance();
    
    //--- Signal Enhancement
    double EnhanceSignalWithML(const STechnicalSignal &signal, string symbol);
    double EnhanceSignalWithSentiment(const STechnicalSignal &signal, string symbol);
    double EnhanceSignalWithVolatility(const STechnicalSignal &signal, string symbol);
    STechnicalSignal CreateCompositeSignal(string symbol);
    
    //--- Market Microstructure Analysis
    bool AnalyzeOrderFlow(string symbol);
    double DetectInstitutionalActivity(string symbol);
    bool IsLiquidityAdequate(string symbol, double orderSize);
    double GetMarketImpactEstimate(string symbol, double orderSize);
    
    //--- Stress Testing
    void RunStressTest(string symbol);
    double CalculateWorstCaseScenario(string symbol);
    bool PassesStressTest(const SDecisionMetrics &metrics);
    void AdjustForStressTestResults();
    
    //--- Configuration and Monitoring
    void SetLearningRate(double rate) { m_learningRate = rate; }
    void SetExplorationFactor(double factor) { m_explorationFactor = factor; }
    void EnableRealTimeLearning(bool enable);
    
    //--- Information and Diagnostics
    SMarketProfile GetCurrentMarketProfile() { return m_marketProfile; }
    SDecisionMetrics GetLastDecisionMetrics() { return m_lastDecision; }
    SAdaptivePerformanceMetrics GetPerformanceMetrics() { return m_performance; }
    ENUM_DECISION_MODE GetCurrentMode() { return m_config.primaryMode; }
    double GetAdaptationConfidence() { return m_config.modeConfidence; }
    
    //--- Utility functions
    void PrintDecisionSummary(string symbol);
    void PrintPerformanceReport();
    void ExportDecisionLog(string fileName);
    void ImportTrainingData(string fileName);
    
private:
    //--- Internal helper methods
    void InitializeAdaptiveParameters();
    void InitializePerformanceMetrics();
    void InitializeLearningSystem();
    
    //--- Market state analysis helpers
    double AnalyzeTrendComponent(string symbol);
    double AnalyzeVolatilityComponent(string symbol);
    double AnalyzeLiquidityComponent(string symbol);
    double AnalyzeSentimentComponent(string symbol);
    double AnalyzeSeasonalComponent(string symbol);
    
    //--- Decision calculation helpers
    double CalculateSignalConfirmationScore(string symbol);
    double CalculateRiskRewardRatio(string symbol, ENUM_ORDER_TYPE direction);
    double CalculateMarketTimingScore(string symbol);
    double CalculatePortfolioFitScore(string symbol);
    
    //--- Learning system helpers
    void UpdateExperienceBuffer(double reward);
    double CalculateMovingAverage(double &array[], int period);
    void NormalizePerformanceMetrics();
    void UpdateLearningParameters();
    
    //--- Optimization helpers
    void OptimizeIndicatorWeights(string symbol);
    void OptimizeTimeframes(string symbol);
    void OptimizeRiskParameters(string symbol);
    void OptimizeExitStrategy(string symbol);
    
    //--- Validation helpers
    bool ValidateMarketData(string symbol);
    bool ValidateDecisionInputs(string symbol);
    bool ValidateRiskParameters();
    void HandleMissingData(string symbol);
};

//--- Global adaptive decision engine instance
extern CAdaptiveDecisionEngine* g_adaptiveEngine;