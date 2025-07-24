import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _navigateToFeature(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome, ${user?.email ?? "User"}!',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat),
                    label: const Text('Ask a Woman Chatbot'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _navigateToFeature(
                        context, '/features/ask_a_woman_chatbot'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('Empathy Neural Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _navigateToFeature(
                        context, '/features/empathy_neural_profile'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.book),
                    label: const Text('Scenario Engine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _navigateToFeature(
                        context, '/features/scenario_engine'),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.mic),
                    label: const Text('Voice of Her'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () =>
                        _navigateToFeature(context, '/features/voice_of_her'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
