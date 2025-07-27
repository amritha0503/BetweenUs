import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../models/forum_post.dart';
import 'create_post_screen.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({Key? key}) : super(key: key);

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'General Discussion',
    'Relationship Advice',
    'Success Stories',
    'Questions',
    'Support'
  ];

  // Demo data - hardcoded posts
  final List<ForumPost> _demoPosts = [
    ForumPost(
      id: '1',
      title: 'How do I start a conversation with someone new?',
      content:
          'I\'m really shy and find it hard to talk to new people, especially in dating situations. What are some good conversation starters that don\'t feel awkward? Any tips would be really helpful!',
      category: 'Questions',
      authorId: 'user1',
      authorName: 'ShyGuy23',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: ['user2', 'user3'],
      commentsCount: 5,
    ),
    ForumPost(
      id: '2',
      title: 'Success Story: Finally understood what she meant!',
      content:
          'After months of learning about communication, I finally understood why my girlfriend gets upset when I try to "fix" her problems instead of just listening. Game changer! Thanks to everyone in this community.',
      category: 'Success Stories',
      authorId: 'user2',
      authorName: 'LearningToListen',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      likes: ['user1', 'user3', 'user4', 'user5'],
      commentsCount: 12,
    ),
    ForumPost(
      id: '3',
      title: 'What does it mean when she says "I\'m fine"?',
      content:
          'My partner often says "I\'m fine" but her body language suggests otherwise. I\'ve learned not to take it at face value, but I\'m still confused about how to respond. What\'s the best approach?',
      category: 'Relationship Advice',
      authorId: 'user3',
      authorName: 'ConfusedBF',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      likes: ['user1', 'user4'],
      commentsCount: 8,
    ),
    ForumPost(
      id: '4',
      title: 'The importance of emotional validation',
      content:
          'I wanted to share something I learned recently. When someone shares their feelings with you, they\'re not always looking for solutions. Sometimes they just want to feel heard and understood. This has changed how I approach conversations.',
      category: 'General Discussion',
      authorId: 'user4',
      authorName: 'EmpathyExplorer',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: ['user1', 'user2', 'user3'],
      commentsCount: 15,
    ),
    ForumPost(
      id: '5',
      title: 'Feeling overwhelmed - need support',
      content:
          'I\'ve been trying to improve my communication skills but sometimes feel like I\'m making things worse. Anyone else feel like this journey is harder than expected? Could use some encouragement.',
      category: 'Support',
      authorId: 'user5',
      authorName: 'StrugglingToGrow',
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      likes: ['user2', 'user4'],
      commentsCount: 7,
    ),
    ForumPost(
      id: '6',
      title: 'How to remember important dates and details?',
      content:
          'I keep forgetting important things she tells me and it\'s causing problems. I\'ve tried setting reminders but still mess up. What strategies do you use to show you\'re really listening and remembering?',
      category: 'Questions',
      authorId: 'user6',
      authorName: 'ForgetfulPartner',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      likes: ['user1', 'user3', 'user5'],
      commentsCount: 9,
    ),
    ForumPost(
      id: '7',
      title: 'Amazing progress after 3 months!',
      content:
          'Started using this app 3 months ago when my relationship was rocky. Today my partner told me she feels more heard and understood than ever before. The empathy exercises really work! Don\'t give up!',
      category: 'Success Stories',
      authorId: 'user7',
      authorName: 'TransformedLover',
      createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
      likes: ['user1', 'user2', 'user3', 'user4', 'user5', 'user6'],
      commentsCount: 18,
    ),
    ForumPost(
      id: '8',
      title: 'Understanding non-verbal communication',
      content:
          'I\'ve been reading about body language and facial expressions. It\'s fascinating how much we communicate without words. What are some key things to watch for? Any good resources to recommend?',
      category: 'General Discussion',
      authorId: 'user8',
      authorName: 'BodyLanguageLearner',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      likes: ['user2', 'user7'],
      commentsCount: 6,
    ),
  ];

  List<ForumPost> get _filteredPosts {
    if (_selectedCategory == 'All') {
      return _demoPosts;
    }
    return _demoPosts
        .where((post) => post.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final userGender = themeProvider.userGender;
        final primaryColor = userGender == 'male' ? Colors.pink : Colors.blue;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Community Forum'),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearchDialog(),
              ),
            ],
          ),
          body: Column(
            children: [
              // Category Filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: primaryColor.withOpacity(0.2),
                        checkmarkColor: primaryColor,
                      ),
                    );
                  },
                ),
              ),

              // Posts List
              Expanded(
                child: _filteredPosts.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredPosts.length,
                        itemBuilder: (context, index) {
                          final post = _filteredPosts[index];
                          return _buildPostCard(post, primaryColor);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToCreatePost(),
            backgroundColor: primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildPostCard(ForumPost post, Color primaryColor) {
    final currentUserId = 'current_user'; // Demo current user ID
    final isLiked = post.isLikedBy(currentUserId);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  child: Text(
                    post.authorName.isNotEmpty
                        ? post.authorName[0].toUpperCase()
                        : 'A',
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.timeAgo,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.category,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Content
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            // Actions
            Row(
              children: [
                InkWell(
                  onTap: () => _toggleLike(post),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_outline,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text('${post.likesCount}'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () => _navigateToPostDetail(post),
                  child: Row(
                    children: [
                      const Icon(Icons.comment_outlined,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 4),
                      Text('${post.commentsCount}'),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _navigateToPostDetail(post),
                  child:
                      Text('Read More', style: TextStyle(color: primaryColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No posts in this category',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
  }

  void _navigateToPostDetail(ForumPost post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening "${post.title}" - coming soon!')),
    );
  }

  void _toggleLike(ForumPost post) {
    setState(() {
      final currentUserId = 'current_user';
      if (post.isLikedBy(currentUserId)) {
        post.likes.remove(currentUserId);
      } else {
        post.likes.add(currentUserId);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(post.isLikedBy('current_user') ? 'Liked!' : 'Unliked!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Posts'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter search terms...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature - coming soon!')),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
