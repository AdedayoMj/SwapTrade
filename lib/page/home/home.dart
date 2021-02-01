import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/user.dart';
import 'package:swap/page/chat/chat.dart';
import 'package:swap/page/my_trade/my_trade.dart';
import 'package:swap/page/market/post_data.dart';
import 'package:swap/page/password-reset/in_app_password_reset.dart';
import 'package:swap/page/profile/profile.dart';
import 'package:swap/page/market/trade_market_post.dart';
import 'package:swap/page/market/people.dart';
import 'package:swap/page/market/trade_offers.dart';

import 'package:swap/services/auth.dart';
import 'package:swap/services/database.dart';
import 'package:swap/shared/loading.dart';
import 'package:swap/page/transactions/transaction_history.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  String queryName = '';
  String queryPeople = '';
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Items'),
    Tab(text: 'People'),
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    return StreamBuilder<SwapUserData>(
        stream: DatabaseService(uid: user.uid).userInformation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SwapUserData userData = snapshot.data;

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  title: Text("Swap Trades"),
                  elevation: 0.0,
                  centerTitle: true,
                  actions: [
                    FadeAnimation(
                      0.6,
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Chat(),
                          ));
                        },
                        icon: Icon(Icons.chat),
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    indicatorColor: Colors.red,
                    tabs: myTabs,
                  ),
                ),
                body: TabBarView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 60,
                              // color: kPrimaryColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    queryName =
                                                        val.toLowerCase();
                                                  });
                                                },
                                                style: TextStyle(fontSize: 15),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "Search",
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: TradeMarketPost(
                            query: queryName,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 60,
                              // color: kPrimaryColor,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    queryPeople =
                                                        val.toLowerCase();
                                                  });
                                                },
                                                style: TextStyle(fontSize: 15),
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintText: "Search",
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.yellow,
                            child: People(
                              query: queryPeople,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                drawer: Drawer(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Column(
                            children: [
                              userData.urlProfile.isEmpty
                                  ? CircleAvatar(
                                      radius: 35.0,
                                      backgroundColor: Colors.white,
                                      child: Text(userData.email[0]))
                                  : CircleAvatar(
                                      radius: 35.0,
                                      backgroundImage:
                                          NetworkImage(userData?.urlProfile),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              FadeAnimation(
                                0.6,
                                Text(
                                  '${userData.username}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                              FadeAnimation(
                                0.6,
                                Text(
                                  userData.email,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.switch_left_sharp,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'My Trades',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyTrades(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.swap_horiz,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Offers Recieved',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TradeOffers(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.money,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Transactions',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransactionHistory(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Change Password',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PasswordResetInApp(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.help,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Help Center',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Profile(),
                              ));
                            },
                          ),
                        ),
                        FadeAnimation(
                          0.6,
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor),
                                    ),
                                  ],
                                ),
                                Row(children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                    color: kPrimaryColor,
                                  ),
                                ])
                              ],
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Container(
                                        color: kPrimaryColor,
                                        child: Center(
                                          child: Icon(
                                            Icons.logout,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      content: Text(
                                        'Do you want to logout?',
                                        style: TextStyle(
                                            fontSize: 15, color: kPrimaryColor),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            await _auth.signOut();
                                            Navigator.pop(context);
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
