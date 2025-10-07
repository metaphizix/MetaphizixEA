# MetaphizixEA

A sophisticated MetaTrader 5 Expert Advisor with modular architecture for order block detection and multi-pair analysis.

## 📊 Overview

MetaphizixEA is an advanced Expert Advisor for MetaTrader 5 that provides automated order block detection across multiple currency pairs. The EA follows a modular, object-oriented design with clear separation of concerns, built using software engineering best practices for maintainability, scalability, and testability.

**Key Capabilities:**
- Automatic order block detection on multiple timeframes
- Multi-pair analysis with opportunity scoring
- Visual display of entry and exit points
- Configurable trading pairs via environment variables
- Real-time signal generation and validation

## 🚀 Features

### Core Functionality
- **Order Block Detection**: Advanced algorithm detecting institutional order blocks using break of structure and liquidity zone analysis
- **Multi-Pair Support**: Simultaneous analysis of multiple currency pairs with automatic pair selection
- **Signal Generation**: Entry and exit signals with calculated stop loss and take profit levels
- **Visual Interface**: Interactive chart display with tooltips and color-coded signals
- **Environment Variables**: Configurable trading pairs list and maximum concurrent pairs

### Technical Features
- **Modular Architecture**: Five separate modules with clear responsibilities
- **Multi-timeframe Analysis**: M15, H1, H4, and D1 timeframe support
- **Opportunity Scoring**: Algorithmic ranking of currency pairs based on volatility, momentum, trend strength, and liquidity
- **Risk Management**: Automatic stop loss and take profit calculation with configurable risk-reward ratios
- **Error Handling**: Comprehensive validation and logging system
- **Memory Management**: Efficient resource cleanup and object lifecycle management

## 🏗️ Architecture Overview

MetaphizixEA follows a modular design with clear separation of concerns:

### 📦 Core Modules

#### 1. Config.mqh - Configuration Manager
**Purpose**: Centralized configuration and utility functions

**Responsibilities:**
- Parse and validate input parameters
- Manage trading pairs list
- Provide logging utilities
- Currency pair validation
- Pips/points conversion utilities

**Key Features:**
- Static class design for global access
- Environment variable support for trading pairs
- Comprehensive input validation
- Standardized logging system

#### 2. OrderBlockDetector.mqh - Order Block Detection Engine
**Purpose**: Detect and manage order blocks across multiple timeframes

**Responsibilities:**
- Identify order blocks using multiple criteria
- Validate order block strength and confirmation
- Manage order block lifecycle (creation, confirmation, expiry)
- Multi-timeframe analysis

**Key Features:**
- **Break of Structure Detection**: Identifies significant price movements
- **Liquidity Zone Analysis**: Finds areas of previous price interaction
- **Strength Calculation**: Measures order block quality using volume, ATR, and time factors
- **Confirmation System**: Validates order blocks with configurable confirmation bars
- **Multi-timeframe Support**: Analyzes M15, H1, H4, and D1 timeframes

#### 3. PairManager.mqh - Multi-Pair Management
**Purpose**: Analyze and select the best currency pairs for trading

**Responsibilities:**
- Monitor multiple currency pairs simultaneously
- Calculate opportunity scores for each pair
- Select best pairs based on analysis
- Respect maximum concurrent pairs limit

**Key Features:**
- **Volatility Analysis**: Measures market movement potential
- **Momentum Calculation**: Identifies trending conditions
- **Trend Strength Assessment**: Uses ADX-like calculations
- **Liquidity Scoring**: Evaluates spread and volume conditions
- **Opportunity Ranking**: Combines all factors into a single score

#### 4. SignalManager.mqh - Signal Processing Engine
**Purpose**: Generate entry and exit signals based on order blocks

**Responsibilities:**
- Process order block data into actionable signals
- Calculate stop loss and take profit levels
- Validate signal quality and risk-reward ratios
- Manage signal lifecycle

**Key Features:**
- **Entry Signal Generation**: Creates buy/sell signals at order block levels
- **Exit Signal Detection**: Identifies when to close positions
- **Risk Management**: Calculates appropriate stop loss and take profit
- **Signal Validation**: Ensures minimum quality standards
- **Confidence Scoring**: Rates signal reliability

#### 5. DisplayManager.mqh - Visual Interface
**Purpose**: Display signals and order blocks on charts

**Responsibilities:**
- Draw entry and exit points
- Show order block rectangles
- Manage chart objects lifecycle
- Handle user interactions

**Key Features:**
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

## 📁 Project Structure

```
MetaphizixEA/
├── MetaphizixEA.mq5              # Main Expert Advisor source code
├── MetaphizixEA.mqproj           # MetaEditor project file
├── Includes/                     # Modular components
│   ├── Config.mqh               # Configuration manager
│   ├── OrderBlockDetector.mqh   # Order block detection engine
│   ├── PairManager.mqh          # Multi-pair management
│   ├── SignalManager.mqh        # Signal processing engine
│   └── DisplayManager.mqh       # Visual interface manager
└── README.md                     # This documentation
```

## ⚙️ Configuration System

### Environment Variables (Input Parameters)
- **InpTradingPairs**: Comma-separated list of currency pairs
- **InpMaxConcurrentPairs**: Maximum pairs to analyze simultaneously (1-28)
- **InpOrderBlockLookback**: Historical bars to analyze (10-200)
- **InpMinOrderBlockSize**: Minimum size requirement in pips (5-100)
- **InpOrderBlockConfirmation**: Confirmation bars needed (1-10)

### Display Settings
- **InpShowEntryPoints**: Toggle entry point display
- **InpShowExitPoints**: Toggle exit point display
- **InpBullishEntryColor**: Color for bullish entry signals
- **InpBearishEntryColor**: Color for bearish entry signals
- **InpExitColor**: Color for exit signals

### System Settings
- **InpTimerInterval**: Analysis interval in seconds (1-60)
- **InpEnableLogging**: Enable detailed logging

## 🛠️ Installation

### Prerequisites
- MetaTrader 5 platform (build 3800+)
- MetaEditor (included with MT5)

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/metaphizix/MetaphizixEA.git
   ```

2. **Copy to MT5 Experts folder:**
   ```
   Copy entire MetaphizixEA folder to:
   [MT5 Data Folder]/MQL5/Experts/
   ```

3. **Compile in MetaEditor:**
   - Open MetaEditor
   - Open `MetaphizixEA.mq5`
   - Press F7 or click Compile
   - Ensure compilation is successful

4. **Attach to Chart:**
   - Open MetaTrader 5
   - Navigate to Navigator → Expert Advisors
   - Drag MetaphizixEA to your desired chart
   - Configure settings and click OK

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

## 🧪 Testing

### Strategy Tester
1. Open MetaTrader 5
2. Press Ctrl+R to open Strategy Tester
3. Select MetaphizixEA
4. Configure test parameters:
   - Set trading pairs in inputs
   - Configure order block parameters
   - Enable visual mode for detailed analysis
5. Run backtest

### Visual Mode Testing
- Enable visual mode for step-by-step analysis
- Monitor order block detection in real-time
- Observe signal generation and display
- Validate entry/exit point accuracy

## 🔧 Best Practices Applied

### 1. Separation of Concerns
Each module has a single, well-defined responsibility:
- Config: Configuration management
- OrderBlockDetector: Technical analysis
- PairManager: Multi-pair coordination
- SignalManager: Signal processing
- DisplayManager: User interface

### 2. Dependency Injection
Components receive their dependencies explicitly:
```cpp
g_signalManager.SetOrderBlockDetector(g_orderBlockDetector);
```

### 3. Error Handling
Comprehensive error checking at all levels:
- Input validation
- Component initialization verification
- Runtime error detection and logging

### 4. Memory Management
Proper cleanup and resource management:
- Destructor cleanup
- Array memory management
- Chart object cleanup

### 5. Configurable Behavior
All key parameters are configurable:
- Trading pairs via environment variable
- Analysis parameters
- Display settings
- Timing intervals

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

## 📋 Requirements

- **Platform**: MetaTrader 5 build 3800+
- **Account**: Any account type (demo/live)
- **Permissions**: Allow automated trading
- **Dependencies**: Standard MQL5 library

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Guidelines
1. Follow MQL5 coding standards
2. Include comprehensive comments
3. Test thoroughly before submitting
4. Update documentation as needed

### Testing Strategy

#### Unit Testing Approach
Each module can be tested independently:
- Mock dependencies for isolated testing
- Validate input/output for each method
- Test error conditions and edge cases

#### Integration Testing
- Test component interactions
- Validate data flow between modules
- Performance testing under various market conditions

## 📜 License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

**Trading Risk Warning**: Trading financial instruments involves substantial risk and may result in loss of capital. Past performance does not guarantee future results. Only trade with capital you can afford to lose.

This Expert Advisor is provided for educational and research purposes. Use at your own risk. The EA currently displays signals only and does not execute trades automatically.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/metaphizix/MetaphizixEA/issues)
- **Discussions**: [GitHub Discussions](https://github.com/metaphizix/MetaphizixEA/discussions)

## 🗓️ Version History

- **v2.0.0** (2025-10-07): Complete modular rewrite with order block detection
  - Modular architecture with 5 core components
  - Order block detection across multiple timeframes
  - Multi-pair analysis and opportunity scoring
  - Visual signal display with interactive tooltips
  - Environment variable configuration
  - Comprehensive error handling and logging

- **v1.0.0** (2025-10-07): Initial release with complete event framework

---

This modular architecture ensures the EA is maintainable, extensible, and follows software engineering best practices while providing sophisticated order block detection and multi-pair analysis capabilities.

**Built with ❤️ for the MetaTrader 5 community**
