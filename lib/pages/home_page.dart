import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String selectedRole;

  const HomePage({super.key, required this.selectedRole});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? passwordError;
  bool _isLoading = false;

  // Google Apps Script Web App URL
  final String _webAppUrl = 'https://script.google.com/macros/s/AKfycbx2le1A-fi8l7YSl-_96UOUZKeCll0D7kFANPwzuAhQpfk8IE3rhjSPelhrES4c2GNlaQ/exec';

  bool isValidPassword(String password) {
    final regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (password.length < 8) {
      setState(() => passwordError = "Password must be at least 8 characters long.");
      return false;
    } else if (!regex.hasMatch(password)) {
      setState(() => passwordError = "Only letters, numbers, and '_' allowed.");
      return false;
    }
    setState(() => passwordError = null);
    return true;
  }

  Future<void> saveUserData(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', widget.selectedRole);
    await prefs.setString('username', username);
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter username and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_webAppUrl),
        body: {
          'action': 'login',
          'role': widget.selectedRole,
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success') {
          await saveUserData(usernameController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login successful for ${widget.selectedRole}")),
          );
          Navigator.pushNamed(context, '/routes');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Login failed")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error. Please try again.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        usernameController.text = savedUsername;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login / Signup"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Login as ${widget.selectedRole}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                errorText: passwordError,
              ),
              onChanged: (value) => isValidPassword(value),
            ),
            const SizedBox(height: 10),

            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Login'),
                ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(selectedRole: widget.selectedRole),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  final String selectedRole;

  const SignupPage({super.key, required this.selectedRole});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Google Apps Script Web App URL
  final String _webAppUrl = 'https://script.google.com/macros/s/AKfycbx2le1A-fi8l7YSl-_96UOUZKeCll0D7kFANPwzuAhQpfk8IE3rhjSPelhrES4c2GNlaQ/exec';
  
  bool _isLoading = false;

  Future<void> signup() async {
    // Basic validation
    if (usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username cannot be empty")),
      );
      return;
    }

    if (passwordController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 8 characters long")),
      );
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(_webAppUrl),
        body: {
          'action': 'signup',
          'role': widget.selectedRole,
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['status'] == 'success') {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', usernameController.text.trim());
          await prefs.setString('role', widget.selectedRole);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signup successful!")),
          );

          Navigator.pop(context); // Return to login page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonResponse['message'] ?? "Signup failed")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Network error. Please try again.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signup as ${widget.selectedRole}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text('Signup'),
                ),
          ],
        ),
      ),
    );
  }
}
