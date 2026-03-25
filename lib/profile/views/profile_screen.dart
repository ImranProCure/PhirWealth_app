import 'package:flutter/material.dart';
import 'package:phir_wealth/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const Color _primary   = Color(0xFF7C5CBF);
  static const Color _secondary = Color(0xFF667EEA);
  static const Color _bg        = Color(0xFFF5F7FA);
  static const Color _fill      = Color(0xFFF5F3FF);
  static const Color _textDark  = Color(0xFF1E1B4B);
  static const Color _textMid   = Color(0xFF64748B);
  static const Color _textLight = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textDark)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.edit_outlined, color: _primary, size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Header ─────────────────────────────────────────────
            _buildProfileHeader(),

            // ── Stats Row ──────────────────────────────────────────────────
            _buildStatsRow(),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── My Account ──────────────────────────────────────────
                  _groupLabel('My Account'),
                  const SizedBox(height: 10),
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Wealth Report',
                      subtitle: 'View your financial report',
                      color: const Color(0xFF667EEA),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const WealthReportScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'My Investments',
                      subtitle: 'Track your portfolio',
                      color: const Color(0xFF43E97B),
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'My Loans',
                      subtitle: 'View active loan applications',
                      color: const Color(0xFF4FACFE),
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── About Phir Wealth ────────────────────────────────────
                  _groupLabel('Phir Wealth'),
                  const SizedBox(height: 10),
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About Us',
                      subtitle: 'Learn more about Phir Wealth',
                      color: _primary,
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const AboutScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.verified_outlined,
                      label: 'Why Choose Us',
                      subtitle: 'See what makes us different',
                      color: const Color(0xFF9473B3),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const WhyUsScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.format_quote_rounded,
                      label: 'Testimonials',
                      subtitle: 'Read success stories',
                      color: const Color(0xFFF59E0B),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const TestimonialsScreen())),
                    ),
                    _MenuItem(
                      icon: Icons.headset_mic_outlined,
                      label: 'Contact Us',
                      subtitle: 'Get in touch with our team',
                      color: const Color(0xFF4FACFE),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ContactScreen())),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── Support ──────────────────────────────────────────────
                  _groupLabel('Support'),
                  const SizedBox(height: 10),
                  _buildMenuGroup([
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      subtitle: 'App preferences & security',
                      color: _textMid,
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      subtitle: 'FAQs and assistance',
                      color: const Color(0xFF43E97B),
                      onTap: () {},
                    ),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      subtitle: 'How we handle your data',
                      color: _textLight,
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // ── Logout ───────────────────────────────────────────────
                  _buildLogoutButton(context),

                  const SizedBox(height: 12),
                  Center(
                    child: Text('Phir Wealth v1.0.0',
                        style: TextStyle(
                            fontSize: 11, color: _textLight.withOpacity(0.6), fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ─────────────────────────────────────────────────────────
  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C5CBF), Color(0xFF667EEA)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.3),
                      blurRadius: 14, offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('AB',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                ),
              ),
              Positioned(
                bottom: 0, right: 0,
                child: Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF43E97B),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Amit Bhargava',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _textDark)),
                const SizedBox(height: 3),
                const Text('amit.bhargava@email.com',
                    style: TextStyle(fontSize: 13, color: _textMid, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _fill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _primary.withOpacity(0.2)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: _primary, size: 13),
                      SizedBox(width: 4),
                      Text('Premium Member',
                          style: TextStyle(color: _primary, fontSize: 11, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _fill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _primary.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Expanded(child: _statItem('₹12.4L', 'Portfolio', Icons.trending_up_rounded, const Color(0xFF667EEA))),
            _verticalDivider(),
            Expanded(child: _statItem('6', 'Policies', Icons.shield_outlined, const Color(0xFF43E97B))),
            _verticalDivider(),
            Expanded(child: _statItem('₹46.8K', 'Tax Saved', Icons.savings_outlined, const Color(0xFFF59E0B))),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon, Color color) {
    return Column(children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _textDark)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: _textLight, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _verticalDivider() => Container(width: 1, height: 40, color: _primary.withOpacity(0.12));

  // ── Group Label ────────────────────────────────────────────────────────────
  Widget _groupLabel(String label) {
    return Row(children: [
      Container(width: 4, height: 16,
          decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 8),
      Text(label,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: _primary, letterSpacing: 0.4)),
    ]);
  }

  // ── Menu Group ─────────────────────────────────────────────────────────────
  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i    = e.key;
          final item = e.value;
          final isLast = i == items.length - 1;
          return Column(children: [
            InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                child: Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(item.icon, color: item.color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(item.label,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _textDark)),
                      const SizedBox(height: 2),
                      Text(item.subtitle,
                          style: const TextStyle(fontSize: 12, color: _textLight, fontWeight: FontWeight.w500)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: _textLight, size: 20),
                ]),
              ),
            ),
            if (!isLast)
              Padding(
                padding: const EdgeInsets.only(left: 70),
                child: Divider(height: 1, color: Colors.grey.shade100),
              ),
          ]);
        }).toList(),
      ),
    );
  }

  // ── Logout Button ──────────────────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w800, color: _textDark)),
          content: const Text('Are you sure you want to logout?',
              style: TextStyle(color: _textMid, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: _textMid, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.25), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
            SizedBox(width: 8),
            Text('Logout', style: TextStyle(color: Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

// ── Helper model ──────────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}