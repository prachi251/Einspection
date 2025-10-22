import 'package:flutter/material.dart';

class AuthPortalScreen extends StatelessWidget {
  const AuthPortalScreen({super.key});

  void _railwayUserLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
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
              top: screenSize.height * 0.1,
              right: 30,
              child: Opacity(
                opacity: 0.1,
                child: Transform.rotate(
                  angle: 0.3,
                  child: const Icon(
                    Icons.train,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            Positioned(
              bottom: screenSize.height * 0.2,
              left: 20,
              child: Opacity(
                opacity: 0.08,
                child: Transform.rotate(
                  angle: -0.2,
                  child: const Icon(
                    Icons.directions_railway,
                    size: 100,
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
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),
                      
                      SizedBox(height: screenSize.height * 0.05),
                      
                      // Main Card
                      Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isSmallScreen ? screenSize.width - 32 : 450,
                            minHeight: screenSize.height * 0.6,
                          ),
                          child: Card(
                            elevation: 20,
                            shadowColor: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
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
                                padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildWelcomeSection(isSmallScreen),
                                    SizedBox(height: isSmallScreen ? 30 : 40),
                                    _buildAuthButtons(context, isSmallScreen),
                                    SizedBox(height: isSmallScreen ? 20 : 30),
                                    _buildInfoSection(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenSize.height * 0.05),
                      
                      // Footer
                      _buildFooter(),
                    ],
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
            Icons.account_circle,
            color: Colors.white,
            size: 48,
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Text(
          'Welcome to',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isSmallScreen ? 6 : 8),
        Text(
          'Railway E-Inspection Portal',
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
          'Use your Railway credentials to continue',
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

  Widget _buildAuthButtons(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        // Railway User Login Button
        _buildGradientButton(
          onPressed: () => _railwayUserLogin(context),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          ),
          icon: Icons.person,
          text: 'Railway User Login',
          shadowColor: const Color(0xFFFF6B35),
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required Gradient gradient,
    required IconData icon,
    required String text,
    String? subtitle,
    required Color shadowColor,
    required bool isSmallScreen,
  }) {
    return SizedBox(
      width: double.infinity,
      height: subtitle != null ? (isSmallScreen ? 70 : 80) : (isSmallScreen ? 55 : 60),
      child: ElevatedButton(
        onPressed: onPressed,
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
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            alignment: Alignment.center,
            child: subtitle != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: Colors.white, size: isSmallScreen ? 20 : 24),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: isSmallScreen ? 20 : 24),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Text(
                        text,
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

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[50]!,
            Colors.indigo[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Use your Railway employee credentials to access the E-Inspection Portal.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
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