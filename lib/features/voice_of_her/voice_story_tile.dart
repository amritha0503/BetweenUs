import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'voice_story_model.dart';

class VoiceStoryTile extends StatefulWidget {
  final VoiceStory story;
  const VoiceStoryTile({super.key, required this.story});

  @override
  State<VoiceStoryTile> createState() => _VoiceStoryTileState();
}

class _VoiceStoryTileState extends State<VoiceStoryTile> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  bool _showTranscript = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.playerStateStream.listen((state) {
      final isPlaying =
          state.playing && state.processingState != ProcessingState.completed;
      if (mounted) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.setUrl(widget.story.audioUrl);
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(widget.story.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(widget.story.description),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayback,
              ),
              const Text('Listen'),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showTranscript = !_showTranscript;
                  });
                },
                icon: Icon(
                    _showTranscript ? Icons.visibility_off : Icons.menu_book),
                label: Text(
                    _showTranscript ? 'Hide Transcript' : 'Show Transcript'),
              ),
            ],
          ),
          if (_showTranscript)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.story.lesson,
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
