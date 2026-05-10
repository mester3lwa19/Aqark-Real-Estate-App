import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../models/models.dart';
import '../../../core/widgets/property_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = [
    'All',
    'Apartment',
    'Duplex',
    'Villa',
    'Townhouse',
    'Studio',
    'Penthouse',
  ];
  String _activeCategory = 'All';

  List<PropertyDisplay> get _filteredProperties {
    if (_activeCategory == 'All') return _properties;
    return _properties.where((p) => p.type == _activeCategory).toList();
  }

  int _getCategoryCount(String category) {
    if (category == 'All') return _properties.length;
    return _properties.where((p) => p.type == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = AppTheme.getColors(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing4,
                  vertical: AppSpacing.spacing5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, colors),
                    const SizedBox(height: AppSpacing.spacing6),
                    _buildCategories(context, isDark, colors),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing4,
                  vertical: AppSpacing.spacing3,
                ),
                child: Text(
                  'Discover Properties',
                  style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                ),
              ),
            ),
            _buildPropertyList(colors),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.spacing4,
                  AppSpacing.spacing6,
                  AppSpacing.spacing4,
                  AppSpacing.spacing3,
                ),
                child: Text(
                  'Meet Our Expert Brokers',
                  style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
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
                  mainAxisSpacing: AppSpacing.spacing3,
                  crossAxisSpacing: AppSpacing.spacing3,
                  childAspectRatio: 0.75,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.spacing6)),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyList(AppSemanticColors colors) {
    final filtered = _filteredProperties;

    if (filtered.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacing10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: colors.textDisabled),
              const SizedBox(height: AppSpacing.spacing4),
              Text(
                'No properties found in this category',
                style: TextStyle(color: colors.textSecondary, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final property = filtered[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacing4,
              vertical: AppSpacing.spacing2,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: PropertyCardPreview(
                key: ValueKey(property.id),
                property: property,
              ),
            ),
          );
        },
        childCount: filtered.length,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppSemanticColors colors) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: colors.actionPrimaryDefault,
            borderRadius: BorderRadius.circular(AppRadius.radius16),
          ),
          alignment: Alignment.center,
          child: const Text(
            'A',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.spacing3),
        Expanded(
          child: Text(
            'Aqark',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
          ),
        ),
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.radius16),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Icon(Icons.notifications_none, color: colors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context, bool isDark, AppSemanticColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.spacing3),
          child: Text(
            'Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
          ),
        ),
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.spacing2),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isActive = category == _activeCategory;
              final count = _getCategoryCount(category);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeCategory = category;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.spacing4,
                    vertical: AppSpacing.spacing3,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? colors.actionPrimaryDefault : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.radius16),
                    border: Border.all(
                      color: isActive ? Colors.transparent : colors.borderSubtle,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$category ($count)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : colors.textSecondary,
                      ),
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
      imageUrl: 'assets/images/properties/villa/villa_1.jpg',
      address: 'Glim, Alexandria',
      type: 'Villa',
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
      imageUrl: 'assets/images/properties/studio/studio_1.jpg',
      address: 'Cleopatra, Alexandria',
      type: 'Studio',
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
      imageUrl: 'assets/images/properties/apartment/apartment_1.jpg',
      address: 'Maadi, Cairo',
      type: 'Apartment',
    ),
    PropertyDisplay(
      id: 'prop_4',
      title: 'Luxury Duplex in Zayed',
      location: 'Sheikh Zayed, Cairo',
      price: 7500000,
      beds: 5,
      baths: 4,
      size: 400,
      description: 'Extravagant duplex with private garden and high-end finishes.',
      imageUrl: 'assets/images/properties/duplex/duplex_1.jpg',
      address: 'Sheikh Zayed, Cairo',
      type: 'Duplex',
    ),
    // APARTMENT
    PropertyDisplay(
      id: 'apt_1',
      title: 'Luxury Downtown Apartment',
      location: 'City Center',
      price: 350000,
      beds: 2,
      baths: 2,
      size: 120,
      description: 'High-end apartment in the heart of downtown with premium finishes.',
      imageUrl: 'assets/images/properties/apartment/apartment_1.jpg',
      address: 'Downtown Street, City Center',
      type: 'Apartment',
    ),
    PropertyDisplay(
      id: 'apt_2',
      title: 'Cozy Studio Apartment',
      location: 'City Center',
      price: 180000,
      beds: 1,
      baths: 1,
      size: 65,
      description: 'Compact and efficient living space, perfect for students or singles.',
      imageUrl: 'assets/images/properties/apartment/apartment_2.jpg',
      address: 'University Ave, City Center',
      type: 'Apartment',
    ),
    // DUPLEX
    PropertyDisplay(
      id: 'duplex_1',
      title: 'Modern Duplex Loft',
      location: 'Arts District',
      price: 550000,
      beds: 3,
      baths: 2,
      size: 180,
      description: 'Industrial style duplex with double-height ceilings and large windows.',
      imageUrl: 'assets/images/properties/duplex/duplex_1.jpg',
      address: 'Arts District, East Side',
      type: 'Duplex',
    ),
    PropertyDisplay(
      id: 'duplex_2',
      title: 'Family Duplex Home',
      location: 'Suburb Area',
      price: 620000,
      beds: 4,
      baths: 3,
      size: 220,
      description: 'Spacious two-story home with a private garden and modern amenities.',
      imageUrl: 'assets/images/properties/duplex/duplex_2.jpg',
      address: 'Green Valley, Suburb Area',
      type: 'Duplex',
    ),
    // VILLA
    PropertyDisplay(
      id: 'villa_1',
      title: 'Beachfront Luxury Villa',
      location: 'Coastline',
      price: 1200000,
      beds: 5,
      baths: 4,
      size: 350,
      description: 'Stunning villa with direct beach access and panoramic ocean views.',
      imageUrl: 'assets/images/properties/villa/villa_1.jpg',
      address: 'Ocean Drive, Coastline',
      type: 'Villa',
    ),
    PropertyDisplay(
      id: 'villa_2',
      title: 'Mountain View Villa',
      location: 'Hillside',
      price: 890000,
      beds: 4,
      baths: 4,
      size: 280,
      description: 'Quiet retreat surrounded by nature with spectacular mountain views.',
      imageUrl: 'assets/images/properties/villa/villa_2.jpg',
      address: 'Pine Ridge, Hillside',
      type: 'Villa',
    ),
    // TOWNHOUSE
    PropertyDisplay(
      id: 'town_1',
      title: 'Modern Townhouse',
      location: 'City Center',
      price: 420000,
      beds: 3,
      baths: 2,
      size: 150,
      description: 'Contemporary townhouse with a rooftop terrace in a prime location.',
      imageUrl: 'assets/images/properties/townhouse/townhouse_1.jpg',
      address: 'Maple Street, City Center',
      type: 'Townhouse',
    ),
    PropertyDisplay(
      id: 'town_2',
      title: 'Corner Unit Townhouse',
      location: 'Residential Zone',
      price: 510000,
      beds: 4,
      baths: 3,
      size: 195,
      description: 'Extra-wide townhouse unit with lots of natural light and side yard.',
      imageUrl: 'assets/images/properties/townhouse/townhouse_2.jpg',
      address: 'Oak Lane, Residential Zone',
      type: 'Townhouse',
    ),
    // STUDIO
    PropertyDisplay(
      id: 'studio_1',
      title: 'Minimalist Studio',
      location: 'Downtown',
      price: 120000,
      beds: 0,
      baths: 1,
      size: 45,
      description: 'Clean and modern studio apartment, optimized for urban living.',
      imageUrl: 'assets/images/properties/studio/studio_1.jpg',
      address: 'Central Park West, Downtown',
      type: 'Studio',
    ),
    PropertyDisplay(
      id: 'studio_2',
      title: 'Art District Studio',
      location: 'Creative Zone',
      price: 135000,
      beds: 0,
      baths: 1,
      size: 50,
      description: 'Vibrant studio located in the heart of the arts and culture district.',
      imageUrl: 'assets/images/properties/studio/studio_2.jpg',
      address: 'Gallery Row, Creative Zone',
      type: 'Studio',
    ),
    // PENTHOUSE
    PropertyDisplay(
      id: 'pent_1',
      title: 'Skyline Penthouse',
      location: 'City Center',
      price: 950000,
      beds: 3,
      baths: 3,
      size: 250,
      description: 'Top-floor penthouse with a private terrace and city-wide views.',
      imageUrl: 'assets/images/properties/penthouse/penthouse_1.jpg',
      address: 'Sky Tower, City Center',
      type: 'Penthouse',
    ),
    PropertyDisplay(
      id: 'pent_2',
      title: 'Luxury Penthouse Suite',
      location: 'Waterfront',
      price: 1400000,
      beds: 4,
      baths: 3,
      size: 310,
      description: 'The ultimate in luxury, featuring ultra-premium amenities and water views.',
      imageUrl: 'assets/images/properties/penthouse/penthouse_2.jpg',
      address: 'Marina Bay, Waterfront',
      type: 'Penthouse',
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
  ];
}

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
  final String type;

  PropertyDisplay({
    required this.id, required this.title, required this.location,
    required this.price, required this.beds, required this.baths,
    required this.size, required this.description, required this.imageUrl,
    required this.address, required this.type,
  });

  Property toProperty() {
    return Property(
      id: id, title: title, description: description,
      price: price, address: address, imageUrl: imageUrl,
      ownerId: 'owner_$id', timestamp: DateTime.now().millisecondsSinceEpoch,
      beds: beds, baths: baths, sqm: size, type: type,
    );
  }
}

class BrokerDisplay {
  final String name;
  final double rating;
  final int reviewCount;
  final String imageUrl;

  BrokerDisplay({required this.name, required this.rating, required this.reviewCount, required this.imageUrl});
}

class PropertyCardPreview extends StatelessWidget {
  final PropertyDisplay property;
  const PropertyCardPreview({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = AppTheme.getColors(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.propertyDetails, arguments: property.toProperty()),
      borderRadius: BorderRadius.circular(AppRadius.radius24),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.radius24),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.radius24)),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: PropertyImage(imageUrl: property.imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(AppRadius.radius8),
                    ),
                    child: Text(
                      property.type,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.spacing4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.location,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: colors.textPrimary),
                  ),
                  const SizedBox(height: AppSpacing.spacing2),
                  Text(
                    '${property.price.toStringAsFixed(0)} EGP',
                    style: TextStyle(color: colors.actionPrimaryDefault, fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: AppSpacing.spacing3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailChip(context, Icons.king_bed, '${property.beds} Bed', colors),
                      _buildDetailChip(context, Icons.bathtub, '${property.baths} Bath', colors),
                      _buildDetailChip(context, Icons.square_foot, '${property.size} m²', colors),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.actionPrimaryDefault,
                      borderRadius: BorderRadius.circular(AppRadius.radius16),
                    ),
                    child: const Center(
                      child: Text('View details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, IconData icon, String label, AppSemanticColors colors) {
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textSecondary),
        const SizedBox(width: AppSpacing.spacing1),
        Text(label, style: TextStyle(fontSize: 13, color: colors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class BrokerCardPreview extends StatelessWidget {
  final BrokerDisplay broker;
  const BrokerCardPreview({super.key, required this.broker});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppTheme.getColors(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.radius24),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.radius24)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.network(broker.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(broker.name, style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppSpacing.spacing1),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFFFD511)),
                    const SizedBox(width: AppSpacing.spacing1),
                    Text('${broker.rating}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: colors.textPrimary)),
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
