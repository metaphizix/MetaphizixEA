//+------------------------------------------------------------------+
//|                                               TradeExecution.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"  // Must come first for ENUM_SIGNAL_TYPE and other enums
#include "RiskManagement.mqh"

//+------------------------------------------------------------------+
//| Trade execution enumerations                                    |
//+------------------------------------------------------------------+
enum ENUM_EXECUTION_TYPE
{
    EXECUTION_MARKET,       // Market execution
    EXECUTION_PENDING,      // Pending order
    EXECUTION_STOP,         // Stop order
    EXECUTION_LIMIT,        // Limit order
    EXECUTION_ICEBERG,      // Iceberg order
    EXECUTION_TWAP,         // Time-weighted average price
    EXECUTION_SMART         // Smart execution with slippage control
};

enum ENUM_ORDER_FILL
{
    FILL_OR_KILL,          // Fill or kill
    FILL_IOC,              // Immediate or cancel
    FILL_FOK,              // Fill or kill
    FILL_PARTIAL,          // Allow partial fills
    FILL_COMPLETE          // Complete fill only
};

enum ENUM_EXECUTION_STATUS
{
    EXEC_STATUS_PENDING,    // Order pending
    EXEC_STATUS_FILLED,     // Order filled
    EXEC_STATUS_PARTIAL,    // Partially filled
    EXEC_STATUS_REJECTED,   // Order rejected
    EXEC_STATUS_CANCELLED,  // Order cancelled
    EXEC_STATUS_ERROR       // Execution error
};

//+------------------------------------------------------------------+
//| Trade execution structures                                       |
//+------------------------------------------------------------------+
struct SExecutionConfig
{
    ENUM_EXECUTION_TYPE executionType;
    ENUM_ORDER_FILL fillType;
    double          maxSlippagePips;
    double          maxSpreadPips;
    int             maxRetries;
    int             retryDelayMs;
    bool            enablePartialFills;
    bool            smartExecution;
    double          minLiquidity;
    bool            priceImprovementEnabled;
};

struct SOrderRequest
{
    string          symbol;
    ENUM_ORDER_TYPE orderType;
    double          volume;
    double          price;
    double          stopLoss;
    double          takeProfit;
    double          confidence;
    string          comment;
    datetime        expiration;
    ENUM_EXECUTION_TYPE executionType;
};

struct SExecutionResult
{
    ulong           ticket;
    ENUM_EXECUTION_STATUS status;
    double          fillPrice;
    double          fillVolume;
    double          slippage;
    double          spread;
    string          errorMessage;
    datetime        executionTime;
    int             retriesUsed;
};

struct STradeMetrics
{
    int             totalTrades;
    int             successfulTrades;
    double          averageSlippage;
    double          averageSpread;
    double          averageFillTime;
    double          rejectionRate;
    datetime        lastUpdate;
};

//+------------------------------------------------------------------+
//| Advanced Trade execution class                                  |
//| Handles sophisticated order placement and execution management  |
//+------------------------------------------------------------------+
class CTradeExecution
{
private:
    // Core components
    CRiskManagement*  m_riskManager;
    SExecutionConfig  m_config;
    STradeMetrics     m_metrics;
    
    // Execution tracking
    SOrderRequest     m_pendingOrders[];
    SExecutionResult  m_executionHistory[];
    
    // Configuration
    int               m_magicNumber;
    string            m_comment;
    
    // Smart execution
    double            m_optimalSpread[];
    string            m_optimalSpreadSymbols[];
    datetime          m_lastSpreadUpdate;
    
    // Performance tracking
    double            m_slippageHistory[];
    double            m_spreadHistory[];
    int               m_executionTimes[];
    datetime          m_executionTimestamps[];
    
public:
    //--- Constructor/Destructor
    CTradeExecution();
    ~CTradeExecution();
    
    //--- Initialization and configuration
    bool Initialize(int magicNumber = 12345, const string comment = "MetaphizixEA");
    bool Initialize(const SExecutionConfig &config);
    void SetRiskManager(CRiskManagement* riskManager);
    void SetConfiguration(const SExecutionConfig &config);
    SExecutionConfig GetConfiguration() const { return m_config; }
    
    //--- Advanced trade execution methods
    bool ExecuteSignal(const SSignal &signal);
    SExecutionResult ExecuteBuyTrade(const string symbol, double entryPrice, double stopLoss, double takeProfit, double confidence = 1.0);
    SExecutionResult ExecuteSellTrade(const string symbol, double entryPrice, double stopLoss, double takeProfit, double confidence = 1.0);
    SExecutionResult ExecuteOrderRequest(const SOrderRequest &request);
    SExecutionResult ExecuteSmartOrder(const SOrderRequest &request);
    
    //--- Order management
    bool PlacePendingOrder(const SOrderRequest &request);
    bool ModifyOrder(ulong ticket, double price, double stopLoss, double takeProfit);
    bool CancelOrder(ulong ticket);
    bool ClosePosition(ulong ticket, double volume = 0);
    bool ClosePartialPosition(ulong ticket, double percentage);
    
    //--- Advanced execution strategies
    SExecutionResult ExecuteIcebergOrder(const SOrderRequest &request, double sliceSize);
    SExecutionResult ExecuteTWAPOrder(const SOrderRequest &request, int timeSlices);
    SExecutionResult ExecuteWithSlippageControl(const SOrderRequest &request);
    SExecutionResult ExecuteWithPriceImprovement(const SOrderRequest &request);
    
    //--- Execution monitoring and analytics
    void MonitorExecution();
    void UpdateExecutionMetrics();
    STradeMetrics GetExecutionMetrics() const { return m_metrics; }
    double GetAverageSlippage(const string symbol = "");
    double GetExecutionQuality(const string symbol = "");
    
    //--- Order validation and risk checks
    bool ValidateOrderRequest(const SOrderRequest &request);
    bool CheckMarketConditions(const string symbol);
    bool CheckLiquidityRequirements(const string symbol, double volume);
    bool IsOptimalExecutionTime(const string symbol);
    
    //--- Price and spread analysis
    double GetOptimalEntryPrice(const string symbol, ENUM_ORDER_TYPE orderType);
    double CalculateExpectedSlippage(const string symbol, double volume);
    bool IsSpreadAcceptable(const string symbol);
    double GetMarketImpact(const string symbol, double volume);
    
    //--- Execution timing optimization
    bool ShouldDelayExecution(const string symbol);
    datetime GetOptimalExecutionTime(const string symbol);
    bool IsHighLiquidityPeriod(const string symbol);
    
    //--- Multi-order management
    bool ExecuteBatchOrders(SOrderRequest &requests[]);
    bool ManagePendingOrders();
    void CancelAllPendingOrders(const string symbol = "");
    int GetActiveOrderCount(const string symbol = "");
    
    //--- Performance tracking
    void RecordExecutionResult(const SExecutionResult &result);
    double CalculateExecutionScore(const SExecutionResult &result);
    bool IsExecutionPerformanceDegrading();
    void OptimizeExecutionParameters();
    
    //--- Utility methods
    bool IsValidPrice(const string symbol, double price);
    double NormalizePrice(const string symbol, double price);
    double CalculateStopLossDistance(const string symbol, double entryPrice, double stopLoss);
    double CalculateRiskReward(ulong ticket);
    bool IsTradeOpen(ulong ticket);
    
    //--- Backward compatibility methods (renamed to avoid ambiguity)
    bool ExecuteBuyTradeCompat(const string symbol, double entryPrice, double stopLoss, double takeProfit);
    bool ExecuteSellTradeCompat(const string symbol, double entryPrice, double stopLoss, double takeProfit);
    bool ModifyTrade(ulong ticket, double stopLoss, double takeProfit);
    bool CloseTrade(ulong ticket, double volume = 0);
    
private:
    //--- Core execution methods
    SExecutionResult ExecuteMarketOrder(const SOrderRequest &request);
    SExecutionResult ExecutePendingOrderInternal(const SOrderRequest &request);
    SExecutionResult ExecuteWithRetries(const SOrderRequest &request);
    
    //--- Order sending helpers
    bool SendBuyOrder(const string symbol, double volume, double price, double sl, double tp, const string comment);
    bool SendSellOrder(const string symbol, double volume, double price, double sl, double tp, const string comment);
    bool SendPendingOrder(const SOrderRequest &request);
    
    //--- Validation and safety
    bool ValidateTradeParameters(const string symbol, double volume, double price, double sl, double tp);
    bool CheckAccountRequirements(const string symbol, double volume);
    bool CheckMarginRequirements(const string symbol, double volume);
    bool ValidateStopLevels(const string symbol, double price, double sl, double tp);
    
    //--- Price analysis and optimization
    double GetBestBidPrice(const string symbol);
    double GetBestAskPrice(const string symbol);
    double CalculateOptimalPrice(const string symbol, ENUM_ORDER_TYPE orderType, double referencePrice);
    bool WaitForPriceImprovement(const string symbol, double targetPrice, int maxWaitMs);
    
    //--- Slippage and spread management
    double CalculateActualSlippage(double requestedPrice, double executedPrice);
    void UpdateSlippageHistory(const string symbol, double slippage);
    void UpdateSpreadHistory(const string symbol);
    double GetAverageSpread(const string symbol, int period = 20);
    
    //--- Execution timing
    bool IsMarketOpen(const string symbol);
    bool IsHighImpactNewsTime();
    bool IsOptimalLiquidityTime(const string symbol);
    int CalculateOptimalDelay(const string symbol);
    
    //--- Order management helpers
    void AddToPendingOrders(const SOrderRequest &request);
    void RemoveFromPendingOrders(ulong ticket);
    int FindPendingOrderIndex(ulong ticket);
    void CleanupExpiredOrders();
    
    //--- Performance calculation
    void UpdateExecutionTime(int executionTimeMs);
    void UpdateSuccessRate(bool success);
    double CalculateExecutionEfficiency();
    
    //--- Array management
    void ResizeExecutionHistoryArray(int newSize);
    void ResizePendingOrdersArray(int newSize);
    void CleanupOldExecutionHistory();
    
    //--- Logging and diagnostics
    void LogExecutionAttempt(const SOrderRequest &request);
    void LogExecutionResult(const SExecutionResult &result);
    void LogExecutionMetrics();
    string GetTradeComment(const string symbol, const string action);
    
    //--- Error handling
    ENUM_EXECUTION_STATUS HandleExecutionError(int errorCode);
    bool ShouldRetryExecution(int errorCode, int currentRetry);
    void HandlePartialFill(const SExecutionResult &result);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTradeExecution::CTradeExecution()
{
    m_riskManager = NULL;
    m_magicNumber = 12345;
    m_comment = "MetaphizixEA";
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTradeExecution::~CTradeExecution()
{
}

//+------------------------------------------------------------------+
//| Initialize trade execution                                       |
//+------------------------------------------------------------------+
bool CTradeExecution::Initialize(int magicNumber = 12345, string comment = "MetaphizixEA")
{
    m_magicNumber = magicNumber;
    m_comment = comment;
    
    CConfig::LogInfo("Trade Execution initialized with Magic Number: " + IntegerToString(magicNumber));
    return true;
}

//+------------------------------------------------------------------+
//| Set risk manager reference                                       |
//+------------------------------------------------------------------+
void CTradeExecution::SetRiskManager(CRiskManagement* riskManager)
{
    m_riskManager = riskManager;
}

//+------------------------------------------------------------------+
//| Execute buy trade                                                |
//+------------------------------------------------------------------+
bool CTradeExecution::ExecuteBuyTradeCompat(string symbol, double entryPrice, double stopLoss, double takeProfit)
{
    if(m_riskManager == NULL)
    {
        CConfig::LogError("Risk manager not set");
        return false;
    }
    
    // Calculate position size
    double slDistance = CalculateStopLossDistance(symbol, entryPrice, stopLoss);
    double positionSize = m_riskManager.CalculatePositionSize(symbol, slDistance);
    
    if(positionSize <= 0)
    {
        CConfig::LogError("Invalid position size calculated");
        return false;
    }
    
    // Check if risk is acceptable
    if(!m_riskManager.IsRiskAcceptable(symbol, positionSize))
    {
        CConfig::LogInfo("Trade rejected by risk management");
        return false;
    }
    
    // Normalize prices
    entryPrice = NormalizePrice(symbol, entryPrice);
    stopLoss = NormalizePrice(symbol, stopLoss);
    takeProfit = NormalizePrice(symbol, takeProfit);
    
    // Validate parameters
    if(!ValidateTradeParameters(symbol, positionSize, entryPrice, stopLoss, takeProfit))
    {
        CConfig::LogError("Invalid trade parameters");
        return false;
    }
    
    return SendBuyOrder(symbol, positionSize, entryPrice, stopLoss, takeProfit, "MetaphizixEA Buy");
}

//+------------------------------------------------------------------+
//| Execute sell trade                                               |
//+------------------------------------------------------------------+
bool CTradeExecution::ExecuteSellTradeCompat(string symbol, double entryPrice, double stopLoss, double takeProfit)
{
    if(m_riskManager == NULL)
    {
        CConfig::LogError("Risk manager not set");
        return false;
    }
    
    // Calculate position size
    double slDistance = CalculateStopLossDistance(symbol, entryPrice, stopLoss);
    double positionSize = m_riskManager.CalculatePositionSize(symbol, slDistance);
    
    if(positionSize <= 0)
    {
        CConfig::LogError("Invalid position size calculated");
        return false;
    }
    
    // Check if risk is acceptable
    if(!m_riskManager.IsRiskAcceptable(symbol, positionSize))
    {
        CConfig::LogInfo("Trade rejected by risk management");
        return false;
    }
    
    // Normalize prices
    entryPrice = NormalizePrice(symbol, entryPrice);
    stopLoss = NormalizePrice(symbol, stopLoss);
    takeProfit = NormalizePrice(symbol, takeProfit);
    
    // Validate parameters
    if(!ValidateTradeParameters(symbol, positionSize, entryPrice, stopLoss, takeProfit))
    {
        CConfig::LogError("Invalid trade parameters");
        return false;
    }
    
    return SendSellOrder(symbol, positionSize, entryPrice, stopLoss, takeProfit, "MetaphizixEA Sell");
}

//+------------------------------------------------------------------+
//| Execute signal                                                   |
//+------------------------------------------------------------------+
bool CTradeExecution::ExecuteSignal(const SSignal &signal)
{
    switch(signal.type)
    {
        case (ENUM_SIGNAL_TYPE)SIGNAL_BUY_ENTRY:
            return ExecuteBuyTrade(signal.symbol, signal.entry_price, signal.stop_loss, signal.take_profit);
            
        case (ENUM_SIGNAL_TYPE)SIGNAL_SELL_ENTRY:
            return ExecuteSellTrade(signal.symbol, signal.entry_price, signal.stop_loss, signal.take_profit);
            
        case (ENUM_SIGNAL_TYPE)SIGNAL_BUY_EXIT:
        case (ENUM_SIGNAL_TYPE)SIGNAL_SELL_EXIT:
            // Find and close relevant positions
            for(int i = 0; i < PositionsTotal(); i++)
            {
                if(PositionSelectByIndex(i))
                {
                    if(PositionGetString(POSITION_SYMBOL) == signal.symbol)
                    {
                        ulong ticket = PositionGetInteger(POSITION_TICKET);
                        return CloseTrade(ticket);
                    }
                }
            }
            break;
            
        default:
            CConfig::LogError("Unknown signal type: " + IntegerToString(signal.type));
            return false;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Send buy order                                                   |
//+------------------------------------------------------------------+
bool CTradeExecution::SendBuyOrder(const string symbol, double volume, double price, double sl, double tp, const string comment)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = symbol;
    request.volume = volume;
    request.type = ORDER_TYPE_BUY;
    request.price = SymbolInfoDouble(symbol, SYMBOL_ASK);
    request.sl = sl;
    request.tp = tp;
    request.magic = m_magicNumber;
    request.comment = comment;
    request.comment = GetTradeComment(symbol, "BUY");
    request.deviation = 3;
    
    bool success = OrderSend(request, result);
    
    if(success)
    {
        CConfig::LogInfo(StringFormat("BUY order executed: %s, Volume: %.2f, Price: %.5f, Ticket: %d", 
                        symbol, volume, result.price, result.order));
    }
    else
    {
        CConfig::LogError(StringFormat("BUY order failed: %s, Error: %d - %s", 
                         symbol, result.retcode, result.comment));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Send sell order                                                  |
//+------------------------------------------------------------------+
bool CTradeExecution::SendSellOrder(const string symbol, double volume, double price, double sl, double tp, const string comment)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    request.action = TRADE_ACTION_DEAL;
    request.symbol = symbol;
    request.volume = volume;
    request.type = ORDER_TYPE_SELL;
    request.price = SymbolInfoDouble(symbol, SYMBOL_BID);
    request.sl = sl;
    request.tp = tp;
    request.magic = m_magicNumber;
    request.comment = comment;
    request.deviation = 3;
    
    bool success = OrderSend(request, result);
    
    if(success)
    {
        CConfig::LogInfo(StringFormat("SELL order executed: %s, Volume: %.2f, Price: %.5f, Ticket: %d", 
                        symbol, volume, result.price, result.order));
    }
    else
    {
        CConfig::LogError(StringFormat("SELL order failed: %s, Error: %d - %s", 
                         symbol, result.retcode, result.comment));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Validate trade parameters                                        |
//+------------------------------------------------------------------+
bool CTradeExecution::ValidateTradeParameters(string symbol, double volume, double price, double sl, double tp)
{
    // Check minimum distance requirements
    double minDistance = SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL) * SymbolInfoDouble(symbol, SYMBOL_POINT);
    
    if(MathAbs(price - sl) < minDistance)
    {
        CConfig::LogError("Stop loss too close to entry price");
        return false;
    }
    
    if(MathAbs(price - tp) < minDistance)
    {
        CConfig::LogError("Take profit too close to entry price");
        return false;
    }
    
    // Check volume constraints
    double minVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double maxVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
    
    if(volume < minVol || volume > maxVol)
    {
        CConfig::LogError("Volume outside allowed range");
        return false;
    }
    
    return true;
}

//+------------------------------------------------------------------+
//| Modify trade                                                     |
//+------------------------------------------------------------------+
bool CTradeExecution::ModifyTrade(ulong ticket, double stopLoss, double takeProfit)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    if(!PositionSelectByTicket(ticket))
        return false;
    
    string symbol = PositionGetString(POSITION_SYMBOL);
    
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.sl = NormalizePrice(symbol, stopLoss);
    request.tp = NormalizePrice(symbol, takeProfit);
    
    bool success = OrderSend(request, result);
    
    if(success)
    {
        CConfig::LogInfo(StringFormat("Trade modified: Ticket %d, SL: %.5f, TP: %.5f", 
                        ticket, stopLoss, takeProfit));
    }
    else
    {
        CConfig::LogError(StringFormat("Trade modification failed: Ticket %d, Error: %d", 
                         ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Close trade                                                      |
//+------------------------------------------------------------------+
bool CTradeExecution::CloseTrade(ulong ticket, double volume = 0)
{
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    
    if(!PositionSelectByTicket(ticket))
        return false;
    
    if(volume <= 0)
        volume = PositionGetDouble(POSITION_VOLUME);
    
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.volume = volume;
    request.type = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 
                    SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_BID) : 
                    SymbolInfoDouble(PositionGetString(POSITION_SYMBOL), SYMBOL_ASK);
    request.magic = m_magicNumber;
    request.comment = "Close " + m_comment;
    
    bool success = OrderSend(request, result);
    
    if(success)
    {
        CConfig::LogInfo(StringFormat("Trade closed: Ticket %d, Volume: %.2f", ticket, volume));
    }
    else
    {
        CConfig::LogError(StringFormat("Trade close failed: Ticket %d, Error: %d", ticket, result.retcode));
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Close partial position                                           |
//+------------------------------------------------------------------+
bool CTradeExecution::ClosePartialPosition(ulong ticket, double percentage)
{
    if(!PositionSelectByTicket(ticket))
        return false;
    
    double totalVolume = PositionGetDouble(POSITION_VOLUME);
    double closeVolume = totalVolume * (percentage / 100.0);
    
    return CloseTrade(ticket, closeVolume);
}

//+------------------------------------------------------------------+
//| Monitor execution                                                |
//+------------------------------------------------------------------+
void CTradeExecution::MonitorExecution()
{
    // This can be expanded to include execution statistics
    CConfig::LogDebug(StringFormat("Monitoring %d open positions", PositionsTotal()));
}

//+------------------------------------------------------------------+
//| Calculate risk reward ratio                                      |
//+------------------------------------------------------------------+
double CTradeExecution::CalculateRiskReward(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
        return 0;
    
    double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
    double sl = PositionGetDouble(POSITION_SL);
    double tp = PositionGetDouble(POSITION_TP);
    
    if(sl == 0 || tp == 0)
        return 0;
    
    double risk = MathAbs(openPrice - sl);
    double reward = MathAbs(tp - openPrice);
    
    return risk > 0 ? reward / risk : 0;
}

//+------------------------------------------------------------------+
//| Check if trade is open                                           |
//+------------------------------------------------------------------+
bool CTradeExecution::IsTradeOpen(ulong ticket)
{
    return PositionSelectByTicket(ticket);
}

//+------------------------------------------------------------------+
//| Check if price is valid                                          |
//+------------------------------------------------------------------+
bool CTradeExecution::IsValidPrice(string symbol, double price)
{
    return price > 0 && price > SymbolInfoDouble(symbol, SYMBOL_POINT);
}

//+------------------------------------------------------------------+
//| Normalize price                                                  |
//+------------------------------------------------------------------+
double CTradeExecution::NormalizePrice(string symbol, double price)
{
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    return NormalizeDouble(price, digits);
}

//+------------------------------------------------------------------+
//| Calculate stop loss distance                                     |
//+------------------------------------------------------------------+
double CTradeExecution::CalculateStopLossDistance(string symbol, double entryPrice, double stopLoss)
{
    return MathAbs(entryPrice - stopLoss);
}

//+------------------------------------------------------------------+
//| Get trade comment                                                |
//+------------------------------------------------------------------+
string CTradeExecution::GetTradeComment(string symbol, string action)
{
    return StringFormat("%s_%s_%s", m_comment, symbol, action);
}