import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const EmpathyKeyboardApp());
}

class EmpathyKeyboardApp extends StatelessWidget {
  const EmpathyKeyboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => KeyboardProvider(),
      child: MaterialApp(
        title: 'Empathy Keyboard',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const KeyboardScreen(),
      ),
    );
  }
}

class KeyboardProvider extends ChangeNotifier {
  String _currentText = '';
  List<EmotionalSuggestion> _suggestions = [];
  ToneAnalysis? _toneAnalysis;
  bool _isAnalyzing = false;

  String get currentText => _currentText;
  List<EmotionalSuggestion> get suggestions => _suggestions;
  ToneAnalysis? get toneAnalysis => _toneAnalysis;
  bool get isAnalyzing => _isAnalyzing;

  Timer? _analysisTimer;

  void updateText(String text) {
    _currentText = text;
    notifyListeners();

    // Debounce analysis
    _analysisTimer?.cancel();
    _analysisTimer = Timer(const Duration(milliseconds: 500), () {
      _analyzeText(text);
    });
  }

  void _analyzeText(String text) async {
    if (text.trim().isEmpty) {
      _suggestions.clear();
      _toneAnalysis = null;
      notifyListeners();
      return;
    }

    _isAnalyzing = true;
    notifyListeners();

    try {
      // Simulate AI analysis (replace with actual AI service)
      await Future.delayed(const Duration(milliseconds: 800));

      _toneAnalysis = _performToneAnalysis(text);
      if (_toneAnalysis != null) {
        _suggestions = _generateSuggestions(text, _toneAnalysis!);
      } else {
        _suggestions.clear();
      }
    } catch (e) {
      print('Analysis error: $e');
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }

  ToneAnalysis _performToneAnalysis(String text) {
    // Simple rule-based analysis (replace with ML model)
    double aggression = _calculateAggression(text);
    double empathy = _calculateEmpathy(text);
    double clarity = _calculateClarity(text);

    return ToneAnalysis(
      aggression: aggression,
      empathy: empathy,
      clarity: clarity,
      overallTone: _getOverallTone(aggression, empathy, clarity),
    );
  }

  double _calculateAggression(String text) {
    final aggressiveWords = [
      'stupid',
      'idiot',
      'hate',
      'angry',
      'furious',
      'damn',
      'hell',
      'shut up',
      'whatever',
      'don\'t care',
      'ridiculous',
      'nonsense',
    ];

    final lowerText = text.toLowerCase();
    int aggressiveCount = 0;

    for (String word in aggressiveWords) {
      if (lowerText.contains(word)) aggressiveCount++;
    }

    // Check for caps lock
    if (text.toUpperCase() == text && text.length > 5) {
      aggressiveCount += 2;
    }

    // Check for excessive punctuation
    if (text.contains('!!!') || text.contains('???')) {
      aggressiveCount++;
    }

    return (aggressiveCount /
            ((text.split(' ').length / 10).clamp(1, double.infinity)))
        .clamp(0.0, 1.0);
  }

  double _calculateEmpathy(String text) {
    final empathyWords = [
      'understand',
      'feel',
      'sorry',
      'appreciate',
      'thank',
      'please',
      'kindly',
      'hope',
      'care',
      'support',
      'help',
    ];

    final lowerText = text.toLowerCase();
    int empathyCount = 0;

    for (String word in empathyWords) {
      if (lowerText.contains(word)) empathyCount++;
    }

    return (empathyCount /
            ((text.split(' ').length / 10).clamp(1, double.infinity)))
        .clamp(0.0, 1.0);
  }

  double _calculateClarity(String text) {
    // Simple clarity check based on sentence structure
    final sentences = text.split('.');
    if (sentences.isEmpty || sentences.first.trim().isEmpty) return 0.0;
    double avgLength =
        sentences.fold(0, (sum, s) => sum + s.length) / sentences.length;

    // Ideal sentence length is around 100 chars (approx 15-20 words)
    return (1.0 - (avgLength - 100).abs() / 100).clamp(0.0, 1.0);
  }

  String _getOverallTone(double aggression, double empathy, double clarity) {
    if (aggression > 0.7) return 'Aggressive';
    if (empathy > 0.6) return 'Empathetic';
    if (clarity < 0.3) return 'Unclear';
    return 'Neutral';
  }

  List<EmotionalSuggestion> _generateSuggestions(
    String text,
    ToneAnalysis analysis,
  ) {
    List<EmotionalSuggestion> suggestions = [];

    if (analysis.aggression > 0.5) {
      suggestions.add(
        EmotionalSuggestion(
          type: SuggestionType.warning,
          message: 'This message might come across as aggressive',
          suggestion: _softenText(text),
          icon: Icons.warning_amber,
        ),
      );
    }

    if (analysis.empathy < 0.3 && text.length > 20) {
      suggestions.add(
        EmotionalSuggestion(
          type: SuggestionType.empathy,
          message: 'Consider adding more empathy to your message',
          suggestion: _addEmpathy(text),
          icon: Icons.favorite,
        ),
      );
    }

    if (analysis.clarity < 0.4) {
      suggestions.add(
        EmotionalSuggestion(
          type: SuggestionType.clarity,
          message: 'This message could be clearer',
          suggestion: _improveClarity(text),
          icon: Icons.lightbulb,
        ),
      );
    }

    return suggestions;
  }

  String _softenText(String text) {
    String softened = text;

    // Replace aggressive words with softer alternatives
    final replacements = {
      'stupid': 'misguided',
      'idiot': 'person',
      'hate': 'dislike',
      'shut up': 'please stop',
      'whatever': 'I understand',
      'ridiculous': 'unusual',
      'nonsense': 'unclear to me',
    };

    replacements.forEach((harsh, soft) {
      softened = softened.replaceAll(RegExp(harsh, caseSensitive: false), soft);
    });

    // Convert caps to normal case
    if (softened.toUpperCase() == softened && softened.length > 1) {
      softened = softened.toLowerCase();
      softened = softened[0].toUpperCase() + softened.substring(1);
    }

    return softened;
  }

  String _addEmpathy(String text) {
    final empathyPhrases = [
      'I understand that ',
      'I can see why ',
      'I appreciate that ',
      'Thank you for ',
    ];
    final random = Random();
    final randomPhrase = empathyPhrases[random.nextInt(empathyPhrases.length)];
    return randomPhrase + text.toLowerCase();
  }

  String _improveClarity(String text) {
    // Simple clarity improvement by breaking long sentences
    if (text.length > 100) {
      int midPoint = text.indexOf(' ', text.length ~/ 2);
      if (midPoint != -1) {
        return '${text.substring(0, midPoint)}. ${text.substring(midPoint + 1)}';
      }
    }
    return text;
  }

  void applySuggestion(String suggestion) {
    _currentText = suggestion;
    _suggestions.clear();
    notifyListeners();
  }
}

class ToneAnalysis {
  final double aggression;
  final double empathy;
  final double clarity;
  final String overallTone;

  ToneAnalysis({
    required this.aggression,
    required this.empathy,
    required this.clarity,
    required this.overallTone,
  });
}

class EmotionalSuggestion {
  final SuggestionType type;
  final String message;
  final String suggestion;
  final IconData icon;

  EmotionalSuggestion({
    required this.type,
    required this.message,
    required this.suggestion,
    required this.icon,
  });
}

enum SuggestionType { warning, empathy, clarity }

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({super.key});

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      context.read<KeyboardProvider>().updateText(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Empathy Keyboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Consumer<KeyboardProvider>(
                    builder: (context, provider, child) {
                      if (provider.isAnalyzing) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Input Area
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                hintText: 'Type your message here...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),

                          // Tone Analysis Bar
                          Consumer<KeyboardProvider>(
                            builder: (context, provider, child) {
                              if (provider.toneAnalysis == null) {
                                return const SizedBox();
                              }

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tone Analysis',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildToneBar(
                                      'Aggression',
                                      provider.toneAnalysis!.aggression,
                                      Colors.red,
                                    ),
                                    _buildToneBar(
                                      'Empathy',
                                      provider.toneAnalysis!.empathy,
                                      Colors.green,
                                    ),
                                    _buildToneBar(
                                      'Clarity',
                                      provider.toneAnalysis!.clarity,
                                      Colors.blue,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Overall Tone: ${provider.toneAnalysis!.overallTone}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Suggestions
                    Consumer<KeyboardProvider>(
                      builder: (context, provider, child) {
                        if (provider.suggestions.isEmpty) {
                          return const SizedBox();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggestions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...provider.suggestions.map(
                              (suggestion) =>
                                  _buildSuggestionCard(suggestion, provider),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _copyToClipboard(context);
                        _focusNode.unfocus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Copy Text'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _controller.clear();
                        _focusNode.unfocus();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToneBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(value * 100).toInt()}%',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
    EmotionalSuggestion suggestion,
    KeyboardProvider provider,
  ) {
    Color cardColor;
    switch (suggestion.type) {
      case SuggestionType.warning:
        cardColor = Colors.orange[50]!;
        break;
      case SuggestionType.empathy:
        cardColor = Colors.green[50]!;
        break;
      case SuggestionType.clarity:
        cardColor = Colors.blue[50]!;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(suggestion.icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestion.message,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              suggestion.suggestion,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _controller.text = suggestion.suggestion;
                provider.applySuggestion(suggestion.suggestion);
              },
              child: const Text('Apply Suggestion'),
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
