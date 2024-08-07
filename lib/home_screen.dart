import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umee_app/post_provider.dart';
import 'package:umee_app/post_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    //_loadPosts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_username.isNotEmpty) {
      context.read<PostProvider>().loadPosts(_username);
    }
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
    });
    if (mounted) {
      context.read<PostProvider>().loadPosts(_username);
    }
  }

  /*Future<void> _loadPosts() async {
    // Posts are loaded by the PostProvider, so no need to load posts here.
  } */

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_username.isEmpty ? 'Home' : "$_username's Home"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    username: _username,
                    onPostAdded: () {
                      context.read<PostProvider>().loadAllPosts();
                    },
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'Logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          // Get all posts and reverse the order to show the most recent first
          final posts = postProvider.posts.reversed.toList();
          print(posts);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // Adjust as needed
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostDetailsScreen(
                                  caption: post.caption,
                                  body: post.body,
                                  timestamp: post.timestamp,
                                  username: post.username,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.caption,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Expanded(
                                    child: Text(
                                      post.body,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Posted by: ${post.username}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    'Posted on: ${_formatTimestamp(post.timestamp)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('${post.dislikes}'),
                                          IconButton(
                                            icon: const Icon(Icons.thumb_down),
                                            onPressed: () => context.read<PostProvider>().dislikePost(post),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.thumb_up),
                                            onPressed: () => context.read<PostProvider>().likePost(post),
                                          ),
                                          Text('${post.likes}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}