import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:let_me_grab/controller/firebase_controller.dart';
import 'package:let_me_grab/controller/home_controller.dart';
import 'package:let_me_grab/screens/home/home_screen.dart';
import 'package:let_me_grab/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FirebaseController(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeController(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading screen if the authentication state is waiting.
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              // Navigate to the home screen if the user is already logged in.
              return HomeScreen();
            } else {
              // Navigate to the login screen if the user is not logged in.
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
