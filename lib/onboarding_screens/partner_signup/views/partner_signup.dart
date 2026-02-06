
// ==================== PARTNER SIGNUP SCREEN ====================
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

  // Step 1: Organizational Identity
  final _companyNameController = TextEditingController();
  final _companySectorController = TextEditingController();
  final List<String> _selectedPartnerTypes = [];
  final _geographicalPresenceController = TextEditingController();

  // Step 2: Professional Background
  final _licenceCertificateController = TextEditingController();
  final List<String> _selectedExpertise = [];
  final _experienceYearsController = TextEditingController();

  // Step 3: Partnership Model
  String? _selectedPartnershipModel;
  String? _selectedPartnershipType;
  final _commercialExpectationsController = TextEditingController();
  String? _levelOfInvolvement;

  // Step 4: Partnership History & Compliance
  final _previousCollaborationController = TextEditingController();
  bool _agreeToFollowPolicies = false;
  bool _hasLegalIssues = false;
  final _motivationController = TextEditingController();

  // Contact & Auth
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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

  @override
  void dispose() {
    _companyNameController.dispose();
    _companySectorController.dispose();
    _geographicalPresenceController.dispose();
    _licenceCertificateController.dispose();
    _experienceYearsController.dispose();
    _commercialExpectationsController.dispose();
    _previousCollaborationController.dispose();
    _motivationController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8E44AD),
        foregroundColor: Colors.white,
        title: const Text('Partner Registration'),
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
                if (!_agreeToFollowPolicies) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please agree to follow PHIR policies'),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E44AD),
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
              title: const Text('Organization'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildOrganizationStep(),
            ),
            Step(
              title: const Text('Background'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildBackgroundStep(),
            ),
            Step(
              title: const Text('Partnership'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildPartnershipStep(),
            ),
            Step(
              title: const Text('Verification'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: _buildPartnerVerificationStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: _emailController,
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
        TextFormField(
          controller: _companySectorController,
          decoration: const InputDecoration(
            labelText: 'Company Working Sector *',
            prefixIcon: Icon(Icons.work),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        const Text(
          'Partner Type *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _partnerTypes.map((type) {
            final isSelected = _selectedPartnerTypes.contains(type);
            return FilterChip(
              label: Text(type, style: const TextStyle(fontSize: 12)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPartnerTypes.add(type);
                  } else {
                    _selectedPartnerTypes.remove(type);
                  }
                });
              },
              selectedColor: const Color(0xFF8E44AD).withOpacity(0.3),
              checkmarkColor: const Color(0xFF8E44AD),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _geographicalPresenceController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Geographical Presence *',
            prefixIcon: Icon(Icons.location_on),
            hintText: 'Cities/States where you operate',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _licenceCertificateController,
          decoration: const InputDecoration(
            labelText: 'Licence Certificate *',
            prefixIcon: Icon(Icons.badge),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        const Text(
          'Core Expertise *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _expertiseOptions.map((expertise) {
            final isSelected = _selectedExpertise.contains(expertise);
            return FilterChip(
              label: Text(expertise),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedExpertise.add(expertise);
                  } else {
                    _selectedExpertise.remove(expertise);
                  }
                });
              },
              selectedColor: const Color(0xFF8E44AD).withOpacity(0.3),
              checkmarkColor: const Color(0xFF8E44AD),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _experienceYearsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Relevant Experience (years) *',
            prefixIcon: Icon(Icons.work_history),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildPartnershipStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedPartnershipModel,
          decoration: const InputDecoration(
            labelText: 'Proposed Model *',
            prefixIcon: Icon(Icons.handshake),
          ),
          items: _partnershipModels.map((model) {
            return DropdownMenuItem(value: model, child: Text(model));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPartnershipModel = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _commercialExpectationsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Commercial Expectations *',
            prefixIcon: Icon(Icons.attach_money),
            hintText: 'Describe your commercial expectations',
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _levelOfInvolvement,
          decoration: const InputDecoration(
            labelText: 'Level of Involvement *',
            prefixIcon: Icon(Icons.access_time),
          ),
          items: _involvementLevels.map((level) {
            return DropdownMenuItem(value: level, child: Text(level));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _levelOfInvolvement = value;
            });
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildPartnerVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _previousCollaborationController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Previous Collaboration Experience',
            prefixIcon: Icon(Icons.history),
            hintText: 'Describe your partnership history',
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Any past legal/compliance issues?'),
          value: _hasLegalIssues,
          onChanged: (value) {
            setState(() {
              _hasLegalIssues = value;
            });
          },
          activeColor: const Color(0xFFE74C3C),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _motivationController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Why do you want to partner with us? *',
            prefixIcon: Icon(Icons.lightbulb),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Required';
            if (value!.length < 50) return 'Please provide more details';
            return null;
          },
        ),
        const SizedBox(height: 24),
        CheckboxListTile(
          title: const Text(
            'I agree to follow PHIR policies & ethics',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          value: _agreeToFollowPolicies,
          onChanged: (value) {
            setState(() {
              _agreeToFollowPolicies = value ?? false;
            });
          },
          activeColor: const Color(0xFF8E44AD),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}