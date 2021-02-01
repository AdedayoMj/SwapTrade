import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/page/trade_offers/active_trade.dart';
import 'package:swap/page/trade_offers/completed_trade.dart';

class TradeOffers extends StatefulWidget {
  @override
  _TradeOffersState createState() => _TradeOffersState();
}

class _TradeOffersState extends State<TradeOffers> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Active'),
    Tab(text: 'Completed'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(" Trade Offers"),
          elevation: 0.0,
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.red,
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: [
            ActiveTradeOffers(),
            CompletedTradeOffers(),
          ],
        ),
      ),
    );
  }
}
