import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'empathy_neural_profile_provider.dart';
import 'empathy_profile_results_screen.dart';
import 'empathy_assessment_screen.dart';

class EmpathyNeuralProfileScreen extends StatefulWidget {
  const EmpathyNeuralProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmpathyNeuralProfileScreen> createState() =>
      _EmpathyNeuralProfileScreenState();
}

class _EmpathyNeuralProfileScreenState extends State<EmpathyNeuralProfileScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _analysisHistory = [];
  String? _sentiment;
  double? _confidenceScore;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    final provider =
        Provider.of<EmpathyNeuralProfileProvider>(context, listen: false);
    provider.loadAnalyticsData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, EmpathyNeuralProfileProvider>(
      builder: (context, themeProvider, profileProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Empathy Analytics Dashboard'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => profileProvider.refreshAnalytics(),
                tooltip: 'Refresh Analytics',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Header
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.analytics, size: 64, color: primaryColor),
                        const SizedBox(height: 16),
                        Text(
                          'Activity Analytics Engine',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'AI-powered analysis of your empathy activities and progress tracking.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Real-time Analysis Status
                _buildAnalysisStatus(profileProvider, primaryColor),

                const SizedBox(height: 20),

                // Activity Metrics
                _buildActivityMetrics(profileProvider, primaryColor),

                const SizedBox(height: 20),

                // Progress Insights
                _buildProgressInsights(profileProvider, primaryColor),

                const SizedBox(height: 20),

                // Recent Activities
                _buildRecentActivities(profileProvider, primaryColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnalysisStatus(
      EmpathyNeuralProfileProvider provider, Color primaryColor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'AI Analysis Engine',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.isAnalyzing ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  provider.isAnalyzing
                      ? 'Analyzing Activities...'
                      : 'Ready for Analysis',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            if (provider.isAnalyzing) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Last Updated: ${_formatDateTime(provider.lastAnalysisTime)}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityMetrics(
      EmpathyNeuralProfileProvider provider, Color primaryColor) {
    final metrics = provider.activityMetrics;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem('Sessions', '${metrics['sessions'] ?? 0}',
                    Icons.chat, Colors.blue),
                _buildMetricItem('Scenarios', '${metrics['scenarios'] ?? 0}',
                    Icons.quiz, Colors.green),
                _buildMetricItem('Games', '${metrics['games'] ?? 0}',
                    Icons.games, Colors.orange),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar('Empathy Score',
                (metrics['empathy_score'] ?? 0.0) / 100, primaryColor),
            _buildProgressBar('Listening Skills',
                (metrics['listening_score'] ?? 0.0) / 100, Colors.blue),
            _buildProgressBar('Emotional Intelligence',
                (metrics['eq_score'] ?? 0.0) / 100, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildProgressBar(String label, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInsights(
      EmpathyNeuralProfileProvider provider, Color primaryColor) {
    final insights = provider.progressInsights;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Progress Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...insights
                .map((insight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                insight,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(
      EmpathyNeuralProfileProvider provider, Color primaryColor) {
    final activities = provider.recentActivities;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...activities
                .map((activity) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColor.withOpacity(0.1),
                          child: Icon(_getActivityIcon(activity['type']),
                              color: primaryColor, size: 20),
                        ),
                        title: Text(activity['description']),
                        subtitle: Text(
                          '${activity['type']} • ${_formatDateTime(activity['timestamp'])}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getScoreColor(activity['score'])
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${activity['score']}%',
                            style: TextStyle(
                              color: _getScoreColor(activity['score']),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat;
      case 'scenario':
        return Icons.quiz;
      case 'game':
        return Icons.games;
      case 'assessment':
        return Icons.psychology;
      default:
        return Icons.timeline;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildMainContent(BuildContext context) {
    final provider = Provider.of<EmpathyNeuralProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Empathy Neural Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {
              setState(() {
                _analysisHistory.clear();
                _textController.clear();
                _sentiment = null;
                _confidenceScore = null;
              });
              _fadeController.reset();
            },
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.psychology,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Text Analysis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Enter text to analyze sentiment',
                          hintText: 'Type your message here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          suffixIcon: _textController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _textController.clear();
                                    _analyzeSentiment('', provider);
                                  },
                                )
                              : null,
                        ),
                        onChanged: (text) {
                          _analyzeSentiment(text, provider);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSentimentResult(),
              const SizedBox(height: 20),
              _buildAnalysisHistory(),
              const SizedBox(height: 20),
              if (provider.profileData != null) ...[
                _buildCurrentProfile(
                    provider.profileData, Theme.of(context).primaryColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateToAssessment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Retake Assessment',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _navigateToEmpathyAssessment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Empathy Test',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _buildAssessmentIntro(Theme.of(context).primaryColor),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToAssessment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Empathy Assessment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToEmpathyAssessment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Take Empathy Test',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEmpathyAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmpathyAssessmentScreen(
          onAssessmentComplete: (profile) {
            final provider = Provider.of<EmpathyNeuralProfileProvider>(context,
                listen: false);
            provider.loadAnalyticsData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmpathyProfileResultsScreen(profile: profile),
              ),
            );
          },
        ),
      ),
    );
  }

  void _analyzeSentiment(String text, EmpathyNeuralProfileProvider provider) {
    // Implement sentiment analysis logic here
  }

  Widget _buildSentimentResult() {
    // Implement sentiment result widget
    return Container();
  }

  Widget _buildAnalysisHistory() {
    // Implement analysis history widget
    return Container();
  }

  Widget _buildCurrentProfile(dynamic profile, Color primaryColor) {
    // Implement current profile widget
    return Container();
  }

  Widget _buildAssessmentIntro(Color primaryColor) {
    // Implement assessment intro widget
    return Container();
  }

  void _navigateToAssessment() {
    // Implement navigation to assessment
  }
}
