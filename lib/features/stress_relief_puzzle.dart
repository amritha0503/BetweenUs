import 'package:flutter/material.dart';

class StressReliefPuzzle extends StatefulWidget {
  const StressReliefPuzzle({super.key});

  @override
  State<StressReliefPuzzle> createState() => _StressReliefPuzzleState();
}

class _StressReliefPuzzleState extends State<StressReliefPuzzle> {
  List<int> tiles = List.generate(15, (index) => index + 1)..add(0);
  int emptyIndex = 15;

  void swapTiles(int index) {
    if ((index - 1 == emptyIndex && index % 4 != 0) ||
        (index + 1 == emptyIndex && (index + 1) % 4 != 0) ||
        index - 4 == emptyIndex ||
        index + 4 == emptyIndex) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
        emptyIndex = index;
      });
    }
  }

  bool isCompleted() {
    for (int i = 0; i < 15; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Relief Puzzle'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                final tile = tiles[index];
                return GestureDetector(
                  onTap: () {
                    if (tile != 0) swapTiles(index);
                    if (isCompleted()) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Congratulations!'),
                          content: const Text('You completed the puzzle!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: tile == 0 ? Colors.transparent : Colors.purple[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple),
                    ),
                    child: Center(
                      child: tile == 0
                          ? null
                          : Text(
                              '$tile',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
