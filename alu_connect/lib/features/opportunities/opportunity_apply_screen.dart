import 'package:flutter/material.dart';
import 'models/opportunity_model.dart';
import '../../theme/app_theme.dart';

class OpportunityApplyScreen extends StatefulWidget {
  final Opportunity opportunity;

  const OpportunityApplyScreen({super.key, required this.opportunity});

  @override
  State<OpportunityApplyScreen> createState() => _OpportunityApplyScreenState();
}

class _OpportunityApplyScreenState extends State<OpportunityApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _motivationController = TextEditingController();
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isSubmitting = false);

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
          title: const Text('Application Submitted! 🎉', style: TextStyle(color: AppColors.textPrimary)),
          content: Text('You have successfully applied for ${widget.opportunity.title}.', style: const TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Apply', style: TextStyle(color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Applying for:', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(widget.opportunity.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              _buildField('Full Name', _nameController, 'Enter your full name'),
              const SizedBox(height: 16),
              _buildField('Email Address', _emailController, 'Enter your email', isEmail: true),
              const SizedBox(height: 16),
              _buildField('Why do you want this opportunity?', _motivationController, 'Write your motivation...', maxLines: 5),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: AppColors.onPrimary)
                      : const Text('Submit Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String hint, {bool isEmail = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.textPrimary),
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
          decoration: InputDecoration(hintText: hint),
          validator: (value) {
            if (value == null || value.isEmpty) return 'This field is required';
            if (isEmail && !value.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
      ],
    );
  }
}