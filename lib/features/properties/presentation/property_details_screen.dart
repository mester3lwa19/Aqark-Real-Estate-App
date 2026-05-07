import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late final PropertyRepository _propertyRepo;
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _propertyRepo = GetIt.instance<PropertyRepository>();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await _propertyRepo.getFavorites();
    if (mounted) {
      setState(() {
        _isFavorite = favorites.any((p) => p.id == widget.property.id);
        _isLoadingFavorite = false;
      });
    }
  }

  void _toggleFavorite() async {
    setState(() => _isFavorite = !_isFavorite);
    try {
      await _propertyRepo.toggleFavorite(widget.property);
    } catch (e) {
      if (mounted) {
        setState(() => _isFavorite = !_isFavorite); // Revert
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.light;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.property.imageUrl.isNotEmpty 
                    ? widget.property.imageUrl 
                    : 'https://via.placeholder.com/400x300',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, size: 100, color: Colors.grey),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: _isLoadingFavorite ? null : _toggleFavorite,
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.spacing6),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  widget.property.title,
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize6,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.property.price} EGP",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize5,
                    fontWeight: AppTypography.weightSemiBold,
                    lineHeight: AppTypography.lineHeight6,
                  ).copyWith(color: colors.actionPrimaryDefault),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.property.address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Text(
                  "Description",
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize4,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.property.description,
                  style: const TextStyle(height: 1.5),
                ),
                const SizedBox(height: 100), // Space for bottom button
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing6),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.actionPrimaryDefault,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius8),
                  ),
                ),
                onPressed: () {},
                child: const Text("Contact Owner", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline),
              style: IconButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
