import 'package:flutter/material.dart';
import 'package:bgisp/models/Gallery/gallery_model.dart';
import 'package:bgisp/api/Gallery/gallery_api.dart';
import 'package:bgisp/utils/language_helper.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final LanguageHelper _languageHelper = LanguageHelper();
  List<GalleryItem> _galleryItems = [];
  List<GalleryItem> _filteredItems = [];
  List<GalleryItem> _paginatedItems = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 3;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _languageHelper.addListener(_updateLanguage);
    _fetchGalleryItems();
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
        _fetchGalleryItems();
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

  Future<void> _fetchGalleryItems() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final items = await GalleryApi.getGalleryItems(
        language: _languageHelper.currentLanguage,
      );

      setState(() {
        _galleryItems = items;
        _filteredItems = items;
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
      _totalPages = (_filteredItems.length / _itemsPerPage).ceil();
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
      final endIndex = startIndex + _itemsPerPage < _filteredItems.length
          ? startIndex + _itemsPerPage
          : _filteredItems.length;

      _paginatedItems = _filteredItems.sublist(startIndex, endIndex);
    });
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredItems = _galleryItems;
      } else {
        _filteredItems = _galleryItems
            .where(
              (item) =>
                  item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.shortDetails.toLowerCase().contains(query.toLowerCase()),
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
    if (_totalPages <= 1 || _filteredItems.isEmpty) {
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
              'gallery_pagination_info',
              params: {
                'start': ((_currentPage - 1) * _itemsPerPage) + 1,
                'end': ((_currentPage - 1) * _itemsPerPage) + _paginatedItems.length,
                'total': _filteredItems.length,
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

  String _getImageUrl(GalleryItem item) {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return '${GalleryApi.baseUrl}${item.imagePath}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _languageHelper.translate('gallery'),
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
                        onChanged: _filterItems,
                        decoration: InputDecoration(
                          hintText: _languageHelper.translate('search_gallery'),
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
                          _filterItems('');
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
                              _languageHelper.translate('gallery_items'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '${_galleryItems.length}',
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
                            Icons.photo_library,
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
                : _buildGalleryContent(),
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
            _languageHelper.translate('loading_gallery_items'),
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
              _languageHelper.translate('failed_to_load_gallery'),
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
              onPressed: _fetchGalleryItems,
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

  Widget _buildGalleryContent() {
    if (_filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? _languageHelper.translate('no_gallery_items')
                  : '${_languageHelper.translate('no_search_results')} "$_searchQuery"',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _paginatedItems.length,
      itemBuilder: (context, index) {
        final item = _paginatedItems[index];
        return _buildSingleCard(item);
      },
    );
  }

  Widget _buildSingleCard(GalleryItem item) {
    final imageUrl = _getImageUrl(item);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _showItemDetails(item);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Single large image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: Colors.grey[200],
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? const Center(
                      child: Icon(Icons.photo, size: 60, color: Colors.grey),
                    )
                  : null,
            ),

            // Content Section below image
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Short Details
                  if (item.shortDetails.isNotEmpty)
                    Text(
                      item.shortDetails,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 12),

                  // Date and View Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _showItemDetails(item);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.visibility, size: 16),
                        label: Text(
                          _languageHelper.translate('view_details'),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(GalleryItem item) {
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
            return _buildItemDetailSheet(item, scrollController);
          },
        );
      },
    );
  }

  Widget _buildItemDetailSheet(
    GalleryItem item,
    ScrollController scrollController,
  ) {
    final imageUrl = _getImageUrl(item);

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

          // Gallery Image
          Center(
            child: imageUrl.isNotEmpty
                ? Container(
                    width: double.infinity,
                    height: 200,
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
                                Icons.photo,
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
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.photo, size: 60, color: Colors.grey),
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // Title
          Center(
            child: Text(
              item.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
              textAlign: TextAlign.center,
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
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Text(
                      item.shortDetails,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
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
}