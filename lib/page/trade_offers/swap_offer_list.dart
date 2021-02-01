import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:swap/animation/fade_adnimation.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/model/offer.dart';
import 'package:swap/model/post.dart';
import 'package:swap/page/chat/chat.dart';
import 'package:swap/services/database.dart';
import 'package:swap/widget/post_profile_pic.dart';

class SwapOfferList extends StatefulWidget {
  final PostItem post;

  const SwapOfferList({Key key, this.post}) : super(key: key);
  @override
  _SwapOfferListState createState() => _SwapOfferListState();
}

class _SwapOfferListState extends State<SwapOfferList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 40,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        Expanded(
          child: StreamProvider<List<OfferItem>>.value(
            value: DatabaseService().swapOfferItemPost,
            child: MyOffers(
                swapOfferId: widget.post.documentId,
                isComplete: widget.post.isCompleted),
          ),
        ),
      ],
    );
  }
}

class MyOffers extends StatefulWidget {
  final String swapOfferId;
  final bool isComplete;
  const MyOffers({Key key, this.swapOfferId, this.isComplete})
      : super(key: key);
  @override
  _MyOffersState createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  @override
  Widget build(BuildContext context) {
    final loadPost = Provider.of<List<OfferItem>>(context) ?? [];
    final myposts = loadPost
        .where((e) => e.tadeSwapId.contains(widget.swapOfferId))
        .toList();

    return Scaffold(
        body: myposts.isNotEmpty
            ? ListView.builder(
                itemCount: myposts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Card(
                          elevation: 0.0,
                          color: kPrimaryColor,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OfferPostPreview(
                                    postData: myposts[index],
                                    isComplete: widget.isComplete),
                              ));
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(myposts[index].itemImages[0]),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  myposts[index].itemName,
                                  // searchList[index].currencyName.toUpperCase(),

                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  myposts[index].username,
                                  // searchList[index].username,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white10),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: Text('You have no offer'),
              ));
  }
}

class OfferPostPreview extends StatefulWidget {
  final OfferItem postData;
  final bool isComplete;

  const OfferPostPreview({Key key, this.postData, this.isComplete})
      : super(key: key);
  @override
  _OfferPostPreviewState createState() => _OfferPostPreviewState();
}

class _OfferPostPreviewState extends State<OfferPostPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: FadeAnimation(
          0.5,
          Text(widget.postData.itemName),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.postData.itemImages[0],
                    child: Container(
                      width: 350,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        image: DecorationImage(
                          image: NetworkImage(widget.postData.itemImages[0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      /* add child content here */
                      child: SliderOfferPic(
                        postData: widget.postData,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  ' ${widget.postData.itemName}',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 5),
                    child: Text(
                      'Description:',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 250,
                    minWidth: 350,
                    minHeight: 20,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.postData.description,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 15),
                child: Row(
                  children: [
                    PostProfilePicture(userIdPost: widget.postData.userId),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.postData.username,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.isComplete != true
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 35.0,
                        right: 35.0,
                      ),
                      child: FlatButton(
                        color: kPrimaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Chat(),
                          ));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Text(''),
            ],
          ),
        ),
      ),
    );
  }
}

class SliderOfferPic extends StatefulWidget {
  final OfferItem postData;

  const SliderOfferPic({Key key, this.postData}) : super(key: key);
  @override
  _SliderOfferPicState createState() => _SliderOfferPicState();
}

class _SliderOfferPicState extends State<SliderOfferPic> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // color: Colors.red,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            image: DecorationImage(
              image: NetworkImage(widget.postData.itemImages[index]),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      autoplay: false,
      itemCount: widget.postData.itemImages.length,
      pagination: SwiperPagination(),
      control: SwiperControl(),
    );
  }
}
