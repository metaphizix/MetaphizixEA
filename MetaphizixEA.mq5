//+------------------------------------------------------------------+
//|                                                 MetaphizixEA.mq5 |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"
#property version   "2.00"
#property description "Modular Order Block Detection EA with Multi-Pair Analysis"

//--- Include modular components
#include "Includes/Config.mqh"
#include "Includes/OrderBlockDetector.mqh"
#include "Includes/PairManager.mqh"
#include "Includes/SignalManager.mqh"
#include "Includes/DisplayManager.mqh"

//--- Input parameters
input group "=== Trading Pairs ==="
input string InpTradingPairs = "EURUSD,GBPUSD,USDJPY,USDCHF,AUDUSD,USDCAD,NZDUSD,EURJPY,GBPJPY,EURGBP"; // Trading Pairs (comma separated)
input int InpMaxConcurrentPairs = 3; // Maximum concurrent pairs to analyze

input group "=== Order Block Settings ==="
input int InpOrderBlockLookback = 50; // Order block lookback period
input double InpMinOrderBlockSize = 10; // Minimum order block size in pips
input int InpOrderBlockConfirmation = 3; // Number of candles for confirmation

input group "=== Display Settings ==="
input bool InpShowEntryPoints = true; // Show entry points on chart
input bool InpShowExitPoints = true; // Show exit points on chart
input color InpBullishEntryColor = clrLime; // Bullish entry point color
input color InpBearishEntryColor = clrRed; // Bearish entry point color
input color InpExitColor = clrYellow; // Exit point color

input group "=== System Settings ==="
input int InpTimerInterval = 5; // Timer interval in seconds
input bool InpEnableLogging = true; // Enable detailed logging

//--- Global objects
COrderBlockDetector* g_orderBlockDetector = NULL;
CPairManager* g_pairManager = NULL;
CSignalManager* g_signalManager = NULL;
CDisplayManager* g_displayManager = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- Initialize logging
    if(InpEnableLogging)
    {
        Print("=== MetaphizixEA v2.00 Initialization ===");
        Print("Author: Metaphizix Ltd.");
        Print("GitHub: https://github.com/metaphizix/MetaphizixEA");
    }
    
    //--- Validate inputs
    if(!ValidateInputs())
    {
        Print("ERROR: Invalid input parameters");
        return(INIT_PARAMETERS_INCORRECT);
    }
    
    //--- Initialize configuration
    if(!CConfig::Initialize(InpTradingPairs, InpMaxConcurrentPairs, InpOrderBlockLookback, 
                           InpMinOrderBlockSize, InpOrderBlockConfirmation, InpTimerInterval, 
                           InpEnableLogging))
    {
        Print("ERROR: Failed to initialize configuration");
        return(INIT_FAILED);
    }
    
    //--- Create and initialize components
    g_orderBlockDetector = new COrderBlockDetector();
    g_pairManager = new CPairManager();
    g_signalManager = new CSignalManager();
    g_displayManager = new CDisplayManager();
    
    if(!g_orderBlockDetector || !g_pairManager || !g_signalManager || !g_displayManager)
    {
        Print("ERROR: Failed to create component objects");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Initialize components
    if(!g_orderBlockDetector.Initialize() ||
       !g_pairManager.Initialize() ||
       !g_signalManager.Initialize() ||
       !g_displayManager.Initialize(InpShowEntryPoints, InpShowExitPoints, 
                                   InpBullishEntryColor, InpBearishEntryColor, InpExitColor))
    {
        Print("ERROR: Failed to initialize components");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Set references between components
    g_signalManager.SetOrderBlockDetector(g_orderBlockDetector);
    
    //--- Set timer
    EventSetTimer(InpTimerInterval);
    
    if(InpEnableLogging)
        Print("MetaphizixEA initialized successfully");
    
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
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
    //--- Process current symbol tick
    if(g_pairManager != NULL && g_orderBlockDetector != NULL)
    {
        g_pairManager.OnTick(_Symbol);
        
        //--- Check for new order blocks on current symbol
        if(g_orderBlockDetector.HasNewOrderBlock(_Symbol))
        {
            //--- Process the signal
            if(g_signalManager != NULL)
                g_signalManager.ProcessSignal(_Symbol);
                
            //--- Update display
            if(g_displayManager != NULL)
                g_displayManager.UpdateDisplay(_Symbol);
        }
    }
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
    //--- Analyze all pairs and select best opportunities
    if(g_pairManager != NULL)
    {
        g_pairManager.AnalyzeAllPairs();
        
        //--- Get best pairs to trade
        string bestPairs[];
        if(g_pairManager.GetBestPairs(bestPairs))
        {
            //--- Process each best pair
            for(int i = 0; i < ArraySize(bestPairs); i++)
            {
                if(g_orderBlockDetector != NULL)
                {
                    //--- Detect order blocks for this pair
                    g_orderBlockDetector.AnalyzePair(bestPairs[i]);
                    
                    //--- Process signals if any
                    if(g_signalManager != NULL && g_orderBlockDetector.HasNewOrderBlock(bestPairs[i]))
                    {
                        g_signalManager.ProcessSignal(bestPairs[i]);
                    }
                }
            }
            
            //--- Update display for all analyzed pairs
            if(g_displayManager != NULL)
                g_displayManager.UpdateAllDisplays(bestPairs);
        }
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
    //--- Check trading pairs
    if(StringLen(InpTradingPairs) == 0)
    {
        Print("ERROR: Trading pairs list cannot be empty");
        return false;
    }
    
    //--- Check max concurrent pairs
    if(InpMaxConcurrentPairs < 1 || InpMaxConcurrentPairs > 28)
    {
        Print("ERROR: Max concurrent pairs must be between 1 and 28");
        return false;
    }
    
    //--- Check order block settings
    if(InpOrderBlockLookback < 10 || InpOrderBlockLookback > 200)
    {
        Print("ERROR: Order block lookback must be between 10 and 200");
        return false;
    }
    
    if(InpMinOrderBlockSize < 5 || InpMinOrderBlockSize > 100)
    {
        Print("ERROR: Minimum order block size must be between 5 and 100 pips");
        return false;
    }
    
    if(InpOrderBlockConfirmation < 1 || InpOrderBlockConfirmation > 10)
    {
        Print("ERROR: Order block confirmation must be between 1 and 10 candles");
        return false;
    }
    
    //--- Check timer interval
    if(InpTimerInterval < 1 || InpTimerInterval > 60)
    {
        Print("ERROR: Timer interval must be between 1 and 60 seconds");
        return false;
    }
    
    return true;
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
}
