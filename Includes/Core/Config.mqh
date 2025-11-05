//+------------------------------------------------------------------+
//|                                                       Config.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#ifndef CONFIG_MQH
#define CONFIG_MQH

//+------------------------------------------------------------------+
//| Signal type enumeration                                         |
//+------------------------------------------------------------------+
// Signal type enum
enum ENUM_SIGNAL_TYPE
{
    SIGNAL_NONE           = 0, // No signal
    SIGNAL_BUY            = 1, // Buy signal
    SIGNAL_SELL           = 2, // Sell signal
    SIGNAL_BUY_ENTRY      = 3, // Buy entry signal
    SIGNAL_SELL_ENTRY     = 4, // Sell entry signal
    SIGNAL_BUY_EXIT       = 5, // Buy exit signal
    SIGNAL_SELL_EXIT      = 6, // Sell exit signal
    SIGNAL_HOLD           = 7, // Hold current position
    SIGNAL_REDUCE         = 8  // Reduce position size
};

//+------------------------------------------------------------------+
//| Enumerations for configuration                                  |
//+------------------------------------------------------------------+
enum ENUM_LOG_LEVEL
{
    LOG_LEVEL_NONE,     // No logging
    LOG_LEVEL_ERROR,    // Error messages only
    LOG_LEVEL_WARNING,  // Warnings and errors
    LOG_LEVEL_INFO,     // Info, warnings, and errors
    LOG_LEVEL_DEBUG,    // All messages including debug
    LOG_LEVEL_VERBOSE   // Extremely detailed logging
};

enum ENUM_TRADING_MODE
{
    TRADING_MODE_CONSERVATIVE, // Conservative risk settings
    TRADING_MODE_BALANCED,     // Balanced risk/reward
    TRADING_MODE_AGGRESSIVE,   // Aggressive trading
    TRADING_MODE_CUSTOM        // Custom user-defined settings
};

enum ENUM_EA_STATE
{
    EA_STATE_INIT,        // Initializing
    EA_STATE_RUNNING,     // Normal operation
    EA_STATE_PAUSED,      // Temporarily paused
    EA_STATE_EMERGENCY,   // Emergency stop mode
    EA_STATE_MAINTENANCE, // Maintenance mode
    EA_STATE_ERROR        // Error state
};

//+------------------------------------------------------------------+
//| Configuration structures                                         |
//+------------------------------------------------------------------+
struct SProfileConfig
{
    string            name;
    ENUM_TRADING_MODE mode;
    double            riskPercent;
    int               maxTrades;
    double            atrMultiplier;
    double            correlationThreshold;
    bool              enableML;
    bool              enableNews;
    bool              enableSession;
};

struct SPerformanceMetrics
{
    int               totalTrades;
    int               profitableTrades;
    double            totalProfit;
    double            maxDrawdown;
    double            sharpeRatio;
    double            winRate;
    datetime          lastUpdate;
};

//+------------------------------------------------------------------+
//| Advanced Configuration manager class                            |
//| Handles all EA configuration, profiles, and global settings     |
//+------------------------------------------------------------------+
class CConfig
{
private:
    // Core settings
    static string        m_tradingPairs[];
    static int           m_maxConcurrentPairs;
    static int           m_orderBlockLookback;
    static double        m_minOrderBlockSize;
    static int           m_orderBlockConfirmation;
    static int           m_timerInterval;
    static ENUM_LOG_LEVEL m_logLevel;
    
    // Advanced settings
    static ENUM_EA_STATE m_eaState;
    static ENUM_TRADING_MODE m_tradingMode;
    static SProfileConfig m_profiles[];
    static string        m_activeProfile;
    static bool          m_autoOptimization;
    static bool          m_cloudSyncEnabled;
    
    // Performance tracking
    static SPerformanceMetrics m_performance;
    static datetime      m_startTime;
    static string        m_logFilePath;
    
    // Market condition settings
    static double        m_maxSpreadPips;
    static double        m_minLiquidity;
    static bool          m_avoidNews;
    static int           m_newsBufferMinutes;
    
    // ML and AI settings
    static bool          m_enableML;
    static string        m_mlModelPath;
    static double        m_mlConfidenceThreshold;
    static bool          m_enableSentimentAnalysis;
    
public:
    //--- Initialization and configuration
    static bool Initialize(string pairs, int maxPairs, int lookback, double minSize, 
                          int confirmation, int timer, ENUM_LOG_LEVEL logLevel = LOG_LEVEL_INFO);
    static bool InitializeAdvanced(const SProfileConfig &profile);
    static bool LoadConfiguration(const string filePath);
    static bool SaveConfiguration(const string filePath);
    
    //--- Profile management
    static bool CreateProfile(const SProfileConfig &profile);
    static bool LoadProfile(const string profileName);
    static bool SaveProfile(const string profileName);
    static void GetAvailableProfiles(string &profiles[]);
    static SProfileConfig GetCurrentProfile();
    
    //--- Core getters
    static void GetTradingPairs(string &pairs[])
    {
        if(ArraySize(m_tradingPairs) > 0)
        {
            int size = MathMin(ArraySize(m_tradingPairs), ArraySize(pairs));
            if(size > 0)
                ArrayCopy(pairs, m_tradingPairs, 0, 0, size);
        }
    }
    static int GetMaxConcurrentPairs() { return m_maxConcurrentPairs; }
    static int GetOrderBlockLookback() { return m_orderBlockLookback; }
    static double GetMinOrderBlockSize() { return m_minOrderBlockSize; }
    static int GetOrderBlockConfirmation() { return m_orderBlockConfirmation; }
    static int GetTimerInterval() { return m_timerInterval; }
    static ENUM_LOG_LEVEL GetLogLevel() { return m_logLevel; }
    
    //--- Advanced getters
    static ENUM_EA_STATE GetEAState() { return m_eaState; }
    static ENUM_TRADING_MODE GetTradingMode() { return m_tradingMode; }
    static string GetActiveProfile() { return m_activeProfile; }
    static bool IsAutoOptimizationEnabled() { return m_autoOptimization; }
    static bool IsCloudSyncEnabled() { return m_cloudSyncEnabled; }
    
    //--- Market condition getters
    static double GetMaxSpreadPips() { return m_maxSpreadPips; }
    static double GetMinLiquidity() { return m_minLiquidity; }
    static bool IsNewsAvoidanceEnabled() { return m_avoidNews; }
    static int GetNewsBufferMinutes() { return m_newsBufferMinutes; }
    
    //--- ML and AI getters
    static bool IsMLEnabled() { return m_enableML; }
    static string GetMLModelPath() { return m_mlModelPath; }
    static double GetMLConfidenceThreshold() { return m_mlConfidenceThreshold; }
    static bool IsSentimentAnalysisEnabled() { return m_enableSentimentAnalysis; }
    
    //--- State management
    static void SetEAState(ENUM_EA_STATE state);
    static void SetTradingMode(ENUM_TRADING_MODE mode);
    static void EnableEmergencyMode(const string reason);
    static void DisableEmergencyMode();
    static bool IsEmergencyMode() { return m_eaState == EA_STATE_EMERGENCY; }
    
    //--- Performance tracking
    static void UpdatePerformanceMetrics(int trades, int profitable, double profit, double drawdown);
    static SPerformanceMetrics GetPerformanceMetrics() { return m_performance; }
    static void ResetPerformanceMetrics();
    static double GetSharpeRatio();
    static double GetWinRate();
    
    //--- Enhanced utility functions
    static double PointToPips(const string symbol, double points);
    static double PipsToPoints(const string symbol, double pips);
    static bool IsValidSymbol(const string symbol);
    static bool IsMarketOpen(const string symbol);
    static double GetSpreadPips(const string symbol);
    static bool IsSpreadAcceptable(const string symbol);
    
    //--- Advanced logging functions
    static void LogInfo(const string message);
    static void LogError(const string message);
    static void LogDebug(const string message);
    static void LogWarning(const string message);
    static void LogVerbose(const string message);
    static void LogTrade(const string symbol, const string action, double volume, double price);
    static void LogPerformance();
    
    //--- File and data management
    static bool ExportSettings(const string fileName);
    static bool ImportSettings(const string fileName);
    static void BackupConfiguration();
    static string GetLogFilePath() { return m_logFilePath; }
    
    //--- Market data validation
    static bool ValidateMarketData(const string symbol);
    static bool CheckConnectionStatus();
    static bool ValidateTradingConditions();
    
private:
    //--- Internal helper methods
    static bool ParseTradingPairs(const string pairsString);
    static void InitializeDefaults();
    static void InitializePerformanceMetrics();
    static void WriteToLogFile(const string level, const string message);
    static string GetTimeStamp();
    static bool CreateLogFile();
    static void ValidateConfiguration();
};

//--- Enhanced static member definitions
string CConfig::m_tradingPairs[];
int CConfig::m_maxConcurrentPairs = 3;
int CConfig::m_orderBlockLookback = 50;
double CConfig::m_minOrderBlockSize = 10.0;
int CConfig::m_orderBlockConfirmation = 3;
int CConfig::m_timerInterval = 5;
ENUM_LOG_LEVEL CConfig::m_logLevel = LOG_LEVEL_INFO;

ENUM_EA_STATE CConfig::m_eaState = EA_STATE_INIT;
ENUM_TRADING_MODE CConfig::m_tradingMode = TRADING_MODE_BALANCED;
SProfileConfig CConfig::m_profiles[];
string CConfig::m_activeProfile = "Default";
bool CConfig::m_autoOptimization = false;
bool CConfig::m_cloudSyncEnabled = false;

SPerformanceMetrics CConfig::m_performance;
datetime CConfig::m_startTime = 0;
string CConfig::m_logFilePath = "";

double CConfig::m_maxSpreadPips = 5.0;
double CConfig::m_minLiquidity = 1000000.0;
bool CConfig::m_avoidNews = true;
int CConfig::m_newsBufferMinutes = 30;

bool CConfig::m_enableML = false;
string CConfig::m_mlModelPath = "";
double CConfig::m_mlConfidenceThreshold = 0.7;
bool CConfig::m_enableSentimentAnalysis = false;

//+------------------------------------------------------------------+
//| Enhanced initialization with advanced features                  |
//+------------------------------------------------------------------+
bool CConfig::Initialize(string pairs, int maxPairs, int lookback, double minSize, 
                        int confirmation, int timer, ENUM_LOG_LEVEL logLevel = LOG_LEVEL_INFO)
{
    //--- Initialize defaults first
    InitializeDefaults();
    
    //--- Set configuration values
    m_maxConcurrentPairs = maxPairs;
    m_orderBlockLookback = lookback;
    m_minOrderBlockSize = minSize;
    m_orderBlockConfirmation = confirmation;
    m_timerInterval = timer;
    m_logLevel = logLevel;
    m_startTime = TimeCurrent();
    
    //--- Create log file
    if(!CreateLogFile())
    {
        Print("[ERROR] Failed to create log file");
    }
    
    //--- Parse trading pairs
    if(!ParseTradingPairs(pairs))
    {
        LogError("Failed to parse trading pairs: " + pairs);
        return false;
    }
    
    //--- Initialize performance metrics
    InitializePerformanceMetrics();
    
    //--- Validate configuration
    ValidateConfiguration();
    
    //--- Set EA state to running
    SetEAState(EA_STATE_RUNNING);
    
    LogInfo(StringFormat("MetaphizixEA Configuration initialized - Pairs: %d, Max concurrent: %d, Mode: %s", 
                        ArraySize(m_tradingPairs), m_maxConcurrentPairs, EnumToString(m_tradingMode)));
    
    return true;
}

//+------------------------------------------------------------------+
//| Initialize with advanced profile configuration                  |
//+------------------------------------------------------------------+
bool CConfig::InitializeAdvanced(const SProfileConfig &profile)
{
    //--- Load profile settings
    m_tradingMode = profile.mode;
    m_activeProfile = profile.name;
    m_enableML = profile.enableML;
    m_avoidNews = profile.enableNews;
    
    //--- Apply profile-specific settings
    switch(profile.mode)
    {
        case TRADING_MODE_CONSERVATIVE:
            m_maxSpreadPips = 3.0;
            m_mlConfidenceThreshold = 0.8;
            break;
            
        case TRADING_MODE_AGGRESSIVE:
            m_maxSpreadPips = 8.0;
            m_mlConfidenceThreshold = 0.6;
            break;
            
        default:
            m_maxSpreadPips = 5.0;
            m_mlConfidenceThreshold = 0.7;
            break;
    }
    
    LogInfo(StringFormat("Advanced configuration loaded - Profile: %s, Mode: %s", 
                        profile.name, EnumToString(profile.mode)));
    
    return true;
}

//+------------------------------------------------------------------+
//| Set EA state with logging                                       |
//+------------------------------------------------------------------+
void CConfig::SetEAState(ENUM_EA_STATE state)
{
    ENUM_EA_STATE oldState = m_eaState;
    m_eaState = state;
    
    LogInfo(StringFormat("EA State changed from %s to %s", 
                        EnumToString(oldState), EnumToString(state)));
}

//+------------------------------------------------------------------+
//| Enable emergency mode                                           |
//+------------------------------------------------------------------+
void CConfig::EnableEmergencyMode(const string reason)
{
    SetEAState(EA_STATE_EMERGENCY);
    LogError(StringFormat("EMERGENCY MODE ACTIVATED: %s", reason));
    
    // Additional emergency actions can be added here
    // such as closing all positions, disabling new trades, etc.
}

//+------------------------------------------------------------------+
//| Disable emergency mode                                          |
//+------------------------------------------------------------------+
void CConfig::DisableEmergencyMode()
{
    if(m_eaState == EA_STATE_EMERGENCY)
    {
        SetEAState(EA_STATE_RUNNING);
        LogInfo("Emergency mode deactivated - returning to normal operation");
    }
}

//+------------------------------------------------------------------+
//| Parse trading pairs string                                       |
//+------------------------------------------------------------------+
bool CConfig::ParseTradingPairs(string pairsString)
{
    ArrayResize(m_tradingPairs, 0);
    
    string pairs[];
    int count = StringSplit(pairsString, ',', pairs);
    
    for(int i = 0; i < count; i++)
    {
        string pair = pairs[i];
        StringTrimLeft(pair);
        StringTrimRight(pair);
        StringToUpper(pair);
        
        if(StringLen(pair) >= 6 && IsValidSymbol(pair))
        {
            ArrayResize(m_tradingPairs, ArraySize(m_tradingPairs) + 1);
            m_tradingPairs[ArraySize(m_tradingPairs) - 1] = pair;
        }
        else
        {
            LogError("Invalid trading pair: " + pair);
        }
    }
    
    return ArraySize(m_tradingPairs) > 0;
}

//+------------------------------------------------------------------+
//| Convert points to pips                                           |
//+------------------------------------------------------------------+
double CConfig::PointToPips(string symbol, double points)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    if(digits == 2 || digits == 3)
        return points;
    else if(digits == 4 || digits == 5)
        return points / 10.0;
    
    return points;
}

//+------------------------------------------------------------------+
//| Convert pips to points                                           |
//+------------------------------------------------------------------+
double CConfig::PipsToPoints(string symbol, double pips)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    
    if(digits == 2 || digits == 3)
        return pips;
    else if(digits == 4 || digits == 5)
        return pips * 10.0;
    
    return pips;
}

//+------------------------------------------------------------------+
//| Check if symbol is valid                                         |
//+------------------------------------------------------------------+
bool CConfig::IsValidSymbol(string symbol)
{
    return SymbolSelect(symbol, true);
}

//+------------------------------------------------------------------+
//| Log information message                                          |
//+------------------------------------------------------------------+
void CConfig::LogInfo(string message)
{
    Print("[INFO] ", message);
}

//+------------------------------------------------------------------+
//| Log error message                                                |
//+------------------------------------------------------------------+
void CConfig::LogError(string message)
{
    Print("[ERROR] ", message);
}

//+------------------------------------------------------------------+
//| Log debug message                                                |
//+------------------------------------------------------------------+
void CConfig::LogDebug(string message)
{
    if(m_logLevel >= LOG_LEVEL_DEBUG)
        Print("[DEBUG] ", message);
}


#endif // CONFIG_MQH

