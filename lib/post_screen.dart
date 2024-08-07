import 'package:flutter/material.dart';

class PostDetailsScreen extends StatelessWidget {
  final String caption;
  final String body;
  final String timestamp;
  final String username; // Add this field

  const PostDetailsScreen({
    super.key,
    required this.caption,
    required this.body,
    required this.timestamp,
    required this.username, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted by: $username', // Display the username
              style: Theme.of(context).textTheme.titleSmall, // Update styling as needed
            ),
            const SizedBox(height: 8.0),
            Text(
              caption,
              style: Theme.of(context).textTheme.labelMedium, // Update styling as needed
            ),
            const SizedBox(height: 8.0),
            Text(
              body,
              style: Theme.of(context).textTheme.bodySmall, // Update styling as needed
            ),
            const SizedBox(height: 8.0),
            Text(
              'Posted on: ${_formatTimestamp(timestamp)}',
              style: Theme.of(context).textTheme.labelSmall, // Update styling as needed
            ),
          ],
        ),
      ),
    );
  }

  // Method to format the timestamp for display
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
