import 'package:flutter/material.dart';
import 'package:bgisp/widgets/language_text.dart';
import 'package:bgisp/widgets/language_toggle.dart';

class AppBarWithLanguage extends StatelessWidget implements PreferredSizeWidget {
  final String translationKey;
  final VoidCallback? onBackPressed;
  final List<Widget>? additionalActions;
  final bool showLanguageToggle;

  const AppBarWithLanguage({
    super.key,
    required this.translationKey,
    this.onBackPressed,
    this.additionalActions,
    this.showLanguageToggle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: LanguageText(
        translationKey: translationKey,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ), text: '',
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF0D47A1),
      elevation: 4,
      iconTheme: const IconThemeData(color: Colors.white),
      leading: onBackPressed != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
              tooltip: 'Back',
            )
          : null,
      actions: [
        if (showLanguageToggle) ...[
          LanguageToggle(
            width: 65,
            height: 35,
            fontSize: 14,
            margin: const EdgeInsets.only(right: 8),
          ),
          ...?additionalActions,
        ] else ...[
          ...?additionalActions,
        ],
      ],
    );
  }
}