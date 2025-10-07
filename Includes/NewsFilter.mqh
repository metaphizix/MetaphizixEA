//+------------------------------------------------------------------+
//|                                                   NewsFilter.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| News impact levels                                               |
//+------------------------------------------------------------------+
enum ENUM_NEWS_IMPACT
{
    NEWS_IMPACT_LOW = 1,
    NEWS_IMPACT_MEDIUM = 2,
    NEWS_IMPACT_HIGH = 3
};

//+------------------------------------------------------------------+
//| News event structure                                             |
//+------------------------------------------------------------------+
struct SNewsEvent
{
    string            currency;
    string            title;
    datetime          time;
    ENUM_NEWS_IMPACT  impact;
    string            forecast;
    string            previous;
    bool              is_upcoming;
};

//+------------------------------------------------------------------+
//| News filter class                                                |
//| Filters trading based on economic news events                    |
//+------------------------------------------------------------------+
class CNewsFilter
{
private:
    int               m_impactThreshold;
    int               m_bufferMinutes;
    SNewsEvent        m_newsEvents[];
    datetime          m_lastUpdate;
    
public:
    //--- Constructor/Destructor
    CNewsFilter();
    ~CNewsFilter();
    
    //--- Initialization
    bool Initialize(int impactThreshold = 3, int bufferMinutes = 30);
    
    //--- Main methods
    bool IsHighImpactNewsUpcoming(string symbol);
    bool IsNewsPeriod(string symbol);
    bool ShouldAvoidTrading(string symbol);
    
    //--- News data management
    bool LoadNewsEvents();
    bool UpdateNewsData();
    void ClearOldEvents();
    
    //--- Analysis methods
    ENUM_NEWS_IMPACT GetUpcomingNewsImpact(string symbol);
    datetime GetNextNewsTime(string symbol);
    int GetNewsCountInPeriod(string symbol, int minutes);
    
    //--- Utility methods
    string GetBaseCurrency(string symbol);
    string GetQuoteCurrency(string symbol);
    bool IsCurrencyAffected(string currency, string symbol);
    
    //--- Getters/Setters
    void SetImpactThreshold(int threshold) { m_impactThreshold = threshold; }
    void SetBufferMinutes(int minutes) { m_bufferMinutes = minutes; }
    int GetImpactThreshold() { return m_impactThreshold; }
    int GetBufferMinutes() { return m_bufferMinutes; }
    
private:
    //--- Helper methods
    bool ParseNewsData(string newsData);
    SNewsEvent CreateNewsEvent(string currency, string title, datetime time, int impact);
    bool IsWithinBuffer(datetime newsTime);
    string ExtractCurrencyFromSymbol(string symbol, bool isBase);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CNewsFilter::CNewsFilter()
{
    m_impactThreshold = 3;
    m_bufferMinutes = 30;
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
    m_impactThreshold = impactThreshold;
    m_bufferMinutes = bufferMinutes;
    
    CConfig::LogInfo(StringFormat("News Filter initialized - Impact threshold: %d, Buffer: %d minutes", 
                     impactThreshold, bufferMinutes));
    
    // Load initial news data
    return LoadNewsEvents();
}

//+------------------------------------------------------------------+
//| Check if high impact news is upcoming                           |
//+------------------------------------------------------------------+
bool CNewsFilter::IsHighImpactNewsUpcoming(string symbol)
{
    // Update news data if needed
    UpdateNewsData();
    
    datetime currentTime = TimeCurrent();
    datetime bufferTime = currentTime + (m_bufferMinutes * 60);
    
    string baseCurrency = GetBaseCurrency(symbol);
    string quoteCurrency = GetQuoteCurrency(symbol);
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= currentTime && m_newsEvents[i].time <= bufferTime)
        {
            if(m_newsEvents[i].impact >= m_impactThreshold)
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
    datetime bufferBefore = currentTime - (m_bufferMinutes * 60);
    datetime bufferAfter = currentTime + (m_bufferMinutes * 60);
    
    for(int i = 0; i < ArraySize(m_newsEvents); i++)
    {
        if(m_newsEvents[i].time >= bufferBefore && m_newsEvents[i].time <= bufferAfter)
        {
            if(m_newsEvents[i].impact >= m_impactThreshold)
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
    datetime bufferTime = currentTime + (m_bufferMinutes * 60);
    
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
                if(m_newsEvents[i].impact >= m_impactThreshold)
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
bool CNewsFilter::IsCurrencyAffected(string currency, string symbol)
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
    
    return timeDiff <= m_bufferMinutes;
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