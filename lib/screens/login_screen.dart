import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'railway_dashboard.dart'; // Import your dashboard screen
import 'otp_page.dart'; // Import the OTP page

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  final _phoneController =
      TextEditingController(); // Add phone controller for OTP
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isOtpLoading = false; // Add loading state for OTP
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  String _captchaText = '';

  // HttpClient httpClient = HttpClient()
  //   ..badCertificateCallback =
  //       (X509Certificate cert, String host, int port) => true;

  // IOClient ioClient = IOClient(httpClient);

  // API endpoint
  static const String _apiUrl = 'http://192.168.56.1/api/login/';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    setState(() {
      _captchaText =
          List.generate(6, (_) => chars[rnd.nextInt(chars.length)]).join();
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check CAPTCHA first
        if (_captchaController.text.trim() != _captchaText) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Incorrect CAPTCHA'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
          _generateCaptcha();
          _captchaController.clear();
          return;
        }

        // Prepare the request body
        final Map<String, String> requestBody = {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text,
        };

        // Make the API call
        final response = await http.post(
          Uri.parse(_apiUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(requestBody),
        );

        // Handle the response
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          // if (responseData['success'] == true) {
          //   // Login successful
          //   if (mounted) {
          //     setState(() {
          //       _isLoading = false;
          //     });

          //     // Show success message
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(
          //         content: Text(responseData['message'] ?? 'Login successful'),
          //         backgroundColor: Colors.green[600],
          //         behavior: SnackBarBehavior.floating,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12)),
          //       ),
          //     );

          //     // Navigate to dashboard using Navigator.push
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const RailwayDashboard(),
          //       ),
          //     );
          //   }
         if (responseData['success'] == true) {
  // Save user data to SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Extract user data from response
  if (responseData['user'] != null) {
    final userData = responseData['user'];
    
    // Save user_id (from user.id)
    if (userData['id'] != null) {
      int userId = userData['id'] is int 
          ? userData['id'] 
          : int.tryParse(userData['id'].toString()) ?? 0;
      await prefs.setInt('user_id', userId);
      print('✅ User ID saved successfully: $userId');
    }
    
    // Save other user data (optional but useful)
    if (userData['username'] != null) {
      await prefs.setString('username', userData['username']);
    }
    if (userData['email'] != null) {
      await prefs.setString('email', userData['email']);
    }
    if (userData['user_role'] != null) {
      await prefs.setString('user_role', userData['user_role']);
    }
  } else {
    print('⚠️ WARNING: User data not found in response');
  }
  
  // Login successful
  if (mounted) {
    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(responseData['message'] ?? 'Login successful'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate to dashboard using Navigator.push
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RailwayDashboard(),
      ),
    );
  }


          } else {
            // Login failed with success: false
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(responseData['message'] ?? 'Login failed'),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          }
        } else {
          // HTTP error
          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error: ${response.statusCode}'),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      } catch (e) {
        // Network or other error
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error: ${e.toString()}'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Forgot password functionality will be implemented'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _signUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sign up functionality will be implemented'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A237E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E1A), // Deep navy
              Color(0xFF1A237E), // Deep blue
              Color(0xFF3F51B5), // Indigo
              Color(0xFF2196F3), // Blue
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background Railway Elements
            Positioned.fill(
              child: CustomPaint(
                painter: RailwayBackgroundPainter(),
              ),
            ),

            // Floating Train Icons
            Positioned(
              top: screenSize.height * 0.15,
              right: 30,
              child: Opacity(
                opacity: 0.08,
                child: Transform.rotate(
                  angle: 0.2,
                  child: const Icon(
                    Icons.train,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: screenSize.height * 0.25,
              left: 20,
              child: Opacity(
                opacity: 0.06,
                child: Transform.rotate(
                  angle: -0.3,
                  child: const Icon(
                    Icons.directions_railway,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16 : 24,
                    vertical: 20,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Header
                        _buildHeader(),

                        SizedBox(height: screenSize.height * 0.04),

                        // Main Login Card
                        Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth:
                                  isSmallScreen ? screenSize.width - 32 : 420,
                              minHeight: screenSize.height * 0.65,
                            ),
                            child: Card(
                              elevation: 25,
                              shadowColor: Colors.black.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white,
                                      Colors.grey[50]!,
                                      Colors.white,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(isSmallScreen ? 28 : 36),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildWelcomeSection(isSmallScreen),
                                        SizedBox(
                                            height: isSmallScreen ? 32 : 40),
                                        _buildLoginForm(isSmallScreen),
                                        SizedBox(
                                            height: isSmallScreen ? 24 : 32),
                                        _buildCaptchaSection(),
                                        SizedBox(
                                            height: isSmallScreen ? 24 : 32),
                                        _buildActionButtons(isSmallScreen),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenSize.height * 0.04),

                        // Footer
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.train,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    'E-Inspection Portal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B35).withOpacity(0.2),
                  const Color(0xFFFF8C42).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF6B35).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              'CRIS',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A237E),
                Color(0xFF3F51B5),
                Color(0xFF2196F3),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.directions_railway,
            color: Colors.white,
            size: 48,
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A237E),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Text(
          'Sign in to Railway E-Inspection Portal',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey[600],
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isSmallScreen) {
    return Column(
      children: [
        // Username Field
        _buildTextField(
          controller: _usernameController,
          label: 'Username',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your username';
            }
            return null;
          },
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 20 : 24),

        // Password Field
        _buildTextField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock_outline,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required String? Function(String?) validator,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF1A237E),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 16 : 18,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildCaptchaSection() {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(
                painter: CaptchaPainter(_captchaText),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
              onPressed: _generateCaptcha,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: _captchaController,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: 'Enter CAPTCHA Text',
            labelStyle: const TextStyle(
              color: Color(0xFF1A237E),
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.text_fields,
                color: Colors.white,
                size: 20,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter CAPTCHA text (case sensitive)';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 16),

// 👉 Get OTP button added here
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpPage(
                  phoneNumber:
                      "9876543210", // Replace with backend/fetched phone
                ),
              ),
            );
          },
          child: const Text(
            "Get OTP",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildActionButtons(bool isSmallScreen) {
    return Column(
      children: [
        // Login Button
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 56 : 60,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              padding: EdgeInsets.zero,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.center,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.login,
                              color: Colors.white, size: 22),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 16 : 20),

        // // Forgot Password Button
        // TextButton(
        //   onPressed: _forgotPassword,
        //   style: TextButton.styleFrom(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: isSmallScreen ? 16 : 20,
        //       vertical: isSmallScreen ? 8 : 12,
        //     ),
        //   ),
        //   child: Text(
        //     'Forgot Password?',
        //     style: TextStyle(
        //       color: const Color(0xFF1A237E),
        //       fontSize: isSmallScreen ? 14 : 16,
        //       fontWeight: FontWeight.w600,
        //       decoration: TextDecoration.underline,
        //     ),
        //   ),
        // ),

        // SizedBox(height: isSmallScreen ? 16 : 20),

        // // Divider
        // Row(
        //   children: [
        //     Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20),
        //       child: Text(
        //         'OR',
        //         style: TextStyle(
        //           color: Colors.grey[600],
        //           fontSize: 14,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //     Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        //   ],
        // ),

        // SizedBox(height: isSmallScreen ? 16 : 20),

        // // Create Account Button
        // SizedBox(
        //   width: double.infinity,
        //   height: isSmallScreen ? 52 : 56,
        //   child: OutlinedButton(
        //     onPressed: _signUp,
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(color: Color(0xFF1A237E), width: 2),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(16),
        //       ),
        //       backgroundColor: Colors.white,
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Icon(Icons.person_add, color: Color(0xFF1A237E), size: 20),
        //         SizedBox(width: isSmallScreen ? 8 : 12),
        //         Text(
        //           'Create New Account',
        //           style: TextStyle(
        //             color: const Color(0xFF1A237E),
        //             fontSize: isSmallScreen ? 16 : 17,
        //             fontWeight: FontWeight.w700,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.train,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                '© 2024 CRIS - Centre for Railway Information Systems',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Secure • Reliable • Efficient',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

class RailwayBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw railway tracks
    final trackSpacing = size.width / 8;
    for (int i = 0; i < 8; i++) {
      final x = i * trackSpacing;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.width * 0.2, size.height),
        paint,
      );
    }

    // Draw horizontal ties
    final tieSpacing = size.height / 15;
    for (int i = 0; i < 15; i++) {
      final y = i * tieSpacing;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint..strokeWidth = 1,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CaptchaPainter extends CustomPainter {
  final String captchaText;
  final Random random = Random();

  CaptchaPainter(this.captchaText);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final textStyle = TextStyle(
      color: Colors.red[800],
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );

    double x = 10;
    for (var char in captchaText.characters) {
      final angle = (random.nextDouble() - 0.5) * pi / 6;
      canvas.save();
      canvas.translate(x, size.height / 2);
      canvas.rotate(angle);

      final textSpan = TextSpan(text: char, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, -textPainter.height / 2));
      canvas.restore();

      x += 20 + random.nextDouble() * 10;
    }

    final linePaint = Paint()
      ..color = Colors.brown.withOpacity(0.5)
      ..strokeWidth = 1;

    for (int i = 0; i < 15; i++) {
      final start = Offset(
          random.nextDouble() * size.width, random.nextDouble() * size.height);
      final end = Offset(
          random.nextDouble() * size.width, random.nextDouble() * size.height);
      canvas.drawLine(start, end, linePaint);
    }

    for (int i = 0; i < 30; i++) {
      final dot = Offset(
          random.nextDouble() * size.width, random.nextDouble() * size.height);
      canvas.drawCircle(dot, 1, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
