import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/services/auth.dart';

class PasswordResetInApp extends StatefulWidget {
  @override
  _PasswordResetInAppState createState() => _PasswordResetInAppState();
}

class _PasswordResetInAppState extends State<PasswordResetInApp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String currentPassword;
  String newPassword;
  String confirmPassword;

  bool checkCurrentPasswordValid = true;

  bool loading = false;

  changeSuccessful() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: const Text('Password Reset'),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            currentPassword = val;
                          });
                        },
                        validator: (val) =>
                            val.isEmpty ? 'Enter your current password' : null,
                        decoration: InputDecoration(
                            errorText: checkCurrentPasswordValid
                                ? null
                                : 'Invalid current password',
                            border: InputBorder.none,
                            hintText: "Current Password",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) =>
                            val.isEmpty ? 'Enter your new password' : null,
                        onChanged: (val) {
                          setState(() {
                            newPassword = val;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "New Password",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[200]))),
                      child: TextFormField(
                        obscureText: true,
                        validator: (val) => val != newPassword
                            ? 'Password does not match'
                            : null,
                        onChanged: (val) {
                          setState(() {
                            confirmPassword = val;
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState.validate()) {
                          checkCurrentPasswordValid =
                              await _auth.checkCurrentPassword(currentPassword);
                          if (checkCurrentPasswordValid) {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Reset password',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    content: Text(
                                      'Password has been reset',
                                      style: TextStyle(
                                          fontSize: 15, color: kPrimaryColor),
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                });

                            _auth.updateUserPassword(newPassword);
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kPrimaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "Reset",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
