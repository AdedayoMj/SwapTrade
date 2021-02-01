import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/page/market/post_data.dart';
import 'package:swap/services/database.dart';
import 'package:swap/page/market/post_data_grid_list.dart';

class TradeMarketPost extends StatefulWidget {
  final String query;

  const TradeMarketPost({Key key, this.query}) : super(key: key);
  @override
  _TradeMarketPostState createState() => _TradeMarketPostState();
}

class _TradeMarketPostState extends State<TradeMarketPost> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostItem>>.value(
      value: DatabaseService().tradeItemPost,
      child: Scaffold(
        body: PostDataList(
          query: widget.query,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FadeAnimation(
          0.6,
          FloatingActionButton.extended(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PoatDataPage(),
              ));
            },
            label: Text('Upload'),
            icon: Icon(Icons.add),
            backgroundColor: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}
