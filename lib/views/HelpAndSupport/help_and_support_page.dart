import 'package:flutter/material.dart';
import 'package:bgisp/utils/language_helper.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedCategory = 'general_inquiry';

  final Map<String, String> _categories = {
    'general_inquiry': 'General Inquiry',
    'technical_support': 'Technical Support',
    'data_access': 'Data Access',
    'account_issues': 'Account Issues',
    'feedback': 'Feedback',
    'partnership': 'Partnership',
  };

  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateLanguage);
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateLanguage);
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _updateLanguage() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleLanguage() {
    if (_languageHelper.isEnglish) {
      _languageHelper.setLanguage('bn');
    } else {
      _languageHelper.setLanguage('en');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageHelper.translate('help_support_page_title'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Language toggle button
          IconButton(
            icon: Icon(
              Icons.translate,
              color: Colors.white,
              semanticLabel: _languageHelper.translate('toggle_language'),
            ),
            onPressed: _toggleLanguage,
            tooltip: _languageHelper.translate('toggle_language'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(),

            // Contact Form
            _buildContactForm(),

            // Contact Information
            _buildContactInformation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.support_agent, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            _languageHelper.translate('how_can_we_help'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _languageHelper.translate('help_support_subtitle'),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: _languageHelper.translate('search'),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _languageHelper.translate('send_us_message'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _languageHelper.translate('contact_form_subtitle'),
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('category'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categories.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(_getCategoryTranslation(entry.key)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${_languageHelper.translate('please_select')} ${_languageHelper.translate('category').toLowerCase()}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('your_name'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${_languageHelper.translate('Please enter')} ${_languageHelper.translate('your_name').toLowerCase()}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('your_email'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${_languageHelper.translate('Please enter')} ${_languageHelper.translate('your_email').toLowerCase()}';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return _languageHelper.translate('invalid_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('subject'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.subject),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${_languageHelper.translate('Please enter')} ${_languageHelper.translate('subject').toLowerCase()}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('your_message'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '${_languageHelper.translate('Please enter')} ${_languageHelper.translate('your_message').toLowerCase()}';
                    }
                    if (value.length < 10) {
                      return _languageHelper.translate('message_min_length');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 100.0,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _languageHelper.translate('submit'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF0D47A1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _languageHelper.translate('contact_information'),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            icon: Icons.location_on,
            titleKey: 'head_office',
            valueKey: 'head_office_address',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.phone,
            titleKey: 'phone_numbers',
            valueKey: 'phone_numbers_list',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email,
            titleKey: 'email',
            valueKey: 'email_list',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.language,
            titleKey: 'website',
            valueKey: 'website_list',
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.access_time,
            titleKey: 'office_hours',
            valueKey: 'office_hours_list',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String titleKey,
    required String valueKey,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _languageHelper.translate(titleKey),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _languageHelper.translate(valueKey),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_languageHelper.translate('message_sent')),
          content: Text(
            _languageHelper.translate('thank_you_message'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: Text(_languageHelper.translate('ok')),
            ),
          ],
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
    setState(() {
      _selectedCategory = 'general_inquiry';
    });
  }

  // Helper method to get category translations
  String _getCategoryTranslation(String categoryKey) {
    switch (categoryKey) {
      case 'general_inquiry':
        return _languageHelper.isEnglish ? 'General Inquiry' : 'সাধারণ জিজ্ঞাসা';
      case 'technical_support':
        return _languageHelper.isEnglish ? 'Technical Support' : 'প্রযুক্তিগত সহায়তা';
      case 'data_access':
        return _languageHelper.isEnglish ? 'Data Access' : 'ডেটা অ্যাক্সেস';
      case 'account_issues':
        return _languageHelper.isEnglish ? 'Account Issues' : 'অ্যাকাউন্ট সমস্যা';
      case 'feedback':
        return _languageHelper.isEnglish ? 'Feedback' : 'প্রতিক্রিয়া';
      case 'partnership':
        return _languageHelper.isEnglish ? 'Partnership' : 'অংশীদারিত্ব';
      default:
        return categoryKey;
    }
  }
}