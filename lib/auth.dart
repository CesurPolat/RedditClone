import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({ Key? key }) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override

  var _PageController = new PageController();
  var _usernameController = new TextEditingController();
  var _passwordController = new TextEditingController();

  bool obscure = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
        controller: _PageController,
        children: [
          Padding(padding: EdgeInsets.all(10.0),child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Log in to Reddit",style: TextStyle(fontWeight: FontWeight.bold),),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  label: Text("Username"),
                ),
                ),
              TextField(
                controller: _passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  label: Text("Password"),
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      obscure=!obscure;
                    });
                    }, icon: Icon(obscure ? Icons.visibility : Icons.visibility_off)),
                    
                ),
              ),
              Row(children: [
                TextButton(onPressed: (){_PageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);}, child: Text("SIGN UP")),
                Spacer(),
                Text("FORGOT PASSWORD")
              ],),
              Spacer(),
              Divider(),
              ElevatedButton(onPressed: (){}, child: Text("LOG IN"),style: ElevatedButton.styleFrom(),)
            ],
          ),),
          Padding(padding: EdgeInsets.all(10.0),child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Log in to Reddit",style: TextStyle(fontWeight: FontWeight.bold),),
              TextField(),
              TextField(),
              Row(children: [
                TextButton(onPressed: (){_PageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeIn);}, child: Text("SIGN UP")),
                Spacer(),
                Text("FORGOT PASSWORD")
              ],),
              Spacer(),
              Divider(),
              ElevatedButton(onPressed: (){}, child: Text("LOG IN"),style: ElevatedButton.styleFrom(),)
            ],
          ),),
        ],
      ),
    );
  }
}
