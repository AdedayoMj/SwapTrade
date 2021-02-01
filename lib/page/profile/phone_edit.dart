import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/services/auth.dart';
import 'package:swap/widget/numeric_pad.dart';
import 'package:swap/page/profile/verify_phone.dart';

class PhoneEdit extends StatefulWidget {
  @override
  _PhoneEditState createState() => _PhoneEditState();
}

class _PhoneEditState extends State<PhoneEdit> {
  String phoneNumber = "";
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Phone"),
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 130,
                    child: Image.asset('assets/images/holding-phone.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 64),
                    child: Text(
                      "You'll receive a 4 digit code to verify next.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 230,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Enter your phone",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          phoneNumber,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (phoneNumber.isNotEmpty) {
                          if (phoneNumber.length == 11) {
                            dynamic result = await _auth.checkPhoneInFirebase(
                                phoneNumber: phoneNumber);

                            if (result == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        VerifyPhone(phoneNumber: phoneNumber)),
                              );
                              // setState(() {
                              //   phoneNumber = '';
                              // });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Phone number',
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                      content: Text(
                                        result,
                                        style: TextStyle(
                                            fontSize: 15, color: kPrimaryColor),
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
                                      'Phone number',
                                      style: TextStyle(color: kPrimaryColor),
                                    ),
                                    content: Text(
                                      'Incorrect phone number format',
                                      style: TextStyle(
                                          fontSize: 15, color: kPrimaryColor),
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
                                    'Phone number',
                                    style: TextStyle(color: kPrimaryColor),
                                  ),
                                  content: Text(
                                    'Please provide a phone number',
                                    style: TextStyle(
                                        fontSize: 15, color: kPrimaryColor),
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Send OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          NumericPad(
            onNumberSelected: (value) {
              setState(() {
                if (value != -1) {
                  phoneNumber = phoneNumber + value.toString();
                } else {
                  phoneNumber =
                      phoneNumber.substring(0, phoneNumber.length - 1);
                }
              });
            },
          ),
        ],
      )),
    );
  }
}
