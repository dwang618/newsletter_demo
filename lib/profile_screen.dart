  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:umee_app/post.dart';
  import 'post_provider.dart';
  import 'post_dialog.dart';
  import 'post_screen.dart'; // Import PostScreen if needed

  class ProfileScreen extends StatefulWidget {
    final String username;
    final VoidCallback onPostAdded; // Callback to notify the HomeScreen

    const ProfileScreen({
      super.key,
      required this.username,
      required this.onPostAdded,
    });

    @override
    ProfileScreenState createState() => ProfileScreenState();
  }

  class ProfileScreenState extends State<ProfileScreen> {
    @override
    void initState() {
      super.initState();
      context.read<PostProvider>().loadPosts(widget.username);
    }

    void _showPostDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PostDialog(
            onSubmit: (String caption, String body) {
              final post = Post(
                caption: caption,
                body: body,
                timestamp: DateTime.now().toIso8601String(),
                username: widget.username,
                likes: 0,  // Initialize likeCount
                dislikes: 0,  // Initialize dislikeCount
              );
              context.read<PostProvider>().savePost(widget.username, post).then((_) {
                widget.onPostAdded(); // Notify HomeScreen to refresh posts
                Navigator.pop(context); // Close the dialog
              });
            },
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.username}\'s Profile'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _showPostDialog(context),
                child: const Text('Create a Post'),
              ),

              const SizedBox(height: 10), // Add vertical space between the buttons

              ElevatedButton(
                onPressed: () => context.read<PostProvider>().clearPosts(widget.username),
                child: const Text('Clear All Posts'),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Consumer<PostProvider>(
                  builder: (context, postProvider, child) {
                    final posts = postProvider.posts.toList();
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Adjust to your desired number of columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
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
                          child: SizedBox(
                            height: 150.0,
                            child: Card(
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post.caption, style: Theme.of(context).textTheme.headlineSmall),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                      child: Text(post.body, style: Theme.of(context).textTheme.bodySmall),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text('Posted on: ${_formatTimestamp(post.timestamp)}', style: Theme.of(context).textTheme.bodySmall),
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            ],
          ),
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
