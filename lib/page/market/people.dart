import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swap/constant/colors.dart';
import 'package:swap/page/market/people_list_items.dart';
import 'package:swap/model/user.dart';
import 'package:swap/services/database.dart';

class People extends StatefulWidget {
  final String query;

  const People({Key key, this.query}) : super(key: key);
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PeopleData>>.value(
      value: DatabaseService().peopleInformationData,
      child: Scaffold(
        body: PeopleDataList(
          query: widget.query,
        ),
      ),
    );
  }
}

class PeopleDataList extends StatefulWidget {
  final String query;

  const PeopleDataList({Key key, this.query}) : super(key: key);
  @override
  _PeopleDataListState createState() => _PeopleDataListState();
}

class _PeopleDataListState extends State<PeopleDataList> {
  @override
  Widget build(BuildContext context) {
    final loadPost = Provider.of<List<PeopleData>>(context) ?? [];
    final myposts = widget.query.isEmpty
        ? loadPost
        : loadPost.where((e) => e.username.contains(widget.query)).toList();

    return Scaffold(
        body: myposts.isNotEmpty
            ? ListView.builder(
                itemCount: myposts.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey),
                      Card(
                        elevation: 0.0,
                        // color: kPrimaryColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  PeopleListData(postData: myposts[index]),
                            ));
                          },
                          leading: myposts[index].urlProfile.isNotEmpty
                              ? CircleAvatar(
                                  radius: 18,
                                  backgroundColor: kPrimaryColor,
                                  backgroundImage:
                                      NetworkImage(myposts[index].urlProfile),
                                )
                              : CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 18,
                                  child: Text(
                                    myposts[index].username[0].toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                myposts[index].username,
                                // searchList[index].currencyName.toUpperCase(),

                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 17,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                      Container(
                          height: 0.5,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey),
                    ],
                  );
                },
              )
            : Center(
                child: Text('You have no offer'),
              ));
  }
}
