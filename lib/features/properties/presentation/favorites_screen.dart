import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/theme/app_theme.dart';
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
    final colors = AppTheme.getColors(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Saved Properties",
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: _favoritesController,
        builder: (context, _) {
          if (_favoritesController.isLoading) {
            return Center(child: CircularProgressIndicator(color: colors.actionPrimaryDefault));
          }

          final favorites = _favoritesController.favorites;

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: colors.textDisabled),
                  const SizedBox(height: 16),
                  Text(
                    "No saved properties yet",
                    style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Properties you favorite will appear here",
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
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
