import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/auth.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';

class AccountEdit extends StatefulWidget {
  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<AccountEdit> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _lastName;
  String _firstName;
  String _username;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Account"),
        backgroundColor: kPrimaryColor,
      ),
      body: StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: user.uid).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;
            return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
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
                                  enabled: false,
                                  initialValue: userData.email,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      labelText: 'Email',
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
                                  enabled: false,
                                  initialValue: userData.username,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter your Username'
                                      : null,
                                  onChanged: (val) {
                                    setState(() {
                                      _username = val.toLowerCase().trim();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      labelText: 'Username',
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
                                  initialValue: userData.firstName,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter your First name'
                                      : null,
                                  onChanged: (val) {
                                    setState(() {
                                      _firstName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "First Name",
                                      labelText: 'First Name',
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
                                  initialValue: userData.lastName,
                                  validator: (val) => val.isEmpty
                                      ? 'Enter your Last Name'
                                      : null,
                                  onChanged: (val) {
                                    setState(() {
                                      _lastName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Last Name",
                                      labelText: 'Last Name',
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            dynamic verifyUniqueUsername = await _auth
                                .usernameCheck(_username.toLowerCase());
                            if (verifyUniqueUsername == true) {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                _firstName ?? userData.firstName,
                                _lastName ?? userData.lastName,
                                _username ?? userData.username,
                                userData.email,
                                userData.urlProfile,
                                userData.address,
                                userData.city,
                                userData.state,
                                userData.country,
                                userData.phoneNumber,
                                userData.starRatings,
                                userData.createdAt,
                              );
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Username',
                                        style: TextStyle(color: kPrimaryColor),
                                      ),
                                      content: Text(
                                        'Username is already taken, Please try again',
                                        style: TextStyle(
                                            fontSize: 15, color: kPrimaryColor),
                                      ),
                                    );
                                  });
                            }
                          }
                        },
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: kPrimaryColor,
                          ),
                          child: Center(
                            child: Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
