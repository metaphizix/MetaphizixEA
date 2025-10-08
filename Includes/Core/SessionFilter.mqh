//+------------------------------------------------------------------+
//|                                                SessionFilter.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Enhanced Trading session enumerations                           |
//+------------------------------------------------------------------+
enum ENUM_TRADING_SESSION
{
    SESSION_ASIAN,              // Asian session (Tokyo)
    SESSION_EUROPEAN,           // European session (London)
    SESSION_AMERICAN,           // American session (New York)
    SESSION_PACIFIC,            // Pacific session (Sydney)
    SESSION_OVERLAP_ASIAN_EUR,  // Asian-European overlap
    SESSION_OVERLAP_EUR_US,     // European-US overlap
    SESSION_OVERLAP_US_ASIAN,   // US-Asian overlap
    SESSION_NONE                // Outside major sessions
};

enum ENUM_SESSION_QUALITY
{
    SESSION_QUALITY_POOR,       // Poor liquidity/activity
    SESSION_QUALITY_FAIR,       // Fair trading conditions
    SESSION_QUALITY_GOOD,       // Good trading conditions
    SESSION_QUALITY_EXCELLENT   // Excellent liquidity/activity
};

enum ENUM_TIME_ZONE
{
    TIMEZONE_UTC,               // UTC time
    TIMEZONE_NEW_YORK,          // New York (EST/EDT)
    TIMEZONE_LONDON,            // London (GMT/BST)
    TIMEZONE_TOKYO,             // Tokyo (JST)
    TIMEZONE_SYDNEY,            // Sydney (AEST/AEDT)
    TIMEZONE_FRANKFURT,         // Frankfurt (CET/CEST)
    TIMEZONE_SAST,              // South African Standard Time
    TIMEZONE_SERVER             // Broker server time
};

enum ENUM_MARKET_HOURS
{
    MARKET_HOURS_24_5,          // 24/5 market (Sunday evening - Friday evening)
    MARKET_HOURS_BUSINESS,      // Business hours only
    MARKET_HOURS_EXTENDED,      // Extended hours
    MARKET_HOURS_CUSTOM         // Custom hours definition
};

//+------------------------------------------------------------------+
//| Enhanced Session structures                                     |
//+------------------------------------------------------------------+
struct SSessionInfo
{
    ENUM_TRADING_SESSION session;
    string name;
    int startHour;              // Start hour in UTC
    int startMinute;            // Start minute
    int endHour;                // End hour in UTC
    int endMinute;              // End minute
    ENUM_TIME_ZONE timezone;    // Session timezone
    double avgVolatility;       // Average volatility during session
    double avgSpread;           // Average spread during session
    double liquidityScore;      // Liquidity score (0-100)
    bool isDST;                 // Daylight saving time active
};

struct SSessionConfig
{
    int customStartHour;        // Custom session start hour
    int customEndHour;          // Custom session end hour
    ENUM_TIME_ZONE baseTimezone; // Base timezone for calculations
    bool enableWeekendFilter;   // Filter weekend trading
    bool enableHolidayFilter;   // Filter holiday trading
    bool enableLiquidityFilter; // Filter based on liquidity
    bool enableVolatilityFilter; // Filter based on volatility
    double minLiquidityScore;   // Minimum liquidity score required
    double minVolatilityLevel;  // Minimum volatility level
    bool adaptToMarketConditions; // Adapt session rules to market
    string holidayCalendar[];   // Holiday calendar for filtering
};

struct SSessionStatistics
{
    ENUM_TRADING_SESSION session;
    int totalTrades;            // Total trades during session
    int profitableTrades;       // Profitable trades
    double averageProfit;       // Average profit per trade
    double winRate;             // Win rate percentage
    double averageVolatility;   // Average volatility
    double averageSpread;       // Average spread
    datetime lastUpdate;        // Last statistics update
    double sharpeRatio;         // Sharpe ratio for session
};

struct SMarketActivity
{
    string symbol;
    ENUM_TRADING_SESSION activeSession;
    double currentVolatility;
    double currentSpread;
    double liquidityLevel;
    double activityScore;       // Overall activity score (0-100)
    bool isOptimalTradingTime;
    datetime lastUpdate;
};

//+------------------------------------------------------------------+
//| Advanced Trading Session Filter class                           |
//| Comprehensive session analysis and trading time optimization    |
//+------------------------------------------------------------------+
class CSessionFilter
{
private:
    // Configuration
    SSessionConfig m_config;
    SSessionInfo m_sessions[];
    SSessionStatistics m_sessionStats[];
    
    // Market activity tracking
    SMarketActivity m_marketActivity[];
    string m_trackedSymbols[];
    
    // Time zone and DST management
    int m_timezoneOffsets[];
    bool m_isDSTActive[];
    datetime m_lastDSTCheck;
    
    // Holiday calendar
    datetime m_holidays[];
    string m_holidayNames[];
    
    // Performance tracking
    double m_sessionVolatility[][];  // [session][hour]
    double m_sessionSpreads[][];     // [session][hour]
    double m_sessionLiquidity[][];   // [session][hour]
    
public:
    //--- Constructor/Destructor
    CSessionFilter();
    ~CSessionFilter();
    
    //--- Initialization and configuration
    bool Initialize(int startHour = 9, int endHour = 22, bool weekendFilter = true);
    bool Initialize(const SSessionConfig &config);
    void SetConfiguration(const SSessionConfig &config);
    SSessionConfig GetConfiguration() const { return m_config; }
    
    //--- Session identification and analysis
    ENUM_TRADING_SESSION GetCurrentSession();
    ENUM_TRADING_SESSION GetActiveSession(const string symbol);
    ENUM_SESSION_QUALITY GetSessionQuality(ENUM_TRADING_SESSION session);
    bool IsSessionOverlap();
    bool IsSessionTransition();
    
    //--- Main filtering methods
    bool IsTradingAllowed();
    bool IsTradingAllowed(const string symbol);
    bool IsOptimalTradingTime(const string symbol);
    bool IsHighActivityPeriod(const string symbol);
    bool ShouldAvoidTrading(const string symbol);
    
    //--- Time and market validation
    bool IsWithinTradingSession();
    bool IsMarketOpen();
    bool IsMarketOpen(const string symbol);
    bool IsWeekend();
    bool IsHoliday();
    bool IsHoliday(datetime checkDate);
    
    //--- Session-specific analysis
    bool IsAsianSession();
    bool IsEuropeanSession();
    bool IsAmericanSession();
    bool IsPacificSession();
    bool IsAsianEuropeanOverlap();
    bool IsEuropeanAmericanOverlap();
    bool IsAmericanAsianOverlap();
    
    //--- Liquidity and volatility analysis
    double GetCurrentLiquidity(const string symbol);
    double GetSessionVolatility(ENUM_TRADING_SESSION session, const string symbol);
    double GetSessionSpread(ENUM_TRADING_SESSION session, const string symbol);
    bool IsHighLiquidityPeriod(const string symbol);
    bool IsHighVolatilityPeriod(const string symbol);
    
    //--- Time zone and conversion utilities
    datetime ConvertTime(datetime time, ENUM_TIME_ZONE fromTZ, ENUM_TIME_ZONE toTZ);
    datetime ConvertToUTC(datetime localTime, ENUM_TIME_ZONE timezone);
    datetime ConvertFromUTC(datetime utcTime, ENUM_TIME_ZONE timezone);
    int GetTimezoneOffset(ENUM_TIME_ZONE timezone);
    bool IsDSTActive(ENUM_TIME_ZONE timezone);
    
    //--- Session timing optimization
    datetime GetSessionStart(ENUM_TRADING_SESSION session);
    datetime GetSessionEnd(ENUM_TRADING_SESSION session);
    int GetMinutesToSessionStart(ENUM_TRADING_SESSION session);
    int GetMinutesToSessionEnd(ENUM_TRADING_SESSION session);
    ENUM_TRADING_SESSION GetNextSession();
    datetime GetNextSessionStart();
    
    //--- Market activity scoring
    double CalculateActivityScore(const string symbol);
    double GetOptimalTradingScore(const string symbol);
    bool IsAboveActivityThreshold(const string symbol, double threshold = 70.0);
    void UpdateMarketActivity(const string symbol);
    
    //--- Session performance analysis
    SSessionStatistics GetSessionStatistics(ENUM_TRADING_SESSION session);
    double GetSessionWinRate(ENUM_TRADING_SESSION session);
    double GetSessionProfitability(ENUM_TRADING_SESSION session);
    ENUM_TRADING_SESSION GetBestPerformingSession();
    ENUM_TRADING_SESSION GetWorstPerformingSession();
    
    //--- Holiday and calendar management
    bool AddHoliday(datetime date, const string name);
    bool RemoveHoliday(datetime date);
    bool IsMarketHoliday(datetime date, const string country = "");
    void LoadHolidayCalendar(const string country);
    void UpdateHolidayCalendar();
    
    //--- Adaptive session management
    void AdaptSessionRules();
    void OptimizeSessionParameters();
    bool ShouldExtendSession(ENUM_TRADING_SESSION session);
    bool ShouldReduceSession(ENUM_TRADING_SESSION session);
    void UpdateSessionBoundaries();
    
    //--- Integration with other systems
    bool IntegrateWithNewsFilter(CNewsFilter* newsFilter);
    bool IntegrateWithVolatilityAnalyzer(CVolatilityAnalyzer* volAnalyzer);
    bool ValidateWithMarketConditions(const string symbol);
    
    //--- Session-based risk management
    double GetSessionRiskMultiplier(ENUM_TRADING_SESSION session);
    bool ShouldReducePositionSize(ENUM_TRADING_SESSION session);
    double GetMaxAllowedExposure(ENUM_TRADING_SESSION session);
    
    //--- Performance tracking and statistics
    void RecordSessionTrade(ENUM_TRADING_SESSION session, bool profitable, double pnl);
    void UpdateSessionStatistics();
    void ResetSessionStatistics();
    double GetOverallSessionPerformance();
    
    //--- Configuration getters/setters
    void SetCustomSessionHours(int startHour, int endHour);
    void SetBaseTimezone(ENUM_TIME_ZONE timezone) { m_config.baseTimezone = timezone; }
    void EnableWeekendFilter(bool enable) { m_config.enableWeekendFilter = enable; }
    void EnableHolidayFilter(bool enable) { m_config.enableHolidayFilter = enable; }
    void SetMinLiquidityScore(double score) { m_config.minLiquidityScore = score; }
    
    //--- Getters
    int GetSessionStartHour() const { return m_config.customStartHour; }
    int GetSessionEndHour() const { return m_config.customEndHour; }
    bool IsWeekendFilterEnabled() const { return m_config.enableWeekendFilter; }
    bool IsHolidayFilterEnabled() const { return m_config.enableHolidayFilter; }
    
private:
    //--- Internal session management
    void InitializeDefaultSessions();
    void UpdateDSTStatus();
    void CalculateSessionBoundaries();
    void ValidateSessionConfiguration();
    
    //--- Time calculation helpers
    int GetCurrentHourUTC();
    int GetCurrentMinuteUTC();
    datetime GetCurrentTimeInTimezone(ENUM_TIME_ZONE timezone);
    bool IsWithinTimeRange(int currentHour, int currentMinute, int startHour, int startMinute, int endHour, int endMinute);
    
    //--- Market analysis helpers
    void UpdateVolatilityMetrics(const string symbol);
    void UpdateSpreadMetrics(const string symbol);
    void UpdateLiquidityMetrics(const string symbol);
    double CalculateLiquidityScore(const string symbol);
    
    //--- Session overlap calculations
    bool IsSessionActive(ENUM_TRADING_SESSION session);
    int GetActiveSessionCount();
    double GetOverlapIntensity();
    
    //--- Statistical analysis
    void CalculateSessionAverages();
    void UpdateMovingAverages();
    double GetHistoricalSessionVolatility(ENUM_TRADING_SESSION session, int period = 20);
    
    //--- Array management
    int FindSymbolIndex(const string symbol);
    void AddSymbolToTracking(const string symbol);
    void RemoveSymbolFromTracking(const string symbol);
    void ResizeActivityArrays(int newSize);
    
    //--- Holiday calendar helpers
    bool ParseHolidayData(const string calendarData);
    bool IsWeekendInCountry(const string country);
    datetime GetNextBusinessDay(datetime date);
    
    //--- Logging and diagnostics
    void LogSessionChange(ENUM_TRADING_SESSION oldSession, ENUM_TRADING_SESSION newSession);
    void LogTradingDecision(const string symbol, bool allowed, const string reason);
    void LogSessionStatistics();
};
    bool IsLowVolatilityPeriod();
    double GetSessionVolatilityMultiplier();
    
    //--- Getters/Setters
    void SetSessionHours(int startHour, int endHour);
    void SetWeekendFilter(bool enable) { m_enableWeekendFilter = enable; }
    void SetHolidayFilter(bool enable) { m_enableHolidayFilter = enable; }
    
    int GetSessionStartHour() { return m_sessionStartHour; }
    int GetSessionEndHour() { return m_sessionEndHour; }
    bool IsWeekendFilterEnabled() { return m_enableWeekendFilter; }
    bool IsHolidayFilterEnabled() { return m_enableHolidayFilter; }
    
private:
    //--- Helper methods
    bool IsWithinHours(int currentHour, int startHour, int endHour);
    bool CheckHolidayCalendar(datetime date);
    string GetSessionName();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSessionFilter::CSessionFilter()
{
    m_sessionStartHour = 9;  // 9 AM SAST
    m_sessionEndHour = 22;   // 10 PM SAST
    m_enableWeekendFilter = true;
    m_enableHolidayFilter = false; // Disabled by default for simplicity
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSessionFilter::~CSessionFilter()
{
}

//+------------------------------------------------------------------+
//| Initialize session filter                                        |
//+------------------------------------------------------------------+
bool CSessionFilter::Initialize(int startHour = 9, int endHour = 22, bool weekendFilter = true)
{
    m_sessionStartHour = startHour;
    m_sessionEndHour = endHour;
    m_enableWeekendFilter = weekendFilter;
    
    CConfig::LogInfo(StringFormat("Session Filter initialized - Hours: %02d:00 - %02d:00 SAST, Weekend filter: %s", 
                     startHour, endHour, weekendFilter ? "Enabled" : "Disabled"));
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if within trading session                                 |
//+------------------------------------------------------------------+
bool CSessionFilter::IsWithinTradingSession()
{
    int currentHour = GetCurrentHourSAST();
    return IsWithinHours(currentHour, m_sessionStartHour, m_sessionEndHour);
}

//+------------------------------------------------------------------+
//| Check if market is open                                         |
//+------------------------------------------------------------------+
bool CSessionFilter::IsMarketOpen()
{
    // Forex market is open 24/5, but we can add specific market hours logic
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    
    // Check weekend
    if(m_enableWeekendFilter && IsWeekend())
        return false;
    
    // Check holidays
    if(m_enableHolidayFilter && IsHoliday())
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if weekend                                                |
//+------------------------------------------------------------------+
bool CSessionFilter::IsWeekend()
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    
    // Saturday = 6, Sunday = 0
    return (dt.day_of_week == 0 || dt.day_of_week == 6);
}

//+------------------------------------------------------------------+
//| Check if holiday                                                |
//+------------------------------------------------------------------+
bool CSessionFilter::IsHoliday()
{
    if(!m_enableHolidayFilter)
        return false;
    
    return CheckHolidayCalendar(TimeCurrent());
}

//+------------------------------------------------------------------+
//| Check if trading is allowed                                     |
//+------------------------------------------------------------------+
bool CSessionFilter::IsTradingAllowed()
{
    if(!IsMarketOpen())
        return false;
    
    if(!IsWithinTradingSession())
        return false;
    
    return true;
}

//+------------------------------------------------------------------+
//| Check if Asian session (Tokyo)                                  |
//+------------------------------------------------------------------+
bool CSessionFilter::IsAsianSession()
{
    int currentHour = GetCurrentHourSAST();
    // Asian session: approximately 02:00 - 11:00 SAST
    return IsWithinHours(currentHour, 2, 11);
}

//+------------------------------------------------------------------+
//| Check if European session (London)                              |
//+------------------------------------------------------------------+
bool CSessionFilter::IsEuropeanSession()
{
    int currentHour = GetCurrentHourSAST();
    // European session: approximately 09:00 - 18:00 SAST
    return IsWithinHours(currentHour, 9, 18);
}

//+------------------------------------------------------------------+
//| Check if American session (New York)                            |
//+------------------------------------------------------------------+
bool CSessionFilter::IsAmericanSession()
{
    int currentHour = GetCurrentHourSAST();
    // American session: approximately 15:00 - 00:00 SAST
    return IsWithinHours(currentHour, 15, 24) || IsWithinHours(currentHour, 0, 0);
}

//+------------------------------------------------------------------+
//| Check if session overlap                                        |
//+------------------------------------------------------------------+
bool CSessionFilter::IsSessionOverlap()
{
    int currentHour = GetCurrentHourSAST();
    
    // Asian-European overlap: 09:00 - 11:00 SAST
    if(IsWithinHours(currentHour, 9, 11))
        return true;
    
    // European-American overlap: 15:00 - 18:00 SAST
    if(IsWithinHours(currentHour, 15, 18))
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Convert UTC time to SAST                                        |
//+------------------------------------------------------------------+
datetime CSessionFilter::ConvertToSAST(datetime utcTime)
{
    // SAST is UTC+2
    return utcTime + (2 * 3600);
}

//+------------------------------------------------------------------+
//| Convert SAST time to UTC                                        |
//+------------------------------------------------------------------+
datetime CSessionFilter::ConvertFromSAST(datetime sastTime)
{
    // SAST is UTC+2
    return sastTime - (2 * 3600);
}

//+------------------------------------------------------------------+
//| Get current hour in SAST                                        |
//+------------------------------------------------------------------+
int CSessionFilter::GetCurrentHourSAST()
{
    datetime sastTime = ConvertToSAST(TimeCurrent());
    MqlDateTime dt;
    TimeToStruct(sastTime, dt);
    return dt.hour;
}

//+------------------------------------------------------------------+
//| Check if high volatility period                                 |
//+------------------------------------------------------------------+
bool CSessionFilter::IsHighVolatilityPeriod()
{
    // High volatility during session overlaps and major news times
    if(IsSessionOverlap())
        return true;
    
    int currentHour = GetCurrentHourSAST();
    
    // Major news release times (approximate)
    if(IsWithinHours(currentHour, 14, 16)) // US market open + economic releases
        return true;
    
    if(IsWithinHours(currentHour, 8, 10)) // European market open
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if low volatility period                                  |
//+------------------------------------------------------------------+
bool CSessionFilter::IsLowVolatilityPeriod()
{
    int currentHour = GetCurrentHourSAST();
    
    // Typically low volatility periods
    if(IsWithinHours(currentHour, 22, 2)) // Late NY / Early Asian
        return true;
    
    if(IsWithinHours(currentHour, 11, 14)) // European lunch / Pre-NY
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Get session volatility multiplier                               |
//+------------------------------------------------------------------+
double CSessionFilter::GetSessionVolatilityMultiplier()
{
    if(IsHighVolatilityPeriod())
        return 1.5; // Increase sensitivity during high volatility
    
    if(IsLowVolatilityPeriod())
        return 0.7; // Decrease sensitivity during low volatility
    
    return 1.0; // Normal volatility
}

//+------------------------------------------------------------------+
//| Set session hours                                               |
//+------------------------------------------------------------------+
void CSessionFilter::SetSessionHours(int startHour, int endHour)
{
    m_sessionStartHour = startHour;
    m_sessionEndHour = endHour;
    
    CConfig::LogInfo(StringFormat("Session hours updated: %02d:00 - %02d:00 SAST", startHour, endHour));
}

//+------------------------------------------------------------------+
//| Check if within hours                                           |
//+------------------------------------------------------------------+
bool CSessionFilter::IsWithinHours(int currentHour, int startHour, int endHour)
{
    if(startHour <= endHour)
    {
        return (currentHour >= startHour && currentHour < endHour);
    }
    else
    {
        // Handle overnight sessions (e.g., 22:00 - 06:00)
        return (currentHour >= startHour || currentHour < endHour);
    }
}

//+------------------------------------------------------------------+
//| Check holiday calendar                                          |
//+------------------------------------------------------------------+
bool CSessionFilter::CheckHolidayCalendar(datetime date)
{
    // Simplified holiday check - can be expanded with actual holiday calendar
    MqlDateTime dt;
    TimeToStruct(date, dt);
    
    // Example: New Year's Day
    if(dt.mon == 1 && dt.day == 1)
        return true;
    
    // Example: Christmas Day
    if(dt.mon == 12 && dt.day == 25)
        return true;
    
    // Add more holidays as needed
    
    return false;
}

//+------------------------------------------------------------------+
//| Get session name                                                |
//+------------------------------------------------------------------+
string CSessionFilter::GetSessionName()
{
    if(IsAsianSession() && IsEuropeanSession())
        return "Asian-European Overlap";
    else if(IsEuropeanSession() && IsAmericanSession())
        return "European-American Overlap";
    else if(IsAsianSession())
        return "Asian Session";
    else if(IsEuropeanSession())
        return "European Session";
    else if(IsAmericanSession())
        return "American Session";
    else
        return "Off-Session";
}