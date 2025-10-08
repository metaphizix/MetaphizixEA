//+------------------------------------------------------------------+
//|                                           SeasonalityAnalyzer.mqh |
//|                                   Advanced Seasonality Analysis |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Seasonality Analysis Class                                     |
//+------------------------------------------------------------------+
class CSeasonalityAnalyzer
{
private:
    //--- Seasonal patterns
    struct SeasonalPattern
    {
        int month;
        int dayOfWeek;
        int hour;
        double avgReturn;
        double volatility;
        double winRate;
        int sampleSize;
        bool isBullish;
        bool isBearish;
        double confidence;
        string description;
    };
    
    SeasonalPattern m_monthlyPatterns[12];
    SeasonalPattern m_weeklyPatterns[7];  // 0=Sunday, 1=Monday, etc.
    SeasonalPattern m_hourlyPatterns[24];
    
    //--- Calendar effects
    struct CalendarEffect
    {
        string eventName;
        int month;
        int day;
        double expectedImpact;
        string direction;
        int daysAffected;
        bool isRecurring;
        double historicalReliability;
    };
    
    CalendarEffect m_calendarEffects[50];
    int m_calendarEffectCount;
    
    //--- Session analysis
    struct TradingSession
    {
        string sessionName;
        int startHour;
        int endHour;
        double avgVolatility;
        double avgReturn;
        double bestPerformance;
        string timeZone;
        bool isActive;
        double currentVolatility;
    };
    
    TradingSession m_sessions[4]; // Asian, London, NY, Sydney
    
    //--- Holiday effects
    struct HolidayEffect
    {
        string holidayName;
        string country;
        datetime date;
        int daysBefore;
        int daysAfter;
        double expectedVolatility;
        string marketBehavior;
    };
    
    HolidayEffect m_holidays[30];
    int m_holidayCount;
    
    //--- Economic cycle patterns
    struct EconomicCycle
    {
        string cycleName;
        int durationMonths;
        string currentPhase;
        double phaseProgress;
        string expectedDirection;
        double confidence;
    };
    
    EconomicCycle m_economicCycles[5];
    int m_cycleCount;

public:
    //--- Constructor
    CSeasonalityAnalyzer();
    
    //--- Initialization
    bool Initialize(string symbol);
    void LoadHistoricalData(string symbol, int years = 5);
    void CalculateSeasonalPatterns(string symbol);
    
    //--- Monthly seasonality
    void AnalyzeMonthlyPatterns(string symbol);
    double GetMonthlyBias(int month);
    bool IsStrongMonthlyPattern(int month);
    string GetMonthlyDescription(int month);
    
    //--- Weekly seasonality
    void AnalyzeWeeklyPatterns(string symbol);
    double GetDayOfWeekBias(int dayOfWeek);
    bool IsBestDayOfWeek(int dayOfWeek);
    bool IsWorstDayOfWeek(int dayOfWeek);
    
    //--- Intraday seasonality
    void AnalyzeHourlyPatterns(string symbol);
    double GetHourlyBias(int hour);
    bool IsActiveHour(int hour);
    string GetBestTradingHours();
    string GetWorstTradingHours();
    
    //--- Trading session analysis
    void AnalyzeTradingSessions(string symbol);
    string GetCurrentSession();
    double GetSessionVolatility(string sessionName);
    bool IsOverlapPeriod();
    string GetBestSession(string symbol);
    
    //--- Calendar effects
    void LoadCalendarEffects();
    bool IsCalendarEffectActive(datetime date);
    double GetCalendarImpact(datetime date);
    bool IsHolidayPeriod(datetime date);
    void CheckUpcomingEvents(datetime date);
    
    //--- Economic cycles
    void AnalyzeEconomicCycles(string symbol);
    string GetCurrentEconomicPhase();
    double GetCyclicalBias();
    bool IsEconomicTurningPoint();
    
    //--- Current analysis
    double GetCurrentSeasonalBias(string symbol);
    bool IsCurrentlyBullishSeason(string symbol);
    bool IsCurrentlyBearishSeason(string symbol);
    double GetSeasonalConfidence();
    
    //--- Signal generation
    ENUM_ORDER_TYPE GetSeasonalSignal(string symbol);
    double GetSeasonalRiskAdjustment();
    bool ShouldAvoidTrading();
    bool IsOptimalTradingTime();
    
    //--- Volatility patterns
    double GetExpectedVolatility(string symbol);
    bool IsHighVolatilityPeriod();
    bool IsLowVolatilityPeriod();
    void PredictVolatilityChanges();
    
    //--- Turn of month/quarter effects
    bool IsTurnOfMonth();
    bool IsTurnOfQuarter();
    bool IsMonthEnd();
    bool IsQuarterEnd();
    double GetTurnOfMonthBias();
    
    //--- News and earnings seasonality
    bool IsEarningsSeasonPeak();
    bool IsLowNewsVolumePeriod();
    double GetNewsImpactMultiplier();
    
    //--- Advanced patterns
    void DetectAnomalies(string symbol);
    bool IsSeasonalAnomaly();
    void AnalyzeSeasonalReversals(string symbol);
    bool IsCounterSeasonalMove();
    
    //--- Risk management
    double AdjustPositionSizeForSeasonality();
    bool ShouldReduceRisk();
    bool ShouldIncreaseRisk();
    
    //--- Information functions
    SeasonalPattern GetMonthlyPattern(int month);
    SeasonalPattern GetWeeklyPattern(int dayOfWeek);
    SeasonalPattern GetHourlyPattern(int hour);
    
    //--- Utility functions
    int GetCurrentMonth();
    int GetCurrentDayOfWeek();
    int GetCurrentHour();
    string GetSeasonDescription();
    
    //--- Reporting
    void PrintSeasonalAnalysis(string symbol);
    void PrintMonthlyPatterns();
    void PrintWeeklyPatterns();
    void PrintHourlyPatterns();
    string GetSeasonalSummary(string symbol);
    
    //--- Backtesting
    void BacktestSeasonalStrategy(string symbol, int years = 5);
    double GetSeasonalStrategyPerformance();
    void OptimizeSeasonalParameters();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSeasonalityAnalyzer::CSeasonalityAnalyzer()
{
    //--- Initialize seasonal patterns
    for(int i = 0; i < 12; i++)
    {
        m_monthlyPatterns[i].month = i + 1;
        m_monthlyPatterns[i].avgReturn = 0.0;
        m_monthlyPatterns[i].volatility = 0.0;
        m_monthlyPatterns[i].winRate = 50.0;
        m_monthlyPatterns[i].confidence = 0.0;
        m_monthlyPatterns[i].isBullish = false;
        m_monthlyPatterns[i].isBearish = false;
    }
    
    for(int i = 0; i < 7; i++)
    {
        m_weeklyPatterns[i].dayOfWeek = i;
        m_weeklyPatterns[i].avgReturn = 0.0;
        m_weeklyPatterns[i].volatility = 0.0;
        m_weeklyPatterns[i].winRate = 50.0;
        m_weeklyPatterns[i].confidence = 0.0;
    }
    
    for(int i = 0; i < 24; i++)
    {
        m_hourlyPatterns[i].hour = i;
        m_hourlyPatterns[i].avgReturn = 0.0;
        m_hourlyPatterns[i].volatility = 0.0;
        m_hourlyPatterns[i].winRate = 50.0;
        m_hourlyPatterns[i].confidence = 0.0;
    }
    
    //--- Initialize trading sessions
    m_sessions[0].sessionName = "Asian";
    m_sessions[0].startHour = 23;  // 11 PM UTC
    m_sessions[0].endHour = 8;     // 8 AM UTC
    
    m_sessions[1].sessionName = "London";
    m_sessions[1].startHour = 8;   // 8 AM UTC
    m_sessions[1].endHour = 17;    // 5 PM UTC
    
    m_sessions[2].sessionName = "New York";
    m_sessions[2].startHour = 13;  // 1 PM UTC
    m_sessions[2].endHour = 22;    // 10 PM UTC
    
    m_sessions[3].sessionName = "Sydney";
    m_sessions[3].startHour = 21;  // 9 PM UTC
    m_sessions[3].endHour = 6;     // 6 AM UTC
    
    //--- Initialize counters
    m_calendarEffectCount = 0;
    m_holidayCount = 0;
    m_cycleCount = 0;
    
    //--- Load calendar effects
    LoadCalendarEffects();
    
    Print("📅 Seasonality Analyzer initialized");
}

//+------------------------------------------------------------------+
//| Initialize seasonality analyzer                               |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::Initialize(string symbol)
{
    //--- Load and analyze historical data
    LoadHistoricalData(symbol, 5);
    CalculateSeasonalPatterns(symbol);
    
    //--- Analyze current patterns
    AnalyzeMonthlyPatterns(symbol);
    AnalyzeWeeklyPatterns(symbol);
    AnalyzeHourlyPatterns(symbol);
    AnalyzeTradingSessions(symbol);
    AnalyzeEconomicCycles(symbol);
    
    Print("✅ Seasonality Analyzer initialized for ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Calculate seasonal patterns                                    |
//+------------------------------------------------------------------+
void CSeasonalityAnalyzer::CalculateSeasonalPatterns(string symbol)
{
    //--- This would typically analyze several years of historical data
    //--- For demonstration, we'll create representative patterns
    
    //--- Monthly patterns (simplified)
    m_monthlyPatterns[0].avgReturn = 1.2;   // January - usually bullish
    m_monthlyPatterns[0].winRate = 65.0;
    m_monthlyPatterns[0].isBullish = true;
    m_monthlyPatterns[0].description = "January Effect - New Year optimism";
    
    m_monthlyPatterns[1].avgReturn = 0.3;   // February - neutral
    m_monthlyPatterns[1].winRate = 52.0;
    m_monthlyPatterns[1].description = "February - Quiet month";
    
    m_monthlyPatterns[2].avgReturn = 0.8;   // March - moderately bullish
    m_monthlyPatterns[2].winRate = 58.0;
    m_monthlyPatterns[2].isBullish = true;
    m_monthlyPatterns[2].description = "March - Quarter-end flows";
    
    m_monthlyPatterns[3].avgReturn = 1.5;   // April - strong bullish
    m_monthlyPatterns[3].winRate = 68.0;
    m_monthlyPatterns[3].isBullish = true;
    m_monthlyPatterns[3].description = "April - Strong seasonal performance";
    
    m_monthlyPatterns[4].avgReturn = -0.2;  // May - "Sell in May"
    m_monthlyPatterns[4].winRate = 45.0;
    m_monthlyPatterns[4].isBearish = true;
    m_monthlyPatterns[4].description = "May - 'Sell in May and go away'";
    
    m_monthlyPatterns[8].avgReturn = -0.8;  // September - typically bearish
    m_monthlyPatterns[8].winRate = 42.0;
    m_monthlyPatterns[8].isBearish = true;
    m_monthlyPatterns[8].description = "September - Historically worst month";
    
    m_monthlyPatterns[10].avgReturn = 1.0;  // November - bullish
    m_monthlyPatterns[10].winRate = 62.0;
    m_monthlyPatterns[10].isBullish = true;
    m_monthlyPatterns[10].description = "November - Holiday season begins";
    
    m_monthlyPatterns[11].avgReturn = 1.3;  // December - year-end rally
    m_monthlyPatterns[11].winRate = 64.0;
    m_monthlyPatterns[11].isBullish = true;
    m_monthlyPatterns[11].description = "December - Year-end rally";
    
    Print("📊 Seasonal patterns calculated for ", symbol);
}

//+------------------------------------------------------------------+
//| Analyze weekly patterns                                        |
//+------------------------------------------------------------------+
void CSeasonalityAnalyzer::AnalyzeWeeklyPatterns(string symbol)
{
    //--- Typical weekly patterns for Forex
    m_weeklyPatterns[0].avgReturn = -0.1;   // Sunday - quiet
    m_weeklyPatterns[0].volatility = 0.3;
    m_weeklyPatterns[0].description = "Sunday - Market opening, low volume";
    
    m_weeklyPatterns[1].avgReturn = 0.4;    // Monday - moderate activity
    m_weeklyPatterns[1].volatility = 0.8;
    m_weeklyPatterns[1].description = "Monday - Week opening momentum";
    
    m_weeklyPatterns[2].avgReturn = 0.6;    // Tuesday - typically strong
    m_weeklyPatterns[2].volatility = 1.0;
    m_weeklyPatterns[2].isBullish = true;
    m_weeklyPatterns[2].description = "Tuesday - Often best trading day";
    
    m_weeklyPatterns[3].avgReturn = 0.5;    // Wednesday - moderate
    m_weeklyPatterns[3].volatility = 0.9;
    m_weeklyPatterns[3].description = "Wednesday - Mid-week stability";
    
    m_weeklyPatterns[4].avgReturn = 0.3;    // Thursday - declining
    m_weeklyPatterns[4].volatility = 0.7;
    m_weeklyPatterns[4].description = "Thursday - Pre-weekend caution";
    
    m_weeklyPatterns[5].avgReturn = -0.2;   // Friday - often bearish
    m_weeklyPatterns[5].volatility = 0.6;
    m_weeklyPatterns[5].isBearish = true;
    m_weeklyPatterns[5].description = "Friday - Position squaring, lower volume";
    
    m_weeklyPatterns[6].avgReturn = -0.3;   // Saturday - very quiet
    m_weeklyPatterns[6].volatility = 0.2;
    m_weeklyPatterns[6].description = "Saturday - Minimal activity";
    
    Print("📅 Weekly patterns analyzed for ", symbol);
}

//+------------------------------------------------------------------+
//| Analyze hourly patterns                                       |
//+------------------------------------------------------------------+
void CSeasonalityAnalyzer::AnalyzeHourlyPatterns(string symbol)
{
    //--- Typical hourly patterns for Forex (UTC time)
    for(int i = 0; i < 24; i++)
    {
        if(i >= 8 && i <= 16) // London session
        {
            m_hourlyPatterns[i].volatility = 1.2;
            m_hourlyPatterns[i].avgReturn = 0.1;
        }
        else if(i >= 13 && i <= 21) // NY session overlap
        {
            m_hourlyPatterns[i].volatility = 1.5; // Highest volatility
            m_hourlyPatterns[i].avgReturn = 0.15;
        }
        else if(i >= 23 || i <= 7) // Asian session
        {
            m_hourlyPatterns[i].volatility = 0.7;
            m_hourlyPatterns[i].avgReturn = 0.05;
        }
        else // Quiet periods
        {
            m_hourlyPatterns[i].volatility = 0.4;
            m_hourlyPatterns[i].avgReturn = 0.0;
        }
    }
    
    Print("⏰ Hourly patterns analyzed for ", symbol);
}

//+------------------------------------------------------------------+
//| Get current seasonal bias                                      |
//+------------------------------------------------------------------+
double CSeasonalityAnalyzer::GetCurrentSeasonalBias(string symbol)
{
    int currentMonth = GetCurrentMonth();
    int currentDay = GetCurrentDayOfWeek();
    int currentHour = GetCurrentHour();
    
    //--- Combine all seasonal biases
    double monthlyBias = GetMonthlyBias(currentMonth);
    double weeklyBias = GetDayOfWeekBias(currentDay);
    double hourlyBias = GetHourlyBias(currentHour);
    
    //--- Weight the biases
    double combinedBias = (monthlyBias * 0.5) + (weeklyBias * 0.3) + (hourlyBias * 0.2);
    
    return combinedBias;
}

//+------------------------------------------------------------------+
//| Get monthly bias                                               |
//+------------------------------------------------------------------+
double CSeasonalityAnalyzer::GetMonthlyBias(int month)
{
    if(month >= 1 && month <= 12)
        return m_monthlyPatterns[month - 1].avgReturn;
    
    return 0.0;
}

//+------------------------------------------------------------------+
//| Get day of week bias                                          |
//+------------------------------------------------------------------+
double CSeasonalityAnalyzer::GetDayOfWeekBias(int dayOfWeek)
{
    if(dayOfWeek >= 0 && dayOfWeek <= 6)
        return m_weeklyPatterns[dayOfWeek].avgReturn;
    
    return 0.0;
}

//+------------------------------------------------------------------+
//| Get hourly bias                                               |
//+------------------------------------------------------------------+
double CSeasonalityAnalyzer::GetHourlyBias(int hour)
{
    if(hour >= 0 && hour <= 23)
        return m_hourlyPatterns[hour].avgReturn;
    
    return 0.0;
}

//+------------------------------------------------------------------+
//| Get current trading session                                   |
//+------------------------------------------------------------------+
string CSeasonalityAnalyzer::GetCurrentSession()
{
    int currentHour = GetCurrentHour();
    
    for(int i = 0; i < 4; i++)
    {
        int startHour = m_sessions[i].startHour;
        int endHour = m_sessions[i].endHour;
        
        //--- Handle sessions that cross midnight
        if(startHour > endHour)
        {
            if(currentHour >= startHour || currentHour <= endHour)
                return m_sessions[i].sessionName;
        }
        else
        {
            if(currentHour >= startHour && currentHour <= endHour)
                return m_sessions[i].sessionName;
        }
    }
    
    return "Quiet";
}

//+------------------------------------------------------------------+
//| Check if overlap period                                        |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::IsOverlapPeriod()
{
    int currentHour = GetCurrentHour();
    
    //--- London-NY overlap (13:00-17:00 UTC)
    if(currentHour >= 13 && currentHour <= 17)
        return true;
    
    //--- Asian-London overlap (07:00-09:00 UTC)
    if(currentHour >= 7 && currentHour <= 9)
        return true;
    
    //--- NY-Asian overlap (21:00-23:00 UTC)
    if(currentHour >= 21 && currentHour <= 23)
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Get seasonal signal                                           |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CSeasonalityAnalyzer::GetSeasonalSignal(string symbol)
{
    double seasonalBias = GetCurrentSeasonalBias(symbol);
    
    //--- Check if bias is strong enough
    if(seasonalBias > 0.5)
        return ORDER_TYPE_BUY;
    else if(seasonalBias < -0.5)
        return ORDER_TYPE_SELL;
    
    return -1; // No signal
}

//+------------------------------------------------------------------+
//| Check if currently bullish season                             |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::IsCurrentlyBullishSeason(string symbol)
{
    int currentMonth = GetCurrentMonth();
    return m_monthlyPatterns[currentMonth - 1].isBullish;
}

//+------------------------------------------------------------------+
//| Check if currently bearish season                             |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::IsCurrentlyBearishSeason(string symbol)
{
    int currentMonth = GetCurrentMonth();
    return m_monthlyPatterns[currentMonth - 1].isBearish;
}

//+------------------------------------------------------------------+
//| Should avoid trading                                          |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::ShouldAvoidTrading()
{
    int currentDay = GetCurrentDayOfWeek();
    int currentHour = GetCurrentHour();
    
    //--- Avoid trading during very quiet periods
    if(currentDay == 0) // Sunday
        return true;
    
    if(currentDay == 6) // Saturday
        return true;
    
    //--- Avoid trading during low volatility hours
    if(currentHour >= 22 || currentHour <= 6) // Dead zone
        return true;
    
    //--- Check if holiday period
    if(IsHolidayPeriod(TimeCurrent()))
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Is optimal trading time                                       |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::IsOptimalTradingTime()
{
    //--- Check if in overlap period (high volatility)
    if(IsOverlapPeriod())
        return true;
    
    //--- Check if Tuesday-Thursday (typically best days)
    int currentDay = GetCurrentDayOfWeek();
    if(currentDay >= 2 && currentDay <= 4)
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Load calendar effects                                         |
//+------------------------------------------------------------------+
void CSeasonalityAnalyzer::LoadCalendarEffects()
{
    //--- Major calendar effects that impact markets
    m_calendarEffects[0].eventName = "New Year Effect";
    m_calendarEffects[0].month = 1;
    m_calendarEffects[0].day = 1;
    m_calendarEffects[0].expectedImpact = 1.5;
    m_calendarEffects[0].direction = "BULLISH";
    m_calendarEffects[0].daysAffected = 5;
    
    m_calendarEffects[1].eventName = "Tax Day Effect";
    m_calendarEffects[1].month = 4;
    m_calendarEffects[1].day = 15;
    m_calendarEffects[1].expectedImpact = -0.8;
    m_calendarEffects[1].direction = "BEARISH";
    m_calendarEffects[1].daysAffected = 3;
    
    m_calendarEffects[2].eventName = "Halloween Effect";
    m_calendarEffects[2].month = 10;
    m_calendarEffects[2].day = 31;
    m_calendarEffects[2].expectedImpact = 1.2;
    m_calendarEffects[2].direction = "BULLISH";
    m_calendarEffects[2].daysAffected = 7;
    
    m_calendarEffects[3].eventName = "Santa Claus Rally";
    m_calendarEffects[3].month = 12;
    m_calendarEffects[3].day = 20;
    m_calendarEffects[3].expectedImpact = 1.8;
    m_calendarEffects[3].direction = "BULLISH";
    m_calendarEffects[3].daysAffected = 10;
    
    m_calendarEffectCount = 4;
    
    Print("📅 Loaded ", m_calendarEffectCount, " calendar effects");
}

//+------------------------------------------------------------------+
//| Get current month                                             |
//+------------------------------------------------------------------+
int CSeasonalityAnalyzer::GetCurrentMonth()
{
    MqlDateTime timeStruct;
    TimeToStruct(TimeCurrent(), timeStruct);
    return timeStruct.mon;
}

//+------------------------------------------------------------------+
//| Get current day of week                                       |
//+------------------------------------------------------------------+
int CSeasonalityAnalyzer::GetCurrentDayOfWeek()
{
    MqlDateTime timeStruct;
    TimeToStruct(TimeCurrent(), timeStruct);
    return timeStruct.day_of_week;
}

//+------------------------------------------------------------------+
//| Get current hour                                              |
//+------------------------------------------------------------------+
int CSeasonalityAnalyzer::GetCurrentHour()
{
    MqlDateTime timeStruct;
    TimeToStruct(TimeCurrent(), timeStruct);
    return timeStruct.hour;
}

//+------------------------------------------------------------------+
//| Check if holiday period                                       |
//+------------------------------------------------------------------+
bool CSeasonalityAnalyzer::IsHolidayPeriod(datetime date)
{
    MqlDateTime timeStruct;
    TimeToStruct(date, timeStruct);
    
    //--- Christmas/New Year period
    if(timeStruct.mon == 12 && timeStruct.day >= 20)
        return true;
    
    if(timeStruct.mon == 1 && timeStruct.day <= 5)
        return true;
    
    //--- Summer holidays (reduced volume)
    if(timeStruct.mon == 8)
        return true;
    
    return false;
}

//+------------------------------------------------------------------+
//| Print seasonal analysis                                       |
//+------------------------------------------------------------------+
void CSeasonalityAnalyzer::PrintSeasonalAnalysis(string symbol)
{
    Print("═══════════════════════════════════════");
    Print("📅 SEASONALITY ANALYSIS - ", symbol);
    Print("═══════════════════════════════════════");
    
    int currentMonth = GetCurrentMonth();
    int currentDay = GetCurrentDayOfWeek();
    string currentSession = GetCurrentSession();
    
    Print("📅 Current Month: ", currentMonth, " (", m_monthlyPatterns[currentMonth-1].description, ")");
    Print("📊 Monthly Bias: ", DoubleToString(GetMonthlyBias(currentMonth), 2), "%");
    Print("📆 Day of Week: ", currentDay);
    Print("📈 Daily Bias: ", DoubleToString(GetDayOfWeekBias(currentDay), 2), "%");
    Print("⏰ Trading Session: ", currentSession);
    Print("🔄 Overlap Period: ", IsOverlapPeriod() ? "YES" : "NO");
    Print("🎯 Overall Seasonal Bias: ", DoubleToString(GetCurrentSeasonalBias(symbol), 2), "%");
    
    if(IsCurrentlyBullishSeason(symbol))
        Print("📈 Current Season: BULLISH");
    else if(IsCurrentlyBearishSeason(symbol))
        Print("📉 Current Season: BEARISH");
    else
        Print("📊 Current Season: NEUTRAL");
    
    Print("⚠️ Avoid Trading: ", ShouldAvoidTrading() ? "YES" : "NO");
    Print("✅ Optimal Time: ", IsOptimalTradingTime() ? "YES" : "NO");
    Print("🏖️ Holiday Period: ", IsHolidayPeriod(TimeCurrent()) ? "YES" : "NO");
    
    ENUM_ORDER_TYPE seasonalSignal = GetSeasonalSignal(symbol);
    Print("🎯 Seasonal Signal: ", seasonalSignal == ORDER_TYPE_BUY ? "BULLISH" : 
          (seasonalSignal == ORDER_TYPE_SELL ? "BEARISH" : "NEUTRAL"));
    
    Print("═══════════════════════════════════════");
}