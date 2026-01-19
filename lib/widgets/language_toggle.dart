import 'package:flutter/material.dart';
import '../utils/language_helper.dart';

class LanguageToggle extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final EdgeInsets margin;
  
  const LanguageToggle({
    super.key,
    this.width = 60,
    this.height = 36,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
    this.margin = EdgeInsets.zero,
  });

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  final LanguageHelper _languageHelper = LanguageHelper();
  
  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateState);
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _toggleLanguage() {
    _languageHelper.toggleLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: GestureDetector(
        onTap: _toggleLanguage,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0xFF0D47A1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _languageHelper.isEnglish ? 'বাংলা' : 'English',
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: widget.textColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}