import 'package:crime_map/screens/screens.dart';
import 'package:crime_map/services/service.dart';
import 'package:crime_map/shared_widgets/crimeApp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CrimeApp.sharedPreferences = await SharedPreferences.getInstance();
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
        ),
        StreamProvider<List<CrimeLocation>>.value(
            value: Global.crimeLocation.getData().asStream(), initialData: []),
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
          '/authentication': (context) => AuthenticationPage(),
        },
      ),
    );
  }
}
