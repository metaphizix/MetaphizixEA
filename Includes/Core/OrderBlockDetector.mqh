//+------------------------------------------------------------------+
//|                                            OrderBlockDetector.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Enhanced Order block enumerations                               |
//+------------------------------------------------------------------+
enum ENUM_ORDER_BLOCK_TYPE
{
    OB_TYPE_BULLISH,            // Bullish order block
    OB_TYPE_BEARISH,            // Bearish order block
    OB_TYPE_MITIGATION,         // Mitigation block
    OB_TYPE_BREAKER,            // Breaker block
    OB_TYPE_INSTITUTIONAL,      // Institutional order block
    OB_TYPE_INEFFICIENCY,       // Fair value gap/inefficiency
    OB_TYPE_LIQUIDITY_VOID      // Liquidity void
};

enum ENUM_ORDER_BLOCK_STRENGTH
{
    OB_STRENGTH_WEAK,           // Weak order block
    OB_STRENGTH_MODERATE,       // Moderate order block
    OB_STRENGTH_STRONG,         // Strong order block
    OB_STRENGTH_VERY_STRONG     // Very strong order block
};

enum ENUM_ORDER_BLOCK_STATUS
{
    OB_STATUS_FRESH,            // Fresh/untested order block
    OB_STATUS_TESTED,           // Tested but holding
    OB_STATUS_WEAKENED,         // Weakened by multiple tests
    OB_STATUS_BROKEN,           // Broken/invalidated
    OB_STATUS_RESPECTED,        // Recently respected
    OB_STATUS_EXPIRED           // Expired due to time
};

enum ENUM_PATTERN_TYPE
{
    PATTERN_ENGULFING,          // Engulfing pattern
    PATTERN_HAMMER,             // Hammer/doji
    PATTERN_SHOOTING_STAR,      // Shooting star
    PATTERN_INSIDE_BAR,         // Inside bar
    PATTERN_OUTSIDE_BAR,        // Outside bar
    PATTERN_PIN_BAR,            // Pin bar
    PATTERN_MARUBOZU,           // Marubozu
    PATTERN_DOJI,               // Doji
    PATTERN_NONE                // No specific pattern
};

//+------------------------------------------------------------------+
//| Enhanced Order block structures                                 |
//+------------------------------------------------------------------+
struct SOrderBlock
{
    string                  symbol;
    datetime                formation_time;
    datetime                last_update;
    double                  high;
    double                  low;
    double                  open;
    double                  close;
    double                  pivot_high;
    double                  pivot_low;
    ENUM_TIMEFRAMES         timeframe;
    ENUM_ORDER_BLOCK_TYPE   type;
    ENUM_ORDER_BLOCK_STRENGTH strength;
    ENUM_ORDER_BLOCK_STATUS status;
    ENUM_PATTERN_TYPE       pattern;
    bool                    is_confirmed;
    bool                    is_mitigated;
    double                  strength_score;
    int                     touch_count;
    int                     rejection_count;
    datetime                last_touch;
    datetime                last_rejection;
    double                  volume;
    double                  momentum;
    double                  confluence_score;
    int                     timeframe_alignment;
    string                  confluence_factors[];
    double                  probability;
    double                  expected_move;
};

struct SOrderBlockConfig
{
    int                     lookback_period;
    double                  min_block_size_pips;
    int                     confirmation_candles;
    bool                    multi_timeframe_analysis;
    ENUM_TIMEFRAMES         primary_timeframe;
    ENUM_TIMEFRAMES         secondary_timeframes[];
    bool                    enable_volume_analysis;
    bool                    enable_momentum_filter;
    bool                    enable_confluence_scoring;
    bool                    enable_pattern_recognition;
    double                  min_strength_score;
    double                  min_confluence_score;
    int                     max_blocks_per_symbol;
    bool                    filter_overlapping_blocks;
    bool                    enable_ai_enhancement;
};

struct SOrderBlockStatistics
{
    int                     total_blocks_detected;
    int                     successful_blocks;
    int                     broken_blocks;
    double                  success_rate;
    double                  average_strength;
    double                  average_hold_time;
    int                     bullish_blocks;
    int                     bearish_blocks;
    datetime                last_update;
    double                  detection_accuracy;
};

struct SMarketStructure
{
    string                  symbol;
    double                  higher_highs[];
    double                  higher_lows[];
    double                  lower_highs[];
    double                  lower_lows[];
    datetime                structure_times[];
    bool                    is_uptrend;
    bool                    is_downtrend;
    bool                    is_ranging;
    double                  trend_strength;
    datetime                last_structure_break;
};

//+------------------------------------------------------------------+
//| Advanced Order Block Detector class                             |
//| AI-enhanced order block detection and market structure analysis |
//+------------------------------------------------------------------+
class COrderBlockDetector
{
private:
    // Configuration and settings
    SOrderBlockConfig       m_config;
    SOrderBlockStatistics   m_statistics;
    
    // Order block data
    SOrderBlock             m_orderBlocks[];
    SOrderBlock             m_historicalBlocks[];
    
    // Market structure analysis
    SMarketStructure        m_marketStructure[];
    string                  m_trackedSymbols[];
    
    // Analysis state
    datetime                m_lastAnalysis[];
    datetime                m_lastUpdate[];
    
    // Pattern recognition
    ENUM_PATTERN_TYPE       m_detectedPatterns[][];
    double                  m_patternScores[][];
    
    // AI enhancement
    bool                    m_aiEnabled;
    double                  m_aiConfidenceScores[];
    
public:
    //--- Constructor/Destructor
    COrderBlockDetector();
    ~COrderBlockDetector();
    
    //--- Initialization and configuration
    bool Initialize();
    bool Initialize(const SOrderBlockConfig &config);
    void SetConfiguration(const SOrderBlockConfig &config);
    SOrderBlockConfig GetConfiguration() const { return m_config; }
    
    //--- Main analysis methods
    bool AnalyzePair(const string symbol);
    bool AnalyzeAllPairs();
    bool PerformMultiTimeframeAnalysis(const string symbol);
    void UpdateMarketStructure(const string symbol);
    
    //--- Order block detection
    bool DetectOrderBlocks(const string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectBullishOrderBlocks(const string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectBearishOrderBlocks(const string symbol, ENUM_TIMEFRAMES timeframe);
    bool DetectMitigationBlocks(const string symbol);
    bool DetectBreakerBlocks(const string symbol);
    bool DetectInstitutionalBlocks(const string symbol);
    
    //--- Pattern recognition and analysis
    ENUM_PATTERN_TYPE IdentifyCandlestickPattern(const string symbol, int index);
    bool DetectEngulfingPattern(const string symbol, int index);
    bool DetectPinBarPattern(const string symbol, int index);
    bool DetectInsideBarPattern(const string symbol, int index);
    bool DetectDoji(const string symbol, int index);
    
    //--- Order block validation and scoring
    bool ValidateOrderBlock(SOrderBlock &orderBlock);
    double CalculateOrderBlockStrength(const SOrderBlock &orderBlock);
    double CalculateConfluenceScore(const SOrderBlock &orderBlock);
    ENUM_ORDER_BLOCK_STRENGTH DetermineStrengthLevel(double strengthScore);
    bool IsOrderBlockValid(const SOrderBlock &orderBlock);
    
    //--- Market structure analysis
    bool IdentifyMarketStructure(const string symbol);
    bool DetectTrendDirection(const string symbol);
    bool DetectStructureBreak(const string symbol);
    bool FindSwingHighsAndLows(const string symbol);
    double CalculateTrendStrength(const string symbol);
    
    //--- Order block management
    bool HasNewOrderBlock(const string symbol);
    bool GetLatestOrderBlock(const string symbol, SOrderBlock &orderBlock);
    bool GetOrderBlocks(const string symbol, SOrderBlock &orderBlocks[]);
    bool GetValidOrderBlocks(const string symbol, SOrderBlock &orderBlocks[]);
    void UpdateOrderBlockStatus(const string symbol);
    
    //--- Order block interaction tracking
    bool CheckOrderBlockTouch(const string symbol, SOrderBlock &orderBlock);
    bool CheckOrderBlockBreak(const string symbol, SOrderBlock &orderBlock);
    bool CheckOrderBlockRejection(const string symbol, SOrderBlock &orderBlock);
    void RecordOrderBlockInteraction(SOrderBlock &orderBlock, bool respected);
    
    //--- Advanced analysis features
    bool PerformVolumeAnalysis(const string symbol, SOrderBlock &orderBlock);
    bool PerformMomentumAnalysis(const string symbol, SOrderBlock &orderBlock);
    bool AnalyzeTimeframeAlignment(const string symbol, SOrderBlock &orderBlock);
    double CalculateExpectedMove(const SOrderBlock &orderBlock);
    
    //--- AI-enhanced detection
    bool EnableAIEnhancement();
    bool DisableAIEnhancement();
    double GetAIConfidenceScore(const SOrderBlock &orderBlock);
    bool ValidateWithAI(const SOrderBlock &orderBlock);
    
    //--- Filtering and optimization
    void FilterOverlappingBlocks(const string symbol);
    void RemoveWeakBlocks(const string symbol);
    void RemoveExpiredBlocks(const string symbol);
    void OptimizeBlockDetection();
    
    //--- Statistical analysis and performance
    SOrderBlockStatistics GetStatistics() const { return m_statistics; }
    double GetDetectionAccuracy() const { return m_statistics.detection_accuracy; }
    double GetSuccessRate() const { return m_statistics.success_rate; }
    void UpdateStatistics();
    void ResetStatistics();
    
    //--- Integration and utilities
    bool IntegrateWithMLPredictor(CMLPredictor* mlPredictor);
    bool IntegrateWithVolatilityAnalyzer(CVolatilityAnalyzer* volAnalyzer);
    double GetOrderBlockProbability(const SOrderBlock &orderBlock);
    
    //--- Configuration getters/setters
    void SetLookbackPeriod(int period) { m_config.lookback_period = period; }
    void SetMinBlockSize(double pips) { m_config.min_block_size_pips = pips; }
    void SetConfirmationCandles(int candles) { m_config.confirmation_candles = candles; }
    void EnableMultiTimeframeAnalysis(bool enable) { m_config.multi_timeframe_analysis = enable; }
    void EnableVolumeAnalysis(bool enable) { m_config.enable_volume_analysis = enable; }
    
    //--- Getters
    int GetLookbackPeriod() const { return m_config.lookback_period; }
    double GetMinBlockSize() const { return m_config.min_block_size_pips; }
    int GetOrderBlockCount(const string symbol);
    int GetValidOrderBlockCount(const string symbol);
    
private:
    //--- Internal detection algorithms
    bool ScanForBullishBlocks(const string symbol, ENUM_TIMEFRAMES tf, int startBar, int endBar);
    bool ScanForBearishBlocks(const string symbol, ENUM_TIMEFRAMES tf, int startBar, int endBar);
    bool IdentifyKeyLevels(const string symbol, ENUM_TIMEFRAMES tf);
    bool FindImbalances(const string symbol, ENUM_TIMEFRAMES tf);
    
    //--- Validation helpers
    bool MeetsMinimumSize(const SOrderBlock &orderBlock);
    bool HasSufficientVolume(const SOrderBlock &orderBlock);
    bool PassesQualityFilter(const SOrderBlock &orderBlock);
    bool IsWithinTimeframe(const SOrderBlock &orderBlock);
    
    //--- Calculation helpers
    double CalculateBlockHeight(const SOrderBlock &orderBlock);
    double CalculateVolumeRatio(const string symbol, int index);
    double CalculateMomentumScore(const string symbol, int index);
    double CalculateRelativePosition(const SOrderBlock &orderBlock, double currentPrice);
    
    //--- Pattern analysis helpers
    bool IsBearishEngulfing(const string symbol, int index);
    bool IsBullishEngulfing(const string symbol, int index);
    bool IsHammer(const string symbol, int index);
    bool IsShootingStar(const string symbol, int index);
    double GetCandleBodyRatio(const string symbol, int index);
    
    //--- Market structure helpers
    void IdentifySwingPoints(const string symbol);
    bool IsSwingHigh(const string symbol, int index, int period = 5);
    bool IsSwingLow(const string symbol, int index, int period = 5);
    void UpdateTrendDirection(const string symbol);
    
    //--- Array management
    void AddOrderBlock(const SOrderBlock &orderBlock);
    void RemoveOrderBlock(int index);
    int FindOrderBlockIndex(const string symbol, datetime time);
    void CleanupOldBlocks();
    void SortBlocksByStrength(SOrderBlock &blocks[]);
    
    //--- Symbol management
    int FindSymbolIndex(const string symbol);
    void AddSymbolToTracking(const string symbol);
    void RemoveSymbolFromTracking(const string symbol);
    
    //--- Performance optimization
    void UpdateAnalysisCache(const string symbol);
    bool IsAnalysisRequired(const string symbol);
    void OptimizeDetectionParameters();
    
    //--- Logging and diagnostics
    void LogOrderBlockDetection(const SOrderBlock &orderBlock);
    void LogMarketStructureUpdate(const string symbol);
    void LogStatistics();
    void LogPerformanceMetrics();
};
    bool GetOrderBlocks(string symbol, SOrderBlock &blocks[]);
    bool GetLatestOrderBlock(string symbol, SOrderBlock &block);
    
    //--- Utility functions
    void ClearOrderBlocks(string symbol = "");
    int GetOrderBlockCount(string symbol = "");
    
private:
    //--- Order block detection methods
    bool DetectOrderBlocks(string symbol, ENUM_TIMEFRAMES timeframe);
    bool IsOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool ValidateOrderBlock(string symbol, const SOrderBlock &block);
    double CalculateOrderBlockStrength(string symbol, const SOrderBlock &block);
    bool IsOrderBlockConfirmed(string symbol, const SOrderBlock &block);
    
    //--- Helper functions
    bool IsBreakOfStructure(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool IsLiquidityZone(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    double GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14);
    bool IsBullishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    bool IsBearishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift);
    
    //--- Array management
    int FindOrderBlockIndex(string symbol, datetime time);
    void AddOrderBlock(const SOrderBlock &block);
    void UpdateOrderBlock(int index, const SOrderBlock &block);
    void RemoveOldOrderBlocks(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COrderBlockDetector::COrderBlockDetector()
{
    ArrayResize(m_orderBlocks, 0);
    ArrayResize(m_lastAnalysis, 0);
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
COrderBlockDetector::~COrderBlockDetector()
{
    ArrayFree(m_orderBlocks);
    ArrayFree(m_lastAnalysis);
}

//+------------------------------------------------------------------+
//| Initialize order block detector                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::Initialize()
{
    CConfig::LogInfo("Initializing Order Block Detector");
    
    //--- Clear existing data
    ClearOrderBlocks();
    
    //--- Initialize last analysis times for all trading pairs
    string pairs[];
    CConfig::GetTradingPairs(pairs);
    
    ArrayResize(m_lastAnalysis, ArraySize(pairs));
    
    for(int i = 0; i < ArraySize(pairs); i++)
    {
        m_lastAnalysis[i] = 0;
    }
    
    CConfig::LogInfo("Order Block Detector initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Analyze pair for order blocks                                    |
//+------------------------------------------------------------------+
bool COrderBlockDetector::AnalyzePair(string symbol)
{
    //--- Check if symbol is valid
    if(!CConfig::IsValidSymbol(symbol))
    {
        CConfig::LogError("Invalid symbol for analysis: " + symbol);
        return false;
    }
    
    //--- Get current time
    datetime currentTime = TimeCurrent();
    
    //--- Check if enough time has passed since last analysis
    string pairs[];
    CConfig::GetTradingPairs(pairs);
    
    int pairIndex = -1;
    for(int i = 0; i < ArraySize(pairs); i++)
    {
        if(pairs[i] == symbol)
        {
            pairIndex = i;
            break;
        }
    }
    
    if(pairIndex >= 0 && pairIndex < ArraySize(m_lastAnalysis))
    {
        if(currentTime - m_lastAnalysis[pairIndex] < 60) // Minimum 1 minute between analyses
            return true;
            
        m_lastAnalysis[pairIndex] = currentTime;
    }
    
    //--- Remove old order blocks for this symbol
    RemoveOldOrderBlocks(symbol);
    
    //--- Detect order blocks on multiple timeframes
    ENUM_TIMEFRAMES timeframes[] = {PERIOD_M15, PERIOD_H1, PERIOD_H4, PERIOD_D1};
    
    bool foundNew = false;
    
    for(int i = 0; i < ArraySize(timeframes); i++)
    {
        if(DetectOrderBlocks(symbol, timeframes[i]))
            foundNew = true;
    }
    
    if(foundNew)
        CConfig::LogDebug("Found new order blocks for " + symbol);
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if there are new order blocks for symbol                   |
//+------------------------------------------------------------------+
bool COrderBlockDetector::HasNewOrderBlock(string symbol)
{
    datetime currentTime = TimeCurrent();
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && 
           currentTime - m_orderBlocks[i].time < 300) // New within 5 minutes
        {
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Get all order blocks for symbol                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::GetOrderBlocks(string symbol, SOrderBlock &blocks[])
{
    ArrayResize(blocks, 0);
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol)
        {
            ArrayResize(blocks, ArraySize(blocks) + 1);
            blocks[ArraySize(blocks) - 1] = m_orderBlocks[i];
        }
    }
    
    return ArraySize(blocks) > 0;
}

//+------------------------------------------------------------------+
//| Get latest order block for symbol                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::GetLatestOrderBlock(string symbol, SOrderBlock &block)
{
    datetime latestTime = 0;
    bool found = false;
    
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time > latestTime)
        {
            latestTime = m_orderBlocks[i].time;
            block = m_orderBlocks[i];
            found = true;
        }
    }
    
    return found;
}

//+------------------------------------------------------------------+
//| Detect order blocks on specific timeframe                        |
//+------------------------------------------------------------------+
bool COrderBlockDetector::DetectOrderBlocks(string symbol, ENUM_TIMEFRAMES timeframe)
{
    int lookback = CConfig::GetOrderBlockLookback();
    bool foundNew = false;
    
    //--- Analyze candles
    for(int i = 1; i <= lookback; i++)
    {
        if(IsOrderBlock(symbol, timeframe, i))
        {
            SOrderBlock block;
            block.symbol = symbol;
            block.time = iTime(symbol, timeframe, i);
            block.high = iHigh(symbol, timeframe, i);
            block.low = iLow(symbol, timeframe, i);
            block.open = iOpen(symbol, timeframe, i);
            block.close = iClose(symbol, timeframe, i);
            block.timeframe = timeframe;
            block.is_bullish = IsBullishOrderBlock(symbol, timeframe, i);
            block.is_confirmed = IsOrderBlockConfirmed(symbol, block);
            block.strength = CalculateOrderBlockStrength(symbol, block);
            block.touch_count = 0;
            block.last_touch = 0;
            
            //--- Validate order block
            if(ValidateOrderBlock(symbol, block))
            {
                //--- Check if this order block already exists
                int existingIndex = FindOrderBlockIndex(symbol, block.time);
                if(existingIndex >= 0)
                {
                    UpdateOrderBlock(existingIndex, block);
                }
                else
                {
                    AddOrderBlock(block);
                    foundNew = true;
                }
            }
        }
    }
    
    return foundNew;
}

//+------------------------------------------------------------------+
//| Check if candle forms an order block                             |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Basic order block criteria
    if(!IsBreakOfStructure(symbol, timeframe, shift))
        return false;
        
    if(!IsLiquidityZone(symbol, timeframe, shift))
        return false;
    
    //--- Check for minimum size requirement
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    double sizePips = CConfig::PointToPips(symbol, high - low);
    
    if(sizePips < CConfig::GetMinOrderBlockSize())
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Validate order block                                             |
//+------------------------------------------------------------------+
bool COrderBlockDetector::ValidateOrderBlock(string symbol, const SOrderBlock &block)
{
    //--- Check minimum size
    double sizePips = CConfig::PointToPips(symbol, block.high - block.low);
    if(sizePips < CConfig::GetMinOrderBlockSize())
        return false;
    
    //--- Check strength threshold
    if(block.strength < 0.3) // Minimum strength of 30%
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Calculate order block strength                                   |
//+------------------------------------------------------------------+
double COrderBlockDetector::CalculateOrderBlockStrength(string symbol, const SOrderBlock &block)
{
    double strength = 0.0;
    
    //--- Volume factor (if available)
    double volume = iVolume(symbol, block.timeframe, 0);
    if(volume > 0)
    {
        double avgVolume = 0;
        for(int i = 1; i <= 20; i++)
        {
            avgVolume += iVolume(symbol, block.timeframe, i);
        }
        avgVolume /= 20.0;
        
        if(volume > avgVolume * 1.5)
            strength += 0.3;
    }
    
    //--- Size factor
    double atr = GetATR(symbol, block.timeframe);
    if(atr > 0)
    {
        double relativeSize = (block.high - block.low) / atr;
        strength += MathMin(relativeSize / 2.0, 0.4);
    }
    
    //--- Time factor (fresher blocks are stronger)
    double hoursSince = (double)(TimeCurrent() - block.time) / 3600.0;
    if(hoursSince < 24)
        strength += 0.3;
    else if(hoursSince < 168) // 1 week
        strength += 0.2;
    
    return MathMin(strength, 1.0);
}

//+------------------------------------------------------------------+
//| Check if order block is confirmed                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsOrderBlockConfirmed(string symbol, const SOrderBlock &block)
{
    int confirmationBars = CConfig::GetOrderBlockConfirmation();
    
    //--- Check if price has moved away from the order block
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    if(block.is_bullish)
    {
        return currentPrice > block.high;
    }
    else
    {
        return currentPrice < block.low;
    }
}

//+------------------------------------------------------------------+
//| Check for break of structure                                     |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBreakOfStructure(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Look for significant price movement
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    double close = iClose(symbol, timeframe, shift);
    double open = iOpen(symbol, timeframe, shift);
    
    //--- Check for strong candle
    double bodySize = MathAbs(close - open);
    double candleSize = high - low;
    
    return bodySize > candleSize * 0.7; // Strong body relative to total range
}

//+------------------------------------------------------------------+
//| Check if area is a liquidity zone                                |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsLiquidityZone(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    //--- Look for previous touches at this level
    double high = iHigh(symbol, timeframe, shift);
    double low = iLow(symbol, timeframe, shift);
    
    int touches = 0;
    for(int i = shift + 1; i < shift + 20; i++)
    {
        double testHigh = iHigh(symbol, timeframe, i);
        double testLow = iLow(symbol, timeframe, i);
        
        if((testHigh >= low && testHigh <= high) || (testLow >= low && testLow <= high))
            touches++;
    }
    
    return touches >= 2; // At least 2 previous touches
}

//+------------------------------------------------------------------+
//| Get Average True Range                                           |
//+------------------------------------------------------------------+
double COrderBlockDetector::GetATR(string symbol, ENUM_TIMEFRAMES timeframe, int period = 14)
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
//| Check if order block is bullish                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBullishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    double open = iOpen(symbol, timeframe, shift);
    double close = iClose(symbol, timeframe, shift);
    
    return close > open;
}

//+------------------------------------------------------------------+
//| Check if order block is bearish                                  |
//+------------------------------------------------------------------+
bool COrderBlockDetector::IsBearishOrderBlock(string symbol, ENUM_TIMEFRAMES timeframe, int shift)
{
    return !IsBullishOrderBlock(symbol, timeframe, shift);
}

//+------------------------------------------------------------------+
//| Find order block index by symbol and time                        |
//+------------------------------------------------------------------+
int COrderBlockDetector::FindOrderBlockIndex(string symbol, datetime time)
{
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time == time)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Add new order block                                              |
//+------------------------------------------------------------------+
void COrderBlockDetector::AddOrderBlock(const SOrderBlock &block)
{
    ArrayResize(m_orderBlocks, ArraySize(m_orderBlocks) + 1);
    m_orderBlocks[ArraySize(m_orderBlocks) - 1] = block;
}

//+------------------------------------------------------------------+
//| Update existing order block                                      |
//+------------------------------------------------------------------+
void COrderBlockDetector::UpdateOrderBlock(int index, const SOrderBlock &block)
{
    if(index >= 0 && index < ArraySize(m_orderBlocks))
        m_orderBlocks[index] = block;
}

//+------------------------------------------------------------------+
//| Remove old order blocks                                          |
//+------------------------------------------------------------------+
void COrderBlockDetector::RemoveOldOrderBlocks(string symbol)
{
    datetime cutoffTime = TimeCurrent() - (7 * 24 * 3600); // 1 week old
    
    for(int i = ArraySize(m_orderBlocks) - 1; i >= 0; i--)
    {
        if(m_orderBlocks[i].symbol == symbol && m_orderBlocks[i].time < cutoffTime)
        {
            ArrayRemove(m_orderBlocks, i, 1);
        }
    }
}

//+------------------------------------------------------------------+
//| Clear all order blocks                                           |
//+------------------------------------------------------------------+
void COrderBlockDetector::ClearOrderBlocks(string symbol = "")
{
    if(symbol == "")
    {
        ArrayResize(m_orderBlocks, 0);
    }
    else
    {
        for(int i = ArraySize(m_orderBlocks) - 1; i >= 0; i--)
        {
            if(m_orderBlocks[i].symbol == symbol)
            {
                ArrayRemove(m_orderBlocks, i, 1);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Get order block count                                            |
//+------------------------------------------------------------------+
int COrderBlockDetector::GetOrderBlockCount(string symbol = "")
{
    if(symbol == "")
        return ArraySize(m_orderBlocks);
    
    int count = 0;
    for(int i = 0; i < ArraySize(m_orderBlocks); i++)
    {
        if(m_orderBlocks[i].symbol == symbol)
            count++;
    }
    
    return count;
}