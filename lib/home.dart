import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';

class Home extends StatefulWidget {
  static String tag = 'home-tag';
  final String username;
  final String realToken;

  const Home({Key? key, required this.username, required this.realToken})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState(username, realToken);
}

class _HomeState extends State<Home> {
  final String username;
  final String realToken;

  _HomeState(this.username, this.realToken);

  List _get = [];
  // token berasal dari realToken yang sudah di encode melalui framework web service
  String token =
      "abfc2e0db113ef82afc493736c03ee9a21b2f297a574ad426a1f49a78ed6e628538883045c90d71099e2667c666add2872fe138e42100e21421c6b4567fcf023";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      var bodyReq = <String, String>{'token': token};
      var headerReq = <String, String>{
        "Content-type": "application/x-www-form-urlencoded"
      };
      final response = await http.post(
          Uri.parse("http://192.168.1.13/siacloud/mobile/api/announcement"),
          headers: headerReq,
          body: bodyReq);
      // untuk cek data
      final data = jsonDecode(response.body);

      var responseSystem = data['applicationSystem'];
      var berita = data['data'];
      if (response.statusCode == 200) {
        if (responseSystem['code'] == 0) {
          setState(() {
            _get = berita['data'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseSystem['message']),
          ));
        }
        // _get = data['articles'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseSystem['message']
              ? responseSystem['message']
              : 'gagal Get Data'),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/logo.png'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        "Welcome $username",
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final listData = SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RefreshIndicator(
                  onRefresh: _getData,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _get.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          '${_get[index]['title']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          '${_get[index]['title']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => Detail(
                                url: null,
                                title: _get[index]['title'],
                                content: _get[index]['content'],
                                urlToImage: null,
                                author: _get[index]['user']['name'],
                                publishedAt: _get[index]['createdAt'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ))
            ]));

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.blue,
        Colors.lightBlueAccent,
      ])),
      child: Column(
        children: <Widget>[photo, welcome, listData],
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: <Widget>[body])));
  }
}
