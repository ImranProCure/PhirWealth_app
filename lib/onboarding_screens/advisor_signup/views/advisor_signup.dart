
// ==================== ADVISOR SIGNUP SCREEN ====================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvisorSignupScreen extends StatefulWidget {
  const AdvisorSignupScreen({Key? key}) : super(key: key);

  @override
  State<AdvisorSignupScreen> createState() => _AdvisorSignupScreenState();
}

class _AdvisorSignupScreenState extends State<AdvisorSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Step 1: Basic Profile
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedSpecialization;
  final _educationDegreeController = TextEditingController();
  final _licenceNumberController = TextEditingController();
  String? _certificateYear;
  bool _canPracticeIndependently = false;

  // Step 2: Experience & Expertise
  final _totalExperienceController = TextEditingController();
  final _specializationExperienceController = TextEditingController();
  final _practiceDetailsController = TextEditingController();
  final _instituteNameController = TextEditingController();
  final _yearsOfAssociationController = TextEditingController();
  final _achievementsController = TextEditingController();

  // Step 3: Digital Readiness
  final _techProtocolsController = TextEditingController();
  bool _hasTelechonsultationExperience = false;
  final _suitableTimingController = TextEditingController();

  // Step 4: Language & Charges
  final List<String> _selectedLanguages = [];
  final _sessionTimeController = TextEditingController();
  final _sessionChargesController = TextEditingController();

  // Step 5: Final Verification
  bool _hasFacedLegalAction = false;
  final _motivationController = TextEditingController();
  bool _confirmInformation = false;

  bool _obscurePassword = true;

  final List<String> _specializations = [
    'Investment Planning',
    'Tax Planning',
    'Retirement Planning',
    'Insurance Planning',
    'Estate Planning',
    'Debt Management',
    'Mutual Funds',
    'Stock Market',
  ];

  final List<String> _languages = [
    'English',
    'Hindi',
    'Marathi',
    'Tamil',
    'Telugu',
    'Bengali',
    'Gujarati',
    'Kannada',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _educationDegreeController.dispose();
    _licenceNumberController.dispose();
    _totalExperienceController.dispose();
    _specializationExperienceController.dispose();
    _practiceDetailsController.dispose();
    _instituteNameController.dispose();
    _yearsOfAssociationController.dispose();
    _achievementsController.dispose();
    _techProtocolsController.dispose();
    _suitableTimingController.dispose();
    _sessionTimeController.dispose();
    _sessionChargesController.dispose();
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE89E3C),
        foregroundColor: Colors.white,
        title: const Text('Advisor Registration'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 4) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              if (_formKey.currentState!.validate()) {
                if (!_confirmInformation) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please confirm that your information is correct',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.pushReplacementNamed(context, '/main');
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  if (details.currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Back'),
                      ),
                    ),
                  if (details.currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                        details.currentStep == 4 ? 'Submit' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Basic Profile'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildBasicProfileStep(),
            ),
            Step(
              title: const Text('Experience'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildExperienceStep(),
            ),
            Step(
              title: const Text('Digital Readiness'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildDigitalReadinessStep(),
            ),
            Step(
              title: const Text('Languages & Charges'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: _buildLanguagesStep(),
            ),
            Step(
              title: const Text('Verification'),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 ? StepState.complete : StepState.indexed,
              content: _buildVerificationStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email ID *',
            prefixIcon: Icon(Icons.email),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Contact Number *',
            prefixIcon: Icon(Icons.phone),
            prefixText: '+91 ',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (value!.length != 10) return 'Invalid number';
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password *',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (value!.length < 8) return 'At least 8 characters';
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedSpecialization,
          decoration: const InputDecoration(
            labelText: 'Specialization *',
            prefixIcon: Icon(Icons.work),
          ),
          items: _specializations.map((spec) {
            return DropdownMenuItem(value: spec, child: Text(spec));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSpecialization = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _educationDegreeController,
          decoration: const InputDecoration(
            labelText: 'Educational Degree *',
            prefixIcon: Icon(Icons.school),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _licenceNumberController,
          decoration: const InputDecoration(
            labelText: 'Licence No / Certification No *',
            prefixIcon: Icon(Icons.badge),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _certificateYear,
          decoration: const InputDecoration(
            labelText: 'Year of Certificate *',
            prefixIcon: Icon(Icons.calendar_today),
          ),
          items: List.generate(30, (index) {
            int year = DateTime.now().year - index;
            return DropdownMenuItem(
              value: year.toString(),
              child: Text(year.toString()),
            );
          }),
          onChanged: (value) {
            setState(() {
              _certificateYear = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Licensed to Practice Independently'),
          value: _canPracticeIndependently,
          onChanged: (value) {
            setState(() {
              _canPracticeIndependently = value;
            });
          },
          activeColor: const Color(0xFFE89E3C),
        ),
      ],
    );
  }

  Widget _buildExperienceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _totalExperienceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Total Experience (years) *',
            prefixIcon: Icon(Icons.work_history),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _specializationExperienceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Specialization Experience (years) *',
            prefixIcon: Icon(Icons.star),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _practiceDetailsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Practice Details *',
            prefixIcon: Icon(Icons.description),
            hintText: 'Describe your current practice',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _instituteNameController,
          decoration: const InputDecoration(
            labelText: 'Current Association - Institute Name',
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _yearsOfAssociationController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Years of Association',
            prefixIcon: Icon(Icons.timer),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _achievementsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Achievements / Awards',
            prefixIcon: Icon(Icons.emoji_events),
            hintText: 'List your professional achievements',
          ),
        ),
      ],
    );
  }

  Widget _buildDigitalReadinessStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _techProtocolsController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Tech Protocols *',
            prefixIcon: Icon(Icons.computer),
            hintText: 'Describe your tech setup and capabilities',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Experience in Teleconsultation/Presentation'),
          value: _hasTelechonsultationExperience,
          onChanged: (value) {
            setState(() {
              _hasTelechonsultationExperience = value;
            });
          },
          activeColor: const Color(0xFFE89E3C),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _suitableTimingController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Suitable Timing for Online Services *',
            prefixIcon: Icon(Icons.access_time),
            hintText: 'e.g., Mon-Fri 9AM-6PM',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildLanguagesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferable Languages *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languages.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return FilterChip(
              label: Text(lang),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedLanguages.add(lang);
                  } else {
                    _selectedLanguages.remove(lang);
                  }
                });
              },
              selectedColor: const Color(0xFFE89E3C).withOpacity(0.3),
              checkmarkColor: const Color(0xFFE89E3C),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _sessionTimeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Per Session Time (minutes) *',
            prefixIcon: Icon(Icons.timer),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _sessionChargesController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Per Session Charges (₹) *',
            prefixIcon: Icon(Icons.currency_rupee),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Legal Check',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text(
            'Have you ever faced disciplinary or legal action related to your profession?',
          ),
          value: _hasFacedLegalAction,
          onChanged: (value) {
            setState(() {
              _hasFacedLegalAction = value;
            });
          },
          activeColor: const Color(0xFFE74C3C),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _motivationController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'What motivates you to join PHIR Wealth? *',
            prefixIcon: Icon(Icons.lightbulb),
            hintText: 'Share your motivation...',
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (value!.length < 50)
              return 'Please provide more details (at least 50 characters)';
            return null;
          },
        ),
        const SizedBox(height: 24),
        CheckboxListTile(
          title: const Text(
            'I confirm that the information provided is true and correct',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          value: _confirmInformation,
          onChanged: (value) {
            setState(() {
              _confirmInformation = value ?? false;
            });
          },
          activeColor: const Color(0xFFE89E3C),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}
