import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Resources/routes_manager.dart';
import 'package:social_media_app/Resources/theme_manager.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/Screens/auth/views/signUp_screen.dart';
import 'package:social_media_app/Screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Social Media App',
      theme: getApplicationTheme(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateRoute: routeGenerator.getRoute,
      initialRoute: routes.splashRoute,
    );
  }
}
