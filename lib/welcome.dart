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

  Future<List<dynamic>> getPop() async{

    return( jsonDecode((await http.get(Uri.parse("https://www.reddit.com/new.json"))).body)["data"]["children"]);
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
                Tab(text: "Home",),
                Tab(text: "Popular",),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              FutureBuilder(
                future: getPop(),
                builder: (context,AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Text("no data");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        return Text(snapshot.data[index]["data"]["title"]);
                      }
                      );
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
