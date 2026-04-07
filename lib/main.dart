import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:phir_wealth/landing_screen.dart';
import 'package:phir_wealth/login/views/login_screen.dart';
import 'package:phir_wealth/models/questions.dart';
import 'package:phir_wealth/models/services.dart';
import 'package:phir_wealth/onboarding_screens/advisor_signup/views/advisor_signup.dart';
import 'package:phir_wealth/onboarding_screens/corporate_signup/views/corporate_signup.dart';
import 'package:phir_wealth/onboarding_screens/customer_signup/views/customer_signup.dart';
import 'package:phir_wealth/onboarding_screens/partner_signup/views/partner_signup.dart';
import 'package:phir_wealth/profile/views/profile_screen.dart';
import 'package:phir_wealth/splash_screen.dart';

void main() {
  runApp(const PhirWealthApp());
}

class PhirWealthApp extends StatelessWidget {
  const PhirWealthApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phir Wealth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF9473B3),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF9473B3),
          secondary: Color(0xFF2F4EA1),
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9473B3),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF9473B3), width: 2),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
          case '/role-selection':
            return MaterialPageRoute(
              builder: (context) => const RoleSelectionScreen(),
            );
          case '/login':
            final role = settings.arguments as String?;

            return MaterialPageRoute(builder: (context) => LoginScreen(role!));
          case '/signup':
            final role = settings.arguments as String?;
            return MaterialPageRoute(
              builder: (context) => SignupRouterScreen(selectedRole: role),
            );
          case '/main':
            return MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
        }
      },
    );
  }
}

class SignupRouterScreen extends StatelessWidget {
  final String? selectedRole;

  const SignupRouterScreen({Key? key, this.selectedRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (selectedRole) {
      case 'Customer':
        return const CustomerSignupScreen();
      case 'Advisor':
        return const AdvisorSignupScreen();
      case 'Partner':
        return const PartnerSignupScreen();
      case 'Corporate':
        return const CorporateSignupScreen();
      default:
        return const CustomerSignupScreen();
    }
  }
}

// ==================== UPPER CASE TEXT FORMATTER ====================
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// ==================== SUCCESS ANIMATION SCREEN ====================
class QuestionnaireSuccessAnimation extends StatefulWidget {
  final VoidCallback onComplete;

  const QuestionnaireSuccessAnimation({Key? key, required this.onComplete})
    : super(key: key);

  @override
  State<QuestionnaireSuccessAnimation> createState() =>
      _QuestionnaireSuccessAnimationState();
}

class _QuestionnaireSuccessAnimationState
    extends State<QuestionnaireSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for checkmark
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Fade animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Rotation animation for confetti
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _rotationController.repeat();

    // Auto close after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    widget.onComplete();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Confetti Background
            Stack(
              alignment: Alignment.center,
              children: [
                // Confetti particles
                ...List.generate(12, (index) {
                  return AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      final angle = (index * 30.0) * 3.14159 / 180;
                      final distance = 80 * _rotationAnimation.value;
                      return Transform.translate(
                        offset: Offset(
                          distance *
                              cos(angle + _rotationAnimation.value * 6.28),
                          distance *
                              sin(angle + _rotationAnimation.value * 6.28),
                        ),
                        child: Opacity(
                          opacity: 1 - _rotationAnimation.value,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getConfettiColor(index),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                // Animated Checkmark Circle
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9473B3),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9473B3).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Animated Text
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9473B3),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your profile is complete',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let\'s start your wealth journey!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfettiColor(int index) {
    final colors = [
      const Color(0xFF9473B3),
      const Color(0xFF52B7E8),
      const Color(0xFF8E44AD),
      const Color(0xFF27AE60),
      const Color(0xFFE74C3C),
      const Color(0xFFF39C12),
    ];
    return colors[index % colors.length];
  }

  double cos(double angle) => math.cos(angle);
  double sin(double angle) => math.sin(angle);
}

// ==================== ABOUT SCREEN ====================
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF9473B3),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who We Are',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Phir Wealth is a financial wellness and wealth management platform dedicated to empowering individuals to make smarter, more informed financial decisions. We bring together expert guidance, innovative tools, and financial education to help you build and sustain long-term financial freedom.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF9473B3).withOpacity(0.2),
                      const Color(0xFF9473B3).withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 80,
                    color: Color(0xFF9473B3),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
                    ),
                  );
                },
                child: const Text('Learn More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== WHY US SCREEN ====================
class WhyUsScreen extends StatelessWidget {
  const WhyUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Why Choose Us'),
        backgroundColor: const Color(0xFF9473B3),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF394A71), Color(0xFF4B5D85)],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Why Choose Phir Wealth',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Our approach is rooted in transparency, trust, and deep expertise. Each plan is thoughtfully tailored to align with your unique goals, lifestyle, and aspirations.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFCBD5E1),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureItem(
                      Icons.person,
                      'Tailored Strategies',
                      'Financial strategies designed around your unique needs',
                    ),
                    _buildFeatureItem(
                      Icons.verified_user,
                      'Transparency & Integrity',
                      'A commitment to transparency and ethical practices',
                    ),
                    _buildFeatureItem(
                      Icons.emoji_events,
                      'Expert Team',
                      'Seasoned professionals bringing decades of expertise',
                    ),
                    _buildFeatureItem(
                      Icons.handshake,
                      'Long-term Partnership',
                      'A trusted partnership focused on your success',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9473B3),
                      ),
                      child: const Text('Talk to an Advisor'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF9473B3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFCBD5E1),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TESTIMONIALS SCREEN ====================
class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testimonials'),
        backgroundColor: const Color(0xFF9473B3),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'What Our Clients Say',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildTestimonialCard(
                'Phir Wealth helped me understand investing and grow my portfolio confidently.',
                'Ankit S.',
                'Entrepreneur',
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                'Professional, transparent, and supportive. Highly recommended!',
                'Priya R.',
                'Software Engineer',
              ),
              const SizedBox(height: 16),
              _buildTestimonialCard(
                'The financial literacy programs transformed my approach to money management.',
                'Rajesh M.',
                'Business Owner',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialCard(String text, String name, String role) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '"',
            style: TextStyle(
              fontSize: 40,
              color: Color(0xFF9473B3),
              height: 0.8,
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade800,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF9473B3).withOpacity(0.2),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Color(0xFF9473B3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    role,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== CONTACT SCREEN ====================
class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: const Color(0xFF9473B3),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9473B3), Color(0xFFD48B2C)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Text(
                      'Ready to Take Charge of Your Financial Future?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Let\'s kick off your journey with Phir Wealth and create a plan for financial freedom—step by step.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),
              _buildContactItem(Icons.email, 'info@phirwealth.com'),
              _buildContactItem(Icons.phone, '+91 XXXXX XXXXX'),
              _buildContactItem(Icons.location_on, 'Your Office Address Here'),
              const SizedBox(height: 30),
              const Text(
                'Follow Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSocialButton(Icons.business),
                  _buildSocialButton(Icons.facebook),
                  _buildSocialButton(Icons.camera_alt),
                  _buildSocialButton(Icons.alternate_email),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  '© 2025 Phir Wealth. All Rights Reserved.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF9473B3), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF52B7E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  static const Color _primary = Color(0xFF7C5CBF);

  final List<Widget> _screens = const [
    HomeScreen(),
    LoanScreen(),
    FinancialLiteracyScreen(),
    ProfileScreen(),
  ];

  final List<_NavItem> _items = const [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Loans',
    ),
    _NavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      label: 'Learn',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnims;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _items.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 220),
      ),
    );
    _scaleAnims = _controllers
        .map(
          (c) => Tween<double>(
            begin: 1.0,
            end: 1.15,
          ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutBack)),
        )
        .toList();
    _controllers[0].forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => _showQuestionnaire());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.lightImpact();
    _controllers[_currentIndex].reverse();
    _controllers[index].forward();
    setState(() => _currentIndex = index);
  }

  void _showQuestionnaire() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: QuestionnaireDialog(onCompleted: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false, // 👈 hides back button
        //   title: const Text("PHIR Wealth"),
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.logout),
        //       tooltip: "Logout",
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ],
        // ),
       // No extendBody — keeps screen content perfectly above nav bar
        // body: Center(
        //   child: Text(
        //     "Thank you! Our PHIR Wealth team will connect with you soon",
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        body: _screens[_currentIndex],

        bottomNavigationBar: _buildNavBar(),
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: List.generate(
              _items.length,
              (i) => Expanded(child: _buildNavItem(i)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isActive = _currentIndex == index;
    final item = _items[index];

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnims[index],
        builder: (_, __) => Transform.scale(
          scale: isActive ? _scaleAnims[index].value : 1.0,
          child: SizedBox(
            height: 72,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated pill for active icon
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: isActive ? 50 : 40,
                  height: 34,
                  decoration: isActive
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: _primary.withOpacity(0.28),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        )
                      : null,
                  child: Center(
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive ? Colors.white : const Color(0xFFB0BEC5),
                      size: isActive ? 20 : 22,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Label
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                    color: isActive ? _primary : const Color(0xFFB0BEC5),
                    letterSpacing: 0.1,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// ==================== QUESTIONNAIRE DIALOG (UPDATED) ====================
class QuestionnaireDialog extends StatefulWidget {
  final VoidCallback onCompleted;

  const QuestionnaireDialog({Key? key, required this.onCompleted})
    : super(key: key);

  @override
  State<QuestionnaireDialog> createState() => _QuestionnaireDialogState();
}

class _QuestionnaireDialogState extends State<QuestionnaireDialog> {
  int _currentQuestionIndex = 0;
  final Map<int, List<String>> _answers =
      {}; // Store List<String> for all questions

  final List<Question> _questions = [
    Question(
      question: 'What is your primary source of income?',
      options: ['Salary', 'Business', 'Commission / Agent'],
    ),
    Question(
      question: 'What is your income slab?',
      options: ['Less than ₹10 Lakh', '₹10 Lakh – ₹20 Lakh', 'Above ₹20 Lakh'],
    ),
    Question(
      question: 'What is your age group?',
      options: ['18 – 30 years', '30 – 50 years', 'Above 50 years'],
    ),
    Question(
      question: 'What is your investment time horizon?',
      options: ['Annual investments', 'Within 5 years', 'Within 10 years'],
    ),
    Question(
      question: 'Which type of loan have you taken? (Select all that apply)',
      options: [
        'Home Loan',
        'Personal Loan',
        'Vehicle Loan',
        'Education Loan',
        'Business Loan',
        'No Loan',
      ],
    ),
    Question(
      question: 'What percentage of your income do you save?',
      options: ['Less than 10%', '10% – 20%', '20% – 30%'],
    ),
    Question(
      question: 'What was the amount of the last loan you took?',
      options: ['Less than ₹1 Lakh', '₹3 Lakh – ₹5 Lakh', 'Above ₹5 Lakh'],
    ),
    Question(
      question: 'What was the value of the last asset you purchased?',
      options: ['Less than ₹1 Lakh', '₹3 Lakh – ₹5 Lakh', 'Above ₹5 Lakh'],
    ),
    Question(
      question: 'Do you earn rental income?',
      options: [
        'No rental income',
        'Yes, less than ₹5 Lakh per year',
        'Yes, ₹5 Lakh or more per year',
      ],
    ),
    Question(
      question: 'Do you regularly donate or contribute to charities?',
      options: ['No', 'Occasionally', 'Yes, regularly'],
    ),
    Question(
      question: 'How many credit cards do you currently have?',
      options: ['None', '1 – 2 credit cards', '3 or more credit cards'],
    ),
  ];

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeQuestionnaire();
    }
  }

  void _skipQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeQuestionnaire();
    }
  }

  void _completeQuestionnaire() {
    print('Questionnaire completed with answers: $_answers');

    Navigator.of(context).pop();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => QuestionnaireSuccessAnimation(
        onComplete: () {
          Navigator.of(context).pop();
          widget.onCompleted();

          // Show Wealth Report button dialog
          _showWealthReportDialog(context);
        },
      ),
    );
  }

  void _showWealthReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9473B3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assessment,
                  size: 48,
                  color: Color(0xFF9473B3),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Profile is Complete!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 12),
              // Text(
              //   'View your personalized wealth report to see insights and recommendations',
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: Colors.grey.shade600,
              //     height: 1.5,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF9473B3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // Expanded(
                  //   flex: 2,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const WealthReportScreen(),
                  //         ),
                  //       );
                  //     },
                  //     icon: const Icon(Icons.assessment, size: 20),
                  //     label: const Text('View Report'),
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 12),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleOption(String option) {
    setState(() {
      List<String> selectedOptions = _answers[_currentQuestionIndex] ?? [];

      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }

      _answers[_currentQuestionIndex] = selectedOptions;
    });
  }

  bool _isOptionSelected(String option) {
    List<String> selectedOptions = _answers[_currentQuestionIndex] ?? [];
    return selectedOptions.contains(option);
  }

  bool _canProceed() {
    List<String> selectedOptions = _answers[_currentQuestionIndex] ?? [];
    return selectedOptions.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9473B3),
                  ),
                ),
                TextButton(
                  onPressed: _skipQuestion,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                  ),
                  child: const Text('Skip'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF9473B3),
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              question.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'You can select multiple options',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = _isOptionSelected(option);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _toggleOption(option),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF9473B3).withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF9473B3)
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF9473B3)
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? const Color(0xFF9473B3)
                                    : Colors.white,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? const Color(0xFF9473B3)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentQuestionIndex--;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF9473B3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _nextQuestion : null,
                    child: Text(
                      _currentQuestionIndex == _questions.length - 1
                          ? 'Complete'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _WealthDashboardState();
}

class _WealthDashboardState extends State<HomeScreen> {
  bool hasPastPolicies = false;
  String? selectedIncomeSlab;
  String? selectedMonthlyInvestment;
  Set<String> selectedInvestmentModes = {};

  // ── Colors ────────────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF667EEA);
  static const Color _secondary = Color(0xFF764BA2);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _textDark = Color(0xFF1E1B4B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);
  static const Color _cardBg = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Welcome Amit,',
          style: TextStyle(
            color: _primary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: _primary,
                size: 24,
              ),
              onPressed: () {},
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: _primary.withOpacity(0.1),
              child: const Text(
                'A',
                style: TextStyle(
                  color: _primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioCard(),
            const SizedBox(height: 16),
            _buildQuickStats(),
            const SizedBox(height: 20),
            _buildSectionTitle(
              'Insurance',
              Icons.shield_outlined,
              const Color(0xFF667EEA),
            ),
            const SizedBox(height: 12),
            _buildInsuranceSection(),
            const SizedBox(height: 20),
            _buildSectionTitle(
              'Investment',
              Icons.trending_up_rounded,
              const Color(0xFFF5576C),
            ),
            const SizedBox(height: 12),
            _buildInvestmentSection(),
            const SizedBox(height: 20),
            _buildSectionTitle(
              'Tax Planning',
              Icons.account_balance_outlined,
              const Color(0xFF4FACFE),
            ),
            const SizedBox(height: 12),
            _buildTaxPlanningSection(),
            const SizedBox(height: 20),
            _buildSectionTitle(
              'Financial Goals',
              Icons.flag_outlined,
              const Color(0xFF43E97B),
            ),
            const SizedBox(height: 12),
            _buildFinancialGoalsSection(),
            const SizedBox(height: 20),
            _buildSectionTitle(
              'Quick Tools',
              Icons.grid_view_rounded,
              _primary,
            ),
            const SizedBox(height: 12),
            _buildQuickTools(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Section Title ─────────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  // ── Portfolio Card ────────────────────────────────────────────────────────
  Widget _buildPortfolioCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, Amit 👋',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Total Portfolio',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Text(
            '₹12,45,000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _portfolioChip(
                Icons.trending_up_rounded,
                '+12.5%',
                Colors.greenAccent,
              ),
              const SizedBox(width: 10),
              _portfolioChip(
                Icons.shield_outlined,
                '6 Policies',
                Colors.white70,
              ),
              const SizedBox(width: 10),
              _portfolioChip(
                Icons.savings_outlined,
                '₹46.8K Saved',
                Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _portfolioChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Stats ───────────────────────────────────────────────────────────
  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            '6',
            'Active Policies',
            Icons.shield_outlined,
            _primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            '₹46.8K',
            'Tax Saved',
            Icons.account_balance_wallet_outlined,
            const Color(0xFFF5576C),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            '₹25K',
            'Monthly SIP',
            Icons.trending_up_rounded,
            const Color(0xFF43E97B),
          ),
        ),
      ],
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: _textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Insurance Section ─────────────────────────────────────────────────────
  Widget _buildInsuranceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        children: [
          _insuranceRow(
            'Health Insurance',
            Icons.local_hospital_outlined,
            2,
            _primary,
          ),
          _insuranceRow(
            'Life Insurance',
            Icons.favorite_outline_rounded,
            1,
            _primary,
          ),
          _insuranceRow(
            'Term Insurance',
            Icons.description_outlined,
            0,
            _primary,
          ),
          _insuranceRow(
            'Motor Insurance',
            Icons.directions_car_outlined,
            1,
            _primary,
          ),
          _insuranceRow('Home & Travel', Icons.home_outlined, 0, _primary),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Have past policies?',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                Switch.adaptive(
                  value: hasPastPolicies,
                  onChanged: (v) => setState(() => hasPastPolicies = v),
                  activeColor: _primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _primaryButton('+ New Insurance Policy', _primary, () {}),
        ],
      ),
    );
  }

  Widget _insuranceRow(String title, IconData icon, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
          ),
          count > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              : Icon(Icons.chevron_right_rounded, color: _textLight, size: 20),
        ],
      ),
    );
  }

  // ── Investment Section ────────────────────────────────────────────────────
  Widget _buildInvestmentSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _dropdownField(
            label: 'Annual Income Slab',
            icon: Icons.account_balance_wallet_outlined,
            value: selectedIncomeSlab,
            hint: 'Select income range',
            items: const [
              DropdownMenuItem(value: '< 5L', child: Text('< ₹5 Lac')),
              DropdownMenuItem(value: '5-10L', child: Text('₹5–10 Lac')),
              DropdownMenuItem(value: '10-20L', child: Text('₹10–20 Lac')),
              DropdownMenuItem(value: '> 20L', child: Text('> ₹20 Lac')),
            ],
            onChanged: (v) => setState(() => selectedIncomeSlab = v),
          ),
          const SizedBox(height: 12),
          _dropdownField(
            label: 'Monthly Investment Capacity',
            icon: Icons.currency_rupee_rounded,
            value: selectedMonthlyInvestment,
            hint: 'Select investment range',
            items: const [
              DropdownMenuItem(value: '< 5K', child: Text('< ₹5,000')),
              DropdownMenuItem(value: '5-20K', child: Text('₹5,000 – ₹20,000')),
              DropdownMenuItem(
                value: '20-50K',
                child: Text('₹20,000 – ₹50,000'),
              ),
              DropdownMenuItem(value: '> 50K', child: Text('> ₹50,000')),
            ],
            onChanged: (v) => setState(() => selectedMonthlyInvestment = v),
          ),
          const SizedBox(height: 14),
          const Text(
            'Mode of Investment',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: _textMid,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                  'Stocks',
                  'Mutual Funds',
                  'Debentures',
                  'Fixed Deposits',
                  'PMS',
                  'Bonds',
                ].map((label) {
                  final selected = selectedInvestmentModes.contains(label);
                  return GestureDetector(
                    onTap: () => setState(() {
                      selected
                          ? selectedInvestmentModes.remove(label)
                          : selectedInvestmentModes.add(label);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? _primary : _bg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _primary : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : _textMid,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 16),
          _primaryButton(
            'Get Personalized Recommendations',
            const Color(0xFFF5576C),
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Getting personalized recommendations...',
                  ),
                  backgroundColor: _primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: _textMid,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 13, color: _textLight),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: _textDark,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: _primary.withOpacity(0.7), size: 18),
            filled: true,
            fillColor: _bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ── Tax Planning Section ──────────────────────────────────────────────────
  Widget _buildTaxPlanningSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        children: [
          _taxRow(
            'Income Tax Filing',
            Icons.receipt_long_outlined,
            'FY 24-25',
            const Color(0xFF4FACFE),
          ),
          _taxRow(
            '80C Deductions',
            Icons.savings_outlined,
            'Track',
            const Color(0xFF4FACFE),
          ),
          _taxRow(
            'GST Filing',
            Icons.description_outlined,
            'Pending',
            const Color(0xFFF5576C),
          ),
          _taxRow(
            'TDS Management',
            Icons.attach_money_rounded,
            'View',
            const Color(0xFF4FACFE),
          ),
          _taxRow(
            'Capital Gains Tax',
            Icons.show_chart_rounded,
            'Calculate',
            const Color(0xFF4FACFE),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF92400E),
                      ),
                      children: [
                        TextSpan(
                          text: 'Tip: ',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: 'Save ₹1,03,200 more under 80C this year!',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _primaryButton(
            'Optimize Tax Strategy',
            const Color(0xFF4FACFE),
            () {},
          ),
        ],
      ),
    );
  }

  Widget _taxRow(String title, IconData icon, String badge, Color color) {
    final isPending = badge == 'Pending';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isPending
                  ? const Color(0xFFF5576C).withOpacity(0.1)
                  : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: isPending ? const Color(0xFFF5576C) : color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Financial Goals Section ───────────────────────────────────────────────
  Widget _buildFinancialGoalsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(),
      child: Column(
        children: [
          _goalProgress(
            'House Purchase',
            65,
            '₹32.5L',
            '₹50L',
            const Color(0xFF667EEA),
          ),
          const SizedBox(height: 14),
          _goalProgress(
            'Child Education',
            40,
            '₹8L',
            '₹20L',
            const Color(0xFF43E97B),
          ),
          const SizedBox(height: 14),
          _goalProgress(
            'Retirement Fund',
            25,
            '₹25L',
            '₹1Cr',
            const Color(0xFFF5576C),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Add New Goal',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF43E97B),
              side: const BorderSide(color: Color(0xFF43E97B), width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalProgress(
    String title,
    int pct,
    String saved,
    String goal,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct / 100,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$saved saved of $goal',
          style: const TextStyle(
            fontSize: 11.5,
            color: _textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Quick Tools ───────────────────────────────────────────────────────────
  Widget _buildQuickTools() {
    final tools = [
      ('Retirement', Icons.beach_access_rounded, const Color(0xFFFA709A)),
      ('Estate', Icons.gavel_rounded, _primary),
      ('Loan Calc', Icons.calculate_outlined, const Color(0xFF4FACFE)),
      ('Credit Score', Icons.credit_score_rounded, const Color(0xFFF5576C)),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: tools.map((t) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t.$3.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(t.$2, color: t.$3, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  t.$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Shared Helpers ────────────────────────────────────────────────────────
  BoxDecoration _cardDecor() => BoxDecoration(
    color: _cardBg,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  );

  Widget _primaryButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showInsuranceDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('New Insurance Policy'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Policy Type'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  hint: const Text('Select policy type'),
                  items: const [
                    DropdownMenuItem(value: 'health', child: Text('Health')),
                    DropdownMenuItem(value: 'life', child: Text('Life')),
                    DropdownMenuItem(value: 'term', child: Text('Term')),
                    DropdownMenuItem(value: 'motor', child: Text('Motor')),
                    DropdownMenuItem(value: 'other', child: Text('Other')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                const Text('Full Name'),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter full name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Age'),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sum Assured'),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter sum assured',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Policy request submitted!'),
                    backgroundColor: Color(0xFF43E97B),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LOAN SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class LoanScreen extends StatelessWidget {
  const LoanScreen({Key? key}) : super(key: key);

  static const Color _primary = Color(0xFF7C5CBF);
  static const Color _secondary = Color(0xFF9473B3);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _textDark = Color(0xFF1E1B4B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);

  final List<Map<String, dynamic>> _loanTypes = const [
    {
      'title': 'Home Loan',
      'subtitle': 'Up to ₹5 Cr',
      'rate': '8.5% p.a.',
      'icon': Icons.home_rounded,
      'color': Color(0xFF667EEA),
      'tag': 'Most Popular',
    },
    {
      'title': 'Personal Loan',
      'subtitle': 'Up to ₹50 L',
      'rate': '10.9% p.a.',
      'icon': Icons.person_outline_rounded,
      'color': Color(0xFFF5576C),
      'tag': 'Instant',
    },
    {
      'title': 'Business Loan',
      'subtitle': 'Up to ₹2 Cr',
      'rate': '11.5% p.a.',
      'icon': Icons.business_center_outlined,
      'color': Color(0xFF43E97B),
      'tag': '',
    },
    {
      'title': 'Education Loan',
      'subtitle': 'Up to ₹75 L',
      'rate': '9.0% p.a.',
      'icon': Icons.school_outlined,
      'color': Color(0xFF4FACFE),
      'tag': '',
    },
    {
      'title': 'Car Loan',
      'subtitle': 'Up to ₹1 Cr',
      'rate': '9.5% p.a.',
      'icon': Icons.directions_car_outlined,
      'color': Color(0xFFFA709A),
      'tag': '',
    },
    {
      'title': 'Loan Against Property',
      'subtitle': 'Up to ₹10 Cr',
      'rate': '9.2% p.a.',
      'icon': Icons.villa_outlined,
      'color': Color(0xFFF59E0B),
      'tag': '',
    },
  ];

  final List<Map<String, dynamic>> _features = const [
    {
      'icon': Icons.bolt_rounded,
      'label': 'Instant\nApproval',
      'color': Color(0xFFF5576C),
    },
    {
      'icon': Icons.percent_rounded,
      'label': 'Low\nInterest',
      'color': Color(0xFF43E97B),
    },
    {
      'icon': Icons.description_outlined,
      'label': 'Min\nDocuments',
      'color': Color(0xFF4FACFE),
    },
    {
      'icon': Icons.support_agent_rounded,
      'label': '24/7\nSupport',
      'color': Color(0xFFF59E0B),
    },
  ];

  final List<Map<String, dynamic>> _steps = const [
    {
      'icon': Icons.edit_note_rounded,
      'title': 'Fill Application',
      'desc': 'Quick 3-min form',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'Upload Documents',
      'desc': 'Minimal paperwork',
    },
    {
      'icon': Icons.verified_outlined,
      'title': 'Get Approved',
      'desc': 'In 24–48 hours',
    },
    {
      'icon': Icons.account_balance_outlined,
      'title': 'Money Credited',
      'desc': 'Directly to your account',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Loans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.history_rounded, size: 16, color: _primary),
            label: const Text(
              'My Loans',
              style: TextStyle(
                color: _primary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            _buildFeatureStrip(),
            _buildLoanTypes(context),
            _buildEMICalculator(),
            _buildHowItWorks(),
            _buildEligibilityCard(),
            _buildDocumentsCard(),
            _buildApplyBanner(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Hero Banner ────────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C5CBF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '✨ Best rates guaranteed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Smart Loans,\nSimpler Life',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get funds in 24 hrs • Low interest • Zero hidden fees',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _heroBannerStat('₹500 Cr+', 'Disbursed')),
              Container(width: 1, height: 36, color: Colors.white24),
              Expanded(child: _heroBannerStat('50,000+', 'Happy Customers')),
              Container(width: 1, height: 36, color: Colors.white24),
              Expanded(child: _heroBannerStat('8.5%', 'Starting Rate')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBannerStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Feature Strip ──────────────────────────────────────────────────────────
  Widget _buildFeatureStrip() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _features.map((f) {
          final color = f['color'] as Color;
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(f['icon'] as IconData, color: color, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  f['label'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Loan Types ─────────────────────────────────────────────────────────────
  Widget _buildLoanTypes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Choose Your Loan'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemCount: _loanTypes.length,
            itemBuilder: (_, i) {
              final loan = _loanTypes[i];
              final color = loan['color'] as Color;
              final tag = loan['tag'] as String;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoanApplicationScreen(
                      loanType: loan['title'] as String,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Icon(
                              loan['icon'] as IconData,
                              color: color,
                              size: 18,
                            ),
                          ),
                          const Spacer(),
                          if (tag.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        loan['title'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            loan['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: _textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            loan['rate'] as String,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── EMI Calculator ─────────────────────────────────────────────────────────
  Widget _buildEMICalculator() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4FACFE).withOpacity(0.08),
            const Color(0xFF4FACFE).withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4FACFE).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EMI Calculator',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Plan your repayments before you apply',
                  style: TextStyle(fontSize: 12, color: _textMid),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FACFE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Calculate EMI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF4FACFE).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calculate_outlined,
              color: Color(0xFF4FACFE),
              size: 36,
            ),
          ),
        ],
      ),
    );
  }

  // ── How It Works ──────────────────────────────────────────────────────────
  Widget _buildHowItWorks() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('How It Works'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _steps.asMap().entries.map((e) {
                final i = e.key;
                final step = e.value;
                final isLast = i == _steps.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            step['icon'] as IconData,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _primary.withOpacity(0.4),
                                  _primary.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : 20,
                          top: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _textDark,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              step['desc'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _textLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Step ${i + 1}',
                        style: const TextStyle(
                          color: _primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Eligibility Card ──────────────────────────────────────────────────────
  Widget _buildEligibilityCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Eligibility Criteria'),
          const SizedBox(height: 14),
          ...[
            (Icons.cake_outlined, 'Age 21–65 years', const Color(0xFF667EEA)),
            (
              Icons.work_outline_rounded,
              'Salaried or Self-Employed',
              const Color(0xFF43E97B),
            ),
            (
              Icons.currency_rupee_rounded,
              'Min. income ₹15,000/month',
              const Color(0xFFF5576C),
            ),
            (
              Icons.credit_score_rounded,
              'CIBIL score 650+',
              const Color(0xFF4FACFE),
            ),
            (
              Icons.location_on_outlined,
              'Indian resident',
              const Color(0xFFF59E0B),
            ),
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: item.$3.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(item.$1, color: item.$3, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Documents Card ────────────────────────────────────────────────────────
  Widget _buildDocumentsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Documents Required'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      'Aadhaar Card',
                      'PAN Card',
                      'Bank Statement (3 months)',
                      'Salary Slips',
                      'ITR / Form 16',
                      'Address Proof',
                    ]
                    .map(
                      (doc) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _primary.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _primary.withOpacity(0.15)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: _primary,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              doc,
                              style: const TextStyle(
                                fontSize: 12,
                                color: _primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  // ── Apply Banner ──────────────────────────────────────────────────────────
  Widget _buildApplyBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF7C5CBF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ready to apply?',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get funds in\n24 hours!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoanApplicationScreen(
                        loanType: 'Personal Loan',
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Apply Now →',
                      style: TextStyle(
                        color: _primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.account_balance_rounded,
            color: Colors.white24,
            size: 80,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LOAN APPLICATION SCREEN
// ══════════════════════════════════════════════════════════════════════════════

class LoanApplicationScreen extends StatefulWidget {
  final String loanType;
  const LoanApplicationScreen({Key? key, required this.loanType})
    : super(key: key);

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  static const Color _primary = Color(0xFF7C5CBF);
  static const Color _fill = Color(0xFFF5F3FF);
  static const Color _textDark = Color(0xFF1E1B4B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _panController = TextEditingController();
  final _dobController = TextEditingController();
  final _amountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _purposeController = TextEditingController();
  final _incomeController = TextEditingController();
  final _employerController = TextEditingController();
  final _experienceController = TextEditingController();
  String? _employmentType;
  String? _loanPurpose;

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Personal', 'icon': Icons.person_outline_rounded},
    {'label': 'Loan', 'icon': Icons.currency_rupee_rounded},
    {'label': 'Employment', 'icon': Icons.work_outline_rounded},
    {'label': 'Review', 'icon': Icons.fact_check_outlined},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _panController.dispose();
    _dobController.dispose();
    _amountController.dispose();
    _tenureController.dispose();
    _purposeController.dispose();
    _incomeController.dispose();
    _employerController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  InputDecoration _dec({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: _textLight,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(color: _textLight.withOpacity(0.6), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFF9473B3), size: 20),
      filled: true,
      fillColor: _fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }

  TextStyle get _inputStyle => const TextStyle(
    fontSize: 14,
    color: _textDark,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _fill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _primary,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          widget.loanType,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.05, 0),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final isDone = _currentStep > i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: isDone ? _primary : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final idx = i ~/ 2;
          final isDone = _currentStep > idx;
          final isActive = _currentStep == idx;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDone
                      ? _primary
                      : isActive
                      ? _primary.withOpacity(0.12)
                      : const Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: _primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                      : Icon(
                          _steps[idx]['icon'] as IconData,
                          color: isActive ? _primary : _textLight,
                          size: 18,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _steps[idx]['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive || isDone
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isActive || isDone ? _primary : _textLight,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep--),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_ios_rounded, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Back',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C5CBF), Color(0xFF9473B3)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < 3) {
                    setState(() => _currentStep++);
                  } else {
                    _showSuccessDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentStep == 3 ? 'Submit Application' : 'Continue',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      _currentStep == 3
                          ? Icons.check_circle_outline_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalStep();
      case 1:
        return _buildLoanStep();
      case 2:
        return _buildEmploymentStep();
      case 3:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _stepHeader(String title, String sub, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.08), _primary.withOpacity(0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _primary.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C5CBF), Color(0xFF9473B3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  sub,
                  style: const TextStyle(fontSize: 12, color: _textMid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _primary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    ),
  );

  // Step 1 — Personal
  Widget _buildPersonalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Personal Details',
          'Tell us about yourself',
          Icons.person_outline_rounded,
        ),
        _label('Basic Info'),
        TextFormField(
          controller: _nameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(label: 'Full Name', icon: Icons.badge_outlined),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: _inputStyle,
          decoration: _dec(
            label: 'Email Address',
            icon: Icons.alternate_email_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          decoration: _dec(
            label: 'Mobile Number',
            icon: Icons.phone_iphone_rounded,
            hint: '+91 XXXXX XXXXX',
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        _label('Identity'),
        TextFormField(
          controller: _panController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.characters,
          decoration: _dec(
            label: 'PAN Card Number',
            icon: Icons.credit_card_rounded,
            hint: 'ABCDE1234F',
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dobController,
          style: _inputStyle,
          decoration: _dec(
            label: 'Date of Birth',
            icon: Icons.cake_outlined,
            hint: 'DD/MM/YYYY',
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  // Step 2 — Loan
  Widget _buildLoanStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Loan Details',
          'How much do you need?',
          Icons.currency_rupee_rounded,
        ),
        _label('Loan Amount & Tenure'),
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            label: 'Loan Amount (₹)',
            icon: Icons.currency_rupee_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _tenureController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            label: 'Tenure (months)',
            icon: Icons.calendar_month_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        _label('Purpose'),
        DropdownButtonFormField<String>(
          value: _loanPurpose,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(label: 'Loan Purpose', icon: Icons.flag_outlined),
          items: [
            'Home Purchase',
            'Home Renovation',
            'Medical Emergency',
            'Education',
            'Wedding',
            'Business',
            'Travel',
            'Debt Consolidation',
            'Other',
          ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (v) => setState(() => _loanPurpose = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _purposeController,
          maxLines: 2,
          style: _inputStyle,
          decoration: _dec(
            label: 'Additional Details (optional)',
            icon: Icons.notes_rounded,
          ),
        ),
      ],
    );
  }

  // Step 3 — Employment
  Widget _buildEmploymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Employment Details',
          'Your income and work details',
          Icons.work_outline_rounded,
        ),
        _label('Employment Type'),
        DropdownButtonFormField<String>(
          value: _employmentType,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            label: 'Employment Type',
            icon: Icons.business_center_outlined,
          ),
          items: [
            'Salaried',
            'Self-Employed',
            'Business Owner',
            'Freelancer',
            'Government Employee',
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _employmentType = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _employerController,
          style: _inputStyle,
          decoration: _dec(
            label: 'Employer / Company Name',
            icon: Icons.domain_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        _label('Financial Info'),
        TextFormField(
          controller: _incomeController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            label: 'Monthly Net Income (₹)',
            icon: Icons.account_balance_wallet_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            label: 'Work Experience (years)',
            icon: Icons.work_history_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  // Step 4 — Review
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _stepHeader(
          'Review Application',
          'Confirm your details before submitting',
          Icons.fact_check_outlined,
        ),
        _reviewCard('Personal Details', Icons.person_outline_rounded, [
          ('Name', _nameController.text.isEmpty ? '—' : _nameController.text),
          (
            'Email',
            _emailController.text.isEmpty ? '—' : _emailController.text,
          ),
          (
            'Mobile',
            _phoneController.text.isEmpty ? '—' : _phoneController.text,
          ),
          ('PAN', _panController.text.isEmpty ? '—' : _panController.text),
        ]),
        const SizedBox(height: 12),
        _reviewCard('Loan Details', Icons.currency_rupee_rounded, [
          ('Loan Type', widget.loanType),
          (
            'Amount',
            _amountController.text.isEmpty ? '—' : '₹${_amountController.text}',
          ),
          (
            'Tenure',
            _tenureController.text.isEmpty
                ? '—'
                : '${_tenureController.text} months',
          ),
          ('Purpose', _loanPurpose ?? '—'),
        ]),
        const SizedBox(height: 12),
        _reviewCard('Employment Details', Icons.work_outline_rounded, [
          ('Type', _employmentType ?? '—'),
          (
            'Employer',
            _employerController.text.isEmpty ? '—' : _employerController.text,
          ),
          (
            'Income',
            _incomeController.text.isEmpty
                ? '—'
                : '₹${_incomeController.text}/mo',
          ),
          (
            'Experience',
            _experienceController.text.isEmpty
                ? '—'
                : '${_experienceController.text} yrs',
          ),
        ]),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFF59E0B),
                size: 18,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'By submitting, you agree to our terms and authorize credit bureau checks.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reviewCard(
    String title,
    IconData icon,
    List<(String, String)> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primary, size: 16),
              const SizedBox(width: 7),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: _primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.$1,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: _textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.$2,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: _textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF43E97B).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We\'ve received your application. Our team will review and contact you within 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: _textMid, height: 1.5),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF43E97B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Ref: PW-2024-LOAN-XXXX',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF43E97B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 15,
                    ),
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

class WealthReportScreen extends StatefulWidget {
  const WealthReportScreen({Key? key}) : super(key: key);

  @override
  State<WealthReportScreen> createState() => _WealthReportScreenState();
}

class _WealthReportScreenState extends State<WealthReportScreen> {
  String _selectedPeriod = '1 Year';
  final List<String> _periods = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    'All Time',
  ];

  // ── Colors ────────────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF7C5CBF);
  static const Color _secondary = Color(0xFF667EEA);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _fill = Color(0xFFF5F3FF);
  static const Color _textDark = Color(0xFF1E1B4B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);
  static const Color _green = Color(0xFF22C55E);
  static const Color _red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _fill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _primary,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Wealth Report',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download_outlined,
              color: _primary,
              size: 22,
            ),
            onPressed: () => _showSnack(context, 'Downloading report...'),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: _primary, size: 22),
            onPressed: () => _showSnack(context, 'Sharing report...'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            _buildPeriodSelector(),
            _buildNetWorthCard(),
            const SizedBox(height: 4),
            _buildIncomeExpense(),
            _buildSection('Portfolio Breakdown', _buildPortfolioBreakdown()),
            _buildSection('Assets vs Liabilities', _buildAssetsLiabilities()),
            _buildSection('Financial Goals', _buildGoals()),
            _buildSection('Investment Performance', _buildPerformance()),
            _buildSection('AI Recommendations', _buildRecommendations()),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // ── Hero Banner ────────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.insert_chart_outlined_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Wealth Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'As of January 15, 2026',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Period Selector ────────────────────────────────────────────────────────
  Widget _buildPeriodSelector() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _periods.map((p) {
            final isSelected = p == _selectedPeriod;
            return GestureDetector(
              onTap: () => setState(() => _selectedPeriod = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _primary : _bg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? _primary : const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  p,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : _textMid,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Net Worth Card ─────────────────────────────────────────────────────────
  Widget _buildNetWorthCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4FACFE).withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Net Worth',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '₹45,67,850',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '↑ Increased by ₹5,08,925 this year',
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Income vs Expense ──────────────────────────────────────────────────────
  Widget _buildIncomeExpense() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _incomeExpenseItem(
              'Monthly Income',
              '₹1,25,000',
              Icons.arrow_circle_down_rounded,
              _green,
            ),
          ),
          Container(width: 1, height: 60, color: const Color(0xFFF1F5F9)),
          Expanded(
            child: _incomeExpenseItem(
              'Monthly Expenses',
              '₹78,500',
              Icons.arrow_circle_up_rounded,
              _red,
            ),
          ),
          Container(width: 1, height: 60, color: const Color(0xFFF1F5F9)),
          Expanded(
            child: _incomeExpenseItem(
              'Monthly Savings',
              '₹46,500',
              Icons.savings_outlined,
              _primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeExpenseItem(
    String label,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.5,
            color: _textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ── Portfolio Breakdown ────────────────────────────────────────────────────
  Widget _buildPortfolioBreakdown() {
    final items = [
      ('Mutual Funds', '₹18,50,000', 40.5, const Color(0xFF667EEA)),
      ('Stocks', '₹12,30,000', 26.9, const Color(0xFF7C5CBF)),
      ('Fixed Deposits', '₹8,50,000', 18.6, const Color(0xFF22C55E)),
      ('Gold', '₹4,20,000', 9.2, const Color(0xFFF59E0B)),
      ('Cash & Others', '₹2,17,850', 4.8, const Color(0xFFEF4444)),
    ];
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: item.$4,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            item.$1,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: _textDark,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                            ),
                          ),
                          Text(
                            '${item.$3.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: item.$3 / 100,
                      minHeight: 7,
                      backgroundColor: item.$4.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(item.$4),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Assets vs Liabilities ──────────────────────────────────────────────────
  Widget _buildAssetsLiabilities() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statBox(
                'Total Assets',
                '₹52,45,000',
                Icons.account_balance_outlined,
                _green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statBox(
                'Total Liabilities',
                '₹6,77,150',
                Icons.credit_card_outlined,
                _red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _fill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _primary.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.balance_rounded, color: _primary, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Asset to Liability Ratio',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Text(
                '7.7 : 1',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statBox(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: _textMid,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Financial Goals ────────────────────────────────────────────────────────
  Widget _buildGoals() {
    final goals = [
      (
        'Retirement Fund',
        65.0,
        '₹32,50,000',
        '₹50,00,000',
        const Color(0xFF667EEA),
        Icons.beach_access_rounded,
      ),
      (
        'Child Education',
        45.0,
        '₹9,00,000',
        '₹20,00,000',
        const Color(0xFF7C5CBF),
        Icons.school_outlined,
      ),
      (
        'Dream Home',
        30.0,
        '₹15,00,000',
        '₹50,00,000',
        const Color(0xFF22C55E),
        Icons.home_outlined,
      ),
    ];
    return Column(
      children: goals
          .map(
            (g) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: g.$5.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: g.$5.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: g.$5.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(g.$6, color: g.$5, size: 17),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          g.$1,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: g.$5.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${g.$2.toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: g.$5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: g.$2 / 100,
                      minHeight: 8,
                      backgroundColor: g.$5.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(g.$5),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved: ${g.$3}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Target: ${g.$4}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: _textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Investment Performance ─────────────────────────────────────────────────
  Widget _buildPerformance() {
    final metrics = [
      ('Total Invested', '₹38,50,000', false),
      ('Current Value', '₹45,67,850', false),
      ('Total Returns', '+ ₹7,17,850', true),
      ('ROI', '+18.6%', true),
      ('XIRR', '+14.2%', true),
    ];
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: metrics.asMap().entries.map((e) {
          final isLast = e.key == metrics.length - 1;
          final m = e.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      m.$1,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: _textMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      m.$2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: m.$3 ? _green : _textDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                  height: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 14,
                  endIndent: 14,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── AI Recommendations ─────────────────────────────────────────────────────
  Widget _buildRecommendations() {
    final recs = [
      (
        Icons.trending_up_rounded,
        'Increase SIP Amount',
        'Consider increasing your monthly SIP by ₹5,000 to reach your retirement goal 2 years faster.',
        const Color(0xFF667EEA),
      ),
      (
        Icons.health_and_safety_outlined,
        'Review Insurance Coverage',
        'Your life cover seems low. Consider upgrading to ₹1 Cr term plan for complete protection.',
        _red,
      ),
      (
        Icons.savings_outlined,
        'Emergency Fund Alert',
        'Your emergency fund covers only 3 months. Add ₹2,00,000 to reach the ideal 6-month buffer.',
        const Color(0xFFF59E0B),
      ),
    ];
    return Column(
      children: recs.asMap().entries.map((e) {
        final isLast = e.key == recs.length - 1;
        final r = e.value;
        return Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: r.$4.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: r.$4.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: r.$4.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(r.$1, color: r.$4, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.$2,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r.$3,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _textMid,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Section Wrapper ────────────────────────────────────────────────────────
  Widget _buildSection(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: _primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class FinancialLiteracyScreen extends StatefulWidget {
  const FinancialLiteracyScreen({Key? key}) : super(key: key);

  @override
  State<FinancialLiteracyScreen> createState() =>
      _FinancialLiteracyScreenState();
}

class _FinancialLiteracyScreenState extends State<FinancialLiteracyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  // ── Colors ────────────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF7C5CBF);
  static const Color _secondary = Color(0xFF667EEA);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _fill = Color(0xFFF5F3FF);
  static const Color _textDark = Color(0xFF1E1B4B);
  static const Color _textMid = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);

  final List<String> _categories = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Investment Fundamentals',
      'desc': 'Master stocks, bonds, and mutual funds from scratch',
      'icon': Icons.trending_up_rounded,
      'color': Color(0xFF667EEA),
      'lessons': 12,
      'duration': '4h 30m',
      'level': 'Beginner',
      'progress': 0.65,
      'enrolled': true,
    },
    {
      'title': 'Smart Budgeting & Saving',
      'desc': 'Build habits that grow your wealth every month',
      'icon': Icons.account_balance_wallet_outlined,
      'color': Color(0xFF43E97B),
      'lessons': 8,
      'duration': '2h 45m',
      'level': 'Beginner',
      'progress': 0.3,
      'enrolled': true,
    },
    {
      'title': 'Tax Planning Mastery',
      'desc': 'Legally save more with 80C, 80D & beyond',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF4FACFE),
      'lessons': 10,
      'duration': '3h 20m',
      'level': 'Intermediate',
      'progress': 0.0,
      'enrolled': false,
    },
    {
      'title': 'Retirement Blueprint',
      'desc': 'Plan your corpus and retire with confidence',
      'icon': Icons.beach_access_rounded,
      'color': Color(0xFFF59E0B),
      'lessons': 15,
      'duration': '5h 10m',
      'level': 'Intermediate',
      'progress': 0.0,
      'enrolled': false,
    },
    {
      'title': 'Stock Market Deep Dive',
      'desc': 'Technical & fundamental analysis for investors',
      'icon': Icons.candlestick_chart_outlined,
      'color': Color(0xFFF5576C),
      'lessons': 20,
      'duration': '8h 00m',
      'level': 'Advanced',
      'progress': 0.0,
      'enrolled': false,
    },
    {
      'title': 'Estate & Legacy Planning',
      'desc': 'Protect and pass on your wealth efficiently',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF9473B3),
      'lessons': 9,
      'duration': '3h 00m',
      'level': 'Advanced',
      'progress': 0.0,
      'enrolled': false,
    },
  ];

  final List<Map<String, dynamic>> _coaches = [
    {
      'name': 'Priya Sharma',
      'role': 'Wealth & Investment Advisor',
      'rating': '4.9',
      'sessions': '320+',
      'color': Color(0xFF667EEA),
      'initials': 'PS',
      'tags': ['Investments', 'SIP', 'Stocks'],
    },
    {
      'name': 'Rahul Mehta',
      'role': 'Tax Planning Expert',
      'rating': '4.8',
      'sessions': '210+',
      'color': Color(0xFF43E97B),
      'initials': 'RM',
      'tags': ['Tax', '80C', 'ITR Filing'],
    },
    {
      'name': 'Anita Joshi',
      'role': 'Retirement Specialist',
      'rating': '4.9',
      'sessions': '180+',
      'color': Color(0xFFF59E0B),
      'initials': 'AJ',
      'tags': ['Retirement', 'NPS', 'Pension'],
    },
  ];

  final List<Map<String, dynamic>> _webinars = [
    {
      'title': 'How to Build a ₹1 Cr Portfolio',
      'date': 'Sat, 1 Mar • 6:00 PM',
      'speaker': 'Priya Sharma',
      'color': Color(0xFF667EEA),
      'live': true,
    },
    {
      'title': 'Tax Saving Strategies FY 2024-25',
      'date': 'Sun, 2 Mar • 5:00 PM',
      'speaker': 'Rahul Mehta',
      'color': Color(0xFF4FACFE),
      'live': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Learn & Grow',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: _primary),
              onPressed: () {},
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: _primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: _primary,
          unselectedLabelColor: _textLight,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Courses'),
            Tab(text: 'Coaching'),
            Tab(text: 'Webinars'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCoursesTab(),
          _buildCoachingTab(),
          _buildWebinarsTab(),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 1 — Courses
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCoursesTab() {
    final filtered = _selectedCategory == 0
        ? _courses
        : _courses
              .where((c) => c['level'] == _categories[_selectedCategory])
              .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          _buildLearningBanner(),
          const SizedBox(height: 16),

          // My progress section
          _buildMyProgress(),
          const SizedBox(height: 20),

          // Category filter
          _sectionTitle('Browse Courses'),
          const SizedBox(height: 10),
          _buildCategoryFilter(),
          const SizedBox(height: 14),

          // Course cards
          ...filtered.map((c) => _buildCourseCard(c)).toList(),
        ],
      ),
    );
  }

  Widget _buildLearningBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🎯 Personalized for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Build Your\nFinancial IQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '6 courses • 3 expert coaches',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Continue Learning',
                      style: TextStyle(
                        color: _primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.school_rounded, color: Colors.white24, size: 80),
        ],
      ),
    );
  }

  Widget _buildMyProgress() {
    final enrolled = _courses.where((c) => c['enrolled'] == true).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Continue Learning'),
        const SizedBox(height: 10),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: enrolled.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final c = enrolled[i];
              final color = c['color'] as Color;
              final progress = c['progress'] as double;
              return Container(
                width: 220,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Icon(
                            c['icon'] as IconData,
                            color: color,
                            size: 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      c['title'] as String,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${c['lessons']} lessons • ${c['duration']}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: _textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: selected ? _primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? _primary : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : _textMid,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final color = course['color'] as Color;
    final progress = course['progress'] as double;
    final enrolled = course['enrolled'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(course['icon'] as IconData, color: color, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course['title'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course['level'] as String,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  course['desc'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      color: _textLight,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${course['lessons']} lessons',
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.access_time_rounded,
                      color: _textLight,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      course['duration'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (enrolled)
                      Text(
                        '${(progress * 100).toInt()}% done',
                        style: TextStyle(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primary, _secondary],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Enroll',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (enrolled) ...[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      backgroundColor: color.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 2 — Coaching
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCoachingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CTA banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primary.withOpacity(0.08),
                  _primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _primary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '1-on-1 Coaching',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Book a session with a certified wealth advisor and get a personalized roadmap.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: _textMid,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Book Free Session',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.support_agent_rounded,
                  color: _primary,
                  size: 60,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          _sectionTitle('Expert Coaches'),
          const SizedBox(height: 12),

          ..._coaches.map((coach) => _buildCoachCard(coach)).toList(),

          const SizedBox(height: 20),
          _sectionTitle('How Coaching Works'),
          const SizedBox(height: 12),
          _buildCoachingSteps(),
        ],
      ),
    );
  }

  Widget _buildCoachCard(Map<String, dynamic> coach) {
    final color = coach['color'] as Color;
    final tags = coach['tags'] as List<String>;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withOpacity(0.15),
                child: Text(
                  coach['initials'] as String,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coach['role'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _textMid,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          coach['rating'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.people_outline_rounded,
                          color: _textLight,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${coach['sessions']} sessions',
                          style: const TextStyle(
                            fontSize: 12,
                            color: _textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Text(
                  'Book',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingSteps() {
    final steps = [
      (
        Icons.person_search_rounded,
        'Choose a Coach',
        'Browse certified advisors',
      ),
      (
        Icons.calendar_today_rounded,
        'Book a Session',
        'Pick a time that suits you',
      ),
      (Icons.video_call_rounded, 'Online Meeting', '45-min video consultation'),
      (Icons.map_outlined, 'Get Your Roadmap', 'Custom financial plan for you'),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final s = e.value;
          final isLast = i == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(s.$1, color: Colors.white, size: 17),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 24,
                      color: _primary.withOpacity(0.15),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 18, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.$2,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      Text(
                        s.$3,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // TAB 3 — Webinars
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildWebinarsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Upcoming Webinars'),
          const SizedBox(height: 12),
          ..._webinars.map((w) => _buildWebinarCard(w)).toList(),

          const SizedBox(height: 20),
          _sectionTitle('Quick Tips'),
          const SizedBox(height: 12),
          _buildTipsGrid(),

          const SizedBox(height: 20),
          _sectionTitle('Financial Glossary'),
          const SizedBox(height: 12),
          _buildGlossaryCard(),
        ],
      ),
    );
  }

  Widget _buildWebinarCard(Map<String, dynamic> w) {
    final color = w['color'] as Color;
    final isLive = w['live'] as bool;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 6),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'UPCOMING',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            w['title'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 13, color: _textLight),
              const SizedBox(width: 4),
              Text(
                w['date'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.person_outline_rounded, size: 13, color: _textLight),
              const SizedBox(width: 4),
              Text(
                w['speaker'] as String,
                style: const TextStyle(
                  fontSize: 12,
                  color: _textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: isLive ? const Color(0xFFEF4444) : color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLive ? 'Join Now →' : 'Register Free',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsGrid() {
    final tips = [
      (
        Icons.savings_outlined,
        '50-30-20 Rule',
        'Split income wisely',
        Color(0xFF667EEA),
      ),
      (
        Icons.timeline_rounded,
        'Power of Compounding',
        'Start early, grow more',
        Color(0xFF43E97B),
      ),
      (
        Icons.shield_outlined,
        'Emergency Fund',
        'Keep 6 months of expenses',
        Color(0xFF4FACFE),
      ),
      (
        Icons.pie_chart_outline_outlined,
        'Asset Allocation',
        'Diversify for stability',
        Color(0xFFF59E0B),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: tips.map((t) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: t.$4.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(t.$1, color: t.$4, size: 18),
              ),
              const Spacer(),
              Text(
                t.$2,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                t.$3,
                style: const TextStyle(
                  fontSize: 11,
                  color: _textLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGlossaryCard() {
    final terms = [
      ('SIP', 'Systematic Investment Plan — invest fixed amounts regularly'),
      ('CAGR', 'Compound Annual Growth Rate — year-over-year growth rate'),
      ('NAV', 'Net Asset Value — price per unit of a mutual fund'),
      ('ELSS', 'Equity Linked Savings Scheme — tax-saving mutual fund'),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: terms.asMap().entries.map((e) {
          final isLast = e.key == terms.length - 1;
          final t = e.value;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _fill,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      t.$1,
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.$2,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _textMid,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: _primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
      ],
    );
  }
}
