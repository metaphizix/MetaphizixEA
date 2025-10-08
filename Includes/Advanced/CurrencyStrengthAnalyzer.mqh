//+------------------------------------------------------------------+
//|                                     CurrencyStrengthAnalyzer.mqh |
//|                                   Advanced Currency Strength    |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Currency Strength Analysis Class                               |
//+------------------------------------------------------------------+
class CCurrencyStrengthAnalyzer
{
private:
    //--- Currency data
    struct CurrencyData
    {
        string currency;
        double strength;
        double momentum;
        double trend;
        double volatility;
        double interestRate;
        double economicScore;
        double technicalScore;
        double fundamentalScore;
        double overallRanking;
        int rank;
        bool isBullish;
        bool isBearish;
        datetime lastUpdate;
    };
    
    CurrencyData m_currencies[8]; // USD, EUR, GBP, JPY, CHF, CAD, AUD, NZD
    int m_currencyCount;
    
    //--- Currency pairs matrix
    struct PairAnalysis
    {
        string pair;
        string baseCurrency;
        string quoteCurrency;
        double strengthDifferential;
        double expectedDirection;
        double confidence;
        ENUM_ORDER_TYPE signal;
        bool isValidSignal;
    };
    
    PairAnalysis m_pairMatrix[28]; // All major combinations
    int m_pairCount;
    
    //--- Economic indicators
    struct EconomicIndicators
    {
        string currency;
        double gdpGrowth;
        double inflation;
        double unemployment;
        double interestRate;
        double tradeBalance;
        double currentAccount;
        double debtToGDP;
        double manufacturingPMI;
        double servicesPMI;
        double consumerConfidence;
        double economicHealthScore;
    };
    
    EconomicIndicators m_economicData[8];
    
    //--- Central bank policy
    struct CentralBankPolicy
    {
        string currency;
        string centralBank;
        double currentRate;
        string rateDirection; // "RAISING", "CUTTING", "NEUTRAL"
        double rateProbability;
        string policyStance; // "HAWKISH", "DOVISH", "NEUTRAL"
        datetime nextMeeting;
        double expectedRateChange;
    };
    
    CentralBankPolicy m_centralBankData[8];
    
    //--- Market sentiment by currency
    struct CurrencySentiment
    {
        string currency;
        double bullishPositioning;
        double bearishPositioning;
        double netPositioning;
        double retailSentiment;
        double institutionalFlow;
        double hedgeFundPositioning;
        double centralBankIntervention;
        double overallSentiment;
    };
    
    CurrencySentiment m_sentiment[8];

public:
    //--- Constructor
    CCurrencyStrengthAnalyzer();
    
    //--- Initialization
    bool Initialize();
    void LoadCurrencyData();
    void LoadEconomicData();
    void LoadCentralBankData();
    
    //--- Core analysis
    void CalculateCurrencyStrengths();
    void AnalyzeTechnicalStrength(string currency);
    void AnalyzeFundamentalStrength(string currency);
    void AnalyzeEconomicStrength(string currency);
    void RankCurrencies();
    
    //--- Pair analysis
    void AnalyzeCurrencyPairs();
    double CalculateStrengthDifferential(string baseCurrency, string quoteCurrency);
    ENUM_ORDER_TYPE GetPairSignal(string pair);
    double GetPairConfidence(string pair);
    string GetStrongestPair();
    string GetWeakestPair();
    
    //--- Currency-specific analysis
    double GetCurrencyStrength(string currency);
    double GetCurrencyMomentum(string currency);
    double GetCurrencyTrend(string currency);
    int GetCurrencyRank(string currency);
    bool IsCurrencyBullish(string currency);
    bool IsCurrencyBearish(string currency);
    
    //--- Economic analysis
    void UpdateEconomicIndicators();
    double GetEconomicHealthScore(string currency);
    double GetInflationImpact(string currency);
    double GetGDPImpact(string currency);
    double GetEmploymentImpact(string currency);
    
    //--- Interest rate analysis
    void AnalyzeInterestRateDifferentials();
    double GetRateDifferential(string currency1, string currency2);
    string GetRateDirection(string currency);
    double GetCarryTradeScore(string currency);
    bool IsCarryTradeFavorable(string baseCurrency, string quoteCurrency);
    
    //--- Central bank analysis
    void AnalyzeCentralBankPolicies();
    string GetCentralBankStance(string currency);
    double GetHawkishnesScore(string currency);
    bool IsRateHikeCycle(string currency);
    bool IsRateCutCycle(string currency);
    
    //--- Market positioning
    void AnalyzeMarketPositioning();
    double GetNetPositioning(string currency);
    bool IsOverBought(string currency);
    bool IsOverSold(string currency);
    double GetContrarian_signal(string currency);
    
    //--- Relative strength
    string GetStrongestCurrency();
    string GetWeakestCurrency();
    void GetTopCurrencies(string &strongCurrencies[], string &weakCurrencies[]);
    double GetRelativeStrength(string currency1, string currency2);
    
    //--- Signal generation
    ENUM_ORDER_TYPE GetCurrencySignal(string pair);
    double GetSignalStrength(string pair);
    bool ValidateCurrencySignal(string pair, ENUM_ORDER_TYPE signal);
    string GetBestTradingPair();
    
    //--- Risk analysis
    double GetCurrencyRisk(string currency);
    double GetPairVolatility(string pair);
    bool IsHighRiskCurrency(string currency);
    double GetSafehavenScore(string currency);
    
    //--- Correlation analysis
    double GetCurrencyCorrelation(string currency1, string currency2);
    void BuildCorrelationMatrix();
    bool IsHighCorrelation(string currency1, string currency2);
    
    //--- News and events
    void CheckCurrencyEvents(string currency);
    bool IsHighImpactEvent(string currency);
    double GetNewsImpactScore(string currency);
    
    //--- Seasonal analysis
    double GetSeasonalStrength(string currency);
    bool IsSeasonallyBullish(string currency);
    bool IsSeasonallyBearish(string currency);
    
    //--- Technical patterns
    bool DetectCurrencyBreakout(string currency);
    bool IsCurrencyTrending(string currency);
    bool IsCurrencyRanging(string currency);
    
    //--- Information functions
    CurrencyData GetCurrencyData(string currency);
    PairAnalysis GetPairAnalysis(string pair);
    EconomicIndicators GetEconomicData(string currency);
    CentralBankPolicy GetCentralBankPolicy(string currency);
    
    //--- Utility functions
    int FindCurrencyIndex(string currency);
    int FindPairIndex(string pair);
    string CreatePairName(string base, string quote);
    bool IsValidCurrency(string currency);
    
    //--- Reporting
    void PrintCurrencyStrengths();
    void PrintCurrencyRankings();
    void PrintPairAnalysis();
    void PrintEconomicSummary();
    string GetStrengthSummary();
    
    //--- Advanced features
    void ImplementCurrencyMomentum();
    void DetectCurrencyRotation();
    bool IsCurrencyRotationSignal();
    void PredictCurrencyMovements();
    
    //--- Backtesting
    void BacktestCurrencyStrategy();
    double GetStrategyPerformance();
    void OptimizeCurrencyWeights();
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCurrencyStrengthAnalyzer::CCurrencyStrengthAnalyzer()
{
    //--- Initialize currency list
    m_currencies[0].currency = "USD";
    m_currencies[1].currency = "EUR";
    m_currencies[2].currency = "GBP";
    m_currencies[3].currency = "JPY";
    m_currencies[4].currency = "CHF";
    m_currencies[5].currency = "CAD";
    m_currencies[6].currency = "AUD";
    m_currencies[7].currency = "NZD";
    
    m_currencyCount = 8;
    
    //--- Initialize currency data
    for(int i = 0; i < m_currencyCount; i++)
    {
        m_currencies[i].strength = 50.0;
        m_currencies[i].momentum = 0.0;
        m_currencies[i].trend = 0.0;
        m_currencies[i].volatility = 0.0;
        m_currencies[i].interestRate = 0.0;
        m_currencies[i].economicScore = 50.0;
        m_currencies[i].technicalScore = 50.0;
        m_currencies[i].fundamentalScore = 50.0;
        m_currencies[i].overallRanking = 50.0;
        m_currencies[i].rank = i + 1;
        m_currencies[i].isBullish = false;
        m_currencies[i].isBearish = false;
        m_currencies[i].lastUpdate = TimeCurrent();
    }
    
    //--- Initialize pair count
    m_pairCount = 0;
    
    //--- Load initial data
    LoadCurrencyData();
    LoadEconomicData();
    LoadCentralBankData();
    
    Print("💱 Currency Strength Analyzer initialized with ", m_currencyCount, " currencies");
}

//+------------------------------------------------------------------+
//| Initialize currency strength analyzer                         |
//+------------------------------------------------------------------+
bool CCurrencyStrengthAnalyzer::Initialize()
{
    //--- Calculate initial currency strengths
    CalculateCurrencyStrengths();
    
    //--- Rank currencies
    RankCurrencies();
    
    //--- Analyze currency pairs
    AnalyzeCurrencyPairs();
    
    //--- Update market positioning
    AnalyzeMarketPositioning();
    
    Print("✅ Currency Strength Analyzer initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Load currency data                                            |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::LoadCurrencyData()
{
    //--- Load current interest rates (simplified data)
    m_currencies[0].interestRate = 5.25; // USD
    m_currencies[1].interestRate = 4.50; // EUR
    m_currencies[2].interestRate = 5.25; // GBP
    m_currencies[3].interestRate = -0.10; // JPY
    m_currencies[4].interestRate = 1.75; // CHF
    m_currencies[5].interestRate = 5.00; // CAD
    m_currencies[6].interestRate = 4.35; // AUD
    m_currencies[7].interestRate = 5.50; // NZD
    
    Print("📊 Currency data loaded");
}

//+------------------------------------------------------------------+
//| Load economic data                                            |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::LoadEconomicData()
{
    //--- Load simplified economic data
    for(int i = 0; i < m_currencyCount; i++)
    {
        m_economicData[i].currency = m_currencies[i].currency;
        
        //--- Assign realistic economic values
        if(m_currencies[i].currency == "USD")
        {
            m_economicData[i].gdpGrowth = 2.1;
            m_economicData[i].inflation = 3.2;
            m_economicData[i].unemployment = 3.7;
            m_economicData[i].economicHealthScore = 85.0;
        }
        else if(m_currencies[i].currency == "EUR")
        {
            m_economicData[i].gdpGrowth = 0.8;
            m_economicData[i].inflation = 2.9;
            m_economicData[i].unemployment = 6.5;
            m_economicData[i].economicHealthScore = 75.0;
        }
        else if(m_currencies[i].currency == "GBP")
        {
            m_economicData[i].gdpGrowth = 0.5;
            m_economicData[i].inflation = 4.0;
            m_economicData[i].unemployment = 4.2;
            m_economicData[i].economicHealthScore = 70.0;
        }
        else if(m_currencies[i].currency == "JPY")
        {
            m_economicData[i].gdpGrowth = 0.2;
            m_economicData[i].inflation = 2.5;
            m_economicData[i].unemployment = 2.6;
            m_economicData[i].economicHealthScore = 78.0;
        }
        else
        {
            //--- Default values for other currencies
            m_economicData[i].gdpGrowth = 1.5;
            m_economicData[i].inflation = 3.0;
            m_economicData[i].unemployment = 5.0;
            m_economicData[i].economicHealthScore = 72.0;
        }
    }
    
    Print("📈 Economic data loaded");
}

//+------------------------------------------------------------------+
//| Load central bank data                                        |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::LoadCentralBankData()
{
    for(int i = 0; i < m_currencyCount; i++)
    {
        m_centralBankData[i].currency = m_currencies[i].currency;
        m_centralBankData[i].currentRate = m_currencies[i].interestRate;
        
        //--- Assign policy stances
        if(m_currencies[i].currency == "USD")
        {
            m_centralBankData[i].centralBank = "Federal Reserve";
            m_centralBankData[i].policyStance = "NEUTRAL";
            m_centralBankData[i].rateDirection = "NEUTRAL";
        }
        else if(m_currencies[i].currency == "EUR")
        {
            m_centralBankData[i].centralBank = "European Central Bank";
            m_centralBankData[i].policyStance = "NEUTRAL";
            m_centralBankData[i].rateDirection = "RAISING";
        }
        else if(m_currencies[i].currency == "JPY")
        {
            m_centralBankData[i].centralBank = "Bank of Japan";
            m_centralBankData[i].policyStance = "DOVISH";
            m_centralBankData[i].rateDirection = "NEUTRAL";
        }
        else
        {
            m_centralBankData[i].policyStance = "NEUTRAL";
            m_centralBankData[i].rateDirection = "NEUTRAL";
        }
    }
    
    Print("🏛️ Central bank data loaded");
}

//+------------------------------------------------------------------+
//| Calculate currency strengths                                  |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::CalculateCurrencyStrengths()
{
    for(int i = 0; i < m_currencyCount; i++)
    {
        string currency = m_currencies[i].currency;
        
        //--- Analyze technical strength
        AnalyzeTechnicalStrength(currency);
        
        //--- Analyze fundamental strength
        AnalyzeFundamentalStrength(currency);
        
        //--- Analyze economic strength
        AnalyzeEconomicStrength(currency);
        
        //--- Calculate overall strength
        m_currencies[i].strength = (m_currencies[i].technicalScore * 0.4) +
                                 (m_currencies[i].fundamentalScore * 0.35) +
                                 (m_currencies[i].economicScore * 0.25);
        
        //--- Determine bullish/bearish status
        m_currencies[i].isBullish = m_currencies[i].strength > 65.0;
        m_currencies[i].isBearish = m_currencies[i].strength < 35.0;
        
        m_currencies[i].lastUpdate = TimeCurrent();
    }
    
    Print("💪 Currency strengths calculated");
}

//+------------------------------------------------------------------+
//| Analyze technical strength                                     |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::AnalyzeTechnicalStrength(string currency)
{
    int currencyIndex = FindCurrencyIndex(currency);
    if(currencyIndex == -1) return;
    
    double technicalScore = 50.0; // Neutral baseline
    int bullishCount = 0;
    int bearishCount = 0;
    int totalPairs = 0;
    
    //--- Analyze currency against all other major currencies
    for(int i = 0; i < m_currencyCount; i++)
    {
        if(i == currencyIndex) continue;
        
        string otherCurrency = m_currencies[i].currency;
        string pair1 = currency + otherCurrency;
        string pair2 = otherCurrency + currency;
        
        //--- Try both pair combinations
        bool foundPair = false;
        string actualPair = "";
        bool isBaseCurrency = false;
        
        //--- Check if pair exists in market
        if(SymbolInfoInteger(pair1, SYMBOL_SELECT))
        {
            actualPair = pair1;
            isBaseCurrency = true;
            foundPair = true;
        }
        else if(SymbolInfoInteger(pair2, SYMBOL_SELECT))
        {
            actualPair = pair2;
            isBaseCurrency = false;
            foundPair = true;
        }
        
        if(foundPair)
        {
            //--- Analyze trend for this pair
            double sma20 = iMA(actualPair, PERIOD_D1, 20, 0, MODE_SMA, PRICE_CLOSE, 0);
            double sma50 = iMA(actualPair, PERIOD_D1, 50, 0, MODE_SMA, PRICE_CLOSE, 0);
            double currentPrice = iClose(actualPair, PERIOD_D1, 0);
            
            bool pairBullish = (currentPrice > sma20 && sma20 > sma50);
            bool pairBearish = (currentPrice < sma20 && sma20 < sma50);
            
            //--- Adjust for currency position in pair
            if(isBaseCurrency)
            {
                if(pairBullish) bullishCount++;
                if(pairBearish) bearishCount++;
            }
            else
            {
                if(pairBullish) bearishCount++; // Pair up = quote currency strong
                if(pairBearish) bullishCount++; // Pair down = quote currency weak
            }
            
            totalPairs++;
        }
    }
    
    //--- Calculate technical score
    if(totalPairs > 0)
    {
        double bullishRatio = (double)bullishCount / totalPairs;
        double bearishRatio = (double)bearishCount / totalPairs;
        
        technicalScore = 50.0 + ((bullishRatio - bearishRatio) * 50.0);
        technicalScore = MathMax(0, MathMin(100, technicalScore));
    }
    
    m_currencies[currencyIndex].technicalScore = technicalScore;
    
    //--- Calculate momentum and trend
    m_currencies[currencyIndex].momentum = (bullishCount - bearishCount) * 10;
    m_currencies[currencyIndex].trend = technicalScore - 50.0;
}

//+------------------------------------------------------------------+
//| Analyze fundamental strength                                   |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::AnalyzeFundamentalStrength(string currency)
{
    int currencyIndex = FindCurrencyIndex(currency);
    if(currencyIndex == -1) return;
    
    double fundamentalScore = 50.0; // Neutral baseline
    
    //--- Interest rate component (30%)
    double rateScore = 50.0;
    double currentRate = m_currencies[currencyIndex].interestRate;
    
    if(currentRate > 4.0)
        rateScore = 80.0; // High rates are attractive
    else if(currentRate > 2.0)
        rateScore = 65.0;
    else if(currentRate > 0.0)
        rateScore = 50.0;
    else
        rateScore = 30.0; // Negative rates are unattractive
    
    //--- Central bank policy component (25%)
    double policyScore = 50.0;
    string policyStance = GetCentralBankStance(currency);
    
    if(policyStance == "HAWKISH")
        policyScore = 75.0;
    else if(policyStance == "DOVISH")
        policyScore = 25.0;
    else
        policyScore = 50.0;
    
    //--- Economic health component (25%)
    double economicScore = GetEconomicHealthScore(currency);
    
    //--- Safe haven status (20%)
    double safehavenScore = GetSafehavenScore(currency);
    
    //--- Combine all components
    fundamentalScore = (rateScore * 0.30) + (policyScore * 0.25) + 
                      (economicScore * 0.25) + (safehavenScore * 0.20);
    
    m_currencies[currencyIndex].fundamentalScore = fundamentalScore;
}

//+------------------------------------------------------------------+
//| Analyze economic strength                                      |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::AnalyzeEconomicStrength(string currency)
{
    int currencyIndex = FindCurrencyIndex(currency);
    if(currencyIndex == -1) return;
    
    int economicIndex = FindCurrencyIndex(currency);
    if(economicIndex == -1) return;
    
    m_currencies[currencyIndex].economicScore = m_economicData[economicIndex].economicHealthScore;
}

//+------------------------------------------------------------------+
//| Rank currencies                                               |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::RankCurrencies()
{
    //--- Sort currencies by strength
    for(int i = 0; i < m_currencyCount - 1; i++)
    {
        for(int j = i + 1; j < m_currencyCount; j++)
        {
            if(m_currencies[j].strength > m_currencies[i].strength)
            {
                //--- Swap currencies
                CurrencyData temp = m_currencies[i];
                m_currencies[i] = m_currencies[j];
                m_currencies[j] = temp;
            }
        }
    }
    
    //--- Assign ranks
    for(int i = 0; i < m_currencyCount; i++)
    {
        m_currencies[i].rank = i + 1;
        m_currencies[i].overallRanking = m_currencies[i].strength;
    }
    
    Print("🏆 Currencies ranked: ", m_currencies[0].currency, " (strongest), ", 
          m_currencies[m_currencyCount-1].currency, " (weakest)");
}

//+------------------------------------------------------------------+
//| Analyze currency pairs                                        |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::AnalyzeCurrencyPairs()
{
    m_pairCount = 0;
    
    //--- Analyze all possible major pairs
    for(int i = 0; i < m_currencyCount; i++)
    {
        for(int j = 0; j < m_currencyCount; j++)
        {
            if(i == j || m_pairCount >= 28) continue;
            
            string baseCurrency = m_currencies[i].currency;
            string quoteCurrency = m_currencies[j].currency;
            string pair = CreatePairName(baseCurrency, quoteCurrency);
            
            //--- Check if pair exists
            if(SymbolInfoInteger(pair, SYMBOL_SELECT))
            {
                m_pairMatrix[m_pairCount].pair = pair;
                m_pairMatrix[m_pairCount].baseCurrency = baseCurrency;
                m_pairMatrix[m_pairMatrix].quoteCurrency = quoteCurrency;
                
                //--- Calculate strength differential
                m_pairMatrix[m_pairCount].strengthDifferential = 
                    CalculateStrengthDifferential(baseCurrency, quoteCurrency);
                
                //--- Generate signal
                m_pairMatrix[m_pairCount].signal = GetPairSignal(pair);
                m_pairMatrix[m_pairCount].confidence = GetPairConfidence(pair);
                m_pairMatrix[m_pairCount].isValidSignal = (m_pairMatrix[m_pairCount].confidence > 60.0);
                
                m_pairCount++;
            }
        }
    }
    
    Print("💱 Analyzed ", m_pairCount, " currency pairs");
}

//+------------------------------------------------------------------+
//| Calculate strength differential                               |
//+------------------------------------------------------------------+
double CCurrencyStrengthAnalyzer::CalculateStrengthDifferential(string baseCurrency, string quoteCurrency)
{
    double baseStrength = GetCurrencyStrength(baseCurrency);
    double quoteStrength = GetCurrencyStrength(quoteCurrency);
    
    return baseStrength - quoteStrength;
}

//+------------------------------------------------------------------+
//| Get pair signal                                               |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CCurrencyStrengthAnalyzer::GetPairSignal(string pair)
{
    int pairIndex = FindPairIndex(pair);
    if(pairIndex == -1) return -1;
    
    double differential = m_pairMatrix[pairIndex].strengthDifferential;
    
    //--- Strong differential suggests trend direction
    if(differential > 15.0)
        return ORDER_TYPE_BUY;  // Base currency much stronger
    else if(differential < -15.0)
        return ORDER_TYPE_SELL; // Quote currency much stronger
    
    return -1; // No clear signal
}

//+------------------------------------------------------------------+
//| Get pair confidence                                           |
//+------------------------------------------------------------------+
double CCurrencyStrengthAnalyzer::GetPairConfidence(string pair)
{
    int pairIndex = FindPairIndex(pair);
    if(pairIndex == -1) return 0.0;
    
    double differential = MathAbs(m_pairMatrix[pairIndex].strengthDifferential);
    
    //--- Higher differential = higher confidence
    double confidence = differential * 2; // Scale to 0-100
    confidence = MathMin(95.0, confidence); // Cap at 95%
    
    return confidence;
}

//+------------------------------------------------------------------+
//| Get currency strength                                         |
//+------------------------------------------------------------------+
double CCurrencyStrengthAnalyzer::GetCurrencyStrength(string currency)
{
    int index = FindCurrencyIndex(currency);
    if(index != -1)
        return m_currencies[index].strength;
    
    return 50.0; // Default neutral
}

//+------------------------------------------------------------------+
//| Get currency rank                                             |
//+------------------------------------------------------------------+
int CCurrencyStrengthAnalyzer::GetCurrencyRank(string currency)
{
    int index = FindCurrencyIndex(currency);
    if(index != -1)
        return m_currencies[index].rank;
    
    return 5; // Default middle rank
}

//+------------------------------------------------------------------+
//| Get strongest currency                                        |
//+------------------------------------------------------------------+
string CCurrencyStrengthAnalyzer::GetStrongestCurrency()
{
    return m_currencies[0].currency; // Already sorted by strength
}

//+------------------------------------------------------------------+
//| Get weakest currency                                          |
//+------------------------------------------------------------------+
string CCurrencyStrengthAnalyzer::GetWeakestCurrency()
{
    return m_currencies[m_currencyCount - 1].currency;
}

//+------------------------------------------------------------------+
//| Get central bank stance                                       |
//+------------------------------------------------------------------+
string CCurrencyStrengthAnalyzer::GetCentralBankStance(string currency)
{
    int index = FindCurrencyIndex(currency);
    if(index != -1)
        return m_centralBankData[index].policyStance;
    
    return "NEUTRAL";
}

//+------------------------------------------------------------------+
//| Get economic health score                                     |
//+------------------------------------------------------------------+
double CCurrencyStrengthAnalyzer::GetEconomicHealthScore(string currency)
{
    int index = FindCurrencyIndex(currency);
    if(index != -1)
        return m_economicData[index].economicHealthScore;
    
    return 50.0;
}

//+------------------------------------------------------------------+
//| Get safe haven score                                          |
//+------------------------------------------------------------------+
double CCurrencyStrengthAnalyzer::GetSafehavenScore(string currency)
{
    //--- Safe haven scores based on traditional safe haven status
    if(currency == "USD") return 85.0;      // Primary safe haven
    else if(currency == "CHF") return 80.0; // Traditional safe haven
    else if(currency == "JPY") return 75.0; // Safe haven in risk-off
    else if(currency == "EUR") return 60.0; // Moderate safe haven
    else if(currency == "GBP") return 50.0; // Neutral
    else return 40.0; // Commodity currencies typically risk-on
}

//+------------------------------------------------------------------+
//| Find currency index                                           |
//+------------------------------------------------------------------+
int CCurrencyStrengthAnalyzer::FindCurrencyIndex(string currency)
{
    for(int i = 0; i < m_currencyCount; i++)
    {
        if(m_currencies[i].currency == currency)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Find pair index                                               |
//+------------------------------------------------------------------+
int CCurrencyStrengthAnalyzer::FindPairIndex(string pair)
{
    for(int i = 0; i < m_pairCount; i++)
    {
        if(m_pairMatrix[i].pair == pair)
            return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Create pair name                                              |
//+------------------------------------------------------------------+
string CCurrencyStrengthAnalyzer::CreatePairName(string base, string quote)
{
    return base + quote;
}

//+------------------------------------------------------------------+
//| Analyze market positioning                                    |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::AnalyzeMarketPositioning()
{
    for(int i = 0; i < m_currencyCount; i++)
    {
        string currency = m_currencies[i].currency;
        
        //--- Simulate positioning data
        m_sentiment[i].currency = currency;
        
        //--- Estimate positioning based on strength and momentum
        double strength = m_currencies[i].strength;
        double momentum = m_currencies[i].momentum;
        
        if(strength > 70)
        {
            m_sentiment[i].bullishPositioning = 70.0 + (MathRand() % 20);
            m_sentiment[i].bearishPositioning = 20.0 + (MathRand() % 20);
        }
        else if(strength < 30)
        {
            m_sentiment[i].bullishPositioning = 20.0 + (MathRand() % 20);
            m_sentiment[i].bearishPositioning = 70.0 + (MathRand() % 20);
        }
        else
        {
            m_sentiment[i].bullishPositioning = 40.0 + (MathRand() % 20);
            m_sentiment[i].bearishPositioning = 40.0 + (MathRand() % 20);
        }
        
        m_sentiment[i].netPositioning = m_sentiment[i].bullishPositioning - m_sentiment[i].bearishPositioning;
        m_sentiment[i].overallSentiment = strength;
    }
}

//+------------------------------------------------------------------+
//| Get best trading pair                                         |
//+------------------------------------------------------------------+
string CCurrencyStrengthAnalyzer::GetBestTradingPair()
{
    double bestConfidence = 0.0;
    string bestPair = "";
    
    for(int i = 0; i < m_pairCount; i++)
    {
        if(m_pairMatrix[i].isValidSignal && m_pairMatrix[i].confidence > bestConfidence)
        {
            bestConfidence = m_pairMatrix[i].confidence;
            bestPair = m_pairMatrix[i].pair;
        }
    }
    
    return bestPair;
}

//+------------------------------------------------------------------+
//| Print currency strengths                                      |
//+------------------------------------------------------------------+
void CCurrencyStrengthAnalyzer::PrintCurrencyStrengths()
{
    Print("═══════════════════════════════════════");
    Print("💱 CURRENCY STRENGTH ANALYSIS");
    Print("═══════════════════════════════════════");
    
    for(int i = 0; i < m_currencyCount; i++)
    {
        string status = m_currencies[i].isBullish ? "BULLISH" : 
                       (m_currencies[i].isBearish ? "BEARISH" : "NEUTRAL");
        
        Print(IntegerToString(m_currencies[i].rank), ". ", m_currencies[i].currency, 
              ": ", DoubleToString(m_currencies[i].strength, 1), 
              "% (", status, ")");
    }
    
    Print("───────────────────────────────────────");
    Print("💪 Strongest: ", GetStrongestCurrency());
    Print("📉 Weakest: ", GetWeakestCurrency());
    Print("🎯 Best Pair: ", GetBestTradingPair());
    Print("═══════════════════════════════════════");
}