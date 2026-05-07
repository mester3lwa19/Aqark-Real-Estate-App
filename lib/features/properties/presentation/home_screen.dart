import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/theme/app_dimensions.dart';
import '../data/data.dart';
import '../models/models.dart';
import 'property_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PropertyRepository _propertyRepo;
  List<Property> _properties = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _propertyRepo = GetIt.instance<PropertyRepository>();
    _loadProperties();
  }

  Future<void> _loadProperties({String? query}) async {
    setState(() => _isLoading = true);
    try {
      final properties = await _propertyRepo.getProperties(query: query);
      setState(() {
        _properties = properties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqark Properties'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (value) => _loadProperties(query: value),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProperties,
              child: _properties.isEmpty
                  ? const Center(child: Text("No properties found"))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing4),
                      itemCount: _properties.length,
                      itemBuilder: (context, index) {
                        final property = _properties[index];
                        return PropertyCard(
                          property: property,
                          title: property.title,
                          price: "${property.price} EGP",
                          isVerified: index % 2 == 0, // Mock verification
                        );
                      },
                    ),
            ),
    );
  }
}
