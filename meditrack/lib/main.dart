import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/medication_provider.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(MediTrackApp());
}

class MediTrackApp extends StatelessWidget {
  const MediTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => MedicationProvider()),
  ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MediTrack',

        // 🎨 LIGHT THEME (PROFESSIONAL)
        theme: AppTheme.lightTheme,

        // 🚀 START HERE (we will handle auto-login in SplashScreen)
        home: const SplashScreen(),
      ),
    );
  }
}