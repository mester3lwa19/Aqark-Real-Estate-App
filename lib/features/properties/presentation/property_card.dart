import 'package:flutter/material.dart';
// Note: Adjust these import paths if your folder structure is slightly different
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_effects.dart';
import '../../../../../core/theme/app_colors.dart';
import '../models/models.dart';
import '../../../routes/app_routes.dart';

class PropertyCard extends StatelessWidget {
  final Property? property; // Optional for backward compatibility in mock lists
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
    final colorScheme = Theme.of(context).colorScheme;
    final isLightMode = Theme.of(context).brightness == Brightness.light;

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
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.radius16),
          boxShadow: AppShadows.shadowDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: (property != null && property!.imageUrl.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(property!.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: colorScheme.secondary.withValues(
                  alpha: AppOpacity.opacity10,
                ),
                borderRadius: BorderRadius.circular(AppRadius.radius8),
              ),
              child: (property == null || property!.imageUrl.isEmpty)
                  ? const Center(child: Icon(Icons.home, size: 50, color: Colors.grey))
                  : null,
            ),
            const SizedBox(height: AppSpacing.spacing3),

            // Title
            Text(
              title,
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize6,
                fontWeight: AppTypography.weightSemiBold,
                lineHeight: AppTypography.lineHeight7,
              ).copyWith(color: colorScheme.onSurface),
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
                  ).copyWith(color: colorScheme.primary),
                ),
                if (isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing2,
                      vertical: AppSpacing.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: isLightMode
                          ? AppSemanticColors.light.propertyVerifiedBadge
                                .withValues(alpha: AppOpacity.opacity15)
                          : AppSemanticColors.dark.propertyVerifiedBadge
                                .withValues(alpha: AppOpacity.opacity15),
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
                            color: isLightMode
                                ? AppSemanticColors.light.propertyVerifiedBadge
                                : AppSemanticColors.dark.propertyVerifiedBadge,
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
