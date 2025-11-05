//+------------------------------------------------------------------+
//|                                                   NewsFilter.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Enhanced News impact levels and enumerations                    |
//+------------------------------------------------------------------+
enum ENUM_NEWS_IMPACT
{
    NEWS_IMPACT_NONE = 0,       // No impact
    NEWS_IMPACT_LOW = 1,        // Low impact
    NEWS_IMPACT_MEDIUM = 2,     // Medium impact
    NEWS_IMPACT_HIGH = 3,       // High impact
    NEWS_IMPACT_CRITICAL = 4    // Critical impact
};

enum ENUM_NEWS_TYPE
{
    NEWS_TYPE_MONETARY_POLICY,  // Central bank decisions
    NEWS_TYPE_EMPLOYMENT,       // Employment data
    NEWS_TYPE_INFLATION,        // Inflation reports
    NEWS_TYPE_GDP,              // GDP data
    NEWS_TYPE_TRADE_BALANCE,    // Trade balance
    NEWS_TYPE_RETAIL_SALES,     // Retail sales
    NEWS_TYPE_MANUFACTURING,    // Manufacturing data
    NEWS_TYPE_HOUSING,          // Housing data
    NEWS_TYPE_CONSUMER_CONFIDENCE, // Consumer sentiment
    NEWS_TYPE_POLITICAL,        // Political events
    NEWS_TYPE_GEOPOLITICAL,     // Geopolitical events
    NEWS_TYPE_SPEECHES,         // Central bank speeches
    NEWS_TYPE_OTHER             // Other news
};

enum ENUM_NEWS_SENTIMENT
{
    NEWS_SENTIMENT_VERY_BEARISH, // Very bearish for currency
    NEWS_SENTIMENT_BEARISH,      // Bearish for currency
    NEWS_SENTIMENT_NEUTRAL,      // Neutral impact
    NEWS_SENTIMENT_BULLISH,      // Bullish for currency
    NEWS_SENTIMENT_VERY_BULLISH  // Very bullish for currency
};

enum ENUM_NEWS_FREQUENCY
{
    NEWS_FREQ_DAILY,            // Daily news
    NEWS_FREQ_WEEKLY,           // Weekly reports
    NEWS_FREQ_MONTHLY,          // Monthly data
    NEWS_FREQ_QUARTERLY,        // Quarterly reports
    NEWS_FREQ_YEARLY,           // Annual data
    NEWS_FREQ_IRREGULAR         // Irregular/ad-hoc events
};

//+------------------------------------------------------------------+
//| Enhanced News structures                                         |
//+------------------------------------------------------------------+
struct SNewsEvent
{
    string            id;                   // Unique identifier
    string            currency;             // Affected currency
    string            country;              // Country code
    string            title;                // News title
    string            description;          // Detailed description
    datetime          time;                 // Event time
    ENUM_NEWS_IMPACT  impact;              // Expected impact level
    ENUM_NEWS_TYPE    type;                 // Type of news
    ENUM_NEWS_SENTIMENT sentiment;         // Market sentiment
    ENUM_NEWS_FREQUENCY frequency;         // Frequency of release
    string            forecast;             // Forecasted value
    string            previous;             // Previous value
    string            actual;               // Actual value (after release)
    bool              is_upcoming;          // Is event upcoming
    bool              is_released;          // Has been released
    double            surprise_index;       // Surprise factor (actual vs forecast)
    double            volatility_impact;    // Expected volatility impact
    string            affected_pairs[];     // Currency pairs affected
    int               priority;             // Event priority ranking
};

struct SNewsConfig
{
    int               impactThreshold;      // Minimum impact level to consider
    int               bufferMinutesBefore;  // Minutes before news to stop trading
    int               bufferMinutesAfter;   // Minutes after news to stop trading
    bool              enableSentimentAnalysis; // Enable sentiment analysis
    bool              enableSurpriseIndex;  // Enable surprise factor calculation
    bool              enableVolatilityPrediction; // Predict volatility impact
    bool              trackNewsHistory;     // Keep historical news data
    string            newsSource;           // News data source
    string            apiKey;               // API key for news service
    bool              filterLowImpact;      // Filter out low impact news
    bool              enableAdaptiveFilter; // Adaptive filtering based on market
    double            volatilityThreshold;  // Volatility threshold for filtering
};

struct SNewsStatistics
{
    int               totalEvents;          // Total news events processed
    int               highImpactEvents;     // High impact events
    double            averageVolatilityImpact; // Average volatility after news
    double            averageSurpriseIndex; // Average surprise factor
    int               tradingPauses;        // Number of times trading was paused
    datetime          lastUpdate;          // Last statistics update
    double            filterAccuracy;       // Filter accuracy percentage
};

struct SMarketReaction
{
    string            newsId;               // Related news event ID
    string            symbol;               // Affected symbol
    double            priceBeforeNews;      // Price before news
    double            priceAfterNews;       // Price after news
    double            maxVolatility;        // Maximum volatility observed
    double            volumeIncrease;       // Volume increase percentage
    int               reactionTimeSeconds;  // Time to react to news
    ENUM_NEWS_SENTIMENT actualSentiment;   // Actual market sentiment
    bool              predictedCorrectly;   // Was impact predicted correctly
};

//+------------------------------------------------------------------+
//| Advanced News Filter class                                      |
//| Comprehensive news analysis and trading filter system           |
//+------------------------------------------------------------------+
class CNewsFilter
{
private:
    // Configuration
    SNewsConfig       m_config;
    SNewsStatistics   m_statistics;
    
    // News data
    SNewsEvent        m_newsEvents[];
    SNewsEvent        m_upcomingEvents[];
    SNewsEvent        m_historicalEvents[];
    SMarketReaction   m_marketReactions[];
    
    // State tracking
    datetime          m_lastUpdate;
    datetime          m_lastDataFetch;
    bool              m_isFilterActive;
    string            m_affectedCurrencies[];
    
    // News source integration
    string            m_newsApiUrl;
    bool              m_isConnectedToNewsSource;
    
    // Adaptive filtering
    double            m_impactPredictionModel[];
    double            m_volatilityPredictionModel[];
    
public:
    //--- Constructor/Destructor
    CNewsFilter();
    ~CNewsFilter();
    
    //--- Initialization and configuration
    bool Initialize(int impactThreshold = 3, int bufferMinutes = 30);
    bool Initialize(const SNewsConfig &config);
    void SetConfiguration(const SNewsConfig &config);
    SNewsConfig GetConfiguration() const { return m_config; }
    
    //--- News data management
    bool UpdateNewsData();
    bool FetchNewsFromSource();
    bool LoadNewsFromFile(const string filePath);
    bool SaveNewsToFile(const string filePath);
    void AddManualNewsEvent(const SNewsEvent &newsEvent);
    
    //--- Main filtering methods
    bool ShouldAvoidTrading(const string symbol);
    bool ShouldAvoidTrading(const string symbol, datetime checkTime);
    bool IsNewsImpactPeriod(const string symbol);
    bool IsHighImpactNewsExpected(const string symbol, int minutesAhead = 60);
    
    //--- News analysis and prediction
    ENUM_NEWS_IMPACT PredictNewsImpact(const SNewsEvent &newsEvent);
    double CalculateSurpriseIndex(const SNewsEvent &newsEvent);
    double PredictVolatilityImpact(const SNewsEvent &newsEvent);
    ENUM_NEWS_SENTIMENT AnalyzeNewsSentiment(const SNewsEvent &newsEvent);
    
    //--- Currency and pair impact analysis
    bool IsCurrencyAffected(const string currency, const string symbol);
    bool IsPairAffected(const string symbol);
    double GetCurrencyNewsRisk(const string currency);
    double GetPairNewsRisk(const string symbol);
    string GetAffectedCurrencies(string &currencies[]);
    
    //--- News event retrieval
    bool GetUpcomingNews(SNewsEvent &events[], int hoursAhead = 24);
    bool GetHighImpactNews(SNewsEvent &events[], int hoursAhead = 12);
    bool GetNewsForCurrency(const string currency, SNewsEvent &events[]);
    bool GetNewsForTimeRange(datetime startTime, datetime endTime, SNewsEvent &events[]);
    SNewsEvent GetNextHighImpactNews(const string currency);
    
    //--- Market reaction tracking
    void RecordMarketReaction(const string newsId, const string symbol);
    bool AnalyzeMarketReaction(const SNewsEvent &newsEvent, const string symbol);
    double GetAverageMarketReaction(ENUM_NEWS_TYPE newsType, const string currency);
    void UpdateReactionStatistics();
    
    //--- Adaptive filtering and learning
    void UpdateImpactPredictionModel();
    void OptimizeFilterParameters();
    bool IsAdaptiveFilteringEnabled() const { return m_config.enableAdaptiveFilter; }
    void CalibrateFilterBasedOnHistory();
    
    //--- News timing and scheduling
    datetime GetNextNewsTime(const string currency);
    int GetMinutesToNextNews(const string currency);
    bool IsNewsCluster(datetime checkTime, int windowMinutes = 60);
    bool IsOptimalTradingTime(const string symbol);
    
    //--- Volatility and risk assessment
    double EstimatePostNewsVolatility(const SNewsEvent &newsEvent, const string symbol);
    bool IsVolatilityExpected(const string symbol, int minutesAhead = 30);
    double GetNewsVolatilityMultiplier(const string symbol);
    
    //--- News sentiment and bias
    bool IsNewsBullishForCurrency(const string currency);
    bool IsNewsBearishForCurrency(const string currency);
    double GetNewsSentimentScore(const string currency);
    ENUM_NEWS_SENTIMENT GetOverallMarketSentiment();
    
    //--- Performance and statistics
    SNewsStatistics GetNewsStatistics() const { return m_statistics; }
    double GetFilterAccuracy() const { return m_statistics.filterAccuracy; }
    void ResetStatistics();
    void UpdatePerformanceMetrics();
    
    //--- Integration with other systems
    bool IntegrateWithVolatilityAnalyzer(CVolatilityAnalyzer* volAnalyzer);
    bool IntegrateWithRiskManager(CRiskManagement* riskManager);
    bool ValidateWithMarketConditions(const string symbol);
    
    //--- Configuration and settings
    void SetImpactThreshold(int threshold) { m_config.impactThreshold = threshold; }
    void SetBufferMinutes(int beforeMinutes, int afterMinutes);
    void EnableSentimentAnalysis(bool enable) { m_config.enableSentimentAnalysis = enable; }
    void EnableAdaptiveFiltering(bool enable) { m_config.enableAdaptiveFilter = enable; }
    
    //--- Getters
    int GetImpactThreshold() const { return m_config.impactThreshold; }
    int GetBufferMinutes() const { return m_config.bufferMinutesBefore; }
    bool IsNewsFilterActive() const { return m_isFilterActive; }
    int GetUpcomingEventsCount() const { return ArraySize(m_upcomingEvents); }
    
private:
    //--- Internal news processing
    void ProcessNewsEvent(SNewsEvent &newsEvent);
    void CalculateEventPriority(SNewsEvent &newsEvent);
    void DetermineAffectedPairs(SNewsEvent &newsEvent);
    void UpdateEventSentiment(SNewsEvent &newsEvent);
    
    //--- Data parsing and validation
    bool ParseNewsData(const string jsonData, SNewsEvent &events[]);
    bool ValidateNewsEvent(const SNewsEvent &newsEvent);
    void CleanupOldEvents();
    void SortEventsByTime(SNewsEvent &events[]);
    
    //--- Impact calculation helpers
    double CalculateBaseImpact(const SNewsEvent &newsEvent);
    double CalculateTimeDecayFactor(datetime newsTime, datetime currentTime);
    double CalculateCurrencyWeightFactor(const string currency, const string symbol);
    
    //--- Market analysis helpers
    bool IsMarketHours(const string symbol);
    double GetHistoricalVolatilityIncrease(ENUM_NEWS_TYPE newsType);
    bool IsConsensusBreaking(const SNewsEvent &newsEvent);
    
    //--- Array management
    void AddNewsEvent(const SNewsEvent &newsEvent);
    void RemoveExpiredEvents();
    void UpdateUpcomingEvents();
    int FindNewsEventIndex(const string newsId);
    
    //--- Statistical analysis
    void CalculateCorrelationWithMarketMoves();
    void UpdateFilterEffectiveness();
    double CalculatePredictionAccuracy();
    
    //--- Logging and diagnostics
    void LogNewsEvent(const SNewsEvent &newsEvent);
    void LogFilterDecision(const string symbol, bool shouldAvoid, const string reason);
    void LogMarketReaction(const SMarketReaction &reaction);
    void LogStatistics();
    
private:
    //--- Helper methods
    bool ParseNewsData(string newsData);
    SNewsEvent CreateNewsEvent(string currency, string title, datetime time, int impact);
    bool IsWithinBuffer(datetime newsTime);
    string ExtractCurrencyFromSymbol(string symbol, bool isBase);
    bool IsHighImpactNewsUpcoming(string symbol);
    bool IsNewsPeriod(string symbol);
    bool LoadNewsEvents();
    void ClearOldEvents();
    ENUM_NEWS_IMPACT GetUpcomingNewsImpact(string symbol);
    int GetNewsCountInPeriod(string symbol, int minutes);
    string GetBaseCurrency(string symbol);
    string GetQuoteCurrency(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CNewsFilter::CNewsFilter()
{
    m_config.impactThreshold = 3;
    m_config.bufferMinutesBefore = 30;
    m_lastUpdate = 0;
    ArrayResize(m_newsEvents, 0);
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CNewsFilter::~CNewsFilter()
{
    ArrayFree(m_newsEvents);
}

//+------------------------------------------------------------------+
//| Initialize news filter                                           |
//+------------------------------------------------------------------+
bool CNewsFilter::Initialize(int impactThreshold = 3, int bufferMinutes = 30)
{
    m_config.impactThreshold = impactThreshold;
    m_config.bufferMinutesBefore = bufferMinutes;
    
    CConfig::LogInfo(StringFormat("News Filter initialized - Impact threshold: %d, Buffer: %d minutes", 
                     impactThreshold, bufferMinutes));
    
    // Load initial news data
    return true; // Default to true until calendar API is implemented
}

//+------------------------------------------------------------------+
//| Check if high impact news is upcoming                           |
//+------------------------------------------------------------------+
bool CNewsFilter::IsHighImpactNewsUpcoming(string symbol)
{
    // Update news data if needed
    UpdateNewsData();
    
    datetime currentTime = TimeCurrent();
    datetime bufferTime = currentTime + (m_config.bufferMinutesBefore * 60);
    
    string baseCurrency = GetBaseCurrency(symbol);
    string quoteCurrency = GetQuoteCurrency(symbol);
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= currentTime && m_newsEvents[i].time <= bufferTime)
        {
            if(m_newsEvents[i].impact >= m_config.impactThreshold)
            {
                if(IsCurrencyAffected(m_newsEvents[i].currency, symbol))
                {
                    CConfig::LogInfo(StringFormat("High impact news upcoming for %s: %s at %s", 
                                    symbol, m_newsEvents[i].title, TimeToString(m_newsEvents[i].time)));
                    return true;
                }
            }
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if currently in news period                               |
//+------------------------------------------------------------------+
bool CNewsFilter::IsNewsPeriod(string symbol)
{
    datetime currentTime = TimeCurrent();
    datetime bufferBefore = currentTime - (m_config.bufferMinutesBefore * 60);
    datetime bufferAfter = currentTime + (m_config.bufferMinutesBefore * 60);
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= bufferBefore && m_newsEvents[i].time <= bufferAfter)
        {
            if(m_newsEvents[i].impact >= m_config.impactThreshold)
            {
                if(IsCurrencyAffected(m_newsEvents[i].currency, symbol))
                {
                    return true;
                }
            }
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if should avoid trading                                   |
//+------------------------------------------------------------------+
bool CNewsFilter::ShouldAvoidTrading(string symbol)
{
    return IsHighImpactNewsUpcoming(symbol) || IsNewsPeriod(symbol);
}

//+------------------------------------------------------------------+
//| Load news events (placeholder implementation)                    |
//+------------------------------------------------------------------+
bool CNewsFilter::LoadNewsEvents()
{
    // In a real implementation, this would load news from an external source
    // For now, create some sample events
    
    ArrayResize(m_newsEvents, 0);
    
    // Sample high-impact events
    datetime now = TimeCurrent();
    
    // USD events
    SNewsEvent usdEvent1 = CreateNewsEvent("USD", "Non-Farm Payrolls", now + 3600, NEWS_IMPACT_HIGH);
    SNewsEvent usdEvent2 = CreateNewsEvent("USD", "FOMC Meeting", now + 7200, NEWS_IMPACT_HIGH);
    
    // EUR events
    SNewsEvent eurEvent1 = CreateNewsEvent("EUR", "ECB Interest Rate Decision", now + 5400, NEWS_IMPACT_HIGH);
    SNewsEvent eurEvent2 = CreateNewsEvent("EUR", "GDP Growth Rate", now + 9000, NEWS_IMPACT_MEDIUM);
    
    // Add events to array
    ArrayResize(m_newsEvents, 4);
    m_newsEvents[0] = usdEvent1;
    m_newsEvents[1] = usdEvent2;
    m_newsEvents[2] = eurEvent1;
    m_newsEvents[3] = eurEvent2;
    
    m_lastUpdate = TimeCurrent();
    
    CConfig::LogInfo(StringFormat("Loaded %d news events", ArraySize(m_newsEvents)));
    return true;
}

//+------------------------------------------------------------------+
//| Update news data                                                 |
//+------------------------------------------------------------------+
bool CNewsFilter::UpdateNewsData()
{
    // Update every hour
    if(TimeCurrent() - m_lastUpdate > 3600)
    {
        ClearOldEvents();
        return LoadNewsEvents();
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Clear old events                                                 |
//+------------------------------------------------------------------+
void CNewsFilter::ClearOldEvents()
{
    datetime cutoffTime = TimeCurrent() - (24 * 3600); // Remove events older than 24 hours
    
    for(int i = ArraySize(m_newsEvents) - 1; i >= 0; i--)
    {
        if(m_newsEvents[i].time < cutoffTime)
        {
            ArrayRemove(m_newsEvents, i, 1);
        }
    }
}

//+------------------------------------------------------------------+
//| Get upcoming news impact                                         |
//+------------------------------------------------------------------+
ENUM_NEWS_IMPACT CNewsFilter::GetUpcomingNewsImpact(string symbol)
{
    datetime currentTime = TimeCurrent();
    datetime bufferTime = currentTime + (m_config.bufferMinutesBefore * 60);
    
    ENUM_NEWS_IMPACT maxImpact = NEWS_IMPACT_LOW;
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= currentTime && m_newsEvents[i].time <= bufferTime)
        {
            if(IsCurrencyAffected(m_newsEvents[i].currency, symbol))
            {
                if(m_newsEvents[i].impact > maxImpact)
                    maxImpact = m_newsEvents[i].impact;
            }
        }
    }
    
    return maxImpact;
}

//+------------------------------------------------------------------+
//| Get next news time                                               |
//+------------------------------------------------------------------+
datetime CNewsFilter::GetNextNewsTime(string symbol)
{
    datetime currentTime = TimeCurrent();
    datetime nextTime = 0;
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time > currentTime)
        {
            if(IsCurrencyAffected(m_newsEvents[i].currency, symbol))
            {
                if(nextTime == 0 || m_newsEvents[i].time < nextTime)
                    nextTime = m_newsEvents[i].time;
            }
        }
    }
    
    return nextTime;
}

//+------------------------------------------------------------------+
//| Get news count in period                                         |
//+------------------------------------------------------------------+
int CNewsFilter::GetNewsCountInPeriod(string symbol, int minutes)
{
    datetime currentTime = TimeCurrent();
    datetime endTime = currentTime + (minutes * 60);
    
    int count = 0;
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= currentTime && m_newsEvents[i].time <= endTime)
        {
            if(IsCurrencyAffected(m_newsEvents[i].currency, symbol))
            {
                if(m_newsEvents[i].impact >= m_config.impactThreshold)
                    count++;
            }
        }
    }
    
    return count;
}

//+------------------------------------------------------------------+
//| Get base currency                                                |
//+------------------------------------------------------------------+
string CNewsFilter::GetBaseCurrency(string symbol)
{
    return ExtractCurrencyFromSymbol(symbol, true);
}

//+------------------------------------------------------------------+
//| Get quote currency                                               |
//+------------------------------------------------------------------+
string CNewsFilter::GetQuoteCurrency(string symbol)
{
    return ExtractCurrencyFromSymbol(symbol, false);
}

//+------------------------------------------------------------------+
//| Check if currency is affected                                   |
//+------------------------------------------------------------------+
bool CNewsFilter::IsCurrencyAffected(const string currency, const string symbol)
{
    string baseCurrency = GetBaseCurrency(symbol);
    string quoteCurrency = GetQuoteCurrency(symbol);
    
    return (currency == baseCurrency || currency == quoteCurrency);
}

//+------------------------------------------------------------------+
//| Create news event                                                |
//+------------------------------------------------------------------+
SNewsEvent CNewsFilter::CreateNewsEvent(string currency, string title, datetime time, int impact)
{
    SNewsEvent event;
    event.currency = currency;
    event.title = title;
    event.time = time;
    event.impact = (ENUM_NEWS_IMPACT)impact;
    event.forecast = "";
    event.previous = "";
    event.is_upcoming = (time > TimeCurrent());
    
    return event;
}

//+------------------------------------------------------------------+
//| Check if within buffer                                           |
//+------------------------------------------------------------------+
bool CNewsFilter::IsWithinBuffer(datetime newsTime)
{
    datetime currentTime = TimeCurrent();
    int timeDiff = (int)MathAbs(newsTime - currentTime) / 60; // in minutes
    
    return timeDiff <= m_config.bufferMinutesBefore;
}

//+------------------------------------------------------------------+
//| Extract currency from symbol                                     |
//+------------------------------------------------------------------+
string CNewsFilter::ExtractCurrencyFromSymbol(string symbol, bool isBase)
{
    if(StringLen(symbol) >= 6)
    {
        if(isBase)
            return StringSubstr(symbol, 0, 3);
        else
            return StringSubstr(symbol, 3, 3);
    }
    
    return "";
}
