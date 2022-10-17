import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var _controller = new TextEditingController();
  var searchRes = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: TextField(
          controller: _controller,
          onChanged: (e) async {
            searchRes = jsonDecode(
                (await http.post(Uri.parse("https://gql.reddit.com/"),
                        headers: {
                          "Authorization":
                              "Bearer -mLW-eIOLL6ocQUyFOLy-q-5_TOGxPQ",
                          "Content-Type": "application/json"
                        },
                        body: jsonEncode({
                          "id": "26f251bf8753",
                          "variables": {
                            "productSurface": "web2x",
                            "query": e,
                            "searchInput": {"isNsfwIncluded": true}
                          }
                        }))) //TODO:Nsfw Settings
                    .body)["data"]["search"]["typeahead"];

            setState(() {});
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
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                _controller.text = "";
              },
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            isDense: true,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: searchRes.length,
        itemBuilder: (context, index) {
          return Padding(padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(right:5.0),child: CircleAvatar(backgroundImage: NetworkImage(searchRes[index]["styles"]["icon"]!=null ? searchRes[index]["styles"]["icon"] : searchRes[index]["styles"]["legacyIcon"]!=null ? searchRes[index]["styles"]["legacyIcon"]["url"] : "https://www.redditstatic.com/desktop2x/img/favicon/android-icon-192x192.png"),),),//TODO:Null Reddit Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(searchRes[index]["name"],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0),),
                  Text(searchRes[index]["__typename"]=="Subreddit"?searchRes[index]["subscribersCount"].toString()+" members":searchRes[index]["redditorInfo"]["karma"]["total"].toString()+" karma"),
                ],
              )
            ],
          ),);
        },
      ),
    );
  }
}
