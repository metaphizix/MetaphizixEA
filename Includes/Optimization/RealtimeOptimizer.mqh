//+------------------------------------------------------------------+
//|                                           RealtimeOptimizer.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "../Core/Config.mqh"
#include "AdaptiveDecisionEngine.mqh"
#include "DynamicStrategyManager.mqh"

//+------------------------------------------------------------------+
//| Real-time Optimization System                                  |
//| Continuously optimizes EA performance in real-time             |
//+------------------------------------------------------------------+

//--- Optimization types
enum ENUM_OPTIMIZATION_TYPE
{
    OPTIMIZATION_PARAMETERS,         // Parameter optimization
    OPTIMIZATION_STRATEGY,           // Strategy selection optimization
    OPTIMIZATION_RISK,               // Risk management optimization
    OPTIMIZATION_TIMING,             // Entry/exit timing optimization
    OPTIMIZATION_PORTFOLIO,          // Portfolio-level optimization
    OPTIMIZATION_ML_MODELS,          // Machine learning model optimization
    OPTIMIZATION_FILTERS,            // Filter optimization
    OPTIMIZATION_ENSEMBLE,           // Ensemble weight optimization
    OPTIMIZATION_ADAPTIVE            // Full adaptive optimization
};

//--- Optimization frequency
enum ENUM_OPTIMIZATION_FREQUENCY
{
    FREQ_CONTINUOUS,                 // Every tick
    FREQ_HIGH,                       // Every minute
    FREQ_MEDIUM,                     // Every 5 minutes
    FREQ_LOW,                        // Every 15 minutes
    FREQ_PERIODIC,                   // Every hour
    FREQ_DAILY,                      // Once per day
    FREQ_WEEKLY,                     // Once per week
    FREQ_ADAPTIVE                    // Based on market conditions
};

//--- Performance metrics
struct SPerformanceSnapshot
{
    datetime timestamp;
    double totalReturn;
    double sharpeRatio;
    double maxDrawdown;
    double winRate;
    double profitFactor;
    double averageTrade;
    int totalTrades;
    double volatility;
    double beta;
    double alpha;
    double calmarRatio;
    double sortinoRatio;
};

//--- Optimization results
struct SOptimizationResult
{
    ENUM_OPTIMIZATION_TYPE type;
    double improvementScore;
    double oldValue;
    double newValue;
    bool wasSuccessful;
    datetime optimizationTime;
    string description;
    double confidence;
};

//--- Real-time metrics
struct SRealtimeMetrics
{
    double currentPnL;
    double unrealizedPnL;
    double dailyPnL;
    double weeklyPnL;
    double monthlyPnL;
    double currentDrawdown;
    double maxDailyDrawdown;
    double riskUtilization;
    double exposureLevel;
    int activePositions;
    double avgPositionSize;
    datetime lastUpdate;
};

//+------------------------------------------------------------------+
//| Real-time Optimizer Class                                      |
//+------------------------------------------------------------------+
class CRealtimeOptimizer
{
private:
    // Core components
    CAdaptiveDecisionEngine* m_adaptiveEngine;
    CDynamicStrategyManager* m_strategyManager;
    
    // Performance tracking
    SPerformanceSnapshot m_performanceHistory[1000];
    int m_performanceIndex;
    SRealtimeMetrics m_realtimeMetrics;
    SOptimizationResult m_optimizationHistory[500];
    int m_optimizationIndex;
    
    // Optimization configuration
    ENUM_OPTIMIZATION_FREQUENCY m_optimizationFreq[9];
    bool m_optimizationEnabled[9];
    datetime m_lastOptimization[9];
    double m_optimizationThresholds[9];
    
    // Learning system
    double m_learningRate;
    double m_optimizationMemory[100];
    double m_parameterSensitivity[50];
    bool m_isLearningMode;
    
    // Real-time monitoring
    datetime m_lastMetricsUpdate;
    bool m_isMonitoring;
    double m_performanceBenchmark;
    double m_riskBenchmark;
    
    // Optimization algorithms
    double m_geneticAlgorithmParams[20];
    double m_particleSwarmParams[15];
    double m_bayesianParams[10];
    bool m_useAdvancedOptimization;
    
public:
    //--- Constructor/Destructor
    CRealtimeOptimizer();
    ~CRealtimeOptimizer();
    
    //--- Initialization
    bool Initialize(CAdaptiveDecisionEngine* adaptiveEngine, CDynamicStrategyManager* strategyManager);
    void SetOptimizationFrequency(ENUM_OPTIMIZATION_TYPE type, ENUM_OPTIMIZATION_FREQUENCY freq);
    void EnableOptimization(ENUM_OPTIMIZATION_TYPE type, bool enable);
    void StartRealTimeOptimization();
    void StopRealTimeOptimization();
    
    //--- Real-time Performance Monitoring
    void UpdateRealtimeMetrics();
    void MonitorPerformance();
    bool DetectPerformanceDegradation();
    void TriggerEmergencyOptimization();
    
    //--- Core Optimization Methods
    void ExecuteRealtimeOptimization();
    SOptimizationResult OptimizeParameters(string symbol);
    SOptimizationResult OptimizeStrategy(string symbol);
    SOptimizationResult OptimizeRiskManagement(string symbol);
    SOptimizationResult OptimizeTiming(string symbol);
    SOptimizationResult OptimizePortfolio();
    SOptimizationResult OptimizeMLModels(string symbol);
    SOptimizationResult OptimizeFilters(string symbol);
    SOptimizationResult OptimizeEnsemble(string symbol);
    
    //--- Parameter Optimization
    void OptimizeIndicatorParameters(string symbol);
    void OptimizeEntryParameters(string symbol);
    void OptimizeExitParameters(string symbol);
    void OptimizeRiskParameters(string symbol);
    void OptimizeTimeframeParameters(string symbol);
    
    //--- Advanced Optimization Algorithms
    double GeneticAlgorithmOptimization(double &parameters[], int paramCount, string symbol);
    double ParticleSwarmOptimization(double &parameters[], int paramCount, string symbol);
    double BayesianOptimization(double &parameters[], int paramCount, string symbol);
    double GradientDescentOptimization(double &parameters[], int paramCount, string symbol);
    double SimulatedAnnealingOptimization(double &parameters[], int paramCount, string symbol);
    
    //--- Machine Learning Optimization
    void OptimizeMLModelParameters();
    void TrainOptimizationModel();
    void UpdateNeuralNetworkWeights();
    void OptimizeFeatureSelection();
    void TuneHyperparameters();
    
    //--- Dynamic Risk Optimization
    void OptimizePositionSizing(string symbol);
    void OptimizeStopLossLevels(string symbol);
    void OptimizeTakeProfitLevels(string symbol);
    void OptimizeCorrelationLimits();
    void OptimizeDrawdownLimits();
    
    //--- Entry/Exit Timing Optimization
    void OptimizeEntryTiming(string symbol);
    void OptimizeExitTiming(string symbol);
    void OptimizeSignalFilters(string symbol);
    void OptimizeConfirmationLogic(string symbol);
    
    //--- Portfolio-Level Optimization
    void OptimizeAssetAllocation();
    void OptimizePairSelection();
    void OptimizeCorrelationMatrix();
    void OptimizeRiskDistribution();
    void OptimizeCapitalUtilization();
    
    //--- Performance-Based Optimization
    void OptimizeBasedOnSharpeRatio();
    void OptimizeBasedOnDrawdown();
    void OptimizeBasedOnWinRate();
    void OptimizeBasedOnProfitFactor();
    void OptimizeBasedOnCalmarRatio();
    
    //--- Adaptive Learning System
    void LearnFromOptimizationResults();
    void UpdateOptimizationStrategy();
    void AdaptOptimizationFrequency();
    void SelfOptimizeOptimizer();
    
    //--- Market Condition Adaptive Optimization
    void OptimizeForTrendingMarkets(string symbol);
    void OptimizeForRangingMarkets(string symbol);
    void OptimizeForHighVolatility(string symbol);
    void OptimizeForLowVolatility(string symbol);
    void OptimizeForNewsEvents(string symbol);
    
    //--- Multi-Objective Optimization
    double MultiObjectiveOptimization(string symbol, double &weights[]);
    void OptimizeReturnVsRisk(string symbol);
    void OptimizeStabilityVsGrowth(string symbol);
    void OptimizeAccuracyVsFrequency(string symbol);
    
    //--- Stress Testing and Robustness
    void StressTestOptimization(string symbol);
    void ValidateOptimizationRobustness();
    void TestWorstCaseScenarios();
    void CheckOptimizationStability();
    
    //--- Real-time Alerts and Notifications
    void MonitorOptimizationHealth();
    void CheckOptimizationConflicts();
    void AlertOnOptimizationFailure();
    void NotifyOptimizationSuccess();
    
    //--- Performance Analysis
    void AnalyzeOptimizationEffectiveness();
    void CompareOptimizationMethods();
    void MeasureOptimizationImpact();
    void TrackOptimizationTrends();
    
    //--- Configuration and Control
    void SetLearningRate(double rate) { m_learningRate = rate; }
    void SetPerformanceBenchmark(double benchmark) { m_performanceBenchmark = benchmark; }
    void SetRiskBenchmark(double benchmark) { m_riskBenchmark = benchmark; }
    void EnableAdvancedOptimization(bool enable) { m_useAdvancedOptimization = enable; }
    void EnableLearningMode(bool enable) { m_isLearningMode = enable; }
    
    //--- Information Functions
    SRealtimeMetrics GetRealtimeMetrics() { return m_realtimeMetrics; }
    SPerformanceSnapshot GetLatestPerformance();
    SOptimizationResult GetLatestOptimizationResult();
    double GetOptimizationEffectiveness();
    bool IsOptimizationActive() { return m_isMonitoring; }
    
    //--- Utility Functions
    void PrintOptimizationStatus();
    void PrintPerformanceReport();
    void ExportOptimizationData(string fileName);
    void ImportOptimizationHistory(string fileName);
    
private:
    //--- Helper Methods
    void InitializeOptimizationSystem();
    void InitializePerformanceTracking();
    void InitializeLearningSystem();
    
    //--- Performance calculation helpers
    double CalculateObjectiveFunction(double &parameters[], int count, string symbol);
    double EvaluatePerformanceMetric(ENUM_OPTIMIZATION_TYPE type);
    void UpdatePerformanceHistory();
    double CalculatePerformanceImprovement(double oldValue, double newValue);
    
    //--- Optimization algorithm helpers
    void InitializeGeneticAlgorithm();
    void InitializeParticleSwarm();
    void InitializeBayesianOptimization();
    double GenerateRandomParameter(double min, double max);
    void MutateParameters(double &parameters[], int count, double mutationRate);
    
    //--- Learning system helpers
    void UpdateParameterSensitivity(int paramIndex, double impact);
    void UpdateOptimizationMemory(double result);
    void ApplyLearning();
    void ForgetOldLearning();
    
    //--- Validation helpers
    bool ValidateOptimizationParameters(double &parameters[], int count);
    bool ValidateOptimizationResult(const SOptimizationResult &result);
    void HandleOptimizationFailure(ENUM_OPTIMIZATION_TYPE type);
    
    //--- Time management helpers
    bool ShouldOptimize(ENUM_OPTIMIZATION_TYPE type);
    void UpdateOptimizationSchedule(ENUM_OPTIMIZATION_TYPE type);
    bool IsOptimizationTime(ENUM_OPTIMIZATION_TYPE type);
    
    //--- Resource management
    void ManageOptimizationResources();
    void PrioritizeOptimizations();
    void BalanceOptimizationLoad();
};

//--- Optimization utility functions
class COptimizationUtils
{
public:
    static double NormalizeParameter(double value, double min, double max);
    static double DenormalizeParameter(double normalizedValue, double min, double max);
    static void Crossover(double &parent1[], double &parent2[], double &child[], int count);
    static void Mutate(double &parameters[], int count, double mutationRate);
    static double CalculateFitness(double &parameters[], int count, string symbol);
    static void SortByFitness(double &population[], double &fitness[], int populationSize, int paramCount);
};

//--- Global realtime optimizer instance
extern CRealtimeOptimizer* g_realtimeOptimizer;