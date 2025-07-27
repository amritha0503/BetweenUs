import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart' as home;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

// Import feature screens
import 'features/ask_a_woman_chatbot/ask_a_woman_chatbot_screen.dart';
import 'features/empathy_neural_profile/empathy_neural_profile_screen.dart';
import 'features/scenario_engine/Scenario_engine_screen.dart';
import 'features/voice_of_her/voice_of_her_screen.dart';
import 'features/bubble_pop_game.dart';
import 'features/mood_song_suggestion_screen.dart';
import 'features/mindful_breathing.dart';
import 'screens/games_screen.dart';
import 'screens/progress_tracking_screen.dart';
import 'gender_selection_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/profile_screen.dart';

// Import providers
import 'features/ask_a_woman_chatbot/ask_a_woman_chatbot_provider.dart';
import 'features/empathy_neural_profile/empathy_neural_profile_provider.dart';
import 'features/scenario_engine/scenario_engine_provider.dart';
import 'features/voice_of_her/voice_of_her_provider.dart';
import 'providers/theme_provider.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, String>> loadEnvFile(String path) async {
  try {
    final content = await rootBundle.loadString(path);
    final lines = content.split('\n');
    final Map<String, String> env = {};
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final index = line.indexOf('=');
      if (index == -1) continue;
      final key = line.substring(0, index).trim();
      final value = line.substring(index + 1).trim();
      env[key] = value;
    }
    return env;
  } catch (e) {
    print('Warning: Could not load .env file: \$e');
    return <String, String>{};
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final env = await loadEnvFile('.env');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Center(
          child: Text('❌ \${details.exception}', textAlign: TextAlign.center),
        ),
      );
    };

    runApp(MyApp(env: env));
  } catch (e, stack) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text(
              'Initialization error:\n\$e\n\$stack',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final Map<String, String> env;
  const MyApp({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AskAWomanChatbotProvider(
                env['OPENAI_API_KEY_ASK_A_WOMAN_CHATBOT'] ?? '')),
        ChangeNotifierProvider(
            create: (_) => EmpathyNeuralProfileProvider(
                env['OPENAI_API_KEY_EMPATHY_NEURAL_PROFILE'] ?? '')),
        ChangeNotifierProvider(
            create: (_) => ScenarioEngineProvider(
                env['OPENAI_API_KEY_SCENARIO_ENGINE'] ?? '')),
        ChangeNotifierProvider(create: (_) => VoiceOfHerProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Unspoken',
            theme: themeProvider.currentTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const AuthWrapper(),
              '/login': (context) => const Login(),
              '/register': (context) => const Register(),
              '/home': (context) => const home.Home(),
              '/features/ask_a_woman_chatbot': (context) =>
                  AskAWomanChatbotScreen(
                      apiKey: env['OPENAI_API_KEY_ASK_A_WOMAN_CHATBOT'] ?? ''),
              '/features/empathy_neural_profile': (context) =>
                  const EmpathyNeuralProfileScreen(),
              '/features/scenario_engine': (context) =>
                  const ScenarioEngineScreen(),
              '/features/voice_of_her': (context) => const VoiceOfHerScreen(),
              '/features/bubble_pop_game': (context) => const BubblePopGame(),
              '/features/mood_song_suggestion': (context) =>
                  const MoodSongSuggestionScreen(),
              '/games': (context) => const GamesScreen(),
              '/features/mindful_breathing': (context) =>
                  const MindfulBreathing(),
              '/progress': (context) => const ProgressTrackingScreen(),
              '/recent_chats': (context) => const PlaceholderScreen(),
              '/recent': (context) => const PlaceholderScreen(),
              '/saved': (context) => const PlaceholderScreen(),
              '/favorites': (context) => const PlaceholderScreen(),
              '/chats': (context) => const PlaceholderScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/notifications': (context) => const PlaceholderScreen(),
              '/settings': (context) => const PlaceholderScreen(),
              '/help': (context) => const PlaceholderScreen(),
              '/all_features': (context) => const PlaceholderScreen(),
              '/learning': (context) => const PlaceholderScreen(),
              '/community': (context) => const CommunityForumScreen(),
              '/create_post': (context) => const CreatePostScreen(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<bool> _hasSelectedGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_gender');
  }

  Future<void> _initializeTheme(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final gender = prefs.getString('user_gender');
    if (gender != null) {
      Provider.of<ThemeProvider>(context, listen: false).setUserGender(gender);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return FutureBuilder<bool>(
            future: _hasSelectedGender(),
            builder: (context, genderSnapshot) {
              if (genderSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (genderSnapshot.hasData && genderSnapshot.data == true) {
                _initializeTheme(context);
                return const home.Home();
              } else {
                return const GenderSelectionScreen();
              }
            },
          );
        }
        return const Login();
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coming Soon'),
        backgroundColor: Colors.purple,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "This feature is coming soon!",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
