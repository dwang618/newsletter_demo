import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart'; // Import the file where your HomeScreen is moved
import 'dart:convert'; // For encoding and decoding JSON

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  List<String> _previousUsernames = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadPreviousUsernames();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    // Redirect to HomeScreen if a valid username is found
    if (username != null && username.isNotEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> _loadPreviousUsernames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernamesJson = prefs.getString('previous_usernames');
    if (usernamesJson != null) {
      setState(() {
        _previousUsernames = List<String>.from(json.decode(usernamesJson));
      });
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Add username to the list of previous usernames
      _previousUsernames.add(username);
      await prefs.setString('previous_usernames', json.encode(_previousUsernames));


      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> _loginProfile(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);

    // Navigate to the home screen after login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _removeUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _previousUsernames.remove(username); // Remove username from the list
    });
    await prefs.setString('previous_usernames', json.encode(_previousUsernames)); // Update SharedPreferences
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Enter your username:'),
              const SizedBox(height:20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),

              const SizedBox(height: 10),
              const Text('User Profiles:'),
              const SizedBox(height: 10),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0), // Add padding around the GridView
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of items per row
                      crossAxisSpacing: 8.0, // Increase space between columns
                      mainAxisSpacing: 8.0, // Increase space between rows
                    ),
                    itemCount: _previousUsernames.length,
                    itemBuilder: (context, index) {
                      final username = _previousUsernames[index];
                      return GestureDetector(
                        onTap: () => _loginProfile(username), // Log in with the selected username
                        child: Container(
                          padding: const EdgeInsets.all(8.0), // Adjust padding inside the container
                          color: Colors.blueGrey[200],
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  username,
                                  style: const TextStyle(fontSize: 14), // Adjust font size if needed
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 16), // Smaller icon size
                                  padding: EdgeInsets.zero, // Remove any extra padding around the icon
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                    _removeUsername(username); // Call method to remove username
                                  },
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
