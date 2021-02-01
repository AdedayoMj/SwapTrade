import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap/constant/colors.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Transaction History"),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
