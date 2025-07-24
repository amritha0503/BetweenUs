import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'scenario_engine_provider.dart';
import 'scenario_choice_title.dart';
import '../../features/tone_optimizer/tone_optimizer_service.dart';
import '../../features/tone_optimizer/tone_optimizer_utils.dart';
import '../../features/empathy_dashboard/dashboard_firestore_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScenarioEngineScreen extends StatefulWidget {
  const ScenarioEngineScreen({super.key});

  @override
  State<ScenarioEngineScreen> createState() => _ScenarioEngineScreenState();
}

class _ScenarioEngineScreenState extends State<ScenarioEngineScreen> {
  String? _tone;
  bool _isLoadingTone = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ScenarioEngineProvider>(context, listen: false)
          .loadScenarios();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ScenarioEngineProvider>(context);
    if (provider.scenarios.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final scenario = provider.scenarios[provider.currentScenario];

    return Scaffold(
      appBar: AppBar(title: const Text('She Says, She Means')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario.prompt,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...scenario.choices.map(
              (choice) => ScenarioChoiceTile(
                choice: choice,
                onTap: () async {
                  // 🔁 If already selected, don't allow reselect
                  if (provider.selectedFeedback != null) return;

                  setState(() => _isLoadingTone = true);

                  try {
                    final apiKey = dotenv.env['OPENAI_API_KEY']!;
                    final toneService = ToneOptimizerService(apiKey);
                    final tone = await toneService.analyzeTone(choice.text);
                    final dashboardService = DashboardFirestoreService();

                    // Replace this with real Firebase user ID
                    const userId = "demo_user";

                    await dashboardService.updateToneAwareness(
                      userId: userId,
                      tone: tone,
                    );

                    final feedback = ToneUtils.getToneFeedback(tone);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "🧠 Tone: ${feedback.emoji} ${feedback.label}"),
                        backgroundColor: feedback.color,
                      ),
                    );

                    setState(() {
                      _tone = tone;
                    });

                    provider.selectChoice(choice);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to analyze tone")),
                    );
                  } finally {
                    setState(() => _isLoadingTone = false);
                  }
                },
                selected: provider.selectedFeedback == choice.feedback,
              ),
            ),
            if (_isLoadingTone) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],
            if (provider.selectedFeedback != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  provider.selectedFeedback!,
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: provider.selectedFeedback != null
                  ? provider.nextScenario
                  : null,
              child: const Text('Next Scenario'),
            ),
          ],
        ),
      ),
    );
  }
}
