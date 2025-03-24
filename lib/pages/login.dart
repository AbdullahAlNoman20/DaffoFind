import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/pages/Register.dart';
import 'home.dart'; // Your home page after successful login

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false; // State to toggle password visibility
  final _auth = FirebaseAuth.instance; // Firebase authentication instance

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ''; // To display error messages

  // Function to handle login
  Future<void> _login() async {
    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If successful, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } catch (e) {
      setState(() {
        // Update error message to display in case of failure
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("images/Banner.jpg", height: 200.0)),
              const SizedBox(height: 30.0),
              Text(
                "Welcome To DaffoFind",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 34.0,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40.0),
              // Email Field
              Text(
                "Email",
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              // Password Field with Show/Hide Button
              Text(
                "Password",
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5.0),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle visibility
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle state
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // Forgot Password Button (Aligned Right)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Add forgot password functionality
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              // Error Message Display
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 30.0),
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login, // Use the login method when button is pressed
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Sign Up Button (Navigates to Register Page)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Register()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
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
