import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';

class Login extends StatefulWidget {
  static String tag = 'login';
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  String token = "";
  TextEditingController getUser = new TextEditingController();
  TextEditingController getPass = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: getUser,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: getPass,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          _goLogin();
        },
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton
          ],
        ),
      ),
    );
  }

  Future _goLogin() async {
    var bodyReq = <String, String>{
            'username' : getUser.text,
            'password' : getPass.text
        };
    var headerReq = <String, String>{
          "Content-type": "application/x-www-form-urlencoded"
      };
    try {
      final response = await http.post(Uri.parse("http://192.168.1.13/siacloud/mobile/api/login"),
                      headers: headerReq,
                      body: bodyReq,
      );
      
      final data = jsonDecode(response.body);
      var responseSystem = data['applicationSystem'];
      if (response.statusCode == 200) {
        if (responseSystem['code'] == 0){
          setState(() {
            token = responseSystem['token'];
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Login Berhasil"),
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => Home(
                username: getUser.text,
                realToken: token
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseSystem['message']),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseSystem['message']?responseSystem['message']:'Login Gagal'),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}