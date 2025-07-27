import 'package:flutter/material.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  void _navigateToGame(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 1,
          mainAxisSpacing: 16,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Stress Relief Puzzle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  _navigateToGame(context, '/features/stress_relief_puzzle'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.self_improvement),
              label: const Text('Mindful Breathing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  _navigateToGame(context, '/features/mindful_breathing'),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Fruit Cutting Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  _navigateToGame(context, '/features/fruit_ninja_flame_game'),
            ),
          ],
        ),
      ),
    );
  }
}
