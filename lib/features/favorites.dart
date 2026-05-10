import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'properties/models/models.dart';
import 'properties/data/data.dart';
import 'auth/data/data.dart';

class FavoritesController extends ChangeNotifier {
  final PropertyRepository _repository;
  final AuthRepository _authRepository;
  
  List<Property> _favorites = [];
  bool _isLoading = false;

  FavoritesController(this._repository, this._authRepository) {
    _init();
  }

  void _init() {
    loadFavorites();
    
    // Listen for auth state changes (Login/Logout)
    FirebaseAuth.instance.authStateChanges().listen((user) {
      loadFavorites();
    });

    // Listen for connectivity changes to trigger background sync
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        // When back online, refresh favorites from cloud
        _repository.syncFavorites().then((_) => loadFavorites());
      }
    });
  }

  List<Property> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    // If we're already loading, don't trigger again to avoid loops
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      // 1. Load from local cache (Instant UI)
      _favorites = await _repository.getFavorites();
      notifyListeners();

      // 2. If online, trigger a background sync to keep data fresh
      // This won't block the UI as it's not awaited for the first render
      _repository.syncFavorites().then((_) async {
        final syncedFavs = await _repository.getFavorites();
        _favorites = syncedFavs;
        notifyListeners();
      });
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String propertyId) {
    return _favorites.any((p) => p.id == propertyId);
  }

  Future<void> toggleFavorite(Property property) async {
    final wasFavorite = isFavorite(property.id);
    
    // Optimistic UI update: Toggle locally in the controller list immediately
    if (wasFavorite) {
      _favorites.removeWhere((p) => p.id == property.id);
    } else {
      _favorites.add(property);
    }
    notifyListeners();

    try {
      await _repository.toggleFavorite(property);
      // No need to reload favorites here as local DB is updated and UI reflects it
    } catch (e) {
      // Revert local UI state on error
      if (wasFavorite) {
        _favorites.add(property);
      } else {
        _favorites.removeWhere((p) => p.id == property.id);
      }
      notifyListeners();
      debugPrint("Error toggling favorite: $e");
    }
  }
}
