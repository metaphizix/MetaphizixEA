//+------------------------------------------------------------------+
//|                                                   MLPredictor.mqh |
//|                                  Copyright 2025, Metaphizix Ltd. |
//|                           https://github.com/metaphizix/MetaphizixEA |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Metaphizix Ltd."
#property link      "https://github.com/metaphizix/MetaphizixEA"

#include "Config.mqh"

//+------------------------------------------------------------------+
//| Machine Learning enumerations                                   |
//+------------------------------------------------------------------+
enum ENUM_ML_MODEL_TYPE
{
    ML_MODEL_LINEAR_REGRESSION,  // Linear regression
    ML_MODEL_LOGISTIC_REGRESSION, // Logistic regression
    ML_MODEL_RANDOM_FOREST,      // Random Forest
    ML_MODEL_SVM,                // Support Vector Machine
    ML_MODEL_NEURAL_NETWORK,     // Neural Network
    ML_MODEL_LSTM,               // Long Short-Term Memory
    ML_MODEL_XG_BOOST,           // XGBoost
    ML_MODEL_ENSEMBLE,           // Ensemble model
    ML_MODEL_REINFORCEMENT       // Reinforcement Learning
};

enum ENUM_PREDICTION_TYPE
{
    PREDICTION_DIRECTION,        // Price direction (up/down)
    PREDICTION_PRICE_TARGET,     // Specific price target
    PREDICTION_VOLATILITY,       // Volatility prediction
    PREDICTION_TREND_STRENGTH,   // Trend strength
    PREDICTION_REVERSAL_PROB,    // Reversal probability
    PREDICTION_BREAKOUT_PROB,    // Breakout probability
    PREDICTION_RISK_LEVEL        // Risk level prediction
};

enum ENUM_FEATURE_TYPE
{
    FEATURE_TECHNICAL,           // Technical indicators
    FEATURE_PRICE_ACTION,        // Price action patterns
    FEATURE_VOLUME,              // Volume-based features
    FEATURE_VOLATILITY,          // Volatility features
    FEATURE_CORRELATION,         // Cross-asset correlations
    FEATURE_SENTIMENT,           // Market sentiment
    FEATURE_NEWS,                // News sentiment/impact
    FEATURE_ECONOMIC,            // Economic indicators
    FEATURE_TEMPORAL             // Time-based features
};

//+------------------------------------------------------------------+
//| Machine Learning structures                                     |
//+------------------------------------------------------------------+
struct SMLConfig
{
    ENUM_ML_MODEL_TYPE modelType;
    string modelPath;
    int lookbackPeriod;          // Historical data period
    int predictionHorizon;       // Prediction time horizon
    double confidenceThreshold; // Minimum confidence for predictions
    int retrainPeriod;          // Model retraining frequency
    bool enableOnlineLearning;   // Enable continuous learning
    bool enableEnsemble;         // Use ensemble methods
    int maxFeatures;            // Maximum number of features
    double validationSplit;     // Validation data split ratio
};

struct SMLFeature
{
    string name;
    ENUM_FEATURE_TYPE type;
    double value;
    double weight;
    double importance;
    datetime timestamp;
};

struct SMLPrediction
{
    string symbol;
    ENUM_PREDICTION_TYPE type;
    double prediction;
    double confidence;
    double probability[];        // Probability distribution
    SMLFeature features[];       // Input features used
    datetime predictionTime;
    datetime targetTime;
    string modelUsed;
    double expectedAccuracy;
};

struct SMLModelPerformance
{
    string modelName;
    double accuracy;
    double precision;
    double recall;
    double f1Score;
    double sharpeRatio;
    double maxDrawdown;
    int totalPredictions;
    int correctPredictions;
    datetime lastUpdate;
    double calibrationScore;     // How well-calibrated are the probabilities
};

struct STrainingData
{
    double features[][];         // Feature matrix [sample][feature]
    double targets[];            // Target values
    datetime timestamps[];       // Time stamps for each sample
    int sampleCount;
    int featureCount;
};

//+------------------------------------------------------------------+
//| Advanced ML Predictor class                                     |
//| Integrates machine learning for predictive signal generation    |
//+------------------------------------------------------------------+
class CMLPredictor
{
private:
    // Configuration
    SMLConfig m_config;
    
    // Model management
    string m_loadedModels[];
    SMLModelPerformance m_modelPerformance[];
    datetime m_lastTrainingTime;
    bool m_modelsInitialized;
    
    // Feature engineering
    SMLFeature m_featureSet[];
    string m_featureNames[];
    double m_featureWeights[];
    double m_featureImportance[];
    
    // Prediction tracking
    SMLPrediction m_predictions[];
    SMLPrediction m_predictionHistory[];
    
    // Training data management
    STrainingData m_trainingData;
    double m_validationData[][];
    double m_validationTargets[];
    
    // Online learning
    double m_learningRate;
    double m_decayRate;
    bool m_adaptiveWeights;
    
    // Ensemble components
    double m_ensembleWeights[];
    string m_ensembleModels[];
    
public:
    //--- Constructor/Destructor
    CMLPredictor();
    ~CMLPredictor();
    
    //--- Initialization and configuration
    bool Initialize(const SMLConfig &config);
    bool LoadModel(const string modelPath, ENUM_ML_MODEL_TYPE modelType);
    bool LoadEnsembleModels(const string modelPaths[]);
    void SetConfiguration(const SMLConfig &config);
    
    //--- Feature engineering
    bool ExtractFeatures(const string symbol, SMLFeature &features[]);
    bool AddCustomFeature(const string name, ENUM_FEATURE_TYPE type, double value);
    void UpdateFeatureWeights();
    double CalculateFeatureImportance(const string featureName);
    
    //--- Prediction methods
    SMLPrediction PredictDirection(const string symbol);
    SMLPrediction PredictPriceTarget(const string symbol, int horizonBars);
    SMLPrediction PredictVolatility(const string symbol, int horizonBars);
    SMLPrediction PredictTrendStrength(const string symbol);
    SMLPrediction PredictReversalProbability(const string symbol);
    SMLPrediction PredictBreakoutProbability(const string symbol);
    
    //--- Ensemble predictions
    SMLPrediction GetEnsemblePrediction(const string symbol, ENUM_PREDICTION_TYPE type);
    double CalculateEnsembleConfidence(const SMLPrediction predictions[]);
    void OptimizeEnsembleWeights();
    
    //--- Model training and updates
    bool TrainModel(const string symbol, int trainingPeriod);
    bool UpdateModelOnline(const string symbol, const SMLFeature features[], double target);
    bool RetrainPeriodically();
    bool ValidateModel(const string symbol);
    
    //--- Performance monitoring
    void UpdatePredictionOutcome(const SMLPrediction &prediction, double actualOutcome);
    SMLModelPerformance GetModelPerformance(const string modelName);
    double CalculateModelAccuracy(const string modelName, int evaluationPeriod);
    bool IsModelPerformanceDegrading(const string modelName);
    
    //--- Feature analysis
    void AnalyzeFeatureImportance();
    void SelectOptimalFeatures(int maxFeatures);
    bool IsFeatureRelevant(const string featureName, double threshold = 0.01);
    void RemoveIrrelevantFeatures();
    
    //--- Prediction validation and calibration
    bool IsPredictionReliable(const SMLPrediction &prediction);
    double CalibrateConfidence(double rawConfidence, const string modelName);
    void UpdateCalibrationParameters();
    
    //--- Risk assessment with ML
    double AssessMLRisk(const SMLPrediction &prediction);
    bool ShouldUsePrediction(const SMLPrediction &prediction, double riskTolerance);
    double CalculatePredictionUncertainty(const SMLPrediction &prediction);
    
    //--- Trading signal integration
    bool GenerateMLSignal(const string symbol, STechnicalSignal &signal);
    double EnhanceSignalWithML(const STechnicalSignal &baseSignal);
    bool ValidateSignalWithML(const STechnicalSignal &signal);
    
    //--- Market regime adaptation
    bool DetectMarketRegimeChange();
    void AdaptModelToRegime(ENUM_MARKET_CONDITION regime);
    double GetRegimeAdjustedPrediction(const SMLPrediction &prediction, ENUM_MARKET_CONDITION regime);
    
    //--- Model explanation and interpretability
    void ExplainPrediction(const SMLPrediction &prediction, string &explanation);
    void GetTopContributingFeatures(const SMLPrediction &prediction, SMLFeature &topFeatures[], int count = 5);
    double CalculateFeatureContribution(const SMLFeature &feature, const SMLPrediction &prediction);
    
    //--- Data management
    bool PrepareTrainingData(const string symbol, int period);
    void CleanTrainingData();
    bool ExportTrainingData(const string filePath);
    bool ImportTrainingData(const string filePath);
    
    //--- Getters and utilities
    SMLPrediction GetLatestPrediction(const string symbol, ENUM_PREDICTION_TYPE type);
    double GetPredictionConfidence(const string symbol, ENUM_PREDICTION_TYPE type);
    bool IsMLEnabled() { return m_modelsInitialized; }
    int GetLoadedModelCount() { return ArraySize(m_loadedModels); }
    
    //--- Configuration getters/setters
    void SetConfidenceThreshold(double threshold) { m_config.confidenceThreshold = threshold; }
    void SetLookbackPeriod(int period) { m_config.lookbackPeriod = period; }
    void EnableOnlineLearning(bool enable) { m_config.enableOnlineLearning = enable; }
    
private:
    //--- Internal ML implementation (simplified interfaces)
    bool InitializeNeuralNetwork(const string modelPath);
    bool InitializeRandomForest(const string modelPath);
    bool InitializeLinearModel(const string modelPath);
    bool InitializeEnsemble();
    
    //--- Feature extraction helpers
    void ExtractTechnicalFeatures(const string symbol, SMLFeature &features[]);
    void ExtractPriceActionFeatures(const string symbol, SMLFeature &features[]);
    void ExtractVolumeFeatures(const string symbol, SMLFeature &features[]);
    void ExtractVolatilityFeatures(const string symbol, SMLFeature &features[]);
    void ExtractTemporalFeatures(const string symbol, SMLFeature &features[]);
    
    //--- Data preprocessing
    void NormalizeFeatures(SMLFeature &features[]);
    void HandleMissingValues(SMLFeature &features[]);
    void ScaleFeatures(SMLFeature &features[], double minVal = -1.0, double maxVal = 1.0);
    
    //--- Model inference (simplified - would interface with actual ML libraries)
    double InferenceLinearModel(const SMLFeature features[]);
    double InferenceNeuralNetwork(const SMLFeature features[]);
    double InferenceRandomForest(const SMLFeature features[]);
    double InferenceEnsemble(const SMLFeature features[]);
    
    //--- Training helpers
    void UpdateModelWeights(const SMLFeature features[], double target, double learningRate);
    void BackpropagateError(double error);
    void UpdateFeatureImportance(const SMLFeature features[], double target);
    
    //--- Performance calculation helpers
    void CalculateConfusionMatrix(const double predictions[], const double targets[], int size);
    double CalculateROCAUC(const double predictions[], const double targets[], int size);
    double CalculateMeanSquaredError(const double predictions[], const double targets[], int size);
    
    //--- Array management
    void AddPredictionToHistory(const SMLPrediction &prediction);
    void CleanupPredictionHistory();
    void ResizeTrainingArrays(int sampleCount, int featureCount);
    
    //--- Validation and diagnostics
    bool ValidateFeatures(const SMLFeature features[]);
    void LogPrediction(const SMLPrediction &prediction);
    void LogModelPerformance(const SMLModelPerformance &performance);
    void LogFeatureImportance();
};