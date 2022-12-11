import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MethodChannel _oneChannel = MethodChannel('one_page');
  final MethodChannel _towChannel = MethodChannel('tow_page');
  final BasicMessageChannel _messageChannel =
      BasicMessageChannel('messageChannel', StandardMessageCodec());
  String _pageIndex;

  @override
  void initState() {
    super.initState();

    _messageChannel.setMessageHandler((message) {
      print('收到来自iOS的:$message');
      return null;
    });

    _oneChannel.setMethodCallHandler((call) {
      setState(() {
        _pageIndex = call.method;
      });
      return null;
    });
    _towChannel.setMethodCallHandler((call) {
      setState(() {
        _pageIndex = call.method;
      });
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _rootPage(_pageIndex),
    );
  }

  Widget _rootPage(String pageIndex) {
    switch (pageIndex) {
      case 'one':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _oneChannel.invokeMapMethod('exit');
                },
                child: Text(pageIndex),
              ),
              TextField(
                onChanged: (String str) {
                  _messageChannel.send(str);
                },
              )
            ],
          ),
        );
      case 'tow':
        return Scaffold(
          appBar: AppBar(
            title: Text(pageIndex),
          ),
          body: Center(
              child: RaisedButton(
            onPressed: () {
              _towChannel.invokeMapMethod('exit');
            },
            child: Text(pageIndex),
          )),
        );
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text("default"),
          ),
          body: Center(
              child: RaisedButton(
            onPressed: () {
              MethodChannel('default_page').invokeMapMethod('exit');
            },
            child: Text(pageIndex),
          )),
        );
    }
  }
}
