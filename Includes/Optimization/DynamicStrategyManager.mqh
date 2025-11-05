//+------------------------------------------------------------------+
//|                                      DynamicStrategyManager.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "../Core/Config.mqh"
#include "AdaptiveDecisionEngine.mqh"

//+------------------------------------------------------------------+
//| Dynamic Strategy Management System                              |
//| Automatically selects and optimizes trading strategies         |
//+------------------------------------------------------------------+

//--- Strategy types
enum ENUM_STRATEGY_TYPE
{
    STRATEGY_TREND_FOLLOWING,        // Follow established trends
    STRATEGY_MEAN_REVERSION,         // Counter-trend trading
    STRATEGY_BREAKOUT,               // Breakout trading
    STRATEGY_SCALPING,               // High-frequency trading
    STRATEGY_SWING,                  // Medium-term swing trading
    STRATEGY_NEWS_TRADING,           // News-based trading
    STRATEGY_CORRELATION,            // Cross-pair correlation
    STRATEGY_CARRY_TRADE,            // Interest rate differential
    STRATEGY_MOMENTUM,               // Momentum-based trading
    STRATEGY_VOLATILITY,             // Volatility-based trading
    STRATEGY_HYBRID_ML,              // ML-enhanced hybrid
    STRATEGY_ADAPTIVE_ENSEMBLE       // Multi-strategy ensemble
};

//--- Strategy performance tracking
struct SStrategyPerformance
{
    ENUM_STRATEGY_TYPE strategyType;
    double totalReturn;
    double sharpeRatio;
    double maxDrawdown;
    double winRate;
    double avgTrade;
    double profitFactor;
    int totalTrades;
    datetime lastUsed;
    double recentPerformance[30];    // Last 30 days
    bool isActive;
    double allocationPercent;
};

//--- Strategy parameters
struct SStrategyParameters
{
    ENUM_STRATEGY_TYPE type;
    double riskLevel;
    double confidenceThreshold;
    int timeframe;
    double positionSizing;
    double stopLossMultiplier;
    double takeProfitMultiplier;
    bool enableFilters;
    double adaptationRate;
    string description;
};

//--- Market condition mapping
struct SMarketConditionMapping
{
    ENUM_MARKET_STATE marketState;
    ENUM_STRATEGY_TYPE preferredStrategy;
    ENUM_STRATEGY_TYPE alternativeStrategy;
    double confidence;
    double expectedPerformance;
};

//+------------------------------------------------------------------+
//| Dynamic Strategy Manager Class                                  |
//+------------------------------------------------------------------+
class CDynamicStrategyManager
{
private:
    // Strategy performance tracking
    SStrategyPerformance m_strategyPerformance[12];
    SStrategyParameters m_strategyParams[12];
    SMarketConditionMapping m_conditionMapping[10];
    
    // Current strategy selection
    ENUM_STRATEGY_TYPE m_currentStrategy;
    ENUM_STRATEGY_TYPE m_backupStrategy;
    double m_strategyConfidence;
    datetime m_lastStrategyChange;
    
    // Performance monitoring
    double m_strategyWeights[12];
    double m_adaptiveWeights[12];
    bool m_isEnsembleMode;
    double m_ensembleThreshold;
    
    // Dynamic optimization
    double m_optimizationHistory[100];
    int m_optimizationIndex;
    bool m_isOptimizing;
    datetime m_lastOptimization;
    
    // Dependencies
    CAdaptiveDecisionEngine* m_adaptiveEngine;
    
public:
    //--- Constructor/Destructor
    CDynamicStrategyManager();
    ~CDynamicStrategyManager();
    
    //--- Initialization
    bool Initialize(CAdaptiveDecisionEngine* adaptiveEngine);
    void InitializeStrategyParameters();
    void InitializePerformanceTracking();
    void LoadStrategyHistory();
    
    //--- Strategy Selection
    ENUM_STRATEGY_TYPE SelectOptimalStrategy(string symbol, ENUM_MARKET_STATE marketState);
    bool ShouldSwitchStrategy(string symbol);
    void ExecuteStrategySwitch(ENUM_STRATEGY_TYPE newStrategy);
    double CalculateStrategySuitability(ENUM_STRATEGY_TYPE strategy, string symbol);
    
    //--- Dynamic Strategy Optimization
    void OptimizeCurrentStrategy(string symbol);
    void OptimizeStrategyParameters(ENUM_STRATEGY_TYPE strategy, string symbol);
    void AdaptStrategyToMarketConditions(string symbol);
    bool TestStrategyPerformance(ENUM_STRATEGY_TYPE strategy, string symbol);
    
    //--- Ensemble Strategy Management
    void EnableEnsembleMode(bool enable);
    STechnicalSignal GenerateEnsembleSignal(string symbol);
    void OptimizeEnsembleWeights();
    double CalculateEnsembleConfidence(string symbol);
    
    //--- Performance-Based Adaptation
    void UpdateStrategyPerformance(ENUM_STRATEGY_TYPE strategy, double return_rate, double drawdown);
    void AnalyzeStrategyEffectiveness();
    void RankStrategiesByPerformance();
    void AdjustStrategyAllocation();
    
    //--- Market-Specific Strategy Selection
    ENUM_STRATEGY_TYPE GetStrategyForTrendingMarket(double trendStrength);
    ENUM_STRATEGY_TYPE GetStrategyForRangingMarket(double volatility);
    ENUM_STRATEGY_TYPE GetStrategyForHighVolatility();
    ENUM_STRATEGY_TYPE GetStrategyForLowVolatility();
    ENUM_STRATEGY_TYPE GetStrategyForBreakout();
    ENUM_STRATEGY_TYPE GetStrategyForReversal();
    
    //--- Individual Strategy Implementations
    STechnicalSignal ExecuteTrendFollowingStrategy(string symbol);
    STechnicalSignal ExecuteMeanReversionStrategy(string symbol);
    STechnicalSignal ExecuteBreakoutStrategy(string symbol);
    STechnicalSignal ExecuteScalpingStrategy(string symbol);
    STechnicalSignal ExecuteSwingStrategy(string symbol);
    STechnicalSignal ExecuteNewsStrategy(string symbol);
    STechnicalSignal ExecuteCorrelationStrategy(string symbol);
    STechnicalSignal ExecuteCarryTradeStrategy(string symbol);
    STechnicalSignal ExecuteMomentumStrategy(string symbol);
    STechnicalSignal ExecuteVolatilityStrategy(string symbol);
    STechnicalSignal ExecuteMLHybridStrategy(string symbol);
    
    //--- Risk Management per Strategy
    double CalculateStrategySpecificRisk(ENUM_STRATEGY_TYPE strategy, string symbol);
    double GetOptimalPositionSize(ENUM_STRATEGY_TYPE strategy, string symbol);
    double GetStrategyStopLoss(ENUM_STRATEGY_TYPE strategy, string symbol, double entryPrice);
    double GetStrategyTakeProfit(ENUM_STRATEGY_TYPE strategy, string symbol, double entryPrice);
    
    //--- Real-time Strategy Monitoring
    void MonitorActiveStrategies();
    void CheckStrategyPerformance();
    void HandleStrategyFailure(ENUM_STRATEGY_TYPE strategy);
    void EmergencyStrategySwitch();
    
    //--- Machine Learning Integration
    void TrainStrategySelectionModel();
    double PredictStrategyPerformance(ENUM_STRATEGY_TYPE strategy, string symbol);
    void UpdateMLBasedWeights();
    bool ShouldUseMLStrategy(string symbol);
    
    //--- Advanced Strategy Features
    void ImplementAdaptiveFilters(ENUM_STRATEGY_TYPE strategy);
    void OptimizeEntryExitLogic(ENUM_STRATEGY_TYPE strategy);
    void ImplementDynamicStops(ENUM_STRATEGY_TYPE strategy);
    void OptimizeTimeframes(ENUM_STRATEGY_TYPE strategy);
    
    //--- Portfolio Strategy Coordination
    void CoordinateMultiplePairs();
    void BalanceStrategyExposure();
    void ManageCorrelationRisk();
    void OptimizePortfolioStrategy();
    
    //--- Performance Analytics
    void AnalyzeStrategyCorrelations();
    void CalculateStrategyBeta(ENUM_STRATEGY_TYPE strategy);
    void AnalyzeStrategyDrawdowns();
    void GenerateStrategyReport();
    
    //--- Strategy Backtesting
    double BacktestStrategy(ENUM_STRATEGY_TYPE strategy, string symbol, int testPeriod);
    void ValidateStrategyRobustness(ENUM_STRATEGY_TYPE strategy);
    void OptimizeHistoricalPerformance(ENUM_STRATEGY_TYPE strategy);
    
    //--- Information Functions
    ENUM_STRATEGY_TYPE GetCurrentStrategy() { return m_currentStrategy; }
    double GetStrategyConfidence() { return m_strategyConfidence; }
    SStrategyPerformance GetStrategyPerformance(ENUM_STRATEGY_TYPE strategy);
    string GetStrategyDescription(ENUM_STRATEGY_TYPE strategy);
    bool IsEnsembleMode() { return m_isEnsembleMode; }
    
    //--- Configuration
    void SetStrategyParameters(ENUM_STRATEGY_TYPE strategy, const SStrategyParameters &params);
    void SetEnsembleThreshold(double threshold) { m_ensembleThreshold = threshold; }
    void EnableStrategyOptimization(bool enable) { m_isOptimizing = enable; }
    
    //--- Utility Functions
    void PrintStrategyStatus();
    void PrintPerformanceReport();
    void ExportStrategyData(string fileName);
    void ImportStrategyConfiguration(string fileName);
    
private:
    //--- Helper methods
    void InitializeDefaultStrategies();
    void InitializeMarketMappings();
    void UpdateStrategyWeights();
    double CalculateWeightedScore(double &scores[], double &weights[], int count);
    
    //--- Strategy implementation helpers
    double CalculateTrendStrength(string symbol);
    double CalculateVolatilityRegime(string symbol);
    double CalculateLiquidityLevel(string symbol);
    bool IsNewsImpactPeriod();
    
    //--- Performance calculation helpers
    double CalculateSharpeRatio(double &returns[], int count);
    double CalculateMaxDrawdown(double &equity[], int count);
    double CalculateWinRate(ENUM_STRATEGY_TYPE strategy);
    double CalculateProfitFactor(ENUM_STRATEGY_TYPE strategy);
    
    //--- Optimization helpers
    void OptimizeParameterSet(SStrategyParameters &params, string symbol);
    double EvaluateParameterSet(const SStrategyParameters &params, string symbol);
    void UpdateOptimizationHistory(double performance);
    
    //--- Validation helpers
    bool ValidateStrategyParameters(const SStrategyParameters &params);
    bool ValidateMarketConditions(string symbol);
    void HandleInvalidStrategy(ENUM_STRATEGY_TYPE strategy);
};

//--- Specialized strategy classes
class CTrendFollowingStrategy
{
public:
    static STechnicalSignal GenerateSignal(string symbol);
    static double CalculateConfidence(string symbol);
    static SStrategyParameters GetOptimalParameters(string symbol);
};

class CMeanReversionStrategy
{
public:
    static STechnicalSignal GenerateSignal(string symbol);
    static double CalculateOverboughtOversold(string symbol);
    static bool IsReversionOpportunity(string symbol);
};

class CBreakoutStrategy
{
public:
    static STechnicalSignal GenerateSignal(string symbol);
    static double DetectBreakoutPotential(string symbol);
    static bool ValidateBreakout(string symbol, double level);
};

class CScalpingStrategy
{
public:
    static STechnicalSignal GenerateSignal(string symbol);
    static bool IsScalpingCondition(string symbol);
    static double GetOptimalScalpingSize(string symbol);
};

class CNewsStrategy
{
public:
    static STechnicalSignal GenerateSignal(string symbol);
    static double AnalyzeNewsImpact(string symbol);
    static bool IsNewsTradeOpportunity();
};

//--- Global strategy manager instance
extern CDynamicStrategyManager* g_strategyManager;