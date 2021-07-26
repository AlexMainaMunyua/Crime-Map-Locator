import 'package:crime_map/services/service.dart';
import 'package:crime_map/shared_widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    final user = Provider.of<UserInformation>(context);//User Provider
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            DrawerHeader(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: FaIcon(
                    FontAwesomeIcons.user,
                    color: Colors.grey[500],
                  ),
                  backgroundColor: Colors.grey[200],
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${user.userName}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${user.userEmail}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _auth.signOut().then((value) =>
                          Navigator.pushReplacementNamed(context, '/authentication'));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.50,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Config().lightGradientShadecolor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("Logout",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}