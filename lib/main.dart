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
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFE89E3C),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE89E3C),
          secondary: Color(0xFF52B7E8),
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: false),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE89E3C),
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
            borderSide: const BorderSide(color: Color(0xFFE89E3C), width: 2),
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
            return MaterialPageRoute(builder: (context) => const LoginScreen());
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
                      color: const Color(0xFFE89E3C),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE89E3C).withOpacity(0.3),
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
                      color: Color(0xFFE89E3C),
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
      const Color(0xFFE89E3C),
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
        backgroundColor: const Color(0xFFE89E3C),
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
                      const Color(0xFFE89E3C).withOpacity(0.2),
                      const Color(0xFFE89E3C).withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 80,
                    color: Color(0xFFE89E3C),
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
        backgroundColor: const Color(0xFFE89E3C),
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
                        foregroundColor: const Color(0xFFE89E3C),
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
              color: const Color(0xFFE89E3C),
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
        backgroundColor: const Color(0xFFE89E3C),
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
              color: Color(0xFFE89E3C),
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
                backgroundColor: const Color(0xFFE89E3C).withOpacity(0.2),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Color(0xFFE89E3C),
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
        backgroundColor: const Color(0xFFE89E3C),
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
                    colors: [Color(0xFFE89E3C), Color(0xFFD48B2C)],
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
          Icon(icon, color: const Color(0xFFE89E3C), size: 24),
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

// ==================== MAIN NAVIGATION SCREEN ====================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  bool _questionnaireCompleted = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    ServicesScreen(),
    FourQuadrantsScreen(),
    FinancialLiteracyScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Show questionnaire after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowQuestionnaire();
    });
  }

  Future<void> _checkAndShowQuestionnaire() async {
    _showQuestionnaire();
  }

  void _showQuestionnaire() {
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot dismiss by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button dismiss
          child: QuestionnaireDialog(
            onCompleted: () async {
              setState(() {
                _questionnaireCompleted = true;
              });

              // TODO: Save completion status to SharedPreferences
              // final prefs = await SharedPreferences.getInstance();
              // await prefs.setBool('questionnaire_completed', true);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE89E3C),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Services'),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Quadrants',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
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
                  color: const Color(0xFFE89E3C).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assessment,
                  size: 48,
                  color: Color(0xFFE89E3C),
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
              const SizedBox(height: 12),
              Text(
                'View your personalized wealth report to see insights and recommendations',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
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
                        side: const BorderSide(color: Color(0xFFE89E3C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Later'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WealthReportScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assessment, size: 20),
                      label: const Text('View Report'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
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
                    color: Color(0xFFE89E3C),
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
                  Color(0xFFE89E3C),
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
                              ? const Color(0xFFE89E3C).withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE89E3C)
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
                                      ? const Color(0xFFE89E3C)
                                      : Colors.grey[400]!,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? const Color(0xFFE89E3C)
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
                                      ? const Color(0xFFE89E3C)
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
                        side: const BorderSide(color: Color(0xFFE89E3C)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Phir Wealth',
          style: TextStyle(
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF667EEA),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF667EEA),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 20),
            _buildQuickStats(),
            const SizedBox(height: 24),
            _buildInsuranceSection(),
            const SizedBox(height: 20),
            _buildInvestmentSection(),
            const SizedBox(height: 20),
            _buildTaxPlanningSection(),
            const SizedBox(height: 20),
            _buildFinancialGoalsSection(),
            const SizedBox(height: 20),
            _buildAdditionalFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back!',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your Financial Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Portfolio',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    '₹12,45,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '6',
            'Active Policies',
            Icons.shield_outlined,
            const Color(0xFF667EEA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '₹46,800',
            'Tax Saved',
            Icons.account_balance_wallet_outlined,
            const Color(0xFFF5576C),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '₹25,000',
            'Monthly SIP',
            Icons.trending_up,
            const Color(0xFF43E97B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildInsuranceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Insurance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInsuranceItem('Health Insurance', Icons.local_hospital, 2),
          _buildInsuranceItem('Life Insurance', Icons.favorite, 1),
          _buildInsuranceItem('Term Insurance', Icons.description, 0),
          _buildInsuranceItem('Motor Insurance', Icons.directions_car, 1),
          _buildInsuranceItem('Others (Home, Travel)', Icons.home, 0),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Have past policies?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Switch(
                value: hasPastPolicies,
                onChanged: (value) {
                  setState(() {
                    hasPastPolicies = value;
                  });
                },
                activeColor: const Color(0xFF667EEA),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showInsuranceDetailsDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '+ New Insurance Policy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceItem(String title, IconData icon, int activeCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF667EEA), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          if (activeCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$activeCount Active',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildInvestmentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Investment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Annual Income Slab',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedIncomeSlab,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text('Select income range'),
            items: const [
              DropdownMenuItem(value: '< 5L', child: Text('< ₹5 Lac')),
              DropdownMenuItem(value: '5-10L', child: Text('₹5-10 Lac')),
              DropdownMenuItem(value: '10-20L', child: Text('₹10-20 Lac')),
              DropdownMenuItem(value: '> 20L', child: Text('> ₹20 Lac')),
            ],
            onChanged: (value) {
              setState(() {
                selectedIncomeSlab = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Monthly Investment Capacity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedMonthlyInvestment,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text('Select investment range'),
            items: const [
              DropdownMenuItem(value: '< 5K', child: Text('< ₹5,000')),
              DropdownMenuItem(value: '5-20K', child: Text('₹5,000 - ₹20,000')),
              DropdownMenuItem(
                value: '20-50K',
                child: Text('₹20,000 - ₹50,000'),
              ),
              DropdownMenuItem(value: '> 50K', child: Text('> ₹50,000')),
            ],
            onChanged: (value) {
              setState(() {
                selectedMonthlyInvestment = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Mode of Investment',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInvestmentChip('Stocks'),
              _buildInvestmentChip('Mutual Funds'),
              _buildInvestmentChip('Debentures'),
              _buildInvestmentChip('Fixed Deposits'),
              _buildInvestmentChip('PMS'),
              _buildInvestmentChip('Bonds'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Getting personalized recommendations...'),
                    backgroundColor: Color(0xFF667EEA),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5576C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Personalized Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentChip(String label) {
    final isSelected = selectedInvestmentModes.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            selectedInvestmentModes.add(label);
          } else {
            selectedInvestmentModes.remove(label);
          }
        });
      },
      selectedColor: const Color(0xFF667EEA).withOpacity(0.2),
      checkmarkColor: const Color(0xFF667EEA),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF667EEA) : const Color(0xFF4A5568),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: const Color(0xFFF7FAFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFF667EEA) : Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildTaxPlanningSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tax Planning',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTaxItem('Income Tax Filing', Icons.receipt_long, 'FY 24-25'),
          _buildTaxItem('80C Deductions', Icons.savings, 'Track'),
          _buildTaxItem('GST Filing', Icons.description, 'Pending'),
          _buildTaxItem('TDS Management', Icons.attach_money, 'View'),
          _buildTaxItem('Capital Gains Tax', Icons.show_chart, 'Calculate'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFFF59E0B),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                      children: [
                        TextSpan(
                          text: 'Tax Saving Tip: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              'You can save ₹1,03,200 more under 80C this year!',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4FACFE),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Optimize Tax Strategy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxItem(String title, IconData icon, String badge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4FACFE), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4FACFE).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(0xFF4FACFE),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialGoalsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Financial Goals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGoalProgress('House Purchase', 65, '₹32.5L', '₹50L'),
          const SizedBox(height: 16),
          _buildGoalProgress('Child Education', 40, '₹8L', '₹20L'),
          const SizedBox(height: 16),
          _buildGoalProgress('Retirement Fund', 25, '₹25L', '₹1Cr'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFF43E97B), width: 2),
              ),
              child: const Text(
                '+ Add New Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF43E97B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(
    String title,
    int percentage,
    String saved,
    String goal,
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
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF43E97B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF43E97B)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$saved saved of $goal goal',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAdditionalFeatures() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Retirement Planning',
                Icons.beach_access,
                const Color(0xFFFA709A),
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Estate Planning',
                Icons.gavel,
                const Color(0xFF667EEA),
                () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                'Loan Calculator',
                Icons.calculate,
                const Color(0xFF4FACFE),
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                'Credit Score',
                Icons.credit_score,
                const Color(0xFFF5576C),
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
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

// ==================== SERVICES SCREEN ====================
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line
        title: const Text('Our Services'),
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Path to Success',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE89E3C),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'From Education to Earn & Investment to get better Return',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildServiceCard(
                context,
                Icons.school,
                'Financial Education and Personalized Coaching',
                'Build a strong foundation with expert guidance and personalized learning.',
                const Color(0xFF52B7E8),
                ServiceDetailData(
                  title: 'Financial Education and Personalized Coaching',
                  icon: Icons.school,
                  color: Color(0xFF52B7E8),
                  description:
                      'Begin your path to success with comprehensive financial education. We believe that informed decisions lead to better outcomes. Our personalized coaching program empowers you with the knowledge and confidence to navigate your financial journey effectively.',
                  features: [
                    'Interactive financial literacy workshops and webinars',
                    'One-on-one coaching with certified wealth advisors',
                    'Customized learning modules based on your financial goals',
                    'Real-world case studies and practical exercises',
                    'Access to exclusive financial tools and calculators',
                    'Monthly progress tracking and milestone reviews',
                    'Community support and peer learning opportunities',
                  ],
                  benefits: [
                    'Understand fundamental and advanced financial concepts',
                    'Make informed investment decisions with confidence',
                    'Develop healthy financial habits and discipline',
                    'Learn to identify opportunities and avoid common pitfalls',
                    'Build a personalized roadmap to financial success',
                  ],
                  ctaTitle: 'Start Your Learning Journey',
                  ctaDescription:
                      'Get educated and take the first step towards financial success',
                ),
              ),
              _buildServiceCard(
                context,
                Icons.trending_up,
                'Investment, Portfolio & Retirement Planning',
                'Strategic investment solutions for wealth creation and secure retirement.',
                const Color(0xFF8E44AD),
                ServiceDetailData(
                  title: 'Investment, Portfolio & Retirement Planning',
                  icon: Icons.trending_up,
                  color: Color(0xFF8E44AD),
                  description:
                      'Turn your education into earnings with strategic investment and retirement planning. Our comprehensive wealth management services help you invest wisely, earn consistently, and build a substantial retirement corpus, ensuring your money works as hard as you do to achieve better returns and a secure future.',
                  features: [
                    'Personalized investment strategies aligned with your risk profile',
                    'Diversified portfolio across equity, debt, mutual funds, and alternatives',
                    'Comprehensive retirement corpus calculation and planning',
                    'Goal-based SIP and investment planning',
                    'Active portfolio monitoring and timely rebalancing',
                    'Tax-efficient investment planning and execution',
                    'Retirement income planning with pension and annuity optimization',
                    'Regular portfolio review meetings and strategy updates',
                    'Access to premium investment opportunities',
                    'Healthcare and medical expense planning for retirement',
                  ],
                  benefits: [
                    'Maximize returns while managing risk effectively',
                    'Build adequate retirement corpus for financial independence',
                    'Benefit from professional expertise and market insights',
                    'Achieve consistent growth across market cycles',
                    'Retire with dignity and maintain desired lifestyle',
                    'Create multiple income streams for post-retirement',
                  ],
                  ctaTitle: 'Grow Your Wealth & Secure Retirement',
                  ctaDescription:
                      'Invest smartly, earn better returns, and plan a comfortable retirement',
                ),
              ),
              _buildServiceCard(
                context,
                Icons.receipt_long,
                'Tax Planning and Wealth Enhancement',
                'Optimize taxes and enhance wealth through strategic planning.',
                const Color(0xFF27AE60),
                ServiceDetailData(
                  title: 'Tax Planning and Wealth Enhancement',
                  icon: Icons.receipt_long,
                  color: Color(0xFF27AE60),
                  description:
                      'Enhance your returns through smart tax planning. Every rupee saved in taxes is a rupee earned. Our comprehensive tax strategies help you legally minimize tax liability while maximizing wealth accumulation, giving you better net returns on your investments.',
                  features: [
                    'Year-round strategic tax planning and optimization',
                    'Tax-saving investment recommendations under 80C, 80D, and other sections',
                    'Income tax return filing and compliance management',
                    'Tax-loss harvesting and capital gains optimization',
                    'GST planning for business owners and professionals',
                    'TDS and advance tax planning',
                    'Estate and inheritance tax planning strategies',
                    'Regular updates on changing tax laws and implications',
                  ],
                  benefits: [
                    'Reduce tax burden through legal optimization strategies',
                    'Increase after-tax returns on your investments',
                    'Stay compliant with all tax regulations effortlessly',
                    'Preserve more wealth for future goals',
                    'Get expert guidance on complex tax matters',
                  ],
                  ctaTitle: 'Optimize Your Taxes',
                  ctaDescription:
                      'Save more and enhance your wealth with smart tax planning',
                ),
              ),
              _buildServiceCard(
                context,
                Icons.account_balance_wallet,
                'Financial Support & Assistance',
                'Get expert guidance and support for all your financial needs.',
                const Color(0xFFF39C12),
                ServiceDetailData(
                  title: 'Financial Support & Assistance',
                  icon: Icons.account_balance_wallet,
                  color: Color(0xFFF39C12),
                  description:
                      'Comprehensive financial support when you need it most. Whether you\'re facing a financial challenge, planning a major purchase, or need guidance on loans and credit, our expert team provides personalized support to help you make the right financial decisions and maintain stability.',
                  features: [
                    'Personal loan and home loan advisory',
                    'Credit score improvement strategies',
                    'Debt consolidation and management planning',
                    'Emergency fund planning and management',
                    'Insurance planning (Life, Health, Term)',
                    'Financial crisis management and counseling',
                    'Budget optimization and expense management',
                    'EMI restructuring and loan refinancing guidance',
                    '24/7 financial advisory support',
                    'Education and marriage loan planning',
                  ],
                  benefits: [
                    'Get expert help during financial emergencies',
                    'Access best loan deals and interest rates',
                    'Improve your credit profile systematically',
                    'Manage and eliminate debt efficiently',
                    'Build financial resilience and security',
                    'Make informed borrowing decisions',
                  ],
                  ctaTitle: 'Get Financial Support',
                  ctaDescription:
                      'Connect with our experts for personalized financial assistance',
                ),
              ),
              _buildServiceCard(
                context,
                Icons.account_balance,
                'Estate and Legacy Management',
                'Preserve and transfer your wealth to future generations efficiently.',
                const Color(0xFFE74C3C),
                ServiceDetailData(
                  title: 'Estate and Legacy Management',
                  icon: Icons.account_balance,
                  color: Color(0xFFE74C3C),
                  description:
                      'Protect and transfer your earned wealth efficiently. After years of education, earning, and smart investments that delivered better returns, ensure your legacy is preserved and passed on smoothly to your loved ones according to your wishes, with minimal tax impact.',
                  features: [
                    'Comprehensive estate planning and documentation',
                    'Will drafting and legal documentation services',
                    'Trust creation and management',
                    'Nomination and beneficiary optimization',
                    'Asset protection and succession planning',
                    'Family wealth governance and conflict resolution',
                    'Charitable giving and philanthropy planning',
                    'Power of attorney and guardianship planning',
                    'Regular estate plan reviews and updates',
                  ],
                  benefits: [
                    'Protect your hard-earned assets for your family',
                    'Minimize estate taxes and legal complications',
                    'Ensure smooth wealth transfer to next generation',
                    'Avoid family disputes and legal challenges',
                    'Create a lasting legacy aligned with your values',
                  ],
                  ctaTitle: 'Plan Your Legacy',
                  ctaDescription:
                      'Preserve your wealth and create a lasting impact for generations',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
    ServiceDetailData detailData,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailScreen(data: detailData),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 40, color: color),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SERVICE DETAIL SCREEN ====================
class ServiceDetailScreen extends StatelessWidget {
  final ServiceDetailData data;

  const ServiceDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: data.color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                data.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [data.color, data.color.withOpacity(0.7)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    data.icon,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  _buildSectionTitle('Overview'),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features Section
                  _buildSectionTitle('What We Offer'),
                  const SizedBox(height: 16),
                  ...data.features.map((feature) => _buildFeatureItem(feature)),
                  const SizedBox(height: 32),

                  // Benefits Section
                  _buildSectionTitle('Key Benefits'),
                  const SizedBox(height: 16),
                  ...data.benefits.map((benefit) => _buildBenefitItem(benefit)),
                  const SizedBox(height: 32),

                  // Call to Action
                  _buildCTASection(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 20, color: data.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 20, color: data.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.color.withOpacity(0.1), data.color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: data.color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.support_agent, size: 48, color: data.color),
          const SizedBox(height: 16),
          Text(
            data.ctaTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            data.ctaDescription,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling advisor...')),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Call Now'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: data.color,
                    side: BorderSide(color: data.color, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening schedule form...')),
                    );
                  },
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: data.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== WEALTH REPORT SCREEN ====================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Wealth Report'),
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading report...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing report...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              _buildPeriodSelector(),
              _buildNetWorthCard(),
              _buildPortfolioBreakdown(),
              _buildGoalsProgress(),
              _buildIncomeExpenseSection(),
              _buildAssetLiabilitySection(),
              _buildInvestmentPerformance(),
              _buildRecommendations(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFFE89E3C), const Color(0xFFD48B2C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assessment,
                  size: 32,
                  color: Colors.white,
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'As of January 15, 2026',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _periods.map((period) {
            final isSelected = period == _selectedPeriod;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(period),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                },
                selectedColor: const Color(0xFFE89E3C),
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                elevation: isSelected ? 2 : 0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNetWorthCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF52B7E8),
            const Color(0xFF52B7E8).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF52B7E8).withOpacity(0.3),
            blurRadius: 12,
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
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '₹45,67,850',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Increased by ₹5,08,925 this year',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioBreakdown() {
    return _buildSection(
      'Portfolio Breakdown',
      Column(
        children: [
          _buildPortfolioItem(
            'Mutual Funds',
            '₹18,50,000',
            40.5,
            const Color(0xFF52B7E8),
          ),
          _buildPortfolioItem(
            'Stocks',
            '₹12,30,000',
            26.9,
            const Color(0xFF8E44AD),
          ),
          _buildPortfolioItem(
            'Fixed Deposits',
            '₹8,50,000',
            18.6,
            const Color(0xFF27AE60),
          ),
          _buildPortfolioItem(
            'Gold',
            '₹4,20,000',
            9.2,
            const Color(0xFFF39C12),
          ),
          _buildPortfolioItem(
            'Cash & Others',
            '₹2,17,850',
            4.8,
            const Color(0xFFE74C3C),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioItem(
    String name,
    String value,
    double percentage,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsProgress() {
    return _buildSection(
      'Financial Goals Progress',
      Column(
        children: [
          _buildGoalCard(
            'Retirement Fund',
            65,
            '₹32,50,000',
            '₹50,00,000',
            const Color(0xFF52B7E8),
          ),
          const SizedBox(height: 12),
          _buildGoalCard(
            'Child Education',
            45,
            '₹9,00,000',
            '₹20,00,000',
            const Color(0xFF8E44AD),
          ),
          const SizedBox(height: 12),
          _buildGoalCard(
            'Dream Home',
            30,
            '₹15,00,000',
            '₹50,00,000',
            const Color(0xFF27AE60),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(
    String title,
    double progress,
    String achieved,
    String target,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '${progress.toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Achieved: $achieved',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              Text(
                'Target: $target',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseSection() {
    return _buildSection(
      'Income vs Expenses',
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF27AE60).withOpacity(0.1),
              const Color(0xFFE74C3C).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildIncomeExpenseCard(
                'Monthly Income',
                '₹1,25,000',
                Icons.arrow_downward,
                const Color(0xFF27AE60),
              ),
            ),
            Container(width: 1, height: 60, color: Colors.grey.shade300),
            Expanded(
              child: _buildIncomeExpenseCard(
                'Monthly Expenses',
                '₹78,500',
                Icons.arrow_upward,
                const Color(0xFFE74C3C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard(
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetLiabilitySection() {
    return _buildSection(
      'Assets vs Liabilities',
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  'Total Assets',
                  '₹52,45,000',
                  const Color(0xFF27AE60),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatBox(
                  'Total Liabilities',
                  '₹6,77,150',
                  const Color(0xFFE74C3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF52B7E8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF52B7E8).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Asset to Liability Ratio',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '7.7:1',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF52B7E8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentPerformance() {
    return _buildSection(
      'Investment Performance',
      Column(
        children: [
          _buildPerformanceMetric('Total Invested', '₹38,50,000'),
          _buildPerformanceMetric('Current Value', '₹45,67,850'),
          _buildPerformanceMetric(
            'Total Returns',
            '₹7,17,850',
            isPositive: true,
          ),
          _buildPerformanceMetric('ROI', '+18.6%', isPositive: true),
          _buildPerformanceMetric('XIRR', '+14.2%', isPositive: true),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetric(
    String label,
    String value, {
    bool isPositive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive
                  ? const Color(0xFF27AE60)
                  : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return _buildSection(
      'AI Recommendations',
      Column(
        children: [
          _buildRecommendationCard(
            Icons.trending_up,
            'Increase SIP Amount',
            'Consider increasing your monthly SIP by ₹5,000 to reach retirement goal faster',
            const Color(0xFF52B7E8),
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            Icons.shield,
            'Review Insurance Coverage',
            'Your life insurance coverage seems low. Consider increasing it to ₹1 Cr',
            const Color(0xFFE74C3C),
          ),
          const SizedBox(height: 12),
          _buildRecommendationCard(
            Icons.savings,
            'Emergency Fund Alert',
            'Your emergency fund is below 6 months of expenses. Add ₹2,00,000 more',
            const Color(0xFFF39C12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ==================== FOUR QUADRANTS SCREEN ====================
class FourQuadrantsScreen extends StatelessWidget {
  const FourQuadrantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line

        title: const Text('Four Quadrants'),
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                'Four Quadrants of Phir Wealth',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Our comprehensive approach to your financial success',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.9,
                children: [
                  _buildQuadrantCard(
                    Icons.trending_up,
                    'Wealth Building',
                    'Strategic investment and portfolio management',
                    const Color(0xFF52B7E8),
                  ),
                  _buildQuadrantCard(
                    Icons.shield,
                    'Wealth Protection',
                    'Insurance and risk management solutions',
                    const Color(0xFF7BC96F),
                  ),
                  _buildQuadrantCard(
                    Icons.school,
                    'Financial Education',
                    'Learning and coaching for financial literacy',
                    const Color(0xFFE89E3C),
                  ),
                  _buildQuadrantCard(
                    Icons.account_balance,
                    'Legacy Planning',
                    'Estate and succession planning',
                    const Color(0xFFAB89C8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuadrantCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ==================== FINANCIAL LITERACY SCREEN ====================
class FinancialLiteracyScreen extends StatelessWidget {
  const FinancialLiteracyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line

        title: const Text('Financial Literacy'),
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial Literacy & Training',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Empowering you with knowledge to make better financial decisions',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              _buildLiteracyModule(
                Icons.book,
                'Investment Basics',
                'Learn the fundamentals of investing and portfolio management',
              ),
              _buildLiteracyModule(
                Icons.pie_chart,
                'Budgeting & Saving',
                'Master the art of budgeting and building your savings',
              ),
              _buildLiteracyModule(
                Icons.account_balance_wallet,
                'Tax Planning',
                'Understand tax optimization strategies and benefits',
              ),
              _buildLiteracyModule(
                Icons.trending_up,
                'Retirement Planning',
                'Plan your retirement with confidence and security',
              ),
              _buildLiteracyModule(
                Icons.security,
                'Risk Management',
                'Protect your wealth with proper insurance and planning',
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Start Learning'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiteracyModule(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE89E3C).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: const Color(0xFFE89E3C)),
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
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
