import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bgisp/utils/language_helper.dart';

class IntegratedGeoportalPage extends StatefulWidget {
  const IntegratedGeoportalPage({super.key});

  @override
  State<IntegratedGeoportalPage> createState() =>
      _IntegratedGeoportalPageState();
}

class _IntegratedGeoportalPageState extends State<IntegratedGeoportalPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateLanguage);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://ims.cegisbd.com:8092/map_view_mobile_app'));
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateLanguage);
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
          _languageHelper.translate('integrated_geoportal_page'),
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
      body: WebViewWidget(controller: _controller),
    );
  }
}