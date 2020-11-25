import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HealthTips extends StatefulWidget {
  @override
  _HealthTipsState createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  String title = 'Health Tips/Guidelines';
  String helper = '';
  bool isLoading=true;
  final _key = UniqueKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ,

        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.call,
            ),
            onPressed: () {
              // launch("tel:0717353774");
            },
          )
        ],
      ),
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: 'https://www.who.int/philippines/news/feature-stories/detail/20-health-tips-for-2020',
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },

          ),
          isLoading ? Center( child: CircularProgressIndicator(),)
              : Stack(),
        ],
      ),
    );
  }
}
