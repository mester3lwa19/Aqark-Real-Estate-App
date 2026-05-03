import 'package:flutter/material.dart';
import '../../../core/theme/app_dimensions.dart';
// Note: If your PropertyCard is in the same folder, use: import 'property_card.dart';
// If it is in a widgets folder, use: import 'widgets/property_card.dart';
import 'property_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aqark Properties')),
      // ListView lets us scroll through the properties
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing4),
        children: const [
          PropertyCard(
            title: 'Modern Villa in New Cairo',
            price: '12,500,000 EGP',
            isVerified: true,
          ),
          PropertyCard(
            title: 'Luxury Apartment in Zayed',
            price: '4,200,000 EGP',
            isVerified: false,
          ),
          PropertyCard(
            title: 'Cozy Studio in Maadi',
            price: '1,800,000 EGP',
            isVerified: true,
          ),
        ],
      ),
    );
  }
}
