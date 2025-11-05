//+------------------------------------------------------------------+
//|                                         BrokerLeverageDetector.mqh |
//|                                   Copyright 2025, MetaphizixEA Team |
//|                               https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://github.com/metaphizix/MetaphizixEA"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Broker and Leverage Detection Class                            |
//+------------------------------------------------------------------+
class CBrokerLeverageDetector
{
private:
    //--- Broker information structure
    struct BrokerInfo
    {
        string companyName;
        string serverName;
        string brokerType;        // ECN, STP, Market Maker, Hybrid
        string regulationType;    // Regulated, Unregulated, Unknown
        string country;
        string currency;
        bool isDemo;
        bool isLive;
        int accountType;          // 0=Demo, 1=Contest, 2=Real
        string tradingMode;       // Hedging, Netting
        double commissionType;    // 0=None, 1=Per lot, 2=Per deal
        double minimumLot;
        double maximumLot;
        double lotStep;
        int digits;
        double tickSize;
        double tickValue;
        bool isECN;
        bool allowsScalping;
        bool allowsHedging;
        bool allowsEA;
        datetime serverTime;
        int timeZone;
        double spread;
        double averageSpread;
    };
    
    //--- Leverage information structure
    struct LeverageInfo
    {
        double currentLeverage;
        double maxLeverage;
        double usedLeverage;
        double availableLeverage;
        double marginRequired;
        double freeMargin;
        double marginLevel;
        double equity;
        double balance;
        bool isLeverageRestricted;
        string leverageRestrictionReason;
        double riskPercentage;
        bool isHighRisk;
        double recommendedLotSize;
        double maxSafeLotSize;
        string leverageType;      // Fixed, Variable, Dynamic
        bool marginCallRisk;
        double marginCallLevel;
        double stopOutLevel;
    };
    
    //--- Broker classification data
    struct BrokerClassification
    {
        string brokerClass;       // A-Book, B-Book, Mixed, Unknown
        string executionModel;    // STP, ECN, MM, Hybrid
        string liquidityProvider; // Banks, Prime Brokers, Internal
        double trustScore;        // 0-100 rating
        bool hasRegulation;
        string regulators;        // Comma-separated list of regulators
        bool hasNegativeBalance;
        bool hasGuaranteedStops;
        bool hasVariableSpreads;
        double typicalSpread;
        string platformType;      // MT4, MT5, cTrader, Proprietary
        bool allowsScalping;
        bool allowsHedging;
        bool allowsEAs;
        bool hasSwapFree;
        double maxDrawdownProtection;
    };
    
    //--- Risk assessment structure
    struct RiskAssessment
    {
        int riskLevel;           // 1=Very Low, 2=Low, 3=Medium, 4=High, 5=Very High
        string riskDescription;
        double safeLeverage;
        double maxRecommendedLot;
        bool requiresMarginAlert;
        double marginBuffer;
        string riskWarnings[];
        double stressTestResult;
        bool isOverLeveraged;
        double volatilityImpact;
        string riskMitigationSuggestions[];
    };
    
    //--- Private variables
    BrokerInfo m_brokerInfo;
    LeverageInfo m_leverageInfo;
    BrokerClassification m_classification;
    RiskAssessment m_riskAssessment;
    
    string m_symbol;
    bool m_initialized;
    datetime m_lastUpdate;
    
    //--- Known broker database
    string m_knownBrokers[][5];  // [Name, Type, Country, Regulation, TrustScore]
    
public:
    //--- Constructor and destructor
    CBrokerLeverageDetector(void);
    ~CBrokerLeverageDetector(void);
    
    //--- Initialization methods
    bool Init(string symbol = "");
    void InitializeKnownBrokers(void);
    
    //--- Detection methods
    bool DetectBrokerInfo(void);
    bool DetectLeverageInfo(void);
    bool ClassifyBroker(void);
    bool AssessRisk(void);
    
    //--- Information retrieval methods
    BrokerInfo GetBrokerInfo(void) { return m_brokerInfo; }
    LeverageInfo GetLeverageInfo(void) { return m_leverageInfo; }
    BrokerClassification GetBrokerClassification(void) { return m_classification; }
    RiskAssessment GetRiskAssessment(void) { return m_riskAssessment; }
    
    //--- Analysis methods
    bool IsBrokerReliable(void);
    bool IsLeverageSafe(void);
    bool IsOverLeveraged(void);
    double CalculateOptimalLotSize(double riskPercent);
    double CalculateMarginRequired(double lotSize);
    double CalculateMaxLotSize(void);
    
    //--- Monitoring methods
    bool MonitorLeverageChanges(void);
    bool MonitorMarginLevel(void);
    bool CheckMarginCall(void);
    
    //--- Utility methods
    string GetBrokerTypeString(void);
    string GetLeverageString(void);
    string GetRiskLevelString(void);
    string GetComprehensiveReport(void);
    
    //--- Display methods
    void PrintBrokerInfo(void);
    void PrintLeverageInfo(void);
    void PrintRiskAssessment(void);
    void PrintFullReport(void);
    
    //--- Alert methods
    void CheckForAlerts(void);
    void SendRiskAlert(string message, int severity);
    
private:
    //--- Internal helper methods
    bool IdentifyBrokerFromName(string companyName);
    string ClassifyBrokerType(void);
    string DetermineBrokerClass(void);
    bool HasRegulation(string companyName);
    double CalculateTrustScore(void);
    
    //--- Risk calculation methods
    double CalculateStressTest(void);
    double CalculateVolatilityImpact(void);
    bool CheckLeverageRestrictions(void);
    
    //--- Validation methods
    bool ValidateAccountInfo(void);
    bool ValidateMarginInfo(void);
    
    //--- Database methods
    void LoadBrokerDatabase(void);
    string FindBrokerInDatabase(string name);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CBrokerLeverageDetector::CBrokerLeverageDetector(void)
{
    m_symbol = "";
    m_initialized = false;
    m_lastUpdate = 0;
    
    ZeroMemory(m_brokerInfo);
    ZeroMemory(m_leverageInfo);
    ZeroMemory(m_classification);
    ZeroMemory(m_riskAssessment);
    
    InitializeKnownBrokers();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CBrokerLeverageDetector::~CBrokerLeverageDetector(void)
{
}

//+------------------------------------------------------------------+
//| Initialize the detector                                          |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::Init(string symbol = "")
{
    if(symbol == "") symbol = Symbol();
    m_symbol = symbol;
    
    // Load known broker database
    LoadBrokerDatabase();
    
    // Detect all information
    bool success = DetectBrokerInfo() &&
                  DetectLeverageInfo() &&
                  ClassifyBroker() &&
                  AssessRisk();
    
    if(success)
    {
        m_initialized = true;
        m_lastUpdate = TimeCurrent();
        Print("✅ Broker and Leverage detector initialized successfully");
        PrintFullReport();
    }
    else
    {
        Print("❌ Failed to initialize Broker and Leverage detector");
    }
    
    return success;
}

//+------------------------------------------------------------------+
//| Detect broker information                                        |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::DetectBrokerInfo(void)
{
    // Get basic account information
    m_brokerInfo.companyName = AccountInfoString(ACCOUNT_COMPANY);
    m_brokerInfo.serverName = AccountInfoString(ACCOUNT_SERVER);
    m_brokerInfo.currency = AccountInfoString(ACCOUNT_CURRENCY);
    m_brokerInfo.isDemo = (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO);
    m_brokerInfo.isLive = (AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_REAL);
    m_brokerInfo.accountType = (int)AccountInfoInteger(ACCOUNT_TRADE_MODE);
    
    // Determine trading mode
    if(AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
        m_brokerInfo.tradingMode = "Hedging";
    else
        m_brokerInfo.tradingMode = "Netting";
    
    // Get symbol-specific information
    m_brokerInfo.minimumLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
    m_brokerInfo.maximumLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
    m_brokerInfo.lotStep = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    m_brokerInfo.digits = (int)SymbolInfoInteger(m_symbol, SYMBOL_DIGITS);
    m_brokerInfo.tickSize = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_SIZE);
    m_brokerInfo.tickValue = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_VALUE);
    
    // Calculate current spread
    double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
    double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    m_brokerInfo.spread = (ask - bid) / point;
    
    // Determine broker capabilities
    m_brokerInfo.allowsEA = (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && 
                            MQLInfoInteger(MQL_TRADE_ALLOWED) && 
                            AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
    
    m_brokerInfo.allowsHedging = (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);
    
    // Get server time and timezone
    m_brokerInfo.serverTime = TimeCurrent();
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    m_brokerInfo.timeZone = dt.hour - TimeGMT() / 3600;
    
    // Identify broker type from name
    IdentifyBrokerFromName(m_brokerInfo.companyName);
    
    return true;
}

//+------------------------------------------------------------------+
//| Detect leverage information                                      |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::DetectLeverageInfo(void)
{
    // Get basic account financial information
    m_leverageInfo.balance = AccountInfoDouble(ACCOUNT_BALANCE);
    m_leverageInfo.equity = AccountInfoDouble(ACCOUNT_EQUITY);
    m_leverageInfo.freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
    m_leverageInfo.marginRequired = AccountInfoDouble(ACCOUNT_MARGIN);
    
    // Calculate leverage information
    m_leverageInfo.currentLeverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
    m_leverageInfo.maxLeverage = m_leverageInfo.currentLeverage; // Usually the same in MT5
    
    // Calculate used leverage
    if(m_leverageInfo.equity > 0)
    {
        m_leverageInfo.usedLeverage = m_leverageInfo.marginRequired / m_leverageInfo.equity;
    }
    
    // Calculate margin level
    if(m_leverageInfo.marginRequired > 0)
    {
        m_leverageInfo.marginLevel = (m_leverageInfo.equity / m_leverageInfo.marginRequired) * 100.0;
    }
    else
    {
        m_leverageInfo.marginLevel = 100.0; // No positions open
    }
    
    // Get margin call and stop out levels
    m_leverageInfo.marginCallLevel = AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
    m_leverageInfo.stopOutLevel = AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
    
    // Check for margin call risk
    m_leverageInfo.marginCallRisk = (m_leverageInfo.marginLevel <= m_leverageInfo.marginCallLevel * 1.2); // 20% buffer
    
    // Calculate risk percentage
    if(m_leverageInfo.balance > 0)
    {
        double drawdown = m_leverageInfo.balance - m_leverageInfo.equity;
        m_leverageInfo.riskPercentage = (drawdown / m_leverageInfo.balance) * 100.0;
    }
    
    // Determine if high risk
    m_leverageInfo.isHighRisk = (m_leverageInfo.usedLeverage > 10.0 || 
                                m_leverageInfo.marginLevel < 200.0 ||
                                m_leverageInfo.riskPercentage > 20.0);
    
    // Check for leverage restrictions
    m_leverageInfo.isLeverageRestricted = CheckLeverageRestrictions();
    
    // Calculate recommended lot sizes
    m_leverageInfo.recommendedLotSize = CalculateOptimalLotSize(1.0); // 1% risk
    m_leverageInfo.maxSafeLotSize = CalculateMaxLotSize();
    
    // Determine leverage type
    if(m_leverageInfo.currentLeverage <= 50)
        m_leverageInfo.leverageType = "Conservative";
    else if(m_leverageInfo.currentLeverage <= 200)
        m_leverageInfo.leverageType = "Moderate";
    else if(m_leverageInfo.currentLeverage <= 500)
        m_leverageInfo.leverageType = "Aggressive";
    else
        m_leverageInfo.leverageType = "Extreme";
    
    return true;
}

//+------------------------------------------------------------------+
//| Classify broker type and characteristics                        |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::ClassifyBroker(void)
{
    // Determine broker type based on various factors
    m_classification.executionModel = ClassifyBrokerType();
    m_classification.brokerClass = DetermineBrokerClass();
    
    // Check regulation status
    m_classification.hasRegulation = HasRegulation(m_brokerInfo.companyName);
    
    // Calculate trust score
    m_classification.trustScore = CalculateTrustScore();
    
    // Determine platform type
    string terminalName = TerminalInfoString(TERMINAL_NAME);
    if(StringFind(terminalName, "MetaTrader 5") >= 0)
        m_classification.platformType = "MetaTrader 5";
    else if(StringFind(terminalName, "MetaTrader 4") >= 0)
        m_classification.platformType = "MetaTrader 4";
    else
        m_classification.platformType = "Unknown";
    
    // Analyze spread characteristics
    m_classification.hasVariableSpreads = true; // Assume variable spreads for MT5
    m_classification.typicalSpread = m_brokerInfo.spread;
    
    // Check broker policies
    m_classification.allowsScalping = true; // Default assumption
    m_classification.allowsHedging = m_brokerInfo.allowsHedging;
    m_classification.allowsEAs = m_brokerInfo.allowsEA;
    
    // Check for negative balance protection
    m_classification.hasNegativeBalance = (AccountInfoDouble(ACCOUNT_MARGIN_SO_SO) > 0);
    
    // Determine if ECN
    m_brokerInfo.isECN = (StringFind(m_brokerInfo.serverName, "ECN") >= 0 || 
                         StringFind(m_brokerInfo.companyName, "ECN") >= 0 ||
                         m_classification.executionModel == "ECN");
    
    return true;
}

//+------------------------------------------------------------------+
//| Assess risk based on broker and leverage information           |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::AssessRisk(void)
{
    // Initialize risk level
    m_riskAssessment.riskLevel = 1; // Start with very low risk
    
    // Assess leverage risk
    if(m_leverageInfo.currentLeverage > 500)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 5);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "Extremely high leverage detected";
    }
    else if(m_leverageInfo.currentLeverage > 200)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 4);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "High leverage detected";
    }
    else if(m_leverageInfo.currentLeverage > 100)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 3);
    }
    
    // Assess margin level risk
    if(m_leverageInfo.marginLevel < 200.0)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 4);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "Low margin level - high risk of margin call";
    }
    else if(m_leverageInfo.marginLevel < 500.0)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 3);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "Moderate margin level - monitor closely";
    }
    
    // Assess broker regulation risk
    if(!m_classification.hasRegulation)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 3);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "Broker regulation status unclear";
    }
    
    // Assess trust score risk
    if(m_classification.trustScore < 50.0)
    {
        m_riskAssessment.riskLevel = MathMax(m_riskAssessment.riskLevel, 4);
        ArrayResize(m_riskAssessment.riskWarnings, ArraySize(m_riskAssessment.riskWarnings) + 1);
        m_riskAssessment.riskWarnings[ArraySize(m_riskAssessment.riskWarnings) - 1] = "Low broker trust score";
    }
    
    // Calculate safe leverage
    m_riskAssessment.safeLeverage = MathMin(50.0, m_leverageInfo.currentLeverage / 4.0);
    
    // Calculate maximum recommended lot size
    m_riskAssessment.maxRecommendedLot = CalculateOptimalLotSize(2.0); // 2% risk
    
    // Check if over-leveraged
    m_riskAssessment.isOverLeveraged = (m_leverageInfo.usedLeverage > 10.0);
    
    // Calculate stress test result
    m_riskAssessment.stressTestResult = CalculateStressTest();
    
    // Calculate volatility impact
    m_riskAssessment.volatilityImpact = CalculateVolatilityImpact();
    
    // Determine margin buffer requirement
    m_riskAssessment.marginBuffer = MathMax(200.0, m_leverageInfo.marginCallLevel * 2.0);
    
    // Set risk description
    switch(m_riskAssessment.riskLevel)
    {
        case 1: m_riskAssessment.riskDescription = "Very Low Risk - Safe trading conditions"; break;
        case 2: m_riskAssessment.riskDescription = "Low Risk - Generally safe with minor concerns"; break;
        case 3: m_riskAssessment.riskDescription = "Medium Risk - Requires careful monitoring"; break;
        case 4: m_riskAssessment.riskDescription = "High Risk - Significant risk factors present"; break;
        case 5: m_riskAssessment.riskDescription = "Very High Risk - Dangerous trading conditions"; break;
    }
    
    // Check if margin alert is required
    m_riskAssessment.requiresMarginAlert = (m_leverageInfo.marginLevel < m_riskAssessment.marginBuffer);
    
    return true;
}

//+------------------------------------------------------------------+
//| Initialize known brokers database                               |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::InitializeKnownBrokers(void)
{
    // This is a simplified database - in practice, you'd load from a file
    ArrayResize(m_knownBrokers, 20);
    
    // Format: [Name, Type, Country, Regulation, TrustScore]
    m_knownBrokers[0][0] = "FXTM"; m_knownBrokers[0][1] = "STP"; m_knownBrokers[0][2] = "Cyprus"; m_knownBrokers[0][3] = "CySEC"; m_knownBrokers[0][4] = "85";
    m_knownBrokers[1][0] = "XM"; m_knownBrokers[1][1] = "MM"; m_knownBrokers[1][2] = "Cyprus"; m_knownBrokers[1][3] = "CySEC"; m_knownBrokers[1][4] = "82";
    m_knownBrokers[2][0] = "IC Markets"; m_knownBrokers[2][1] = "ECN"; m_knownBrokers[2][2] = "Australia"; m_knownBrokers[2][3] = "ASIC"; m_knownBrokers[2][4] = "90";
    m_knownBrokers[3][0] = "Pepperstone"; m_knownBrokers[3][1] = "ECN"; m_knownBrokers[3][2] = "Australia"; m_knownBrokers[3][3] = "ASIC"; m_knownBrokers[3][4] = "88";
    m_knownBrokers[4][0] = "Tickmill"; m_knownBrokers[4][1] = "STP"; m_knownBrokers[4][2] = "UK"; m_knownBrokers[4][3] = "FCA"; m_knownBrokers[4][4] = "87";
    m_knownBrokers[5][0] = "Admiral Markets"; m_knownBrokers[5][1] = "STP"; m_knownBrokers[5][2] = "Estonia"; m_knownBrokers[5][3] = "FCA"; m_knownBrokers[5][4] = "86";
    // Add more brokers as needed...
}

//+------------------------------------------------------------------+
//| Identify broker from company name                               |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::IdentifyBrokerFromName(string companyName)
{
    for(int i = 0; i < ArrayRange(m_knownBrokers, 0); i++)
    {
        if(StringFind(companyName, m_knownBrokers[i][0]) >= 0)
        {
            m_brokerInfo.brokerType = m_knownBrokers[i][1];
            m_brokerInfo.country = m_knownBrokers[i][2];
            m_brokerInfo.regulationType = m_knownBrokers[i][3];
            return true;
        }
    }
    
    // If not found in database, try to determine from name patterns
    if(StringFind(companyName, "ECN") >= 0)
        m_brokerInfo.brokerType = "ECN";
    else if(StringFind(companyName, "STP") >= 0)
        m_brokerInfo.brokerType = "STP";
    else
        m_brokerInfo.brokerType = "Unknown";
    
    return false;
}

//+------------------------------------------------------------------+
//| Calculate optimal lot size based on risk percentage            |
//+------------------------------------------------------------------+
double CBrokerLeverageDetector::CalculateOptimalLotSize(double riskPercent)
{
    double riskAmount = m_leverageInfo.balance * (riskPercent / 100.0);
    double stopLossPips = 50.0; // Assume 50 pip stop loss
    double pipValue = SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_VALUE) / 
                     SymbolInfoDouble(m_symbol, SYMBOL_TRADE_TICK_SIZE) * 
                     SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    
    double lotSize = riskAmount / (stopLossPips * pipValue);
    
    // Round to valid lot size
    double lotStep = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    // Ensure within broker limits
    double minLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_MAX);
    
    return MathMax(minLot, MathMin(maxLot, lotSize));
}

//+------------------------------------------------------------------+
//| Calculate maximum safe lot size                                 |
//+------------------------------------------------------------------+
double CBrokerLeverageDetector::CalculateMaxLotSize(void)
{
    double maxMarginUsage = 0.3; // Use maximum 30% of available margin
    double availableMargin = m_leverageInfo.freeMargin * maxMarginUsage;
    
    double marginRequired = SymbolInfoDouble(m_symbol, SYMBOL_MARGIN_INITIAL);
    if(marginRequired <= 0) return 0;
    
    double maxLots = availableMargin / marginRequired;
    
    // Round down to valid lot size
    double lotStep = SymbolInfoDouble(m_symbol, SYMBOL_VOLUME_STEP);
    maxLots = MathFloor(maxLots / lotStep) * lotStep;
    
    return MathMax(0, maxLots);
}

//+------------------------------------------------------------------+
//| Print comprehensive broker and leverage report                  |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::PrintFullReport(void)
{
    Print("========================================");
    Print("🏢 BROKER & LEVERAGE ANALYSIS REPORT");
    Print("========================================");
    
    PrintBrokerInfo();
    Print("----------------------------------------");
    PrintLeverageInfo();
    Print("----------------------------------------");
    PrintRiskAssessment();
    
    Print("========================================");
}

//+------------------------------------------------------------------+
//| Print broker information                                        |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::PrintBrokerInfo(void)
{
    Print("🏢 BROKER INFORMATION:");
    Print("Company: ", m_brokerInfo.companyName);
    Print("Server: ", m_brokerInfo.serverName);
    Print("Type: ", m_brokerInfo.brokerType);
    Print("Country: ", m_brokerInfo.country);
    Print("Regulation: ", m_brokerInfo.regulationType);
    Print("Account Type: ", m_brokerInfo.isDemo ? "DEMO" : "LIVE");
    Print("Trading Mode: ", m_brokerInfo.tradingMode);
    Print("Platform: ", m_classification.platformType);
    Print("Current Spread: ", DoubleToString(m_brokerInfo.spread, 1), " points");
    Print("Allows EAs: ", m_brokerInfo.allowsEA ? "✅ YES" : "❌ NO");
    Print("Allows Hedging: ", m_brokerInfo.allowsHedging ? "✅ YES" : "❌ NO");
    Print("Trust Score: ", DoubleToString(m_classification.trustScore, 1), "/100");
}

//+------------------------------------------------------------------+
//| Print leverage information                                       |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::PrintLeverageInfo(void)
{
    Print("⚖️ LEVERAGE INFORMATION:");
    Print("Current Leverage: 1:", DoubleToString(m_leverageInfo.currentLeverage, 0));
    Print("Leverage Type: ", m_leverageInfo.leverageType);
    Print("Used Leverage: 1:", DoubleToString(m_leverageInfo.usedLeverage, 2));
    Print("Account Balance: ", DoubleToString(m_leverageInfo.balance, 2), " ", m_brokerInfo.currency);
    Print("Account Equity: ", DoubleToString(m_leverageInfo.equity, 2), " ", m_brokerInfo.currency);
    Print("Free Margin: ", DoubleToString(m_leverageInfo.freeMargin, 2), " ", m_brokerInfo.currency);
    Print("Margin Level: ", DoubleToString(m_leverageInfo.marginLevel, 2), "%");
    Print("Margin Call Level: ", DoubleToString(m_leverageInfo.marginCallLevel, 2), "%");
    Print("Stop Out Level: ", DoubleToString(m_leverageInfo.stopOutLevel, 2), "%");
    Print("Recommended Lot Size: ", DoubleToString(m_leverageInfo.recommendedLotSize, 2));
    Print("Max Safe Lot Size: ", DoubleToString(m_leverageInfo.maxSafeLotSize, 2));
}

//+------------------------------------------------------------------+
//| Print risk assessment                                           |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::PrintRiskAssessment(void)
{
    Print("⚠️ RISK ASSESSMENT:");
    Print("Risk Level: ", m_riskAssessment.riskLevel, "/5 (", m_riskAssessment.riskDescription, ")");
    Print("Over-leveraged: ", m_riskAssessment.isOverLeveraged ? "⚠️ YES" : "✅ NO");
    Print("Margin Call Risk: ", m_leverageInfo.marginCallRisk ? "⚠️ HIGH" : "✅ LOW");
    Print("Safe Leverage: 1:", DoubleToString(m_riskAssessment.safeLeverage, 0));
    Print("Stress Test Result: ", DoubleToString(m_riskAssessment.stressTestResult, 2), "%");
    
    if(ArraySize(m_riskAssessment.riskWarnings) > 0)
    {
        Print("⚠️ RISK WARNINGS:");
        for(int i = 0; i < ArraySize(m_riskAssessment.riskWarnings); i++)
        {
            Print("  • ", m_riskAssessment.riskWarnings[i]);
        }
    }
}

//+------------------------------------------------------------------+
//| Check leverage restrictions                                      |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::CheckLeverageRestrictions(void)
{
    // Check if leverage is restricted based on account equity
    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    
    // Many brokers reduce leverage for larger accounts
    if(equity > 100000 && m_leverageInfo.currentLeverage > 100)
    {
        m_leverageInfo.leverageRestrictionReason = "High equity account - leverage may be restricted";
        return true;
    }
    
    // Check for weekend leverage restrictions
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    if(dt.day_of_week == 0 || dt.day_of_week == 6) // Sunday or Saturday
    {
        m_leverageInfo.leverageRestrictionReason = "Weekend leverage restrictions may apply";
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Calculate stress test result                                    |
//+------------------------------------------------------------------+
double CBrokerLeverageDetector::CalculateStressTest(void)
{
    // Simulate a 2% adverse movement in all positions
    double stressMovement = 0.02; // 2%
    double currentEquity = m_leverageInfo.equity;
    double totalMargin = m_leverageInfo.marginRequired;
    
    if(totalMargin == 0) return 100.0; // No positions
    
    // Estimate potential loss
    double estimatedLoss = totalMargin * m_leverageInfo.usedLeverage * stressMovement;
    double stressEquity = currentEquity - estimatedLoss;
    
    // Calculate margin level after stress
    double stressMarginLevel = (stressEquity / totalMargin) * 100.0;
    
    return MathMax(0, stressMarginLevel);
}

//+------------------------------------------------------------------+
//| Calculate volatility impact                                     |
//+------------------------------------------------------------------+
double CBrokerLeverageDetector::CalculateVolatilityImpact(void)
{
    // Get ATR for volatility measurement
    double atr = iATR(m_symbol, PERIOD_CURRENT, 14, 0);
    double currentPrice = SymbolInfoDouble(m_symbol, SYMBOL_BID);
    
    if(currentPrice == 0) return 0;
    
    // Calculate volatility as percentage
    double volatilityPercent = (atr / currentPrice) * 100.0;
    
    // High volatility increases risk
    return volatilityPercent * m_leverageInfo.usedLeverage;
}

//+------------------------------------------------------------------+
//| Load broker database                                            |
//+------------------------------------------------------------------+
void CBrokerLeverageDetector::LoadBrokerDatabase(void)
{
    // In a full implementation, this would load from a file or online database
    InitializeKnownBrokers();
}

//+------------------------------------------------------------------+
//| Get comprehensive status string                                 |
//+------------------------------------------------------------------+
string CBrokerLeverageDetector::GetComprehensiveReport(void)
{
    string report = StringFormat("Broker: %s | Leverage: 1:%g | Risk: %d/5 | Margin: %.1f%%",
                                m_brokerInfo.companyName,
                                m_leverageInfo.currentLeverage,
                                m_riskAssessment.riskLevel,
                                m_leverageInfo.marginLevel);
    
    if(m_leverageInfo.marginCallRisk)
        report += " ⚠️ MARGIN RISK";
    
    if(m_riskAssessment.isOverLeveraged)
        report += " ⚠️ OVER-LEVERAGED";
    
    return report;
}

//+------------------------------------------------------------------+
//| Calculate trust score                                           |
//+------------------------------------------------------------------+
double CBrokerLeverageDetector::CalculateTrustScore(void)
{
    double score = 50.0; // Base score
    
    // Check if broker is in known database
    string brokerData = FindBrokerInDatabase(m_brokerInfo.companyName);
    if(brokerData != "")
    {
        score = StringToDouble(brokerData);
    }
    else
    {
        // Calculate score based on available information
        if(m_classification.hasRegulation) score += 20.0;
        if(m_brokerInfo.isECN) score += 10.0;
        if(StringFind(m_brokerInfo.serverName, "demo") < 0) score += 5.0; // Not obviously demo
        if(m_brokerInfo.allowsEA) score += 5.0;
        if(m_brokerInfo.spread < 2.0) score += 10.0; // Competitive spreads
    }
    
    return MathMax(0, MathMin(100, score));
}

//+------------------------------------------------------------------+
//| Find broker in database                                         |
//+------------------------------------------------------------------+
string CBrokerLeverageDetector::FindBrokerInDatabase(string name)
{
    for(int i = 0; i < ArrayRange(m_knownBrokers, 0); i++)
    {
        if(StringFind(name, m_knownBrokers[i][0]) >= 0)
        {
            return m_knownBrokers[i][4]; // Return trust score
        }
    }
    return "";
}

//+------------------------------------------------------------------+
//| Check if broker has regulation                                  |
//+------------------------------------------------------------------+
bool CBrokerLeverageDetector::HasRegulation(string companyName)
{
    // Check if regulation info is already detected
    if(m_brokerInfo.regulationType != "" && m_brokerInfo.regulationType != "Unknown")
        return true;
    
    // Check common regulatory keywords in company name
    string regulators[] = {"FCA", "CySEC", "ASIC", "FSA", "CFTC", "NFA", "FINRA", "BaFin", "AMF", "CONSOB"};
    
    for(int i = 0; i < ArraySize(regulators); i++)
    {
        if(StringFind(companyName, regulators[i]) >= 0)
            return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Classify broker type                                            |
//+------------------------------------------------------------------+
string CBrokerLeverageDetector::ClassifyBrokerType(void)
{
    if(m_brokerInfo.brokerType != "" && m_brokerInfo.brokerType != "Unknown")
        return m_brokerInfo.brokerType;
    
    // Try to determine from server name or company name
    string name = m_brokerInfo.companyName + " " + m_brokerInfo.serverName;
    StringToUpper(name);
    
    if(StringFind(name, "ECN") >= 0)
        return "ECN";
    else if(StringFind(name, "STP") >= 0)
        return "STP";
    else if(StringFind(name, "MARKET") >= 0 && StringFind(name, "MAKER") >= 0)
        return "Market Maker";
    else
        return "Unknown";
}

//+------------------------------------------------------------------+
//| Determine broker class (A-Book vs B-Book)                      |
//+------------------------------------------------------------------+
string CBrokerLeverageDetector::DetermineBrokerClass(void)
{
    // This is complex to determine definitively, use heuristics
    if(m_classification.executionModel == "ECN")
        return "A-Book";
    else if(m_classification.executionModel == "STP")
        return "A-Book";
    else if(m_classification.executionModel == "Market Maker")
        return "B-Book";
    else
        return "Unknown";
}