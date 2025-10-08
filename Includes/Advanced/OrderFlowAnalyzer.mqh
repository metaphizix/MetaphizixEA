//+------------------------------------------------------------------+
//|                                            OrderFlowAnalyzer.mqh |
//|                                   Advanced Order Flow Analysis  |
//|                               Copyright 2025, MetaphizixEA Team |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, MetaphizixEA Team"
#property link      "https://www.metaphizix.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Order Flow Analysis Class                                      |
//+------------------------------------------------------------------+
class COrderFlowAnalyzer
{
private:
    //--- Order flow data
    struct OrderFlowData
    {
        double bidVolume;
        double askVolume;
        double totalVolume;
        double volumeImbalance;
        double buyPressure;
        double sellPressure;
        double netFlow;
        datetime timestamp;
    };
    
    OrderFlowData m_orderFlow[1000];
    int m_flowCount;
    
    //--- Volume profile
    struct VolumeNode
    {
        double priceLevel;
        double volume;
        double buyVolume;
        double sellVolume;
        int trades;
        bool isPOC; // Point of Control
        bool isHVN; // High Volume Node
        bool isLVN; // Low Volume Node
    };
    
    VolumeNode m_volumeProfile[200];
    int m_profileCount;
    
    //--- Footprint data
    struct FootprintBar
    {
        datetime time;
        double open, high, low, close;
        double totalVolume;
        double bidVolume;
        double askVolume;
        double delta;
        double cumulativeDelta;
        int numberOfTrades;
        double avgTradeSize;
        bool isAbsorption;
        bool isBreakout;
    };
    
    FootprintBar m_footprint[500];
    int m_footprintCount;
    
    //--- Liquidity levels
    struct LiquidityLevel
    {
        double price;
        double volume;
        string type; // "RESISTANCE", "SUPPORT", "STOP_CLUSTER"
        double strength;
        bool isActive;
        datetime lastTouch;
        int touchCount;
    };
    
    LiquidityLevel m_liquidityLevels[100];
    int m_liquidityCount;
    
    //--- Market microstructure
    struct MarketMicrostructure
    {
        double bidAskSpread;
        double marketDepth;
        double orderBookImbalance;
        double tickDirection;
        double aggressiveness;
        double institutionalFlow;
        bool isAccumulation;
        bool isDistribution;
    };
    
    MarketMicrostructure m_microstructure;
    
    //--- Volume indicators
    double m_vwap;
    double m_volumeWeightedPrice;
    double m_volumeTrend;
    double m_volumeOscillator;

public:
    //--- Constructor
    COrderFlowAnalyzer();
    
    //--- Initialization
    bool Initialize(string symbol);
    void UpdateOrderFlow(string symbol);
    
    //--- Volume profile analysis
    void BuildVolumeProfile(string symbol, int period = 100);
    double GetPointOfControl();
    double GetVolumeAtPrice(double price);
    bool IsHighVolumeNode(double price);
    bool IsLowVolumeNode(double price);
    double GetValueAreaHigh();
    double GetValueAreaLow();
    
    //--- Order flow analysis
    void AnalyzeOrderFlow(string symbol);
    double CalculateVolumeImbalance();
    double GetBuyPressure();
    double GetSellPressure();
    double GetNetOrderFlow();
    bool IsOrderFlowBullish();
    bool IsOrderFlowBearish();
    
    //--- Footprint analysis
    void UpdateFootprint(string symbol);
    double CalculateDelta(int barIndex);
    double GetCumulativeDelta();
    bool DetectAbsorption(int barIndex);
    bool DetectVolumeBreakout(int barIndex);
    double GetAverageTradeSize(int barIndex);
    
    //--- Liquidity analysis
    void DetectLiquidityLevels(string symbol);
    double GetLiquidityAtLevel(double price);
    bool IsLiquidityCluster(double price);
    bool IsStopHuntingLevel(double price);
    void UpdateLiquidityLevels(string symbol);
    
    //--- Market microstructure
    void AnalyzeMarketMicrostructure(string symbol);
    double GetBidAskSpread(string symbol);
    double CalculateOrderBookImbalance(string symbol);
    double GetMarketDepth(string symbol);
    bool IsInstitutionalActivity();
    
    //--- Volume-based indicators
    void CalculateVWAP(string symbol);
    void UpdateVolumeIndicators(string symbol);
    double GetVolumeWeightedAverage();
    double GetVolumeTrend();
    bool IsVolumeIncreasing();
    bool IsVolumeDecreasing();
    
    //--- Smart money detection
    bool DetectSmartMoneyActivity(string symbol);
    bool IsAccumulationPhase();
    bool IsDistributionPhase();
    bool DetectInstitutionalStealth();
    double GetSmartMoneyIndex();
    
    //--- Auction theory
    void AnalyzeMarketAuction(string symbol);
    bool IsAuctionRotational();
    bool IsAuctionTrending();
    string GetAuctionType();
    bool IsBalancedMarket();
    bool IsImbalancedMarket();
    
    //--- Volume patterns
    bool DetectVolumeSpike(double threshold = 2.0);
    bool DetectVolumeClimaxes();
    bool IsVolumeConfirmation(ENUM_ORDER_TYPE direction);
    bool DetectVolumeDivergence();
    
    //--- Order flow signals
    ENUM_ORDER_TYPE GetOrderFlowSignal(string symbol);
    double GetOrderFlowConfidence();
    bool ValidateWithOrderFlow(ENUM_ORDER_TYPE signal);
    double GetOrderFlowRisk(string symbol);
    
    //--- Advanced patterns
    bool DetectIcebergOrders(string symbol);
    bool DetectSpoofing(string symbol);
    bool DetectLayering(string symbol);
    bool DetectWashTrading(string symbol);
    
    //--- Time and sales analysis
    void AnalyzeTimeAndSales(string symbol);
    double GetTradeAggression();
    double GetMarketImpactCost();
    bool IsPassiveFilling();
    bool IsAggressiveFilling();
    
    //--- Session analysis
    void AnalyzeSessionOrderFlow(string symbol);
    double GetSessionVWAP();
    bool IsAboveSessionVWAP(double price);
    bool IsBelowSessionVWAP(double price);
    
    //--- Momentum based on order flow
    bool IsOrderFlowMomentumBullish();
    bool IsOrderFlowMomentumBearish();
    double GetOrderFlowMomentum();
    bool IsOrderFlowDivergence(string symbol);
    
    //--- Risk management
    double AdjustRiskBasedOnFlow();
    bool ShouldReducePositionSize();
    bool ShouldIncreasePositionSize();
    double GetFlowBasedStopLoss(ENUM_ORDER_TYPE direction, double entry);
    
    //--- Information functions
    OrderFlowData GetCurrentOrderFlow();
    VolumeNode GetVolumeProfileNode(int index);
    FootprintBar GetFootprintBar(int index);
    MarketMicrostructure GetMicrostructure() { return m_microstructure; }
    
    //--- Utility functions
    double NormalizeVolume(double volume);
    bool IsSignificantVolume(double volume);
    string GetOrderFlowDirection();
    
    //--- Reporting
    void PrintOrderFlowAnalysis(string symbol);
    void PrintVolumeProfile();
    void PrintLiquidityLevels();
    string GetOrderFlowSummary(string symbol);
    
    //--- Optimization
    void OptimizeVolumeParameters();
    void CalibrateOrderFlowSensitivity();
    void BacktestOrderFlowStrategy(string symbol);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
COrderFlowAnalyzer::COrderFlowAnalyzer()
{
    //--- Initialize counters
    m_flowCount = 0;
    m_profileCount = 0;
    m_footprintCount = 0;
    m_liquidityCount = 0;
    
    //--- Initialize VWAP and indicators
    m_vwap = 0.0;
    m_volumeWeightedPrice = 0.0;
    m_volumeTrend = 0.0;
    m_volumeOscillator = 0.0;
    
    //--- Initialize microstructure
    m_microstructure.bidAskSpread = 0.0;
    m_microstructure.marketDepth = 0.0;
    m_microstructure.orderBookImbalance = 0.0;
    m_microstructure.aggressiveness = 0.0;
    m_microstructure.isAccumulation = false;
    m_microstructure.isDistribution = false;
    
    Print("📊 Order Flow Analyzer initialized");
}

//+------------------------------------------------------------------+
//| Initialize order flow analyzer                                |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::Initialize(string symbol)
{
    //--- Build initial volume profile
    BuildVolumeProfile(symbol, 100);
    
    //--- Analyze current order flow
    AnalyzeOrderFlow(symbol);
    
    //--- Update footprint
    UpdateFootprint(symbol);
    
    //--- Detect liquidity levels
    DetectLiquidityLevels(symbol);
    
    //--- Analyze microstructure
    AnalyzeMarketMicrostructure(symbol);
    
    //--- Calculate VWAP
    CalculateVWAP(symbol);
    
    Print("✅ Order Flow Analyzer initialized for ", symbol);
    return true;
}

//+------------------------------------------------------------------+
//| Build volume profile                                          |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::BuildVolumeProfile(string symbol, int period = 100)
{
    //--- Get price range
    int highestBar = iHighest(symbol, PERIOD_CURRENT, MODE_HIGH, period, 0);
    int lowestBar = iLowest(symbol, PERIOD_CURRENT, MODE_LOW, period, 0);
    
    double highest = iHigh(symbol, PERIOD_CURRENT, highestBar);
    double lowest = iLow(symbol, PERIOD_CURRENT, lowestBar);
    
    double priceRange = highest - lowest;
    double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
    int levels = (int)(priceRange / tickSize / 10); // Reduce granularity
    
    if(levels > 200) levels = 200; // Limit array size
    
    m_profileCount = levels;
    
    //--- Initialize profile
    for(int i = 0; i < levels; i++)
    {
        m_volumeProfile[i].priceLevel = lowest + (i * priceRange / levels);
        m_volumeProfile[i].volume = 0.0;
        m_volumeProfile[i].buyVolume = 0.0;
        m_volumeProfile[i].sellVolume = 0.0;
        m_volumeProfile[i].trades = 0;
        m_volumeProfile[i].isPOC = false;
        m_volumeProfile[i].isHVN = false;
        m_volumeProfile[i].isLVN = false;
    }
    
    //--- Build profile from historical bars
    for(int bar = 0; bar < period; bar++)
    {
        double high = iHigh(symbol, PERIOD_CURRENT, bar);
        double low = iLow(symbol, PERIOD_CURRENT, bar);
        double close = iClose(symbol, PERIOD_CURRENT, bar);
        double open = iOpen(symbol, PERIOD_CURRENT, bar);
        long volume = iVolume(symbol, PERIOD_CURRENT, bar);
        
        //--- Estimate volume distribution within the bar
        double barRange = high - low;
        if(barRange > 0)
        {
            for(int i = 0; i < levels; i++)
            {
                double levelPrice = m_volumeProfile[i].priceLevel;
                
                if(levelPrice >= low && levelPrice <= high)
                {
                    //--- Distribute volume based on where price spent time
                    double weight = 1.0;
                    if(levelPrice == close || MathAbs(levelPrice - close) < tickSize)
                        weight = 2.0; // More weight near close
                    
                    double volumeAtLevel = (volume * weight) / (barRange / tickSize);
                    m_volumeProfile[i].volume += volumeAtLevel;
                    
                    //--- Estimate buy/sell split based on bar direction
                    if(close > open) // Bullish bar
                    {
                        m_volumeProfile[i].buyVolume += volumeAtLevel * 0.6;
                        m_volumeProfile[i].sellVolume += volumeAtLevel * 0.4;
                    }
                    else // Bearish bar
                    {
                        m_volumeProfile[i].buyVolume += volumeAtLevel * 0.4;
                        m_volumeProfile[i].sellVolume += volumeAtLevel * 0.6;
                    }
                    
                    m_volumeProfile[i].trades++;
                }
            }
        }
    }
    
    //--- Find Point of Control (highest volume)
    double maxVolume = 0;
    int pocIndex = 0;
    
    for(int i = 0; i < levels; i++)
    {
        if(m_volumeProfile[i].volume > maxVolume)
        {
            maxVolume = m_volumeProfile[i].volume;
            pocIndex = i;
        }
    }
    
    m_volumeProfile[pocIndex].isPOC = true;
    
    //--- Identify High and Low Volume Nodes
    double avgVolume = 0;
    for(int i = 0; i < levels; i++)
        avgVolume += m_volumeProfile[i].volume;
    avgVolume /= levels;
    
    for(int i = 0; i < levels; i++)
    {
        if(m_volumeProfile[i].volume > avgVolume * 1.5)
            m_volumeProfile[i].isHVN = true;
        else if(m_volumeProfile[i].volume < avgVolume * 0.5)
            m_volumeProfile[i].isLVN = true;
    }
    
    Print("📊 Volume profile built: ", levels, " levels, POC at ", DoubleToString(m_volumeProfile[pocIndex].priceLevel, 5));
}

//+------------------------------------------------------------------+
//| Analyze order flow                                            |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::AnalyzeOrderFlow(string symbol)
{
    //--- Simulate order flow analysis (in real implementation, this would use tick data)
    double currentVolume = iVolume(symbol, PERIOD_CURRENT, 0);
    double prevVolume = iVolume(symbol, PERIOD_CURRENT, 1);
    
    //--- Estimate bid/ask volume based on price action
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    double prevPrice = iClose(symbol, PERIOD_CURRENT, 1);
    
    if(m_flowCount < 1000)
    {
        //--- Estimate volume split
        if(currentPrice > prevPrice) // Price moving up - more buying
        {
            m_orderFlow[m_flowCount].askVolume = currentVolume * 0.7;
            m_orderFlow[m_flowCount].bidVolume = currentVolume * 0.3;
            m_orderFlow[m_flowCount].buyPressure = 70.0;
            m_orderFlow[m_flowCount].sellPressure = 30.0;
        }
        else if(currentPrice < prevPrice) // Price moving down - more selling
        {
            m_orderFlow[m_flowCount].askVolume = currentVolume * 0.3;
            m_orderFlow[m_flowCount].bidVolume = currentVolume * 0.7;
            m_orderFlow[m_flowCount].buyPressure = 30.0;
            m_orderFlow[m_flowCount].sellPressure = 70.0;
        }
        else // Price unchanged - balanced
        {
            m_orderFlow[m_flowCount].askVolume = currentVolume * 0.5;
            m_orderFlow[m_flowCount].bidVolume = currentVolume * 0.5;
            m_orderFlow[m_flowCount].buyPressure = 50.0;
            m_orderFlow[m_flowCount].sellPressure = 50.0;
        }
        
        m_orderFlow[m_flowCount].totalVolume = currentVolume;
        m_orderFlow[m_flowCount].volumeImbalance = m_orderFlow[m_flowCount].askVolume - m_orderFlow[m_flowCount].bidVolume;
        m_orderFlow[m_flowCount].netFlow = m_orderFlow[m_flowCount].volumeImbalance;
        m_orderFlow[m_flowCount].timestamp = TimeCurrent();
        
        m_flowCount++;
    }
    
    Print("📈 Order flow analyzed: Buy pressure=", DoubleToString(GetBuyPressure(), 1), 
          "%, Sell pressure=", DoubleToString(GetSellPressure(), 1), "%");
}

//+------------------------------------------------------------------+
//| Get Point of Control                                          |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::GetPointOfControl()
{
    for(int i = 0; i < m_profileCount; i++)
    {
        if(m_volumeProfile[i].isPOC)
            return m_volumeProfile[i].priceLevel;
    }
    return 0.0;
}

//+------------------------------------------------------------------+
//| Get volume at specific price                                  |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::GetVolumeAtPrice(double price)
{
    double minDistance = DBL_MAX;
    double volume = 0.0;
    
    for(int i = 0; i < m_profileCount; i++)
    {
        double distance = MathAbs(m_volumeProfile[i].priceLevel - price);
        if(distance < minDistance)
        {
            minDistance = distance;
            volume = m_volumeProfile[i].volume;
        }
    }
    
    return volume;
}

//+------------------------------------------------------------------+
//| Check if high volume node                                     |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::IsHighVolumeNode(double price)
{
    for(int i = 0; i < m_profileCount; i++)
    {
        if(MathAbs(m_volumeProfile[i].priceLevel - price) < SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE) * 5)
        {
            return m_volumeProfile[i].isHVN;
        }
    }
    return false;
}

//+------------------------------------------------------------------+
//| Get buy pressure                                              |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::GetBuyPressure()
{
    if(m_flowCount == 0) return 50.0;
    
    double totalBuyPressure = 0.0;
    for(int i = MathMax(0, m_flowCount - 10); i < m_flowCount; i++)
    {
        totalBuyPressure += m_orderFlow[i].buyPressure;
    }
    
    return totalBuyPressure / MathMin(10, m_flowCount);
}

//+------------------------------------------------------------------+
//| Get sell pressure                                             |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::GetSellPressure()
{
    if(m_flowCount == 0) return 50.0;
    
    double totalSellPressure = 0.0;
    for(int i = MathMax(0, m_flowCount - 10); i < m_flowCount; i++)
    {
        totalSellPressure += m_orderFlow[i].sellPressure;
    }
    
    return totalSellPressure / MathMin(10, m_flowCount);
}

//+------------------------------------------------------------------+
//| Check if order flow is bullish                               |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::IsOrderFlowBullish()
{
    return GetBuyPressure() > 60.0;
}

//+------------------------------------------------------------------+
//| Check if order flow is bearish                               |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::IsOrderFlowBearish()
{
    return GetSellPressure() > 60.0;
}

//+------------------------------------------------------------------+
//| Update footprint data                                         |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::UpdateFootprint(string symbol)
{
    if(m_footprintCount < 500)
    {
        m_footprint[m_footprintCount].time = iTime(symbol, PERIOD_CURRENT, 0);
        m_footprint[m_footprintCount].open = iOpen(symbol, PERIOD_CURRENT, 0);
        m_footprint[m_footprintCount].high = iHigh(symbol, PERIOD_CURRENT, 0);
        m_footprint[m_footprintCount].low = iLow(symbol, PERIOD_CURRENT, 0);
        m_footprint[m_footprintCount].close = iClose(symbol, PERIOD_CURRENT, 0);
        m_footprint[m_footprintCount].totalVolume = iVolume(symbol, PERIOD_CURRENT, 0);
        
        //--- Calculate delta (buy volume - sell volume)
        m_footprint[m_footprintCount].delta = CalculateDelta(m_footprintCount);
        
        //--- Calculate cumulative delta
        if(m_footprintCount > 0)
            m_footprint[m_footprintCount].cumulativeDelta = m_footprint[m_footprintCount-1].cumulativeDelta + m_footprint[m_footprintCount].delta;
        else
            m_footprint[m_footprintCount].cumulativeDelta = m_footprint[m_footprintCount].delta;
        
        //--- Estimate number of trades
        m_footprint[m_footprintCount].numberOfTrades = (int)(m_footprint[m_footprintCount].totalVolume / 100); // Simplified
        
        //--- Calculate average trade size
        if(m_footprint[m_footprintCount].numberOfTrades > 0)
            m_footprint[m_footprintCount].avgTradeSize = m_footprint[m_footprintCount].totalVolume / m_footprint[m_footprintCount].numberOfTrades;
        else
            m_footprint[m_footprintCount].avgTradeSize = 0.0;
        
        //--- Detect absorption and breakouts
        m_footprint[m_footprintCount].isAbsorption = DetectAbsorption(m_footprintCount);
        m_footprint[m_footprintCount].isBreakout = DetectVolumeBreakout(m_footprintCount);
        
        m_footprintCount++;
    }
}

//+------------------------------------------------------------------+
//| Calculate delta for a bar                                     |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::CalculateDelta(int barIndex)
{
    if(barIndex >= m_footprintCount) return 0.0;
    
    //--- Estimate delta based on price action
    double close = m_footprint[barIndex].close;
    double open = m_footprint[barIndex].open;
    double volume = m_footprint[barIndex].totalVolume;
    
    if(close > open) // Bullish bar
    {
        double bullishRatio = (close - open) / (m_footprint[barIndex].high - m_footprint[barIndex].low);
        return volume * (0.5 + bullishRatio * 0.5); // More buying
    }
    else if(close < open) // Bearish bar
    {
        double bearishRatio = (open - close) / (m_footprint[barIndex].high - m_footprint[barIndex].low);
        return volume * (0.5 - bearishRatio * 0.5); // More selling (negative delta)
    }
    
    return 0.0; // Neutral
}

//+------------------------------------------------------------------+
//| Detect absorption pattern                                     |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::DetectAbsorption(int barIndex)
{
    if(barIndex < 5) return false;
    
    //--- Look for high volume with small price movement
    double volume = m_footprint[barIndex].totalVolume;
    double range = m_footprint[barIndex].high - m_footprint[barIndex].low;
    
    //--- Calculate average volume and range
    double avgVolume = 0, avgRange = 0;
    for(int i = barIndex - 5; i < barIndex; i++)
    {
        avgVolume += m_footprint[i].totalVolume;
        avgRange += (m_footprint[i].high - m_footprint[i].low);
    }
    avgVolume /= 5;
    avgRange /= 5;
    
    //--- Absorption: high volume, small range
    return (volume > avgVolume * 1.5 && range < avgRange * 0.7);
}

//+------------------------------------------------------------------+
//| Detect volume breakout                                        |
//+------------------------------------------------------------------+
bool COrderFlowAnalyzer::DetectVolumeBreakout(int barIndex)
{
    if(barIndex < 10) return false;
    
    double volume = m_footprint[barIndex].totalVolume;
    double range = m_footprint[barIndex].high - m_footprint[barIndex].low;
    
    //--- Calculate averages
    double avgVolume = 0, avgRange = 0;
    for(int i = barIndex - 10; i < barIndex; i++)
    {
        avgVolume += m_footprint[i].totalVolume;
        avgRange += (m_footprint[i].high - m_footprint[i].low);
    }
    avgVolume /= 10;
    avgRange /= 10;
    
    //--- Breakout: high volume AND large range
    return (volume > avgVolume * 2.0 && range > avgRange * 1.5);
}

//+------------------------------------------------------------------+
//| Get order flow signal                                         |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE COrderFlowAnalyzer::GetOrderFlowSignal(string symbol)
{
    double buyPressure = GetBuyPressure();
    double sellPressure = GetSellPressure();
    double poc = GetPointOfControl();
    double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
    
    int bullishSignals = 0;
    int bearishSignals = 0;
    
    //--- Order flow pressure signals
    if(buyPressure > 65) bullishSignals += 2;
    if(sellPressure > 65) bearishSignals += 2;
    
    //--- Volume profile signals
    if(currentPrice > poc) bullishSignals++;
    else bearishSignals++;
    
    //--- High volume node signals
    if(IsHighVolumeNode(currentPrice))
    {
        //--- Price at HVN can act as support/resistance
        if(buyPressure > sellPressure) bullishSignals++;
        else bearishSignals++;
    }
    
    //--- Cumulative delta signals
    if(m_footprintCount > 0)
    {
        double cumDelta = m_footprint[m_footprintCount-1].cumulativeDelta;
        if(cumDelta > 0) bullishSignals++;
        else bearishSignals++;
    }
    
    //--- Generate signal
    if(bullishSignals >= bearishSignals + 2)
        return ORDER_TYPE_BUY;
    else if(bearishSignals >= bullishSignals + 2)
        return ORDER_TYPE_SELL;
    
    return -1; // No signal
}

//+------------------------------------------------------------------+
//| Calculate VWAP                                                |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::CalculateVWAP(string symbol)
{
    double totalPV = 0.0; // Price * Volume
    double totalVolume = 0.0;
    
    //--- Calculate for session (last 24 bars for hourly chart)
    int period = 24;
    
    for(int i = 0; i < period; i++)
    {
        double typical = (iHigh(symbol, PERIOD_CURRENT, i) + iLow(symbol, PERIOD_CURRENT, i) + iClose(symbol, PERIOD_CURRENT, i)) / 3;
        double volume = iVolume(symbol, PERIOD_CURRENT, i);
        
        totalPV += (typical * volume);
        totalVolume += volume;
    }
    
    if(totalVolume > 0)
        m_vwap = totalPV / totalVolume;
    else
        m_vwap = SymbolInfoDouble(symbol, SYMBOL_BID);
}

//+------------------------------------------------------------------+
//| Detect liquidity levels                                       |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::DetectLiquidityLevels(string symbol)
{
    m_liquidityCount = 0;
    
    //--- Use volume profile to identify liquidity clusters
    for(int i = 0; i < m_profileCount && m_liquidityCount < 100; i++)
    {
        if(m_volumeProfile[i].isHVN || m_volumeProfile[i].isPOC)
        {
            m_liquidityLevels[m_liquidityCount].price = m_volumeProfile[i].priceLevel;
            m_liquidityLevels[m_liquidityCount].volume = m_volumeProfile[i].volume;
            m_liquidityLevels[m_liquidityCount].strength = m_volumeProfile[i].volume / 1000; // Normalize
            m_liquidityLevels[m_liquidityCount].isActive = true;
            m_liquidityLevels[m_liquidityCount].touchCount = 0;
            
            double currentPrice = SymbolInfoDouble(symbol, SYMBOL_BID);
            if(m_volumeProfile[i].priceLevel > currentPrice)
                m_liquidityLevels[m_liquidityCount].type = "RESISTANCE";
            else
                m_liquidityLevels[m_liquidityCount].type = "SUPPORT";
            
            m_liquidityCount++;
        }
    }
    
    Print("💧 Detected ", m_liquidityCount, " liquidity levels");
}

//+------------------------------------------------------------------+
//| Analyze market microstructure                                |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::AnalyzeMarketMicrostructure(string symbol)
{
    //--- Get bid-ask spread
    m_microstructure.bidAskSpread = GetBidAskSpread(symbol);
    
    //--- Estimate market depth (simplified)
    m_microstructure.marketDepth = iVolume(symbol, PERIOD_CURRENT, 0);
    
    //--- Calculate order book imbalance (simplified)
    double buyPressure = GetBuyPressure();
    double sellPressure = GetSellPressure();
    m_microstructure.orderBookImbalance = (buyPressure - sellPressure) / (buyPressure + sellPressure);
    
    //--- Determine market state
    if(buyPressure > 60 && m_microstructure.orderBookImbalance > 0.2)
        m_microstructure.isAccumulation = true;
    else if(sellPressure > 60 && m_microstructure.orderBookImbalance < -0.2)
        m_microstructure.isDistribution = true;
    
    //--- Calculate aggressiveness
    double avgTradeSize = 0;
    if(m_footprintCount > 0)
        avgTradeSize = m_footprint[m_footprintCount-1].avgTradeSize;
    
    m_microstructure.aggressiveness = avgTradeSize / 1000; // Normalize
}

//+------------------------------------------------------------------+
//| Get bid-ask spread                                            |
//+------------------------------------------------------------------+
double COrderFlowAnalyzer::GetBidAskSpread(string symbol)
{
    double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
    
    return ask - bid;
}

//+------------------------------------------------------------------+
//| Print order flow analysis                                     |
//+------------------------------------------------------------------+
void COrderFlowAnalyzer::PrintOrderFlowAnalysis(string symbol)
{
    Print("═══════════════════════════════════════");
    Print("📊 ORDER FLOW ANALYSIS - ", symbol);
    Print("═══════════════════════════════════════");
    Print("💹 Buy Pressure: ", DoubleToString(GetBuyPressure(), 1), "%");
    Print("📉 Sell Pressure: ", DoubleToString(GetSellPressure(), 1), "%");
    Print("🎯 Point of Control: ", DoubleToString(GetPointOfControl(), 5));
    Print("📊 VWAP: ", DoubleToString(m_vwap, 5));
    Print("💧 Liquidity Levels: ", m_liquidityCount);
    Print("📈 Order Flow Direction: ", GetOrderFlowDirection());
    Print("🔄 Market State: ", m_microstructure.isAccumulation ? "ACCUMULATION" : 
          (m_microstructure.isDistribution ? "DISTRIBUTION" : "NEUTRAL"));
    Print("📏 Bid-Ask Spread: ", DoubleToString(m_microstructure.bidAskSpread, 5));
    
    ENUM_ORDER_TYPE flowSignal = GetOrderFlowSignal(symbol);
    Print("🎯 Flow Signal: ", flowSignal == ORDER_TYPE_BUY ? "BULLISH" : 
          (flowSignal == ORDER_TYPE_SELL ? "BEARISH" : "NEUTRAL"));
    
    if(m_footprintCount > 0)
    {
        Print("📊 Cumulative Delta: ", DoubleToString(m_footprint[m_footprintCount-1].cumulativeDelta, 2));
        Print("⚡ Recent Absorption: ", m_footprint[m_footprintCount-1].isAbsorption ? "YES" : "NO");
        Print("💥 Recent Breakout: ", m_footprint[m_footprintCount-1].isBreakout ? "YES" : "NO");
    }
    
    Print("═══════════════════════════════════════");
}

//+------------------------------------------------------------------+
//| Get order flow direction                                      |
//+------------------------------------------------------------------+
string COrderFlowAnalyzer::GetOrderFlowDirection()
{
    double buyPressure = GetBuyPressure();
    double sellPressure = GetSellPressure();
    
    if(buyPressure > sellPressure + 10)
        return "BULLISH";
    else if(sellPressure > buyPressure + 10)
        return "BEARISH";
    else
        return "NEUTRAL";
}