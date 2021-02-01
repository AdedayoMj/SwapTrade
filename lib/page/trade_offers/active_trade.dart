import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/post.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/page/my_trade/my_post_preview.dart';
import 'package:swap/page/trade_offers/swap_offer_list.dart';
import 'package:swap/shared/loading.dart';

class ActiveTradeOffers extends StatefulWidget {
  @override
  _ActiveTradeOffersState createState() => _ActiveTradeOffersState();
}

class _ActiveTradeOffersState extends State<ActiveTradeOffers> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostItem>>.value(
      value: DatabaseService().tradeItemPost,
      child: TradeOfferList(),
    );
  }
}

class TradeOfferList extends StatefulWidget {
  @override
  _TradeOfferListState createState() => _TradeOfferListState();
}

class _TradeOfferListState extends State<TradeOfferList> {
  bool loading;
  @override
  void initState() {
    super.initState();
    loading = true;

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomeUser>(context);
    final loadPost = Provider.of<List<PostItem>>(context) ?? [];
    final myposts = loadPost
        .where((e) => e.userId.contains(user.uid) && e.isCompleted != true)
        .toList();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: loading == false
          ? Container(
              child: myposts != null
                  ? Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ListView.builder(
                              itemCount: myposts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 8.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          enableDrag: false,
                                                          isDismissible: false,
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          builder: (ctx) {
                                                            return Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.80,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                // border:Border(bottom: BorderSide(color: Colors.white)),
                                                                borderRadius:
                                                                    new BorderRadius
                                                                        .only(
                                                                  topLeft:
                                                                      const Radius
                                                                              .circular(
                                                                          25.0),
                                                                  topRight:
                                                                      const Radius
                                                                              .circular(
                                                                          25.0),
                                                                ),
                                                              ),
                                                              child:
                                                                  MyPostPreview(
                                                                postData:
                                                                    myposts[
                                                                        index],
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      height: 120,
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              myposts[index]
                                                                  .itemImages[0]),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.swap_horiz,
                                                          size: 50,
                                                          color: Colors.red,
                                                        ),
                                                        Container(
                                                            child: Text(
                                                          'Active',
                                                          style: TextStyle(
                                                            // fontSize: 12,
                                                            color: Colors.green,
                                                          ),
                                                        )),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          height: 33,
                                                          child: RaisedButton(
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Text(
                                                                        'Swap',
                                                                        style: TextStyle(
                                                                            color:
                                                                                kPrimaryColor),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        'Is your swap trade completed?',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                kPrimaryColor),
                                                                      ),
                                                                      actions: [
                                                                        FlatButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('No'),
                                                                        ),
                                                                        FlatButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await DatabaseService().updatePostItemToFirebase(
                                                                              userId: myposts[index].userId,
                                                                              username: myposts[index].username,
                                                                              urlProfile: myposts[index].urlProfile,
                                                                              city: myposts[index].city,
                                                                              state: myposts[index].state,
                                                                              itemName: myposts[index].itemName,
                                                                              itemImages: myposts[index].itemImages,
                                                                              description: myposts[index].description,
                                                                              itemExtimatedPrice: myposts[index].itemExtimatedPrice,
                                                                              postedAt: myposts[index].postedAt,
                                                                              documentId: myposts[index].documentId,
                                                                              isCompleted: true,
                                                                            );
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Yes'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Text(
                                                              'Complete',
                                                              style: TextStyle(
                                                                // fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      enableDrag: false,
                                                      isDismissible: false,
                                                      context: context,
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (ctx) {
                                                        return Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.80,
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors.white,
                                                            // border:Border(bottom: BorderSide(color: Colors.white)),
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .only(
                                                              topLeft: const Radius
                                                                      .circular(
                                                                  25.0),
                                                              topRight: const Radius
                                                                      .circular(
                                                                  25.0),
                                                            ),
                                                          ),
                                                          child: SwapOfferList(
                                                            post:
                                                                myposts[index],
                                                          ),
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  height: 120,
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.grey)),
                                                  child: Center(
                                                    child: Text(
                                                      'VIEW OFFERS',
                                                      style: TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Center(child: Text('No active trade')),
            )
          : Loading(),
    );
  }
}
