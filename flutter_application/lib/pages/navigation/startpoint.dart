import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/mainUI/bulletinboard.dart';
import 'package:pandabar/pandabar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../authentication/login.dart';
import '../mainUI/homepage.dart';
import '../mainUI/petitionpage.dart';
import '../mainUI/resourcepage.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';

class HomeP extends StatelessWidget {
  var myUser;
  var userAuth;
  HomeP({Key key, this.myUser, this.userAuth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(
        myUser: this.myUser,
        userAuth: this.userAuth,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  var myUser;
  var userAuth;
  HomePage({Key key, this.myUser, this.userAuth}) : super(key: key);

  @override
  _HomePageState createState() =>
      _HomePageState(myUser: this.myUser, userAuth: this.userAuth);
}

class _HomePageState extends State<HomePage> {
  @override
  int page = 0;
  int _currentIndex = 0;
  var myUser;
  var userAuth;
  _HomePageState({this.myUser, this.userAuth});
  final List<Widget> _children = [
    TP(),
    PetitionP(),
    BulletinBoardP(),
    ResourceP(),
    //TP()
  ];

  @override
  Widget build(BuildContext context) {
    TP Obj = _children[0];
    Obj.setUser(this.myUser);
    Obj.setAuth(this.userAuth);
    List list = myUser.emergency_contacts;
    List val = List.from(list);
    int count = 0;

    return Scaffold(
      extendBody: true,
      body: _children[page],
      bottomNavigationBar: PandaBar(
        buttonData: [
          PandaBarButtonData(
            id: 0,
            icon: Icons.home,
            title: 'Home',
          ),
          PandaBarButtonData(
            id: 1,
            icon: Icons.edit,
            title: 'Petitions',
          ),
          PandaBarButtonData(
            id: 2,
            icon: Icons.event,
            title: 'Events',
          ),
          PandaBarButtonData(
            id: 3,
            icon: Icons.lightbulb,
            title: 'Resources',
          ),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
        },
        fabIcon: FloatingActionButton(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            child: GestureDetector(
              child: Icon(
                Icons.sos,
                size: 40,
                color: Colors.black,
              ),
              onLongPress: () async {
                String temp1 = val[0];
                String temp2 = val[1];
                String temp3 = val[2];

                bool value = false;

                if (count % 4 == 0 && count != 0) {
                  print("This is emergency call\n");
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Please Confirm!"),
                          content: const Text("Do you want to call 911?"),
                          actions: [
                            // The "Yes" button
                            TextButton(
                                onPressed: () async {
                                  value =
                                      await FlutterPhoneDirectCaller.callNumber(
                                          "9112");

                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  // Close the dialog
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'))
                          ],
                        );
                      });
                } else {
                  while (!value) {
                    value = await FlutterPhoneDirectCaller.callNumber(temp1);
                    print("This is the value after making a call:\n");
                    print(value);

                    val[0] = temp3;
                    val[1] = temp1;
                    val[2] = temp2;
                    count++;
                  }
                  print(val[0]);
                }

                /* if (count % 3 == 0) {
                  print("THis is emergency call\n");
                  AlertDialog(
                    title: const Text("Please Confirm!"),
                    content: const Text("Do you want to call 911?"),
                    actions: [
                      // The "Yes" button
                      TextButton(
                          onPressed: () async {
                            value = await FlutterPhoneDirectCaller.callNumber(
                                "9112");

                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'))
                    ],
                  );
                }
                */
              },
            ),
            onPressed: () async {
              final map = Map<String, dynamic>();

              map['emergency'] = list;

              List<String> emer = (map['emergency'] as List)
                  ?.map((item) => item as String)
                  ?.toList();

              PermissionStatus status;

              status = await Permission.sms.request();

              if (status.isGranted) {
                String val = await sendSMS(
                        message: "This is an SOS message from your relation" +
                            myUser.name +
                            " please respond",
                        recipients: emer,
                        sendDirect: true)
                    .catchError((onError) {
                  print(onError);
                });
                print(val);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    content: Container(
                        height: 90,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text("Successfully sent message!"))));
              } else if (status.isPermanentlyDenied) {

                 if(Platform.isIOS) {
                   PermissionStatus status;

                   status = await Permission.contacts.request();


                     String val = await sendSMS(
                         message: "This is an SOS message from your relation" +
                             myUser.name +
                             " please respond",
                         recipients: emer)
                         .catchError((onError) {
                       print(onError);
                     });
                     print(val);

                 }
              }
            }),
        buttonColor: Colors.white,
        buttonSelectedColor: Colors.amber,
        fabColors: [Colors.amber, Colors.amber],
      ),
    );
  }
}
