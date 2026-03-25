import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvisorSignupScreen extends StatefulWidget {
  const AdvisorSignupScreen({Key? key}) : super(key: key);

  @override
  State<AdvisorSignupScreen> createState() => _AdvisorSignupScreenState();
}

class _AdvisorSignupScreenState extends State<AdvisorSignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // ── Brand Colors (matching all screens) ───────────────────────────────────
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);
  static const Color _bgColor = Color(0xFFF8F8FF);
  static const Color _textDark = Color(0xFF0F172A);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFFB0B8C1);

  // ── Controllers ────────────────────────────────────────────────────────────
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedSpecialization;
  final _educationDegreeController = TextEditingController();
  final _licenceNumberController = TextEditingController();
  String? _certificateYear;
  String? _licenseStatus;
  String? _certificateCategory;
  String? _certificateRegulator;
  bool _canPracticeIndependently = false;
  bool _obscurePassword = true;

  String? _degreeFileName;
  String? _certificateFileName;

  final _totalExperienceController = TextEditingController();
  final _specializationExperienceController = TextEditingController();
  final Set<String> _selectedSpecializations = {};
  final _practiceDetailsController = TextEditingController();
  final _instituteNameController = TextEditingController();
  final _yearsOfAssociationController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _experienceMotivationController = TextEditingController();

  final _techProtocolsController = TextEditingController();
  bool _hasTelechonsultationExperience = false;

  String? _selectedLanguage;
  final List<String> _addedLanguages = [];
  int? _sessionDurationMinutes;

  final Set<DateTime> _availableDates = {};
  DateTime _calendarFocusedDay = DateTime.now();

  final _sessionChargesController = TextEditingController();

  bool _hasFacedLegalAction = false;
  final _motivationController = TextEditingController();
  bool _confirmInformation = false;
  bool _documentVerified = false;
  bool _hasDigitalExperience = false;
  bool _disclaimerAccepted = false;

  // ── Data ───────────────────────────────────────────────────────────────────
  final List<String> _specializations = [
    'Investment Planning',
    'Tax Planning',
    'Retirement Planning',
    'Insurance Planning',
    'Estate Planning',
    'Mutual Funds',
    'Stock Market',
  ];

  final List<Map<String, dynamic>> _specializationChips = [
    {'label': 'Financial', 'icon': Icons.money_off_rounded},
    {'label': 'Investment', 'icon': Icons.trending_up_rounded},
    {'label': 'Tax', 'icon': Icons.receipt_long_rounded},
    {'label': 'Retirement', 'icon': Icons.beach_access_rounded},
    {'label': 'Insurance', 'icon': Icons.shield_outlined},
    {'label': 'Stock', 'icon': Icons.candlestick_chart_outlined},
    {'label': 'Mutual', 'icon': Icons.pie_chart_outline_rounded},
    {'label': 'Estate', 'icon': Icons.account_balance_outlined},
  ];

  final List<String> _certificateCategories = [
    'AMFI (Mutual Fund)',
    'NISM Series V-A',
    'NISM Series VIII',
    'NISM Series X-A',
    'CFP (Financial Planner)',
    'CFA (Chartered)',
    'CA (Chartered Accountant)',
    'LIC Agent',
    'Other',
  ];

  final List<String> _certificateRegulators = ['IRDA', 'SEBI', 'PFRDA'];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Marathi',
    'Tamil',
    'Telugu',
    'Bengali',
    'Gujarati',
    'Kannada',
    'Punjabi',
    'Malayalam',
    'Odia',
    'Urdu',
  ];

  final List<int> _durationOptions = [15, 30, 45, 60];

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Profile', 'icon': Icons.person_outline_rounded},
    {'label': 'Experience', 'icon': Icons.workspace_premium_outlined},
    {'label': 'Languages', 'icon': Icons.translate_rounded},
    {'label': 'Verify', 'icon': Icons.verified_outlined},
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _educationDegreeController.dispose();
    _licenceNumberController.dispose();
    _totalExperienceController.dispose();
    _specializationExperienceController.dispose();
    _practiceDetailsController.dispose();
    _instituteNameController.dispose();
    _yearsOfAssociationController.dispose();
    _achievementsController.dispose();
    _experienceMotivationController.dispose();
    _techProtocolsController.dispose();
    _sessionChargesController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  // ── Field Decoration (matching login screen style) ─────────────────────────
  InputDecoration _dec({
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

  // ── Navigation ─────────────────────────────────────────────────────────────
  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      if (_formKey.currentState!.validate()) {
        if (!_disclaimerAccepted) {
          _showSnack('Please accept the disclaimer');
          return;
        }
        if (!_confirmInformation) {
          _showSnack('Please confirm your information');
          return;
        }
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
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
        title: const Text(
          'Advisor Registration',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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
      ),
    );
  }

  // ── Step Indicator ─────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8FF),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final isDone = _currentStep > stepIndex;
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: isDone
                      ? const LinearGradient(colors: [_purple, _blue])
                      : null,
                  color: isDone ? null : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = _currentStep > stepIndex;
          final isActive = _currentStep == stepIndex;
          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isDone
                      ? const LinearGradient(
                          colors: [_purple, _blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isDone
                      ? null
                      : isActive
                      ? _purple.withOpacity(0.1)
                      : Colors.white,
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: _purple, width: 2)
                      : !isDone
                      ? Border.all(color: const Color(0xFFE5E7EB), width: 1)
                      : null,
                  boxShadow: isDone || isActive
                      ? [
                          BoxShadow(
                            color: _purple.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: isDone
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 18,
                        )
                      : Icon(
                          _steps[stepIndex]['icon'] as IconData,
                          color: isActive ? _purple : _textLight,
                          size: 18,
                        ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _steps[stepIndex]['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive || isDone
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isActive || isDone ? _purple : _textLight,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBasicProfileStep();
      case 1:
        return _buildExperienceStep();
      case 2:
        return _buildLanguagesStep();
      case 3:
        return _buildVerificationStep();
      default:
        return const SizedBox();
    }
  }

  // ── Bottom Nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F8FF),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: _back,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _purple,
                    side: const BorderSide(color: _purple, width: 1.5),
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
                  onTap: _next,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentStep == _steps.length - 1
                            ? 'Submit'
                            : 'Continue',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        _currentStep == _steps.length - 1
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
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
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
      ),
    );
  }

  Widget _stepHeader(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_purple, _blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _purple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: _textMid),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = _purple,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: value ? activeColor.withOpacity(0.07) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value ? activeColor.withOpacity(0.3) : const Color(0xFFE5E7EB),
          width: 1.5,
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: _textMid),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        secondary: Icon(
          icon,
          color: value ? activeColor : _textLight,
          size: 22,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    required IconData icon,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    final hasFile = fileName != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: hasFile ? const Color(0xFFF3EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasFile ? _purple.withOpacity(0.4) : const Color(0xFFE5E7EB),
            width: hasFile ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: hasFile
                    ? const LinearGradient(
                        colors: [_purple, _blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: hasFile ? null : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                hasFile ? Icons.check_rounded : icon,
                color: hasFile ? Colors.white : _textLight,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasFile ? _purple : _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasFile ? fileName! : 'Tap to upload (PDF, JPG, PNG)',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: hasFile ? _textMid : _textLight,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              hasFile ? Icons.edit_outlined : Icons.upload_rounded,
              color: hasFile ? _purple : _textLight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLicenseStatusSelector() {
    final options = [
      {
        'value': 'Valid',
        'icon': Icons.check_circle_outline_rounded,
        'color': const Color(0xFF22C55E),
      },
      {
        'value': 'Expired',
        'icon': Icons.cancel_outlined,
        'color': const Color(0xFFEF4444),
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.verified_outlined, color: _textLight, size: 22),
            const SizedBox(width: 10),
            const Text(
              'License Status',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: _textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: options.map((opt) {
            final val = opt['value'] as String;
            final icon = opt['icon'] as IconData;
            final color = opt['color'] as Color;
            final isSelected = _licenseStatus == val;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _licenseStatus = val),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: val == 'Valid' ? 10 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? color : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? color : _textLight,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        val,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? color : _textMid,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpecializationChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select all that apply',
          style: TextStyle(
            fontSize: 12,
            color: _textLight,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _specializationChips.map((chip) {
            final label = chip['label'] as String;
            final icon = chip['icon'] as IconData;
            final isSelected = _selectedSpecializations.contains(label);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected
                      ? _selectedSpecializations.remove(label)
                      : _selectedSpecializations.add(label);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
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
                      size: 15,
                      color: isSelected ? Colors.white : _purple,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : _textDark,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilityCalendar() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(
      _calendarFocusedDay.year,
      _calendarFocusedDay.month,
    );
    final firstDayOfMonth = DateTime(
      _calendarFocusedDay.year,
      _calendarFocusedDay.month,
      1,
    );
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: _purple.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, color: _purple),
                onPressed: () => setState(() {
                  _calendarFocusedDay = DateTime(
                    _calendarFocusedDay.year,
                    _calendarFocusedDay.month - 1,
                  );
                }),
              ),
              Text(
                '${_monthName(_calendarFocusedDay.month)} ${_calendarFocusedDay.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, color: _purple),
                onPressed: () => setState(() {
                  _calendarFocusedDay = DateTime(
                    _calendarFocusedDay.year,
                    _calendarFocusedDay.month + 1,
                  );
                }),
              ),
            ],
          ),
          Row(
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _textLight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemCount: startWeekday + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox();
              final day = index - startWeekday + 1;
              final date = DateTime(
                _calendarFocusedDay.year,
                _calendarFocusedDay.month,
                day,
              );
              final isPast = date.isBefore(
                DateTime(now.year, now.month, now.day),
              );
              final isSelected = _availableDates.any(
                (d) =>
                    d.year == date.year &&
                    d.month == date.month &&
                    d.day == date.day,
              );

              return GestureDetector(
                onTap: isPast
                    ? null
                    : () {
                        setState(() {
                          final existing = _availableDates.firstWhere(
                            (d) =>
                                d.year == date.year &&
                                d.month == date.month &&
                                d.day == date.day,
                            orElse: () => DateTime(0),
                          );
                          if (existing.year == 0) {
                            _availableDates.add(date);
                          } else {
                            _availableDates.remove(existing);
                          }
                        });
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [_purple, _blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : isPast
                            ? _textLight.withOpacity(0.4)
                            : _textDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_availableDates.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.event_available_rounded,
                  color: _purple,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_availableDates.length} day(s) selected',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _purple,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _availableDates.clear()),
                  child: const Text(
                    'Clear all',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 1 — Basic Profile
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBasicProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //_stepHeader('Basic Profile', 'Tell us about yourself', Icons.person_outline_rounded),
        const SizedBox(height: 12),
        _sectionLabel('Personal Details'),
        TextFormField(
          controller: _fullNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Full name as per Aadhar',
            icon: Icons.badge_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _addressController,
          style: _inputStyle,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: _dec(
            hint: 'House no., Street, City, State...',
            icon: Icons.home_outlined,
            alignLabelWithHint: true,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Email Address',
            icon: Icons.alternate_email_rounded,
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!))
              return 'Invalid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          decoration:
              _dec(
                hint: 'Contact Number',
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
                    Container(width: 1, height: 20, color: Color(0xFFE5E7EB)),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (v!.length != 10) return 'Enter valid 10-digit number';
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: _inputStyle,
          decoration: _dec(
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
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (v!.length < 8) return 'At least 8 characters';
            return null;
          },
        ),
        const SizedBox(height: 20),
        _sectionLabel('Professional Details'),
        DropdownButtonFormField<String>(
          value: _selectedSpecialization,
          style: _inputStyle,
          dropdownColor: Colors.white,
          decoration: _dec(
            hint: 'Primary Specialization',
            icon: Icons.analytics_outlined,
          ),
          borderRadius: BorderRadius.circular(14),
          items: _specializations
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _selectedSpecialization = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _educationDegreeController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Educational Degree',
            icon: Icons.school_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        _buildUploadButton(
          label: 'Upload Degree Certificate',
          icon: Icons.upload_file_rounded,
          fileName: _degreeFileName,
          onTap: () =>
              setState(() => _degreeFileName = 'degree_certificate.pdf'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _licenceNumberController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Licence / Certification No.',
            icon: Icons.verified_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _certificateYear,
          style: _inputStyle,
          dropdownColor: Colors.white,
          decoration: _dec(
            hint: 'Year of Certificate',
            icon: Icons.calendar_month_outlined,
          ),
          borderRadius: BorderRadius.circular(14),
          items: List.generate(30, (i) {
            final yr = (DateTime.now().year - i).toString();
            return DropdownMenuItem(value: yr, child: Text(yr));
          }),
          onChanged: (v) => setState(() => _certificateYear = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _certificateCategory,
          style: _inputStyle,
          dropdownColor: Colors.white,
          decoration: _dec(
            hint: 'Certificate Category',
            icon: Icons.category_outlined,
          ),
          borderRadius: BorderRadius.circular(14),
          items: _certificateCategories
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (v) => setState(() => _certificateCategory = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _certificateRegulator,
          style: _inputStyle,
          dropdownColor: Colors.white,
          decoration: _dec(
            hint: 'Issuing Regulator',
            icon: Icons.account_balance_outlined,
          ),
          borderRadius: BorderRadius.circular(14),
          items: _certificateRegulators.map((r) {
            return DropdownMenuItem(
              value: r,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _purple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      r,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _purple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _regulatorFullName(r),
                    style: const TextStyle(fontSize: 13, color: _textMid),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (v) => setState(() => _certificateRegulator = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        _buildUploadButton(
          label: 'Upload Certificate',
          icon: Icons.workspace_premium_outlined,
          fileName: _certificateFileName,
          onTap: () => setState(() => _certificateFileName = 'certificate.pdf'),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: _buildLicenseStatusSelector(),
        ),
        if (_licenseStatus == null)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Please select license status',
              style: TextStyle(fontSize: 11.5, color: Color(0xFFEF4444)),
            ),
          ),
        const SizedBox(height: 12),
        _toggleCard(
          title: 'Licensed to Practice Independently',
          subtitle: 'You can operate without institutional supervision',
          icon: Icons.gavel_rounded,
          value: _canPracticeIndependently,
          onChanged: (v) => setState(() => _canPracticeIndependently = v),
        ),
      ],
    );
  }

  String _regulatorFullName(String code) {
    switch (code) {
      case 'IRDA':
        return 'Insurance Regulatory';
      case 'SEBI':
        return 'Securities Exchange Board';
      case 'PFRDA':
        return 'Pension Fund Regulatory';
      default:
        return '';
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 2 — Experience
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildExperienceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Experience & Expertise',
        //   'Share your professional background',
        //   Icons.workspace_premium_outlined,
        // ),
        const SizedBox(height: 12),
        _sectionLabel('Years of Experience'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _totalExperienceController,
                keyboardType: TextInputType.number,
                style: _inputStyle,
                decoration: _dec(
                  hint: 'Total (years)',
                  icon: Icons.work_history_outlined,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _specializationExperienceController,
                keyboardType: TextInputType.number,
                style: _inputStyle,
                decoration: _dec(
                  hint: 'In Spec. (years)',
                  icon: Icons.star_outline_rounded,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _sectionLabel('Specialized In'),
        _buildSpecializationChips(),
        if (_selectedSpecializations.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Please select at least one specialization',
              style: TextStyle(fontSize: 11.5, color: Color(0xFFEF4444)),
            ),
          ),
        const SizedBox(height: 20),
        _sectionLabel('Practice Details'),
        TextFormField(
          controller: _practiceDetailsController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Describe your current practice...',
            icon: Icons.description_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        _sectionLabel('Current Association'),
        TextFormField(
          controller: _instituteNameController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Institute / Company Name',
            icon: Icons.business_outlined,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _yearsOfAssociationController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Years of Association',
            icon: Icons.timelapse_rounded,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 20),
        _sectionLabel('Achievements'),
        TextFormField(
          controller: _achievementsController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'List your professional achievements...',
            icon: Icons.emoji_events_outlined,
          ),
        ),
        const SizedBox(height: 20),
        _sectionLabel('What Drives You'),
        TextFormField(
          controller: _experienceMotivationController,
          maxLines: 4,
          style: _inputStyle,
          decoration: _dec(
            hint: 'What motivates you in your advisory career?',
            icon: Icons.lightbulb_outline_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 3 — Languages & Charges
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildLanguagesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Languages & Charges',
        //   'Set your preferences and session fees',
        //   Icons.translate_rounded,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Preferred Languages'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                style: _inputStyle,
                dropdownColor: Colors.white,
                decoration: _dec(
                  hint: 'Select Language',
                  icon: Icons.language_rounded,
                ),
                borderRadius: BorderRadius.circular(14),
                items: _languages
                    .where((l) => !_addedLanguages.contains(l))
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedLanguage = v),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_purple, _blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _purple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                onPressed: () {
                  if (_selectedLanguage != null &&
                      !_addedLanguages.contains(_selectedLanguage)) {
                    setState(() {
                      _addedLanguages.add(_selectedLanguage!);
                      _selectedLanguage = null;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (_addedLanguages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _addedLanguages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_purple, _blue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      lang,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => setState(() => _addedLanguages.remove(lang)),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        if (_addedLanguages.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Please add at least one language',
              style: TextStyle(fontSize: 11.5, color: Color(0xFFEF4444)),
            ),
          ),
        const SizedBox(height: 24),
        _sectionLabel('Available Dates'),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Tap dates to mark your availability for online sessions',
            style: TextStyle(fontSize: 12, color: _textMid),
          ),
        ),
        _buildAvailabilityCalendar(),
        const SizedBox(height: 24),
        _sectionLabel('Session Details'),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _sessionDurationMinutes,
                style: _inputStyle,
                dropdownColor: Colors.white,
                decoration: _dec(hint: 'Duration', icon: Icons.timer_outlined),
                borderRadius: BorderRadius.circular(14),
                items: _durationOptions
                    .map(
                      (d) => DropdownMenuItem(value: d, child: Text('$d min')),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _sessionDurationMinutes = v),
                validator: (v) => v == null ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _sessionChargesController,
                keyboardType: TextInputType.number,
                style: _inputStyle,
                decoration: _dec(
                  hint: 'Charges (₹)',
                  icon: Icons.currency_rupee_rounded,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 4 — Verification
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Final Verification',
        //   'Almost there! Just a few last checks.',
        //   Icons.verified_outlined,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Legal Check'),
        _toggleCard(
          title: 'Disciplinary / Legal Action',
          subtitle:
              'Have you ever faced legal action related to your profession?',
          icon: Icons.gavel_rounded,
          value: _hasFacedLegalAction,
          onChanged: (v) => setState(() => _hasFacedLegalAction = v),
          activeColor: const Color(0xFFEF4444),
        ),
        const SizedBox(height: 16),
        _sectionLabel('Document Verification'),
        _toggleCard(
          title: 'Document Authenticity',
          subtitle: 'I confirm all uploaded documents are authentic and valid',
          icon: Icons.folder_open_rounded,
          value: _documentVerified,
          onChanged: (v) => setState(() => _documentVerified = v),
        ),
        const SizedBox(height: 16),
        _sectionLabel('Digital Experience'),
        _toggleCard(
          title: 'Digital Advisory Experience',
          subtitle:
              'I have prior experience conducting online financial advisory sessions',
          icon: Icons.devices_rounded,
          value: _hasDigitalExperience,
          onChanged: (v) => setState(() => _hasDigitalExperience = v),
        ),
        const SizedBox(height: 20),
        _sectionLabel('Disclaimer'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFF59E0B).withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Important Disclaimer',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'By submitting this application, you acknowledge that:\n\n'
                '• All information provided is accurate and complete.\n'
                '• You are legally authorized to provide financial advisory services.\n'
                '• PHIR Wealth reserves the right to verify credentials independently.\n'
                '• False information may result in immediate termination.\n'
                '• You agree to comply with all applicable SEBI/IRDA/PFRDA regulations.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF78350F),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () =>
                    setState(() => _disclaimerAccepted = !_disclaimerAccepted),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _disclaimerAccepted
                            ? const Color(0xFFF59E0B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _disclaimerAccepted
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFFD97706),
                          width: 1.5,
                        ),
                      ),
                      child: _disclaimerAccepted
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'I have read and accept the above disclaimer',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _sectionLabel('Confirmation'),
        GestureDetector(
          onTap: () =>
              setState(() => _confirmInformation = !_confirmInformation),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _confirmInformation
                  ? const Color(0xFFF3EEFF)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _confirmInformation
                    ? _purple.withOpacity(0.3)
                    : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: _confirmInformation
                        ? const LinearGradient(
                            colors: [_purple, _blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _confirmInformation ? null : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _confirmInformation
                          ? Colors.transparent
                          : _textLight,
                      width: 1.5,
                    ),
                  ),
                  child: _confirmInformation
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'I confirm that all information provided is true and accurate to the best of my knowledge.',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: _textDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
