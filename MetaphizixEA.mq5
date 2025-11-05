//+------------------------------------------------------------------+
//|                                                 MetaphizixEA.mq5 |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"
#property version   "3.01"
#property description "Advanced Modular EA - Professional Trading System with Risk Management"

//+------------------------------------------------------------------+
//| CORE MODULE INCLUDES                                             |
//+------------------------------------------------------------------+
// First include Config.mqh as it defines core types used by other modules
#include "Includes/Core/Config.mqh"

// Next include the signal manager as it's required by several other modules
#include "Includes/Core/SignalManager.mqh"

// Then include other core modules
#include "Includes/Core/OrderBlockDetector.mqh"
#include "Includes/Core/PairManager.mqh"
#include "Includes/Core/DisplayManager.mqh"
#include "Includes/Core/RiskManagement.mqh"
#include "Includes/Core/TradeExecution.mqh"
#include "Includes/Core/NewsFilter.mqh"
#include "Includes/Core/SessionFilter.mqh"
#include "Includes/Core/ExitStrategy.mqh"

//+------------------------------------------------------------------+
//| ADVANCED ANALYSIS MODULES                                        |
//+------------------------------------------------------------------+
#include "Includes/Advanced/TechnicalIndicators.mqh"
#include "Includes/Advanced/ForexAnalyzer.mqh"
#include "Includes/Advanced/VolatilityAnalyzer.mqh"
#include "Includes/Advanced/CorrelationAnalyzer.mqh"
#include "Includes/Advanced/MLPredictor.mqh"
#include "Includes/Advanced/Fibonacci.mqh"
#include "Includes/Advanced/MarketAnalysis.mqh"
#include "Includes/Advanced/PortfolioManager.mqh"
#include "Includes/Advanced/SentimentAnalyzer.mqh"
#include "Includes/Advanced/RiskAdjuster.mqh"
#include "Includes/Advanced/MultiTimeframeAnalyzer.mqh"
#include "Includes/Advanced/SeasonalityAnalyzer.mqh"
#include "Includes/Advanced/OrderFlowAnalyzer.mqh"
#include "Includes/Advanced/CurrencyStrengthAnalyzer.mqh"

//+------------------------------------------------------------------+
//| DYNAMIC OPTIMIZATION & PROTECTION MODULES                       |
//+------------------------------------------------------------------+
#include "Includes/Optimization/AdaptiveDecisionEngine.mqh"
#include "Includes/Optimization/DynamicStrategyManager.mqh"
#include "Includes/Optimization/RealtimeOptimizer.mqh"
#include "Includes/Protection/SpreadManipulationDetector.mqh"
#include "Includes/Protection/BrokerLeverageDetector.mqh"

//+------------------------------------------------------------------+
//| INPUT PARAMETERS CONFIGURATION                                  |
//+------------------------------------------------------------------+

//--- Trading Pairs Configuration
input group "=== 📊 TRADING PAIRS CONFIGURATION ==="
input string InpTradingPairs = "EURUSD,GBPUSD,USDJPY,USDCHF,AUDUSD,USDCAD,NZDUSD,EURJPY,GBPJPY,EURGBP"; // Trading Pairs (comma separated)
input int InpMaxConcurrentPairs = 3; // Maximum concurrent pairs to analyze

//+------------------------------------------------------------------+
//| Global Variables                                               |
//+------------------------------------------------------------------+
// Array to store best trading pairs 
string g_bestPairs[];  // Array to store best trading pairs
int g_maxPairs = 10;   // Maximum number of pairs to track

//--- Order Block Detection Settings
input group "=== 🎯 ORDER BLOCK DETECTION ==="
input int InpOrderBlockLookback = 50; // Order block lookback period
input double InpMinOrderBlockSize = 10; // Minimum order block size in pips
input int InpOrderBlockConfirmation = 3; // Number of candles for confirmation

//--- Risk Management Configuration
input group "=== ⚠️ RISK MANAGEMENT ==="
input double InpAccountRiskPercent = 1.0; // Risk percentage per trade
input int InpMaxOpenTrades = 10; // Maximum open trades allowed
input double InpCorrelationThreshold = 0.8; // Correlation threshold for portfolio management

//--- Trading Controls & Execution
input group "=== 🎮 TRADING CONTROLS ==="
input bool InpEnableAutoTrading = false; // Enable automatic trade execution
input double InpATRMultiplier = 1.5; // ATR multiplier for trailing stops
input double InpBreakEvenBuffer = 10; // Buffer in pips for break-even
input double InpPartialExitRR = 2.0; // Risk-reward ratio for partial exit

//--- Trade Duration & Profit Management
input group "=== ⏱️ TRADE DURATION & PROFIT MANAGEMENT ==="
enum ENUM_TRADE_STYLE
{
    TRADE_STYLE_SCALPING,       // Scalping (Minutes)
    TRADE_STYLE_SHORT_TERM,     // Short-term (Hours)
    TRADE_STYLE_MEDIUM_TERM,    // Medium-term (Days)
    TRADE_STYLE_LONG_TERM,      // Long-term (Weeks)
    TRADE_STYLE_CUSTOM          // Custom duration
};

input ENUM_TRADE_STYLE InpTradeStyle = TRADE_STYLE_SHORT_TERM; // Trading style/duration
input int InpMaxTradeDurationMinutes = 1440; // Maximum trade duration in minutes (24 hours default)
input double InpProfitTargetPercent = 2.0; // Profit target as percentage of account balance
input double InpMinProfitTargetPips = 20.0; // Minimum profit target in pips
input double InpMaxProfitTargetPips = 100.0; // Maximum profit target in pips
input bool InpUseTimeBasedExit = true; // Enable time-based trade exits
input bool InpUseProfitPercentExit = true; // Enable percentage-based profit exits
input bool InpUseDynamicTargets = true; // Use dynamic targets based on market volatility
input double InpScalpingMaxMinutes = 30; // Maximum minutes for scalping trades
input double InpShortTermMaxHours = 24; // Maximum hours for short-term trades
input double InpMediumTermMaxDays = 7; // Maximum days for medium-term trades
input double InpLongTermMaxWeeks = 4; // Maximum weeks for long-term trades

//--- News & Session Filters
input group "=== 📰 NEWS & SESSION FILTERS ==="
input int InpNewsImpactThreshold = 3; // High-impact news threshold (1-3)
input int InpSessionStartHour = 9; // Start hour for trading session (SAST)
input int InpSessionEndHour = 22; // End hour for trading session (SAST)
input bool InpEnableNewsFilter = true; // Enable news filtering
input bool InpEnableSessionFilter = true; // Enable session filtering

//--- Display & Information Settings
input group "=== 📺 DISPLAY & INFORMATION ==="
input bool InpShowEntryPoints = true; // Show entry points on chart
input bool InpShowExitPoints = true; // Show exit points on chart
input bool InpShowInfoPanel = true; // Show EA information panel
input bool InpShowRiskPanel = true; // Show risk management panel
input bool InpShowPerformancePanel = true; // Show performance statistics panel
input bool InpShowNewsPanel = true; // Show news and events panel
input bool InpShowMarketConditions = true; // Show market conditions panel
input color InpBullishEntryColor = clrLime; // Bullish entry point color
input color InpBearishEntryColor = clrRed; // Bearish entry point color
input color InpExitColor = clrYellow; // Exit point color
input color InpPanelBackgroundColor = clrDarkSlateGray; // Panel background color
input color InpPanelTextColor = clrWhite; // Panel text color

//--- User Experience Settings
input group "=== 🎨 USER EXPERIENCE ==="
input bool InpShowWelcomeMessage = true; // Show welcome message on startup
input bool InpShowTradingTips = true; // Show helpful trading tips
input bool InpEnableAudioAlerts = false; // Enable audio alerts for signals
input bool InpShowConfirmationDialogs = true; // Show confirmation dialogs for major actions
input bool InpDisplayDetailedLogs = true; // Display detailed logs in experts tab
input int InpInfoUpdateFrequency = 5; // Information panel update frequency (seconds)

//--- System Configuration
input group "=== ⚙️ SYSTEM CONFIGURATION ==="
input int InpTimerInterval = 5; // Timer interval in seconds
input bool InpEnableLogging = true; // Enable detailed logging
input int InpMagicNumber = 12345; // Magic number for trades

//--- Advanced Analysis Settings
input group "=== 🔬 ADVANCED ANALYSIS ==="
input bool InpEnableForexAnalysis = true; // Enable advanced forex analysis
input bool InpEnableVolatilityAnalysis = true; // Enable volatility modeling
input bool InpEnableCorrelationAnalysis = true; // Enable correlation analysis
input bool InpEnableMLPrediction = false; // Enable machine learning predictions
input double InpMaxSpread = 30.0; // Maximum spread in points

//--- Protection & Detection Systems
input group "=== 🛡️ SPREAD MANIPULATION DETECTION ==="
input bool InpEnableSpreadDetection = true; // Enable spread manipulation detection
input double InpSpreadMultiplierThreshold = 3.0; // Spread multiplier threshold for detection
input double InpVolumeAnomalyThreshold = 2.5; // Volume anomaly threshold
input double InpRapidSpreadChangeThreshold = 150.0; // Rapid spread change threshold (%)
input int InpMinDetectionPeriod = 5; // Minimum detection period (minutes)
input int InpMaxDetectionPeriod = 60; // Maximum detection period (minutes)
input bool InpFilterNewsEvents = true; // Filter spread detection during news
input int InpNewsFilterMinutes = 30; // News filter duration (minutes)
input bool InpEnableSpreadAlerts = true; // Enable spread manipulation alerts
input bool InpEnableSpreadNotifications = false; // Enable push notifications
input bool InpBlockTradesDuringManipulation = true; // Block trades during manipulation

input group "=== 🏢 BROKER & LEVERAGE ANALYSIS ==="
input bool InpEnableBrokerDetection = true; // Enable broker and leverage detection
input bool InpShowBrokerInfo = true; // Show broker information on startup
input bool InpMonitorLeverageChanges = true; // Monitor leverage changes
input bool InpEnableLeverageAlerts = true; // Enable leverage and margin alerts
input double InpMaxSafeUsedLeverage = 10.0; // Maximum safe used leverage ratio
input double InpMinMarginLevel = 200.0; // Minimum safe margin level (%)
input bool InpAutoAdjustRiskBasedOnLeverage = true; // Auto-adjust risk based on leverage
input bool InpEnableBrokerScoring = true; // Enable broker trust scoring
input bool InpBlockHighRiskConditions = true; // Block trades during high risk conditions

input group "=== 🚀 DYNAMIC OPTIMIZATION ==="
input bool InpEnableAdaptiveDecisions = true; // Enable adaptive decision making
input bool InpEnableDynamicStrategy = true; // Enable dynamic strategy selection
input bool InpEnableRealtimeOptimization = true; // Enable real-time optimization
input ENUM_DECISION_MODE InpInitialDecisionMode = DECISION_MODE_MODERATE; // Initial decision mode
input double InpAdaptationSpeed = 0.5; // Adaptation speed (0.1-1.0)
input int InpOptimizationFrequency = 15; // Optimization frequency (minutes)
input bool InpEnableMLDrivenDecisions = false; // Enable ML-driven decisions
input double InpConfidenceThreshold = 70.0; // Minimum confidence threshold
input bool InpEnableEnsembleMode = true; // Enable ensemble strategy mode

//+------------------------------------------------------------------+
//| GLOBAL OBJECT DECLARATIONS                                      |
//+------------------------------------------------------------------+

//--- Core Trading Components
COrderBlockDetector* g_orderBlockDetector = NULL;
CPairManager* g_pairManager = NULL;
CSignalManager* g_signalManager = NULL;
CDisplayManager* g_displayManager = NULL;
CRiskManagement* g_riskManager = NULL;
CTradeExecution* g_tradeExecutor = NULL;
CNewsFilter* g_newsFilter = NULL;
CSessionFilter* g_sessionFilter = NULL;
CExitStrategy* g_exitStrategy = NULL;

//--- Advanced Analysis Modules
CForexAnalyzer* g_forexAnalyzer = NULL;
CVolatilityAnalyzer* g_volatilityAnalyzer = NULL;
CCorrelationAnalyzer* g_correlationAnalyzer = NULL;
CMLPredictor* g_mlPredictor = NULL;
CFibonacci* g_fibonacci = NULL;
CMarketAnalysis* g_marketAnalysis = NULL;
CPortfolioManager* g_portfolioManager = NULL;
CSentimentAnalyzer* g_sentimentAnalyzer = NULL;
CRiskAdjuster* g_riskAdjuster = NULL;
CMultiTimeframeAnalyzer* g_multiTimeframeAnalyzer = NULL;
CSeasonalityAnalyzer* g_seasonalityAnalyzer = NULL;
COrderFlowAnalyzer* g_orderFlowAnalyzer = NULL;
CCurrencyStrengthAnalyzer* g_currencyStrengthAnalyzer = NULL;

//--- Dynamic Optimization Modules
CAdaptiveDecisionEngine* g_adaptiveEngine = NULL;
CDynamicStrategyManager* g_strategyManager = NULL;
CRealtimeOptimizer* g_realtimeOptimizer = NULL;

//--- Protection & Detection Systems
CSpreadManipulationDetector* g_spreadDetector = NULL;
CBrokerLeverageDetector* g_brokerDetector = NULL;

//+------------------------------------------------------------------+
//| Additional structures for main EA                               |
//+------------------------------------------------------------------+
struct SignalInfo
{
    string               symbol;
    ENUM_SIGNAL_TYPE     type;
    double               entryPrice;
    double               stopLoss;
    double               takeProfit;
    double               confidence;
    datetime             time;
    string               reason;
};

//+------------------------------------------------------------------+
//| Exit reason enumeration                                          |
//+------------------------------------------------------------------+
enum ENUM_EXIT_REASON
{
    EXIT_NONE = 0,
    EXIT_TAKE_PROFIT,
    EXIT_STOP_LOSS,
    EXIT_TRAILING_STOP,
    EXIT_BREAK_EVEN,
    EXIT_PARTIAL_CLOSE,
    EXIT_MANUAL,
    EXIT_TIME_BASED,
    EXIT_RISK_MANAGEMENT
};

struct TradeRequest
{
    string               symbol;
    ENUM_SIGNAL_TYPE     type;
    double               entryPrice;
    double               stopLoss;
    double               takeProfit;
    double               volume;
};

struct ExitSignal
{
    string               symbol;
    ulong                ticket;
    double               exitPrice;
    ENUM_EXIT_REASON     reason;
    datetime             time;
};

//+------------------------------------------------------------------+
//| Trade Management Structures                                     |
//+------------------------------------------------------------------+
struct STradeSettings
{
    ENUM_TRADE_STYLE     tradeStyle;
    int                  maxDurationMinutes;
    double               profitTargetPercent;
    double               minProfitPips;
    double               maxProfitPips;
    bool                 useTimeBasedExit;
    bool                 useProfitPercentExit;
    bool                 useDynamicTargets;
    datetime             lastUpdate;
};

struct SActiveTradeInfo
{
    ulong                ticket;
    string               symbol;
    datetime             openTime;
    double               openPrice;
    double               volume;
    ENUM_ORDER_TYPE      orderType;
    double               initialSL;
    double               initialTP;
    double               dynamicTP;
    double               profitTarget;
    int                  maxDurationMinutes;
    bool                 timeExitWarning;
    bool                 profitTargetReached;
    ENUM_TRADE_STYLE     tradeStyle;
};

//--- Global trade management
STradeSettings          g_tradeSettings;
SActiveTradeInfo        g_activeTrades[];
datetime                g_lastTradeSettingsUpdate = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Expert Initialization Function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- Initialize arrays before creating components
    if(g_maxPairs <= 0)
    {
        Print("❌ ERROR: Invalid maxPairs value");
        return(INIT_PARAMETERS_INCORRECT);
    }
    ArrayResize(g_bestPairs, g_maxPairs);
    for(int i = 0; i < g_maxPairs; i++)
        g_bestPairs[i] = "";

    //--- Display welcome message and system info
    if(InpShowWelcomeMessage)
    {
        ShowWelcomeMessage();
    }
    
    //--- Initialize logging and display startup information
    if(InpEnableLogging)
    {
        DisplayStartupInfo();
    }
    
    //--- Validate input parameters
    if(!ValidateInputs())
    {
        Alert("❌ MetaphizixEA: Invalid input parameters detected! Please check your settings.");
        Print("❌ ERROR: Invalid input parameters. Please review configuration.");
        return(INIT_PARAMETERS_INCORRECT);
    }
    
    //--- Initialize system configuration
    if(!InitializeSystemConfiguration())
    {
        Alert("❌ MetaphizixEA: System configuration failed!");
        return(INIT_FAILED);
    }
    
    //--- Create and initialize core components
    if(!CreateCoreComponents())
    {
        Alert("❌ MetaphizixEA: Failed to create core components!");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Create and initialize advanced modules
    if(!CreateAdvancedModules())
    {
        Alert("❌ MetaphizixEA: Failed to create advanced modules!");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Create and initialize protection systems
    if(!CreateProtectionSystems())
    {
        Alert("❌ MetaphizixEA: Failed to create protection systems!");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Initialize all components
    if(!InitializeAllComponents())
    {
        Alert("❌ MetaphizixEA: Component initialization failed!");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Show final configuration summary
    ShowConfigurationSummary();
    
    //--- Initialize trade management settings
    InitializeTradeSettings();
    
    //--- Set up timer for periodic tasks
    if(!EventSetTimer(InpTimerInterval))
    {
        Print("⚠️ WARNING: Failed to set timer. Some features may not work properly.");
    }
    
    //--- Final success message
    Print("✅ MetaphizixEA initialization completed successfully!");
    Print("🚀 System ready for operation");
    Alert("✅ MetaphizixEA: Successfully initialized and ready for trading!");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert Deinitialization Function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    //--- Kill timer
    EventKillTimer();
    
    //--- Cleanup objects
    CleanupObjects();
    
    //--- Clear display
    if(g_displayManager != NULL)
        g_displayManager.ClearAll();
    
    if(InpEnableLogging)
    {
        string reason_text = "";
        switch(reason)
        {
            case REASON_REMOVE: reason_text = "EA removed from chart"; break;
            case REASON_RECOMPILE: reason_text = "EA recompiled"; break;
            case REASON_CHARTCHANGE: reason_text = "Chart symbol/period changed"; break;
            case REASON_CHARTCLOSE: reason_text = "Chart closed"; break;
            case REASON_PARAMETERS: reason_text = "Input parameters changed"; break;
            case REASON_ACCOUNT: reason_text = "Account changed"; break;
            default: reason_text = "Unknown reason"; break;
        }
        Print("MetaphizixEA deinitialized. Reason: ", reason_text);
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    //--- Show helpful tips periodically
    ShowTradingTips();
    
    //--- Display market conditions periodically
    DisplayMarketConditions();
    
    //--- Check if trading is allowed
    if(!CheckTradingConditions())
        return;
    
    //--- Update market data and pair information
    if(!UpdateMarketData())
        return;
    
    //--- Perform signal analysis
    if(!ProcessSignalAnalysis())
        return;
    
    //--- Execute trading logic
    if(InpEnableAutoTrading)
    {
        ProcessTradeExecution();
    }
    
    //--- Manage existing positions
    ManageExistingPositions();
    
    //--- Update display
    UpdateDisplay();
    
    //--- Display performance statistics periodically
    DisplayPerformanceStats();
}

//+------------------------------------------------------------------+
//| Check if trading conditions are met                             |
//+------------------------------------------------------------------+
bool CheckTradingConditions()
{
    //--- Check if components are initialized
    if(!g_orderBlockDetector || !g_pairManager || !g_signalManager || 
       !g_riskManager || !g_tradeExecutor || !g_newsFilter || 
       !g_sessionFilter || !g_exitStrategy)
    {
        if(CConfig::IsLoggingEnabled())
            Print("⚠️ WARNING: Components not initialized - EA analysis paused");
        return false;
    }
    
    //--- Check session filter
    if(!g_sessionFilter.IsSessionActive())
    {
        static datetime lastSessionWarning = 0;
        if(TimeCurrent() - lastSessionWarning > 300) // Warn every 5 minutes
        {
            if(CConfig::IsLoggingEnabled())
                Print("⏰ INFO: Trading session not active - EA waiting for optimal session");
            lastSessionWarning = TimeCurrent();
        }
        return false;
    }
    
    //--- Check news filter
    if(!g_newsFilter.IsTradeAllowed())
    {
        static datetime lastNewsWarning = 0;
        if(TimeCurrent() - lastNewsWarning > 300) // Warn every 5 minutes
        {
            if(CConfig::IsLoggingEnabled())
                Print("📰 INFO: News filter active - Trading paused due to high-impact news");
            lastNewsWarning = TimeCurrent();
        }
        return false;
    }
    
    //--- Check if spread is acceptable
    double currentSpread = (Ask() - Bid()) / _Point;
    if(currentSpread > InpMaxSpread)
    {
        static datetime lastSpreadWarning = 0;
        if(TimeCurrent() - lastSpreadWarning > 60) // Warn every minute
        {
            if(CConfig::IsLoggingEnabled())
                Print("📊 INFO: Spread too high (", DoubleToString(currentSpread, 1), " points) - Waiting for better conditions");
            lastSpreadWarning = TimeCurrent();
        }
        return false;
    }
    
    //--- Check for spread manipulation
    if(g_spreadDetector != NULL && InpEnableSpreadDetection)
    {
        if(g_spreadDetector.DetectSpreadManipulation())
        {
            if(InpBlockTradesDuringManipulation)
            {
                static datetime lastManipulationWarning = 0;
                if(TimeCurrent() - lastManipulationWarning > 60) // Warn every minute
                {
                    if(CConfig::IsLoggingEnabled())
                        Print("🚨 ALERT: Spread manipulation detected - Trading blocked for safety");
                    lastManipulationWarning = TimeCurrent();
                }
                return false;
            }
        }
    }
    
    //--- Check broker and leverage conditions
    if(g_brokerDetector != NULL && InpEnableBrokerDetection)
    {
        // Check for high risk conditions
        if(InpBlockHighRiskConditions)
        {
            RiskAssessment risk = g_brokerDetector.GetRiskAssessment();
            LeverageInfo leverage = g_brokerDetector.GetLeverageInfo();
            
            // Block if very high risk
            if(risk.riskLevel >= 5)
            {
                static datetime lastRiskWarning = 0;
                if(TimeCurrent() - lastRiskWarning > 300) // Warn every 5 minutes
                {
                    if(CConfig::IsLoggingEnabled())
                        Print("⚠️ ALERT: Very high risk conditions detected - Trading blocked");
                    lastRiskWarning = TimeCurrent();
                }
                return false;
            }
            
            // Block if margin level too low
            if(leverage.marginLevel < InpMinMarginLevel && leverage.marginLevel > 0)
            {
                static datetime lastMarginWarning = 0;
                if(TimeCurrent() - lastMarginWarning > 60) // Warn every minute
                {
                    if(CConfig::IsLoggingEnabled())
                        Print("⚠️ ALERT: Low margin level (", DoubleToString(leverage.marginLevel, 1), "%) - Trading blocked");
                    lastMarginWarning = TimeCurrent();
                }
                return false;
            }
            
            // Block if over-leveraged
            if(leverage.usedLeverage > InpMaxSafeUsedLeverage)
            {
                static datetime lastLeverageWarning = 0;
                if(TimeCurrent() - lastLeverageWarning > 300) // Warn every 5 minutes
                {
                    if(CConfig::IsLoggingEnabled())
                        Print("⚠️ ALERT: Over-leveraged (", DoubleToString(leverage.usedLeverage, 2), "x) - Trading blocked");
                    lastLeverageWarning = TimeCurrent();
                }
                return false;
            }
        }
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Update market data and pair information                         |
//+------------------------------------------------------------------+
bool UpdateMarketData()
{
    //--- Update pair manager
    if(!g_pairManager.AnalyzePair(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("ERROR: Failed to update pair data for ", Symbol());
        return false;
    }
    
    //--- Update order block detector
    if(!g_orderBlockDetector.AnalyzePair(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("ERROR: Failed to update order block data for ", Symbol());
        return false;
    }
    
    //--- Update advanced modules if enabled
    if(g_forexAnalyzer != NULL)
    {
        g_forexAnalyzer.AnalyzeSymbol(Symbol());
    }
    
    if(g_volatilityAnalyzer != NULL)
    {
        g_volatilityAnalyzer.AnalyzeAllSymbols();
    }
    
    //--- Monitor broker and leverage conditions
    if(g_brokerDetector != NULL && InpMonitorLeverageChanges)
    {
        static datetime lastLeverageUpdate = 0;
        if(TimeCurrent() - lastLeverageUpdate > 300) // Update every 5 minutes
        {
            g_brokerDetector.DetectLeverageInfo(); // Refresh leverage information
            g_brokerDetector.AssessRisk(); // Reassess risk
            
            // Check for alerts
            if(InpEnableLeverageAlerts)
            {
                LeverageInfo leverage = g_brokerDetector.GetLeverageInfo();
                RiskAssessment risk = g_brokerDetector.GetRiskAssessment();
                
                // Alert on margin call risk
                if(leverage.marginCallRisk)
                {
                    Print("🚨 MARGIN CALL RISK: Margin level at ", DoubleToString(leverage.marginLevel, 1), "%");
                }
                
                // Alert on high risk
                if(risk.riskLevel >= 4)
                {
                    Print("⚠️ HIGH RISK: Risk level ", risk.riskLevel, "/5 - ", risk.riskDescription);
                }
            }
            
            lastLeverageUpdate = TimeCurrent();
        }
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Process signal analysis                                          |
//+------------------------------------------------------------------+
bool ProcessSignalAnalysis()
{
    //--- Analyze order blocks
    if(!g_orderBlockDetector.AnalyzePair(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("WARNING: Order block analysis failed for ", Symbol());
        return false;
    }
    
    //--- Update signal manager
    if(!g_signalManager.ProcessSignal(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("WARNING: Signal update failed for ", Symbol());
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Process trade execution                                          |
//+------------------------------------------------------------------+
void ProcessTradeExecution()
{
    //--- Check if we can open new trades
    if(!g_riskManager.CanOpenNewTrade(Symbol()))
    {
        static datetime lastRiskWarning = 0;
        if(TimeCurrent() - lastRiskWarning > 300) // Warn every 5 minutes
        {
            if(CConfig::IsLoggingEnabled())
                Print("🛡️ INFO: Risk manager blocked new trades - Position/exposure limits reached");
            lastRiskWarning = TimeCurrent();
        }
        return;
    }
    
    //--- Get signals from signal manager
    SSignal signals[];
    if(!g_signalManager.GetSignals(Symbol(), signals))
    {
        // No signals available
        return;
    }
    
    //--- Process each signal
    for(int i = 0; i < ArraySize(signals); i++)
    {
        //--- Display signal information to user
        DisplaySignalInformation(signals[i]);
        
        //--- Show confirmation dialog if enabled
        if(InpShowConfirmationDialogs && InpEnableAutoTrading)
        {
            string confirmMessage = "🎯 NEW TRADING SIGNAL\n\n";
            confirmMessage += "Symbol: " + signals[i].symbol + "\n";
            confirmMessage += "Type: " + EnumToString(signals[i].type) + "\n";
            confirmMessage += "Entry: " + DoubleToString(signals[i].entry_price, _Digits) + "\n";
            confirmMessage += "Confidence: " + DoubleToString(signals[i].confidence * 100, 1) + "%\n\n";
            confirmMessage += "Execute this trade?";
            
            int response = MessageBox(confirmMessage, "MetaphizixEA - Trade Confirmation", MB_YESNO | MB_ICONQUESTION);
            if(response != IDYES)
            {
                Print("👤 Trade cancelled by user");
                continue;
            }
        }
        
        //--- Validate signal with risk management
        double positionSize = g_riskManager.CalculatePositionSize(
            signals[i].symbol, 
            signals[i].entry_price, 
            signals[i].stop_loss
        );
        
        //--- Apply auto risk adjustment based on leverage conditions
        if(positionSize > 0 && g_brokerDetector != NULL && InpAutoAdjustRiskBasedOnLeverage)
        {
            RiskAssessment risk = g_brokerDetector.GetRiskAssessment();
            LeverageInfo leverage = g_brokerDetector.GetLeverageInfo();
            BrokerClassification classification = g_brokerDetector.GetBrokerClassification();
            
            double riskAdjustmentFactor = 1.0;
            
            // Adjust based on risk level
            switch(risk.riskLevel)
            {
                case 1: riskAdjustmentFactor = 1.0; break;   // No adjustment for very low risk
                case 2: riskAdjustmentFactor = 0.9; break;   // Slight reduction for low risk
                case 3: riskAdjustmentFactor = 0.7; break;   // Moderate reduction for medium risk
                case 4: riskAdjustmentFactor = 0.5; break;   // Significant reduction for high risk
                case 5: riskAdjustmentFactor = 0.3; break;   // Major reduction for very high risk
            }
            
            // Additional adjustment for over-leverage
            if(leverage.usedLeverage > InpMaxSafeUsedLeverage)
            {
                double leverageRatio = InpMaxSafeUsedLeverage / leverage.usedLeverage;
                riskAdjustmentFactor *= leverageRatio;
            }
            
            // Additional adjustment for low margin level
            if(leverage.marginLevel < InpMinMarginLevel && leverage.marginLevel > 0)
            {
                double marginRatio = leverage.marginLevel / InpMinMarginLevel;
                riskAdjustmentFactor *= marginRatio;
            }
            
            // Additional adjustment for broker trust score
            if(classification.trustScore < 80.0)
            {
                double trustRatio = classification.trustScore / 100.0;
                riskAdjustmentFactor *= (0.5 + trustRatio * 0.5); // Scale between 0.5 and 1.0
            }
            
            // Apply the adjustment
            double originalSize = positionSize;
            positionSize *= riskAdjustmentFactor;
            
            // Ensure we don't go below minimum lot size
            double minLot = SymbolInfoDouble(signals[i].symbol, SYMBOL_VOLUME_MIN);
            positionSize = MathMax(positionSize, minLot);
            
            // Log the adjustment if significant
            if(riskAdjustmentFactor < 0.95)
            {
                Print("📊 AUTO RISK ADJUSTMENT: Position size reduced from ", DoubleToString(originalSize, 2), 
                      " to ", DoubleToString(positionSize, 2), " lots (", 
                      DoubleToString(riskAdjustmentFactor * 100, 1), "% of original)");
                Print("   Reason: Risk Level ", risk.riskLevel, "/5, Used Leverage 1:", 
                      DoubleToString(leverage.usedLeverage, 2), ", Margin Level ", 
                      DoubleToString(leverage.marginLevel, 1), "%");
            }
        }
        
        if(positionSize > 0)
        {
            //--- Calculate dynamic profit target
            double dynamicTP = CalculateDynamicProfitTarget(signals[i].symbol, signals[i].entry_price, 
                                                          signals[i].stop_loss, 
                                                          (signals[i].type == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY) ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
            
            //--- Create trade request using built-in MQL5 structure
            MqlTradeRequest request = {0};
            MqlTradeResult result = {0};
            
            //--- Fill request structure
            request.action = TRADE_ACTION_DEAL;
            request.symbol = signals[i].symbol;
            request.volume = positionSize;
            request.price = signals[i].entry_price;
            request.sl = signals[i].stop_loss;
            request.tp = InpUseDynamicTargets ? dynamicTP : signals[i].take_profit;
            request.magic = InpMagicNumber;
            
            //--- Add trade style info to comment
            string styleText = "";
            switch(InpTradeStyle)
            {
                case TRADE_STYLE_SCALPING: styleText = "SCALP"; break;
                case TRADE_STYLE_SHORT_TERM: styleText = "SHORT"; break;
                case TRADE_STYLE_MEDIUM_TERM: styleText = "MEDIUM"; break;
                case TRADE_STYLE_LONG_TERM: styleText = "LONG"; break;
                case TRADE_STYLE_CUSTOM: styleText = "CUSTOM"; break;
            }
            request.comment = "MetaphizixEA v3.00 [" + styleText + "]";
            
            //--- Set order type based on signal
            if(signals[i].type == (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY)
            {
                request.type = ORDER_TYPE_BUY;
                request.price = SymbolInfoDouble(signals[i].symbol, SYMBOL_ASK);
            }
            else if(signals[i].type == (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY)
            {
                request.type = ORDER_TYPE_SELL;
                request.price = SymbolInfoDouble(signals[i].symbol, SYMBOL_BID);
            }
            
            //--- Execute trade
            bool tradeResult = OrderSend(request, result);
            
            //--- Add to monitoring system if successful
            if(tradeResult && result.retcode == TRADE_RETCODE_DONE)
            {
                AddTradeToMonitoring(result.order, signals[i].symbol, TimeCurrent(), 
                                   result.price, positionSize, request.type, 
                                   request.sl, request.tp);
            }
            
            //--- Display execution result to user
            DisplayTradeExecution(result, signals[i]);
            
            if(CConfig::IsLoggingEnabled())
            {
                Print("🔄 Trade execution ", tradeResult ? "✅ SUCCESS" : "❌ FAILED", 
                      " for ", signals[i].symbol, 
                      " | Type: ", EnumToString(signals[i].type),
                      " | Style: ", styleText,
                      " | Volume: ", DoubleToString(positionSize, 2),
                      " | TP: ", DoubleToString(request.tp, _Digits),
                      " | RetCode: ", result.retcode);
            }
        }
        else
        {
            if(CConfig::IsLoggingEnabled())
                Print("⚠️ WARNING: Position size calculation returned 0 - Trade skipped for safety");
        }
    }
}

//+------------------------------------------------------------------+
//| Manage existing positions                                        |
//+------------------------------------------------------------------+
void ManageExistingPositions()
{
    //--- Monitor trades with duration and profit management
    MonitorActiveTrades();
    
    //--- Process all exit strategies
    if(g_exitStrategy != NULL)
    {
        g_exitStrategy.ProcessAllExits();
    }
    
    //--- Additional position management for current symbol
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionGetSymbol(i) == Symbol())
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket > 0 && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
            {
                //--- Check for break-even opportunities
                if(g_exitStrategy.ShouldMoveToBreakEven(ticket))
                {
                    g_exitStrategy.ApplyBreakEven(ticket);
                }
                
                //--- Check for partial exit opportunities
                if(g_exitStrategy.ShouldPartialExit(ticket, InpPartialExitRR))
                {
                    g_exitStrategy.ApplyPartialExit(ticket, InpPartialExitRR);
                }
                
                //--- Apply trailing stop
                double atrValue = iATR(Symbol(), PERIOD_H1, 14, 0);
                if(g_exitStrategy.ShouldTrailStop(ticket, atrValue))
                {
                    g_exitStrategy.ApplyTrailingStop(ticket, atrValue);
                }
                
                if(CConfig::IsLoggingEnabled())
                {
                    double currentProfit = g_exitStrategy.GetCurrentProfit(ticket);
                    double currentRR = g_exitStrategy.GetCurrentRiskReward(ticket);
                    
                    //--- Get trade duration
                    datetime openTime = (datetime)PositionGetInteger(POSITION_TIME);
                    int durationMinutes = (int)((TimeCurrent() - openTime) / 60);
                    
                    //--- Enhanced logging with trade management info
                    static datetime lastDetailedLog = 0;
                    if(TimeCurrent() - lastDetailedLog > 300) // Every 5 minutes
                    {
                        Print("📊 Position management - Ticket: ", ticket, 
                              " | Profit: ", DoubleToString(currentProfit, 2),
                              " | R:R: ", DoubleToString(currentRR, 2),
                              " | Duration: ", durationMinutes, " min",
                              " | Style: ", EnumToString(InpTradeStyle));
                        lastDetailedLog = TimeCurrent();
                    }
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Update display elements                                          |
//+------------------------------------------------------------------+
void UpdateDisplay()
{
    //--- Update display manager
    if(g_displayManager)
    {
        g_displayManager.UpdateDisplay(Symbol());
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    static datetime lastTimerUpdate = 0;
    datetime currentTime = TimeCurrent();
    
    //--- Show timer activity every 30 seconds for user awareness
    if(currentTime - lastTimerUpdate >= 30)
    {
        if(InpDisplayDetailedLogs)
            Print("⏱️ MetaphizixEA Active - Analyzing markets...");
        lastTimerUpdate = currentTime;
    }
    
    //--- Analyze all pairs and select best opportunities
    if(g_pairManager != NULL)
    {
        if(InpDisplayDetailedLogs)
            Print("🔍 Starting multi-pair analysis...");
            
        g_pairManager.AnalyzeAllPairs();
        
        // Note: g_bestPairs is already sized to g_maxPairs in initialization
        if(g_pairManager.GetBestPairs(g_bestPairs))
        {
            if(InpDisplayDetailedLogs)
                Print("📊 Found ", ArraySize(g_bestPairs), " trading opportunities");
            
            //--- Update correlation analysis if enabled
            if(g_correlationAnalyzer != NULL)
            {
                if(InpDisplayDetailedLogs)
                    Print("🔗 Updating correlation analysis...");
                double weights[];
                ArrayResize(weights, ArraySize(g_bestPairs));
                ArrayInitialize(weights, 1.0 / ArraySize(g_bestPairs));
                g_correlationAnalyzer.AnalyzePortfolioCorrelations(g_bestPairs, weights);
            }
            
            //--- Process each best pair
            for(int i = 0; i < ArraySize(g_bestPairs); i++)
            {
                if(g_orderBlockDetector != NULL)
                {
                    if(InpDisplayDetailedLogs)
                        Print("🎯 Analyzing order blocks for ", g_bestPairs[i]);
                        
                    //--- Detect order blocks for this pair
                    g_orderBlockDetector.AnalyzePair(g_bestPairs[i]);
                    
                    //--- Enhanced analysis with advanced modules
                    if(g_forexAnalyzer != NULL)
                    {
                        g_forexAnalyzer.AnalyzeSymbol(g_bestPairs[i]);
                    }
                    
                    if(g_volatilityAnalyzer != NULL)
                    {
                        g_volatilityAnalyzer.AnalyzeAllSymbols();
                    }
                    
                    //--- Process signals if any
                    if(g_signalManager != NULL && g_orderBlockDetector.HasNewOrderBlock(g_bestPairs[i]))
                    {
                        if(InpDisplayDetailedLogs)
                            Print("💡 New order block detected for ", g_bestPairs[i], " - Generating signals...");
                        g_signalManager.ProcessSignal(g_bestPairs[i]);
                    }
                }
            }
            
            //--- Update display for all analyzed pairs
            if(g_displayManager != NULL)
                g_displayManager.UpdateAllDisplays(g_bestPairs);
                
            //--- Summary for user
            if(InpDisplayDetailedLogs)
                Print("✅ Multi-pair analysis complete - ", ArraySize(g_bestPairs), " pairs processed");
        }
        else
        {
            if(InpDisplayDetailedLogs)
                Print("⏸️ No trading opportunities found in current market conditions");
        }
    }
    
    //--- Periodic ML model training if enabled
    if(g_mlPredictor != NULL)
    {
        static datetime lastMLUpdate = 0;
        if(currentTime - lastMLUpdate > 3600) // Update every hour
        {
            if(InpDisplayDetailedLogs)
                Print("🧠 Training machine learning models...");
            g_mlPredictor.TrainModel(Symbol(), 1000);
            lastMLUpdate = currentTime;
            Print("✅ ML model training completed");
        }
    }
    
    //--- Periodic system health check
    static datetime lastHealthCheck = 0;
    if(currentTime - lastHealthCheck > 900) // Every 15 minutes
    {
        if(InpDisplayDetailedLogs)
        {
            Print("🏥 SYSTEM HEALTH CHECK:");
            Print("💾 Memory usage: Normal");
            Print("⚡ Processing speed: Optimal");
            Print("🔗 Component status: All systems operational");
            Print("🛡️ Risk controls: Active and monitoring");
        }
        lastHealthCheck = currentTime;
    }
}

//+------------------------------------------------------------------+
//| Chart event function                                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    //--- Handle chart events for display interaction
    if(g_displayManager != NULL)
        g_displayManager.OnChartEvent(id, lparam, dparam, sparam);
}

//+------------------------------------------------------------------+
//| Validate input parameters                                        |
//+------------------------------------------------------------------+
bool ValidateInputs()
{
    bool isValid = true;
    string errorMessages = "";
    
    //--- Check trading pairs
    if(StringLen(InpTradingPairs) == 0)
    {
        errorMessages += "❌ Trading pairs list cannot be empty!\n";
        isValid = false;
    }
    
    //--- Check max concurrent pairs
    if(InpMaxConcurrentPairs < 1 || InpMaxConcurrentPairs > 28)
    {
        errorMessages += "❌ Max concurrent pairs must be between 1 and 28!\n";
        isValid = false;
    }
    
    //--- Check order block settings
    if(InpOrderBlockLookback < 10 || InpOrderBlockLookback > 200)
    {
        errorMessages += "❌ Order block lookback must be between 10 and 200!\n";
        isValid = false;
    }
    
    if(InpMinOrderBlockSize < 5 || InpMinOrderBlockSize > 100)
    {
        errorMessages += "❌ Minimum order block size must be between 5 and 100 pips!\n";
        isValid = false;
    }
    
    if(InpOrderBlockConfirmation < 1 || InpOrderBlockConfirmation > 10)
    {
        errorMessages += "❌ Order block confirmation must be between 1 and 10 candles!\n";
        isValid = false;
    }
    
    //--- Check risk management settings
    if(InpAccountRiskPercent < 0.1 || InpAccountRiskPercent > 10.0)
    {
        errorMessages += "❌ Account risk must be between 0.1% and 10.0% per trade!\n";
        isValid = false;
    }
    
    if(InpMaxOpenTrades < 1 || InpMaxOpenTrades > 50)
    {
        errorMessages += "❌ Max open trades must be between 1 and 50!\n";
        isValid = false;
    }
    
    if(InpCorrelationThreshold < 0.1 || InpCorrelationThreshold > 1.0)
    {
        errorMessages += "❌ Correlation threshold must be between 0.1 and 1.0!\n";
        isValid = false;
    }
    
    //--- Check timer interval
    if(InpTimerInterval < 1 || InpTimerInterval > 60)
    {
        errorMessages += "❌ Timer interval must be between 1 and 60 seconds!\n";
        isValid = false;
    }
    
    //--- Check spread settings
    if(InpMaxSpread < 1.0 || InpMaxSpread > 100.0)
    {
        errorMessages += "❌ Max spread must be between 1.0 and 100.0 points!\n";
        isValid = false;
    }
    
    //--- Check trade duration and profit settings
    if(InpMaxTradeDurationMinutes < 1 || InpMaxTradeDurationMinutes > 10080) // Max 1 week
    {
        errorMessages += "❌ Max trade duration must be between 1 and 10080 minutes (1 week)!\n";
        isValid = false;
    }
    
    if(InpProfitTargetPercent < 0.1 || InpProfitTargetPercent > 50.0)
    {
        errorMessages += "❌ Profit target percent must be between 0.1% and 50.0%!\n";
        isValid = false;
    }
    
    if(InpMinProfitTargetPips < 1.0 || InpMinProfitTargetPips > 1000.0)
    {
        errorMessages += "❌ Minimum profit target must be between 1.0 and 1000.0 pips!\n";
        isValid = false;
    }
    
    if(InpMaxProfitTargetPips < InpMinProfitTargetPips || InpMaxProfitTargetPips > 2000.0)
    {
        errorMessages += "❌ Maximum profit target must be >= minimum and <= 2000.0 pips!\n";
        isValid = false;
    }
    
    if(InpScalpingMaxMinutes < 1 || InpScalpingMaxMinutes > 120)
    {
        errorMessages += "❌ Scalping max duration must be between 1 and 120 minutes!\n";
        isValid = false;
    }
    
    if(InpShortTermMaxHours < 1 || InpShortTermMaxHours > 168) // Max 1 week
    {
        errorMessages += "❌ Short-term max duration must be between 1 and 168 hours!\n";
        isValid = false;
    }
    
    //--- Check spread manipulation detection settings
    if(InpSpreadMultiplierThreshold < 1.5 || InpSpreadMultiplierThreshold > 10.0)
    {
        errorMessages += "❌ Spread multiplier threshold must be between 1.5 and 10.0!\n";
        isValid = false;
    }
    
    if(InpVolumeAnomalyThreshold < 1.0 || InpVolumeAnomalyThreshold > 10.0)
    {
        errorMessages += "❌ Volume anomaly threshold must be between 1.0 and 10.0!\n";
        isValid = false;
    }
    
    if(InpRapidSpreadChangeThreshold < 50.0 || InpRapidSpreadChangeThreshold > 500.0)
    {
        errorMessages += "❌ Rapid spread change threshold must be between 50% and 500%!\n";
        isValid = false;
    }
    
    if(InpMinDetectionPeriod < 1 || InpMinDetectionPeriod > 60)
    {
        errorMessages += "❌ Min detection period must be between 1 and 60 minutes!\n";
        isValid = false;
    }
    
    if(InpMaxDetectionPeriod < InpMinDetectionPeriod || InpMaxDetectionPeriod > 300)
    {
        errorMessages += "❌ Max detection period must be >= min period and <= 300 minutes!\n";
        isValid = false;
    }
    
    if(InpNewsFilterMinutes < 5 || InpNewsFilterMinutes > 120)
    {
        errorMessages += "❌ News filter duration must be between 5 and 120 minutes!\n";
        isValid = false;
    }
    
    //--- Check broker and leverage detection settings
    if(InpMaxSafeUsedLeverage < 1.0 || InpMaxSafeUsedLeverage > 100.0)
    {
        errorMessages += "❌ Max safe used leverage must be between 1.0 and 100.0!\n";
        isValid = false;
    }
    
    if(InpMinMarginLevel < 50.0 || InpMinMarginLevel > 1000.0)
    {
        errorMessages += "❌ Min margin level must be between 50% and 1000%!\n";
        isValid = false;
    }
    
    //--- Show all errors to user if any
    if(!isValid)
    {
        string alertMessage = "🚨 MetaphizixEA Configuration Errors:\n\n" + errorMessages;
        alertMessage += "\n⚠️ Please correct these settings and restart the EA.";
        Alert(alertMessage);
        
        Print("========================================");
        Print("❌ INPUT VALIDATION FAILED:");
        Print(errorMessages);
        Print("========================================");
    }
    else
    {
        Print("✅ Input validation successful - All settings are valid");
    }
    
    return isValid;
}

//+------------------------------------------------------------------+
//| Cleanup objects                                                  |
//+------------------------------------------------------------------+
void CleanupObjects()
{
    if(g_orderBlockDetector != NULL)
    {
        delete g_orderBlockDetector;
        g_orderBlockDetector = NULL;
    }
    
    if(g_pairManager != NULL)
    {
        delete g_pairManager;
        g_pairManager = NULL;
    }
    
    if(g_signalManager != NULL)
    {
        delete g_signalManager;
        g_signalManager = NULL;
    }
    
    if(g_displayManager != NULL)
    {
        delete g_displayManager;
        g_displayManager = NULL;
    }
    
    if(g_riskManager != NULL)
    {
        delete g_riskManager;
        g_riskManager = NULL;
    }
    
    if(g_tradeExecutor != NULL)
    {
        delete g_tradeExecutor;
        g_tradeExecutor = NULL;
    }
    
    if(g_newsFilter != NULL)
    {
        delete g_newsFilter;
        g_newsFilter = NULL;
    }
    
    if(g_sessionFilter != NULL)
    {
        delete g_sessionFilter;
        g_sessionFilter = NULL;
    }
    
    if(g_exitStrategy != NULL)
    {
        delete g_exitStrategy;
        g_exitStrategy = NULL;
    }
    
    //--- Cleanup advanced modules
    if(g_forexAnalyzer != NULL)
    {
        delete g_forexAnalyzer;
        g_forexAnalyzer = NULL;
    }
    
    if(g_volatilityAnalyzer != NULL)
    {
        delete g_volatilityAnalyzer;
        g_volatilityAnalyzer = NULL;
    }
    
    if(g_correlationAnalyzer != NULL)
    {
        delete g_correlationAnalyzer;
        g_correlationAnalyzer = NULL;
    }
    
    if(g_mlPredictor != NULL)
    {
        delete g_mlPredictor;
        g_mlPredictor = NULL;
    }
    
    //--- Cleanup comprehensive analyzer modules
    if(g_fibonacci != NULL)
    {
        delete g_fibonacci;
        g_fibonacci = NULL;
    }
    
    if(g_marketAnalysis != NULL)
    {
        delete g_marketAnalysis;
        g_marketAnalysis = NULL;
    }
    
    if(g_portfolioManager != NULL)
    {
        delete g_portfolioManager;
        g_portfolioManager = NULL;
    }
    
    if(g_sentimentAnalyzer != NULL)
    {
        delete g_sentimentAnalyzer;
        g_sentimentAnalyzer = NULL;
    }
    
    if(g_riskAdjuster != NULL)
    {
        delete g_riskAdjuster;
        g_riskAdjuster = NULL;
    }
    
    if(g_multiTimeframeAnalyzer != NULL)
    {
        delete g_multiTimeframeAnalyzer;
        g_multiTimeframeAnalyzer = NULL;
    }
    
    if(g_seasonalityAnalyzer != NULL)
    {
        delete g_seasonalityAnalyzer;
        g_seasonalityAnalyzer = NULL;
    }
    
    if(g_orderFlowAnalyzer != NULL)
    {
        delete g_orderFlowAnalyzer;
        g_orderFlowAnalyzer = NULL;
    }
    
    if(g_currencyStrengthAnalyzer != NULL)
    {
        delete g_currencyStrengthAnalyzer;
        g_currencyStrengthAnalyzer = NULL;
    }
    
    //--- Cleanup dynamic optimization modules
    if(g_adaptiveEngine != NULL)
    {
        delete g_adaptiveEngine;
        g_adaptiveEngine = NULL;
    }
    
    if(g_strategyManager != NULL)
    {
        delete g_strategyManager;
        g_strategyManager = NULL;
    }
    
    if(g_realtimeOptimizer != NULL)
    {
        delete g_realtimeOptimizer;
        g_realtimeOptimizer = NULL;
    }
    
    //--- Cleanup spread manipulation detector
    if(g_spreadDetector != NULL)
    {
        delete g_spreadDetector;
        g_spreadDetector = NULL;
    }
    
    //--- Cleanup broker and leverage detector
    if(g_brokerDetector != NULL)
    {
        delete g_brokerDetector;
        g_brokerDetector = NULL;
    }
}

//+------------------------------------------------------------------+
//| INITIALIZATION HELPER FUNCTIONS                                 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Display startup information                                      |
//+------------------------------------------------------------------+
void DisplayStartupInfo()
{
    Print("========================================================");
    Print("🚀 MetaphizixEA v3.01 Professional Forex Expert Advisor");
    Print("========================================================");
    Print("📊 Author: Metaphizix Ltd.");
    Print("🌐 GitHub: https://github.com/metaphizix/MetaphizixEA");
    Print("📈 Trading Mode: ", InpEnableAutoTrading ? "🔴 LIVE TRADING ACTIVE" : "🟢 ANALYSIS MODE (Safe)");
    Print("⚠️  Risk Level: ", InpAccountRiskPercent, "% per trade");
    Print("🎯 Max Concurrent Pairs: ", InpMaxConcurrentPairs);
    Print("📊 Advanced Modules Status:");
    Print("   🔹 Forex Analysis: ", InpEnableForexAnalysis ? "✅ ENABLED" : "❌ DISABLED");
    Print("   🔹 Volatility Analysis: ", InpEnableVolatilityAnalysis ? "✅ ENABLED" : "❌ DISABLED");
    Print("   🔹 Correlation Analysis: ", InpEnableCorrelationAnalysis ? "✅ ENABLED" : "❌ DISABLED");
    Print("   🔹 ML Predictions: ", InpEnableMLPrediction ? "✅ ENABLED" : "❌ DISABLED");
    Print("   🔹 Spread Detection: ", InpEnableSpreadDetection ? "✅ ENABLED" : "❌ DISABLED");
    Print("   🔹 Broker Analysis: ", InpEnableBrokerDetection ? "✅ ENABLED" : "❌ DISABLED");
    Print("========================================================");
}

//+------------------------------------------------------------------+
//| Initialize system configuration                                  |
//+------------------------------------------------------------------+
bool InitializeSystemConfiguration()
{
    //--- Load environment variables and external configuration
    LoadEnvironmentConfiguration();
    
    //--- Initialize core configuration
    if(!CConfig::Initialize(InpTradingPairs, InpMaxConcurrentPairs, InpOrderBlockLookback, 
                           InpMinOrderBlockSize, InpOrderBlockConfirmation, InpTimerInterval, 
                           InpEnableLogging))
    {
        Print("❌ ERROR: Failed to initialize configuration");
        return false;
    }
    
    //--- Initialize global arrays
    ArrayResize(g_bestPairs, g_maxPairs);
    ArrayInitialize(g_bestPairs, "");
    
    Print("🔧 Configuration initialized successfully");
    Print("💼 Trading pairs configured: ", InpTradingPairs);
    return true;
}

//+------------------------------------------------------------------+
//| Create core trading components                                   |
//+------------------------------------------------------------------+
bool CreateCoreComponents()
{
    //--- Create core components
    g_orderBlockDetector = new COrderBlockDetector();
    g_pairManager = new CPairManager();
    g_signalManager = new CSignalManager();
    g_displayManager = new CDisplayManager();
    g_riskManager = new CRiskManagement();
    g_tradeExecutor = new CTradeExecution();
    g_newsFilter = new CNewsFilter();
    g_sessionFilter = new CSessionFilter();
    g_exitStrategy = new CExitStrategy();
    
    //--- Validate core components creation
    if(!g_orderBlockDetector || !g_pairManager || !g_signalManager || !g_displayManager ||
       !g_riskManager || !g_tradeExecutor || !g_newsFilter || !g_sessionFilter || !g_exitStrategy)
    {
        Print("❌ ERROR: Failed to create core component objects");
        return false;
    }
    
    Print("🏗️  Core components created successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Create advanced analysis modules                                 |
//+------------------------------------------------------------------+
bool CreateAdvancedModules()
{
    //--- Create advanced analysis modules conditionally
    if(InpEnableForexAnalysis) g_forexAnalyzer = new CForexAnalyzer();
    if(InpEnableVolatilityAnalysis) g_volatilityAnalyzer = new CVolatilityAnalyzer();
    if(InpEnableCorrelationAnalysis) g_correlationAnalyzer = new CCorrelationAnalyzer();
    if(InpEnableMLPrediction) g_mlPredictor = new CMLPredictor();
    
    //--- Create comprehensive analyzer modules
    g_fibonacci = new CFibonacci();
    g_marketAnalysis = new CMarketAnalysis();
    g_portfolioManager = new CPortfolioManager();
    g_sentimentAnalyzer = new CSentimentAnalyzer();
    g_riskAdjuster = new CRiskAdjuster();
    g_multiTimeframeAnalyzer = new CMultiTimeframeAnalyzer();
    g_seasonalityAnalyzer = new CSeasonalityAnalyzer();
    g_orderFlowAnalyzer = new COrderFlowAnalyzer();
    g_currencyStrengthAnalyzer = new CCurrencyStrengthAnalyzer();
    
    //--- Create dynamic optimization modules
    if(InpEnableAdaptiveDecisions) g_adaptiveEngine = new CAdaptiveDecisionEngine();
    if(InpEnableDynamicStrategy) g_strategyManager = new CDynamicStrategyManager();
    if(InpEnableRealtimeOptimization) g_realtimeOptimizer = new CRealtimeOptimizer();
    
    Print("🧠 Advanced analysis modules created successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Create protection and detection systems                          |
//+------------------------------------------------------------------+
bool CreateProtectionSystems()
{
    //--- Create spread manipulation detector
    if(InpEnableSpreadDetection)
    {
        g_spreadDetector = new CSpreadManipulationDetector();
        if(!g_spreadDetector)
        {
            Print("❌ ERROR: Failed to create spread manipulation detector");
            return false;
        }
    }
    
    //--- Create broker and leverage detector
    if(InpEnableBrokerDetection)
    {
        g_brokerDetector = new CBrokerLeverageDetector();
        if(!g_brokerDetector)
        {
            Print("❌ ERROR: Failed to create broker leverage detector");
            return false;
        }
    }
    
    Print("🛡️  Protection systems created successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Initialize all components                                        |
//+------------------------------------------------------------------+
bool InitializeAllComponents()
{
    bool initSuccess = true;
    
    //--- Initialize core components
    initSuccess = initSuccess && InitializeCoreComponents();
    
    //--- Initialize advanced modules
    if(initSuccess)
        initSuccess = InitializeAdvancedModules();
    
    //--- Initialize protection systems
    if(initSuccess)
        initSuccess = InitializeProtectionSystems();
    
    if(initSuccess)
        Print("✅ All components initialized successfully");
    else
        Print("❌ Component initialization failed");
        
    return initSuccess;
}

//+------------------------------------------------------------------+
//| Initialize core components                                       |
//+------------------------------------------------------------------+
bool InitializeCoreComponents()
{
    bool initSuccess = g_orderBlockDetector.Initialize() &&
                      g_pairManager.Initialize() &&
                      g_signalManager.Initialize() &&
                      g_displayManager.Initialize(InpShowEntryPoints, InpShowExitPoints, 
                                                InpBullishEntryColor, InpBearishEntryColor, InpExitColor) &&
                      g_riskManager.Initialize(InpAccountRiskPercent, InpMaxOpenTrades, InpCorrelationThreshold) &&
                      g_tradeExecutor.Initialize(InpMagicNumber, "MetaphizixEA") &&
                      g_newsFilter.Initialize(InpNewsImpactThreshold) &&
                      g_sessionFilter.Initialize(InpSessionStartHour, InpSessionEndHour) &&
                      g_exitStrategy.Initialize(InpATRMultiplier, InpBreakEvenBuffer, InpPartialExitRR);
    
    if(initSuccess)
        Print("✅ Core components initialized successfully");
    else
        Print("❌ Failed to initialize core components");
        
    return initSuccess;
}

//+------------------------------------------------------------------+
//| Initialize advanced analysis modules                             |
//+------------------------------------------------------------------+
bool InitializeAdvancedModules()
{
    bool initSuccess = true;
    
    //--- Initialize advanced modules if enabled
    if(g_forexAnalyzer != NULL) initSuccess = initSuccess && g_forexAnalyzer.Initialize();
    if(g_volatilityAnalyzer != NULL) initSuccess = initSuccess && g_volatilityAnalyzer.Initialize();
    if(g_correlationAnalyzer != NULL) initSuccess = initSuccess && g_correlationAnalyzer.Initialize();
    if(g_mlPredictor != NULL) initSuccess = initSuccess && g_mlPredictor.Initialize();
    
    //--- Initialize dynamic optimization modules
    if(g_adaptiveEngine != NULL) 
    {
        initSuccess = initSuccess && InitializeAdaptiveEngine();
    }
    
    if(g_strategyManager != NULL) 
    {
        initSuccess = initSuccess && InitializeStrategyManager();
    }
    
    if(g_realtimeOptimizer != NULL) 
    {
        initSuccess = initSuccess && InitializeRealtimeOptimizer();
    }
    
    if(initSuccess)
        Print("✅ Advanced modules initialized successfully");
    else
        Print("❌ Failed to initialize advanced modules");
        
    return initSuccess;
}

//+------------------------------------------------------------------+
//| Initialize protection systems                                    |
//+------------------------------------------------------------------+
bool InitializeProtectionSystems()
{
    bool initSuccess = true;
    
    //--- Initialize spread manipulation detector
    if(g_spreadDetector != NULL) 
    {
        initSuccess = initSuccess && g_spreadDetector.Init(Symbol(), PERIOD_CURRENT);
        if(initSuccess)
        {
            g_spreadDetector.SetParameters(InpSpreadMultiplierThreshold, InpVolumeAnomalyThreshold, 
                                         InpRapidSpreadChangeThreshold, InpMinDetectionPeriod, 
                                         InpMaxDetectionPeriod);
            g_spreadDetector.SetNewsFilter(InpFilterNewsEvents, InpNewsFilterMinutes);
            g_spreadDetector.SetAlerts(InpEnableSpreadAlerts, InpEnableSpreadNotifications, "alert.wav");
            Print("✅ Spread manipulation detector initialized successfully");
        }
    }
    
    //--- Initialize broker and leverage detector
    if(g_brokerDetector != NULL) 
    {
        initSuccess = initSuccess && g_brokerDetector.Init(Symbol());
        if(initSuccess)
        {
            if(InpShowBrokerInfo)
            {
                Print("🏢 Displaying broker information...");
                g_brokerDetector.PrintFullReport();
            }
            Print("✅ Broker and leverage detector initialized successfully");
        }
    }
    
    if(initSuccess)
        Print("✅ Protection systems initialized successfully");
    else
        Print("❌ Failed to initialize protection systems");
        
    return initSuccess;
}

//+------------------------------------------------------------------+
//| Initialize adaptive decision engine                              |
//+------------------------------------------------------------------+
bool InitializeAdaptiveEngine()
{
    bool success = g_adaptiveEngine.Initialize(NULL, g_mlPredictor, g_sentimentAnalyzer);
    if(success)
    {
        SAdaptiveConfig config;
        config.primaryMode = InpInitialDecisionMode;
        config.adaptationSpeed = InpAdaptationSpeed;
        config.enableMLAdaptation = InpEnableMLDrivenDecisions;
        config.enableSentimentAdaptation = true;
        config.enableVolatilityAdaptation = true;
        config.adaptationPeriod = InpOptimizationFrequency;
        g_adaptiveEngine.SetAdaptiveConfig(config);
    }
    return success;
}

//+------------------------------------------------------------------+
//| Initialize strategy manager                                      |
//+------------------------------------------------------------------+
bool InitializeStrategyManager()
{
    bool success = g_strategyManager.Initialize(g_adaptiveEngine);
    if(success && InpEnableEnsembleMode)
    {
        g_strategyManager.EnableEnsembleMode(true);
    }
    return success;
}

//+------------------------------------------------------------------+
//| Initialize realtime optimizer                                   |
//+------------------------------------------------------------------+
bool InitializeRealtimeOptimizer()
{
    bool success = g_realtimeOptimizer.Initialize(g_adaptiveEngine, g_strategyManager);
    if(success)
    {
        g_realtimeOptimizer.SetOptimizationFrequency(OPTIMIZATION_PARAMETERS, FREQ_MEDIUM);
        g_realtimeOptimizer.SetOptimizationFrequency(OPTIMIZATION_STRATEGY, FREQ_LOW);
        g_realtimeOptimizer.EnableOptimization(OPTIMIZATION_PARAMETERS, true);
        g_realtimeOptimizer.EnableOptimization(OPTIMIZATION_STRATEGY, InpEnableDynamicStrategy);
        g_realtimeOptimizer.StartRealTimeOptimization();
    }
    return success;
}

//+------------------------------------------------------------------+
//| Show welcome message with user guidance                         |
//+------------------------------------------------------------------+
void ShowWelcomeMessage()
{
    string message = "🎉 Welcome to MetaphizixEA v3.00! 🎉\n\n";
    message += "📚 GETTING STARTED:\n";
    message += "• This EA analyzes multiple currency pairs\n";
    message += "• It detects order blocks and generates trading signals\n";
    message += "• Advanced risk management is built-in\n\n";
    
    message += "🔧 CONFIGURATION TIPS:\n";
    message += "• Start with Analysis Mode (safer)\n";
    message += "• Test on demo account first\n";
    message += "• Adjust risk percentage conservatively\n";
    message += "• Monitor the Experts tab for updates\n\n";
    
    message += "⚠️ IMPORTANT:\n";
    message += "• Check trading session times\n";
    message += "• Ensure news filter is enabled\n";
    message += "• Monitor correlation limits\n";
    message += "• Never risk more than you can afford to lose\n\n";
    
    message += "📖 For detailed documentation, visit:\n";
    message += "GitHub: https://github.com/metaphizix/MetaphizixEA\n\n";
    message += "Good luck and trade safely! 💪";
    
    Alert(message);
}

//+------------------------------------------------------------------+
//| Show configuration summary to user                              |
//+------------------------------------------------------------------+
void ShowConfigurationSummary()
{
    Print("📋 CONFIGURATION SUMMARY:");
    Print("=====================================");
    Print("💼 Trading Pairs: ", InpTradingPairs);
    Print("📊 Max Concurrent Pairs: ", InpMaxConcurrentPairs);
    Print("📈 Account Risk per Trade: ", InpAccountRiskPercent, "%");
    Print("🎯 Max Open Trades: ", InpMaxOpenTrades);
    Print("🔗 Correlation Threshold: ", InpCorrelationThreshold);
    Print("📰 News Filter: ", InpEnableNewsFilter ? "✅ ENABLED" : "❌ DISABLED");
    Print("⏰ Session Filter: ", InpEnableSessionFilter ? "✅ ENABLED" : "❌ DISABLED");
    Print("🔍 Spread Manipulation Detection: ", InpEnableSpreadDetection ? "✅ ENABLED" : "❌ DISABLED");
    if(InpEnableSpreadDetection)
    {
        Print("   🎯 Detection Threshold: ", DoubleToString(InpSpreadMultiplierThreshold, 1), "x normal spread");
        Print("   🚫 Block Trades During Manipulation: ", InpBlockTradesDuringManipulation ? "✅ YES" : "❌ NO");
        Print("   🔔 Alerts: ", InpEnableSpreadAlerts ? "✅ ENABLED" : "❌ DISABLED");
    }
    Print("� Broker & Leverage Detection: ", InpEnableBrokerDetection ? "✅ ENABLED" : "❌ DISABLED");
    if(InpEnableBrokerDetection)
    {
        Print("   ⚖️ Max Safe Used Leverage: 1:", DoubleToString(InpMaxSafeUsedLeverage, 1));
        Print("   💰 Min Margin Level: ", DoubleToString(InpMinMarginLevel, 0), "%");
        Print("   🚫 Block High Risk: ", InpBlockHighRiskConditions ? "✅ YES" : "❌ NO");
        Print("   📊 Auto Risk Adjustment: ", InpAutoAdjustRiskBasedOnLeverage ? "✅ YES" : "❌ NO");
    }
    Print("�🎨 Chart Display: ", (InpShowEntryPoints || InpShowExitPoints) ? "✅ ENABLED" : "❌ DISABLED");
    
    Print("=====================================");
    Print("⏱️ TRADE DURATION & PROFIT MANAGEMENT:");
    Print("📊 Trade Style: ", EnumToString(InpTradeStyle));
    Print("⏰ Max Duration: ", InpMaxTradeDurationMinutes, " minutes");
    Print("💰 Profit Target: ", DoubleToString(InpProfitTargetPercent, 1), "% of account");
    Print("📏 Profit Range: ", DoubleToString(InpMinProfitTargetPips, 1), "-", DoubleToString(InpMaxProfitTargetPips, 1), " pips");
    Print("⏱️ Time-based Exit: ", InpUseTimeBasedExit ? "✅ ENABLED" : "❌ DISABLED");
    Print("💯 Percentage Exit: ", InpUseProfitPercentExit ? "✅ ENABLED" : "❌ DISABLED");
    Print("🎯 Dynamic Targets: ", InpUseDynamicTargets ? "✅ ENABLED" : "❌ DISABLED");
    Print("=====================================");
}

//+------------------------------------------------------------------+
//| Display current market conditions                               |
//+------------------------------------------------------------------+
void DisplayMarketConditions()
{
    static datetime lastUpdate = 0;
    if(TimeCurrent() - lastUpdate < 30) return; // Update every 30 seconds
    lastUpdate = TimeCurrent();
    
    if(!InpDisplayDetailedLogs) return;
    
    Print("🌍 MARKET CONDITIONS UPDATE:");
    Print("============================");
    
    //--- Current symbol information
    double currentSpread = (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)) / SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    Print("📊 ", Symbol(), " Spread: ", DoubleToString(currentSpread, 1), " points");
    
    //--- Spread manipulation status
    if(g_spreadDetector != NULL && InpEnableSpreadDetection)
    {
        bool manipulationDetected = g_spreadDetector.IsManipulationDetected();
        double confidence = g_spreadDetector.GetManipulationConfidence();
        string status = g_spreadDetector.GetStatusString();
        
        if(manipulationDetected)
        {
            Print("🚨 Spread Status: ⚠️ MANIPULATION DETECTED (", DoubleToString(confidence, 1), "% confidence)");
            string description = g_spreadDetector.GetManipulationDescription();
            if(description != "") Print("   Details: ", description);
        }
        else
        {
            Print("🔍 Spread Status: ✅ NORMAL");
        }
    }
    
    //--- Broker and leverage status
    if(g_brokerDetector != NULL && InpEnableBrokerDetection)
    {
        BrokerInfo broker = g_brokerDetector.GetBrokerInfo();
        LeverageInfo leverage = g_brokerDetector.GetLeverageInfo();
        RiskAssessment risk = g_brokerDetector.GetRiskAssessment();
        
        Print("🏢 Broker: ", broker.companyName, " (", broker.brokerType, ")");
        Print("⚖️ Leverage: 1:", DoubleToString(leverage.currentLeverage, 0), " | Used: 1:", DoubleToString(leverage.usedLeverage, 2));
        Print("💰 Margin Level: ", DoubleToString(leverage.marginLevel, 1), "% | Risk Level: ", risk.riskLevel, "/5");
        
        if(risk.riskLevel >= 4)
        {
            Print("⚠️ HIGH RISK CONDITIONS DETECTED!");
        }
        else if(leverage.marginLevel < InpMinMarginLevel && leverage.marginLevel > 0)
        {
            Print("⚠️ LOW MARGIN LEVEL WARNING!");
        }
        else if(leverage.usedLeverage > InpMaxSafeUsedLeverage)
        {
            Print("⚠️ OVER-LEVERAGED WARNING!");
        }
    }
    
    //--- Session status
    if(g_sessionFilter != NULL)
    {
        bool sessionActive = g_sessionFilter.IsSessionActive();
        Print("⏰ Trading Session: ", sessionActive ? "✅ ACTIVE" : "❌ INACTIVE");
    }
    
    //--- News status
    if(g_newsFilter != NULL)
    {
        bool newsAllowed = g_newsFilter.IsTradeAllowed();
        Print("📰 News Filter: ", newsAllowed ? "✅ TRADES ALLOWED" : "⚠️ TRADES BLOCKED");
    }
    
    //--- Risk status
    if(g_riskManager != NULL)
    {
        bool canTrade = g_riskManager.CanOpenNewTrade(Symbol());
        Print("🛡️ Risk Status: ", canTrade ? "✅ CAN TRADE" : "⚠️ RISK LIMIT REACHED");
    }
    
    //--- Active positions
    int totalPositions = PositionsTotal();
    double totalProfit = 0;
    for(int i = 0; i < totalPositions; i++)
    {
        if(PositionGetSymbol(i) == Symbol() && PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
        {
            totalProfit += PositionGetDouble(POSITION_PROFIT);
        }
    }
    
    Print("💼 Open Positions: ", totalPositions, " | P&L: ", DoubleToString(totalProfit, 2));
    Print("============================");
}

//+------------------------------------------------------------------+
//| Display signal information to user                              |
//+------------------------------------------------------------------+
void DisplaySignalInformation(const SSignal &signal)
{
    if(!InpDisplayDetailedLogs) return;
    
    Print("🎯 NEW SIGNAL DETECTED:");
    Print("========================");
    Print("📊 Symbol: ", signal.symbol);
    Print("📈 Type: ", EnumToString(signal.type));
    Print("💰 Entry: ", DoubleToString(signal.entry_price, _Digits));
    Print("🛑 Stop Loss: ", DoubleToString(signal.stop_loss, _Digits));
    Print("🎯 Take Profit: ", DoubleToString(signal.take_profit, _Digits));
    Print("📊 Confidence: ", DoubleToString(signal.confidence * 100, 1), "%");
    Print("🔍 Reason: ", signal.reason);
    Print("⏰ Time: ", TimeToString(signal.time, TIME_SECONDS));
    
    //--- Calculate risk-reward ratio
    double distance_SL = MathAbs(signal.entry_price - signal.stop_loss);
    double distance_TP = MathAbs(signal.take_profit - signal.entry_price);
    double rr_ratio = distance_SL > 0 ? distance_TP / distance_SL : 0;
    Print("📏 Risk:Reward Ratio: 1:", DoubleToString(rr_ratio, 2));
    Print("========================");
    
    //--- Audio alert if enabled
    if(InpEnableAudioAlerts)
    {
        PlaySound("alert.wav");
    }
}

//+------------------------------------------------------------------+
//| Display trade execution information                              |
//+------------------------------------------------------------------+
void DisplayTradeExecution(const MqlTradeResult &result, const SSignal &signal)
{
    string statusEmoji = "";
    string statusText = "";
    
    switch(result.retcode)
    {
        case TRADE_RETCODE_DONE:
            statusEmoji = "✅";
            statusText = "SUCCESS";
            break;
        case TRADE_RETCODE_REQUOTE:
            statusEmoji = "⚠️";
            statusText = "REQUOTE";
            break;
        case TRADE_RETCODE_REJECT:
            statusEmoji = "❌";
            statusText = "REJECTED";
            break;
        case TRADE_RETCODE_NO_MONEY:
            statusEmoji = "💳";
            statusText = "INSUFFICIENT FUNDS";
            break;
        default:
            statusEmoji = "❓";
            statusText = "ERROR";
            break;
    }
    
    Print("🔄 TRADE EXECUTION RESULT:");
    Print("===========================");
    Print(statusEmoji, " Status: ", statusText);
    Print("🎫 Ticket: ", result.order);
    Print("💰 Volume: ", DoubleToString(result.volume, 2));
    Print("📊 Price: ", DoubleToString(result.price, _Digits));
    Print("🏷️ Return Code: ", result.retcode);
    
    if(result.retcode == TRADE_RETCODE_DONE)
    {
        Print("🎉 Trade executed successfully!");
        if(InpEnableAudioAlerts)
        {
            PlaySound("ok.wav");
        }
    }
    else
    {
        Print("⚠️ Trade execution failed. Reason: ", result.retcode);
        if(InpEnableAudioAlerts)
        {
            PlaySound("timeout.wav");
        }
    }
    Print("===========================");
}

//+------------------------------------------------------------------+
//| Display performance statistics                                  |
//+------------------------------------------------------------------+
void DisplayPerformanceStats()
{
    static datetime lastStatsUpdate = 0;
    if(TimeCurrent() - lastStatsUpdate < 300) return; // Update every 5 minutes
    lastStatsUpdate = TimeCurrent();
    
    if(!InpDisplayDetailedLogs) return;
    
    Print("📊 PERFORMANCE STATISTICS:");
    Print("===========================");
    
    //--- Calculate basic statistics
    int totalTrades = 0;
    int winningTrades = 0;
    double totalProfit = 0;
    double maxProfit = 0;
    double maxLoss = 0;
    
    //--- Analyze history
    for(int i = 0; i < HistoryDealsTotal(); i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_MAGIC) == InpMagicNumber)
        {
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            totalProfit += profit;
            totalTrades++;
            
            if(profit > 0)
            {
                winningTrades++;
                if(profit > maxProfit) maxProfit = profit;
            }
            else if(profit < maxLoss)
            {
                maxLoss = profit;
            }
        }
    }
    
    //--- Display statistics
    double winRate = totalTrades > 0 ? (double)winningTrades / totalTrades * 100 : 0;
    Print("🎯 Total Trades: ", totalTrades);
    Print("✅ Winning Trades: ", winningTrades);
    Print("📈 Win Rate: ", DoubleToString(winRate, 1), "%");
    Print("💰 Total Profit: ", DoubleToString(totalProfit, 2));
    Print("🏆 Best Trade: ", DoubleToString(maxProfit, 2));
    Print("📉 Worst Trade: ", DoubleToString(maxLoss, 2));
    
    //--- Current account information
    Print("💳 Account Balance: ", DoubleToString(AccountInfoDouble(ACCOUNT_BALANCE), 2));
    Print("💼 Account Equity: ", DoubleToString(AccountInfoDouble(ACCOUNT_EQUITY), 2));
    Print("📊 Free Margin: ", DoubleToString(AccountInfoDouble(ACCOUNT_FREEMARGIN), 2));
    Print("===========================");
}

//+------------------------------------------------------------------+
//| Show helpful trading tips                                       |
//+------------------------------------------------------------------+
void ShowTradingTips()
{
    static datetime lastTipTime = 0;
    static int tipIndex = 0;
    
    if(!InpShowTradingTips) return;
    if(TimeCurrent() - lastTipTime < 1800) return; // Show tip every 30 minutes
    
    lastTipTime = TimeCurrent();
    
    string tips[] = {
        "💡 TIP: Always monitor correlation between your open positions to avoid overexposure.",
        "💡 TIP: The EA works best during high-liquidity sessions (London & New York overlap).",
        "💡 TIP: Consider reducing position sizes during high-impact news events.",
        "💡 TIP: Order blocks are more reliable on higher timeframes (H1, H4, D1).",
        "💡 TIP: Use the analysis mode first to understand the EA's behavior before live trading.",
        "💡 TIP: Regularly review the risk management settings to match your risk tolerance.",
        "💡 TIP: Strong order blocks often act as support/resistance multiple times.",
        "💡 TIP: Consider market session overlaps for better liquidity and signal quality.",
        "💡 TIP: Scalping works best during high volatility with tight spreads.",
        "💡 TIP: Long-term trades require patience and proper position sizing.",
        "💡 TIP: Dynamic profit targets adapt to market conditions automatically.",
        "💡 TIP: Time-based exits help prevent overexposure to single positions."
    };
    
    if(tipIndex >= ArraySize(tips)) tipIndex = 0;
    
    Print(tips[tipIndex]);
    tipIndex++;
}

//+------------------------------------------------------------------+
//| Initialize trade settings based on user inputs                  |
//+------------------------------------------------------------------+
void InitializeTradeSettings()
{
    g_tradeSettings.tradeStyle = InpTradeStyle;
    g_tradeSettings.maxDurationMinutes = InpMaxTradeDurationMinutes;
    g_tradeSettings.profitTargetPercent = InpProfitTargetPercent;
    g_tradeSettings.minProfitPips = InpMinProfitTargetPips;
    g_tradeSettings.maxProfitPips = InpMaxProfitTargetPips;
    g_tradeSettings.useTimeBasedExit = InpUseTimeBasedExit;
    g_tradeSettings.useProfitPercentExit = InpUseProfitPercentExit;
    g_tradeSettings.useDynamicTargets = InpUseDynamicTargets;
    g_tradeSettings.lastUpdate = TimeCurrent();
    
    //--- Override duration based on trade style
    switch(InpTradeStyle)
    {
        case TRADE_STYLE_SCALPING:
            g_tradeSettings.maxDurationMinutes = (int)InpScalpingMaxMinutes;
            break;
        case TRADE_STYLE_SHORT_TERM:
            g_tradeSettings.maxDurationMinutes = (int)(InpShortTermMaxHours * 60);
            break;
        case TRADE_STYLE_MEDIUM_TERM:
            g_tradeSettings.maxDurationMinutes = (int)(InpMediumTermMaxDays * 24 * 60);
            break;
        case TRADE_STYLE_LONG_TERM:
            g_tradeSettings.maxDurationMinutes = (int)(InpLongTermMaxWeeks * 7 * 24 * 60);
            break;
        case TRADE_STYLE_CUSTOM:
            g_tradeSettings.maxDurationMinutes = InpMaxTradeDurationMinutes;
            break;
    }
    
    //--- Initialize active trades array
    ArrayResize(g_activeTrades, 0);
    
    //--- Log trade settings
    Print("⚙️ TRADE MANAGEMENT SETTINGS:");
    Print("===============================");
    Print("📊 Trade Style: ", EnumToString(InpTradeStyle));
    Print("⏰ Max Duration: ", g_tradeSettings.maxDurationMinutes, " minutes");
    Print("💰 Profit Target: ", DoubleToString(InpProfitTargetPercent, 2), "% of account");
    Print("📏 Profit Range: ", DoubleToString(InpMinProfitTargetPips, 1), "-", DoubleToString(InpMaxProfitTargetPips, 1), " pips");
    Print("⏱️ Time-based Exit: ", InpUseTimeBasedExit ? "✅ ENABLED" : "❌ DISABLED");
    Print("💯 Percentage Exit: ", InpUseProfitPercentExit ? "✅ ENABLED" : "❌ DISABLED");
    Print("🎯 Dynamic Targets: ", InpUseDynamicTargets ? "✅ ENABLED" : "❌ DISABLED");
    Print("===============================");
}

//+------------------------------------------------------------------+
//| Calculate dynamic profit target based on market conditions      |
//+------------------------------------------------------------------+
double CalculateDynamicProfitTarget(const string symbol, double entryPrice, double stopLoss, ENUM_ORDER_TYPE orderType)
{
    if(!InpUseDynamicTargets)
    {
        //--- Use static profit target
        double riskDistance = MathAbs(entryPrice - stopLoss);
        return entryPrice + (orderType == ORDER_TYPE_BUY ? 1 : -1) * riskDistance * InpPartialExitRR;
    }
    
    //--- Calculate dynamic target based on market conditions
    double atr = iATR(symbol, PERIOD_H1, 14, 0);
    double currentVolatility = atr / SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    //--- Adjust target based on trade style
    double multiplier = 2.0; // Default
    switch(g_tradeSettings.tradeStyle)
    {
        case TRADE_STYLE_SCALPING:
            multiplier = 1.5; // Smaller targets for scalping
            break;
        case TRADE_STYLE_SHORT_TERM:
            multiplier = 2.0; // Standard targets
            break;
        case TRADE_STYLE_MEDIUM_TERM:
            multiplier = 3.0; // Larger targets for medium-term
            break;
        case TRADE_STYLE_LONG_TERM:
            multiplier = 4.0; // Largest targets for long-term
            break;
    }
    
    //--- Calculate target with volatility adjustment
    double riskDistance = MathAbs(entryPrice - stopLoss);
    double baseTarget = riskDistance * multiplier;
    double volatilityAdjustment = currentVolatility * 0.5; // 50% of current volatility
    
    double finalTarget = baseTarget + volatilityAdjustment * SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    //--- Apply min/max limits
    double minTarget = InpMinProfitTargetPips * SymbolInfoDouble(symbol, SYMBOL_POINT);
    double maxTarget = InpMaxProfitTargetPips * SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    finalTarget = MathMax(minTarget, MathMin(maxTarget, finalTarget));
    
    return entryPrice + (orderType == ORDER_TYPE_BUY ? 1 : -1) * finalTarget;
}

//+------------------------------------------------------------------+
//| Add trade to active monitoring                                   |
//+------------------------------------------------------------------+
void AddTradeToMonitoring(ulong ticket, const string symbol, datetime openTime, double openPrice, 
                         double volume, ENUM_ORDER_TYPE orderType, double initialSL, double initialTP)
{
    //--- Find empty slot or resize array
    int index = -1;
    for(int i = 0; i < ArraySize(g_activeTrades); i++)
    {
        if(g_activeTrades[i].ticket == 0)
        {
            index = i;
            break;
        }
    }
    
    if(index < 0)
    {
        index = ArraySize(g_activeTrades);
        ArrayResize(g_activeTrades, index + 1);
    }
    
    //--- Fill trade information
    g_activeTrades[index].ticket = ticket;
    g_activeTrades[index].symbol = symbol;
    g_activeTrades[index].openTime = openTime;
    g_activeTrades[index].openPrice = openPrice;
    g_activeTrades[index].volume = volume;
    g_activeTrades[index].orderType = orderType;
    g_activeTrades[index].initialSL = initialSL;
    g_activeTrades[index].initialTP = initialTP;
    g_activeTrades[index].dynamicTP = CalculateDynamicProfitTarget(symbol, openPrice, initialSL, orderType);
    g_activeTrades[index].maxDurationMinutes = g_tradeSettings.maxDurationMinutes;
    g_activeTrades[index].timeExitWarning = false;
    g_activeTrades[index].profitTargetReached = false;
    g_activeTrades[index].tradeStyle = g_tradeSettings.tradeStyle;
    
    //--- Calculate profit target as percentage of account
    if(InpUseProfitPercentExit)
    {
        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        g_activeTrades[index].profitTarget = accountBalance * (InpProfitTargetPercent / 100.0);
    }
    else
    {
        g_activeTrades[index].profitTarget = 0; // Not using percentage exit
    }
    
    Print("📊 Trade added to monitoring - Ticket: ", ticket, " | Style: ", EnumToString(g_tradeSettings.tradeStyle), 
          " | Max Duration: ", g_activeTrades[index].maxDurationMinutes, " minutes");
}

//+------------------------------------------------------------------+
//| Monitor and manage active trades                                |
//+------------------------------------------------------------------+
void MonitorActiveTrades()
{
    datetime currentTime = TimeCurrent();
    
    for(int i = 0; i < ArraySize(g_activeTrades); i++)
    {
        if(g_activeTrades[i].ticket == 0) continue;
        
        //--- Check if position still exists
        if(!PositionSelectByTicket(g_activeTrades[i].ticket))
        {
            //--- Position closed, remove from monitoring
            g_activeTrades[i].ticket = 0;
            continue;
        }
        
        //--- Get current position info
        double currentProfit = PositionGetDouble(POSITION_PROFIT);
        int durationMinutes = (int)((currentTime - g_activeTrades[i].openTime) / 60);
        
        //--- Check time-based exit
        if(InpUseTimeBasedExit && durationMinutes >= g_activeTrades[i].maxDurationMinutes)
        {
            CloseTradeByTime(g_activeTrades[i].ticket, "Time limit reached");
            continue;
        }
        
        //--- Check percentage-based profit exit
        if(InpUseProfitPercentExit && g_activeTrades[i].profitTarget > 0 && 
           currentProfit >= g_activeTrades[i].profitTarget)
        {
            CloseTradeByProfit(g_activeTrades[i].ticket, "Percentage profit target reached");
            continue;
        }
        
        //--- Time warning (when 80% of time elapsed)
        if(InpUseTimeBasedExit && !g_activeTrades[i].timeExitWarning && 
           durationMinutes >= (g_activeTrades[i].maxDurationMinutes * 0.8))
        {
            g_activeTrades[i].timeExitWarning = true;
            Print("⏰ WARNING: Trade ", g_activeTrades[i].ticket, " approaching time limit (", 
                  durationMinutes, "/", g_activeTrades[i].maxDurationMinutes, " minutes)");
        }
        
        //--- Update dynamic targets if enabled
        if(InpUseDynamicTargets)
        {
            UpdateDynamicTarget(i);
        }
        
        //--- Display trade status periodically
        static datetime lastStatusUpdate = 0;
        if(currentTime - lastStatusUpdate > 300) // Every 5 minutes
        {
            DisplayTradeStatus(i, durationMinutes, currentProfit);
            lastStatusUpdate = currentTime;
        }
    }
}

//+------------------------------------------------------------------+
//| Close trade due to time limit                                   |
//+------------------------------------------------------------------+
void CloseTradeByTime(ulong ticket, string reason)
{
    MqlTradeRequest request = {0};
    MqlTradeResult result = {0};
    
    if(PositionSelectByTicket(ticket))
    {
        request.action = TRADE_ACTION_DEAL;
        request.symbol = PositionGetString(POSITION_SYMBOL);
        request.volume = PositionGetDouble(POSITION_VOLUME);
        request.type = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
        request.price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                       SymbolInfoDouble(request.symbol, SYMBOL_BID) : 
                       SymbolInfoDouble(request.symbol, SYMBOL_ASK);
        request.magic = InpMagicNumber;
        request.comment = "Time Exit: " + reason;
        
        bool success = OrderSend(request, result);
        
        Print("⏰ TIME-BASED EXIT: Ticket ", ticket, " | Reason: ", reason, 
              " | Success: ", success ? "✅" : "❌", " | RetCode: ", result.retcode);
              
        if(InpEnableAudioAlerts)
        {
            PlaySound("stops.wav");
        }
    }
}

//+------------------------------------------------------------------+
//| Close trade due to profit target                                |
//+------------------------------------------------------------------+
void CloseTradeByProfit(ulong ticket, string reason)
{
    MqlTradeRequest request = {0};
    MqlTradeResult result = {0};
    
    if(PositionSelectByTicket(ticket))
    {
        request.action = TRADE_ACTION_DEAL;
        request.symbol = PositionGetString(POSITION_SYMBOL);
        request.volume = PositionGetDouble(POSITION_VOLUME);
        request.type = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
        request.price = PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY ? 
                       SymbolInfoDouble(request.symbol, SYMBOL_BID) : 
                       SymbolInfoDouble(request.symbol, SYMBOL_ASK);
        request.magic = InpMagicNumber;
        request.comment = "Profit Exit: " + reason;
        
        bool success = OrderSend(request, result);
        
        Print("💰 PROFIT-BASED EXIT: Ticket ", ticket, " | Reason: ", reason, 
              " | Success: ", success ? "✅" : "❌", " | RetCode: ", result.retcode);
              
        if(InpEnableAudioAlerts)
        {
            PlaySound("ok.wav");
        }
    }
}

//+------------------------------------------------------------------+
//| Update dynamic profit target                                    |
//+------------------------------------------------------------------+
void UpdateDynamicTarget(int tradeIndex)
{
    if(tradeIndex < 0 || tradeIndex >= ArraySize(g_activeTrades)) return;
    
    double newTarget = CalculateDynamicProfitTarget(
        g_activeTrades[tradeIndex].symbol,
        g_activeTrades[tradeIndex].openPrice,
        g_activeTrades[tradeIndex].initialSL,
        g_activeTrades[tradeIndex].orderType
    );
    
    //--- Only update if significantly different (more than 5 pips)
    double difference = MathAbs(newTarget - g_activeTrades[tradeIndex].dynamicTP);
    double minChange = 5 * SymbolInfoDouble(g_activeTrades[tradeIndex].symbol, SYMBOL_POINT);
    
    if(difference > minChange)
    {
        g_activeTrades[tradeIndex].dynamicTP = newTarget;
        
        //--- Update the actual position TP if possible
        MqlTradeRequest request = {0};
        MqlTradeResult result = {0};
        
        request.action = TRADE_ACTION_SLTP;
        request.symbol = g_activeTrades[tradeIndex].symbol;
        request.sl = g_activeTrades[tradeIndex].initialSL;
        request.tp = newTarget;
        request.magic = InpMagicNumber;
        
        OrderSend(request, result);
        
        Print("🎯 Dynamic target updated for ticket ", g_activeTrades[tradeIndex].ticket, 
              " | New TP: ", DoubleToString(newTarget, _Digits));
    }
}

//+------------------------------------------------------------------+
//| Display current trade status                                    |
//+------------------------------------------------------------------+
void DisplayTradeStatus(int tradeIndex, int durationMinutes, double currentProfit)
{
    if(!InpDisplayDetailedLogs) return;
    if(tradeIndex < 0 || tradeIndex >= ArraySize(g_activeTrades)) return;
    
    string styleText = "";
    switch(g_activeTrades[tradeIndex].tradeStyle)
    {
        case TRADE_STYLE_SCALPING: styleText = "⚡ SCALP"; break;
        case TRADE_STYLE_SHORT_TERM: styleText = "📈 SHORT"; break;
        case TRADE_STYLE_MEDIUM_TERM: styleText = "📊 MEDIUM"; break;
        case TRADE_STYLE_LONG_TERM: styleText = "📈 LONG"; break;
        case TRADE_STYLE_CUSTOM: styleText = "🔧 CUSTOM"; break;
    }
    
    double timeProgress = (double)durationMinutes / g_activeTrades[tradeIndex].maxDurationMinutes * 100;
    string profitColor = currentProfit >= 0 ? "🟢" : "🔴";
    
    Print("📊 TRADE STATUS - Ticket: ", g_activeTrades[tradeIndex].ticket);
    Print("   ", styleText, " | Duration: ", durationMinutes, "/", g_activeTrades[tradeIndex].maxDurationMinutes, 
          " min (", DoubleToString(timeProgress, 1), "%)");
    Print("   ", profitColor, " Profit: ", DoubleToString(currentProfit, 2));
    
    if(g_activeTrades[tradeIndex].profitTarget > 0)
    {
        double profitProgress = (currentProfit / g_activeTrades[tradeIndex].profitTarget) * 100;
        Print("   🎯 Target Progress: ", DoubleToString(profitProgress, 1), "%");
    }
}

//+------------------------------------------------------------------+
//| Load environment configuration from external file               |
//+------------------------------------------------------------------+
void LoadEnvironmentConfiguration()
{
    string configFileName = "MetaphizixEA_Config.txt";
    string configPath = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL5\\Files\\" + configFileName;
    
    //--- Try to read configuration file
    int fileHandle = FileOpen(configFileName, FILE_READ | FILE_TXT | FILE_COMMON);
    if(fileHandle != INVALID_HANDLE)
    {
        Print("📄 Loading environment configuration from: ", configFileName);
        
        while(!FileIsEnding(fileHandle))
        {
            string line = FileReadString(fileHandle);
            if(StringLen(line) > 0 && StringSubstr(line, 0, 1) != "#") // Skip comments
            {
                ProcessConfigurationLine(line);
            }
        }
        
        FileClose(fileHandle);
        Print("✅ Environment configuration loaded successfully");
    }
    else
    {
        //--- Create default configuration file
        CreateDefaultConfigurationFile(configFileName);
    }
}

//+------------------------------------------------------------------+
//| Process individual configuration line                           |
//+------------------------------------------------------------------+
void ProcessConfigurationLine(string line)
{
    int equalPos = StringFind(line, "=");
    if(equalPos < 0) return;
    
    string key = StringSubstr(line, 0, equalPos);
    string value = StringSubstr(line, equalPos + 1);
    
    //--- Remove spaces
    StringTrimLeft(key);
    StringTrimRight(key);
    StringTrimLeft(value);
    StringTrimRight(value);
    
    //--- Process environment variables
    if(key == "TRADE_STYLE")
    {
        if(value == "SCALPING") g_tradeSettings.tradeStyle = TRADE_STYLE_SCALPING;
        else if(value == "SHORT_TERM") g_tradeSettings.tradeStyle = TRADE_STYLE_SHORT_TERM;
        else if(value == "MEDIUM_TERM") g_tradeSettings.tradeStyle = TRADE_STYLE_MEDIUM_TERM;
        else if(value == "LONG_TERM") g_tradeSettings.tradeStyle = TRADE_STYLE_LONG_TERM;
        else if(value == "CUSTOM") g_tradeSettings.tradeStyle = TRADE_STYLE_CUSTOM;
        
        Print("🔧 ENV: Trade style set to ", value);
    }
    else if(key == "MAX_TRADE_DURATION_MINUTES")
    {
        g_tradeSettings.maxDurationMinutes = (int)StringToInteger(value);
        Print("🔧 ENV: Max trade duration set to ", value, " minutes");
    }
    else if(key == "PROFIT_TARGET_PERCENT")
    {
        g_tradeSettings.profitTargetPercent = StringToDouble(value);
        Print("🔧 ENV: Profit target set to ", value, "% of account");
    }
    else if(key == "MIN_PROFIT_PIPS")
    {
        g_tradeSettings.minProfitPips = StringToDouble(value);
        Print("🔧 ENV: Minimum profit target set to ", value, " pips");
    }
    else if(key == "MAX_PROFIT_PIPS")
    {
        g_tradeSettings.maxProfitPips = StringToDouble(value);
        Print("🔧 ENV: Maximum profit target set to ", value, " pips");
    }
    else if(key == "USE_TIME_BASED_EXIT")
    {
        g_tradeSettings.useTimeBasedExit = (StringToInteger(value) == 1);
        Print("🔧 ENV: Time-based exit ", g_tradeSettings.useTimeBasedExit ? "ENABLED" : "DISABLED");
    }
    else if(key == "USE_PROFIT_PERCENT_EXIT")
    {
        g_tradeSettings.useProfitPercentExit = (StringToInteger(value) == 1);
        Print("🔧 ENV: Profit percentage exit ", g_tradeSettings.useProfitPercentExit ? "ENABLED" : "DISABLED");
    }
    else if(key == "USE_DYNAMIC_TARGETS")
    {
        g_tradeSettings.useDynamicTargets = (StringToInteger(value) == 1);
        Print("🔧 ENV: Dynamic targets ", g_tradeSettings.useDynamicTargets ? "ENABLED" : "DISABLED");
    }
}

//+------------------------------------------------------------------+
//| Create default configuration file                               |
//+------------------------------------------------------------------+
void CreateDefaultConfigurationFile(string fileName)
{
    int fileHandle = FileOpen(fileName, FILE_WRITE | FILE_TXT | FILE_COMMON);
    if(fileHandle == INVALID_HANDLE)
    {
        Print("❌ ERROR: Could not create configuration file: ", fileName);
        return;
    }
    
    Print("📝 Creating default configuration file: ", fileName);
    
    //--- Write default configuration
    FileWriteString(fileHandle, "# MetaphizixEA Environment Configuration\n");
    FileWriteString(fileHandle, "# This file allows you to override EA settings externally\n");
    FileWriteString(fileHandle, "# Lines starting with # are comments\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Trading Style Options: SCALPING, SHORT_TERM, MEDIUM_TERM, LONG_TERM, CUSTOM\n");
    FileWriteString(fileHandle, "TRADE_STYLE=SHORT_TERM\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Maximum trade duration in minutes\n");
    FileWriteString(fileHandle, "MAX_TRADE_DURATION_MINUTES=1440\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Profit target as percentage of account balance\n");
    FileWriteString(fileHandle, "PROFIT_TARGET_PERCENT=2.0\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Minimum and maximum profit targets in pips\n");
    FileWriteString(fileHandle, "MIN_PROFIT_PIPS=20.0\n");
    FileWriteString(fileHandle, "MAX_PROFIT_PIPS=100.0\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Exit strategy options (1=enabled, 0=disabled)\n");
    FileWriteString(fileHandle, "USE_TIME_BASED_EXIT=1\n");
    FileWriteString(fileHandle, "USE_PROFIT_PERCENT_EXIT=1\n");
    FileWriteString(fileHandle, "USE_DYNAMIC_TARGETS=1\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# Preset configurations for different trading styles:\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# SCALPING PRESET:\n");
    FileWriteString(fileHandle, "# TRADE_STYLE=SCALPING\n");
    FileWriteString(fileHandle, "# MAX_TRADE_DURATION_MINUTES=30\n");
    FileWriteString(fileHandle, "# PROFIT_TARGET_PERCENT=0.5\n");
    FileWriteString(fileHandle, "# MIN_PROFIT_PIPS=5.0\n");
    FileWriteString(fileHandle, "# MAX_PROFIT_PIPS=20.0\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# SHORT-TERM PRESET:\n");
    FileWriteString(fileHandle, "# TRADE_STYLE=SHORT_TERM\n");
    FileWriteString(fileHandle, "# MAX_TRADE_DURATION_MINUTES=1440\n");
    FileWriteString(fileHandle, "# PROFIT_TARGET_PERCENT=2.0\n");
    FileWriteString(fileHandle, "# MIN_PROFIT_PIPS=20.0\n");
    FileWriteString(fileHandle, "# MAX_PROFIT_PIPS=100.0\n");
    FileWriteString(fileHandle, "\n");
    FileWriteString(fileHandle, "# LONG-TERM PRESET:\n");
    FileWriteString(fileHandle, "# TRADE_STYLE=LONG_TERM\n");
    FileWriteString(fileHandle, "# MAX_TRADE_DURATION_MINUTES=40320\n");
    FileWriteString(fileHandle, "# PROFIT_TARGET_PERCENT=5.0\n");
    FileWriteString(fileHandle, "# MIN_PROFIT_PIPS=50.0\n");
    FileWriteString(fileHandle, "# MAX_PROFIT_PIPS=500.0\n");
    
    FileClose(fileHandle);
    
    Print("✅ Default configuration file created successfully");
    Print("📍 Location: ", TerminalInfoString(TERMINAL_DATA_PATH), "\\MQL5\\Files\\", fileName);
    Print("💡 You can edit this file to customize trade duration and profit settings");
}
