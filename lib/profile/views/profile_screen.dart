
// ==================== PROFILE SCREEN ====================
import 'package:flutter/material.dart';
import 'package:phir_wealth/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line

        title: const Text('Profile'),
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE89E3C),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'john.doe@email.com',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 30),
              _buildProfileOption(
                Icons.info,
                'About Us',
                'Learn more about Phir Wealth',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              _buildProfileOption(
                Icons.star,
                'Why Choose Us',
                'See what makes us different',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WhyUsScreen(),
                    ),
                  );
                },
              ),
              _buildProfileOption(
                Icons.reviews,
                'Testimonials',
                'Read success stories',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TestimonialsScreen(),
                    ),
                  );
                },
              ),
              _buildProfileOption(
                Icons.contact_mail,
                'Contact Us',
                'Get in touch with us',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                Icons.assessment,
                'Wealth Report',
                'View your financial report',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WealthReportScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildProfileOption(
                Icons.settings,
                'Settings',
                'App preferences',
                () {},
              ),
              _buildProfileOption(
                Icons.help,
                'Help & Support',
                'Get assistance',
                () {},
              ),
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE89E3C), size: 28),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}