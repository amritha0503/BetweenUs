import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/empathy_profile.dart';

class EmpathyProfileResultsScreen extends StatelessWidget {
  final EmpathyProfile profile;

  const EmpathyProfileResultsScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Empathy Profile'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Overall Score
                Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withOpacity(0.1),
                            border: Border.all(color: primaryColor, width: 4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${profile.empathyScore.toInt()}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const Text('Score'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile.overallGrade,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Category Breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Breakdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCategoryBar('Emotional Intelligence',
                            profile.emotionalIntelligence, Colors.purple),
                        _buildCategoryBar('Active Listening',
                            profile.activeListening, Colors.blue),
                        _buildCategoryBar('Non-Verbal Awareness',
                            profile.nonVerbalAwareness, Colors.green),
                        _buildCategoryBar('Conflict Resolution',
                            profile.conflictResolution, Colors.orange),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Strengths & Improvements
                if (profile.strengths.isNotEmpty ||
                    profile.improvementAreas.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (profile.strengths.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.green),
                                const SizedBox(width: 8),
                                const Text(
                                  'Your Strengths',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...profile.strengths
                                .map(
                                  (strength) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 32, bottom: 4),
                                    child: Text('• $strength'),
                                  ),
                                )
                                .toList(),
                          ],
                          if (profile.improvementAreas.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.trending_up,
                                    color: Colors.orange),
                                const SizedBox(width: 8),
                                const Text(
                                  'Areas for Growth',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...profile.improvementAreas
                                .map(
                                  (area) => Padding(
                                    padding: const EdgeInsets.only(
                                        left: 32, bottom: 4),
                                    child: Text('• $area'),
                                  ),
                                )
                                .toList(),
                          ],
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .popUntil((route) => route.isFirst),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back to Home',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Retake Assessment',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBar(String category, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category),
              Text('${score.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }
}
