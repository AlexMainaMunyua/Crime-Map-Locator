import 'package:crime_map/screens/screens.dart';
import 'package:crime_map/services/auth.dart';
import 'package:crime_map/services/service.dart';
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
        StreamProvider<UserInformation>.value(
          value: Global.userInfo.getDocument().asStream(),
          initialData: UserInformation.initialData(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            accentColor: Colors.white,
            // cardColor: Colors.white,
            fontFamily: 'NotoSansJP'),
        // home: AuthenticationPage(),

        // Named Routes
        routes: {
          '/': (context) => AuthenticationPage(),
          '/reportedCrime': (context) => ReportedCrime(),
          '/authentication' : (context) => AuthenticationPage(),
        },
      ),
    );
  }
}
