//+------------------------------------------------------------------+
//|                                               DisplayManager.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"
#include "SignalManager.mqh"

//+------------------------------------------------------------------+
//| Display object structure                                         |
//+------------------------------------------------------------------+
struct SDisplayObject
{
    string            name;
    string            symbol;
    ENUM_OBJECT       type;
    datetime          time;
    double            price;
    color             clr;
    bool              is_active;
};

//+------------------------------------------------------------------+
//| Display manager class                                            |
//| Handles visual display of entry/exit points and order blocks     |
//+------------------------------------------------------------------+
class CDisplayManager
{
private:
    SDisplayObject    m_objects[];
    bool              m_showEntryPoints;
    bool              m_showExitPoints;
    color             m_bullishEntryColor;
    color             m_bearishEntryColor;
    color             m_exitColor;
    string            m_objectPrefix;
    
public:
    //--- Constructor/Destructor
    CDisplayManager();
    ~CDisplayManager();
    
    //--- Initialization
    bool Initialize(bool showEntry, bool showExit, color bullishColor, color bearishColor, color exitColor);
    
    //--- Main functions
    void UpdateDisplay(string symbol);
    void UpdateAllDisplays(string &symbols[]);
    void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
    
    //--- Display management
    void ClearAll();
    void ClearSymbol(string symbol);
    bool CreateEntryPoint(string symbol, datetime time, double price, bool isBullish, string tooltip = "");
    bool CreateExitPoint(string symbol, datetime time, double price, string tooltip = "");
    bool CreateOrderBlockRectangle(string symbol, datetime time1, double price1, datetime time2, double price2, bool isBullish);
    
    //--- Utility functions
    void SetDisplaySettings(bool showEntry, bool showExit);
    void SetColors(color bullishColor, color bearishColor, color exitColor);
    bool IsObjectExists(string name);
    
private:
    //--- Drawing functions
    bool DrawArrow(string name, datetime time, double price, color clr, int code, string tooltip = "");
    bool DrawRectangle(string name, datetime time1, double price1, datetime time2, double price2, color clr, bool fill = false);
    bool DrawText(string name, datetime time, double price, string text, color clr, int fontSize = 8);
    bool DrawLine(string name, datetime time1, double price1, datetime time2, double price2, color clr, ENUM_LINE_STYLE style = STYLE_SOLID);
    
    //--- Helper functions
    string GenerateObjectName(string prefix, string symbol, string type, datetime time);
    void AddDisplayObject(const SDisplayObject &obj);
    void RemoveDisplayObject(string name);
    void UpdateTooltip(string name, string tooltip);
    color GetOrderBlockColor(bool isBullish, double alpha = 0.3);
    
    //--- Object management
    void CleanupObject(string name);
    void CleanupOldObjects(string symbol, datetime cutoffTime);
};

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDisplayManager::CDisplayManager()
{
    ArrayResize(m_objects, 0);
    m_showEntryPoints = true;
    m_showExitPoints = true;
    m_bullishEntryColor = clrLime;
    m_bearishEntryColor = clrRed;
    m_exitColor = clrYellow;
    m_objectPrefix = "MetaphizixEA_";
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDisplayManager::~CDisplayManager()
{
    ClearAll();
    ArrayFree(m_objects);
}

//+------------------------------------------------------------------+
//| Initialize display manager                                       |
//+------------------------------------------------------------------+
bool CDisplayManager::Initialize(bool showEntry, bool showExit, color bullishColor, color bearishColor, color exitColor)
{
    CConfig::LogInfo("Initializing Display Manager");
    
    //--- Set display settings
    m_showEntryPoints = showEntry;
    m_showExitPoints = showExit;
    m_bullishEntryColor = bullishColor;
    m_bearishEntryColor = bearishColor;
    m_exitColor = exitColor;
    
    //--- Clear existing objects
    ClearAll();
    
    CConfig::LogInfo("Display Manager initialized successfully");
    return true;
}

//+------------------------------------------------------------------+
//| Update display for specific symbol                               |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateDisplay(string symbol)
{
    //--- Only update if we're showing the current chart symbol
    if(symbol != _Symbol)
        return;
    
    //--- Clean up old objects for this symbol
    CleanupOldObjects(symbol, TimeCurrent() - (7 * 24 * 3600)); // 1 week old
    
    //--- Get signals for this symbol from global signal manager
    extern CSignalManager* g_signalManager;
    if(g_signalManager == NULL)
        return;
    
    SSignal signals[];
    if(!g_signalManager.GetSignals(symbol, signals))
        return;
    
    //--- Display each signal
    for(int i = 0; i < ArraySize(signals); i++)
    {
        if(signals[i].type == SIGNAL_BUY_ENTRY || signals[i].type == SIGNAL_SELL_ENTRY)
        {
            if(m_showEntryPoints)
            {
                bool isBullish = (signals[i].type == SIGNAL_BUY_ENTRY);
                string tooltip = StringFormat("%s\\nEntry: %.5f\\nSL: %.5f\\nTP: %.5f\\nConfidence: %.1f%%\\n%s",
                                            EnumToString(signals[i].type),
                                            signals[i].entry_price,
                                            signals[i].stop_loss,
                                            signals[i].take_profit,
                                            signals[i].confidence * 100,
                                            signals[i].reason);
                                            
                CreateEntryPoint(symbol, signals[i].time, signals[i].entry_price, isBullish, tooltip);
            }
        }
        else if(signals[i].type == SIGNAL_BUY_EXIT || signals[i].type == SIGNAL_SELL_EXIT)
        {
            if(m_showExitPoints)
            {
                string tooltip = StringFormat("%s\\nExit: %.5f\\nConfidence: %.1f%%\\n%s",
                                            EnumToString(signals[i].type),
                                            signals[i].entry_price,
                                            signals[i].confidence * 100,
                                            signals[i].reason);
                                            
                CreateExitPoint(symbol, signals[i].time, signals[i].entry_price, tooltip);
            }
        }
    }
    
    //--- Display order blocks if available
    extern COrderBlockDetector* g_orderBlockDetector;
    if(g_orderBlockDetector != NULL)
    {
        SOrderBlock orderBlocks[];
        if(g_orderBlockDetector.GetOrderBlocks(symbol, orderBlocks))
        {
            for(int i = 0; i < ArraySize(orderBlocks); i++)
            {
                if(orderBlocks[i].is_confirmed)
                {
                    //--- Calculate end time for rectangle (current time or 24 hours from block time)
                    datetime endTime = MathMax(TimeCurrent(), orderBlocks[i].time + (24 * 3600));
                    
                    CreateOrderBlockRectangle(symbol, orderBlocks[i].time, orderBlocks[i].high,
                                            endTime, orderBlocks[i].low, orderBlocks[i].is_bullish);
                }
            }
        }
    }
    
    //--- Redraw chart
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Update displays for all symbols                                  |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateAllDisplays(string &symbols[])
{
    //--- Only update for current chart symbol
    for(int i = 0; i < ArraySize(symbols); i++)
    {
        if(symbols[i] == _Symbol)
        {
            UpdateDisplay(symbols[i]);
            break;
        }
    }
}

//+------------------------------------------------------------------+
//| Handle chart events                                              |
//+------------------------------------------------------------------+
void CDisplayManager::OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    //--- Handle object click events
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        string objectName = sparam;
        
        //--- Check if it's our object
        if(StringFind(objectName, m_objectPrefix) == 0)
        {
            //--- Get object properties and show detailed info
            string tooltip = ObjectGetString(0, objectName, OBJPROP_TOOLTIP);
            if(StringLen(tooltip) > 0)
            {
                //--- Show message box with signal details
                MessageBox(tooltip, "Signal Details - " + objectName, MB_OK | MB_ICONINFORMATION);
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Create entry point display                                       |
//+------------------------------------------------------------------+
bool CDisplayManager::CreateEntryPoint(string symbol, datetime time, double price, bool isBullish, string tooltip = "")
{
    string name = GenerateObjectName(m_objectPrefix, symbol, "Entry", time);
    color arrowColor = isBullish ? m_bullishEntryColor : m_bearishEntryColor;
    int arrowCode = isBullish ? 233 : 234; // Up arrow for buy, down arrow for sell
    
    if(DrawArrow(name, time, price, arrowColor, arrowCode, tooltip))
    {
        SDisplayObject obj;
        obj.name = name;
        obj.symbol = symbol;
        obj.type = OBJ_ARROW;
        obj.time = time;
        obj.price = price;
        obj.clr = arrowColor;
        obj.is_active = true;
        
        AddDisplayObject(obj);
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Create exit point display                                        |
//+------------------------------------------------------------------+
bool CDisplayManager::CreateExitPoint(string symbol, datetime time, double price, string tooltip = "")
{
    string name = GenerateObjectName(m_objectPrefix, symbol, "Exit", time);
    int arrowCode = 251; // X mark for exit
    
    if(DrawArrow(name, time, price, m_exitColor, arrowCode, tooltip))
    {
        SDisplayObject obj;
        obj.name = name;
        obj.symbol = symbol;
        obj.type = OBJ_ARROW;
        obj.time = time;
        obj.price = price;
        obj.clr = m_exitColor;
        obj.is_active = true;
        
        AddDisplayObject(obj);
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Create order block rectangle                                     |
//+------------------------------------------------------------------+
bool CDisplayManager::CreateOrderBlockRectangle(string symbol, datetime time1, double price1, datetime time2, double price2, bool isBullish)
{
    string name = GenerateObjectName(m_objectPrefix, symbol, "OrderBlock", time1);
    color blockColor = GetOrderBlockColor(isBullish);
    
    if(DrawRectangle(name, time1, price1, time2, price2, blockColor, true))
    {
        SDisplayObject obj;
        obj.name = name;
        obj.symbol = symbol;
        obj.type = OBJ_RECTANGLE;
        obj.time = time1;
        obj.price = price1;
        obj.clr = blockColor;
        obj.is_active = true;
        
        AddDisplayObject(obj);
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Draw arrow object                                                |
//+------------------------------------------------------------------+
bool CDisplayManager::DrawArrow(string name, datetime time, double price, color clr, int code, string tooltip = "")
{
    if(ObjectCreate(0, name, OBJ_ARROW, 0, time, price))
    {
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_ARROWCODE, code);
        ObjectSetInteger(0, name, OBJPROP_WIDTH, 3);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        
        if(StringLen(tooltip) > 0)
            ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);
        
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Draw rectangle object                                            |
//+------------------------------------------------------------------+
bool CDisplayManager::DrawRectangle(string name, datetime time1, double price1, datetime time2, double price2, color clr, bool fill = false)
{
    if(ObjectCreate(0, name, OBJ_RECTANGLE, 0, time1, price1, time2, price2))
    {
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_SOLID);
        ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
        ObjectSetInteger(0, name, OBJPROP_BACK, true);
        ObjectSetInteger(0, name, OBJPROP_FILL, fill);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Draw text object                                                 |
//+------------------------------------------------------------------+
bool CDisplayManager::DrawText(string name, datetime time, double price, string text, color clr, int fontSize = 8)
{
    if(ObjectCreate(0, name, OBJ_TEXT, 0, time, price))
    {
        ObjectSetString(0, name, OBJPROP_TEXT, text);
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_FONTSIZE, fontSize);
        ObjectSetString(0, name, OBJPROP_FONT, "Arial");
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Draw line object                                                 |
//+------------------------------------------------------------------+
bool CDisplayManager::DrawLine(string name, datetime time1, double price1, datetime time2, double price2, color clr, ENUM_LINE_STYLE style = STYLE_SOLID)
{
    if(ObjectCreate(0, name, OBJ_TREND, 0, time1, price1, time2, price2))
    {
        ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
        ObjectSetInteger(0, name, OBJPROP_STYLE, style);
        ObjectSetInteger(0, name, OBJPROP_WIDTH, 1);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, false);
        
        return true;
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Generate unique object name                                      |
//+------------------------------------------------------------------+
string CDisplayManager::GenerateObjectName(string prefix, string symbol, string type, datetime time)
{
    return StringFormat("%s%s_%s_%d", prefix, symbol, type, (int)time);
}

//+------------------------------------------------------------------+
//| Add display object to array                                      |
//+------------------------------------------------------------------+
void CDisplayManager::AddDisplayObject(const SDisplayObject &obj)
{
    //--- Check if object already exists
    for(int i = 0; i < ArraySize(m_objects); i++)
    {
        if(m_objects[i].name == obj.name)
        {
            m_objects[i] = obj; // Update existing
            return;
        }
    }
    
    //--- Add new object
    ArrayResize(m_objects, ArraySize(m_objects) + 1);
    m_objects[ArraySize(m_objects) - 1] = obj;
}

//+------------------------------------------------------------------+
//| Remove display object                                            |
//+------------------------------------------------------------------+
void CDisplayManager::RemoveDisplayObject(string name)
{
    for(int i = 0; i < ArraySize(m_objects); i++)
    {
        if(m_objects[i].name == name)
        {
            ArrayRemove(m_objects, i, 1);
            break;
        }
    }
}

//+------------------------------------------------------------------+
//| Get order block color with transparency                          |
//+------------------------------------------------------------------+
color CDisplayManager::GetOrderBlockColor(bool isBullish, double alpha = 0.3)
{
    if(isBullish)
    {
        //--- Convert to ARGB format with alpha
        return (color)((int)(alpha * 255) << 24 | (m_bullishEntryColor & 0xFFFFFF));
    }
    else
    {
        //--- Convert to ARGB format with alpha
        return (color)((int)(alpha * 255) << 24 | (m_bearishEntryColor & 0xFFFFFF));
    }
}

//+------------------------------------------------------------------+
//| Cleanup specific object                                          |
//+------------------------------------------------------------------+
void CDisplayManager::CleanupObject(string name)
{
    if(ObjectFind(0, name) >= 0)
    {
        ObjectDelete(0, name);
    }
    RemoveDisplayObject(name);
}

//+------------------------------------------------------------------+
//| Cleanup old objects                                              |
//+------------------------------------------------------------------+
void CDisplayManager::CleanupOldObjects(string symbol, datetime cutoffTime)
{
    for(int i = ArraySize(m_objects) - 1; i >= 0; i--)
    {
        if(m_objects[i].symbol == symbol && m_objects[i].time < cutoffTime)
        {
            CleanupObject(m_objects[i].name);
        }
    }
}

//+------------------------------------------------------------------+
//| Clear all display objects                                        |
//+------------------------------------------------------------------+
void CDisplayManager::ClearAll()
{
    //--- Remove all objects from chart
    for(int i = 0; i < ArraySize(m_objects); i++)
    {
        ObjectDelete(0, m_objects[i].name);
    }
    
    //--- Clear array
    ArrayResize(m_objects, 0);
    
    //--- Also remove any remaining objects with our prefix
    int totalObjects = ObjectsTotal(0, -1, -1);
    for(int i = totalObjects - 1; i >= 0; i--)
    {
        string objName = ObjectName(0, i, -1, -1);
        if(StringFind(objName, m_objectPrefix) == 0)
        {
            ObjectDelete(0, objName);
        }
    }
    
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Clear objects for specific symbol                                |
//+------------------------------------------------------------------+
void CDisplayManager::ClearSymbol(string symbol)
{
    for(int i = ArraySize(m_objects) - 1; i >= 0; i--)
    {
        if(m_objects[i].symbol == symbol)
        {
            CleanupObject(m_objects[i].name);
        }
    }
}

//+------------------------------------------------------------------+
//| Set display settings                                             |
//+------------------------------------------------------------------+
void CDisplayManager::SetDisplaySettings(bool showEntry, bool showExit)
{
    m_showEntryPoints = showEntry;
    m_showExitPoints = showExit;
}

//+------------------------------------------------------------------+
//| Set colors                                                       |
//+------------------------------------------------------------------+
void CDisplayManager::SetColors(color bullishColor, color bearishColor, color exitColor)
{
    m_bullishEntryColor = bullishColor;
    m_bearishEntryColor = bearishColor;
    m_exitColor = exitColor;
}

//+------------------------------------------------------------------+
//| Check if object exists                                           |
//+------------------------------------------------------------------+
bool CDisplayManager::IsObjectExists(string name)
{
    return ObjectFind(0, name) >= 0;
}

//+------------------------------------------------------------------+
//| Update tooltip                                                   |
//+------------------------------------------------------------------+
void CDisplayManager::UpdateTooltip(string name, string tooltip)
{
    if(ObjectFind(0, name) >= 0)
    {
        ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);
    }
}