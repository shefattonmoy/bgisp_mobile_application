import 'package:flutter/material.dart';
import 'package:bgisp/utils/language_helper.dart';

class LanguageText extends StatefulWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  
  const LanguageText({
    super.key,
    required this.translationKey,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow, required String text,
  });

  @override
  State<LanguageText> createState() => _LanguageTextState();
}

class _LanguageTextState extends State<LanguageText> {
  final LanguageHelper _languageHelper = LanguageHelper();
  
  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _languageHelper.translate(widget.translationKey),
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}