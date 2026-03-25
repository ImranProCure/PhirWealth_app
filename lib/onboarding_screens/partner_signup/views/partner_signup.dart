import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PartnerSignupScreen extends StatefulWidget {
  const PartnerSignupScreen({Key? key}) : super(key: key);

  @override
  State<PartnerSignupScreen> createState() => _PartnerSignupScreenState();
}

class _PartnerSignupScreenState extends State<PartnerSignupScreen> {
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
  final _partnerNameController = TextEditingController();
  final _partnerSectorController = TextEditingController();
  final _partnerAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = false;

  final List<String> _selectedPartnerTypes = [];
  final _geographicalPresenceController = TextEditingController();

  final _concernPersonNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  final _licenceCertificateController = TextEditingController();
  final List<String> _selectedExpertise = [];
  final _experienceYearsController = TextEditingController();

  String? _selectedPartnershipModel;
  String? _levelOfInvolvement;
  final _commercialExpectationsController = TextEditingController();

  String? _selectedPayoutDays;

  final _previousCollaborationController = TextEditingController();
  final _referenceNameController = TextEditingController();
  final _referenceContactController = TextEditingController();
  bool _hasLegalIssues = false;
  bool _hasPartnershipAgreement = false;
  bool _disclaimerAccepted = false;
  bool _agreeToFollowPolicies = false;
  final _motivationController = TextEditingController();
  final _agreementTenureController = TextEditingController();

  // ── Options ────────────────────────────────────────────────────────────────
  final List<String> _partnerTypes = [
    'PHIR School',
    'PHIR Shiksha',
    'PHIR Jobs',
    'PHIR Health',
    'PHIR Wealth',
    'PHIR Marry',
  ];

  final List<String> _expertiseOptions = [
    'Insurance',
    'Investment',
    'Training/Coaching',
    'Financial Audit',
    'Legal Advisory',
  ];

  final List<String> _partnershipModels = [
    'Service Delivery',
    'Referral',
    'Training',
    'Technology',
    'Investment',
  ];

  final List<String> _involvementLevels = [
    'Full Time',
    'Part Time',
    'Project Based',
    'Advisory',
  ];

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Partner', 'icon': Icons.handshake_outlined},
    {'label': 'Background', 'icon': Icons.workspace_premium_outlined},
    {'label': 'Partnership', 'icon': Icons.account_tree_outlined},
    {'label': 'Verify', 'icon': Icons.verified_outlined},
  ];

  @override
  void dispose() {
    _partnerNameController.dispose();
    _partnerSectorController.dispose();
    _partnerAddressController.dispose();
    _passwordController.dispose();
    _geographicalPresenceController.dispose();
    _concernPersonNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _licenceCertificateController.dispose();
    _experienceYearsController.dispose();
    _commercialExpectationsController.dispose();
    _previousCollaborationController.dispose();
    _referenceNameController.dispose();
    _referenceContactController.dispose();
    _motivationController.dispose();
    _agreementTenureController.dispose();
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
        if (!_disclaimerAccepted) {
          _showSnack('Please accept the disclaimer');
          return;
        }
        if (!_agreeToFollowPolicies) {
          _showSnack('Please agree to follow PHIR policies');
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
          'Partner Registration',
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

  Widget _confirmCard({
    required String text,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFF3EEFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? _purple.withOpacity(0.3) : const Color(0xFFE5E7EB),
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
                gradient: value
                    ? const LinearGradient(
                        colors: [_purple, _blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: value ? null : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value ? Colors.transparent : _textLight,
                  width: 1.5,
                ),
              ),
              child: value
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
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
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPartnerStep();
      case 1:
        return _buildBackgroundStep();
      case 2:
        return _buildPartnershipStep();
      case 3:
        return _buildVerificationStep();
      default:
        return const SizedBox();
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 1 — Partner Identity
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPartnerStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader('Partner Identity', 'Tell us about your partner organization',
        //     Icons.handshake_outlined),
        const SizedBox(height: 12),

        _sectionLabel('Partner Details'),
        TextFormField(
          controller: _partnerNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Partner Name',
            icon: Icons.handshake_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _partnerSectorController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Working Sector',
            icon: Icons.category_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _partnerAddressController,
          style: _inputStyle,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: _dec(
            hint: 'House / Office no., Street, City, State...',
            icon: Icons.location_on_outlined,
            alignLabelWithHint: true,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _geographicalPresenceController,
          style: _inputStyle,
          maxLines: 2,
          decoration: _dec(
            hint: 'Cities / States where you operate',
            icon: Icons.map_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
        _chipGroup('Partner Type', _partnerTypes, _selectedPartnerTypes),

        const SizedBox(height: 20),
        _sectionLabel('Concern Person'),
        TextFormField(
          controller: _concernPersonNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Full Name',
            icon: Icons.person_outline_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _emailController,
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

        const SizedBox(height: 20),
        _sectionLabel('Motivation'),
        TextFormField(
          controller: _motivationController,
          maxLines: 4,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Share your motivation (min. 50 characters)...',
            icon: Icons.lightbulb_outline_rounded,
          ),
          validator: (v) {
            if (v?.isEmpty ?? true) return 'Required';
            if (v!.length < 50) return 'Please write at least 50 characters';
            return null;
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 2 — Background
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Professional Background',
        //   'Your credentials and expertise',
        //   Icons.workspace_premium_outlined,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Credentials'),
        TextFormField(
          controller: _licenceCertificateController,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Licence / Certificate Number',
            icon: Icons.verified_outlined,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _experienceYearsController,
          keyboardType: TextInputType.number,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Relevant Experience (years)',
            icon: Icons.work_history_outlined,
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedPayoutDays,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            hint: 'Expected Payout Time',
            icon: Icons.payments_outlined,
          ),
          items: const [
            DropdownMenuItem(value: '30', child: Text('30 Days')),
            DropdownMenuItem(value: '45', child: Text('45 Days')),
          ],
          onChanged: (v) => setState(() => _selectedPayoutDays = v),
          validator: (v) => v == null ? 'Required' : null,
        ),

        const SizedBox(height: 20),
        _chipGroup('Core Expertise', _expertiseOptions, _selectedExpertise),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // STEP 3 — Partnership Model
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildPartnershipStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _stepHeader(
        //   'Partnership Model',
        //   'Define how you want to collaborate',
        //   Icons.account_tree_outlined,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Collaboration Structure'),
        DropdownButtonFormField<String>(
          value: _selectedPartnershipModel,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            hint: 'Proposed Partnership Model',
            icon: Icons.account_tree_outlined,
          ),
          items: _partnershipModels
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: (v) => setState(() => _selectedPartnershipModel = v),
          validator: (v) => v == null ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _levelOfInvolvement,
          style: _inputStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14),
          decoration: _dec(
            hint: 'Level of Involvement',
            icon: Icons.bar_chart_rounded,
          ),
          items: _involvementLevels
              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
              .toList(),
          onChanged: (v) => setState(() => _levelOfInvolvement = v),
          validator: (v) => v == null ? 'Required' : null,
        ),

        const SizedBox(height: 20),
        _sectionLabel('Commercial Details'),
        TextFormField(
          controller: _commercialExpectationsController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Describe your commercial expectations...',
            icon: Icons.currency_rupee_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
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
        //   'Last step before you join PHIR!',
        //   Icons.verified_outlined,
        // ),
        const SizedBox(height: 12),

        _sectionLabel('Partnership History'),
        TextFormField(
          controller: _previousCollaborationController,
          maxLines: 3,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Describe your past partnerships...',
            icon: Icons.history_rounded,
          ),
        ),

        const SizedBox(height: 20),
        _sectionLabel('Partnership Reference'),
        TextFormField(
          controller: _referenceNameController,
          style: _inputStyle,
          textCapitalization: TextCapitalization.words,
          decoration: _dec(
            hint: 'Full name of your reference',
            icon: Icons.person_outline_rounded,
          ),
          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _referenceContactController,
          keyboardType: TextInputType.phone,
          style: _inputStyle,
          decoration: _dec(
            hint: 'Reference Contact Number',
            icon: Icons.phone_iphone_rounded,
            prefix: '+91  ',
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

        const SizedBox(height: 20),
        _sectionLabel('Compliance Check'),
        _toggleCard(
          title: 'Past Legal / Compliance Issues',
          subtitle: 'Have you faced any legal or compliance issues?',
          icon: Icons.gavel_rounded,
          value: _hasLegalIssues,
          onChanged: (v) => setState(() => _hasLegalIssues = v),
          activeColor: const Color(0xFFEF4444),
        ),
        const SizedBox(height: 16),
        _toggleCard(
          title: 'Partnership Agreement Signed',
          subtitle:
              'A formal partnership agreement has been reviewed and is ready to sign',
          icon: Icons.handshake_outlined,
          value: _hasPartnershipAgreement,
          onChanged: (v) => setState(() => _hasPartnershipAgreement = v),
        ),

        const SizedBox(height: 20),
        _sectionLabel('Agreement Tenure'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: _purple.withOpacity(0.05),
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
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: _textLight,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Partnership Duration',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Specify the intended tenure for this partnership agreement',
                style: TextStyle(fontSize: 12, color: _textMid),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _agreementTenureController,
                style: _inputStyle,
                decoration: _dec(
                  hint: 'e.g. 1 Year, 6 Months, 2 Years...',
                  icon: Icons.timelapse_rounded,
                ),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
            ],
          ),
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
                '• PHIR reserves the right to verify all credentials independently.\n'
                '• False or misleading information may result in immediate rejection.\n'
                '• Partnership terms are subject to PHIR\'s approval and policies.\n'
                '• You agree to comply with all applicable laws and regulations.',
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
        _sectionLabel('Agreement'),
        _confirmCard(
          text:
              'I agree to follow PHIR Wealth policies, code of conduct, and ethical guidelines.',
          value: _agreeToFollowPolicies,
          onChanged: (v) => setState(() => _agreeToFollowPolicies = v ?? false),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
