import 'package:flutter/material.dart';
import 'dart:math';

class BubblePopGame extends StatefulWidget {
  const BubblePopGame({super.key});

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame>
    with TickerProviderStateMixin {
  List<Bubble> bubbles = [];
  int score = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _generateBubbles();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateBubbles() {
    final random = Random();
    bubbles.clear();
    for (int i = 0; i < 10; i++) {
      bubbles.add(Bubble(
        x: random.nextDouble() * 300,
        y: random.nextDouble() * 500,
        size: random.nextDouble() * 50 + 30,
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
      ));
    }
  }

  void _popBubble(int index) {
    setState(() {
      bubbles.removeAt(index);
      score += 10;
      if (bubbles.isEmpty) {
        _generateBubbles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubble Pop Game'),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Score: $score',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.purple.shade200],
          ),
        ),
        child: Stack(
          children: [
            ...bubbles.asMap().entries.map((entry) {
              int index = entry.key;
              Bubble bubble = entry.value;
              return Positioned(
                left: bubble.x,
                top: bubble.y,
                child: GestureDetector(
                  onTap: () => _popBubble(index),
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_animationController.value * 0.1),
                        child: Container(
                          width: bubble.size,
                          height: bubble.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bubble.color.withOpacity(0.7),
                            boxShadow: [
                              BoxShadow(
                                color: bubble.color.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            score = 0;
            _generateBubbles();
          });
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final Color color;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
  });
}
