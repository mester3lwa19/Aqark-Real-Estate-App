import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_effects.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../core/widgets/property_image.dart';
import '../models/models.dart';
import '../../favorites.dart';
import '../../../routes/app_routes.dart';

class PropertyCard extends StatelessWidget {
  final Property? property; 
  final String title;
  final String price;
  final bool isVerified;

  const PropertyCard({
    super.key,
    this.property,
    required this.title,
    required this.price,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppTheme.getColors(context);
    final isLightMode = theme.brightness == Brightness.light;
    final favoritesController = GetIt.instance<FavoritesController>();

    return GestureDetector(
      onTap: () {
        if (property != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.propertyDetails,
            arguments: property,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing4,
          vertical: AppSpacing.spacing2,
        ),
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: isLightMode ? AppShadows.shadowDefault : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.radius8),
                  child: SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: (property != null && property!.imageUrl.isNotEmpty)
                        ? PropertyImage(
                            imageUrl: property!.imageUrl,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: colors.surfaceBackground,
                            child: Icon(Icons.home, size: 50, color: colors.textDisabled),
                          ),
                  ),
                ),
                if (property != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ListenableBuilder(
                      listenable: favoritesController,
                      builder: (context, _) {
                        final isFavorite = favoritesController.isFavorite(property!.id);
                        return GestureDetector(
                          onTap: () => favoritesController.toggleFavorite(property!),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing3),

            // Title
            Text(
              title,
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize6,
                fontWeight: AppTypography.weightSemiBold,
                lineHeight: AppTypography.lineHeight7,
              ).copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.spacing1),

            // Price and Verified Badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: AppTypography.createStyle(
                    fontSize: AppTypography.fontSize4,
                    fontWeight: AppTypography.weightBold,
                    lineHeight: AppTypography.lineHeight6,
                  ).copyWith(color: colors.actionPrimaryDefault),
                ),
                if (isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing2,
                      vertical: AppSpacing.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: colors.propertyVerifiedBadge.withValues(alpha: AppOpacity.opacity15),
                      borderRadius: BorderRadius.circular(AppRadius.radius4),
                    ),
                    child: Text(
                      'Verified',
                      style:
                          AppTypography.createStyle(
                            fontSize: AppTypography.fontSize3,
                            fontWeight: AppTypography.weightSemiBold,
                            lineHeight: AppTypography.lineHeight4,
                          ).copyWith(
                            color: colors.propertyVerifiedBadge,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
