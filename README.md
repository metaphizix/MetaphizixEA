# MetaphizixEA

A MetaTrader 5 Expert Advisor (EA) template with comprehensive event handling framework.

## 📊 Overview

MetaphizixEA is a foundational Expert Advisor for MetaTrader 5 that provides a complete event-driven architecture for algorithmic trading. The EA includes all standard MQL5 event handlers, making it an excellent starting point for developing sophisticated trading strategies.

## 🚀 Features

- **Complete Event Framework**: Implements all MQL5 event handlers including:

  - `OnInit()` - Expert initialization
  - `OnDeinit()` - Expert deinitialization
  - `OnTick()` - Price tick processing
  - `OnTimer()` - Timer-based operations
  - `OnTrade()` - Trade event handling
  - `OnTradeTransaction()` - Trade transaction monitoring
  - `OnTester()` - Strategy tester integration
  - `OnChartEvent()` - Chart interaction events
  - `OnBookEvent()` - Depth of Market events

- **Timer Integration**: Built-in 60-second timer for periodic operations
- **Strategy Tester Ready**: Full compatibility with MT5 Strategy Tester
- **Event-Driven Architecture**: Clean structure for implementing trading logic

## 📁 Project Structure

```
MetaphizixEA/
├── MetaphizixEA.mq5      # Main Expert Advisor source code
├── MetaphizixEA.mqproj   # MetaEditor project file
└── README.md             # This documentation
```

## 🛠️ Installation

### Prerequisites

- MetaTrader 5 platform
- MetaEditor (included with MT5)

### Installation Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/metaphizix/MetaphizixEA.git
   ```

2. **Copy to MT5 Experts folder:**

   ```
   Copy MetaphizixEA.mq5 to:
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

## ⚙️ Configuration

Currently, the EA is a template without specific trading parameters. Future versions will include:

- Risk management settings
- Trading strategy parameters
- Timeframe selections
- Symbol filters
- Position sizing options

## 🔧 Development

This EA serves as a foundation for implementing trading strategies. Key areas for development:

### OnTick() Function

```mql5
void OnTick()
{
    // Implement your trading logic here
    // Example: Check signals, manage positions, etc.
}
```

### OnTimer() Function

```mql5
void OnTimer()
{
    // Implement periodic operations
    // Example: Portfolio management, risk checks, etc.
}
```

### Trading Logic Implementation

- Add signal generation algorithms
- Implement risk management rules
- Create position management system
- Add performance monitoring

## 📈 Usage Examples

### Basic Implementation

```mql5
void OnTick()
{
    // Simple moving average crossover example
    double ma_fast = iMA(_Symbol, PERIOD_CURRENT, 10, 0, MODE_SMA, PRICE_CLOSE);
    double ma_slow = iMA(_Symbol, PERIOD_CURRENT, 20, 0, MODE_SMA, PRICE_CLOSE);

    // Your trading logic here
}
```

## 🧪 Testing

1. **Strategy Tester:**

   - Open MetaTrader 5
   - Press Ctrl+R to open Strategy Tester
   - Select MetaphizixEA
   - Configure test parameters
   - Run backtest

2. **Visual Mode:**
   - Enable visual mode for step-by-step testing
   - Monitor EA behavior in real-time

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

## 📜 License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

**Trading Risk Warning**: Trading financial instruments involves substantial risk and may result in loss of capital. Past performance does not guarantee future results. Only trade with capital you can afford to lose.

This Expert Advisor is provided for educational and research purposes. Use at your own risk.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/metaphizix/MetaphizixEA/issues)
- **Discussions**: [GitHub Discussions](https://github.com/metaphizix/MetaphizixEA/discussions)

## 🗓️ Version History

- **v1.0.0** (2025-10-07): Initial release with complete event framework

---

**Built with ❤️ for the MetaTrader 5 community**
