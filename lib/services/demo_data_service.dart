import 'package:cloud_firestore/cloud_firestore.dart';

class DemoDataService {
  static Future<void> createDemoForumPosts() async {
    final firestore = FirebaseFirestore.instance;

    final demoPosts = [
      {
        'title': 'How do I start a conversation with someone new?',
        'content':
            'I\'m really shy and find it hard to talk to new people, especially in dating situations. What are some good conversation starters that don\'t feel awkward? Any tips would be really helpful!',
        'category': 'Questions',
        'authorId': 'demo_user_1',
        'authorName': 'ShyGuy23',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 2))),
        'likes': ['demo_user_2', 'demo_user_3'],
        'commentsCount': 5,
      },
      {
        'title': 'Success Story: Finally understood what she meant!',
        'content':
            'After months of using this app and learning about communication, I finally understood why my girlfriend gets upset when I try to "fix" her problems instead of just listening. Game changer! Thanks to everyone in this community.',
        'category': 'Success Stories',
        'authorId': 'demo_user_2',
        'authorName': 'LearningToListen',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 5))),
        'likes': ['demo_user_1', 'demo_user_3', 'demo_user_4', 'demo_user_5'],
        'commentsCount': 12,
      },
      {
        'title': 'What does it mean when she says "I\'m fine"?',
        'content':
            'My partner often says "I\'m fine" but her body language suggests otherwise. I\'ve learned not to take it at face value, but I\'m still confused about how to respond. What\'s the best approach?',
        'category': 'Relationship Advice',
        'authorId': 'demo_user_3',
        'authorName': 'ConfusedBF',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(hours: 8))),
        'likes': ['demo_user_1', 'demo_user_4'],
        'commentsCount': 8,
      },
      {
        'title': 'The importance of emotional validation',
        'content':
            'I wanted to share something I learned recently. When someone shares their feelings with you, they\'re not always looking for solutions. Sometimes they just want to feel heard and understood. This has changed how I approach conversations.',
        'category': 'General Discussion',
        'authorId': 'demo_user_4',
        'authorName': 'EmpathyExplorer',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1))),
        'likes': ['demo_user_1', 'demo_user_2', 'demo_user_3'],
        'commentsCount': 15,
      },
      {
        'title': 'Feeling overwhelmed - need support',
        'content':
            'I\'ve been trying to improve my communication skills but sometimes feel like I\'m making things worse. Anyone else feel like this journey is harder than expected? Could use some encouragement.',
        'category': 'Support',
        'authorId': 'demo_user_5',
        'authorName': 'StrugglingToGrow',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 1, hours: 3))),
        'likes': ['demo_user_2', 'demo_user_4'],
        'commentsCount': 7,
      },
      {
        'title': 'How to remember important dates and details?',
        'content':
            'I keep forgetting important things she tells me and it\'s causing problems. I\'ve tried setting reminders but still mess up. What strategies do you use to show you\'re really listening and remembering?',
        'category': 'Questions',
        'authorId': 'demo_user_6',
        'authorName': 'ForgetfulPartner',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 2))),
        'likes': ['demo_user_1', 'demo_user_3', 'demo_user_5'],
        'commentsCount': 9,
      },
      {
        'title': 'Amazing progress after 3 months!',
        'content':
            'Started using this app 3 months ago when my relationship was rocky. Today my partner told me she feels more heard and understood than ever before. The empathy exercises really work! Don\'t give up!',
        'category': 'Success Stories',
        'authorId': 'demo_user_7',
        'authorName': 'TransformedLover',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 2, hours: 5))),
        'likes': [
          'demo_user_1',
          'demo_user_2',
          'demo_user_3',
          'demo_user_4',
          'demo_user_5',
          'demo_user_6'
        ],
        'commentsCount': 18,
      },
      {
        'title': 'Understanding non-verbal communication',
        'content':
            'I\'ve been reading about body language and facial expressions. It\'s fascinating how much we communicate without words. What are some key things to watch for? Any good resources to recommend?',
        'category': 'General Discussion',
        'authorId': 'demo_user_8',
        'authorName': 'BodyLanguageLearner',
        'createdAt': Timestamp.fromDate(
            DateTime.now().subtract(const Duration(days: 3))),
        'likes': ['demo_user_2', 'demo_user_7'],
        'commentsCount': 6,
      },
    ];

    // Add demo posts to Firestore
    for (var post in demoPosts) {
      await firestore.collection('forum_posts').add(post);
    }
  }
}
