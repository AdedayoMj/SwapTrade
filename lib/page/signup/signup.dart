import 'package:flutter/material.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/services/auth.dart';
import 'package:swap/shared/loading.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String username = '';
  String email = '';
  String password = '';
  bool busy = false;
  bool agree = false;

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
              height: MediaQuery.of(context).size.height / 3,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: MediaQuery.of(context).size.height / 2.5,
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
                        "SignUp",
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
                                      username = val.trim().toLowerCase();
                                    });
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
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
                    height: 10,
                  ),
                  Row(
                    children: [
                      Material(
                        child: Checkbox(
                          activeColor: kPrimaryColor,
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              agree = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I have read and accept terms and conditions',
                        style: new TextStyle(
                          color: Colors.blue[900],
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  !busy
                      ? FadeAnimation(
                          1.9,
                          GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                if (agree == true) {
                                  setState(() {
                                    busy = true;
                                  });
                                  dynamic result =
                                      await _auth.signUpWithEmailAndPassword(
                                          username: username,
                                          email: email,
                                          password: password);
                                  if (result is bool) {
                                    setState(() {
                                      busy = false;
                                    });

                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'SignUp',
                                              style: TextStyle(
                                                  color: kPrimaryColor),
                                            ),
                                            content: Text(
                                              'Your account was successfully created, please login to your email to verify account',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: kPrimaryColor),
                                            ),
                                          );
                                        });
                                  } else {
                                    setState(() {
                                      busy = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'SignUp',
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
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'SignUp',
                                            style:
                                                TextStyle(color: kPrimaryColor),
                                          ),
                                          content: Text(
                                            'Please check the box to agree to the terms and conditions',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: kPrimaryColor),
                                          ),
                                        );
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
                            ),
                          ))
                      : Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor)),
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
