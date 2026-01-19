import 'package:flutter/material.dart';

class DataDisseminationPage extends StatefulWidget {
  const DataDisseminationPage({super.key});

  @override
  State<DataDisseminationPage> createState() => _DataDisseminationPageState();
}

class _DataDisseminationPageState extends State<DataDisseminationPage> {
  String _language = 'en';

  void _toggleLanguage() {
    setState(() {
      _language = _language == 'en' ? 'bn' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _language == 'en' ? 'Data Dissemination' : 'ডেটা বিতরণ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(_language == 'en' ? Icons.language : Icons.translate),
            onPressed: _toggleLanguage,
            tooltip: _language == 'en' ? 'বাংলা' : 'English',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Card(
              color: const Color(0xFF0D47A1),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _language == 'en' ? 'Data Dissemination' : 'ডেটা বিতরণ',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _language == 'en'
                          ? 'Efficient sharing and distribution of geospatial data'
                          : 'ভৌগোলিক স্থানিক ডেটার দক্ষ শেয়ারিং এবং বিতরণ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Formats Section
            Text(
              _language == 'en' ? 'Supported Formats' : 'সমর্থিত ফরম্যাট',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFormatChip('GeoJSON'),
                _buildFormatChip('Shapefile'),
                _buildFormatChip('KML'),
                _buildFormatChip('CSV'),
                _buildFormatChip('Excel'),
                _buildFormatChip('PDF'),
                _buildFormatChip('GeoTIFF'),
                _buildFormatChip('GeoPackage'),
              ],
            ),

            const SizedBox(height: 24),

            // Coming Soon Section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.share,
                      size: 80,
                      color: Color(0xFF0D47A1),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _language == 'en' ? 'Data Dissemination Platform Coming Soon' : 'ডেটা বিতরণ প্ল্যাটফর্ম শীঘ্রই আসছে',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _language == 'en'
                          ? 'Advanced platform for secure and efficient sharing of geospatial data with various stakeholders.'
                          : 'বিভিন্ন অংশীদারদের সাথে ভৌগোলিক স্থানিক ডেটার নিরাপদ এবং দক্ষ শেয়ারিংয়ের জন্য উন্নত প্ল্যাটফর্ম।',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _language == 'en'
                                  ? 'Data dissemination platform will be available soon'
                                  : 'ডেটা বিতরণ প্ল্যাটফর্ম শীঘ্রই উপলব্ধ হবে',
                            ),
                            backgroundColor: const Color(0xFF0D47A1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.cloud_download, color: Colors.white),
                      label: Text(
                        _language == 'en' ? 'Access Data' : 'ডেটা অ্যাক্সেস করুন',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChip(String format) {
    return Chip(
      label: Text(format),
      backgroundColor: const Color(0xFF0D47A1),
      labelStyle: const TextStyle(color: Colors.white),
      avatar: const Icon(
        Icons.check,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}