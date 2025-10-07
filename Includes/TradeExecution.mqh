//+------------------------------------------------------------------+
//|                                               TradeExecution.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"
#include "RiskManagement.mqh"
#include "SignalManager.mqh"

//+------------------------------------------------------------------+
//| Trade execution class                                            |
//| Handles order placement and trade management                     |
//+------------------------------------------------------------------+
class CTradeExecution
{
private:
    CRiskManagement*  m_riskManager;
    int               m_magicNumber;
    string            m_comment;
    
public:
    //--- Constructor/Destructor
    CTradeExecution();
    ~CTradeExecution();
    
    //--- Initialization
    bool Initialize(int magicNumber = 12345, string comment = "MetaphizixEA");
    void SetRiskManager(CRiskManagement* riskManager);
    
    //--- Trade execution methods
    bool ExecuteBuyTrade(string symbol, double entryPrice, double stopLoss, double takeProfit);
    bool ExecuteSellTrade(string symbol, double entryPrice, double stopLoss, double takeProfit);
    bool ExecuteSignal(const SSignal &signal);
    
    //--- Trade management
    bool ModifyTrade(ulong ticket, double stopLoss, double takeProfit);
    bool CloseTrade(ulong ticket, double volume = 0);
    bool ClosePartialTrade(ulong ticket, double percentage);
    
    //--- Trade monitoring
    void MonitorExecution();
    double CalculateRiskReward(ulong ticket);
    bool IsTradeOpen(ulong ticket);
    
    //--- Utility methods
    bool IsValidPrice(string symbol, double price);
    double NormalizePrice(string symbol, double price);
    double CalculateStopLossDistance(string symbol, double entryPrice, double stopLoss);
    
private:
    //--- Helper methods
    bool SendBuyOrder(string symbol, double volume, double price, double sl, double tp);
    bool SendSellOrder(string symbol, double volume, double price, double sl, double tp);
    bool ValidateTradeParameters(string symbol, double volume, double price, double sl, double tp);
    string GetTradeComment(string symbol, string action);
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
bool CTradeExecution::ExecuteBuyTrade(string symbol, double entryPrice, double stopLoss, double takeProfit)
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
    
    return SendBuyOrder(symbol, positionSize, entryPrice, stopLoss, takeProfit);
}

//+------------------------------------------------------------------+
//| Execute sell trade                                               |
//+------------------------------------------------------------------+
bool CTradeExecution::ExecuteSellTrade(string symbol, double entryPrice, double stopLoss, double takeProfit)
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
    
    return SendSellOrder(symbol, positionSize, entryPrice, stopLoss, takeProfit);
}

//+------------------------------------------------------------------+
//| Execute signal                                                   |
//+------------------------------------------------------------------+
bool CTradeExecution::ExecuteSignal(const SSignal &signal)
{
    switch(signal.type)
    {
        case SIGNAL_BUY_ENTRY:
            return ExecuteBuyTrade(signal.symbol, signal.entry_price, signal.stop_loss, signal.take_profit);
            
        case SIGNAL_SELL_ENTRY:
            return ExecuteSellTrade(signal.symbol, signal.entry_price, signal.stop_loss, signal.take_profit);
            
        case SIGNAL_BUY_EXIT:
        case SIGNAL_SELL_EXIT:
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
bool CTradeExecution::SendBuyOrder(string symbol, double volume, double price, double sl, double tp)
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
bool CTradeExecution::SendSellOrder(string symbol, double volume, double price, double sl, double tp)
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
    request.comment = GetTradeComment(symbol, "SELL");
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
//| Close partial trade                                              |
//+------------------------------------------------------------------+
bool CTradeExecution::ClosePartialTrade(ulong ticket, double percentage)
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