import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

// Import feature screens
import 'features/ask_a_woman_chatbot/ask_a_woman_chatbot_screen.dart';
import 'features/empathy_neural_profile/empathy_neural_profile_screen.dart';
import 'features/scenario_engine/Scenario_engine_screen.dart';
import 'features/voice_of_her/voice_of_her_screen.dart';

import 'gender_selection_screen.dart';

// Import providers
import 'features/ask_a_woman_chatbot/ask_a_woman_chatbot_provider.dart';
import 'features/empathy_neural_profile/empathy_neural_profile_provider.dart';
import 'features/scenario_engine/scenario_engine_provider.dart';
import 'features/voice_of_her/voice_of_her_provider.dart';

import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, String>> loadEnvFile(String path) async {
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
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Manually load .env file
    final env = await loadEnvFile('.env');

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Center(
          child: Text('❌ ${details.exception}', textAlign: TextAlign.center),
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
              'Initialization error:\n$e\n$stack',
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
      ],
      child: MaterialApp(
        title: 'Firebase Auth Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const Login(),
          '/register': (context) => const Register(),
          '/home': (context) => const Home(),
          // Feature routes
          '/features/ask_a_woman_chatbot': (context) => AskAWomanChatbotScreen(
              apiKey: env['OPENAI_API_KEY_ASK_A_WOMAN_CHATBOT'] ?? ''),
          '/features/empathy_neural_profile': (context) =>
              EmpathyNeuralProfileScreen(),
          '/features/scenario_engine': (context) =>
              const ScenarioEngineScreen(),
          '/features/voice_of_her': (context) => const VoiceOfHerScreen(),
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
                return const Home();
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
    return const Scaffold(
      body: Center(
        child: Text("✅ Routing works. AuthWrapper has issues."),
      ),
    );
  }
}
