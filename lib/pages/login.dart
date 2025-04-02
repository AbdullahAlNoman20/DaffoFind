import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/pages/Register.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset("images/Banner.jpg", height: 200.0)),
              const SizedBox(height: 30.0),
              _buildHeader(),
              const SizedBox(height: 40.0),
              _buildTextField("Email", _emailController, Icons.email, false),
              const SizedBox(height: 30.0),
              _buildTextField("Password", _passwordController, Icons.lock, true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?", style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16)),
                ),
              _buildLoginButton(),
              const SizedBox(height: 20.0),
              _buildSignUpOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Welcome To DaffoFind", style: TextStyle(color: Colors.white70, fontSize: 34.0, fontWeight: FontWeight.w500)),
        Text("Login", style: TextStyle(color: Colors.white, fontSize: 45.0, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 20.0, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? !_isPasswordVisible : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            hintText: "Enter your $label",
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIcon: Icon(icon, color: Colors.white),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white24),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Login", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Register())),
        child: const Text(
          "Don't have an account? Sign Up",
          style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
