import 'package:crime_map/screens/screens.dart';
import 'package:crime_map/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: AuthService().user, initialData: AuthService().getUser),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'NotoSansJP'),
        // home: AuthenticationPage(),

        // Named Routes
        routes: {
          '/': (context) => AuthenticationPage(),
          '/reportedCrime': (context) => ReportedCrime(),
        },
      ),
    );
  }
}
