# MetaphizixEA - Modular Architecture Documentation

## 🏗️ Architecture Overview

MetaphizixEA follows a modular, object-oriented design with clear separation of concerns. The EA is built using best practices for maintainability, scalability, and testability.

## 📦 Core Modules

### 1. Config.mqh - Configuration Manager
**Purpose**: Centralized configuration and utility functions
**Responsibilities**:
- Parse and validate input parameters
- Manage trading pairs list
- Provide logging utilities
- Currency pair validation
- Pips/points conversion utilities

**Key Features**:
- Static class design for global access
- Environment variable support for trading pairs
- Comprehensive input validation
- Standardized logging system

### 2. OrderBlockDetector.mqh - Order Block Detection Engine
**Purpose**: Detect and manage order blocks across multiple timeframes
**Responsibilities**:
- Identify order blocks using multiple criteria
- Validate order block strength and confirmation
- Manage order block lifecycle (creation, confirmation, expiry)
- Multi-timeframe analysis

**Key Features**:
- **Break of Structure Detection**: Identifies significant price movements
- **Liquidity Zone Analysis**: Finds areas of previous price interaction
- **Strength Calculation**: Measures order block quality using volume, ATR, and time factors
- **Confirmation System**: Validates order blocks with configurable confirmation bars
- **Multi-timeframe Support**: Analyzes M15, H1, H4, and D1 timeframes

### 3. PairManager.mqh - Multi-Pair Management
**Purpose**: Analyze and select the best currency pairs for trading
**Responsibilities**:
- Monitor multiple currency pairs simultaneously
- Calculate opportunity scores for each pair
- Select best pairs based on analysis
- Respect maximum concurrent pairs limit

**Key Features**:
- **Volatility Analysis**: Measures market movement potential
- **Momentum Calculation**: Identifies trending conditions
- **Trend Strength Assessment**: Uses ADX-like calculations
- **Liquidity Scoring**: Evaluates spread and volume conditions
- **Opportunity Ranking**: Combines all factors into a single score

### 4. SignalManager.mqh - Signal Processing Engine
**Purpose**: Generate entry and exit signals based on order blocks
**Responsibilities**:
- Process order block data into actionable signals
- Calculate stop loss and take profit levels
- Validate signal quality and risk-reward ratios
- Manage signal lifecycle

**Key Features**:
- **Entry Signal Generation**: Creates buy/sell signals at order block levels
- **Exit Signal Detection**: Identifies when to close positions
- **Risk Management**: Calculates appropriate stop loss and take profit
- **Signal Validation**: Ensures minimum quality standards
- **Confidence Scoring**: Rates signal reliability

### 5. DisplayManager.mqh - Visual Interface
**Purpose**: Display signals and order blocks on charts
**Responsibilities**:
- Draw entry and exit points
- Show order block rectangles
- Manage chart objects lifecycle
- Handle user interactions

**Key Features**:
- **Interactive Tooltips**: Show detailed signal information
- **Color-coded Signals**: Visual distinction between bullish/bearish
- **Order Block Visualization**: Semi-transparent rectangles
- **Automatic Cleanup**: Removes old objects to prevent clutter

## 🔄 Data Flow

```
1. Timer Event (Every 5 seconds)
   ↓
2. PairManager.AnalyzeAllPairs()
   ↓
3. Select Best Pairs (up to MaxConcurrentPairs)
   ↓
4. For each selected pair:
   ├── OrderBlockDetector.AnalyzePair()
   ├── Detect new order blocks
   ├── SignalManager.ProcessSignal()
   ├── Generate entry/exit signals
   └── DisplayManager.UpdateDisplay()
       └── Show signals on chart
```

## ⚙️ Configuration System

### Environment Variables (Input Parameters)
- **InpTradingPairs**: Comma-separated list of currency pairs
- **InpMaxConcurrentPairs**: Maximum pairs to analyze simultaneously
- **InpOrderBlockLookback**: Historical bars to analyze
- **InpMinOrderBlockSize**: Minimum size requirement in pips
- **InpOrderBlockConfirmation**: Confirmation bars needed

### Best Practices Applied

#### 1. **Separation of Concerns**
Each module has a single, well-defined responsibility:
- Config: Configuration management
- OrderBlockDetector: Technical analysis
- PairManager: Multi-pair coordination
- SignalManager: Signal processing
- DisplayManager: User interface

#### 2. **Dependency Injection**
Components receive their dependencies explicitly:
```cpp
g_signalManager.SetOrderBlockDetector(g_orderBlockDetector);
```

#### 3. **Error Handling**
Comprehensive error checking at all levels:
- Input validation
- Component initialization verification
- Runtime error detection and logging

#### 4. **Memory Management**
Proper cleanup and resource management:
- Destructor cleanup
- Array memory management
- Chart object cleanup

#### 5. **Configurable Behavior**
All key parameters are configurable:
- Trading pairs via environment variable
- Analysis parameters
- Display settings
- Timing intervals

## 🎯 Signal Generation Process

### Order Block Detection Criteria
1. **Break of Structure**: Candle with strong body (>70% of total range)
2. **Liquidity Zone**: Minimum 2 previous touches at the level
3. **Minimum Size**: Configurable minimum size in pips
4. **Confirmation**: Price movement away from the block

### Entry Signal Conditions
- Price approaches confirmed order block
- Order block is less than 1 week old
- Minimum confidence threshold (40%)
- Acceptable risk-reward ratio (1.5:1 minimum)

### Exit Signal Conditions
- Price breaks through order block level
- Order block invalidation
- Time-based exit (if implemented)

## 📊 Opportunity Scoring Algorithm

Each currency pair receives an opportunity score (0-1) based on:

```
Opportunity Score = (Volatility × 0.25) + 
                   (Momentum × 0.30) + 
                   (Trend Strength × 0.25) + 
                   (Liquidity × 0.20)
```

### Scoring Components
- **Volatility**: Average True Range relative to historical data
- **Momentum**: Price position relative to moving averages
- **Trend Strength**: ADX-based trending condition
- **Liquidity**: Spread and volume considerations

## 🛠️ Extensibility Features

### Adding New Analysis Methods
The modular design allows easy addition of new analysis methods:
1. Create new include file in `/Includes/` folder
2. Implement required interface methods
3. Add to main EA initialization
4. Configure dependencies

### Custom Signal Types
New signal types can be added to `ENUM_SIGNAL_TYPE`:
```cpp
enum ENUM_SIGNAL_TYPE
{
    SIGNAL_NONE = 0,
    SIGNAL_BUY_ENTRY = 1,
    SIGNAL_SELL_ENTRY = 2,
    SIGNAL_BUY_EXIT = 3,
    SIGNAL_SELL_EXIT = 4,
    SIGNAL_CUSTOM_NEW = 5  // Add new types here
};
```

## 🔧 Maintenance and Updates

### Logging System
Comprehensive logging at three levels:
- **INFO**: General operational information
- **ERROR**: Error conditions and failures
- **DEBUG**: Detailed debugging information

### Performance Considerations
- Efficient array management with proper sizing
- Minimal chart object creation/deletion
- Configurable analysis intervals
- Memory cleanup procedures

## 🚀 Future Enhancements

The modular architecture supports easy addition of:
1. **Risk Management Module**: Position sizing and portfolio management
2. **News Filter Module**: Economic calendar integration
3. **Backtesting Module**: Historical performance analysis
4. **Machine Learning Module**: AI-enhanced signal generation
5. **Trade Execution Module**: Automated order placement

## 📋 Testing Strategy

### Unit Testing Approach
Each module can be tested independently:
- Mock dependencies for isolated testing
- Validate input/output for each method
- Test error conditions and edge cases

### Integration Testing
- Test component interactions
- Validate data flow between modules
- Performance testing under various market conditions

This modular architecture ensures the EA is maintainable, extensible, and follows software engineering best practices while providing sophisticated order block detection and multi-pair analysis capabilities.