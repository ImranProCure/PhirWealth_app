import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phir_wealth/main.dart';
import 'package:phir_wealth/onboarding_screens/customer_signup/views/verify_otp.dart';

class CustomerSignupScreen extends StatefulWidget {
  const CustomerSignupScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSignupScreen> createState() => _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends State<CustomerSignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _altContactController = TextEditingController();
  final _pancardController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _locationController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  DateTime? _selectedDOB;
  String? _selectedMotherTongue;
  final Set<String> _selectedInterests = {};

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Brand Colors — matching login & role selection screens
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);
  static const Color _textDark = Color(0xFF0F172A);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFFB0B8C1);
  static const Color _bgColor = Color(0xFFF8F8FF);

  final List<String> _motherTongues = [
    'Hindi',
    'English',
    'Bengali',
    'Telugu',
    'Marathi',
    'Tamil',
    'Gujarati',
    'Kannada',
    'Malayalam',
    'Punjabi',
    'Odia',
    'Urdu',
    'Other',
  ];

  final List<Map<String, dynamic>> _interests = [
    {'label': 'Financial Literacy', 'icon': Icons.money_off_rounded},
    {'label': 'Investment Planning', 'icon': Icons.trending_up_rounded},
    {'label': 'Tax Planning', 'icon': Icons.receipt_long_rounded},
    {'label': 'Retirement Planning', 'icon': Icons.beach_access_rounded},
    {'label': 'Insurance Planning', 'icon': Icons.shield_outlined},
    {'label': 'Stock Market', 'icon': Icons.candlestick_chart_outlined},
    {'label': 'Mutual Funds', 'icon': Icons.pie_chart_outline_rounded},
    {'label': 'Estate Planning', 'icon': Icons.account_balance_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    _altContactController.dispose();
    _pancardController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Field decoration matching login screen style
  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    String? prefix,
    Widget? suffix,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: _textLight,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      prefixText: prefix,
      prefixStyle: const TextStyle(
        color: _textMid,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      prefixIcon: Icon(icon, color: _textLight, size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      alignLabelWithHint: alignLabelWithHint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _purple, width: 1.5),
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
    fontSize: 15,
    color: _textDark,
    fontWeight: FontWeight.w500,
  );

  Future<void> _pickDOB() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25, now.month, now.day),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 18, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _purple,
              onPrimary: Colors.white,
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDOB = picked);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} / ${date.month.toString().padLeft(2, '0')} / ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _bgColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: _purple,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),

                    // ── Header ──────────────────────────────────────────────
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // ── Personal Info ───────────────────────────────────────
                    _sectionLabel('Personal Info'),
                    const SizedBox(height: 14),

                    // Full Name
                    TextFormField(
                      controller: _fullNameController,
                      style: _inputStyle,
                      textCapitalization: TextCapitalization.words,
                      decoration: _fieldDecoration(
                        hint: 'Full name as per Aadhar',
                        icon: Icons.badge_outlined,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your full name'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // Date of Birth
                    GestureDetector(
                      onTap: _pickDOB,
                      child: AbsorbPointer(
                        child: TextFormField(
                          style: _inputStyle,
                          readOnly: true,
                          controller: TextEditingController(
                            text: _selectedDOB != null
                                ? _formatDate(_selectedDOB!)
                                : '',
                          ),
                          decoration: _fieldDecoration(
                            hint: 'Date of Birth (DD / MM / YYYY)',
                            icon: Icons.cake_outlined,
                            suffix: const Icon(
                              Icons.calendar_month_rounded,
                              color: _textLight,
                              size: 20,
                            ),
                          ),
                          validator: (_) => _selectedDOB == null
                              ? 'Please select your date of birth'
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Contact Number
                    TextFormField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      style: _inputStyle,
                      decoration:
                          _fieldDecoration(
                            hint: 'Contact number linked with Aadhar',
                            icon: Icons.phone_iphone_rounded,
                          ).copyWith(
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 14),
                                const Icon(
                                  Icons.phone_iphone_rounded,
                                  color: Color(0xFFB0B8C1),
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '+91',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Color(0xFFE5E7EB),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Please enter your contact number';
                        if (v.length != 10)
                          return 'Please enter a valid 10-digit number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Alternate Contact
                    TextFormField(
                      controller: _altContactController,
                      keyboardType: TextInputType.phone,
                      style: _inputStyle,
                      decoration:
                          _fieldDecoration(
                            hint: 'Alternate Contact Number (Optional)',
                            icon: Icons.phone_outlined,
                          ).copyWith(
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 14),
                                const Icon(
                                  Icons.phone_outlined,
                                  color: Color(0xFFB0B8C1),
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '+91',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Color(0xFFE5E7EB),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (v) {
                        if (v != null && v.isNotEmpty && v.length != 10) {
                          return 'Please enter a valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Mother Tongue
                    DropdownButtonFormField<String>(
                      value: _selectedMotherTongue,
                      style: _inputStyle,
                      dropdownColor: Colors.white,
                      decoration: _fieldDecoration(
                        hint: 'Mother Tongue',
                        icon: Icons.translate_rounded,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      items: _motherTongues
                          .map(
                            (lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedMotherTongue = v),
                      validator: (v) =>
                          v == null ? 'Please select your mother tongue' : null,
                    ),
                    const SizedBox(height: 14),

                    // PAN Card
                    TextFormField(
                      controller: _pancardController,
                      textCapitalization: TextCapitalization.characters,
                      style: _inputStyle,
                      decoration: _fieldDecoration(
                        hint: 'PAN Card Number (ABCDE1234F)',
                        icon: Icons.credit_card_rounded,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                        LengthLimitingTextInputFormatter(10),
                        UpperCaseTextFormatter(),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Please enter your PAN card number';
                        if (v.length != 10)
                          return 'PAN card must be 10 characters';
                        if (!RegExp(
                          r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                        ).hasMatch(v)) {
                          return 'Please enter a valid PAN card number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Address ─────────────────────────────────────────────
                    _sectionLabel('Address & Location'),
                    const SizedBox(height: 14),

                    // Full Address
                    TextFormField(
                      controller: _addressController,
                      style: _inputStyle,
                      maxLines: 3,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _fieldDecoration(
                        hint: 'House no., Street, Area...',
                        icon: Icons.home_outlined,
                        alignLabelWithHint: true,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your address'
                          : null,
                    ),
                    const SizedBox(height: 14),

                    // City / State
                    TextFormField(
                      controller: _locationController,
                      style: _inputStyle,
                      textCapitalization: TextCapitalization.words,
                      decoration: _fieldDecoration(
                        hint: 'City / State (e.g. Mumbai, Maharashtra)',
                        icon: Icons.location_on_outlined,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your city / state'
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // ── Account Details ─────────────────────────────────────
                    _sectionLabel('Account Details'),
                    const SizedBox(height: 14),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: _inputStyle,
                      decoration: _fieldDecoration(
                        hint: 'Email Address',
                        icon: Icons.alternate_email_rounded,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Please enter your email';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: _inputStyle,
                      decoration: _fieldDecoration(
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _textLight,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Please enter a password';
                        if (v.length < 8)
                          return 'Password must be at least 8 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: _inputStyle,
                      decoration: _fieldDecoration(
                        hint: 'Confirm Password',
                        icon: Icons.lock_person_outlined,
                        suffix: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _textLight,
                            size: 20,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                      ),
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords do not match'
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // ── Financial Interests ─────────────────────────────────
                    _sectionLabel('Financial Interests'),
                    const SizedBox(height: 6),
                    const Text(
                      'Select all areas you\'re interested in',
                      style: TextStyle(
                        fontSize: 13,
                        color: _textMid,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 14),

                    _buildInterestsGrid(),

                    const SizedBox(height: 24),

                    // ── Disclaimer ──────────────────────────────────────────
                    _buildDisclaimer(),
                    const SizedBox(height: 24),

                    // ── Submit Button ───────────────────────────────────────
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_purple, _blue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _purple.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            if (_selectedInterests.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please select at least one financial interest',
                                  ),
                                  backgroundColor: _purple,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OtpVerifyScreen(
                                    phoneNumber: _contactController.text,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Login link ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: _textMid, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: _purple,
                              decoration: TextDecoration.underline,
                              decorationColor: _purple,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Financial Interests Grid ─────────────────────────────────────────────────
  Widget _buildInterestsGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _interests.map((interest) {
        final label = interest['label'] as String;
        final icon = interest['icon'] as IconData;
        final isSelected = _selectedInterests.contains(label);

        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected
                  ? _selectedInterests.remove(label)
                  : _selectedInterests.add(label);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [_purple, _blue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _purple.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : _purple,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _textDark,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Disclaimer ───────────────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple.withOpacity(0.2), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _purple, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12.5, color: _textMid, height: 1.5),
                children: [
                  TextSpan(
                    text: 'Disclaimer: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _purple,
                    ),
                  ),
                  TextSpan(
                    text:
                        'By creating an account, you agree to our Terms & Conditions and Privacy Policy. '
                        'The information provided must be accurate and match your official documents (Aadhar / PAN). '
                        'Phir Wealth does not guarantee any investment returns. '
                        'All financial decisions are solely your responsibility.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // Container(
        //   width: 80,
        //   height: 80,
        //   decoration: BoxDecoration(
        //     gradient: const LinearGradient(
        //       colors: [_purple, _blue],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     borderRadius: BorderRadius.circular(24),
        //     boxShadow: [
        //       BoxShadow(
        //         color: _purple.withOpacity(0.3),
        //         blurRadius: 20,
        //         offset: const Offset(0, 8),
        //       ),
        //     ],
        //   ),
        //   child: const Icon(
        //     Icons.person_add_alt_1_rounded,
        //     color: Colors.white,
        //     size: 40,
        //   ),
        // ),
        //const SizedBox(height: 18),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _textDark,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Text(
          'Start your wealth journey today',
          style: TextStyle(
            fontSize: 15,
            color: _textMid,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Section Label ─────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_purple, _blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _purple,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Uppercase Formatter ───────────────────────────────────────────────────────
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
