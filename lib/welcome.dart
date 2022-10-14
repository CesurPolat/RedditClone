import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Future getPop() async {
    var data=jsonDecode(
        (await http.get(Uri.parse("https://gateway.reddit.com/desktopapi/v1/subreddits/popular?geo_filter=TR&sort=hot&layout=card&forceGeopopular=true")))
            .body);

    return data;
    /* return (jsonDecode(
        (await http.get(Uri.parse("https://www.reddit.com/hot.json?geo_filter=TR")))
            .body)["data"]["children"]); */
  }

  //TODO:Create a lib for funcs
  getAgeFromEpoch(int timestamp) {
    int deltaTime = (DateTime.now().millisecondsSinceEpoch ~/ 1) - timestamp;
    var deltaTimestamp = DateTime.fromMillisecondsSinceEpoch(deltaTime * 1);
    if (deltaTimestamp.year - 1970 > 0) {
      return deltaTimestamp.year.toString() + " years ago";
    } else if (deltaTimestamp.month - 1 > 0) {
      return deltaTimestamp.month.toString() + " months ago";
    } else if (deltaTimestamp.day - 1 > 0) {
      return deltaTimestamp.day.toString() + " days ago";
    } else if (deltaTimestamp.hour - 2 > 0) {
      return deltaTimestamp.hour.toString() + " hours ago";
    } else if (deltaTimestamp.minute >= 0) {
      return deltaTimestamp.minute.toString() + " minutes ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: drawer(),
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.person),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Popular",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              FutureBuilder(
                future: getPop(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text("no data");
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data["postIds"].length,
                        itemBuilder: (context, index) {
                          if(snapshot.data["posts"][snapshot.data["postIds"][index]]["belongsTo"]["type"]=="subreddit"){
                            return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(snapshot.data["subreddits"][snapshot.data["posts"][snapshot.data["postIds"][index]]["belongsTo"]["id"]]["displayText"]),//snapshot.data["posts"][snapshot.data["postIds"][index]]["belongsTo"]["id"]
                                    Text("Posted by u/" +
                                        snapshot.data["posts"][snapshot.data["postIds"][index]]["author"] +
                                        " • " +
                                        getAgeFromEpoch(snapshot.data["posts"][snapshot.data["postIds"][index]]["created"])
                                            .toString()),
                                  ],
                                ),
                                Text(snapshot.data["posts"][snapshot.data["postIds"][index]]["title"]),
                              ],
                            ),
                          );
                          }else{
                            return Text("Rek");
                          }
                          
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
