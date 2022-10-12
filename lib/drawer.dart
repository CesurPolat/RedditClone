import 'package:flutter/material.dart';
import 'package:reddit_clone/Auth.dart';

class drawer extends StatelessWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ElevatedButton.icon(
        icon: Icon(Icons.switch_account),
        label: Text("Sign up / Log in"),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Auth()));
        },
      ),
    );
  }
}
