import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/models.dart';
import '../../favorites.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/property_image.dart';
import '../../../routes/app_routes.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late final FavoritesController _favoritesController;
  int _activeTab = 0; // 0: About, 1: 3d Tour, 2: Review
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _favoritesController = GetIt.instance<FavoritesController>();
  }

  void _toggleFavorite() async {
    try {
      await _favoritesController.toggleFavorite(widget.property);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    return ListenableBuilder(
      listenable: _favoritesController,
      builder: (context, _) {
        final isFavorite = _favoritesController.isFavorite(widget.property.id);
        
        return Scaffold(
          backgroundColor: colors.surfaceBackground,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Property Details",
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize4,
                fontWeight: AppTypography.weightBold,
                lineHeight: AppTypography.lineHeight5,
              ).copyWith(color: colors.textPrimary),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : colors.textPrimary,
                ),
                onPressed: _toggleFavorite,
              ),
              IconButton(
                icon: Icon(Icons.share_outlined, color: colors.textPrimary),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.outlined_flag, color: colors.textPrimary),
                onPressed: () {},
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.radius24),
                    child: Stack(
                      children: [
                        _buildPropertyImage(widget.property.imageUrl),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "1/8 Photos",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Thumbnails
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.radius8),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: _buildPropertyImage(widget.property.imageUrl),
                              ),
                              if (index == 3)
                                Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.black.withOpacity(0.4),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "+4",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Title and Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.property.title,
                          style: AppTypography.createStyle(
                            fontSize: AppTypography.fontSize5,
                            fontWeight: AppTypography.weightBold,
                            lineHeight: AppTypography.lineHeight6,
                          ).copyWith(color: colors.textPrimary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.actionPrimaryDefault.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 14, color: colors.actionPrimaryDefault),
                            const SizedBox(width: 4),
                            Text(
                              "4.5",
                              style: TextStyle(
                                color: colors.actionPrimaryDefault,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                  child: Text(
                    "${widget.property.price.toStringAsFixed(0)} EGP",
                    style: AppTypography.createStyle(
                      fontSize: AppTypography.fontSize6,
                      fontWeight: AppTypography.weightExtraBold,
                      lineHeight: AppTypography.lineHeight7,
                    ).copyWith(color: colors.actionPrimaryDefault),
                  ),
                ),
                const SizedBox(height: 16),
                // Specs (Bed, Bath, Sqm)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.borderSubtle),
                      borderRadius: BorderRadius.circular(AppRadius.radius16),
                      color: colors.surfaceCard,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSpecItem(Icons.bed_outlined, "${widget.property.beds} Bed", colors),
                        _buildSpecItem(Icons.bathtub_outlined, "${widget.property.baths} Bath", colors),
                        _buildSpecItem(Icons.architecture, "${widget.property.sqm} sqm", colors),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTabItem("About", 0, colors),
                      _buildTabItem("3d Tour", 1, colors),
                      _buildTabItem("Review", 2, colors),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 16),
                // Tab Content
                _buildTabContent(colors),
                const SizedBox(height: 80), // For bottom nav
              ],
            ),
          ),
          bottomNavigationBar: _buildActionBottomBar(colors),
        );
      },
    );
  }

  Widget _buildPropertyImage(String imageUrl) {
    return PropertyImage(
      imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/600x400',
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildActionBottomBar(AppSemanticColors colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing4),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Visit booking feature coming soon!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.actionPrimaryDefault,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius16),
                  ),
                ),
                child: const Text("Book a Visit", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, AppSemanticColors colors) {
    return Column(
      children: [
        Icon(icon, color: colors.actionPrimaryDefault),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTabItem(String title, int index, AppSemanticColors colors) {
    final isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? colors.actionPrimaryDefault : colors.textDisabled,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 40,
              color: colors.actionPrimaryDefault,
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent(AppSemanticColors colors) {
    switch (_activeTab) {
      case 0:
        return _buildAboutTab(colors);
      case 1:
        return _build3dTourTab(colors);
      case 2:
        return _buildReviewTab(colors);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAboutTab(AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description",
            style: AppTypography.createStyle(
              fontSize: AppTypography.fontSize4,
              fontWeight: AppTypography.weightBold,
              lineHeight: AppTypography.lineHeight5,
            ).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            "${widget.property.description}${_isDescriptionExpanded ? " This luxurious modern villa offers an unparalleled living experience. Featuring high-end finishes, automated climate control, and a state-of-the-art security system. The expansive outdoor area includes a heated infinity pool, landscaped gardens, and a built-in BBQ station, making it perfect for hosting guests or enjoying quiet family evenings." : ""}",
            style: TextStyle(color: colors.textSecondary, height: 1.6),
            maxLines: _isDescriptionExpanded ? null : 3,
            overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            child: Text(
              _isDescriptionExpanded ? "Show Less" : "Read More", 
              style: TextStyle(color: colors.actionPrimaryDefault, fontWeight: FontWeight.bold)
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Listing Agent",
            style: AppTypography.createStyle(
              fontSize: AppTypography.fontSize4,
              fontWeight: AppTypography.weightBold,
              lineHeight: AppTypography.lineHeight5,
            ).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: colors.borderSubtle),
              borderRadius: BorderRadius.circular(AppRadius.radius16),
              color: colors.surfaceCard,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ahmed Mansour", style: TextStyle(fontWeight: FontWeight.bold, color: colors.textPrimary)),
                      Text("Specialist in Sodic & Emaar", style: TextStyle(fontSize: 12, color: colors.textDisabled)),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: colors.actionPrimaryDefault),
                          const SizedBox(width: 4),
                          Text("4.9 (82 reviews)", style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone_outlined, size: 20),
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    side: BorderSide(color: colors.borderSubtle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3dTourTab(AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Interactive Virtual Tour",
            style: AppTypography.createStyle(
              fontSize: AppTypography.fontSize4,
              fontWeight: AppTypography.weightBold,
              lineHeight: AppTypography.lineHeight5,
            ).copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            "Experience every corner of the property from the comfort of your home.",
            style: TextStyle(color: colors.textDisabled, fontSize: 12),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.radius16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1200&q=80',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.actionPrimaryDefault,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      _buildTourTag(Icons.vibration, "VR Mode"),
                      const SizedBox(width: 8),
                      _buildTourTag(Icons.fullscreen, ""),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.circle, color: Colors.green, size: 8),
                        SizedBox(width: 4),
                        Text("Main Lounge", style: TextStyle(color: Colors.white, fontSize: 10)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTourInfo(Icons.gps_fixed, "Hotspots", "24 Points", colors)),
              const SizedBox(width: 12),
              Expanded(child: _buildTourInfo(Icons.high_quality, "Quality", "4K HDR", colors)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.actionPrimaryDefault.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppRadius.radius8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.actionPrimaryDefault, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "This 3D tour covers the entire floor plan, including the private garden and pool deck.",
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ],
        ],
      ),
    );
  }

  Widget _buildTourInfo(IconData icon, String title, String value, AppSemanticColors colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderSubtle),
        borderRadius: BorderRadius.circular(AppRadius.radius8),
        color: colors.surfaceCard,
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.actionPrimaryDefault, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 10, color: colors.textDisabled)),
              Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab(AppSemanticColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacing4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews (24)",
                style: AppTypography.createStyle(
                  fontSize: AppTypography.fontSize4,
                  fontWeight: AppTypography.weightBold,
                  lineHeight: AppTypography.lineHeight5,
                ).copyWith(color: colors.textPrimary),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: colors.actionPrimaryDefault),
                  const SizedBox(width: 4),
                  Text("4.5", style: TextStyle(color: colors.actionPrimaryDefault, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildReviewCard(
            "Ahmed Mansour", 
            "10hr ago", 
            "The property is absolutely stunning, especially the view of the Nile from the balcony. Highly recommend for anyone looking for premium living.", 
            "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=100&q=80",
            colors,
          ),
          _buildReviewCard(
            "Sarah El-Masry", 
            "1d ago", 
            "Great location and very responsive agent. The virtual tour was very helpful in making my decision.", 
            "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=100&q=80",
            colors,
          ),
          _buildReviewCard(
            "Khaled Youssef", 
            "3d ago", 
            "The finishing is top-notch and the community is very quiet and secure.", 
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80",
            colors,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String time, String content, String avatarUrl, AppSemanticColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radius16),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20, 
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: TextStyle(fontSize: 11, color: colors.textDisabled)),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.actionPrimaryDefault.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 10, color: colors.actionPrimaryDefault),
                    Text("4.5", style: TextStyle(fontSize: 8, color: colors.actionPrimaryDefault, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              const Text("12", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 16),
              const Icon(Icons.send_outlined, size: 16, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
