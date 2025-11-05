//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#ifndef SIGNALMANAGER_MQH
#define SIGNALMANAGER_MQH

#include "Config.mqh"  // Must come first for ENUM_SIGNAL_TYPE and other enums
#include "../Advanced/ForexAnalyzer.mqh"
#include "OrderBlockDetector.mqh"
#include "../Advanced/MLPredictor.mqh"
#include "../Advanced/VolatilityAnalyzer.mqh"
#include "../Advanced/CorrelationAnalyzer.mqh"
#include "../Optimization/AdaptiveDecisionEngine.mqh"
#include "../Optimization/DynamicStrategyManager.mqh"
#include "../Optimization/RealtimeOptimizer.mqh"

//+------------------------------------------------------------------+
//| Enhanced Signal types and enumerations                          |
//+------------------------------------------------------------------+
// ENUM_SIGNAL_TYPE is defined in Config.mqh to avoid conflicts

enum ENUM_SIGNAL_SOURCE
{
    SIGNAL_SOURCE_ORDERBLOCK,    // Order block detection
    SIGNAL_SOURCE_TECHNICAL,     // Technical analysis
    SIGNAL_SOURCE_ML,            // Machine learning
    SIGNAL_SOURCE_FUNDAMENTAL,   // Fundamental analysis
    SIGNAL_SOURCE_SENTIMENT,     // Market sentiment
    SIGNAL_SOURCE_NEWS,          // News analysis
    SIGNAL_SOURCE_CORRELATION,   // Cross-asset correlation
    SIGNAL_SOURCE_VOLATILITY,    // Volatility analysis
    SIGNAL_SOURCE_ENSEMBLE       // Combined signals
};

enum ENUM_SIGNAL_QUALITY
{
    SIGNAL_QUALITY_POOR,         // Poor quality signal
    SIGNAL_QUALITY_FAIR,         // Fair quality signal
    SIGNAL_QUALITY_GOOD,         // Good quality signal
    SIGNAL_QUALITY_EXCELLENT     // Excellent quality signal
};

enum ENUM_SIGNAL_URGENCY
{
    SIGNAL_URGENCY_LOW,          // Low urgency
    SIGNAL_URGENCY_NORMAL,       // Normal urgency
    SIGNAL_URGENCY_HIGH,         // High urgency
    SIGNAL_URGENCY_CRITICAL      // Critical urgency
};

//+------------------------------------------------------------------+
//| Enhanced Signal structures                                       |
//+------------------------------------------------------------------+
struct SSignal
{
    string               symbol;
    ENUM_SIGNAL_TYPE     type;
    ENUM_SIGNAL_SOURCE   source;
    ENUM_SIGNAL_QUALITY  quality;
    ENUM_SIGNAL_URGENCY  urgency;
    double               entry_price;
    double               stop_loss;
    double               take_profit;
    double               confidence;
    double               strength;
    double               probability;
    datetime             time;
    datetime             expiry;
    string               reason;
    string               analysis;
    bool                 is_processed;
    bool                 is_valid;
    double               risk_reward_ratio;
    double               expected_profit;
    int                  timeframe_alignment;
    string               contributing_indicators[];
};

struct SSignalConfig
{
    double               minConfidence;
    double               minStrength;
    bool                 requireMultiTimeframeAlignment;
    bool                 enableMLValidation;
    bool                 enableCorrelationCheck;
    bool                 enableVolatilityFilter;
    bool                 enableNewsFilter;
    int                  maxSignalsPerSymbol;
    int                  signalExpiryMinutes;
    bool                 enableEnsembleSignals;
    double               ensembleWeights[];
};

struct SSignalStatistics
{
    int                  totalSignals;
    int                  processedSignals;
    int                  successfulSignals;
    double               averageConfidence;
    double               averageAccuracy;
    double               winRate;
    double               averageRiskReward;
    datetime             lastUpdate;
    double               qualityScore;
};

struct SMarketContext
{
    string               symbol;
    ENUM_MARKET_CONDITION marketCondition;
    double               volatility;
    double               trend;
    double               momentum;
    bool                 newsImpact;
    double               correlationRisk;
    double               liquidityLevel;
    bool                 optimalTiming;
};

//+------------------------------------------------------------------+
//| Advanced Signal Manager class                                   |
//| Processes multiple signal sources and generates high-quality signals |
//+------------------------------------------------------------------+
class CSignalManager
{
private:
    // Core signal data
    SSignal              m_signals[];
    SSignal              m_signalHistory[];
    SSignalConfig        m_config;
    SSignalStatistics    m_statistics;
    
    // Component references
    COrderBlockDetector* m_orderBlockDetector;
    CForexAnalyzer*      m_forexAnalyzer;
    CMLPredictor*        m_mlPredictor;
    CVolatilityAnalyzer* m_volatilityAnalyzer;
    CCorrelationAnalyzer* m_correlationAnalyzer;
    
    // Dynamic decision-making components
    CAdaptiveDecisionEngine* m_adaptiveEngine;
    CDynamicStrategyManager* m_strategyManager;
    CRealtimeOptimizer*  m_realtimeOptimizer;
    
    // Signal processing
    SMarketContext       m_marketContext[];
    datetime             m_lastSignalTime[];
    double               m_signalWeights[];
    
    // Dynamic signal processing
    bool                 m_isDynamicMode;
    double               m_dynamicThresholds[10];
    ENUM_DECISION_MODE   m_currentDecisionMode;
    double               m_adaptiveConfidence;
    
    // Performance tracking
    double               m_signalAccuracy[];
    string               m_trackedSymbols[];
    
public:
    //--- Constructor/Destructor
    CSignalManager();
    ~CSignalManager();
    
    //--- Initialization and configuration
    bool Initialize();
    bool Initialize(const SSignalConfig &config);
    void SetConfiguration(const SSignalConfig &config);
    void SetComponentReferences(COrderBlockDetector* orderBlock, CForexAnalyzer* forex, 
                               CMLPredictor* ml, CVolatilityAnalyzer* vol, CCorrelationAnalyzer* corr,
                               CAdaptiveDecisionEngine* adaptive, CDynamicStrategyManager* strategy,
                               CRealtimeOptimizer* optimizer);
    void SetOrderBlockDetector(COrderBlockDetector* detector);
    
    //--- Main signal processing
    bool ProcessSignal(string symbol);
    bool ProcessSignals(const string symbol);
    bool ProcessAllSymbols();
    bool GenerateEnsembleSignal(const string symbol);
    void UpdateMarketContext(const string symbol);
    
    //--- Signal generation from different sources
    bool GenerateOrderBlockSignals(const string symbol);
    bool GenerateTechnicalSignals(const string symbol);
    bool GenerateMLSignals(const string symbol);
    bool GenerateVolatilitySignals(const string symbol);
    bool GenerateCorrelationSignals(const string symbol);
    
    //--- Dynamic signal generation
    bool GenerateAdaptiveSignals(const string symbol);
    bool GenerateStrategyBasedSignals(const string symbol);
    bool GenerateOptimizedSignals(const string symbol);
    SSignal GenerateDynamicEnsembleSignal(const string symbol);
    bool ProcessSignalWithDynamicEngine(const string symbol);
    
    //--- Adaptive decision making
    bool ShouldTradeBasedOnAdaptiveLogic(const string symbol, const SSignal &signal);
    ENUM_ORDER_TYPE GetAdaptiveSignalDirection(const string symbol);
    double CalculateAdaptiveConfidence(const string symbol, const SSignal &signal);
    bool ValidateSignalWithDynamicFilters(const SSignal &signal, const string symbol);
    
    //--- Signal validation and filtering
    bool ValidateSignal(const SSignal &signal);
    bool PassesQualityFilter(const SSignal &signal);
    bool PassesCorrelationFilter(const SSignal &signal);
    bool PassesVolatilityFilter(const SSignal &signal);
    bool PassesNewsFilter(const SSignal &signal);
    bool PassesMultiTimeframeCheck(const SSignal &signal);
    
    //--- Signal combination and weighting
    SSignal CombineSignals(SSignal &signals[]);
    double CalculateEnsembleConfidence(SSignal &signals[]);
    void OptimizeSignalWeights();
    double CalculateSignalWeight(ENUM_SIGNAL_SOURCE source, const string symbol);
    
    //--- Signal retrieval and management
    bool GetLatestSignal(const string symbol, SSignal &signal);
    bool GetSignals(const string symbol, SSignal &signals[]);
    bool GetHighQualitySignals(const string symbol, SSignal &signals[]);
    bool HasNewSignal(const string symbol);
    bool HasCriticalSignal(const string symbol);
    
    //--- Signal analysis and metrics
    double CalculateSignalQuality(const SSignal &signal);
    double CalculateSignalStrength(const SSignal &signal);
    ENUM_SIGNAL_URGENCY DetermineSignalUrgency(const SSignal &signal);
    double EstimateSignalAccuracy(const SSignal &signal);
    
    //--- Performance tracking and optimization
    void UpdateSignalOutcome(const SSignal &signal, bool success, double actualPnL);
    SSignalStatistics GetSignalStatistics(const string symbol = "");
    double GetSignalAccuracy(ENUM_SIGNAL_SOURCE source, const string symbol = "");
    void OptimizeSignalGeneration();
    
    //--- Signal lifecycle management
    void ClearSignals(const string symbol = "");
    void ExpireOldSignals();
    void ArchiveProcessedSignals();
    int GetSignalCount(const string symbol = "");
    int GetActiveSignalCount(const string symbol = "");
    
    //--- Market context analysis
    void AnalyzeMarketConditions(const string symbol);
    bool IsOptimalSignalTiming(const string symbol);
    double GetMarketNoise(const string symbol);
    bool IsMarketTrendAligned(const SSignal &signal);
    
    //--- Signal conflict resolution
    bool HasConflictingSignals(const string symbol);
    SSignal ResolveSignalConflicts(const string symbol);
    void PrioritizeSignals(SSignal &signals[]);
    
    //--- Advanced signal features
    bool GenerateRegimeAwareSignals(const string symbol);
    bool GenerateRiskAdjustedSignals(const string symbol);
    
    //--- Integration with other systems
    bool IntegrateWithRiskManagement(SSignal &signal, double maxRisk);
    bool IntegrateWithPortfolioManager(SSignal &signal);
    bool IntegrateWithExitStrategy(SSignal &signal);
    
    //--- Debugging and diagnostics
    void LogSignalGeneration(const SSignal &signal);
    void LogSignalValidation(const SSignal &signal, bool passed);
    void LogSignalPerformance();
    string ExplainSignal(const SSignal &signal);
    
private:
    //--- Internal signal generation helpers
    bool GenerateEntrySignal(const string symbol, const SOrderBlock &orderBlock);
    bool GenerateExitSignal(const string symbol, const SOrderBlock &orderBlock);
    SSignal CreateSignalFromOrderBlock(const string symbol, const SOrderBlock &orderBlock);
    SSignal CreateSignalFromTechnical(const string symbol, const STechnicalSignal &techSignal);
    SSignal CreateSignalFromML(const string symbol, const SMLPrediction &mlPrediction);
    
    //--- Signal calculation helpers
    double CalculateStopLoss(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType);
    double CalculateTakeProfit(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType);
    double CalculateSignalConfidence(string symbol, const SOrderBlock &orderBlock);
    double CalculateRiskRewardRatio(const SSignal &signal);
    
    //--- Validation helpers
    bool IsSignalRelevant(string symbol, const SOrderBlock &orderBlock);
    bool CheckEntryConditions(string symbol, const SOrderBlock &orderBlock);
    bool CheckExitConditions(string symbol, const SOrderBlock &orderBlock);
    bool IsNearOrderBlock(string symbol, const SOrderBlock &orderBlock, double tolerance = 0.5);
    bool IsNearSignificantLevel(const string symbol, double price);
    
    //--- Market analysis helpers
    double GetCurrentPrice(const string symbol, ENUM_SIGNAL_TYPE signalType);
    double GetATR(const string symbol, ENUM_TIMEFRAMES timeframe, int period = 14);
    bool IsHighImpactTime(const string symbol);
    double GetMarketLiquidity(const string symbol);
    
    //--- Array management
    void AddSignal(const SSignal &signal);
    void RemoveOldSignals(const string symbol);
    void RemoveProcessedSignals(const string symbol);
    int FindLatestSignalIndex(const string symbol);
    int FindSignalIndex(const SSignal &signal);
    
    //--- Statistics and performance
    void UpdateSignalStatistics(const SSignal &signal);
    void UpdateAccuracyMetrics(ENUM_SIGNAL_SOURCE source, bool success);
    void CalculateOverallQualityScore();
    
    //--- Configuration helpers
    void InitializeDefaultConfig();
    void ValidateConfiguration();
    void ApplyConfigurationChanges();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalManager::CSignalManager()
{
    ArrayResize(m_signals, 0);
    m_orderBlockDetector = NULL;
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalManager::~CSignalManager()
{
    ArrayFree(m_signals);
}

//+------------------------------------------------------------------+
//| Initialize signal manager                                        |
//+------------------------------------------------------------------+
bool CSignalManager::Initialize()
{
    CConfig::LogInfo("Initializing Signal Manager");
    
    //--- Clear existing signals
    ClearSignals();
    
    CConfig::LogInfo("Signal Manager initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Set order block detector reference                               |
//+------------------------------------------------------------------+
void CSignalManager::SetOrderBlockDetector(COrderBlockDetector* detector)
{
    m_orderBlockDetector = detector;
}

//+------------------------------------------------------------------+
//| Process signals for symbol                                       |
//+------------------------------------------------------------------+
bool CSignalManager::ProcessSignal(string symbol)
{
    if(m_orderBlockDetector == NULL)
    {
        CConfig::LogError("Order block detector not set");
        return false;
    }
    
    //--- Remove old signals first
    RemoveOldSignals(symbol);
    
    //--- Get order blocks for this symbol
    SOrderBlock orderBlocks[];
    if(!m_orderBlockDetector.GetOrderBlocks(symbol, orderBlocks))
        return true; // No order blocks, but not an error
    
    bool signalGenerated = false;
    
    //--- Process each order block
    for(int i = 0; i < ArraySize(orderBlocks); i++)
    {
        //--- Check if order block is relevant
        if(!IsSignalRelevant(symbol, orderBlocks[i]))
            continue;
        
        //--- Generate entry signals
        if(CheckEntryConditions(symbol, orderBlocks[i]))
        {
            if(GenerateEntrySignal(symbol, orderBlocks[i]))
                signalGenerated = true;
        }
        
        //--- Generate exit signals
        if(CheckExitConditions(symbol, orderBlocks[i]))
        {
            if(GenerateExitSignal(symbol, orderBlocks[i]))
                signalGenerated = true;
        }
    }
    
    if(signalGenerated)
        CConfig::LogDebug("Generated new signals for " + symbol);
    
    return true;
}

//+------------------------------------------------------------------+
//| Generate entry signal                                            |
//+------------------------------------------------------------------+
bool CSignalManager::GenerateEntrySignal(string symbol, const SOrderBlock &orderBlock)
{
    SSignal signal;
    signal.symbol = symbol;
    signal.time = TimeCurrent();
    signal.is_processed = false;
    
    //--- Determine signal type based on order block direction
    if(orderBlock.type == OB_TYPE_BULLISH)
    {
        signal.type = (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY;
        signal.entry_price = orderBlock.high;
        signal.reason = "Bullish order block entry at " + DoubleToString(orderBlock.high, _Digits);
    }
    else
    {
        signal.type = (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY;
        signal.entry_price = orderBlock.low;
        signal.reason = "Bearish order block entry at " + DoubleToString(orderBlock.low, _Digits);
    }
    
    //--- Calculate stop loss and take profit
    signal.stop_loss = CalculateStopLoss(symbol, orderBlock, signal.type);
    signal.take_profit = CalculateTakeProfit(symbol, orderBlock, signal.type);
    signal.confidence = CalculateSignalConfidence(symbol, orderBlock);
    
    //--- Validate signal
    if(!ValidateSignal(signal))
        return false;
    
    //--- Add signal
    AddSignal(signal);
    
    CConfig::LogInfo(StringFormat("Entry signal generated for %s: %s at %.5f", 
                     symbol, EnumToString(signal.type), signal.entry_price));
    
    return true;
}

//+------------------------------------------------------------------+
//| Generate exit signal                                             |
//+------------------------------------------------------------------+
bool CSignalManager::GenerateExitSignal(string symbol, const SOrderBlock &orderBlock)
{
    SSignal signal;
    signal.symbol = symbol;
    signal.time = TimeCurrent();
    signal.is_processed = false;
    
    //--- Determine exit based on current price position relative to order block
    double currentPrice = GetCurrentPrice(symbol, (ENUM_SIGNAL_TYPE)SIGNAL_BUY_EXIT);
    
    if(orderBlock.is_bullish && currentPrice < orderBlock.low)
    {
        signal.type = (ENUM_SIGNAL_TYPE)SIGNAL_BUY_EXIT;
        signal.entry_price = currentPrice;
        signal.reason = "Exit long position - price below bullish order block";
    }
    else if(!orderBlock.is_bullish && currentPrice > orderBlock.high)
    {
        signal.type = (ENUM_SIGNAL_TYPE)SIGNAL_SELL_EXIT;
        signal.entry_price = currentPrice;
        signal.reason = "Exit short position - price above bearish order block";
    }
    else
    {
        return false; // No exit condition met
    }
    
    signal.stop_loss = 0; // No stop loss for exit signals
    signal.take_profit = 0; // No take profit for exit signals
    signal.confidence = CalculateSignalConfidence(symbol, orderBlock);
    
    //--- Validate signal
    if(!ValidateSignal(signal))
        return false;
    
    //--- Add signal
    AddSignal(signal);
    
    CConfig::LogInfo(StringFormat("Exit signal generated for %s: %s at %.5f", 
                     symbol, EnumToString(signal.type), signal.entry_price));
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate stop loss                                              |
//+------------------------------------------------------------------+
double CSignalManager::CalculateStopLoss(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType)
{
    double atr = GetATR(symbol, orderBlock.timeframe);
    double stopDistance = atr * 1.5; // 1.5 x ATR
    
    if(signalType == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY)
    {
        return orderBlock.low - stopDistance;
    }
    else if(signalType == (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY)
    {
        return orderBlock.high + stopDistance;
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate take profit                                            |
//+------------------------------------------------------------------+
double CSignalManager::CalculateTakeProfit(string symbol, const SOrderBlock &orderBlock, ENUM_SIGNAL_TYPE signalType)
{
    double atr = GetATR(symbol, orderBlock.timeframe);
    double targetDistance = atr * 3.0; // 3 x ATR (2:1 risk-reward)
    
    if(signalType == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY)
    {
        return orderBlock.high + targetDistance;
    }
    else if(signalType == (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY)
    {
        return orderBlock.low - targetDistance;
    }
    
    return 0;
}

//+------------------------------------------------------------------+
//| Calculate signal confidence                                      |
//+------------------------------------------------------------------+
double CSignalManager::CalculateSignalConfidence(string symbol, const SOrderBlock &orderBlock)
{
    double confidence = 0.0;
    
    //--- Base confidence from order block strength
    confidence += orderBlock.strength * 0.4;
    
    //--- Confirmation bonus
    if(orderBlock.is_confirmed)
        confidence += 0.3;
    
    //--- Timeframe bonus (higher timeframes = higher confidence)
    switch(orderBlock.timeframe)
    {
        case PERIOD_D1: confidence += 0.2; break;
        case PERIOD_H4: confidence += 0.15; break;
        case PERIOD_H1: confidence += 0.1; break;
        case PERIOD_M15: confidence += 0.05; break;
    }
    
    //--- Freshness bonus (newer blocks = higher confidence)
    double hoursSince = (double)(TimeCurrent() - orderBlock.time) / 3600.0;
    if(hoursSince < 4)
        confidence += 0.1;
    else if(hoursSince < 24)
        confidence += 0.05;
    
    return MathMin(confidence, 1.0);
}

//+------------------------------------------------------------------+
//| Validate signal                                                  |
//+------------------------------------------------------------------+
bool CSignalManager::ValidateSignal(const SSignal &signal)
{
    //--- Check confidence threshold
    if(signal.confidence < 0.4)
        return false;
    
    //--- Check price validity
    if(signal.entry_price <= 0)
        return false;
    
    //--- Check stop loss validity (for entry signals)
    if((signal.type == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY || signal.type == (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY) && signal.stop_loss <= 0)
        return false;
    
    //--- Check risk-reward ratio
    if(signal.type == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY)
    {
        double risk = signal.entry_price - signal.stop_loss;
        double reward = signal.take_profit - signal.entry_price;
        if(reward / risk < 1.5) // Minimum 1.5:1 risk-reward
            return false;
    }
    else if(signal.type == (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY)
    {
        double risk = signal.stop_loss - signal.entry_price;
        double reward = signal.entry_price - signal.take_profit;
        if(reward / risk < 1.5) // Minimum 1.5:1 risk-reward
            return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if signal is relevant                                      |
//+------------------------------------------------------------------+
bool CSignalManager::IsSignalRelevant(string symbol, const SOrderBlock &orderBlock)
{
    //--- Check if order block is confirmed
    if(!orderBlock.is_confirmed)
        return false;
    
    //--- Check if order block is not too old
    double hoursSince = (double)(TimeCurrent() - orderBlock.time) / 3600.0;
    if(hoursSince > 168) // Older than 1 week
        return false;
    
    //--- Check if price is near the order block
    if(!IsNearOrderBlock(symbol, orderBlock, 2.0)) // Within 2 ATR
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check entry conditions                                           |
//+------------------------------------------------------------------+
bool CSignalManager::CheckEntryConditions(string symbol, const SOrderBlock &orderBlock)
{
    double currentPrice = GetCurrentPrice(symbol, (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY);
    
    if(orderBlock.is_bullish)
    {
        //--- For bullish order block, price should be near or touching the block
        return (currentPrice >= orderBlock.low && currentPrice <= orderBlock.high + GetATR(symbol, orderBlock.timeframe));
    }
    else
    {
        //--- For bearish order block, price should be near or touching the block
        return (currentPrice <= orderBlock.high && currentPrice >= orderBlock.low - GetATR(symbol, orderBlock.timeframe));
    }
}

//+------------------------------------------------------------------+
//| Check exit conditions                                            |
//+------------------------------------------------------------------+
bool CSignalManager::CheckExitConditions(string symbol, const SOrderBlock &orderBlock)
{
    double currentPrice = GetCurrentPrice(symbol, (ENUM_SIGNAL_TYPE)SIGNAL_BUY_EXIT);
    
    //--- Exit conditions based on order block violation
    if(orderBlock.is_bullish)
    {
        return currentPrice < orderBlock.low; // Price broke below bullish block
    }
    else
    {
        return currentPrice > orderBlock.high; // Price broke above bearish block
    }
}

//+------------------------------------------------------------------+
//| Get current price based on signal type                          |
//+------------------------------------------------------------------+
double CSignalManager::GetCurrentPrice(string symbol, ENUM_SIGNAL_TYPE signalType)
{
    if(signalType == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY || signalType == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_EXIT)
        return SymbolInfoDouble(symbol, SYMBOL_ASK);
    else
        return SymbolInfoDouble(symbol, SYMBOL_BID);
}

//+------------------------------------------------------------------+
//| Get Average True Range                                           |
//+------------------------------------------------------------------+
double CSignalManager::GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14)
{
    double atr = 0;
    
    for(int i = 1; i <= period; i++)
    {
        double high = iHigh(symbol, timeframe, i);
        double low = iLow(symbol, timeframe, i);
        double prevClose = iClose(symbol, timeframe, i + 1);
        
        double tr = MathMax(high - low, MathMax(MathAbs(high - prevClose), MathAbs(low - prevClose)));
        atr += tr;
    }
    
    return atr / period;
}

//+------------------------------------------------------------------+
//| Check if price is near order block                              |
//+------------------------------------------------------------------+
bool CSignalManager::IsNearOrderBlock(string symbol, const SOrderBlock &orderBlock, double tolerance = 0.5)
{
    double currentPrice = GetCurrentPrice(symbol, (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY);
    double atr = GetATR(symbol, orderBlock.timeframe);
    double distance = atr * tolerance;
    
    return (currentPrice >= orderBlock.low - distance && currentPrice <= orderBlock.high + distance);
}

//+------------------------------------------------------------------+
//| Add signal to array                                              |
//+------------------------------------------------------------------+
void CSignalManager::AddSignal(const SSignal &signal)
{
    ArrayResize(m_signals, ArraySize(m_signals) + 1);
    m_signals[ArraySize(m_signals) - 1] = signal;
}

//+------------------------------------------------------------------+
//| Remove old signals                                               |
//+------------------------------------------------------------------+
void CSignalManager::RemoveOldSignals(string symbol)
{
    datetime cutoffTime = TimeCurrent() - (24 * 3600); // 24 hours old
    
    for(int i = ArraySize(m_signals) - 1; i >= 0; i--)
    {
        if(m_signals[i].symbol == symbol && m_signals[i].time < cutoffTime)
        {
            ArrayRemove(m_signals, i, 1);
        }
    }
}

//+------------------------------------------------------------------+
//| Find latest signal index                                         |
//+------------------------------------------------------------------+
int CSignalManager::FindLatestSignalIndex(string symbol)
{
    datetime latestTime = 0;
    int latestIndex = -1;
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol && m_signals[i].time > latestTime)
        {
            latestTime = m_signals[i].time;
            latestIndex = i;
        }
    }
    
    return latestIndex;
}

//+------------------------------------------------------------------+
//| Get latest signal                                                |
//+------------------------------------------------------------------+
bool CSignalManager::GetLatestSignal(string symbol, SSignal &signal)
{
    int index = FindLatestSignalIndex(symbol);
    if(index >= 0)
    {
        signal = m_signals[index];
        return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Get all signals for symbol                                       |
//+------------------------------------------------------------------+
bool CSignalManager::GetSignals(string symbol, SSignal &signals[])
{
    ArrayResize(signals, 0);
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol)
        {
            ArrayResize(signals, ArraySize(signals) + 1);
            signals[ArraySize(signals) - 1] = m_signals[i];
        }
    }
    
    return ArraySize(signals) > 0;
}

//+------------------------------------------------------------------+
//| Check if there are new signals                                   |
//+------------------------------------------------------------------+
bool CSignalManager::HasNewSignal(string symbol)
{
    datetime currentTime = TimeCurrent();
    
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol && 
           currentTime - m_signals[i].time < 300 && // New within 5 minutes
           !m_signals[i].is_processed)
        {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Clear signals                                                    |
//+------------------------------------------------------------------+
void CSignalManager::ClearSignals(string symbol = "")
{
    if(symbol == "")
    {
        ArrayResize(m_signals, 0);
    }
    else
    {
        for(int i = ArraySize(m_signals) - 1; i >= 0; i--)
        {
            if(m_signals[i].symbol == symbol)
            {
                ArrayRemove(m_signals, i, 1);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Get signal count                                                 |
//+------------------------------------------------------------------+
int CSignalManager::GetSignalCount(string symbol = "")
{
    if(symbol == "")
        return ArraySize(m_signals);
    
    int count = 0;
    for(int i = 0; i < ArraySize(m_signals); i++)
    {
        if(m_signals[i].symbol == symbol)
            count++;
    }
    
    return count;
}

#endif // SIGNALMANAGER_MQH