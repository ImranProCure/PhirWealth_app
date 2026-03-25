import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerifyScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen>
    with SingleTickerProviderStateMixin {

  // ── Brand Colors (matching login & signup screens) ─────────────────────────
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);
  static const Color _bgColor = Color(0xFFF8F8FF);
  static const Color _textDark = Color(0xFF0F172A);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFFB0B8C1);
  static const Color _errorColor = Color(0xFFEF4444);
  static const Color _successColor = Color(0xFF22C55E);

  // ── OTP Fields ─────────────────────────────────────────────────────────────
  static const int _otpLength = 4;
  final List<TextEditingController> _controllers =
      List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_otpLength, (_) => FocusNode());

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _hasError = false;
  String _errorMessage = '';

  // ── Timer ──────────────────────────────────────────────────────────────────
  static const int _resendSeconds = 30;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;
  bool _canResend = false;

  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  // ── Timer Logic ────────────────────────────────────────────────────────────
  void _startTimer() {
    _canResend = false;
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resendOtp() {
    if (!_canResend) return;
    for (final c in _controllers) c.clear();
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    _focusNodes[0].requestFocus();
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP resent successfully!'),
        backgroundColor: _purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }

  // ── OTP Handling ───────────────────────────────────────────────────────────
  void _onOtpChanged(String value, int index) {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.length == _otpLength) {
      for (int i = 0; i < _otpLength; i++) _controllers[i].text = value[i];
      _focusNodes[_otpLength - 1].requestFocus();
      _verifyOtp();
      return;
    }
    if (index == _otpLength - 1 && value.isNotEmpty) {
      final otp = _controllers.map((c) => c.text).join();
      if (otp.length == _otpLength) _verifyOtp();
    }
  }

  void _onKeyPress(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    final otp = _currentOtp;
    if (otp.length < _otpLength) return;
    setState(() {
      _isVerifying = true;
      _hasError = false;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (otp == '1234') {
      setState(() {
        _isVerifying = false;
        _isVerified = true;
      });
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) Navigator.pushReplacementNamed(context, '/main');
    } else {
      setState(() {
        _isVerifying = false;
        _hasError = true;
        _errorMessage = 'Invalid OTP. Please try again.';
      });
      for (final c in _controllers) c.clear();
      _focusNodes[0].requestFocus();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _purple, size: 18),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // ── Header Icon ──────────────────────────────────────────
                  _buildHeaderIcon(),
                  const SizedBox(height: 28),

                  // ── Title ────────────────────────────────────────────────
                  const Text(
                    'Verify Your Number',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: _textDark,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: _textMid,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'We\'ve sent a 4-digit OTP to\n'),
                        TextSpan(
                          text: '+91 ${widget.phoneNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _purple,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── OTP Boxes ────────────────────────────────────────────
                  _buildOtpBoxes(),

                  // ── Error Message ────────────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _hasError
                        ? Padding(
                            key: const ValueKey('error'),
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline_rounded,
                                    color: _errorColor, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: _errorColor,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(key: ValueKey('no-error'), height: 16),
                  ),

                  const SizedBox(height: 32),

                  // ── Verify Button ────────────────────────────────────────
                  _buildVerifyButton(),
                  const SizedBox(height: 28),

                  // ── Resend ───────────────────────────────────────────────
                  _buildResendRow(),
                  const SizedBox(height: 40),

                  // ── Info Note ────────────────────────────────────────────
                  _buildInfoNote(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Header Icon ─────────────────────────────────────────────────────────────
  Widget _buildHeaderIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _purple.withOpacity(0.08),
          ),
        ),
        // Inner gradient icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_purple, _blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _purple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isVerified
                ? const Icon(Icons.check_rounded,
                    key: ValueKey('check'), color: Colors.white, size: 40)
                : const Icon(Icons.sms_outlined,
                    key: ValueKey('sms'), color: Colors.white, size: 36),
          ),
        ),
      ],
    );
  }

  // ── OTP Boxes ────────────────────────────────────────────────────────────────
  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_otpLength, (index) {
        final isFilled = _controllers[index].text.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(right: index < _otpLength - 1 ? 14 : 0),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _onKeyPress(event, index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 68,
              decoration: BoxDecoration(
                color: _isVerified
                    ? _successColor.withOpacity(0.08)
                    : _hasError
                        ? _errorColor.withOpacity(0.07)
                        : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isVerified
                      ? _successColor
                      : _hasError
                          ? _errorColor
                          : isFilled
                              ? _purple
                              : const Color(0xFFE5E7EB),
                  width: isFilled || _hasError || _isVerified ? 1.5 : 1,
                ),
                boxShadow: isFilled && !_hasError
                    ? [
                        BoxShadow(
                          color: _purple.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _isVerified
                      ? _successColor
                      : _hasError
                          ? _errorColor
                          : _textDark,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onOtpChanged(value, index),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Verify Button ────────────────────────────────────────────────────────────
  Widget _buildVerifyButton() {
    final otpFilled = _currentOtp.length == _otpLength;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isVerified
                ? [const Color(0xFF16A34A), const Color(0xFF22C55E)]
                : otpFilled
                    ? [_purple, _blue]
                    : [_purple.withOpacity(0.4), _blue.withOpacity(0.4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: otpFilled
              ? [
                  BoxShadow(
                    color: (_isVerified ? _successColor : _purple)
                        .withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _isVerifying || _isVerified || !otpFilled ? null : _verifyOtp,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isVerifying
                    ? const SizedBox(
                        key: ValueKey('loading'),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : _isVerified
                        ? const Row(
                            key: ValueKey('verified'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Verified!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          )
                        : const Row(
                            key: ValueKey('verify'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.verified_user_outlined,
                                  color: Colors.white, size: 20),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Resend Row ───────────────────────────────────────────────────────────────
  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Didn't receive OTP? ",
          style: TextStyle(color: _textMid, fontSize: 14),
        ),
        _canResend
            ? GestureDetector(
                onTap: _resendOtp,
                child: const Text(
                  'Resend',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: _purple,
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14),
                  children: [
                    const TextSpan(
                      text: 'Resend in ',
                      style: TextStyle(color: _textLight),
                    ),
                    TextSpan(
                      text: '${_secondsLeft}s',
                      style: const TextStyle(
                        color: _purple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  // ── Info Note ────────────────────────────────────────────────────────────────
  Widget _buildInfoNote() {
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
          const Icon(Icons.info_outline_rounded, color: _purple, size: 17),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'This OTP is valid for 10 minutes. Do not share it with anyone. '
              'Phir Wealth will never ask for your OTP.',
              style: TextStyle(fontSize: 12.5, color: _textMid, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}