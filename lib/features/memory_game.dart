import 'package:flutter/material.dart';
import 'dart:math';

class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  List<String> _cards = [];
  List<bool> _revealed = [];
  List<int> _selectedIndexes = [];
  int _matches = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<String> symbols = ['🌟', '🎯', '🎨', '🎪', '🎭', '🎸', '🎵', '🎮'];
    _cards = [...symbols, ...symbols];
    _cards.shuffle();
    _revealed = List.filled(16, false);
    _selectedIndexes = [];
    _matches = 0;
  }

  void _onCardTap(int index) {
    if (_revealed[index] || _selectedIndexes.length >= 2) return;

    setState(() {
      _revealed[index] = true;
      _selectedIndexes.add(index);
    });

    if (_selectedIndexes.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (_cards[_selectedIndexes[0]] == _cards[_selectedIndexes[1]]) {
        setState(() {
          _matches++;
        });
      } else {
        setState(() {
          _revealed[_selectedIndexes[0]] = false;
          _revealed[_selectedIndexes[1]] = false;
        });
      }
      setState(() {
        _selectedIndexes.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Matches: $_matches/8',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
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
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _revealed[index] ? Colors.white : Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        _revealed[index] ? _cards[index] : '?',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _initializeGame();
                });
              },
              child: const Text('Restart Game'),
            ),
          ),
        ],
      ),
    );
  }
}
