import 'package:crime_map/services/auth.dart';
import 'package:crime_map/shared_widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  AuthService? auth = AuthService();

  @override
  void initState() {
    if (auth!.getUser != null) {
      Future.delayed(Duration.zero,
          () => Navigator.pushReplacementNamed(context, '/reportedCrime'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Config().darkGradientShadecolor,
              Config().darkGradientShadecolor,
              Config().darkGradientShadecolor,
              Config().lightGradientShadecolor,
            ],
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Color(0xfff8a31b),
                          size: 40,
                        ),
                        Text('Crime Alert',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                                letterSpacing: 2.0,
                                color: Colors.white))
                      ],
                    ),
                  )),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 34.0,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        MaterialButton(
                          onPressed: () {
                            auth!.googleSignIn().then((value) {
                              Navigator.pushReplacementNamed(
                                  context, '/reportedCrime');
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            height: MediaQuery.of(context).size.height * 0.10,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.google,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                  "Sign in with Google",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('Add an area reported with crime',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
