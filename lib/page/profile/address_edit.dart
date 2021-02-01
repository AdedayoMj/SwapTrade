import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';

class AddressEdit extends StatefulWidget {
  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  final _formKey = GlobalKey<FormState>();
  String _address;
  // String _state;
  // String _city;
  String countryValue;
  String stateValue;
  String cityValue;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Address"),
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
                                  initialValue: userData.address,
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an Address' : null,
                                  onChanged: (val) {
                                    setState(() {
                                      _address = val;
                                    });
                                  },
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Address',
                                      hintText: "Address",
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      SelectState(
                                        onCountryChanged: (value) {
                                          setState(() {
                                            countryValue = value;
                                          });
                                        },
                                        onStateChanged: (value) {
                                          setState(() {
                                            stateValue = value;
                                          });
                                        },
                                        onCityChanged: (value) {
                                          setState(() {
                                            cityValue = value;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
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
                            await DatabaseService(uid: user.uid).updateUserData(
                              userData.firstName,
                              userData.lastName,
                              userData.username,
                              userData.email,
                              userData.urlProfile,
                              _address ?? userData.address,
                              stateValue ?? userData.city,
                              cityValue ?? userData.state,
                              countryValue ?? userData.country,
                              userData.phoneNumber,
                              userData.starRatings,
                              userData.createdAt,
                            );
                            Navigator.pop(context);
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
