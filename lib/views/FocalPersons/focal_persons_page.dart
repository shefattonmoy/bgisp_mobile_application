import 'package:flutter/material.dart';
import 'package:bgisp/models/FocalPersons/focal_persons_model.dart';
import 'package:bgisp/api/FocalPersons/focal_persons_api.dart';
import 'package:bgisp/utils/language_helper.dart';

class FocalPersonsPage extends StatefulWidget {
  const FocalPersonsPage({super.key});

  @override
  State<FocalPersonsPage> createState() => _FocalPersonsPageState();
}

class _FocalPersonsPageState extends State<FocalPersonsPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  List<FocalPerson> _focalPersons = [];
  List<FocalPerson> _filteredPersons = [];
  List<FocalPerson> _paginatedPersons = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 6;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateLanguage);
    _fetchFocalPersons();
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateLanguage);
    _searchController.dispose();
    super.dispose();
  }

  void _updateLanguage() {
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _fetchFocalPersons();
      });
    }
  }

  void _toggleLanguage() {
    if (_languageHelper.isEnglish) {
      _languageHelper.setLanguage('bn');
    } else {
      _languageHelper.setLanguage('en');
    }
  }

  Future<void> _fetchFocalPersons() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final persons = await FocalPersonApi.getFocalPersons(
        language: _languageHelper.currentLanguage,
      );

      setState(() {
        _focalPersons = persons;
        _filteredPersons = persons;
        _updatePagination();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _updatePagination() {
    setState(() {
      _totalPages = (_filteredPersons.length / _itemsPerPage).ceil();
      if (_totalPages == 0) _totalPages = 1;

      // Ensure current page is valid
      if (_currentPage > _totalPages) {
        _currentPage = _totalPages;
      }
      if (_currentPage < 1) {
        _currentPage = 1;
      }

      // Calculate start and end indices
      final startIndex = (_currentPage - 1) * _itemsPerPage;
      final endIndex = startIndex + _itemsPerPage < _filteredPersons.length
          ? startIndex + _itemsPerPage
          : _filteredPersons.length;

      _paginatedPersons = _filteredPersons.sublist(startIndex, endIndex);
    });
  }

  void _filterPersons(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPersons = _focalPersons;
      } else {
        _filteredPersons = _focalPersons
            .where(
              (person) =>
                  person.name.toLowerCase().contains(query.toLowerCase()) ||
                  person.designation.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  person.organization.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
      }

      // Reset to first page when filtering
      _currentPage = 1;
      _updatePagination();
    });
  }

  String _getImageUrl(FocalPerson person) {
    if (person.imagePath != null && person.imagePath!.isNotEmpty) {
      return '${FocalPersonApi.baseUrl}${person.imagePath}';
    }
    return '';
  }

  void _goToPage(int pageNumber) {
    setState(() {
      _currentPage = pageNumber;
      _updatePagination();
    });

    // Scroll to top when changing pages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      if (context.mounted) {
        Scrollable.ensureVisible(context);
      }
    });
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      _goToPage(_currentPage + 1);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _goToPage(_currentPage - 1);
    }
  }

  Widget _buildPaginationControls() {
    if (_totalPages <= 1 || _filteredPersons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          // Pagination info
          Text(
            _languageHelper.translate(
              'pagination_info',
              params: {
                'start': ((_currentPage - 1) * _itemsPerPage) + 1,
                'end': ((_currentPage - 1) * _itemsPerPage) + _paginatedPersons.length,
                'total': _filteredPersons.length,
              },
            ),
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),

          // Pagination buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous button
              IconButton(
                onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                icon: const Icon(Icons.arrow_back_ios),
                color: _currentPage > 1 ? const Color(0xFF0D47A1) : Colors.grey,
                tooltip: _languageHelper.translate('previous'),
              ),

              const SizedBox(width: 8),

              // Page numbers
              _buildPageNumbers(),

              const SizedBox(width: 8),

              // Next button
              IconButton(
                onPressed: _currentPage < _totalPages ? _goToNextPage : null,
                icon: const Icon(Icons.arrow_forward_ios),
                color: _currentPage < _totalPages
                    ? const Color(0xFF0D47A1)
                    : Colors.grey,
                tooltip: _languageHelper.translate('next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageNumbers() {
    final List<Widget> pageWidgets = [];

    // Always show first page
    pageWidgets.add(_buildPageButton(1));

    if (_totalPages <= 7) {
      // Show all pages if total pages <= 7
      for (int i = 2; i <= _totalPages - 1; i++) {
        pageWidgets.add(_buildPageButton(i));
      }
    } else {
      // Show ellipsis logic for many pages
      if (_currentPage <= 4) {
        // Show pages 2-5, then ellipsis, then last page
        for (int i = 2; i <= 5; i++) {
          pageWidgets.add(_buildPageButton(i));
        }
        pageWidgets.add(const Text('...', style: TextStyle(fontSize: 18)));
      } else if (_currentPage >= _totalPages - 3) {
        // Show first page, ellipsis, then last 5 pages
        pageWidgets.add(const Text('...', style: TextStyle(fontSize: 18)));
        for (int i = _totalPages - 4; i <= _totalPages - 1; i++) {
          pageWidgets.add(_buildPageButton(i));
        }
      } else {
        // Show first page, ellipsis, current-1, current, current+1, ellipsis, last page
        pageWidgets.add(const Text('...', style: TextStyle(fontSize: 18)));
        for (int i = _currentPage - 1; i <= _currentPage + 1; i++) {
          pageWidgets.add(_buildPageButton(i));
        }
        pageWidgets.add(const Text('...', style: TextStyle(fontSize: 18)));
      }
    }

    // Always show last page if more than 1 page
    if (_totalPages > 1) {
      pageWidgets.add(_buildPageButton(_totalPages));
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      alignment: WrapAlignment.center,
      children: pageWidgets,
    );
  }

  Widget _buildPageButton(int pageNumber) {
    final isCurrentPage = pageNumber == _currentPage;

    return GestureDetector(
      onTap: () => _goToPage(pageNumber),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isCurrentPage ? const Color(0xFF0D47A1) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isCurrentPage
                ? const Color(0xFF0D47A1)
                : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            '$pageNumber',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isCurrentPage ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageHelper.translate('focal_persons'),
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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterPersons,
                        decoration: InputDecoration(
                          hintText: _languageHelper.translate('search_hint'),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          _filterPersons('');
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Stats and Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              color: const Color(0xFF0D47A1),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _languageHelper.translate('focal_persons'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_focalPersons.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.contacts,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),

          // Loading, Error, or Content
          Expanded(
            child: _isLoading
                ? _buildLoadingIndicator()
                : _hasError
                ? _buildErrorWidget()
                : _buildFocalPersonsList(),
          ),

          // Pagination Controls
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
          ),
          const SizedBox(height: 16),
          Text(
            _languageHelper.translate('loading_focal_persons'),
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _languageHelper.translate('failed_to_load_focal_persons'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchFocalPersons,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: Text(
                _languageHelper.translate('try_again'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocalPersonsList() {
    if (_filteredPersons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? _languageHelper.translate('no_focal_persons')
                  : '${_languageHelper.translate('no_search_results')} "$_searchQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _paginatedPersons.length,
      itemBuilder: (context, index) {
        final person = _paginatedPersons[index];
        return _buildFocalPersonCard(person);
      },
    );
  }

  Widget _buildFocalPersonCard(FocalPerson person) {
    final imageUrl = _getImageUrl(person);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showPersonDetails(person);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Person Image
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                  image: imageUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),

              const SizedBox(width: 16),

              // Person Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Person Name
                    Text(
                      person.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Designation
                    if (person.designation.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          person.designation,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Organization
                    if (person.organization.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                person.organization,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // View Details Icon
              const Icon(Icons.info, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showPersonDetails(FocalPerson person) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.6,
          builder: (context, scrollController) {
            return _buildPersonDetailSheet(person, scrollController);
          },
        );
      },
    );
  }

  Widget _buildPersonDetailSheet(
    FocalPerson person,
    ScrollController scrollController,
  ) {
    final imageUrl = _getImageUrl(person);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with drag handle
          Center(
            child: Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Person Image
          Center(
            child: imageUrl.isNotEmpty
                ? Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF4CAF50),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Person Name
          Center(
            child: Text(
              person.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Designation
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                person.designation,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const Divider(height: 30, thickness: 1),

          // Details Section
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organization
                  Text(
                    _languageHelper.translate('organization'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.business,
                          color: Color(0xFF0D47A1),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            person.organization,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Contact Information (when available in API)
                  if (person.phone != null || person.email != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _languageHelper.translate('contact_information'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[100]!),
                          ),
                          child: Column(
                            children: [
                              // Phone (if available)
                              if (person.phone != null &&
                                  person.phone!.isNotEmpty)
                                _buildContactInfoItem(
                                  icon: Icons.phone,
                                  label: _languageHelper.translate('phone'),
                                  value: person.phone!,
                                ),
                              // Email (if available)
                              if (person.email != null &&
                                  person.email!.isNotEmpty)
                                _buildContactInfoItem(
                                  icon: Icons.email,
                                  label: _languageHelper.translate('email'),
                                  value: person.email!,
                                ),
                              // Show message if no contact info
                              if ((person.phone == null ||
                                      person.phone!.isEmpty) &&
                                  (person.email == null ||
                                      person.email!.isEmpty))
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 20,
                                        color: Colors.orange[700],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _languageHelper.translate('contact_info_not_available'),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[700],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _languageHelper.translate('close'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}