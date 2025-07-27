import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/empathy_profile.dart';
import '../../models/empathy_response.dart';

class EmpathyAssessmentScreen extends StatefulWidget {
  final Function(EmpathyProfile) onAssessmentComplete;

  const EmpathyAssessmentScreen({
    Key? key,
    required this.onAssessmentComplete,
  }) : super(key: key);

  @override
  State<EmpathyAssessmentScreen> createState() =>
      _EmpathyAssessmentScreenState();
}

class _EmpathyAssessmentScreenState extends State<EmpathyAssessmentScreen> {
  int _currentQuestionIndex = 0;
  List<EmpathyResponse> _responses = [];

  final List<EmpathyQuestion> _questions = [
    EmpathyQuestion(
      id: '1',
      question:
          'When someone is telling you about their problems, what do you usually do?',
      category: 'Active Listening',
      options: [
        EmpathyOption('Listen carefully and ask follow-up questions', 90),
        EmpathyOption('Offer immediate solutions', 60),
        EmpathyOption('Share a similar experience you had', 40),
        EmpathyOption('Change the subject if it gets too heavy', 20),
      ],
    ),
    EmpathyQuestion(
      id: '2',
      question:
          'How well can you tell when someone is upset, even if they don\'t say so?',
      category: 'Non-Verbal Awareness',
      options: [
        EmpathyOption(
            'Very well - I notice subtle changes in body language', 90),
        EmpathyOption('Pretty well - I pick up on obvious signs', 70),
        EmpathyOption('Sometimes - depends on how well I know the person', 50),
        EmpathyOption('Not very well - I usually need them to tell me', 30),
      ],
    ),
    EmpathyQuestion(
      id: '3',
      question: 'During an argument, what\'s your typical approach?',
      category: 'Conflict Resolution',
      options: [
        EmpathyOption('Try to understand their perspective first', 90),
        EmpathyOption('Focus on finding a compromise', 70),
        EmpathyOption('Defend my position strongly', 40),
        EmpathyOption('Avoid the conflict altogether', 30),
      ],
    ),
    EmpathyQuestion(
      id: '4',
      question: 'When someone is emotional, you:',
      category: 'Emotional Intelligence',
      options: [
        EmpathyOption('Stay calm and help them process their feelings', 90),
        EmpathyOption('Try to cheer them up with humor or distractions', 60),
        EmpathyOption('Feel uncomfortable and try to leave', 30),
        EmpathyOption('Get emotional yourself', 40),
      ],
    ),
    EmpathyQuestion(
      id: '5',
      question:
          'How do you respond when someone says "I\'m fine" but seems upset?',
      category: 'Non-Verbal Awareness',
      options: [
        EmpathyOption(
            'Gently acknowledge what I observe and offer support', 90),
        EmpathyOption('Respect their words and give them space', 70),
        EmpathyOption('Keep asking until they tell me what\'s wrong', 40),
        EmpathyOption('Take them at their word and move on', 30),
      ],
    ),
  ];

  EmpathyQuestion get _currentQuestion => _questions[_currentQuestionIndex];
  bool get _isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Empathy Assessment'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    '${_currentQuestionIndex + 1}/${_questions.length}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Card
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _currentQuestion.category,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _currentQuestion.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Options
                      ..._currentQuestion.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => _selectOption(option),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryColor.withOpacity(0.1),
                                      border: Border.all(color: primaryColor),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(
                                            65 + index), // A, B, C, D
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      option.text,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectOption(EmpathyOption option) {
    final response = EmpathyResponse(
      questionId: _currentQuestion.id,
      question: _currentQuestion.question,
      userAnswer: option.text,
      score: option.score.toDouble(),
      category: _currentQuestion.category,
      feedback: _getFeedback(option.score),
    );

    _responses.add(response);

    if (_isLastQuestion) {
      _completeAssessment();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  String _getFeedback(int score) {
    if (score >= 80) return 'Excellent choice! This shows high empathy.';
    if (score >= 60)
      return 'Good response, but there might be better approaches.';
    return 'This response might not be the most empathetic approach.';
  }

  void _completeAssessment() {
    final profile = EmpathyProfile.fromResponses(_responses);
    widget.onAssessmentComplete(profile);
  }
}

class EmpathyQuestion {
  final String id;
  final String question;
  final String category;
  final List<EmpathyOption> options;

  EmpathyQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.options,
  });
}

class EmpathyOption {
  final String text;
  final int score;

  EmpathyOption(this.text, this.score);
}
