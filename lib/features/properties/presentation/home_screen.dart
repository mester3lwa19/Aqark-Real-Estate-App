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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, colors),
                    const SizedBox(height: 24),
                    _buildSearchBar(context, isDark, colors),
                    const SizedBox(height: 24),
                    _buildCategories(context, isDark, colors),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'Discover Properties',
                  style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                ),
              ),
            ),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
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
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
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
            borderRadius: BorderRadius.circular(16),
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
        const SizedBox(width: 12),
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
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Icon(Icons.notifications_none, color: colors.textPrimary),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark, AppSemanticColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: TextField(
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search properties...',
          hintStyle: TextStyle(color: colors.textDisabled),
          prefixIcon: Icon(Icons.search, color: colors.actionPrimaryDefault),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context, bool isDark, AppSemanticColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
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
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isActive = category == _activeCategory;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? colors.actionPrimaryDefault : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isActive ? Colors.transparent : colors.borderSubtle,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : colors.textSecondary,
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

  PropertyDisplay({
    required this.id, required this.title, required this.location,
    required this.price, required this.beds, required this.baths,
    required this.size, required this.description, required this.imageUrl,
    required this.address,
  });

  Property toProperty() {
    return Property(
      id: id, title: title, description: description,
      price: price, address: address, imageUrl: imageUrl,
      ownerId: 'owner_$id', timestamp: DateTime.now().millisecondsSinceEpoch,
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
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.propertyDetails, arguments: property.toProperty()),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(property.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.location,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: colors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${property.price.toStringAsFixed(0)} EGP',
                    style: TextStyle(color: colors.actionPrimaryDefault, fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailChip(context, Icons.king_bed, '${property.beds} Bed', colors),
                      _buildDetailChip(context, Icons.bathtub, '${property.baths} Bath', colors),
                      _buildDetailChip(context, Icons.square_foot, '${property.size} m²', colors),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.actionPrimaryDefault,
                      borderRadius: BorderRadius.circular(16),
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
        const SizedBox(width: 6),
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
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.network(broker.imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(broker.name, style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFFFD511)),
                    const SizedBox(width: 4),
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
