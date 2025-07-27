import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpathyNeuralProfileProvider extends ChangeNotifier {
  final String _apiKey;
  bool _isAnalyzing = false;
  DateTime? _lastAnalysisTime;
  Map<String, dynamic> _activityMetrics = {};
  List<String> _progressInsights = [];
  List<Map<String, dynamic>> _recentActivities = [];

  EmpathyNeuralProfileProvider(this._apiKey);

  bool get isAnalyzing => _isAnalyzing;
  DateTime? get lastAnalysisTime => _lastAnalysisTime;
  Map<String, dynamic> get activityMetrics => _activityMetrics;
  List<String> get progressInsights => _progressInsights;
  List<Map<String, dynamic>> get recentActivities => _recentActivities;

  Map<String, dynamic>? get profileData {
    if (_activityMetrics.isEmpty &&
        _progressInsights.isEmpty &&
        _recentActivities.isEmpty) {
      return null;
    }
    return {
      'activityMetrics': _activityMetrics,
      'progressInsights': _progressInsights,
      'recentActivities': _recentActivities,
      'lastAnalysisTime': _lastAnalysisTime?.toIso8601String(),
    };
  }

  Future<void> loadAnalyticsData() async {
    _isAnalyzing = true;
    notifyListeners();

    // Simulate loading data
    await Future.delayed(const Duration(seconds: 2));

    _activityMetrics = {
      'sessions': 23,
      'scenarios': 15,
      'games': 8,
      'empathy_score': 78.0,
      'listening_score': 82.0,
      'eq_score': 75.0,
    };

    _progressInsights = [
      'Your empathy scores have improved 15% this week',
      'Active listening skills show consistent growth',
      'Consider more conflict resolution scenarios',
      'Great progress in emotional intelligence exercises',
    ];

    _recentActivities = [
      {
        'type': 'chat',
        'description': 'Completed empathy chat session',
        'score': 85,
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'type': 'scenario',
        'description': 'Relationship conflict scenario',
        'score': 72,
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'type': 'game',
        'description': 'Bubble pop stress relief',
        'score': 90,
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];

    _lastAnalysisTime = DateTime.now();
    _isAnalyzing = false;
    notifyListeners();
  }

  Future<void> analyzeActivity(
      String activityType, Map<String, dynamic> activityData) async {
    if (_apiKey.isEmpty) {
      print('OpenAI API key not available');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are an empathy analysis AI. Analyze user activities and provide empathy scores and insights.'
            },
            {
              'role': 'user',
              'content':
                  'Analyze this $activityType activity: ${jsonEncode(activityData)}'
            }
          ],
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analysis = data['choices'][0]['message']['content'];

        // Process AI analysis and update metrics
        await _processAnalysis(activityType, analysis, activityData);
      }
    } catch (e) {
      print('Error analyzing activity: $e');
    }
  }

  Future<void> _processAnalysis(
      String activityType, String analysis, Map<String, dynamic> data) async {
    // Add to recent activities
    _recentActivities.insert(0, {
      'type': activityType,
      'description': data['description'] ?? 'Activity completed',
      'score': data['score'] ?? 75,
      'timestamp': DateTime.now(),
      'analysis': analysis,
    });

    // Keep only last 10 activities
    if (_recentActivities.length > 10) {
      _recentActivities = _recentActivities.take(10).toList();
    }

    // Update metrics based on analysis
    _updateMetrics(activityType, data);

    notifyListeners();
  }

  void _updateMetrics(String activityType, Map<String, dynamic> data) {
    switch (activityType) {
      case 'chat':
        _activityMetrics['sessions'] = (_activityMetrics['sessions'] ?? 0) + 1;
        break;
      case 'scenario':
        _activityMetrics['scenarios'] =
            (_activityMetrics['scenarios'] ?? 0) + 1;
        break;
      case 'game':
        _activityMetrics['games'] = (_activityMetrics['games'] ?? 0) + 1;
        break;
    }

    // Update scores based on performance
    if (data.containsKey('empathy_score')) {
      _activityMetrics['empathy_score'] = data['empathy_score'];
    }
  }

  Future<void> refreshAnalytics() async {
    await loadAnalyticsData();
  }

  // Method to be called by other features to log activities
  Future<void> logActivity(String type, Map<String, dynamic> data) async {
    await analyzeActivity(type, data);
  }

  // Generate progress report for progress tracking screen
  Map<String, dynamic> generateProgressReport() {
    return {
      'totalSessions': _activityMetrics['sessions'] ?? 0,
      'empathyScore': _activityMetrics['empathy_score'] ?? 0.0,
      'listeningScore': _activityMetrics['listening_score'] ?? 0.0,
      'eqScore': _activityMetrics['eq_score'] ?? 0.0,
      'insights': _progressInsights,
      'recentActivities': _recentActivities,
      'lastUpdated': _lastAnalysisTime,
    };
  }
}
