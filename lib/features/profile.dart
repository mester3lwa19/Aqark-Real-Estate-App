import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'auth/data/data.dart';
import '../core/settings/settings_controller.dart';
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
  late final SettingsController _settingsController;
  
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authRepo = GetIt.instance<AuthRepository>();
    _settingsController = GetIt.instance<SettingsController>();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final data = await _authRepo.getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null && mounted) {
      setState(() => _isLoading = true);
      await _authRepo.updateProfile(photoUrl: image.path);
      await _loadUserData();
    }
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _userData?['name'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter your name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                await _authRepo.updateProfile(name: newName);
                await _loadUserData();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = isDark ? AppSemanticColors.dark : AppSemanticColors.light;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String email = _userData?['email'] ?? "email@example.com";
    final String name = _userData?['name'] ?? email.split('@')[0];
    final String? photoUrl = _userData?['photo_url'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: ListenableBuilder(
        listenable: _settingsController,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing6),
            child: Column(
              children: [
                // Profile Image with Edit Button
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: colors.borderSubtle,
                      backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                        ? (photoUrl.startsWith('http') 
                            ? NetworkImage(photoUrl) as ImageProvider
                            : FileImage(File(photoUrl)))
                        : const AssetImage('assets/images/aqark.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.actionPrimaryDefault,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.scaffoldBackgroundColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Name with Edit Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTypography.createStyle(
                        fontSize: AppTypography.fontSize6,
                        fontWeight: AppTypography.weightBold,
                        lineHeight: AppTypography.lineHeight7,
                      ).copyWith(color: colors.textPrimary),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _editName,
                      icon: Icon(Icons.edit, size: 18, color: colors.actionPrimaryDefault),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Text(
                  email,
                  style: TextStyle(color: colors.textDisabled, fontSize: 16),
                ),
                const SizedBox(height: 48),
                
                // --- SETTINGS SECTION ---
                Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(AppRadius.radius16),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(
                          _settingsController.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                          color: colors.actionPrimaryDefault,
                        ),
                        title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600)),
                        value: _settingsController.themeMode == ThemeMode.dark,
                        onChanged: (value) => _settingsController.updateThemeMode(value),
                        activeColor: colors.actionPrimaryDefault,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
                
                // Sign Out Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.radius8),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                    onPressed: _handleSignOut,
                    child: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
