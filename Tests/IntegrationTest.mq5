//+------------------------------------------------------------------+
//|                              IntegrationTest.mq5                |
//|                     Integration Test for MetaphizixEA System     |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property script_show_inputs
#property description "Comprehensive integration test for all MetaphizixEA components"

//+------------------------------------------------------------------+
//| INCLUDES                                                         |
//+------------------------------------------------------------------+
#include "../Includes/Protection/SpreadManipulationDetector.mqh"
#include "../Includes/Protection/BrokerLeverageDetector.mqh"

//+------------------------------------------------------------------+
//| GLOBAL VARIABLES                                                 |
//+------------------------------------------------------------------+
CSpreadManipulationDetector* testSpreadDetector = NULL;
CBrokerLeverageDetector* testBrokerDetector = NULL;

//+------------------------------------------------------------------+
//| Script Start Function                                            |
//+------------------------------------------------------------------+
int OnInit()
{
    DisplayTestHeader();
    
    bool allTestsPassed = true;
    
    //--- Execute Test Suite
    allTestsPassed &= ExecuteTestSuite();
    
    //--- Display Final Results
    DisplayFinalResults(allTestsPassed);
    
    return allTestsPassed ? INIT_SUCCEEDED : INIT_FAILED;
}

//+------------------------------------------------------------------+
//| Execute Complete Test Suite                                      |
//+------------------------------------------------------------------+
bool ExecuteTestSuite()
{
    bool allTestsPassed = true;
    
    // Test 1: Spread Manipulation Detector
    Print("\n📊 Testing Spread Manipulation Detector...");
    allTestsPassed &= TestSpreadDetector();
    
    // Test 2: Broker and Leverage Detector
    Print("\n🏢 Testing Broker and Leverage Detector...");
    allTestsPassed &= TestBrokerDetector();
    
    // Test 3: Integration between components
    Print("\n🔗 Testing Component Integration...");
    allTestsPassed &= TestIntegration();
    
    // Test 4: Risk Management Integration
    Print("\n⚠️ Testing Risk Management Integration...");
    allTestsPassed &= TestRiskIntegration();
    
    // Test 5: Performance Impact
    Print("\n⚡ Testing Performance Impact...");
    allTestsPassed &= TestPerformance();
    
    return allTestsPassed;
}

//+------------------------------------------------------------------+
//| Display Test Header                                              |
//+------------------------------------------------------------------+
void DisplayTestHeader()
{
    Print("========================================");
    Print("🧪 METAPHIZIXEA INTEGRATION TEST");
    Print("========================================");
    Print("🎯 Testing all system components");
    Print("📊 Version: 3.01");
    Print("🕐 Test Time: ", TimeToString(TimeCurrent()));
    Print("========================================");
}

//+------------------------------------------------------------------+
//| Display Final Test Results                                       |
//+------------------------------------------------------------------+
void DisplayFinalResults(bool allTestsPassed)
{
    Print("\n========================================");
    if(allTestsPassed)
    {
        Print("✅ ALL INTEGRATION TESTS PASSED!");
        Print("🎉 MetaphizixEA is ready for trading!");
        Print("🚀 System status: PRODUCTION READY");
        Alert("✅ Integration Test: ALL TESTS PASSED!");
    }
    else
    {
        Print("❌ SOME TESTS FAILED!");
        Print("⚠️ Please check the logs and fix issues before trading.");
        Print("🔧 System status: NEEDS ATTENTION");
        Alert("❌ Integration Test: SOME TESTS FAILED!");
    }
    Print("========================================");
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(testSpreadDetector != NULL)
    {
        delete testSpreadDetector;
        testSpreadDetector = NULL;
    }
    
    if(testBrokerDetector != NULL)
    {
        delete testBrokerDetector;
        testBrokerDetector = NULL;
    }
    
    Print("🧹 Integration test cleanup completed");
}

//+------------------------------------------------------------------+
//| Test Spread Manipulation Detector                              |
//+------------------------------------------------------------------+
bool TestSpreadDetector()
{
    bool testPassed = true;
    
    try
    {
        // Create detector
        testSpreadDetector = new CSpreadManipulationDetector();
        if(testSpreadDetector == NULL)
        {
            Print("❌ Failed to create spread detector");
            return false;
        }
        
        // Initialize detector
        if(!testSpreadDetector.Init(Symbol(), PERIOD_CURRENT))
        {
            Print("❌ Failed to initialize spread detector");
            return false;
        }
        
        // Test parameter setting
        testSpreadDetector.SetParameters(3.0, 2.5, 150.0, 5, 60);
        testSpreadDetector.SetNewsFilter(true, 30);
        testSpreadDetector.SetAlerts(true, false, "alert.wav");
        
        Print("✅ Spread detector created and configured successfully");
        
        // Test detection methods
        double currentSpread = testSpreadDetector.GetCurrentSpread();
        if(currentSpread > 0)
        {
            Print("✅ Current spread detection working: ", DoubleToString(currentSpread, 1), " points");
        }
        else
        {
            Print("⚠️ Warning: Unable to get current spread");
            testPassed = false;
        }
        
        // Test statistical methods
        bool isOutlier = testSpreadDetector.IsStatisticalOutlier(currentSpread);
        Print("✅ Statistical analysis working - Outlier status: ", isOutlier ? "Yes" : "No");
        
        // Test status reporting
        string status = testSpreadDetector.GetStatusString();
        if(StringLen(status) > 0)
        {
            Print("✅ Status reporting working: ", status);
        }
        else
        {
            Print("❌ Status reporting failed");
            testPassed = false;
        }
        
    }
    catch(string error)
    {
        Print("❌ Exception in spread detector test: ", error);
        testPassed = false;
    }
    
    return testPassed;
}

//+------------------------------------------------------------------+
//| Test Broker and Leverage Detector                              |
//+------------------------------------------------------------------+
bool TestBrokerDetector()
{
    bool testPassed = true;
    
    try
    {
        // Create detector
        testBrokerDetector = new CBrokerLeverageDetector();
        if(testBrokerDetector == NULL)
        {
            Print("❌ Failed to create broker detector");
            return false;
        }
        
        // Initialize detector
        if(!testBrokerDetector.Init(Symbol()))
        {
            Print("❌ Failed to initialize broker detector");
            return false;
        }
        
        Print("✅ Broker detector created and initialized successfully");
        
        // Test broker information
        BrokerInfo broker = testBrokerDetector.GetBrokerInfo();
        if(StringLen(broker.companyName) > 0)
        {
            Print("✅ Broker detection working - Company: ", broker.companyName);
            Print("   Server: ", broker.serverName);
            Print("   Type: ", broker.brokerType);
            Print("   Account: ", broker.isDemo ? "Demo" : "Live");
        }
        else
        {
            Print("❌ Broker information detection failed");
            testPassed = false;
        }
        
        // Test leverage information
        LeverageInfo leverage = testBrokerDetector.GetLeverageInfo();
        if(leverage.currentLeverage > 0)
        {
            Print("✅ Leverage detection working - Current: 1:", DoubleToString(leverage.currentLeverage, 0));
            Print("   Used Leverage: 1:", DoubleToString(leverage.usedLeverage, 2));
            Print("   Margin Level: ", DoubleToString(leverage.marginLevel, 1), "%");
        }
        else
        {
            Print("❌ Leverage information detection failed");
            testPassed = false;
        }
        
        // Test risk assessment
        RiskAssessment risk = testBrokerDetector.GetRiskAssessment();
        Print("✅ Risk assessment working - Level: ", risk.riskLevel, "/5");
        Print("   Description: ", risk.riskDescription);
        
        // Test broker classification
        BrokerClassification classification = testBrokerDetector.GetBrokerClassification();
        Print("✅ Broker classification working - Trust Score: ", DoubleToString(classification.trustScore, 1), "/100");
        
        // Test utility methods
        double optimalLot = testBrokerDetector.CalculateOptimalLotSize(1.0);
        if(optimalLot > 0)
        {
            Print("✅ Lot size calculation working - Optimal (1% risk): ", DoubleToString(optimalLot, 2), " lots");
        }
        else
        {
            Print("⚠️ Warning: Lot size calculation returned zero");
        }
        
    }
    catch(string error)
    {
        Print("❌ Exception in broker detector test: ", error);
        testPassed = false;
    }
    
    return testPassed;
}

//+------------------------------------------------------------------+
//| Test Integration between components                             |
//+------------------------------------------------------------------+
bool TestIntegration()
{
    bool testPassed = true;
    
    if(testSpreadDetector == NULL || testBrokerDetector == NULL)
    {
        Print("❌ Components not initialized for integration test");
        return false;
    }
    
    try
    {
        // Test combined risk assessment
        bool spreadManipulation = testSpreadDetector.IsManipulationDetected();
        RiskAssessment brokerRisk = testBrokerDetector.GetRiskAssessment();
        
        int combinedRiskLevel = brokerRisk.riskLevel;
        if(spreadManipulation)
        {
            combinedRiskLevel = MathMax(combinedRiskLevel, 4); // Elevate risk if manipulation detected
        }
        
        Print("✅ Combined risk assessment working");
        Print("   Spread Manipulation: ", spreadManipulation ? "Detected" : "None");
        Print("   Broker Risk Level: ", brokerRisk.riskLevel, "/5");
        Print("   Combined Risk Level: ", combinedRiskLevel, "/5");
        
        // Test integrated lot size calculation
        double baseOptimalLot = testBrokerDetector.CalculateOptimalLotSize(2.0); // 2% risk
        double adjustedLot = baseOptimalLot;
        
        // Adjust for spread manipulation
        if(spreadManipulation)
        {
            adjustedLot *= 0.5; // Reduce by 50% if manipulation detected
        }
        
        // Adjust for high broker risk
        if(brokerRisk.riskLevel >= 4)
        {
            adjustedLot *= 0.7; // Reduce by 30% for high risk
        }
        
        Print("✅ Integrated lot sizing working");
        Print("   Base Optimal Lot: ", DoubleToString(baseOptimalLot, 2));
        Print("   Risk-Adjusted Lot: ", DoubleToString(adjustedLot, 2));
        
        // Test status integration
        string spreadStatus = testSpreadDetector.GetStatusString();
        string brokerReport = testBrokerDetector.GetComprehensiveReport();
        
        string integratedStatus = "Spread: " + spreadStatus + " | " + brokerReport;
        if(StringLen(integratedStatus) > 20) // Basic validation
        {
            Print("✅ Status integration working");
            Print("   Integrated Status: ", integratedStatus);
        }
        else
        {
            Print("❌ Status integration failed");
            testPassed = false;
        }
        
    }
    catch(string error)
    {
        Print("❌ Exception in integration test: ", error);
        testPassed = false;
    }
    
    return testPassed;
}

//+------------------------------------------------------------------+
//| Test Risk Management Integration                                |
//+------------------------------------------------------------------+
bool TestRiskIntegration()
{
    bool testPassed = true;
    
    try
    {
        // Simulate risk scenarios
        Print("🔍 Testing risk scenarios...");
        
        // Scenario 1: High leverage with spread manipulation
        LeverageInfo leverage = testBrokerDetector.GetLeverageInfo();
        bool manipulation = testSpreadDetector.IsManipulationDetected();
        
        bool shouldBlockTrades = false;
        string blockReason = "";
        
        if(leverage.usedLeverage > 10.0)
        {
            shouldBlockTrades = true;
            blockReason += "Over-leveraged (" + DoubleToString(leverage.usedLeverage, 2) + "x); ";
        }
        
        if(leverage.marginLevel < 200.0 && leverage.marginLevel > 0)
        {
            shouldBlockTrades = true;
            blockReason += "Low margin level (" + DoubleToString(leverage.marginLevel, 1) + "%); ";
        }
        
        if(manipulation)
        {
            shouldBlockTrades = true;
            blockReason += "Spread manipulation detected; ";
        }
        
        RiskAssessment risk = testBrokerDetector.GetRiskAssessment();
        if(risk.riskLevel >= 5)
        {
            shouldBlockTrades = true;
            blockReason += "Very high risk level (5/5); ";
        }
        
        Print("✅ Risk scenario analysis complete");
        Print("   Should Block Trades: ", shouldBlockTrades ? "Yes" : "No");
        if(shouldBlockTrades)
        {
            Print("   Reasons: ", blockReason);
        }
        
        // Test risk-adjusted position sizing
        double riskAdjustmentFactor = 1.0;
        
        switch(risk.riskLevel)
        {
            case 1: riskAdjustmentFactor = 1.0; break;
            case 2: riskAdjustmentFactor = 0.9; break;
            case 3: riskAdjustmentFactor = 0.7; break;
            case 4: riskAdjustmentFactor = 0.5; break;
            case 5: riskAdjustmentFactor = 0.3; break;
        }
        
        if(manipulation)
        {
            riskAdjustmentFactor *= 0.5; // Additional 50% reduction
        }
        
        Print("✅ Risk adjustment calculation working");
        Print("   Base Risk Factor: 1.0");
        Print("   Adjusted Risk Factor: ", DoubleToString(riskAdjustmentFactor, 2));
        
    }
    catch(string error)
    {
        Print("❌ Exception in risk integration test: ", error);
        testPassed = false;
    }
    
    return testPassed;
}

//+------------------------------------------------------------------+
//| Test Performance Impact                                         |
//+------------------------------------------------------------------+
bool TestPerformance()
{
    bool testPassed = true;
    
    try
    {
        Print("⏱️ Measuring performance impact...");
        
        uint startTime = GetTickCount();
        
        // Perform multiple detection cycles
        for(int i = 0; i < 100; i++)
        {
            testSpreadDetector.DetectSpreadManipulation();
            testBrokerDetector.DetectLeverageInfo();
            testBrokerDetector.AssessRisk();
        }
        
        uint endTime = GetTickCount();
        uint totalTime = endTime - startTime;
        
        double avgTimePerCycle = (double)totalTime / 100.0;
        
        Print("✅ Performance test completed");
        Print("   100 detection cycles in ", totalTime, "ms");
        Print("   Average per cycle: ", DoubleToString(avgTimePerCycle, 2), "ms");
        
        if(avgTimePerCycle < 10.0) // Less than 10ms per cycle is good
        {
            Print("✅ Performance is excellent (< 10ms per cycle)");
        }
        else if(avgTimePerCycle < 50.0) // Less than 50ms is acceptable
        {
            Print("✅ Performance is acceptable (< 50ms per cycle)");
        }
        else
        {
            Print("⚠️ Performance may be slow (> 50ms per cycle)");
            testPassed = false;
        }
        
        // Test memory usage (simplified)
        double freeMemory = (double)TerminalInfoInteger(TERMINAL_MEMORY_AVAILABLE);
        Print("💾 Available memory: ", DoubleToString(freeMemory, 0), " MB");
        
        if(freeMemory > 100.0) // At least 100MB free
        {
            Print("✅ Memory usage is healthy");
        }
        else
        {
            Print("⚠️ Low memory available");
        }
        
    }
    catch(string error)
    {
        Print("❌ Exception in performance test: ", error);
        testPassed = false;
    }
    
    return testPassed;
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // This test EA doesn't need to do anything on tick
    // Real integration would happen in the main EA
}