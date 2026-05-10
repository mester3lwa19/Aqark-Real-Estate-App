import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../main_hub_screen.dart';
import '../data/data.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = GetIt.instance<AuthRepository>();
    final initialUid = authRepository.currentUserId;

    // 1. Immediate resolution if we already have a local session
    if (initialUid != null) {
      return const MainHubScreen();
    }

    // 2. Otherwise, listen for changes (like login success)
    return StreamBuilder<String?>(
      stream: authRepository.onAuthStateChanged,
      initialData: initialUid,
      builder: (context, snapshot) {
        final String? uid = snapshot.data;

        if (uid != null) {
          return const MainHubScreen();
        }

        // If no user and we've finished the initial check (or it was null)
        if (snapshot.connectionState != ConnectionState.waiting || snapshot.hasData) {
          return const LoginScreen();
        }

        // Fallback for edge cases
        return const LoginScreen();
      },
    );
  }
}
