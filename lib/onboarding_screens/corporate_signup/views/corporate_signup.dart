import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CorporateSignupScreen extends StatefulWidget {
  const CorporateSignupScreen({Key? key}) : super(key: key);

  @override
  State<CorporateSignupScreen> createState() => _CorporateSignupScreenState();
}

class _CorporateSignupScreenState extends State<CorporateSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // ── Brand Colors (matching all screens) ───────────────────────────────────
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);
  static const Color _bgColor = Color(0xFFF8F8FF);
  static const Color _textDark = Color(0xFF0F172A);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFFB0B8C1);

  // ── Step 1 Controllers ─────────────────────────────────────────────────────
  final _companyNameController = TextEditingController();
  final _industryTypeController = TextEditingController();
  final _employeeCountController = TextEditingController();
  String? _companySize;
  final _locationController = TextEditingController();
  final _branchesController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _pocNameController = TextEditingController();
  final _pocDesignationController = TextEditingController();
  final _pocEmailController = TextEditingController();
  final _pocMobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ── Step 2 Controllers ─────────────────────────────────────────────────────
  final List<String> _selectedInterests = [];
  final List<String> _selectedServices = [];
  final _goalsObjectivesController = TextEditingController();
  final _currentChallengesController = TextEditingController();
  bool _isLargeAudience = false;

  // ── Step 3 Controllers ─────────────────────────────────────────────────────
  String? _preferredMode;
  final _expectedTimelineController = TextEditingController();
  final _indicativeBudgetController = TextEditingController();
  final _experienceDetailsController = TextEditingController();
  final _kpiController = TextEditingController();

  // ── Step 4 Controllers ─────────────────────────────────────────────────────
  final _approvalAuthorityController = TextEditingController();
  final _approvalRoleController = TextEditingController();
  final _approvalProcessController = TextEditingController();

  // ── Options ────────────────────────────────────────────────────────────────
  final List<String> _interestAreas = [
    'PHIR School',
    'PHIR Shiksha',
    'PHIR Jobs',
    'PHIR Health',
    'PHIR Wealth',
    'PHIR Marry',
  ];

  final List<String> _serviceOptions = [
    'Training',
    'Hiring',
    'Financial Advisory',
    'Insurance',
    'Tax Planning',
    'Investment',
  ];

  final List<String> _companySizes = [
    'Small (1–50)',
    'Medium (51–250)',
    'Large (251–1000)',
    'Enterprise (1000+)',
  ];

  final List<String> _preferredModes = ['Onsite', 'Online', 'Hybrid'];

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Corporate', 'icon': Icons.business_outlined},
    {'label': 'Interests', 'icon': Icons.interests_outlined},
    {'label': 'Preferences', 'icon': Icons.tune_rounded},
    {'label': 'Verify', 'icon': Icons.verified_outlined},
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _industryTypeController.dispose();
    _employeeCountController.dispose();
    _locationController.dispose();
    _branchesController.dispose();
    _registrationNumberController.dispose();
    _pocNameController.dispose();
    _pocDesignationController.dispose();
    _pocEmailController.dispose();
    _pocMobileController.dispose();
    _passwordController.dispose();
    _goalsObjectivesController.dispose();
    _currentChallengesController.dispose();
    _expectedTimelineController.dispose();
    _indicativeBudgetController.dispose();
    _experienceDetailsController.dispose();
    _kpiController.dispose();
    _approvalAuthorityController.dispose();
    _approvalRoleController.dispose();
    _approvalProcessController.dispose();
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
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      if (_formKey.currentState!.validate()) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    }
  }

  void _back() {
    if (_currentStep > 0) setState(() => _currentStep--);
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
          'Corporate Registration',
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
        color: _bgColor,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final isDone = _currentStep > i ~/ 2;
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
                          _steps[idx]['icon'] as IconData,
                          color: isActive ? _purple : _textLight,
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
                  color: isActive || isDone ? _purple : _textLight,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ── Bottom Nav ─────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: _bgColor,
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
                        _currentStep == 3 ? 'Submit' : 'Continue',
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

  Widget _chipGroup(String label, List<String> options, List<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(label),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((item) {
            final isSelected = selected.contains(item);
            return GestureDetector(
              onTap: () => setState(() {
                isSelected ? selected.remove(item) : selected.add(item);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
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
                  borderRadius: BorderRadius.circular(30),
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
                    if (isSelected) ...[
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      item,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : _textMid,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildCorporateDetailsStep();
      case 1:
        return _buildInterestAreasStep();
      case 2:
        return _buildServicePreferencesStep();
      case 3:
        return _buildFinalDetailsStep();
      default:
        return const SizedBox();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 1 — Corporate Details
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildCorporateDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader('Corporate Details', 'Tell us about your organization',
        //     Icons.business_outlined),
        const SizedBox(height: 12),
        _sectionLabel('Company Information'),
        TextFormField(
          controller: _companyNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(hint: 'Company Name', icon: Icons.domain_rounded),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _industryTypeController,
          style: _inputStyle,
          decoration: _dec(hint: 'Industry Type', icon: Icons.factory_outlined),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _companySize,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            hint: 'Company Size',
            icon: Icons.people_outline_rounded,
          ),
          items: _companySizes
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (v) => setState(() => _companySize = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _employeeCountController,
                keyboardType: TextInputType.number,
                style: _inputStyle,
                decoration: _dec(
                  hint: 'Employees',
                  icon: Icons.groups_outlined,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _branchesController,
                keyboardType: TextInputType.number,
                style: _inputStyle,
                decoration: _dec(hint: 'Branches', icon: Icons.store_outlined),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _locationController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Headquarters Location',
            icon: Icons.location_on_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _registrationNumberController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Corporate Registration Number',
            icon: Icons.numbers_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),

        const SizedBox(height: 20),
        _sectionLabel('Point of Contact'),
        TextFormField(
          controller: _pocNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Contact Person Name',
            icon: Icons.badge_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _pocDesignationController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Designation',
            icon: Icons.work_outline_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _pocEmailController,
          keyboardType: TextInputType.emailAddress,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Official Email',
            icon: Icons.alternate_email_rounded,
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _pocMobileController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          decoration:
              _dec(
                hint: 'Mobile Number',
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
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 2 — Interest Areas
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildInterestAreasStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Interest Areas',
        //   'What services are you looking for?',
        //   Icons.interests_outlined,
        // ),
        const SizedBox(height: 12),

        _chipGroup('PHIR Interest Areas', _interestAreas, _selectedInterests),
        const SizedBox(height: 20),
        _chipGroup('Services Required', _serviceOptions, _selectedServices),

        const SizedBox(height: 20),
        _sectionLabel('Goals & Challenges'),
        TextFormField(
          controller: _goalsObjectivesController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'What do you want to achieve?',
            icon: Icons.flag_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _currentChallengesController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'What challenges are you facing?',
            icon: Icons.report_problem_outlined,
          ),
        ),
        const SizedBox(height: 16),
        _toggleCard(
          title: 'Large Audience / Influencer',
          subtitle: 'We have a large employee base or industry influence',
          icon: Icons.campaign_outlined,
          value: _isLargeAudience,
          onChanged: (v) => setState(() => _isLargeAudience = v),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 3 — Service Preferences
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildServicePreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Service Preferences',
        //   'How do you want to engage with us?',
        //   Icons.tune_rounded,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Delivery Preferences'),
        DropdownButtonFormField<String>(
          value: _preferredMode,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            hint: 'Preferred Mode',
            icon: Icons.devices_outlined,
          ),
          items: _preferredModes
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: (v) => setState(() => _preferredMode = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _expectedTimelineController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'e.g., 3 months, Q2 2026',
            icon: Icons.calendar_month_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _indicativeBudgetController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Indicative Budget (₹)',
            icon: Icons.currency_rupee_rounded,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),

        const SizedBox(height: 20),
        _sectionLabel('Experience & Metrics'),
        TextFormField(
          controller: _experienceDetailsController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Describe any previous experience...',
            icon: Icons.history_edu_outlined,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _kpiController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'How will you measure success?',
            icon: Icons.analytics_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 4 — Final Details
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFinalDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Final Details',
        //   'Decision-making & approval process',
        //   Icons.verified_outlined,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Approval Authority'),
        TextFormField(
          controller: _approvalAuthorityController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Authority Name',
            icon: Icons.manage_accounts_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _approvalRoleController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Authority Role / Designation',
            icon: Icons.work_outline_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _approvalProcessController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Describe your internal approval workflow...',
            icon: Icons.account_tree_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),

        const SizedBox(height: 24),

        // ── What Happens Next card ──────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: _purple.withOpacity(0.06),
                blurRadius: 16,
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_purple, _blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'What Happens Next?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...[
                (
                  Icons.fact_check_outlined,
                  'Our team reviews your application',
                ),
                (
                  Icons.mark_email_read_outlined,
                  'Confirmation email sent to you',
                ),
                (
                  Icons.support_agent_outlined,
                  'Dedicated account manager assigned',
                ),
                (
                  Icons.calendar_today_outlined,
                  'Initial consultation scheduled',
                ),
                (Icons.account_tree, 'Service Matrix prepared for you'),
              ].asMap().entries.map((e) {
                final idx = e.key;
                final item = e.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_purple, _blue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${idx + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(item.$1, color: _purple, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.$2,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: _textMid,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
