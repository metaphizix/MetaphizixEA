//+------------------------------------------------------------------+
//|                                        SpreadManipulationDetector.mqh |
//|                                   Copyright 2025, MetaphizixEA Team |
//|                               https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://github.com/metaphizix/MetaphizixEA"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Spread Manipulation Detection Class                           |
//+------------------------------------------------------------------+
class CSpreadManipulationDetector
{
private:
    //--- Spread history structure
    struct SpreadData
    {
        datetime time;
        double spread;
        double volume;
        double volatility;
        bool isManipulated;
        double normalizedSpread;
        ENUM_TIMEFRAMES timeframe;
    };
    
    //--- Statistical data for analysis
    struct SpreadStatistics
    {
        double avgSpread;
        double minSpread;
        double maxSpread;
        double stdDeviation;
        double threshold95;
        double threshold99;
        double medianSpread;
        double q1Spread;
        double q3Spread;
        double iqrSpread;
        int sampleSize;
        datetime lastUpdate;
    };
    
    //--- Market session information
    struct SessionData
    {
        string sessionName;
        int startHour;
        int endHour;
        double avgSpread;
        double normalSpread;
        bool isActive;
        double spreadMultiplier;
    };
    
    //--- Manipulation patterns
    struct ManipulationPattern
    {
        string patternName;
        double spreadThreshold;
        int duration;
        double volumeThreshold;
        bool isDetected;
        datetime detectedTime;
        double confidence;
        string description;
    };
    
    //--- Private variables
    SpreadData m_spreadHistory[1000];
    SpreadStatistics m_stats;
    SessionData m_sessions[4]; // Asian, London, US, Sydney
    ManipulationPattern m_patterns[10];
    
    int m_historyIndex;
    int m_maxHistory;
    string m_symbol;
    ENUM_TIMEFRAMES m_timeframe;
    
    //--- Detection parameters
    double m_spreadMultiplierThreshold;
    double m_volumeAnomalyThreshold;
    double m_rapidSpreadChangeThreshold;
    int m_minDetectionPeriod;
    int m_maxDetectionPeriod;
    
    //--- News and event filters
    bool m_filterNewsEvents;
    int m_newsFilterMinutes;
    
    //--- Alert settings
    bool m_enableAlerts;
    bool m_enableNotifications;
    string m_alertSound;
    
public:
    //--- Constructor and destructor
    CSpreadManipulationDetector(void);
    ~CSpreadManipulationDetector(void);
    
    //--- Initialization and configuration
    bool Init(string symbol, ENUM_TIMEFRAMES timeframe);
    void SetParameters(double spreadMultiplierThreshold = 3.0,
                      double volumeAnomalyThreshold = 2.5,
                      double rapidSpreadChangeThreshold = 150.0,
                      int minDetectionPeriod = 5,
                      int maxDetectionPeriod = 60);
    
    void SetNewsFilter(bool enable, int filterMinutes = 30);
    void SetAlerts(bool enableAlerts, bool enableNotifications, string alertSound = "alert.wav");
    
    //--- Main detection methods
    bool DetectSpreadManipulation(void);
    bool AnalyzeCurrentSpread(void);
    bool CheckSpreadAnomalies(void);
    bool DetectSpreadSpikes(void);
    bool AnalyzeSpreadPatterns(void);
    
    //--- Statistical analysis
    void UpdateSpreadStatistics(void);
    double CalculateZScore(double currentSpread);
    double CalculatePercentile(double currentSpread);
    bool IsStatisticalOutlier(double currentSpread, double threshold = 2.5);
    
    //--- Pattern recognition
    bool DetectWideningSpreads(void);
    bool DetectSuddenSpreadChanges(void);
    bool DetectSpreadCluster(void);
    bool DetectNewsRelatedSpreads(void);
    bool DetectSessionAnomalies(void);
    bool DetectVolumeSpreadDivergence(void);
    
    //--- Session analysis
    void InitializeSessions(void);
    void UpdateSessionData(void);
    SessionData GetCurrentSession(void);
    bool IsSpreadNormalForSession(double spread);
    
    //--- Utility methods
    double GetCurrentSpread(void);
    double GetNormalizedSpread(double spread);
    double GetSpreadVolatility(int periods = 20);
    double GetAverageSpread(int periods = 100);
    
    //--- Data access methods
    SpreadStatistics GetStatistics(void) { return m_stats; }
    ManipulationPattern GetPattern(int index);
    bool IsManipulationDetected(void);
    double GetManipulationConfidence(void);
    string GetManipulationDescription(void);
    
    //--- Display and reporting
    void PrintDetectionReport(void);
    void UpdateDisplay(void);
    string GetStatusString(void);
    
    //--- Historical analysis
    void SaveSpreadHistory(void);
    void LoadSpreadHistory(void);
    void AnalyzeHistoricalManipulation(datetime fromDate, datetime toDate);
    
private:
    //--- Internal calculation methods
    void AddSpreadData(double spread, double volume, double volatility);
    void CalculateSpreadStatistics(void);
    void UpdatePatternDetection(void);
    void ProcessAlerts(string message, int severity);
    
    //--- Helper methods
    bool IsNewsTime(void);
    bool IsMarketOpen(void);
    double CalculateMovingAverage(int periods);
    double CalculateStandardDeviation(int periods);
    void RemoveOldData(void);
    
    //--- Mathematical functions
    double Percentile(double data[], int size, double percentile);
    double Median(double data[], int size);
    double InterquartileRange(double data[], int size);
    void SortArray(double &array[], int size);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSpreadManipulationDetector::CSpreadManipulationDetector(void)
{
    m_historyIndex = 0;
    m_maxHistory = 1000;
    m_symbol = "";
    m_timeframe = PERIOD_CURRENT;
    
    // Set default parameters
    m_spreadMultiplierThreshold = 3.0;
    m_volumeAnomalyThreshold = 2.5;
    m_rapidSpreadChangeThreshold = 150.0;
    m_minDetectionPeriod = 5;
    m_maxDetectionPeriod = 60;
    
    // Initialize news filter
    m_filterNewsEvents = true;
    m_newsFilterMinutes = 30;
    
    // Initialize alerts
    m_enableAlerts = true;
    m_enableNotifications = false;
    m_alertSound = "alert.wav";
    
    // Initialize arrays
    ArrayInitialize(m_spreadHistory, 0);
    ZeroMemory(m_stats);
    ZeroMemory(m_sessions);
    ZeroMemory(m_patterns);
    
    InitializeSessions();
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSpreadManipulationDetector::~CSpreadManipulationDetector(void)
{
    SaveSpreadHistory();
}

//+------------------------------------------------------------------+
//| Initialize the detector                                          |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::Init(string symbol, ENUM_TIMEFRAMES timeframe)
{
    m_symbol = symbol;
    m_timeframe = timeframe;
    
    // Initialize manipulation patterns
    m_patterns[0].patternName = "Sudden Spread Spike";
    m_patterns[0].spreadThreshold = 300.0; // 300% of normal
    m_patterns[0].duration = 5;
    m_patterns[0].volumeThreshold = 50.0;
    m_patterns[0].description = "Rapid increase in spread with low volume";
    
    m_patterns[1].patternName = "Prolonged Wide Spread";
    m_patterns[1].spreadThreshold = 200.0; // 200% of normal
    m_patterns[1].duration = 30;
    m_patterns[1].volumeThreshold = 80.0;
    m_patterns[1].description = "Extended period of abnormally wide spreads";
    
    m_patterns[2].patternName = "Pre-News Widening";
    m_patterns[2].spreadThreshold = 150.0; // 150% of normal
    m_patterns[2].duration = 15;
    m_patterns[2].volumeThreshold = 60.0;
    m_patterns[2].description = "Spread widening before major news events";
    
    m_patterns[3].patternName = "Session Transition Spike";
    m_patterns[3].spreadThreshold = 250.0; // 250% of normal
    m_patterns[3].duration = 10;
    m_patterns[3].volumeThreshold = 40.0;
    m_patterns[3].description = "Abnormal spreads during session transitions";
    
    m_patterns[4].patternName = "Volume-Spread Divergence";
    m_patterns[4].spreadThreshold = 180.0; // 180% of normal
    m_patterns[4].duration = 20;
    m_patterns[4].volumeThreshold = 30.0;
    m_patterns[4].description = "High spreads with unusually low volume";
    
    // Load historical data if available
    LoadSpreadHistory();
    
    Print("✅ Spread Manipulation Detector initialized for ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Set detection parameters                                         |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::SetParameters(double spreadMultiplierThreshold = 3.0,
                                               double volumeAnomalyThreshold = 2.5,
                                               double rapidSpreadChangeThreshold = 150.0,
                                               int minDetectionPeriod = 5,
                                               int maxDetectionPeriod = 60)
{
    m_spreadMultiplierThreshold = spreadMultiplierThreshold;
    m_volumeAnomalyThreshold = volumeAnomalyThreshold;
    m_rapidSpreadChangeThreshold = rapidSpreadChangeThreshold;
    m_minDetectionPeriod = minDetectionPeriod;
    m_maxDetectionPeriod = maxDetectionPeriod;
}

//+------------------------------------------------------------------+
//| Main spread manipulation detection                               |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectSpreadManipulation(void)
{
    // Get current market data
    double currentSpread = GetCurrentSpread();
    double volume = iVolume(m_symbol, m_timeframe, 0);
    double volatility = GetSpreadVolatility();
    
    // Add to history
    AddSpreadData(currentSpread, volume, volatility);
    
    // Update statistics
    UpdateSpreadStatistics();
    
    // Perform detection checks
    bool manipulationDetected = false;
    
    // 1. Check for statistical anomalies
    if (CheckSpreadAnomalies())
    {
        manipulationDetected = true;
    }
    
    // 2. Check for spread spikes
    if (DetectSpreadSpikes())
    {
        manipulationDetected = true;
    }
    
    // 3. Analyze patterns
    if (AnalyzeSpreadPatterns())
    {
        manipulationDetected = true;
    }
    
    // 4. Check session-specific anomalies
    if (DetectSessionAnomalies())
    {
        manipulationDetected = true;
    }
    
    // 5. Check volume-spread divergence
    if (DetectVolumeSpreadDivergence())
    {
        manipulationDetected = true;
    }
    
    if (manipulationDetected)
    {
        string alertMessage = StringFormat("🚨 SPREAD MANIPULATION DETECTED on %s! Current spread: %.1f points (%.1f%% above normal)",
                                         m_symbol, currentSpread, (currentSpread / m_stats.avgSpread - 1) * 100);
        ProcessAlerts(alertMessage, 2);
        PrintDetectionReport();
    }
    
    return manipulationDetected;
}

//+------------------------------------------------------------------+
//| Check for spread anomalies                                      |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::CheckSpreadAnomalies(void)
{
    double currentSpread = GetCurrentSpread();
    
    // Check if spread is statistical outlier
    if (IsStatisticalOutlier(currentSpread, 3.0)) // 3 sigma rule
    {
        m_patterns[0].isDetected = true;
        m_patterns[0].detectedTime = TimeCurrent();
        m_patterns[0].confidence = MathAbs(CalculateZScore(currentSpread)) * 20.0; // Convert to percentage
        return true;
    }
    
    // Check if spread exceeds threshold multiplier
    if (currentSpread > m_stats.avgSpread * m_spreadMultiplierThreshold)
    {
        m_patterns[1].isDetected = true;
        m_patterns[1].detectedTime = TimeCurrent();
        m_patterns[1].confidence = (currentSpread / m_stats.avgSpread) * 25.0;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect spread spikes                                            |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectSpreadSpikes(void)
{
    if (m_historyIndex < 5) return false;
    
    double currentSpread = GetCurrentSpread();
    double prevSpread = m_spreadHistory[m_historyIndex - 1].spread;
    
    // Check for rapid spread increase
    double spreadChange = (currentSpread - prevSpread) / prevSpread * 100.0;
    
    if (spreadChange > m_rapidSpreadChangeThreshold)
    {
        m_patterns[0].isDetected = true;
        m_patterns[0].detectedTime = TimeCurrent();
        m_patterns[0].confidence = MathMin(spreadChange, 100.0);
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Analyze spread patterns                                         |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::AnalyzeSpreadPatterns(void)
{
    bool patternDetected = false;
    
    // Check for widening spreads
    if (DetectWideningSpreads())
    {
        patternDetected = true;
    }
    
    // Check for sudden changes
    if (DetectSuddenSpreadChanges())
    {
        patternDetected = true;
    }
    
    // Check for clustering
    if (DetectSpreadCluster())
    {
        patternDetected = true;
    }
    
    // Check news-related patterns
    if (DetectNewsRelatedSpreads())
    {
        patternDetected = true;
    }
    
    return patternDetected;
}

//+------------------------------------------------------------------+
//| Detect widening spreads pattern                                 |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectWideningSpreads(void)
{
    if (m_historyIndex < 10) return false;
    
    int wideningCount = 0;
    double threshold = m_stats.avgSpread * 1.5;
    
    // Check last 10 periods for consecutive widening
    for (int i = m_historyIndex - 10; i < m_historyIndex; i++)
    {
        if (m_spreadHistory[i].spread > threshold)
        {
            wideningCount++;
        }
    }
    
    if (wideningCount >= 7) // 70% of periods show wide spreads
    {
        m_patterns[1].isDetected = true;
        m_patterns[1].detectedTime = TimeCurrent();
        m_patterns[1].confidence = (double)wideningCount / 10.0 * 100.0;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect sudden spread changes                                    |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectSuddenSpreadChanges(void)
{
    if (m_historyIndex < 5) return false;
    
    double currentSpread = GetCurrentSpread();
    double avgSpread = GetAverageSpread(5);
    
    // Check for sudden jump
    if (currentSpread > avgSpread * 2.0)
    {
        m_patterns[0].isDetected = true;
        m_patterns[0].detectedTime = TimeCurrent();
        m_patterns[0].confidence = (currentSpread / avgSpread) * 30.0;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect spread clustering                                        |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectSpreadCluster(void)
{
    if (m_historyIndex < 20) return false;
    
    double highThreshold = m_stats.avgSpread * 2.0;
    int clusterCount = 0;
    
    // Check for clusters of high spreads
    for (int i = m_historyIndex - 20; i < m_historyIndex; i++)
    {
        if (m_spreadHistory[i].spread > highThreshold)
        {
            clusterCount++;
        }
    }
    
    if (clusterCount >= 10) // 50% of recent periods show high spreads
    {
        m_patterns[2].isDetected = true;
        m_patterns[2].detectedTime = TimeCurrent();
        m_patterns[2].confidence = (double)clusterCount / 20.0 * 100.0;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect news-related spread patterns                             |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectNewsRelatedSpreads(void)
{
    if (!m_filterNewsEvents) return false;
    
    // Check if we're within news filter time
    if (IsNewsTime())
    {
        double currentSpread = GetCurrentSpread();
        if (currentSpread > m_stats.avgSpread * 1.8)
        {
            m_patterns[2].isDetected = true;
            m_patterns[2].detectedTime = TimeCurrent();
            m_patterns[2].confidence = 75.0; // High confidence for news-related
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect session anomalies                                        |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectSessionAnomalies(void)
{
    SessionData currentSession = GetCurrentSession();
    double currentSpread = GetCurrentSpread();
    
    if (currentSession.isActive && currentSession.normalSpread > 0)
    {
        if (currentSpread > currentSession.normalSpread * 2.5)
        {
            m_patterns[3].isDetected = true;
            m_patterns[3].detectedTime = TimeCurrent();
            m_patterns[3].confidence = (currentSpread / currentSession.normalSpread) * 25.0;
            return true;
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Detect volume-spread divergence                                 |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::DetectVolumeSpreadDivergence(void)
{
    if (m_historyIndex < 5) return false;
    
    double currentSpread = GetCurrentSpread();
    double currentVolume = iVolume(m_symbol, m_timeframe, 0);
    double avgVolume = 0;
    
    // Calculate average volume
    for (int i = m_historyIndex - 5; i < m_historyIndex; i++)
    {
        avgVolume += m_spreadHistory[i].volume;
    }
    avgVolume /= 5;
    
    // Check for high spread with low volume (suspicious)
    if (currentSpread > m_stats.avgSpread * 2.0 && currentVolume < avgVolume * 0.5)
    {
        m_patterns[4].isDetected = true;
        m_patterns[4].detectedTime = TimeCurrent();
        m_patterns[4].confidence = 80.0;
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Get current spread                                              |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::GetCurrentSpread(void)
{
    double ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
    double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
    
    return (ask - bid) / point;
}

//+------------------------------------------------------------------+
//| Calculate Z-score for current spread                            |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::CalculateZScore(double currentSpread)
{
    if (m_stats.stdDeviation == 0) return 0;
    return (currentSpread - m_stats.avgSpread) / m_stats.stdDeviation;
}

//+------------------------------------------------------------------+
//| Check if spread is statistical outlier                          |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::IsStatisticalOutlier(double currentSpread, double threshold = 2.5)
{
    double zScore = MathAbs(CalculateZScore(currentSpread));
    return zScore > threshold;
}

//+------------------------------------------------------------------+
//| Update spread statistics                                         |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::UpdateSpreadStatistics(void)
{
    if (m_historyIndex < 10) return;
    
    CalculateSpreadStatistics();
    m_stats.lastUpdate = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Calculate spread statistics                                      |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::CalculateSpreadStatistics(void)
{
    if (m_historyIndex == 0) return;
    
    double sum = 0, sumSq = 0;
    double min = DBL_MAX, max = 0;
    
    int count = MathMin(m_historyIndex, 100); // Use last 100 data points
    
    for (int i = m_historyIndex - count; i < m_historyIndex; i++)
    {
        double spread = m_spreadHistory[i].spread;
        sum += spread;
        sumSq += spread * spread;
        min = MathMin(min, spread);
        max = MathMax(max, spread);
    }
    
    m_stats.avgSpread = sum / count;
    m_stats.minSpread = min;
    m_stats.maxSpread = max;
    m_stats.sampleSize = count;
    
    // Calculate standard deviation
    double variance = (sumSq / count) - (m_stats.avgSpread * m_stats.avgSpread);
    m_stats.stdDeviation = MathSqrt(variance);
    
    // Calculate thresholds
    m_stats.threshold95 = m_stats.avgSpread + (1.96 * m_stats.stdDeviation);
    m_stats.threshold99 = m_stats.avgSpread + (2.58 * m_stats.stdDeviation);
}

//+------------------------------------------------------------------+
//| Add spread data to history                                      |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::AddSpreadData(double spread, double volume, double volatility)
{
    if (m_historyIndex >= m_maxHistory)
    {
        // Shift array left
        for (int i = 0; i < m_maxHistory - 1; i++)
        {
            m_spreadHistory[i] = m_spreadHistory[i + 1];
        }
        m_historyIndex = m_maxHistory - 1;
    }
    
    m_spreadHistory[m_historyIndex].time = TimeCurrent();
    m_spreadHistory[m_historyIndex].spread = spread;
    m_spreadHistory[m_historyIndex].volume = volume;
    m_spreadHistory[m_historyIndex].volatility = volatility;
    m_spreadHistory[m_historyIndex].normalizedSpread = GetNormalizedSpread(spread);
    m_spreadHistory[m_historyIndex].timeframe = m_timeframe;
    
    m_historyIndex++;
}

//+------------------------------------------------------------------+
//| Initialize trading sessions                                      |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::InitializeSessions(void)
{
    // Asian Session
    m_sessions[0].sessionName = "Asian";
    m_sessions[0].startHour = 22; // 22:00 GMT
    m_sessions[0].endHour = 8;    // 08:00 GMT
    m_sessions[0].spreadMultiplier = 1.2;
    
    // London Session
    m_sessions[1].sessionName = "London";
    m_sessions[1].startHour = 8;   // 08:00 GMT
    m_sessions[1].endHour = 16;    // 16:00 GMT
    m_sessions[1].spreadMultiplier = 0.8;
    
    // US Session
    m_sessions[2].sessionName = "US";
    m_sessions[2].startHour = 13;  // 13:00 GMT
    m_sessions[2].endHour = 22;    // 22:00 GMT
    m_sessions[2].spreadMultiplier = 0.9;
    
    // Sydney Session
    m_sessions[3].sessionName = "Sydney";
    m_sessions[3].startHour = 22;  // 22:00 GMT
    m_sessions[3].endHour = 7;     // 07:00 GMT
    m_sessions[3].spreadMultiplier = 1.3;
}

//+------------------------------------------------------------------+
//| Get current trading session                                     |
//+------------------------------------------------------------------+
SessionData CSpreadManipulationDetector::GetCurrentSession(void)
{
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int currentHour = dt.hour;
    
    // Check each session
    for (int i = 0; i < 4; i++)
    {
        if (m_sessions[i].startHour < m_sessions[i].endHour)
        {
            // Normal session (doesn't cross midnight)
            if (currentHour >= m_sessions[i].startHour && currentHour < m_sessions[i].endHour)
            {
                m_sessions[i].isActive = true;
                return m_sessions[i];
            }
        }
        else
        {
            // Session crosses midnight
            if (currentHour >= m_sessions[i].startHour || currentHour < m_sessions[i].endHour)
            {
                m_sessions[i].isActive = true;
                return m_sessions[i];
            }
        }
    }
    
    // Default session if none found
    SessionData defaultSession;
    defaultSession.sessionName = "Unknown";
    defaultSession.isActive = false;
    return defaultSession;
}

//+------------------------------------------------------------------+
//| Check if manipulation is currently detected                     |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::IsManipulationDetected(void)
{
    for (int i = 0; i < 5; i++)
    {
        if (m_patterns[i].isDetected && 
            TimeCurrent() - m_patterns[i].detectedTime < 300) // Within last 5 minutes
        {
            return true;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Get manipulation confidence level                               |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::GetManipulationConfidence(void)
{
    double maxConfidence = 0;
    for (int i = 0; i < 5; i++)
    {
        if (m_patterns[i].isDetected && 
            TimeCurrent() - m_patterns[i].detectedTime < 300)
        {
            maxConfidence = MathMax(maxConfidence, m_patterns[i].confidence);
        }
    }
    return MathMin(maxConfidence, 100.0);
}

//+------------------------------------------------------------------+
//| Get manipulation description                                     |
//+------------------------------------------------------------------+
string CSpreadManipulationDetector::GetManipulationDescription(void)
{
    string description = "";
    for (int i = 0; i < 5; i++)
    {
        if (m_patterns[i].isDetected && 
            TimeCurrent() - m_patterns[i].detectedTime < 300)
        {
            if (description != "") description += "; ";
            description += m_patterns[i].description;
        }
    }
    return description;
}

//+------------------------------------------------------------------+
//| Print detection report                                          |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::PrintDetectionReport(void)
{
    double currentSpread = GetCurrentSpread();
    SessionData session = GetCurrentSession();
    
    Print("=== SPREAD MANIPULATION DETECTION REPORT ===");
    Print("Symbol: ", m_symbol);
    Print("Time: ", TimeToString(TimeCurrent()));
    Print("Current Spread: ", DoubleToString(currentSpread, 1), " points");
    Print("Average Spread: ", DoubleToString(m_stats.avgSpread, 1), " points");
    Print("Spread Multiplier: ", DoubleToString(currentSpread / m_stats.avgSpread, 2), "x");
    Print("Z-Score: ", DoubleToString(CalculateZScore(currentSpread), 2));
    Print("Current Session: ", session.sessionName);
    Print("Confidence Level: ", DoubleToString(GetManipulationConfidence(), 1), "%");
    Print("Detection: ", GetManipulationDescription());
    Print("===========================================");
}

//+------------------------------------------------------------------+
//| Get normalized spread                                           |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::GetNormalizedSpread(double spread)
{
    if (m_stats.avgSpread == 0) return spread;
    return spread / m_stats.avgSpread;
}

//+------------------------------------------------------------------+
//| Get spread volatility                                           |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::GetSpreadVolatility(int periods = 20)
{
    if (m_historyIndex < periods) return 0;
    
    double sum = 0, sumSq = 0;
    int count = MathMin(periods, m_historyIndex);
    
    for (int i = m_historyIndex - count; i < m_historyIndex; i++)
    {
        sum += m_spreadHistory[i].spread;
        sumSq += m_spreadHistory[i].spread * m_spreadHistory[i].spread;
    }
    
    double mean = sum / count;
    double variance = (sumSq / count) - (mean * mean);
    return MathSqrt(variance);
}

//+------------------------------------------------------------------+
//| Get average spread                                              |
//+------------------------------------------------------------------+
double CSpreadManipulationDetector::GetAverageSpread(int periods = 100)
{
    if (m_historyIndex == 0) return 0;
    
    double sum = 0;
    int count = MathMin(periods, m_historyIndex);
    
    for (int i = m_historyIndex - count; i < m_historyIndex; i++)
    {
        sum += m_spreadHistory[i].spread;
    }
    
    return sum / count;
}

//+------------------------------------------------------------------+
//| Process alerts                                                  |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::ProcessAlerts(string message, int severity)
{
    if (m_enableAlerts)
    {
        Print(message);
        
        if (m_enableNotifications)
        {
            SendNotification(message);
        }
        
        if (m_alertSound != "")
        {
            PlaySound(m_alertSound);
        }
    }
}

//+------------------------------------------------------------------+
//| Check if it's news time                                         |
//+------------------------------------------------------------------+
bool CSpreadManipulationDetector::IsNewsTime(void)
{
    // This is a simplified implementation
    // In a real system, you would check against a news calendar
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    
    // Common news times (GMT)
    if ((dt.hour == 8 && dt.min <= 30) ||  // London open
        (dt.hour == 13 && dt.min <= 30) || // US open
        (dt.hour == 14 && dt.min <= 30) || // US data releases
        (dt.hour == 18 && dt.min <= 30))   // US close
    {
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Save spread history                                             |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::SaveSpreadHistory(void)
{
    // Implementation would save to file
    // This is a placeholder for the file I/O functionality
}

//+------------------------------------------------------------------+
//| Load spread history                                             |
//+------------------------------------------------------------------+
void CSpreadManipulationDetector::LoadSpreadHistory(void)
{
    // Implementation would load from file
    // This is a placeholder for the file I/O functionality
}

//+------------------------------------------------------------------+
//| Get status string                                               |
//+------------------------------------------------------------------+
string CSpreadManipulationDetector::GetStatusString(void)
{
    double currentSpread = GetCurrentSpread();
    bool manipulation = IsManipulationDetected();
    
    string status = StringFormat("Spread: %.1f pts", currentSpread);
    
    if (manipulation)
    {
        status += " ⚠️ MANIPULATION DETECTED";
    }
    else
    {
        status += " ✅ Normal";
    }
    
    return status;
}