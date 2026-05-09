import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../data/data.dart';
import 'property_card.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PropertyRepository _repository = GetIt.instance<PropertyRepository>();
  final SharedPreferences _prefs = GetIt.instance<SharedPreferences>();
  final TextEditingController _searchController = TextEditingController();
  
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  List<String> _recentSearches = [];
  bool _isLoading = true;
  Timer? _debounce;
  static const String _recentSearchesKey = 'recent_searches';

  @override
  void initState() {
    super.initState();
    _loadProperties();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    setState(() {
      _recentSearches = _prefs.getStringList(_recentSearchesKey) ?? [];
    });
  }

  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    List<String> searches = _prefs.getStringList(_recentSearchesKey) ?? [];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 5) searches = searches.sublist(0, 5);
    await _prefs.setStringList(_recentSearchesKey, searches);
    _loadRecentSearches();
  }

  Future<void> _loadProperties() async {
    final properties = await _repository.getProperties();
    if (mounted) {
      setState(() {
        _allProperties = properties;
        _filteredProperties = properties;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterProperties(value);
      if (value.isNotEmpty) {
        _saveSearch(value);
      }
    });
  }

  void _filterProperties(String value) {
    final query = value.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredProperties = _allProperties;
      });
      return;
    }

    final searchNum = int.tryParse(query);

    setState(() {
      _filteredProperties = _allProperties.where((p) {
        // Text Search: Title or Description
        final bool matchesText = p.title.toLowerCase().contains(query) || 
                            p.description.toLowerCase().contains(query);
        
        // Location Search: address field
        final bool matchesLocation = p.address.toLowerCase().contains(query);

        // Numeric Searches
        bool matchesNumeric = false;
        if (searchNum != null) {
          // Beds matches exactly
          final bool matchesBeds = p.beds == searchNum;
          // Baths matches exactly
          final bool matchesBaths = p.baths == searchNum;
          // Area: sqm field >= search value
          final bool matchesArea = p.sqm >= searchNum;
          
          matchesNumeric = matchesBeds || matchesBaths || matchesArea;
        }

        return matchesText || matchesLocation || matchesNumeric;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Search Properties',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchInput(theme, colors),
                if (_searchController.text.isEmpty && _recentSearches.isNotEmpty)
                  _buildRecentSearches(colors),
                if (_searchController.text.isNotEmpty)
                  _buildResultCount(colors),
                Expanded(
                  child: _filteredProperties.isEmpty && _searchController.text.isNotEmpty
                      ? _buildEmptyState(colors)
                      : _buildResultsList(),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchInput(ThemeData theme, AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search by location, beds, sqm...',
            hintStyle: TextStyle(color: colors.textDisabled),
            prefixIcon: Icon(Icons.search, color: colors.actionPrimaryDefault),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterProperties('');
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.spacing4,
              horizontal: AppSpacing.spacing4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Wrap(
            spacing: 8,
            children: _recentSearches.map((search) => ActionChip(
              label: Text(search),
              onPressed: () {
                _searchController.text = search;
                _filterProperties(search);
                setState(() {});
              },
              backgroundColor: colors.surfaceCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.radius8),
                side: BorderSide(color: colors.borderSubtle),
              ),
            )).toList(),
          ),
          const SizedBox(height: AppSpacing.spacing4),
        ],
      ),
    );
  }

  Widget _buildResultCount(AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4, vertical: AppSpacing.spacing2),
      child: Row(
        children: [
          Text(
            'Results found: ',
            style: TextStyle(color: colors.textSecondary),
          ),
          Text(
            '${_filteredProperties.length}',
            style: TextStyle(
              color: colors.actionPrimaryDefault,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: AppSpacing.spacing2),
      itemCount: _filteredProperties.length,
      itemBuilder: (context, index) {
        final property = _filteredProperties[index];
        return PropertyCard(
          property: property,
          title: property.title,
          price: "${property.price.toStringAsFixed(0)} EGP",
          isVerified: true,
        );
      },
    );
  }

  Widget _buildEmptyState(AppSemanticColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: colors.textDisabled),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            "No properties found",
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            "Try adjusting your search filters",
            style: TextStyle(color: colors.textDisabled),
          ),
        ],
      ),
    );
  }
}

