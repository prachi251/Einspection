import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  
  const OtpPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with TickerProviderStateMixin {
  final List<TextEditingController> _otpControllers = 
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  
  bool _isLoading = false;
  bool _canResendOtp = false;
  int _resendTimer = 30;
  Timer? _timer;
  DateTime? _otpExpiry;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _fadeController.forward();
    _slideController.forward();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResendOtp = false;
    _resendTimer = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  String _getMaskedPhoneNumber() {
    if (widget.phoneNumber.length >= 10) {
      final lastThree = widget.phoneNumber.substring(widget.phoneNumber.length - 3);
      final masked = '*' * (widget.phoneNumber.length - 3);
      return '$masked$lastThree';
    }
    return widget.phoneNumber;
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Auto submit when all fields are filled
    if (index == 3 && value.isNotEmpty) {
      _checkAllFieldsFilled();
    }
  }

  void _checkAllFieldsFilled() {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 4) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _submitOtp();
      });
    }
  }

  // Future<void> _submitOtp() async {
  //   final otp = _otpControllers.map((controller) => controller.text).join();
    
  //   if (otp.length != 4) {
  //     _showSnackBar('Please enter complete OTP', Colors.red[600]!);
  //     return;
  //   }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     // Simulate API call
  //     await Future.delayed(const Duration(seconds: 2));
      
  //     // For demo purposes, accept any 4-digit OTP
  //     // In real implementation, you would validate with backend
      
  //     setState(() {
  //       _isLoading = false;
  //     });
      
  //     _showSnackBar('OTP verified successfully!', Colors.green[600]!);
      
  //     // Navigate back to login screen after successful verification
  //     Future.delayed(const Duration(seconds: 1), () {
  //       Navigator.of(context).pop(true); // Return true to indicate success
  //     });
      
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     _showSnackBar('OTP verification failed. Please try again.', Colors.red[600]!);
  //     _clearOtpFields();
  //   }
  // }

  Future<void> _submitOtp() async {
  final otp = _otpControllers.map((controller) => controller.text).join();

  if (otp.length != 4) {
    _showSnackBar('Please enter complete OTP', Colors.red[600]!);
    return;
  }

  // Check if OTP expired at midnight
  final now = DateTime.now();
  if (_otpExpiry != null && now.isAfter(_otpExpiry!)) {
    _showSnackBar('OTP expired! Please request a new one.', Colors.red[600]!);
    _clearOtpFields();
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showSnackBar('OTP verified successfully!', Colors.green[600]!);

    // Navigate back after success
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop(true);
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    _showSnackBar('OTP verification failed. Please try again.', Colors.red[600]!);
    _clearOtpFields();
  }
}


  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  // Future<void> _resendOtp() async {
  //   if (!_canResendOtp) return;
    
  //   setState(() {
  //     _isLoading = true;
  //   });
    
  //   try {
  //     // Simulate API call to resend OTP
  //     await Future.delayed(const Duration(seconds: 1));
      
  //     setState(() {
  //       _isLoading = false;
  //     });
      
  //     _showSnackBar('New OTP sent successfully!', Colors.green[600]!);
  //     _clearOtpFields();
  //     _startResendTimer();
      
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     _showSnackBar('Failed to resend OTP. Please try again.', Colors.red[600]!);
  //   }
  // }
  Future<void> _resendOtp() async {
  if (!_canResendOtp) return;

  setState(() {
    _isLoading = true;
  });

  try {
    // Simulate API call to resend OTP
    await Future.delayed(const Duration(seconds: 1));

    // 🔹 Set OTP expiry to today's midnight
    _otpExpiry = DateTime.now().add(
      Duration(
        hours: 23 - DateTime.now().hour,
        minutes: 59 - DateTime.now().minute,
        seconds: 59 - DateTime.now().second,
      ),
    );

    setState(() {
      _isLoading = false;
    });

    _showSnackBar('New OTP sent successfully!', Colors.green[600]!);
    _clearOtpFields();
    _startResendTimer();

  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    _showSnackBar('Failed to resend OTP. Please try again.', Colors.red[600]!);
  }
}


  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
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
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          // Header
                          _buildHeader(),
                          
                          SizedBox(height: screenSize.height * 0.04),
                          
                          // Main OTP Card
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isSmallScreen ? screenSize.width - 32 : 420,
                                minHeight: screenSize.height * 0.6,
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
                                    padding: EdgeInsets.all(isSmallScreen ? 28 : 36),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _buildOtpHeader(isSmallScreen),
                                        SizedBox(height: isSmallScreen ? 32 : 40),
                                        _buildPhoneDisplay(isSmallScreen),
                                        SizedBox(height: isSmallScreen ? 32 : 40),
                                        _buildOtpInput(isSmallScreen),
                                        SizedBox(height: isSmallScreen ? 32 : 40),
                                        _buildSubmitButton(isSmallScreen),
                                        SizedBox(height: isSmallScreen ? 24 : 32),
                                        _buildResendSection(isSmallScreen),
                                      ],
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
            ),
            
            // Back Button
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
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
        mainAxisAlignment: MainAxisAlignment.center,
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
              Icons.security,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'OTP Verification',
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
        ],
      ),
    );
  }

  Widget _buildOtpHeader(bool isSmallScreen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4CAF50),
                Color(0xFF66BB6A),
                Color(0xFF81C784),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.message,
            color: Colors.white,
            size: 48,
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Text(
          'Verify Your Phone',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A237E),
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4CAF50).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Your OTP has been sent to your registered Phone number',
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneDisplay(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[50]!,
            Colors.grey[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1A237E).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3F51B5)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _getMaskedPhoneNumber(),
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A237E),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpInput(bool isSmallScreen) {
    return Column(
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A237E),
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return SizedBox(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 60 : 70,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _otpControllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A237E),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 3),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) => _onOtpChanged(value, index),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 56 : 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitOtp,
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
              colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withOpacity(0.3),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white, size: 22),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Text(
                        'Submit',
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
    );
  }

  Widget _buildResendSection(bool isSmallScreen) {
    return Column(
      children: [
        Text(
          "Haven't received OTP?",
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        if (_canResendOtp)
          TextButton(
            onPressed: _resendOtp,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: isSmallScreen ? 8 : 12,
              ),
            ),
            child: Text(
              'Send Again',
              style: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: isSmallScreen ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Send Again',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
              Icons.security,
              color: Colors.white.withOpacity(0.9),
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Secure OTP Verification System',
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
            'Protected • Encrypted • Safe',
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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}

// Reuse the RailwayBackgroundPainter from your login screen
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