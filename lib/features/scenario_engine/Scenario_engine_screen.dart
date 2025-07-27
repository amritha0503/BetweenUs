import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/scenario.dart';
import 'scenario_quiz_screen.dart';

class ScenarioEngineScreen extends StatefulWidget {
  const ScenarioEngineScreen({Key? key}) : super(key: key);

  @override
  State<ScenarioEngineScreen> createState() => _ScenarioEngineScreenState();
}

class _ScenarioEngineScreenState extends State<ScenarioEngineScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'First Date',
    'Relationship Conflicts',
    'Communication',
    'Understanding Emotions',
    'Family Situations'
  ];

  // Demo scenarios - hardcoded for now
  final List<Scenario> _demoScenarios = [
    Scenario(
      id: '1',
      title: 'She seems upset after dinner',
      description:
          'Your partner has been quiet since you got home from dinner.',
      situation:
          'Your partner has been unusually quiet since leaving the restaurant. When you ask "What\'s wrong?", she says "Nothing, I\'m fine."',
      category: 'Communication',
      difficulty: 2,
      lessonLearned:
          'Sometimes "I\'m fine" doesn\'t mean everything is okay. Learning to read non-verbal cues is important.',
      options: [
        ScenarioOption(
          id: '1a',
          text: 'Push harder: "Come on, what\'s really wrong?"',
          response: 'She gets more frustrated and walks away.',
          isCorrect: false,
          explanation:
              'Pushing when someone says they\'re fine often makes them more defensive.',
          points: 0,
        ),
        ScenarioOption(
          id: '1b',
          text: 'Give space: "I\'m here when you\'re ready to talk"',
          response: 'She appreciates the space and opens up later.',
          isCorrect: true,
          explanation:
              'Giving space while showing availability often works better.',
          points: 15,
        ),
        ScenarioOption(
          id: '1c',
          text: 'Ignore it and watch TV',
          response: 'The tension grows and she feels ignored.',
          isCorrect: false,
          explanation:
              'Ignoring clear signs of distress can damage relationships.',
          points: 0,
        ),
      ],
    ),
    Scenario(
      id: '2',
      title: 'First date conversation dies',
      description: 'Awkward silence during your first coffee date.',
      situation:
          'You\'re halfway through your first date at a coffee shop. There\'s an uncomfortable silence and she\'s looking around nervously.',
      category: 'First Date',
      difficulty: 1,
      lessonLearned:
          'Good questions and active listening can revive conversations and show genuine interest.',
      options: [
        ScenarioOption(
          id: '2a',
          text: 'Ask "So... do you like movies?"',
          response: 'She gives a short "yes" and the awkwardness continues.',
          isCorrect: false,
          explanation: 'Closed-ended questions often lead to short responses.',
          points: 5,
        ),
        ScenarioOption(
          id: '2b',
          text: 'Ask "What\'s something you\'re passionate about?"',
          response: 'Her eyes light up as she talks about her hobbies.',
          isCorrect: true,
          explanation:
              'Open-ended questions about passions help people share what they love.',
          points: 20,
        ),
        ScenarioOption(
          id: '2c',
          text: 'Check your phone to fill the silence',
          response: 'She feels ignored and the date energy drops.',
          isCorrect: false,
          explanation: 'Phone checking signals disinterest and disrespect.',
          points: 0,
        ),
      ],
    ),
    Scenario(
      id: '3',
      title: 'She cancels plans last minute',
      description: 'Your partner cancels your dinner plans an hour before.',
      situation:
          'You\'ve been looking forward to dinner all week. An hour before, she texts: "Sorry, something came up with work. Can we reschedule?"',
      category: 'Relationship Conflicts',
      difficulty: 2,
      lessonLearned:
          'Understanding and flexibility are key when plans change unexpectedly.',
      options: [
        ScenarioOption(
          id: '3a',
          text: 'Reply: "This always happens! You never prioritize us."',
          response: 'She becomes defensive and a fight ensues.',
          isCorrect: false,
          explanation: 'Accusatory language escalates conflicts unnecessarily.',
          points: 0,
        ),
        ScenarioOption(
          id: '3b',
          text:
              'Reply: "No problem! Work is important. When works better for you?"',
          response: 'She appreciates your understanding and suggests tomorrow.',
          isCorrect: true,
          explanation:
              'Showing understanding and flexibility strengthens relationships.',
          points: 15,
        ),
      ],
    ),
    // Add as many as you want!
  ];

  List<Scenario> get _filteredScenarios {
    if (_selectedCategory == 'All') {
      return _demoScenarios;
    }
    return _demoScenarios
        .where((scenario) => scenario.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Scenario Engine'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Category Selection
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: primaryColor.withOpacity(0.2),
                        checkmarkColor: primaryColor,
                      ),
                    );
                  },
                ),
              ),

              // Quiz Info Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 64,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Scenario Quiz',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedCategory == 'All'
                                    ? 'Practice with all relationship scenarios'
                                    : 'Practice $_selectedCategory scenarios',
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              _buildQuizStats(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Start Quiz Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _startScenarioQuiz(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Start Scenario Quiz',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Practice Individual Scenarios
                      const Text(
                        'Or practice individual scenarios:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 16),

                      // Individual Scenarios
                      ..._filteredScenarios.map((scenario) {
                        return _buildScenarioCard(scenario, primaryColor);
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

  Widget _buildQuizStats() {
    final scenarios = _filteredScenarios;
    final totalPoints = scenarios.fold(
        0,
        (sum, scenario) =>
            sum + scenario.options.where((o) => o.isCorrect).first.points);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('${scenarios.length}', 'Scenarios', Icons.quiz),
        _buildStatItem('$totalPoints', 'Max Points', Icons.stars),
        _buildStatItem('${_getAverageDifficulty().toStringAsFixed(1)}',
            'Avg Difficulty', Icons.trending_up),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  double _getAverageDifficulty() {
    final scenarios = _filteredScenarios;
    if (scenarios.isEmpty) return 0.0;
    return scenarios.fold(0, (sum, s) => sum + s.difficulty) / scenarios.length;
  }

  void _startScenarioQuiz() {
    final scenarios = _filteredScenarios;
    if (scenarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No scenarios available in this category')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioQuizScreen(
          scenarios: scenarios,
          category: _selectedCategory,
        ),
      ),
    );
  }

  Widget _buildScenarioCard(Scenario scenario, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category and difficulty
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    scenario.category,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(3, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < scenario.difficulty
                          ? Colors.orange
                          : Colors.grey.shade300,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              scenario.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              scenario.description,
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                Icon(Icons.quiz_outlined,
                    color: Colors.grey.shade600, size: 16),
                const SizedBox(width: 4),
                Text('${scenario.options.length} options'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _navigateToScenario(scenario),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Start Scenario'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No scenarios in this category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _navigateToScenario(Scenario scenario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioDetailScreen(scenario: scenario),
      ),
    );
  }
}

// Simple scenario detail screen
class ScenarioDetailScreen extends StatefulWidget {
  final Scenario scenario;

  const ScenarioDetailScreen({Key? key, required this.scenario})
      : super(key: key);

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  ScenarioOption? _selectedOption;
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.scenario.title),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Situation
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Situation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.scenario.situation),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Options or Result
                if (!_showResult) ...[
                  Text(
                    'What would you do?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.scenario.options.map((option) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: RadioListTile<ScenarioOption>(
                        value: option,
                        groupValue: _selectedOption,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                          });
                        },
                        title: Text(option.text),
                        activeColor: primaryColor,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedOption != null ? _submitAnswer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Submit Answer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ] else ...[
                  // Show result
                  Card(
                    color: _selectedOption!.isCorrect
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedOption!.isCorrect
                                ? 'Correct!'
                                : 'Learning Opportunity',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Response: ${_selectedOption!.response}'),
                          const SizedBox(height: 8),
                          Text('Explanation: ${_selectedOption!.explanation}'),
                          const SizedBox(height: 8),
                          Text('Points: ${_selectedOption!.points}'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Back to Scenarios',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitAnswer() {
    setState(() {
      _showResult = true;
    });
  }
}
