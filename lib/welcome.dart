import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_clone/redditVideo.dart';
import 'package:reddit_clone/searchBar.dart';
import 'drawer.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Future getPop() async {
    var data = jsonDecode((await http.get(Uri.parse(
            "https://gateway.reddit.com/desktopapi/v1/subreddits/popular?geo_filter=TR&sort=hot&layout=card&forceGeopopular=true")))
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
          backgroundColor: const Color(0x00dae0e6), //dae0e6
          drawer: drawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: TextField(
              readOnly: true,
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SearchBar()));
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey.shade100,
                )),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey.shade100,
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.grey.shade100,
                )),
                hintText: 'Search',
                prefixIcon: Icon(Icons.search,color: Colors.black,),
                fillColor: Colors.grey.shade100,
                filled: true,
                isDense: true,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.monetization_on_rounded,
                    color: Colors.black,
                  ))
            ],
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
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
                          var post = snapshot.data["posts"]
                              [snapshot.data["postIds"][index]];
                          var subreddit = snapshot.data["subreddits"]
                              [post["belongsTo"]["id"]];

                          if (post["belongsTo"]["type"] == "subreddit") {
                            return Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(
                                top: 5.0,
                                bottom: 5.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              subreddit["communityIcon"] ??
                                                  subreddit["icon"]["url"]),
                                        ),
                                      ), //Image.network(subreddit["communityIcon"] ?? subreddit["icon"]["url"],scale: 4,)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subreddit["displayText"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("Posted by u/" +
                                              post["author"] +
                                              " • " +
                                              getAgeFromEpoch(post["created"])
                                                  .toString()),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(post["title"]),
                                  if (post["media"]["type"] == "image")
                                    Image.network(post["media"]["content"]),
                                  if (post["media"]["type"] == "video")
                                    redditVideo(url: post["media"]["hlsUrl"]),
                                ],
                              ),
                            );
                          } else {
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
