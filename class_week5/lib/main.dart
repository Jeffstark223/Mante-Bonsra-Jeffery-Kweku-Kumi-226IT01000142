import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with manual options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authenticated User Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.teal, // changed from blue
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.orangeAccent), // accent color
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: const TextTheme(
          headline4: TextStyle(color: Colors.teal),
          headline5: TextStyle(color: Colors.teal),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.teal, // buttons now teal
            onPrimary: Colors.white, // button text
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          prefixIconColor: Colors.teal,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.teal, // CircularProgressIndicator color
        ),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}