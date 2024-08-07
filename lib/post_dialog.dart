import 'package:flutter/material.dart';

//class for popupmenu user input caption and post body text
class PostDialog extends StatefulWidget {
  final Function(String caption, String body) onSubmit;

  const PostDialog({super.key, required this.onSubmit});

  @override
  PostDialogState createState() => PostDialogState();
}

class PostDialogState extends State<PostDialog> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void _submitPost() {
    final String caption = _captionController.text;
    final String body = _bodyController.text;

    if (caption.isNotEmpty && body.isNotEmpty) {
      widget.onSubmit(caption, body);

      // Clear the text fields after submission
      _captionController.clear();
      _bodyController.clear();

      // Close the dialog
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create a Post'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6, // 80% of screen width
        height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Caption',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Body',
                ),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitPost,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}