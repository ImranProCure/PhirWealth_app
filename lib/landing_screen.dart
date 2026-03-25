// ==================== ROLE SELECTION SCREEN ====================
import 'package:flutter/material.dart';
import 'package:phir_wealth/models/role_option.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  // Brand Colors
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);

  final List<RoleOption> _roles = [
    RoleOption(
      role: 'Customer',
      icon: "assets/images/people.png",
      description: 'Individual looking for wealth management services',
      color: const Color(0xFF8B5CF6),
    ),
    RoleOption(
      role: 'Advisor',
      icon: "assets/images/advisory.png",
      description: 'Financial advisor providing expert guidance',
      color: const Color(0xFF8B5CF6),
    ),
    RoleOption(
      role: 'Partner',
      icon: "assets/images/partners.png",
      description: 'Business partner collaborating with us',
      color: const Color(0xFF8B5CF6),
    ),
    RoleOption(
      role: 'Corporate',
      icon: "assets/images/corporate.png",
      description: 'Corporate entity seeking financial solutions',
      color: const Color(0xFF8B5CF6),
    ),
  ];

  void _continueToLogin() {
    if (_selectedRole != null) {
      Navigator.pushNamed(context, '/login', arguments: _selectedRole);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF), // Very light lavender-white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                'Select Your Role',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Choose how you want to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),

              // Role Cards
              Expanded(
                child: ListView.separated(
                  itemCount: _roles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role.role;

                    return _RoleCard(
                      role: role,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedRole = role.role;
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Continue to Login Button
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: _selectedRole != null
                      ? const LinearGradient(
                          colors: [_purple, _blue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: _selectedRole != null ? null : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: _selectedRole != null
                      ? [
                          BoxShadow(
                            color: _purple.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _selectedRole != null ? _continueToLogin : null,
                    borderRadius: BorderRadius.circular(30),
                    child: Center(
                      child: Text(
                        'Continue to Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _selectedRole != null
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bottom help text
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Need help deciding? ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    children: [
                      TextSpan(
                        text: 'Corporates',
                        style: const TextStyle(
                          fontSize: 14,
                          color: _purple,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: _purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final RoleOption role;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _blue = Color(0xFF3B82F6);

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF3EEFF) // light purple tint
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _purple : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? _purple.withOpacity(0.12)
                  : Colors.black.withOpacity(0.04),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container with gradient background
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [_purple, _blue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : const Color(0xFFF0EEFF),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                role.icon,
                color: isSelected ? Colors.white : _purple,
              ),
            ),
            const SizedBox(width: 16),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.role,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? _purple : const Color(0xFF1A1A2E),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Arrow Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? _purple.withOpacity(0.1)
                    : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isSelected ? _purple : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}