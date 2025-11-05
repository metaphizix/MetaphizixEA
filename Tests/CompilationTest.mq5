//+------------------------------------------------------------------+
//|                                              CompilationTest.mq5 |
//|                                                   Test Compilation |
//+------------------------------------------------------------------+
#property copyright "Test"
#property version   "1.00"

// Test basic includes
#include "../Includes/Core/Config.mqh"
#include "../Includes/Core/OrderBlockDetector.mqh"
#include "../Includes/Core/SignalManager.mqh"

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("Compilation test successful!");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
}