//+------------------------------------------------------------------+
//|                              BrokerLeverageExample.mq5         |
//|                           Example usage of broker detection    |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
// This is a simple example showing how to use the broker and leverage detector independently

#include "../Includes/Protection/BrokerLeverageDetector.mqh"

// Global detector instance
CBrokerLeverageDetector* g_detector = NULL;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Create and initialize the detector
    g_detector = new CBrokerLeverageDetector();
    
    if(!g_detector.Init(Symbol()))
    {
        Print("Failed to initialize broker and leverage detector");
        return INIT_FAILED;
    }
    
    Print("Broker and leverage detector initialized successfully");
    
    // Get and display broker information
    BrokerInfo broker = g_detector.GetBrokerInfo();
    LeverageInfo leverage = g_detector.GetLeverageInfo();
    RiskAssessment risk = g_detector.GetRiskAssessment();
    BrokerClassification classification = g_detector.GetBrokerClassification();
    
    Print("===============================================");
    Print("🏢 BROKER ANALYSIS COMPLETE");
    Print("===============================================");
    Print("Broker: ", broker.companyName);
    Print("Type: ", broker.brokerType);
    Print("Server: ", broker.serverName);
    Print("Trust Score: ", DoubleToString(classification.trustScore, 1), "/100");
    Print("Current Leverage: 1:", DoubleToString(leverage.currentLeverage, 0));
    Print("Used Leverage: 1:", DoubleToString(leverage.usedLeverage, 2));
    Print("Risk Level: ", risk.riskLevel, "/5 (", risk.riskDescription, ")");
    Print("===============================================");
    
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
    
    // Check every 30 seconds
    if(TimeCurrent() - lastCheck < 30) return;
    lastCheck = TimeCurrent();
    
    if(g_detector == NULL) return;
    
    // Update leverage information
    g_detector.DetectLeverageInfo();
    g_detector.AssessRisk();
    
    // Get current information
    LeverageInfo leverage = g_detector.GetLeverageInfo();
    RiskAssessment risk = g_detector.GetRiskAssessment();
    
    // Example risk management actions based on detected conditions
    
    // 1. Check for margin call risk
    if(leverage.marginCallRisk)
    {
        Print("🚨 CRITICAL: Margin call risk detected!");
        Print("   Margin Level: ", DoubleToString(leverage.marginLevel, 1), "%");
        Print("   Recommended Action: Close some positions or add funds");
        
        // Example: Close riskiest positions
        // CloseRiskiestPositions();
    }
    
    // 2. Check for over-leveraging
    if(leverage.usedLeverage > 10.0) // More than 10x used leverage
    {
        Print("⚠️ WARNING: Over-leveraged account!");
        Print("   Used Leverage: 1:", DoubleToString(leverage.usedLeverage, 2));
        Print("   Recommended Action: Reduce position sizes");
        
        // Example: Reduce position sizes
        // ReducePositionSizes();
    }
    
    // 3. Check broker trust score
    BrokerClassification classification = g_detector.GetBrokerClassification();
    if(classification.trustScore < 70.0)
    {
        static datetime lastTrustWarning = 0;
        if(TimeCurrent() - lastTrustWarning > 3600) // Warn every hour
        {
            Print("⚠️ BROKER WARNING: Low trust score (", DoubleToString(classification.trustScore, 1), "/100)");
            Print("   Broker: ", g_detector.GetBrokerInfo().companyName);
            Print("   Recommendation: Consider using a more reputable broker");
            lastTrustWarning = TimeCurrent();
        }
    }
    
    // 4. Calculate optimal lot size for new trades
    double optimalLot1Percent = g_detector.CalculateOptimalLotSize(1.0); // 1% risk
    double optimalLot2Percent = g_detector.CalculateOptimalLotSize(2.0); // 2% risk
    double maxSafeLot = g_detector.CalculateMaxLotSize();
    
    // Display lot size recommendations periodically
    static datetime lastLotDisplay = 0;
    if(TimeCurrent() - lastLotDisplay > 300) // Every 5 minutes
    {
        Print("💡 LOT SIZE RECOMMENDATIONS:");
        Print("   1% Risk: ", DoubleToString(optimalLot1Percent, 2), " lots");
        Print("   2% Risk: ", DoubleToString(optimalLot2Percent, 2), " lots");
        Print("   Max Safe: ", DoubleToString(maxSafeLot, 2), " lots");
        lastLotDisplay = TimeCurrent();
    }
    
    // 5. Monitor for high-risk conditions
    if(risk.riskLevel >= 4)
    {
        static datetime lastRiskAlert = 0;
        if(TimeCurrent() - lastRiskAlert > 600) // Every 10 minutes
        {
            Print("🚨 HIGH RISK CONDITIONS DETECTED!");
            Print("   Risk Level: ", risk.riskLevel, "/5");
            Print("   Description: ", risk.riskDescription);
            
            // Print specific risk warnings
            for(int i = 0; i < ArraySize(risk.riskWarnings); i++)
            {
                Print("   ⚠️ ", risk.riskWarnings[i]);
            }
            
            lastRiskAlert = TimeCurrent();
        }
    }
}

//+------------------------------------------------------------------+
//| Example function to close riskiest positions                   |
//+------------------------------------------------------------------+
void CloseRiskiestPositions()
{
    // This is an example implementation
    // In practice, you would implement logic to identify and close the riskiest positions
    
    double maxLossToClose = AccountInfoDouble(ACCOUNT_BALANCE) * 0.05; // Close positions with >5% loss
    
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        if(PositionGetSymbol(i) == Symbol())
        {
            double profit = PositionGetDouble(POSITION_PROFIT);
            if(profit < -maxLossToClose)
            {
                ulong ticket = PositionGetInteger(POSITION_TICKET);
                CTrade trade;
                if(trade.PositionClose(ticket))
                {
                    Print("Closed risky position ", ticket, " with loss: ", DoubleToString(profit, 2));
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Example function to reduce position sizes                       |
//+------------------------------------------------------------------+
void ReducePositionSizes()
{
    // This is an example implementation
    // In practice, you would implement logic to reduce position sizes
    
    double reductionFactor = 0.5; // Reduce positions by 50%
    
    for(int i = 0; i < PositionsTotal(); i++)
    {
        if(PositionGetSymbol(i) == Symbol())
        {
            double currentVolume = PositionGetDouble(POSITION_VOLUME);
            double newVolume = currentVolume * reductionFactor;
            
            // Round to valid lot size
            double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
            newVolume = MathFloor(newVolume / lotStep) * lotStep;
            
            if(newVolume >= SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN))
            {
                ulong ticket = PositionGetInteger(POSITION_TICKET);
                double volumeToClose = currentVolume - newVolume;
                
                CTrade trade;
                if(trade.PositionClosePartial(ticket, volumeToClose))
                {
                    Print("Reduced position ", ticket, " by ", DoubleToString(volumeToClose, 2), " lots");
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Timer function for periodic checks                              |
//+------------------------------------------------------------------+
void OnTimer()
{
    if(g_detector == NULL) return;
    
    // Perform comprehensive analysis every 15 minutes
    static datetime lastFullAnalysis = 0;
    if(TimeCurrent() - lastFullAnalysis > 900) // 15 minutes
    {
        Print("🔄 Performing comprehensive broker and leverage analysis...");
        
        // Refresh all information
        g_detector.DetectBrokerInfo();
        g_detector.DetectLeverageInfo();
        g_detector.ClassifyBroker();
        g_detector.AssessRisk();
        
        // Get comprehensive report
        string report = g_detector.GetComprehensiveReport();
        Print("📊 Status: ", report);
        
        lastFullAnalysis = TimeCurrent();
    }
}