import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/medication_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

class MediTrackApp extends StatelessWidget {
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
        theme: AppTheme.lightTheme,
        home: SplashScreen(),
      ),
    );
  }
}