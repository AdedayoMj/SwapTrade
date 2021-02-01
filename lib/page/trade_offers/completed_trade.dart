import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:swap/model/post.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';
import 'package:swap/page/my_trade/my_post_preview.dart';
import 'package:swap/page/trade_offers/swap_offer_list.dart';
import 'package:swap/shared/loading.dart';

class CompletedTradeOffers extends StatefulWidget {
  @override
  _CompletedTradeOffersState createState() => _CompletedTradeOffersState();
}

class _CompletedTradeOffersState extends State<CompletedTradeOffers> {
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

    Timer(Duration(milliseconds: 600), () {
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
        .where((e) => e.userId.contains(user.uid) && e.isCompleted != false)
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
                                                        Icons.check_circle,
                                                        size: 40,
                                                        color: Colors.green,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'Completed',
                                                          style: TextStyle(
                                                            // fontSize: 12,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
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
                  : Center(child: Text('No completed trade')),
            )
          : Loading(),
    );
  }
}
