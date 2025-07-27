import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/scenario.dart';

class ScenarioQuizScreen extends StatefulWidget {
  final List<Scenario> scenarios;
  final String category;

  const ScenarioQuizScreen({
    Key? key,
    required this.scenarios,
    required this.category,
  }) : super(key: key);

  @override
  State<ScenarioQuizScreen> createState() => _ScenarioQuizScreenState();
}

class _ScenarioQuizScreenState extends State<ScenarioQuizScreen> {
  int _currentScenarioIndex = 0;
  ScenarioOption? _selectedOption;
  bool _showResult = false;
  int _totalScore = 0;
  int _correctAnswers = 0;
  List<ScenarioOption> _userAnswers = [];

  Scenario get _currentScenario => widget.scenarios[_currentScenarioIndex];
  bool get _isLastScenario =>
      _currentScenarioIndex == widget.scenarios.length - 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.category} Quiz'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '${_currentScenarioIndex + 1}/${widget.scenarios.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentScenarioIndex + 1) / widget.scenarios.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),

              // Score Display
              Container(
                padding: const EdgeInsets.all(16),
                color: primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreItem('Score', '$_totalScore', Icons.stars),
                    _buildScoreItem(
                        'Correct',
                        '$_correctAnswers/${_userAnswers.length}',
                        Icons.check_circle),
                    _buildScoreItem('Difficulty',
                        '${_currentScenario.difficulty}/3', Icons.trending_up),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scenario Card
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category and Title
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _currentScenario.category,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                _currentScenario.title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                _currentScenario.situation,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options or Result
                      if (!_showResult) ...[
                        const Text(
                          'What would you do?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._currentScenario.options
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final option = entry.value;
                          final isSelected = _selectedOption == option;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : null,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedOption = option;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? primaryColor
                                            : Colors.grey.shade300,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(
                                              65 + index), // A, B, C
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        option.text,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],

                      // Result Display
                      if (_showResult) ...[
                        Card(
                          color: _selectedOption!.isCorrect
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _selectedOption!.isCorrect
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: _selectedOption!.isCorrect
                                          ? Colors.green
                                          : Colors.red,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedOption!.isCorrect
                                          ? 'Correct!'
                                          : 'Not the best choice',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '+${_selectedOption!.points} points',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Response: ${_selectedOption!.response}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Why: ${_selectedOption!.explanation}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 12),
                                const Divider(),
                                Text(
                                  'Lesson: ${_currentScenario.lessonLearned}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _getButtonAction(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  VoidCallback? _getButtonAction() {
    if (!_showResult) {
      return _selectedOption != null ? _submitAnswer : null;
    } else {
      return _isLastScenario ? _showFinalResults : _nextScenario;
    }
  }

  String _getButtonText() {
    if (!_showResult) {
      return 'Submit Answer';
    } else {
      return _isLastScenario ? 'View Final Results' : 'Next Scenario';
    }
  }

  void _submitAnswer() {
    setState(() {
      _showResult = true;
      _userAnswers.add(_selectedOption!);
      _totalScore += _selectedOption!.points;
      if (_selectedOption!.isCorrect) {
        _correctAnswers++;
      }
    });
  }

  void _nextScenario() {
    setState(() {
      _currentScenarioIndex++;
      _selectedOption = null;
      _showResult = false;
    });
  }

  void _showFinalResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildResultsDialog(),
    );
  }

  Widget _buildResultsDialog() {
    final percentage = (_correctAnswers / widget.scenarios.length) * 100;
    final grade = _getGrade(percentage);

    return AlertDialog(
      title: const Text('Quiz Complete!'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getGradeIcon(grade),
            size: 64,
            color: _getGradeColor(grade),
          ),
          const SizedBox(height: 16),
          Text(
            'Grade: $grade',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('${percentage.toStringAsFixed(1)}%'),
          const SizedBox(height: 16),
          Text('Correct: $_correctAnswers/${widget.scenarios.length}'),
          Text('Total Score: $_totalScore points'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            Navigator.of(context).pop(); // Go back to scenarios
          },
          child: const Text('Back to Scenarios'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            _restartQuiz();
          },
          child: const Text('Try Again'),
        ),
      ],
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentScenarioIndex = 0;
      _selectedOption = null;
      _showResult = false;
      _totalScore = 0;
      _correctAnswers = 0;
      _userAnswers.clear();
    });
  }

  String _getGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    return 'D';
  }

  IconData _getGradeIcon(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Icons.emoji_events;
      case 'B':
        return Icons.thumb_up;
      case 'C':
        return Icons.sentiment_neutral;
      default:
        return Icons.sentiment_dissatisfied;
    }
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
