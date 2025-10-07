//+------------------------------------------------------------------+
//|                                                 MetaphizixEA.mq5 |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"
#property version   "3.00"
#property description "Advanced Modular EA with Order Block Detection, Multi-Pair Analysis & Risk Management"

//--- Include modular components
#include "Includes/Config.mqh"
#include "Includes/OrderBlockDetector.mqh"
#include "Includes/PairManager.mqh"
#include "Includes/SignalManager.mqh"
#include "Includes/DisplayManager.mqh"
#include "Includes/RiskManagement.mqh"
#include "Includes/TradeExecution.mqh"
#include "Includes/NewsFilter.mqh"
#include "Includes/SessionFilter.mqh"
#include "Includes/ExitStrategy.mqh"

//--- Input parameters
input group "=== Trading Pairs ==="
input string InpTradingPairs = "EURUSD,GBPUSD,USDJPY,USDCHF,AUDUSD,USDCAD,NZDUSD,EURJPY,GBPJPY,EURGBP"; // Trading Pairs (comma separated)
input int InpMaxConcurrentPairs = 3; // Maximum concurrent pairs to analyze

input group "=== Order Block Settings ==="
input int InpOrderBlockLookback = 50; // Order block lookback period
input double InpMinOrderBlockSize = 10; // Minimum order block size in pips
input int InpOrderBlockConfirmation = 3; // Number of candles for confirmation

input group "=== Risk Management ==="
input double InpAccountRiskPercent = 1.0; // Risk percentage per trade
input int InpMaxOpenTrades = 10; // Maximum open trades allowed
input double InpCorrelationThreshold = 0.8; // Correlation threshold for portfolio management

input group "=== Trading Controls ==="
input bool InpEnableAutoTrading = false; // Enable automatic trade execution
input double InpATRMultiplier = 1.5; // ATR multiplier for trailing stops
input double InpBreakEvenBuffer = 10; // Buffer in pips for break-even
input double InpPartialExitRR = 2.0; // Risk-reward ratio for partial exit

input group "=== News & Session Filters ==="
input int InpNewsImpactThreshold = 3; // High-impact news threshold (1-3)
input int InpSessionStartHour = 9; // Start hour for trading session (SAST)
input int InpSessionEndHour = 22; // End hour for trading session (SAST)
input bool InpEnableNewsFilter = true; // Enable news filtering
input bool InpEnableSessionFilter = true; // Enable session filtering

input group "=== Display Settings ==="
input bool InpShowEntryPoints = true; // Show entry points on chart
input bool InpShowExitPoints = true; // Show exit points on chart
input color InpBullishEntryColor = clrLime; // Bullish entry point color
input color InpBearishEntryColor = clrRed; // Bearish entry point color
input color InpExitColor = clrYellow; // Exit point color

input group "=== System Settings ==="
input int InpTimerInterval = 5; // Timer interval in seconds
input bool InpEnableLogging = true; // Enable detailed logging
input int InpMagicNumber = 12345; // Magic number for trades

//--- Global objects
COrderBlockDetector* g_orderBlockDetector = NULL;
CPairManager* g_pairManager = NULL;
CSignalManager* g_signalManager = NULL;
CDisplayManager* g_displayManager = NULL;
CRiskManagement* g_riskManager = NULL;
CTradeExecution* g_tradeExecutor = NULL;
CNewsFilter* g_newsFilter = NULL;
CSessionFilter* g_sessionFilter = NULL;
CExitStrategy* g_exitStrategy = NULL;

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

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    //--- Initialize logging
    if(InpEnableLogging)
    {
        Print("=== MetaphizixEA v3.00 Initialization ===");
        Print("Author: Metaphizix Ltd.");
        Print("GitHub: https://github.com/metaphizix/MetaphizixEA");
        Print("Auto Trading: ", InpEnableAutoTrading ? "ENABLED" : "DISABLED (Display Only)");
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
    g_riskManager = new CRiskManagement();
    g_tradeExecutor = new CTradeExecution();
    g_newsFilter = new CNewsFilter();
    g_sessionFilter = new CSessionFilter();
    g_exitStrategy = new CExitStrategy();
    
    if(!g_orderBlockDetector || !g_pairManager || !g_signalManager || !g_displayManager ||
       !g_riskManager || !g_tradeExecutor || !g_newsFilter || !g_sessionFilter || !g_exitStrategy)
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
                                   InpBullishEntryColor, InpBearishEntryColor, InpExitColor) ||
       !g_riskManager.Initialize(InpAccountRiskPercent, InpMaxOpenTrades, InpCorrelationThreshold) ||
       !g_tradeExecutor.Initialize(InpMagicNumber, "MetaphizixEA") ||
       !g_newsFilter.Initialize(InpNewsImpactThreshold) ||
       !g_sessionFilter.Initialize(InpSessionStartHour, InpSessionEndHour) ||
       !g_exitStrategy.Initialize(InpATRMultiplier, InpBreakEvenBuffer, InpPartialExitRR))
    {
        Print("ERROR: Failed to initialize components");
        CleanupObjects();
        return(INIT_FAILED);
    }
    
    //--- Set references between components
    g_signalManager.SetOrderBlockDetector(g_orderBlockDetector);
    g_tradeExecutor.SetRiskManager(g_riskManager);
    
    //--- Set timer
    EventSetTimer(InpTimerInterval);
    
    if(InpEnableLogging)
    {
        Print("MetaphizixEA initialized successfully");
        Print("Components loaded: OrderBlock, PairManager, Signal, Display, Risk, Trade, News, Session, Exit");
        Print("Trading Mode: ", InpEnableAutoTrading ? "LIVE TRADING" : "ANALYSIS ONLY");
    }
    
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
            Print("WARNING: Components not initialized");
        return false;
    }
    
    //--- Check session filter
    if(!g_sessionFilter.IsSessionActive())
    {
        if(CConfig::IsLoggingEnabled())
            Print("INFO: Trading session not active");
        return false;
    }
    
    //--- Check news filter
    if(!g_newsFilter.IsTradeAllowed())
    {
        if(CConfig::IsLoggingEnabled())
            Print("INFO: News filter blocking trades");
        return false;
    }
    
    //--- Check if spread is acceptable
    double currentSpread = (Ask() - Bid()) / _Point;
    if(currentSpread > InpMaxSpread)
    {
        if(CConfig::IsLoggingEnabled())
            Print("INFO: Spread too high: ", currentSpread, " points");
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Update market data and pair information                         |
//+------------------------------------------------------------------+
bool UpdateMarketData()
{
    //--- Update pair manager
    if(!g_pairManager.UpdatePairData(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("ERROR: Failed to update pair data for ", Symbol());
        return false;
    }
    
    //--- Update order block detector
    if(!g_orderBlockDetector.UpdateMarketData(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("ERROR: Failed to update order block data for ", Symbol());
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Process signal analysis                                          |
//+------------------------------------------------------------------+
bool ProcessSignalAnalysis()
{
    //--- Analyze order blocks
    if(!g_orderBlockDetector.AnalyzeOrderBlocks(Symbol()))
    {
        if(CConfig::IsLoggingEnabled())
            Print("WARNING: Order block analysis failed for ", Symbol());
        return false;
    }
    
    //--- Update signal manager
    if(!g_signalManager.UpdateSignals(Symbol()))
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
        if(CConfig::IsLoggingEnabled())
            Print("INFO: Risk manager blocked new trade for ", Symbol());
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
        //--- Validate signal with risk management
        double positionSize = g_riskManager.CalculatePositionSize(
            signals[i].symbol, 
            signals[i].entry_price, 
            signals[i].stop_loss
        );
        
        if(positionSize > 0)
        {
            //--- Create trade request using built-in MQL5 structure
            MqlTradeRequest request = {0};
            MqlTradeResult result = {0};
            
            //--- Fill request structure
            request.action = TRADE_ACTION_DEAL;
            request.symbol = signals[i].symbol;
            request.volume = positionSize;
            request.price = signals[i].entry_price;
            request.sl = signals[i].stop_loss;
            request.tp = signals[i].take_profit;
            request.magic = InpMagicNumber;
            request.comment = "MetaphizixEA";
            
            //--- Set order type based on signal
            if(signals[i].type == SIGNAL_BUY)
            {
                request.type = ORDER_TYPE_BUY;
                request.price = SymbolInfoDouble(signals[i].symbol, SYMBOL_ASK);
            }
            else if(signals[i].type == SIGNAL_SELL)
            {
                request.type = ORDER_TYPE_SELL;
                request.price = SymbolInfoDouble(signals[i].symbol, SYMBOL_BID);
            }
            
            //--- Execute trade
            bool tradeResult = OrderSend(request, result);
            
            if(CConfig::IsLoggingEnabled())
            {
                Print("Trade execution ", tradeResult ? "SUCCESS" : "FAILED", 
                      " for ", signals[i].symbol, 
                      " Type: ", EnumToString(signals[i].type),
                      " Volume: ", positionSize,
                      " RetCode: ", result.retcode);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Manage existing positions                                        |
//+------------------------------------------------------------------+
void ManageExistingPositions()
{
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
                    Print("Position management - Ticket: ", ticket, 
                          " Profit: ", DoubleToString(currentProfit, 2),
                          " R:R: ", DoubleToString(currentRR, 2));
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
}
