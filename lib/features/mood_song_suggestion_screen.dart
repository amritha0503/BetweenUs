import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoodSongSuggestionScreen extends StatefulWidget {
  const MoodSongSuggestionScreen({Key? key}) : super(key: key);

  @override
  State<MoodSongSuggestionScreen> createState() =>
      _MoodSongSuggestionScreenState();
}

class _MoodSongSuggestionScreenState extends State<MoodSongSuggestionScreen> {
  final TextEditingController _moodController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  YoutubePlayerController? _youtubeController;
  String _detectedMood = '';
  List<Song> _suggestedSongs = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Song? _currentlyPlaying;
  String _selectedLanguage = 'All';

  // Enhanced mood categories
  final Map<String, List<String>> _moodKeywords = {
    'Sad': [
      'sad',
      'depressed',
      'unhappy',
      'down',
      'lonely',
      'blue',
      'melancholy',
      'gloomy'
    ],
    'Anxious': [
      'anxious',
      'nervous',
      'worried',
      'stressed',
      'tense',
      'restless'
    ],
    'Happy': [
      'happy',
      'joy',
      'excited',
      'good',
      'cheerful',
      'delighted',
      'elated',
      'content'
    ],
    'Angry': ['angry', 'frustrated', 'mad', 'furious', 'irritated', 'annoyed'],
    'Energetic': ['energetic', 'pumped', 'motivated', 'active', 'dynamic'],
    'Romantic': ['romantic', 'love', 'loving', 'affectionate', 'tender'],
    'Calm': ['calm', 'peaceful', 'relaxed', 'serene', 'tranquil'],
  };

  @override
  void dispose() {
    try {
      _audioPlayer.dispose();
      _youtubeController?.dispose();
      _moodController.dispose();
    } catch (e) {
      print('Error during disposal: $e');
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Initialize with empty audio to prevent errors
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse('https://example.com/empty.mp3')),
        preload: false,
      );
    } catch (e) {
      print('Error initializing player: $e');
    }
  }

  Future<void> _detectMoodAndSuggestSongs() async {
    if (!mounted) return;

    try {
      final input = _moodController.text.trim().toLowerCase();
      if (input.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter how you are feeling';
          _suggestedSongs = [];
          _detectedMood = '';
          _currentlyPlaying = null;
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = '';
        _currentlyPlaying = null;
      });

      // Process mood detection
      await Future.microtask(() {
        Map<String, int> moodScores = {};
        for (var entry in _moodKeywords.entries) {
          int score =
              entry.value.where((keyword) => input.contains(keyword)).length;
          if (score > 0) {
            moodScores[entry.key] = score;
          }
        }

        String detectedMood = 'Neutral';
        if (moodScores.isNotEmpty) {
          detectedMood = moodScores.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }

        if (!mounted) return;

        setState(() {
          _detectedMood = detectedMood;
          _suggestedSongs = _getSongsForMood(detectedMood);
          _isLoading = false;
        });
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
        _detectedMood = '';
        _suggestedSongs = [];
        _currentlyPlaying = null;
      });
      print('Error in mood detection: $e');
    }
  }

  List<Song> _getSongsForMood(String mood) {
    List<Song> songs = [];

    switch (mood) {
      case 'Sad':
      case 'Anxious':
        songs = _getMotivationalSongs();
        break;
      case 'Happy':
        songs = _getHappySongs();
        break;
      case 'Angry':
      case 'Calm':
        songs = _getCalmingSongs();
        break;
      case 'Energetic':
        songs = _getEnergeticSongs();
        break;
      case 'Romantic':
        songs = _getRomanticSongs();
        break;
      default:
        songs = _getHappySongs();
    }

    // Filter by selected language
    if (_selectedLanguage != 'All') {
      songs =
          songs.where((song) => song.language == _selectedLanguage).toList();
    }

    return songs;
  }

  List<Song> _getMotivationalSongs() {
    return [
      Song('Eye of the Tiger', 'English',
          'https://www.youtube.com/watch?v=btPJPFnesV4', true),
      Song('Stronger (What Doesn\'t Kill You)', 'English',
          'https://www.youtube.com/watch?v=Xn676-fLq7I', true),
      Song('Don\'t Stop Believin\'', 'English',
          'https://www.youtube.com/watch?v=1k8craCGpgs', true),
      Song('We Will Rock You', 'English',
          'https://www.youtube.com/watch?v=-tJYN-eG1zk', true),
      Song('Roar', 'English', 'https://www.youtube.com/watch?v=CevxZvSJLk8',
          true),
      // Added Hindi songs
      Song('Tum Hi Ho', 'Hindi', 'https://www.youtube.com/watch?v=Umqb9KENgmk',
          true),
      Song('Chaiyya Chaiyya', 'Hindi',
          'https://www.youtube.com/watch?v=PQmrmVs10X8', true),
    ];
  }

  List<Song> _getHappySongs() {
    return [
      Song('Happy', 'English', 'https://www.youtube.com/watch?v=ZbZSe6N_BXs',
          true),
      Song('Walking on Sunshine', 'English',
          'https://www.youtube.com/watch?v=iPUmE-tne5U', true),
      Song('Can\'t Stop the Feeling', 'English',
          'https://www.youtube.com/watch?v=ru0K8uYEZWw', true),
      Song('Good as Hell', 'English',
          'https://www.youtube.com/watch?v=H7HmzwI67ec', true),
      Song('Uptown Funk', 'English',
          'https://www.youtube.com/watch?v=OPf0YbXqDm0', true),
      // Added Malayalam songs
      Song('Entammede Jimikki Kammal', 'Malayalam',
          'https://www.youtube.com/watch?v=0sB3p7t9N3k', true),
      Song('Jimmiki Kammal', 'Malayalam',
          'https://www.youtube.com/watch?v=Q9oKMz9V7iA', true),
    ];
  }

  List<Song> _getCalmingSongs() {
    return [
      Song('Weightless', 'English',
          'https://www.youtube.com/watch?v=UfcAVejslrU', true),
      Song('Clair de Lune', 'English',
          'https://www.youtube.com/watch?v=CvFH_6DNRCY', true),
      Song('Aqueous Transmission', 'English',
          'https://www.youtube.com/watch?v=6z0i0Q6X7xk', true),
      Song('Mad World', 'English',
          'https://www.youtube.com/watch?v=4N3N1MlvVc4', true),
      Song('The Sound of Silence', 'English',
          'https://www.youtube.com/watch?v=4zLfCnGVeL4', true),
      Song('Chirapunji Mazhayath', 'Malayalam',
          'https://youtu.be/dDRj50HRkXI?si=1Adc0EgMalRYnMdn', true),
    ];
  }

  List<Song> _getEnergeticSongs() {
    return [
      Song('Thunderstruck', 'English',
          'https://www.youtube.com/watch?v=v2AC41dglnM', true),
      Song('Pump It', 'English', 'https://www.youtube.com/watch?v=ZaI2IlHwmgQ',
          true),
      Song('Till I Collapse', 'English',
          'https://www.youtube.com/watch?v=Y6ljFaKRTrI', true),
      Song('We Are the Champions', 'English',
          'https://www.youtube.com/watch?v=04854XqcfCY', true),
      Song('Stronger', 'English', 'https://www.youtube.com/watch?v=PsO6ZnUZI0g',
          true),
    ];
  }

  List<Song> _getRomanticSongs() {
    return [
      Song('Perfect', 'English', 'https://www.youtube.com/watch?v=2Vv-BfVoq4g',
          true),
      Song('All of Me', 'English',
          'https://www.youtube.com/watch?v=450p7goxZqg', true),
      Song('Thinking Out Loud', 'English',
          'https://www.youtube.com/watch?v=lp-EO5I60KA', true),
      Song('A Thousand Years', 'English',
          'https://www.youtube.com/watch?v=rtL5oMyBHPs', true),
      Song('Make You Feel My Love', 'English',
          'https://www.youtube.com/watch?v=0put0_a--Ng', true),
    ];
  }

  void _playSong(Song song) async {
    if (kIsWeb) {
      _showErrorMessage('YouTube playback is not supported on web');
      return;
    }

    try {
      if (!mounted) return;

      // Stop current playback
      await _stopCurrentSong();

      if (song.isYouTube) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(song.url) ?? '',
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
        setState(() {
          _currentlyPlaying = song;
        });
      } else {
        // Play audio URL
        await _playAudioUrl(song.url);
        if (mounted) {
          setState(() {
            _currentlyPlaying = song;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error playing song: ${e.toString()}');
        setState(() {
          _currentlyPlaying = null;
          _youtubeController = null;
        });
      }
    }
  }

  Future<void> _stopCurrentSong() async {
    try {
      await _audioPlayer.stop();
      if (_youtubeController != null) {
        _youtubeController!.pause();
        _youtubeController = null;
      }
      if (mounted) {
        setState(() {
          _currentlyPlaying = null;
        });
      }
    } catch (e) {
      _showErrorMessage('Error stopping playback');
    }
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _playAudioUrl(String url) async {
    if (!Uri.parse(url).isAbsolute) {
      throw Exception('Invalid audio URL');
    }

    try {
      final duration = await _audioPlayer.setUrl(url);
      if (duration == null) {
        throw Exception('Could not load audio');
      }
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Song Suggestions'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.withOpacity(0.1), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _moodController,
                          decoration: InputDecoration(
                            hintText: 'Type your mood here...',
                            prefixIcon:
                                const Icon(Icons.mood, color: Colors.purple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorText:
                                _errorMessage.isNotEmpty ? _errorMessage : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedLanguage,
                          decoration: InputDecoration(
                            labelText: 'Select Language',
                            prefixIcon: const Icon(Icons.language,
                                color: Colors.purple),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          items: ['All', 'English', 'Hindi', 'Malayalam']
                              .map((lang) => DropdownMenuItem(
                                    value: lang,
                                    child: Text(lang),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLanguage = value!;
                              if (_detectedMood.isNotEmpty) {
                                _suggestedSongs =
                                    _getSongsForMood(_detectedMood);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                _isLoading ? null : _detectMoodAndSuggestSongs,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.music_note),
                            label: Text(
                                _isLoading ? 'Finding Songs...' : 'Find Songs'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_detectedMood.isNotEmpty) ...[
                  Card(
                    elevation: 2,
                    color: Colors.purple.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.psychology, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text(
                            'Detected Mood: $_detectedMood',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_currentlyPlaying != null)
                            IconButton(
                              icon: const Icon(Icons.stop),
                              onPressed: _stopCurrentSong,
                              tooltip: 'Stop current song',
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_youtubeController != null)
                    YoutubePlayer(
                      controller: _youtubeController!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.purple,
                      onEnded: (metaData) {
                        _stopCurrentSong();
                      },
                    ),
                  const SizedBox(height: 16),
                  _suggestedSongs.isEmpty
                      ? const Center(
                          child: Text(
                            'No songs found for selected language',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _suggestedSongs.length,
                          itemBuilder: (context, index) {
                            final song = _suggestedSongs[index];
                            final isPlaying = _currentlyPlaying == song;

                            return Card(
                              elevation: isPlaying ? 4 : 1,
                              color: isPlaying
                                  ? Colors.purple.withOpacity(0.1)
                                  : null,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple,
                                  child: Text(
                                    song.language.substring(0, 1),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  song.title,
                                  style: TextStyle(
                                    fontWeight: isPlaying
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                subtitle: Text('Language: ${song.language}'),
                                trailing: IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.purple,
                                  ),
                                  onPressed: isPlaying
                                      ? _stopCurrentSong
                                      : () => _playSong(song),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Song {
  final String title;
  final String language;
  final String url;
  final bool isYouTube;

  Song(this.title, this.language, this.url, [this.isYouTube = false]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          language == other.language &&
          url == other.url;

  @override
  int get hashCode => title.hashCode ^ language.hashCode ^ url.hashCode;
}
