import 'package:flutter/material.dart';
import 'package:bgisp/models/Metadata/metadata_model.dart';
import 'package:bgisp/api/Metadata/metadata_api.dart';
import 'package:bgisp/utils/language_helper.dart';

class MetadataPage extends StatefulWidget {
  const MetadataPage({super.key});

  @override
  State<MetadataPage> createState() => _MetadataPageState();
}

class _MetadataPageState extends State<MetadataPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  late Future<List<Metadata>> _metadataFuture;
  List<Metadata> _metadataList = [];
  List<Metadata> _filteredMetadataList = [];
  List<Metadata> _paginatedMetadataList = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _selectedDatasetType;

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 3;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateLanguage);
    _metadataFuture = _fetchMetadata();
  }

  @override
  void dispose() {
    _languageHelper.removeListener(_updateLanguage);
    super.dispose();
  }

  void _updateLanguage() {
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _metadataFuture = _fetchMetadata();
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

  Future<List<Metadata>> _fetchMetadata() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final metadata = await MetadataApi.getMetadata();
      setState(() {
        _metadataList = metadata;
        _filteredMetadataList = metadata;
        _updatePagination();
        _isLoading = false;
      });
      return metadata;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  void _updatePagination() {
    setState(() {
      _totalPages = (_filteredMetadataList.length / _itemsPerPage).ceil();
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
      final endIndex = startIndex + _itemsPerPage < _filteredMetadataList.length
          ? startIndex + _itemsPerPage
          : _filteredMetadataList.length;

      _paginatedMetadataList = _filteredMetadataList.sublist(
        startIndex,
        endIndex,
      );
    });
  }

  void _filterMetadata() {
    setState(() {
      _filteredMetadataList = _metadataList.where((metadata) {
        bool matchesSearch = true;
        bool matchesType = true;
        bool matchesLanguage = true;

        if (_searchQuery.isNotEmpty) {
          matchesSearch =
              (metadata.title?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (metadata.abstract?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (metadata.datasetType?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false) ||
              (metadata.datasetLanguage?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false);
        }

        if (_selectedDatasetType != null && _selectedDatasetType!.isNotEmpty) {
          matchesType =
              metadata.datasetType?.toLowerCase() ==
              _selectedDatasetType!.toLowerCase();
        }

        return matchesSearch && matchesType && matchesLanguage;
      }).toList();

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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: _languageHelper.translate('search_metadata_hint'),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _filterMetadata();
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterMetadata();
              });
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedDatasetType,
                  decoration: InputDecoration(
                    labelText: _languageHelper.translate('dataset_type'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '', 
                      child: Text(_languageHelper.translate('all_types')),
                    ),
                    ..._metadataList
                        .map((m) => m.datasetType)
                        .whereType<String>()
                        .toSet()
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        ,
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDatasetType = value;
                      _filterMetadata();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataTable(Metadata metadata) {
    final displayFields = metadata.getDisplayFields();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(2.5),
          },
          border: TableBorder.all(color: Colors.grey.shade300, width: 1.0),
          children: [
            for (var field in displayFields)
              TableRow(
                decoration: BoxDecoration(
                  color: field['value'] == null || field['value']!.isEmpty
                      ? Colors.grey.shade50
                      : Colors.white,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade100,
                    child: Text(
                      field['label']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      field['value']?.isNotEmpty == true
                          ? field['value']!
                          : _languageHelper.translate('not_available'),
                      style: TextStyle(
                        fontSize: 14,
                        color: field['value'] == null || field['value']!.isEmpty
                            ? Colors.grey.shade500
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataInfo(Metadata metadata) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start),
    );
  }

  Widget _buildMetadataItem(Metadata metadata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildMetadataInfo(metadata),
        const SizedBox(height: 8),
        _buildMetadataTable(metadata),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPaginationControls() {
    if (_totalPages <= 1) return const SizedBox.shrink();

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
                'end': ((_currentPage - 1) * _itemsPerPage) + _paginatedMetadataList.length,
                'total': _filteredMetadataList.length,
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
          _languageHelper.translate('metadata'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Language toggle button only
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
      body: FutureBuilder<List<Metadata>>(
        future: _metadataFuture,
        builder: (context, snapshot) {
          if (_isLoading && _metadataList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _languageHelper.translate('loading_metadata'),
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _languageHelper.translate('failed_to_load_metadata'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _metadataFuture = _fetchMetadata();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                    ),
                    child: Text(
                      _languageHelper.translate('try_again'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: _filteredMetadataList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _languageHelper.translate('no_metadata_found'),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_searchQuery.isNotEmpty ||
                                _selectedDatasetType != null)
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                    _selectedDatasetType = null;
                                    _filteredMetadataList = _metadataList;
                                    _currentPage = 1;
                                    _updatePagination();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D47A1),
                                ),
                                child: Text(
                                  _languageHelper.translate('clear_filters'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          ..._paginatedMetadataList
                              .map((metadata) => _buildMetadataItem(metadata)),
                          _buildPaginationControls(),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}