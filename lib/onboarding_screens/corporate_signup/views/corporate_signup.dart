
// ==================== CORPORATE SIGNUP SCREEN ====================
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

  // Step 1: Corporate Details
  final _companyNameController = TextEditingController();
  final _industryTypeController = TextEditingController();
  final _employeeCountController = TextEditingController();
  String? _companySize;
  final _locationController = TextEditingController();
  final _branchesController = TextEditingController();

  // Point of Contact
  final _pocNameController = TextEditingController();
  final _pocDesignationController = TextEditingController();
  final _pocEmailController = TextEditingController();
  final _pocMobileController = TextEditingController();
  final _registrationNumberController = TextEditingController();

  // Step 2: Interest Areas
  final List<String> _selectedInterests = [];
  final List<String> _selectedServices = [];
  final _goalsObjectivesController = TextEditingController();
  final _currentChallengesController = TextEditingController();
  bool _isLargeAudience = false;

  // Step 3: Service Preferences
  String? _preferredMode;
  final _expectedTimelineController = TextEditingController();
  final _indicativeBudgetController = TextEditingController();
  final _experienceDetailsController = TextEditingController();
  final _kpiController = TextEditingController();

  // Step 4: Final Details
  final _approvalAuthorityController = TextEditingController();
  final _approvalRoleController = TextEditingController();
  final _approvalProcessController = TextEditingController();

  // Auth
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
  ];

  final List<String> _companySizes = [
    'Small (1-50 employees)',
    'Medium (51-250 employees)',
    'Large (251-1000 employees)',
    'Enterprise (1000+ employees)',
  ];

  final List<String> _preferredModes = ['Onsite', 'Online', 'Hybrid'];

  @override
  void dispose() {
    _companyNameController.dispose();
    _industryTypeController.dispose();
    _employeeCountController.dispose();
    _locationController.dispose();
    _branchesController.dispose();
    _pocNameController.dispose();
    _pocDesignationController.dispose();
    _pocEmailController.dispose();
    _pocMobileController.dispose();
    _registrationNumberController.dispose();
    _goalsObjectivesController.dispose();
    _currentChallengesController.dispose();
    _expectedTimelineController.dispose();
    _indicativeBudgetController.dispose();
    _experienceDetailsController.dispose();
    _kpiController.dispose();
    _approvalAuthorityController.dispose();
    _approvalRoleController.dispose();
    _approvalProcessController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF27AE60),
        foregroundColor: Colors.white,
        title: const Text('Corporate Registration'),
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
            if (_currentStep < 3) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              if (_formKey.currentState!.validate()) {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27AE60),
                      ),
                      child: Text(
                        details.currentStep == 3 ? 'Submit' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Corporate Details'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildCorporateDetailsStep(),
            ),
            Step(
              title: const Text('Interest Areas'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildInterestAreasStep(),
            ),
            Step(
              title: const Text('Service Preferences'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildServicePreferencesStep(),
            ),
            Step(
              title: const Text('Final Details'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: _buildFinalDetailsStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorporateDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _companyNameController,
          decoration: const InputDecoration(
            labelText: 'Company Name *',
            prefixIcon: Icon(Icons.business),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _industryTypeController,
          decoration: const InputDecoration(
            labelText: 'Industry Type *',
            prefixIcon: Icon(Icons.category),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _companySize,
          decoration: const InputDecoration(
            labelText: 'Company Size *',
            prefixIcon: Icon(Icons.people),
          ),
          items: _companySizes.map((size) {
            return DropdownMenuItem(value: size, child: Text(size));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _companySize = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _employeeCountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Employees *',
            prefixIcon: Icon(Icons.group),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Location *',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _branchesController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of Branches',
            prefixIcon: Icon(Icons.store),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _registrationNumberController,
          decoration: const InputDecoration(
            labelText: 'Corporate Registration Number *',
            prefixIcon: Icon(Icons.badge),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 24),
        const Text(
          'Point of Contact',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _pocNameController,
          decoration: const InputDecoration(
            labelText: 'Contact Person Name *',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _pocDesignationController,
          decoration: const InputDecoration(
            labelText: 'Designation *',
            prefixIcon: Icon(Icons.work),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _pocEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Official Email *',
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
          controller: _pocMobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile Number *',
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
      ],
    );
  }

  Widget _buildInterestAreasStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Interest Areas *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interestAreas.map((area) {
            final isSelected = _selectedInterests.contains(area);
            return FilterChip(
              label: Text(area, style: const TextStyle(fontSize: 12)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(area);
                  } else {
                    _selectedInterests.remove(area);
                  }
                });
              },
              selectedColor: const Color(0xFF27AE60).withOpacity(0.3),
              checkmarkColor: const Color(0xFF27AE60),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text(
          'Services Required *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _serviceOptions.map((service) {
            final isSelected = _selectedServices.contains(service);
            return FilterChip(
              label: Text(service),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedServices.add(service);
                  } else {
                    _selectedServices.remove(service);
                  }
                });
              },
              selectedColor: const Color(0xFF27AE60).withOpacity(0.3),
              checkmarkColor: const Color(0xFF27AE60),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _goalsObjectivesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Goals & Objectives *',
            prefixIcon: Icon(Icons.flag),
            hintText: 'What do you want to achieve?',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _currentChallengesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Current Challenges',
            prefixIcon: Icon(Icons.warning),
            hintText: 'What challenges are you facing?',
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Large Audience/Influencer'),
          subtitle: const Text(
            'Do you have a large employee base or influence?',
          ),
          value: _isLargeAudience,
          onChanged: (value) {
            setState(() {
              _isLargeAudience = value;
            });
          },
          activeColor: const Color(0xFF27AE60),
        ),
      ],
    );
  }

  Widget _buildServicePreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _preferredMode,
          decoration: const InputDecoration(
            labelText: 'Preferred Mode *',
            prefixIcon: Icon(Icons.settings),
          ),
          items: _preferredModes.map((mode) {
            return DropdownMenuItem(value: mode, child: Text(mode));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _preferredMode = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _expectedTimelineController,
          decoration: const InputDecoration(
            labelText: 'Expected Timeline *',
            prefixIcon: Icon(Icons.calendar_today),
            hintText: 'e.g., 3 months, Q2 2026',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _indicativeBudgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Indicative Budget (₹)',
            prefixIcon: Icon(Icons.currency_rupee),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _experienceDetailsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Experience Details',
            prefixIcon: Icon(Icons.history_edu),
            hintText: 'Previous experience with similar services',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _kpiController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Key Success Metrics (KPIs) *',
            prefixIcon: Icon(Icons.analytics),
            hintText: 'How will you measure success?',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildFinalDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Decision Making',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _approvalAuthorityController,
          decoration: const InputDecoration(
            labelText: 'Approval Authority Name *',
            prefixIcon: Icon(Icons.verified_user),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _approvalRoleController,
          decoration: const InputDecoration(
            labelText: 'Approval Authority Role *',
            prefixIcon: Icon(Icons.work),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _approvalProcessController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Approval Process *',
            prefixIcon: Icon(Icons.account_tree),
            hintText: 'Describe your internal approval process',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF27AE60).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF27AE60).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.info, color: Color(0xFF27AE60)),
                  SizedBox(width: 8),
                  Text(
                    'Next Steps',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27AE60),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'After submitting your application:\n'
                '1. Our team will review your details\n'
                '2. You will receive a confirmation email\n'
                '3. A dedicated account manager will contact you\n'
                '4. We will schedule an initial consultation',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}