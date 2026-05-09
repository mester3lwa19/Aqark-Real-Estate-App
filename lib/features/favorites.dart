import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'properties/models/models.dart';
import 'properties/data/data.dart';

class FavoritesController extends ChangeNotifier {
  final PropertyRepository _repository;
  final FirebaseAuth _auth;
  List<Property> _favorites = [];
  bool _isLoading = false;

  FavoritesController(this._repository, this._auth) {
    // Initial load
    loadFavorites();
    
    // Listen to auth changes: reload favorites when user signs in/out
    _auth.authStateChanges().listen((user) {
      loadFavorites();
    });
  }

  List<Property> get favorites => _favorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _favorites = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      _favorites = await _repository.getFavorites();
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
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final wasFavorite = isFavorite(property.id);
    
    // Optimistic UI update
    if (wasFavorite) {
      _favorites.removeWhere((p) => p.id == property.id);
    } else {
      _favorites.add(property);
    }
    notifyListeners();

    try {
      await _repository.toggleFavorite(property);
    } catch (e) {
      // Revert on error
      if (wasFavorite) {
        _favorites.add(property);
      } else {
        _favorites.removeWhere((p) => p.id == property.id);
      }
      notifyListeners();
      rethrow;
    }
  }
}
