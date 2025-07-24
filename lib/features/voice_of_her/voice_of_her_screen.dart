import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'voice_of_her_provider.dart';
import 'voice_story_tile.dart';
import 'voice_story_model.dart';

class VoiceOfHerScreen extends StatefulWidget {
  const VoiceOfHerScreen({super.key});

  @override
  State<VoiceOfHerScreen> createState() => _VoiceOfHerScreenState();
}

class _VoiceOfHerScreenState extends State<VoiceOfHerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoiceOfHerProvider>(context, listen: false).loadStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VoiceOfHerProvider>(context);

    final isLoading = provider.isLoading;
    final error = provider.errorMessage;
    final todayStory = provider.todayStory;
    final allStories = provider.stories;

    // Filter out today's story from the rest
    final pastStories = todayStory == null
        ? allStories
        : allStories.where((s) => s.id != todayStory.id).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Voice of Her')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error))
              : (allStories.isEmpty && todayStory == null)
                  ? const Center(child: Text('No stories available.'))
                  : RefreshIndicator(
                      onRefresh: () => provider.refreshStories(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (todayStory != null) ...[
                            const Text(
                              '✨ Today’s Voice',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            VoiceStoryTile(story: todayStory),
                            const SizedBox(height: 24),
                          ],
                          if (pastStories.isNotEmpty) ...[
                            const Text(
                              '📚 Past Stories',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...pastStories
                                .map((story) => VoiceStoryTile(story: story))
                                .toList(),
                          ]
                        ],
                      ),
                    ),
    );
  }
}
