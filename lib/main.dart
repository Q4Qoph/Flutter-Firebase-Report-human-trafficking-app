import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_app1/accounts/admin.dart';
import 'package:project_app1/accounts/user.dart';
import 'package:project_app1/auth/toggle_auth.dart';
import 'package:project_app1/incident_report/screens/incident_report_screen.dart';
import 'package:project_app1/screens/home_screen.dart';
import 'package:project_app1/screens/join_screen.dart';
import 'package:project_app1/screens/learn_screen.dart';
import 'package:project_app1/services/auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:project_app1/models/app_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<AppUser?>(
          create: (context) => context.read<AuthService>().appUser,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'End Trafficking',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        iconTheme: IconThemeData(color: Colors.lightGreen.shade900),
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.lightGreen),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/learn': (context) => const LearnScreen(),
        '/join': (context) => const JoinScreen(),
        '/auth': (context) => const ToggleAuth(),
        '/report': (context) => const IncidentReportScreen(),
        '/account': (context) => const BaseWrapper(),
        '/admin': (context) => const AdminScreen(),
        '/user': (context) => const UserScreen(),
      },
    );
  }
}

class BaseWrapper extends StatelessWidget {
  const BaseWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const ToggleAuth();
    } else {
      return const UserScreen(
          initialTabIndex: 1); // Navigate to the "Updates" tab
    }
  }
}
