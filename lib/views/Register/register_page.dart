import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, String?> _validationErrors = {};

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearValidationError(String field) {
    if (_validationErrors.containsKey(field)) {
      setState(() {
        _validationErrors[field] = null;
      });
    }
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  bool _validateForm() {
    final errors = <String, String>{};

    // Name validation
    if (_nameController.text.trim().isEmpty) {
      errors['name'] = 'Full name is required';
    }

    // Username validation
    if (_usernameController.text.trim().isEmpty) {
      errors['username'] = 'Username is required';
    } else if (_usernameController.text.trim().length < 3) {
      errors['username'] = 'Username must be at least 3 characters';
    }

    // Email validation
    if (_emailController.text.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
        .hasMatch(_emailController.text.trim())) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Password validation
    if (_passwordController.text.isEmpty) {
      errors['password'] = 'Password is required';
    } else if (_passwordController.text.length < 8) {
      errors['password'] = 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$')
        .hasMatch(_passwordController.text)) {
      errors['password'] = 'Password must contain both letters and numbers';
    }

    // Confirm password validation
    if (_confirmPasswordController.text.isEmpty) {
      errors['confirmPassword'] = 'Please confirm your password';
    } else if (_confirmPasswordController.text != _passwordController.text) {
      errors['confirmPassword'] = 'Passwords do not match';
    }

    setState(() {
      _validationErrors.clear();
      _validationErrors.addAll(errors);
    });

    return errors.isEmpty;
  }

  Future<void> _register() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual API call
      // final response = await AuthApi.register(...);

      // Simulate successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 480;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFf7fafc),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16.0 : 32.0,
              vertical: isSmallScreen ? 16.0 : 32.0,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Register Card
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      transform: Matrix4.translationValues(
                        0,
                        _errorMessage == null ? 0 : 10,
                        0,
                      ),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              isSmallScreen ? 20.0 : 32.0,
                            ),
                            child: Column(
                              children: [
                                // Header Section
                                const SizedBox(height: 8),
                                _buildHeader(),
                                const SizedBox(height: 32),

                                // Error Alert
                                if (_errorMessage != null)
                                  _buildErrorAlert(),
                                
                                SizedBox(height: _errorMessage != null ? 16 : 0),

                                // Form
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      // Name Field
                                      _buildNameField(),
                                      const SizedBox(height: 12),

                                      // Username Field
                                      _buildUsernameField(),
                                      const SizedBox(height: 12),

                                      // Email Field
                                      _buildEmailField(),
                                      const SizedBox(height: 12),

                                      // Password Field
                                      _buildPasswordField(),
                                      const SizedBox(height: 12),

                                      // Confirm Password Field
                                      _buildConfirmPasswordField(),
                                      const SizedBox(height: 20),

                                      // Register Button
                                      _buildRegisterButton(),
                                    ],
                                  ),
                                ),

                                // Auth Links
                                _buildAuthLinks(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Icon Container
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.userPlus,
              size: 28,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Title
        const Text(
          'Create New Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2d3748),
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        const Text(
          'Fill in your details to create an account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorAlert() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfed7d7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFfeb2b2)),
      ),
      child: Row(
        children: [
          const FaIcon(
            FontAwesomeIcons.circleExclamation,
            size: 16,
            color: Color(0xFFc53030),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Color(0xFFc53030),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.user,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            const Text(
              'Full Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4a5568),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text Field
        TextFormField(
          controller: _nameController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['name'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['name'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['name'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFF667eea),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2d3748),
          ),
          onChanged: (value) => _clearValidationError('name'),
          validator: (value) => _validationErrors['name'],
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.userTag,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            const Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4a5568),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text Field
        TextFormField(
          controller: _usernameController,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'Choose a username',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['username'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['username'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['username'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFF667eea),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2d3748),
          ),
          onChanged: (value) => _clearValidationError('username'),
          validator: (value) => _validationErrors['username'],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.envelope,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            const Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4a5568),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'Enter your email address',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['email'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['email'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFFe2e8f0),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: _validationErrors['email'] != null
                    ? const Color(0xFFe53e3e)
                    : const Color(0xFF667eea),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFe53e3e),
                width: 2,
              ),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF2d3748),
          ),
          onChanged: (value) => _clearValidationError('email'),
          validator: (value) => _validationErrors['email'],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.lock,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            const Text(
              'Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4a5568),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text Field with toggle
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Create a strong password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['password'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFFe2e8f0),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['password'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFFe2e8f0),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['password'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFF667eea),
                      width: 2,
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFFe53e3e),
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFFe53e3e),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2d3748),
                ),
                onChanged: (value) => _clearValidationError('password'),
                validator: (value) => _validationErrors['password'],
              ),
            ),
            // Password Toggle Button
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _validationErrors['password'] != null
                      ? const Color(0xFFe53e3e)
                      : const Color(0xFFe2e8f0),
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                  ),
                  child: Container(
                    width: 56,
                    padding: const EdgeInsets.all(16),
                    child: FaIcon(
                      _isPasswordVisible
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 16,
                      color: _isLoading
                          ? const Color(0xFFa0aec0)
                          : const Color(0xFF6c757d),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.lock,
              size: 16,
              color: const Color(0xFF667eea),
            ),
            const SizedBox(width: 8),
            const Text(
              'Confirm Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4a5568),
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Text Field with toggle
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['confirmPassword'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFFe2e8f0),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['confirmPassword'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFFe2e8f0),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: _validationErrors['confirmPassword'] != null
                          ? const Color(0xFFe53e3e)
                          : const Color(0xFF667eea),
                      width: 2,
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFFe53e3e),
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFFe53e3e),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2d3748),
                ),
                onChanged: (value) => _clearValidationError('confirmPassword'),
                validator: (value) => _validationErrors['confirmPassword'],
              ),
            ),
            // Confirm Password Toggle Button
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _validationErrors['confirmPassword'] != null
                      ? const Color(0xFFe53e3e)
                      : const Color(0xFFe2e8f0),
                  width: 2,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                  ),
                  child: Container(
                    width: 56,
                    padding: const EdgeInsets.all(16),
                    child: FaIcon(
                      _isConfirmPasswordVisible
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 16,
                      color: _isLoading
                          ? const Color(0xFFa0aec0)
                          : const Color(0xFF6c757d),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: _isLoading
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF667eea).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: _isLoading ? null : _register,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                Text(
                  _isLoading ? 'Creating Account...' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthLinks() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Already have an account
          const Text(
            'Already have an account?',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(
                color: Color(0xFF667eea),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}