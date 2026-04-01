import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/medication_provider.dart';
import 'services/auth_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MediTrackApp());
}

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
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Color(0xFFF5F7FA),
          textTheme: TextTheme(
            bodyText2: TextStyle(fontSize: 16),
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}