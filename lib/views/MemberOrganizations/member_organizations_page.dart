import 'package:bgisp/models/MemebrOrganizations/member_organizations_model.dart';
import 'package:flutter/material.dart';
import 'package:bgisp/api/MemberOrganizations/member_organizations_api.dart';
import 'package:bgisp/utils/language_helper.dart';

class MemberOrganizationsPage extends StatefulWidget {
  const MemberOrganizationsPage({super.key});

  @override
  State<MemberOrganizationsPage> createState() =>
      _MemberOrganizationsPageState();
}

class _MemberOrganizationsPageState extends State<MemberOrganizationsPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  List<MemberOrganization> _organizations = [];
  List<MemberOrganization> _filteredOrganizations = [];
  List<MemberOrganization> _paginatedOrganizations = [];
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
    _fetchOrganizations();
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
        _fetchOrganizations();
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

  Future<void> _fetchOrganizations() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final organizations = await OrganizationApi.getMemberOrganizations(
        language: _languageHelper.currentLanguage,
      );

      setState(() {
        _organizations = organizations;
        _filteredOrganizations = organizations;
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
      _totalPages = (_filteredOrganizations.length / _itemsPerPage).ceil();
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
      final endIndex =
          startIndex + _itemsPerPage < _filteredOrganizations.length
          ? startIndex + _itemsPerPage
          : _filteredOrganizations.length;

      _paginatedOrganizations = _filteredOrganizations.sublist(
        startIndex,
        endIndex,
      );
    });
  }

  void _filterOrganizations(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredOrganizations = _organizations;
      } else {
        _filteredOrganizations = _organizations
            .where(
              (org) => org.orgName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }

      // Reset to first page when filtering
      _currentPage = 1;
      _updatePagination();
    });
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
    if (_totalPages <= 1 || _filteredOrganizations.isEmpty) {
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
                'end': ((_currentPage - 1) * _itemsPerPage) + _paginatedOrganizations.length,
                'total': _filteredOrganizations.length,
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
      )
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

  Widget _buildImageWidget(MemberOrganization organization) {
    if (organization.fullImageUrl != null &&
        organization.fullImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          organization.fullImageUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.business, size: 40, color: Colors.grey),
            );
          },
        ),
      );
    } else {
      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.business, size: 40, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageHelper.translate('organizations'),
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
                        onChanged: _filterOrganizations,
                        decoration: InputDecoration(
                          hintText: _languageHelper.translate('search_organizations'),
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
                          _filterOrganizations('');
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
                              _languageHelper.translate('total_organizations'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_organizations.length}',
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
                            Icons.groups,
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
                : _buildOrganizationsList(),
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
            _languageHelper.translate('loading_organizations'),
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
              _languageHelper.translate('failed_to_load_organizations'),
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
              onPressed: _fetchOrganizations,
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

  Widget _buildOrganizationsList() {
    if (_filteredOrganizations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? _languageHelper.translate('no_organizations')
                  : '${_languageHelper.translate('no_search_results')} "$_searchQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _paginatedOrganizations.length,
      itemBuilder: (context, index) {
        final organization = _paginatedOrganizations[index];
        return _buildOrganizationCard(organization);
      },
    );
  }

  Widget _buildOrganizationCard(MemberOrganization organization) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showOrganizationDetails(organization);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organization Image with loading state
              _buildImageWidget(organization),

              const SizedBox(width: 16),

              // Organization Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      organization.orgName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (organization.orgShort.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${_languageHelper.translate('short_name')}: ${organization.orgShort}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                    if (organization.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          organization.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              const Icon(Icons.info, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrganizationDetails(MemberOrganization organization) {
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
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return _buildOrganizationDetailSheet(
              organization,
              scrollController,
            );
          },
        );
      },
    );
  }

  Widget _buildOrganizationDetailSheet(
    MemberOrganization organization,
    ScrollController scrollController,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

          Center(
            child:
                organization.fullImageUrl != null &&
                    organization.fullImageUrl!.isNotEmpty
                ? Container(
                    width: 150,
                    height: 150,
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
                        organization.fullImageUrl!,
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
                                Color(0xFF0D47A1),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(
                                Icons.business,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.business, size: 80, color: Colors.grey),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              organization.orgName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
              textAlign: TextAlign.center,
            ),
          ),

          if (organization.orgShort.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '${_languageHelper.translate('short_name')}: ${organization.orgShort}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

          const Divider(height: 30, thickness: 1),

          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    _languageHelper.translate('description'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    organization.description,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 20),

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
}