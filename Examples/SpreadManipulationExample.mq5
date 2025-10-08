//+------------------------------------------------------------------+
//|                              SpreadManipulationExample.mq5     |
//|                           Example usage of spread detection    |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
// This is a simple example showing how to use the spread manipulation detector independently

#include "../Includes/Protection/SpreadManipulationDetector.mqh"

// Global detector instance
CSpreadManipulationDetector* g_detector = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Create and initialize the detector
    g_detector = new CSpreadManipulationDetector();
    
    if(!g_detector.Init(Symbol(), PERIOD_CURRENT))
    {
        Print("Failed to initialize spread manipulation detector");
        return INIT_FAILED;
    }
    
    // Configure detection parameters
    g_detector.SetParameters(3.0,    // Spread multiplier threshold
                           2.5,     // Volume anomaly threshold
                           150.0,   // Rapid spread change threshold
                           5,       // Min detection period
                           60);     // Max detection period
    
    // Enable news filtering
    g_detector.SetNewsFilter(true, 30);
    
    // Enable alerts
    g_detector.SetAlerts(true, false, "alert.wav");
    
    Print("Spread manipulation detector initialized successfully");
    Print("Monitoring ", Symbol(), " for spread manipulation...");
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(g_detector != NULL)
    {
        delete g_detector;
        g_detector = NULL;
    }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    static datetime lastCheck = 0;
    
    // Check every 10 seconds
    if(TimeCurrent() - lastCheck < 10) return;
    lastCheck = TimeCurrent();
    
    if(g_detector == NULL) return;
    
    // Perform detection
    bool manipulationDetected = g_detector.DetectSpreadManipulation();
    
    if(manipulationDetected)
    {
        // Get details about the detected manipulation
        double confidence = g_detector.GetManipulationConfidence();
        string description = g_detector.GetManipulationDescription();
        
        // Example actions you could take:
        
        // 1. Block new trades
        Print("⚠️ Blocking new trades due to spread manipulation");
        
        // 2. Close existing positions (if desired)
        // CloseAllPositions();
        
        // 3. Adjust stop losses to protect against manipulation
        // AdjustStopLossesToBreakeven();
        
        // 4. Send notification to phone/email
        string alertMsg = StringFormat("Spread manipulation detected on %s with %.1f%% confidence: %s", 
                                     Symbol(), confidence, description);
        SendNotification(alertMsg);
        
        // 5. Log detailed information
        g_detector.PrintDetectionReport();
    }
    
    // Display current status
    static datetime lastStatusDisplay = 0;
    if(TimeCurrent() - lastStatusDisplay > 60) // Every minute
    {
        string status = g_detector.GetStatusString();
        Print("Spread Status: ", status);
        lastStatusDisplay = TimeCurrent();
    }
}

//+------------------------------------------------------------------+
//| Example function to close all positions                         |
//+------------------------------------------------------------------+
void CloseAllPositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionGetSymbol(i) == Symbol())
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            CTrade trade;
            trade.PositionClose(ticket);
            Print("Closed position ", ticket, " due to spread manipulation");
        }
    }
}

//+------------------------------------------------------------------+
//| Example function to adjust stop losses to breakeven            |
//+------------------------------------------------------------------+
void AdjustStopLossesToBreakeven()
{
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionGetSymbol(i) == Symbol())
        {
            ulong ticket = PositionGetInteger(POSITION_TICKET);
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentSL = PositionGetDouble(POSITION_SL);
            ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            
            // Move stop loss to breakeven if it's not already better
            bool shouldModify = false;
            double newSL = openPrice;
            
            if(type == POSITION_TYPE_BUY && (currentSL == 0 || currentSL < openPrice))
            {
                shouldModify = true;
            }
            else if(type == POSITION_TYPE_SELL && (currentSL == 0 || currentSL > openPrice))
            {
                shouldModify = true;
            }
            
            if(shouldModify)
            {
                CTrade trade;
                if(trade.PositionModify(ticket, newSL, PositionGetDouble(POSITION_TP)))
                {
                    Print("Moved stop loss to breakeven for position ", ticket);
                }
            }
        }
    }
}