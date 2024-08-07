class Post {
  final String caption;
  final String body;
  final String timestamp;
  final String username; // Add this field
  int likes;
  int dislikes;

  Post({
    required this.caption,
    required this.body,
    required this.timestamp,
    required this.username,
    this.likes = 0,
    this.dislikes = 0,
  });

  // Convert Post to JSON
  Map<String, dynamic> toJson() => {
    'caption': caption,
    'body': body,
    'timestamp': timestamp,
    'username': username,
    'likes' : likes,
    'dislikes' : dislikes,
  };

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      caption: json['caption'],
      body: json['body'],
      timestamp: json['timestamp'],
      username: json['username'],
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}
