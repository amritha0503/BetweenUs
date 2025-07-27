import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/gender_aware_card.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Stress Relief Games'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor.withOpacity(0.1), Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose a game to relax and unwind',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        GenderAwareCard(
                          title: 'Bubble Pop',
                          subtitle: 'Pop bubbles to release stress',
                          icon: Icons.blur_circular_outlined,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/bubble_pop_game'),
                        ),
                        GenderAwareCard(
                          title: 'Mindful Breathing',
                          subtitle: 'Calm your mind with breathing exercises',
                          icon: Icons.air,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/mindful_breathing'),
                        ),
                        GenderAwareCard(
                          title: 'Mood Songs',
                          subtitle: 'Listen to mood-based music',
                          icon: Icons.music_note,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/mood_song_suggestion'),
                        ),
                        GenderAwareCard(
                          title: 'Memory Game',
                          subtitle: 'Exercise your brain',
                          icon: Icons.psychology,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/memory_game'),
                        ),
                        GenderAwareCard(
                          title: 'Puzzle Game',
                          subtitle: 'Solve puzzles to relax',
                          icon: Icons.extension,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/puzzle_game'),
                        ),
                        GenderAwareCard(
                          title: 'Color Therapy',
                          subtitle: 'Relax with colors',
                          icon: Icons.palette,
                          onTap: () => Navigator.pushNamed(
                              context, '/features/color_therapy'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
