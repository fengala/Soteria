import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/services/database.dart';
//import 'package:flutter/services.dart';
import '../../services/auth.dart';
import 'login.dart';
import '../mainUI/homepage.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../mainUI/homepage.dart';
import '../navigation/startpoint.dart';
import '../authentication/resetPassword.dart';

class UpdatePage extends StatefulWidget {
  var myUser;
  var userAuth;

  UpdatePage({Key key, this.title, this.myUser, this.userAuth})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;
  @override
  _UpdatePageState createState() => _UpdatePageState(myUser, userAuth);
}

String _formatPhoneNumber(String digits) {
  if (digits.length < 3) {
    return digits;
  } else if (digits.length < 6) {
    return '(${digits.substring(0, 3)})${digits.substring(3)}';
  } else {
    return '(${digits.substring(0, 3)})${digits.substring(3, 6)}-${digits.substring(6)}';
  }
}

//TO-DO:
//Scroll bar
//Contacts (+ button)
//User phone number
class _UpdatePageState extends State<UpdatePage> {
  UserModel myUser;
  UserAuth userAuth;
  String name = "";
  String last_name = "";
  String username = "";
  String password = "";
  String password2 = "";
  String phone_number = "";
  String emergency_contact1 = "";
  String emergency_contact2 = "";
  String emergency_contact3 = "";

  bool _isAnonymous = false;

  TextEditingController phoneNumberController;
  TextEditingController phoneNumberController2;
  TextEditingController phoneNumberController3;
  TextEditingController phoneNumberController4;
  _UpdatePageState(this.myUser, this.userAuth) {
    name = myUser.name.split(" ")[0];
    last_name = myUser.name.split(" ")[1];
    username = myUser.username;
    password = myUser.password;
    phone_number = myUser.phone_number;
    emergency_contact1 = myUser.emergency_contacts[0];
    emergency_contact2 = myUser.emergency_contacts[1];
    emergency_contact3 = myUser.emergency_contacts[2];
    phoneNumberController =
        TextEditingController(text: _formatPhoneNumber(emergency_contact1));
    phoneNumberController2 =
        TextEditingController(text: _formatPhoneNumber(emergency_contact2));
    phoneNumberController3 =
        TextEditingController(text: _formatPhoneNumber(emergency_contact3));
    phoneNumberController4 =
        TextEditingController(text: _formatPhoneNumber(phone_number));
    _isAnonymous = myUser.anon;
  }
  TextEditingController text_widgets = TextEditingController();

  /* void myMEthod() async {
    var user_detail = await DatabaseService(uid: UserAuth.user.uid)
        .getUser(UserAuth.user.uid);

    this.name = user_detail['name'].split(" ")[0];
    this.last_name = user_detail['name'].split(" ")[1];
    this.username = user_detail['username'];
    this.password = user_detail['password'];
    this.phone_number = user_detail['phone_number'];
    // this.emergency_contact1 = user_detail['emergency_contacts'][0];
    //this.emergency_contact2 = user_detail['emergency_contacts'][1];
    //this.emergency_contact3 = user_detail['emergency_contact3'][2];

    /* print(name);
    print(last_name);
    print(username);
    print(pasword);
    print(emergency_contact1);
    print(emergency_contact2);
    print(emergency_contact3);
    */
  }
  */

  String error_message;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void dispose() {
    text_widgets.dispose();
    super.dispose();
  }

  // GlobalKey<_RegisterPageState> form_key = GlobalKey();
  Future<String> revertPhoneNumber(String formattedPhoneNumber) async {
    return formattedPhoneNumber.replaceAll(RegExp(r'\D+'), '').substring(0, 10);
  }

  String validate_first_name(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_last_name(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  String validate_username(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  // String validate_password(String val) {
  //   if (val == null || val.isEmpty) {
  //     return "This field is mandatory";
  //   }
  //   return null;
  // }

  String validate_phone(String val) {
    if (val == null || val.isEmpty) {
      return "This field is mandatory";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextField(
      controller: TextEditingController(text: name),
      onChanged: (text) {
        name = text;

        //print(name);

        /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Mandatory"))));*/
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final lastName = TextField(
      controller: TextEditingController(text: last_name),
      onChanged: (text) {
        last_name = text;

        if (last_name == null) {
          /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text("Mandatory"))));*/
        }
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final usernameField = TextField(
      controller: TextEditingController(text: username),
      enabled: false,
      onChanged: (text) {
        username = text;
      },
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email Address",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final phoneNumber = TextField(
      controller: phoneNumberController4,
      onChanged: (text) {
        String digits = text.replaceAll(RegExp(r'\D+'), '');
        // format the phone number
        String formatted = _formatPhoneNumber(digits);
        // update the controller with the formatted phone number
        phoneNumberController4.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        phone_number = text;
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Enter phone number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final emergencyContactText = DefaultTextStyle(
        style: style,
        child: Text(
          "Emergency contacts:",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ));
    final emergencyContact1 = TextFormField(
      controller: phoneNumberController,
      onChanged: (text) {
        // remove any non-digit characters
        String digits = text.replaceAll(RegExp(r'\D+'), '');
        // format the phone number
        String formatted = _formatPhoneNumber(digits);
        // update the controller with the formatted phone number
        phoneNumberController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        emergency_contact1 = text;
        print("This si teh emenrfe1 " + emergency_contact1);
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter emergency contact number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final emergencyContact2 = TextFormField(
      controller: phoneNumberController2,
      onChanged: (text) {
        // remove any non-digit characters
        String digits = text.replaceAll(RegExp(r'\D+'), '');
        // format the phone number
        String formatted = _formatPhoneNumber(digits);
        // update the controller with the formatted phone number
        phoneNumberController2.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        emergency_contact2 = text;
        print("This si teh emenrfe2 " + emergency_contact2);
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter emergency contact number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final emergencyContact3 = TextFormField(
      controller: phoneNumberController3,
      onChanged: (text) {
        // remove any non-digit characters
        String digits = text.replaceAll(RegExp(r'\D+'), '');
        // format the phone number
        String formatted = _formatPhoneNumber(digits);
        // update the controller with the formatted phone number
        phoneNumberController3.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
        emergency_contact3 = text;
        print("This si teh emenrfe3 " + emergency_contact3);
      },
      keyboardType: TextInputType.phone,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Enter emergency contact number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final verifyUser = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () async {
          if (!this.myUser.username.contains("purdue.edu")) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text("Failed"),
                    content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.check),
                          DefaultTextStyle(
                              style: style,
                              child: Text(
                                "The email has to be a purdue member to green tick your account",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                  color: Colors.red,
                                ),
                              )),
                        ])));
          } else {
            this.userAuth.verifyUser();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeP(
                          myUser: this.myUser,
                          userAuth: this.userAuth,
                        )));

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text("Success!"),
                    content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.check),
                          DefaultTextStyle(
                              style: style,
                              child: Text(
                                "Verification Email Sent!",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                  color: Colors.green,
                                ),
                              )),
                        ])));
          }
        },
        child: Text("Verify Account",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final createAccount = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () async {
          bool prompt = true;

          if (emergency_contact1 != null) {
            emergency_contact1.trim();
          }
          if (emergency_contact2 != null) {
            emergency_contact2.trim();
          }
          if (emergency_contact3 != null) {
            emergency_contact3.trim();
          }

          bool test1 = true;
          bool test2 = true;
          bool test3 = true;
          bool test4 = true;

          try {
            if (name == null ||
                name.isEmpty ||
                password == null ||
                password.isEmpty ||
                username == null ||
                username.isEmpty ||
                phone_number == null ||
                phone_number.isEmpty ||
                last_name == null ||
                last_name.isEmpty) {
              prompt = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 100,
                  content: Container(
                      height: 120,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Text("There are a few fields missing\n"))));
            } else {
               phone_number = await revertPhoneNumber(phone_number);
              if (phone_number.length != 10) {
                prompt = false;
                test1 = false;
                print("This case section 5");
                print(phone_number.length);
                print(" This is the length: $phone_number");

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    elevation: 100,
                    content: Container(
                        height: 120,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                            "These are invalid contacts, please try again\n"))));
              }
              if (!emergency_contact1.isEmpty && emergency_contact1 != null) {
                if (emergency_contact1.length != 13 &&
                    (emergency_contact1.contains("("))) {
                  print("This case section 2");
                  print("hello");
                  prompt = false;
                  test2 = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 100,
                      content: Container(
                          height: 120,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                              "These are invalid contacts, please try again\n"))));
                }
              }
              if (!emergency_contact2.isEmpty && emergency_contact2 != null) {
                if (emergency_contact2.length != 13 &&
                    (emergency_contact2.contains("("))) {
                  print("This case section 3");

                  prompt = false;
                  test3 = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 100,
                      content: Container(
                          height: 120,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                              "These are invalid contacts, please try again\n"))));
                }
              }

              if (!emergency_contact3.isEmpty && emergency_contact3 != null) {
                if (emergency_contact3.length != 13 &&
                    (emergency_contact3.contains("("))) {
                  print("This case section 4");

                  prompt = false;
                  test4 = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      elevation: 100,
                      content: Container(
                          height: 120,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Text(
                              "These are invalid contacts, please try again\n"))));
                }
              }
              if (test1 && test2 && test3 && test4) {
                print("Hello\n");

                if (emergency_contact1 != null && !emergency_contact1.isEmpty) {
                  emergency_contact1 =
                      await revertPhoneNumber(emergency_contact1);
                  emergency_contact1.trim();
                } else {
                  emergency_contact1 = "";
                }
                if (emergency_contact2 != null && !emergency_contact2.isEmpty) {
                  emergency_contact2 =
                      await revertPhoneNumber(emergency_contact2);
                  emergency_contact2.trim();
                } else {
                  emergency_contact2 = "";
                }
                if (emergency_contact3 != null && !emergency_contact3.isEmpty) {
                  emergency_contact3 =
                      await revertPhoneNumber(emergency_contact3);
                  emergency_contact3.trim();
                } else {
                  emergency_contact3 = "";
                }
                
                List list = [
                  emergency_contact1,
                  emergency_contact2,
                  emergency_contact3
                ];

                name = name + " " + last_name;
                name.trim();
                username.trim();
                password.trim();
                name.trim();
                phone_number.trim();

                myUser.name = name;
                myUser.emergency_contacts = list;
                myUser.password = password;
                myUser.username = username;
                myUser.phone_number = phone_number;
                myUser.anon = _isAnonymous;
                //print(myUser.name);
                //print("After changing");
                //print(myUser.name);
                //print(myUser.password);
                //print(myUser.username);
                //print(myUser.uid);
                //print(myUser.emergency_contacts);
                //print(myUser.phone_number);

                var res = await DatabaseService(uid: myUser.uid).updateUser(
                  username,
                  password,
                  name,
                  list,
                  phone_number,
                  _isAnonymous,
                );
              }
            }
          } catch (x) {
            //print(x);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                    height: 90,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(x.code))));
          }
          if (prompt) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeP(
                          myUser: this.myUser,
                          userAuth: this.userAuth,
                        )));
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: Text("Success!"),
                    content: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.check),
                          DefaultTextStyle(
                              style: style,
                              child: Text(
                                "Successfully updated account details!",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                  color: Colors.green,
                                ),
                              )),
                        ])));
          }
        },
        child: Text("Update Account",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final backButton = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeP(
                        myUser: this.myUser,
                        userAuth: this.userAuth,
                      )));
        },
        child: Text("Back to Homepage",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final reset = Material(
      elevation: 0.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.amber,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(5.0, 3.75, 5.0, 3.75),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => resetPage(
                        myUser: this.myUser,
                        userAuth: this.userAuth,
                      )));
        },
        child: Text("Reset Password",
            textAlign: TextAlign.right,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 36, right: 36, top: 36, bottom: 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset(
                      "assets/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 25.0),
                  firstName,
                  SizedBox(height: 25.0),
                  lastName,
                  SizedBox(height: 25.0),
                  usernameField,
                  SizedBox(height: 25.0),
                  phoneNumber,
                  SizedBox(
                    height: 25.0,
                  ),
                  emergencyContactText,
                  SizedBox(height: 25.0),
                  emergencyContact1,
                  SizedBox(height: 25.0),
                  emergencyContact2,
                  SizedBox(height: 25.0),
                  emergencyContact3,
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Anonymous',
                        style: style.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Checkbox(
                        value: _isAnonymous,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.grey),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            _isAnonymous = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  createAccount,
                  SizedBox(
                    height: 5.0,
                  ),
                  backButton,
                  SizedBox(
                    height: 5.0,
                  ),
                  reset,
                  SizedBox(
                    height: 5.0,
                  ),
                  verifyUser,
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
