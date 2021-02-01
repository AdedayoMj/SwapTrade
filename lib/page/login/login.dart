import 'package:flutter/material.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/page/password-reset/forgot_password.dart';

import 'package:swap/page/signup/signup.dart';
import 'package:swap/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: MediaQuery.of(context).size.height / 2.3,
                    width: width,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/background-1.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    left: 30,
                    width: 80,
                    height: MediaQuery.of(context).size.height / 4,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        )),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: MediaQuery.of(context).size.height / 5.3,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        )),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: MediaQuery.of(context).size.height / 5.3,
                    child: FadeAnimation(
                        1.5,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
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
                        "Login",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 20,
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
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an email' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  validator: (val) => val.length < 6
                                      ? 'Enter a password 6+ chars long'
                                      : null,
                                  onChanged: (val) {
                                    setState(() {
                                      password = val;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ));
                    },
                    child: FadeAnimation(
                        1.7,
                        Center(
                            child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color.fromRGBO(196, 135, 198, 1)),
                        ))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  !busy
                      ? FadeAnimation(
                          1.9,
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  busy = true;
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                if (result is bool) {
                                  setState(() {
                                    busy = false;
                                  });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Login',
                                            style:
                                                TextStyle(color: kPrimaryColor),
                                          ),
                                          content: Text(
                                            result,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: kPrimaryColor),
                                          ),
                                        );
                                      });
                                  setState(() {
                                    busy = false;
                                  });
                                }
                              } else {
                                setState(() {
                                  busy = false;
                                });
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
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )),

                              //  Text(
                              //   "Login",
                              //   style: TextStyle(color: Colors.white),
                              // ),
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor)),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      2,
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpPage(),
                          ));
                        },
                        child: Text(
                          "Create Account",
                          style:
                              TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                        ),
                      ))),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
