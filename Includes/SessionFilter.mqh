//+------------------------------------------------------------------+
//|                                                SessionFilter.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Trading session filter class                                     |
//| Manages trading hours and session-based filtering                |
//+------------------------------------------------------------------+
class CSessionFilter
{
private:
    int               m_sessionStartHour;
    int               m_sessionEndHour;
    bool              m_enableWeekendFilter;
    bool              m_enableHolidayFilter;
    
public:
    //--- Constructor/Destructor
    CSessionFilter();
    ~CSessionFilter();
    
    //--- Initialization
    bool Initialize(int startHour = 9, int endHour = 22, bool weekendFilter = true);
    
    //--- Session validation methods
    bool IsWithinTradingSession();
    bool IsMarketOpen();
    bool IsWeekend();
    bool IsHoliday();
    bool IsTradingAllowed();
    
    //--- Session analysis
    bool IsAsianSession();
    bool IsEuropeanSession();
    bool IsAmericanSession();
    bool IsSessionOverlap();
    
    //--- Time zone conversions
    datetime ConvertToSAST(datetime utcTime);
    datetime ConvertFromSAST(datetime sastTime);
    int GetCurrentHourSAST();
    
    //--- Volatility and activity analysis
    bool IsHighVolatilityPeriod();
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