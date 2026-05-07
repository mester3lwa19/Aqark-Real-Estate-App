import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'Apartment',
    'Villa',
    'Studio',
    'Duplex',
    'Penthouse',
    'Commercial',
  ];
  final String _activeCategory = 'Apartment';

  @override
  void initState() {
    super.initState();
  }

  final List<PropertyDisplay> _properties = [
    PropertyDisplay(
      id: 'prop_1',
      title: 'Ultra-modern villa with pool',
      location: 'Glim, Alexandria',
      price: 5200000,
      beds: 4,
      baths: 4,
      size: 350,
      description: 'A stunning villa with a private pool, open terraces, and sea breeze living.',
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=900&q=80',
      address: 'Glim, Alexandria',
    ),
    PropertyDisplay(
      id: 'prop_2',
      title: 'Cosy studio near beach',
      location: 'Cleopatra, Alexandria',
      price: 1600000,
      beds: 1,
      baths: 1,
      size: 80,
      description: 'Bright studio with beach access and modern finishes for easy coastal living.',
      imageUrl: 'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=900&q=80',
      address: 'Cleopatra, Alexandria',
    ),
    PropertyDisplay(
      id: 'prop_3',
      title: 'Maadi family apartment',
      location: 'Maadi, Cairo',
      price: 3300000,
      beds: 3,
      baths: 2,
      size: 240,
      description: 'Spacious family residence with leafy views and elegant living spaces.',
      imageUrl: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=900&q=80',
      address: 'Maadi, Cairo',
    ),
    PropertyDisplay(
      id: 'prop_4',
      title: 'Stanley city duplex',
      location: 'Stanley, Alexandria',
      price: 4100000,
      beds: 3,
      baths: 2,
      size: 220,
      description: 'A beautiful duplex with city views, modern amenities, and refined interiors.',
      imageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=900&q=80',
      address: 'Stanley, Alexandria',
    ),
    PropertyDisplay(
      id: 'prop_5',
      title: 'Heliopolis luxury apartment',
      location: 'Heliopolis, Cairo',
      price: 4500000,
      beds: 4,
      baths: 3,
      size: 300,
      description: 'Luxury urban apartment with premium finishes and a bright, open plan.',
      imageUrl: 'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=900&q=80',
      address: 'Heliopolis, Cairo',
    ),
    PropertyDisplay(
      id: 'prop_6',
      title: 'Downtown Cairo studio',
      location: 'Garden City, Cairo',
      price: 2100000,
      beds: 1,
      baths: 1,
      size: 95,
      description: 'Compact downtown studio with excellent access to city amenities.',
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      address: 'Garden City, Cairo',
    ),
    PropertyDisplay(
      id: 'prop_7',
      title: 'Historic Down Town apartment',
      location: 'Alexandria Down Town',
      price: 2700000,
      beds: 2,
      baths: 1,
      size: 170,
      description: 'Charming apartment blending classic elegance with modern comforts.',
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      address: 'Alexandria Down Town',
    ),
    PropertyDisplay(
      id: 'prop_8',
      title: 'Modern New Cairo studio',
      location: 'New Cairo, Cairo',
      price: 2200000,
      beds: 1,
      baths: 1,
      size: 90,
      description: 'Contemporary studio designed for effortless living in New Cairo.',
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=900&q=80',
      address: 'New Cairo, Cairo',
    ),
    PropertyDisplay(
      id: 'prop_9',
      title: 'Penthouse with roof terrace',
      location: 'Maadi, Cairo',
      price: 6800000,
      beds: 4,
      baths: 3,
      size: 360,
      description: 'Ultimate penthouse with panoramic terrace, elegant interiors, and skyline views.',
      imageUrl: 'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=900&q=80',
      address: 'Maadi, Cairo',
    ),
    PropertyDisplay(
      id: 'prop_10',
      title: 'Al-Sheikh Zayed Townhouse',
      location: 'Al-Sheikh Zayed, Cairo',
      price: 5000000,
      beds: 3,
      baths: 3,
      size: 280,
      description: 'Stylish townhouse with modern architecture and generous living spaces.',
      imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=900&q=80',
      address: 'Al-Sheikh Zayed, Cairo',
    ),
  ];

  final List<BrokerDisplay> _brokers = [
    BrokerDisplay(
      name: 'Ahmed Mansour',
      rating: 4.9,
      reviewCount: 82,
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Sarah El-Masry',
      rating: 4.8,
      reviewCount: 104,
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Mahmoud Farouk',
      rating: 4.7,
      reviewCount: 78,
      imageUrl: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Yasmine Abdel-Aziz',
      rating: 4.9,
      reviewCount: 135,
      imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Amr El-Din',
      rating: 4.8,
      reviewCount: 96,
      imageUrl: 'https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Nada Gamal',
      rating: 4.7,
      reviewCount: 83,
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Kareem Hassan',
      rating: 4.8,
      reviewCount: 121,
      imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Laila Soliman',
      rating: 4.9,
      reviewCount: 110,
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Hany Fahmy',
      rating: 4.8,
      reviewCount: 90,
      imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=800&q=80',
    ),
    BrokerDisplay(
      name: 'Dalia Ibrahim',
      rating: 4.7,
      reviewCount: 89,
      imageUrl: 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppSemanticColors.light.surfaceBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top bar, search, and categories
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 24),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    _buildCategories(context),
                  ],
                ),
              ),
            ),
            // Discover Properties header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'Discover Properties',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            // Properties list using SliverList for efficient scrolling
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final property = _properties[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: PropertyCardPreview(property: property),
                  );
                },
                childCount: _properties.length,
              ),
            ),
            // Brokers header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Meet Our Expert Brokers',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            // Brokers grid using SliverGrid for efficient layout
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final broker = _brokers[index];
                    return BrokerCardPreview(broker: broker);
                  },
                  childCount: _brokers.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
              ),
            ),
            // Bottom padding
            SliverToBoxAdapter(
              child: const SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppSemanticColors.light.actionSecondaryDefault,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            'A',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Aqark',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_none, color: AppPrimitiveColors.primary700),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Placeholder',
          prefixIcon: const Icon(Icons.search, color: AppPrimitiveColors.primary700),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isActive = category == _activeCategory;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppPrimitiveColors.primary400 : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? Colors.transparent : AppPrimitiveColors.gray200,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppPrimitiveColors.primary400.withValues(alpha: 0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    category,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive ? Colors.white : AppPrimitiveColors.gray800,
                        ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Mock data model for property display
class PropertyDisplay {
  final String id;
  final String title;
  final String location;
  final double price;
  final int beds;
  final int baths;
  final int size;
  final String description;
  final String imageUrl;
  final String address;

  PropertyDisplay({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.size,
    required this.description,
    required this.imageUrl,
    required this.address,
  });

  // Convert PropertyDisplay to Property for navigation
  Property toProperty() {
    return Property(
      id: id,
      title: title,
      description: description,
      price: price,
      address: address,
      imageUrl: imageUrl,
      ownerId: 'owner_$id',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

// Broker display model
class BrokerDisplay {
  final String name;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  BrokerDisplay({
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
  });
}

// Interactive Property Card with navigation and favorite button
class PropertyCardPreview extends StatelessWidget {
  final PropertyDisplay property;

  const PropertyCardPreview({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to property details screen passing the Property object
        Navigator.pushNamed(
          context,
          AppRoutes.propertyDetails,
          arguments: property.toProperty(),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  property.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppPrimitiveColors.gray100,
                    child: const Center(child: Icon(Icons.home, size: 48, color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.location,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${property.price.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppPrimitiveColors.primary700,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailChip(Icons.king_bed, '${property.beds} Bed'),
                      _buildDetailChip(Icons.bathtub, '${property.baths} Bath'),
                      _buildDetailChip(Icons.square_foot, '${property.size} m²'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    property.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppPrimitiveColors.gray700,
                          height: 1.5,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFEA5A2D), Color(0xFFD53E0F)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.propertyDetails,
                                arguments: property.toProperty(),
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('View details'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _FavoriteButton(propertyId: property.id),
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

  Widget _buildDetailChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppPrimitiveColors.gray700),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4A4F59),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Stateful widget for interactive favorite button
class _FavoriteButton extends StatefulWidget {
  final String propertyId;

  const _FavoriteButton({required this.propertyId});

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // In a real app, you would call the FavoritesRepository here
    // FavoritesRepository().toggleFavorite(propertyId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        color: AppPrimitiveColors.gray50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleFavorite,
          borderRadius: BorderRadius.circular(16),
          child: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? const Color(0xFFB5350D) : AppPrimitiveColors.primary700,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// Broker card preview
class BrokerCardPreview extends StatelessWidget {
  final BrokerDisplay broker;

  const BrokerCardPreview({super.key, required this.broker});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 118,
              width: double.infinity,
              child: Image.network(
                broker.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppPrimitiveColors.gray100,
                  child: const Center(child: Icon(Icons.person, size: 40, color: Colors.grey)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  broker.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFFD511)),
                    const SizedBox(width: 4),
                    Text(
                      '${broker.rating}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '(${broker.reviewCount} reviews)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppPrimitiveColors.gray500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 10, color: Color(0xFF48A111)),
                    const SizedBox(width: 8),
                    Text(
                      'Active Today',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppPrimitiveColors.gray700,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
