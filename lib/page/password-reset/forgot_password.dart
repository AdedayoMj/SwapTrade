import 'package:flutter/material.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';

import 'package:swap/services/auth.dart';
import 'package:swap/shared/loading.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 280,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -40,
                          height: 300,
                          width: width,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/background-1.png'),
                                        fit: BoxFit.fill)),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: BackButton(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.3,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeAnimation(
                              1.5,
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/clock.png'))),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                            1.5,
                            Text(
                              "Forgot Password",
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            1.7,
                            Container(
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
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? 'Enter an email'
                                            : null,
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        FadeAnimation(
                            1.9,
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.resetAccountPasswordEmail(
                                    email: email,
                                  );
                                  print(result);

                                  if (result == null) {
                                    Navigator.pop(context);
                                    setState(() {
                                      loading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Forgot Password',
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            ),
                                            content: Text(
                                              'Password reset link has been sent to $email email',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: kPrimaryColor),
                                            ),
                                          );
                                        });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Forgot Password',
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            ),
                                            content: Text(
                                              result,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: kPrimaryColor),
                                            ),
                                          );
                                        });
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
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
