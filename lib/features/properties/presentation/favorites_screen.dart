import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../favorites.dart';
import 'property_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesController _favoritesController;

  @override
  void initState() {
    super.initState();
    _favoritesController = GetIt.instance<FavoritesController>();
    // Ensure favorites are loaded
    _favoritesController.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Properties"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListenableBuilder(
        listenable: _favoritesController,
        builder: (context, _) {
          if (_favoritesController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = _favoritesController.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No saved properties yet",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Properties you favorite will appear here",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _favoritesController.loadFavorites(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final property = favorites[index];
                return PropertyCard(
                  property: property,
                  title: property.title,
                  price: "${property.price.toStringAsFixed(0)} EGP",
                  isVerified: true, // Assuming true or you can add logic from property model
                );
              },
            ),
          );
        },
      ),
    );
  }
}
