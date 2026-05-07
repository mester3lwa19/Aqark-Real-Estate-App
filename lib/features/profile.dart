import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'auth/data/data.dart';
import '../routes/app_routes.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimensions.dart';
import '../core/theme/app_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthRepository _authRepo;

  @override
  void initState() {
    super.initState();
    _authRepo = GetIt.instance<AuthRepository>();
  }

  void _handleSignOut() async {
    await _authRepo.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppSemanticColors.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing6),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/Aqark.png'), // Placeholder
            ),
            const SizedBox(height: 16),
            Text(
              "Karim Ahmed", // Placeholder
              style: AppTypography.createStyle(
                fontSize: AppTypography.fontSize6,
                fontWeight: AppTypography.weightBold,
                lineHeight: AppTypography.lineHeight7,
              ),
            ),
            const Text("karim@example.com"),
            const SizedBox(height: 32),
            _buildProfileOption(
              icon: Icons.person_outline,
              title: "Edit Profile",
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            _buildProfileOption(
              icon: Icons.notifications_none,
              title: "Property Alerts",
              onTap: () => Navigator.pushNamed(context, AppRoutes.propertyAlerts),
            ),
            _buildProfileOption(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {},
            ),
            _buildProfileOption(
              icon: Icons.help_outline,
              title: "Help & Support",
              onTap: () {},
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.radius8),
                  ),
                ),
                onPressed: _handleSignOut,
                child: const Text("Sign Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
