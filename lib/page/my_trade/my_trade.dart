import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/page/my_trade/TadeMade.dart';
import 'package:swap/page/my_trade/my_offers.dart';
import 'package:swap/page/my_trade/my_post.dart';

class MyTrades extends StatefulWidget {
  @override
  _MyTradesState createState() => _MyTradesState();
}

class _MyTradesState extends State<MyTrades> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'My Post'),
    Tab(text: 'My Offers'),
    Tab(text: 'TradeMade'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Trades'),
          backgroundColor: kPrimaryColor,
          bottom: TabBar(
            indicatorColor: Colors.red,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(children: [
          MyPost(),
          MyOffers(),
          TadeMade(),
        ]),
      ),
    );
  }
}
