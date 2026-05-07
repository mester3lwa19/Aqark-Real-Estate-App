import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/data.dart';
import '../models/models.dart';
import 'property_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final PropertyRepository _propertyRepo;
  List<Property> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _propertyRepo = GetIt.instance<PropertyRepository>();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _propertyRepo.getFavorites();
      setState(() {
        _favorites = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading favorites: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No saved properties yet", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Saved Properties")),
      body: RefreshIndicator(
        onRefresh: _loadFavorites,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _favorites.length,
          itemBuilder: (context, index) {
            final property = _favorites[index];
            return PropertyCard(
              property: property,
              title: property.title,
              price: "${property.price} EGP",
              isVerified: true, // Simplified for now
            );
          },
        ),
      ),
    );
  }
}
