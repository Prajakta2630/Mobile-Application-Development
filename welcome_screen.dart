import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isSignUpLoading = false;
  bool _isLoginLoading = false;

  Future<void> _handleSignUp(BuildContext context) async {
    setState(() {
      _isSignUpLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenWelcome', true);
      Navigator.pushReplacementNamed(context, '/signup');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during sign-up: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSignUpLoading = false;
      });
    }
  }

  Future<void> _handleLogin(BuildContext context) async {
    setState(() {
      _isLoginLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenWelcome', true);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during login: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoginLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7BD5F5),
              Color(0xFFE6F5FA),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 250,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Capture Every Moment',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2F98),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Your little archive of awesome.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1F2F98),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed:
                    _isSignUpLoading ? null : () => _handleSignUp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ).copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: _isSignUpLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onSecondary,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Get Started',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoginLoading ? null : () => _handleLogin(context),
                style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.tertiary),
                      elevation: MaterialStateProperty.all(8),
                    ),
                child: _isLoginLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onTertiary,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Log In',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onTertiary,
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
