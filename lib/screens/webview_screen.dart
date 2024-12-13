import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home/home_screeen.dart';

class WebViewScreen extends StatefulWidget {
  final String title;
  final bool? isFromHelp;
  final String? url;

  WebViewScreen({Key? key, required this.title, this.isFromHelp, this.url}) : super(key: key);

  @override
  _WebViewScreen createState() => _WebViewScreen();
}

class _WebViewScreen extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String filepath = 'asset/terms_and_condition_french.html';
  WebViewController? webController;

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    filepath = StringLocalization.of(context)
        .getText(StringLocalization.termsAndConditionPageUrl);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {

    super.initState();
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.url ?? stringLocalization.getText(getUrl(widget.title))),
      ) ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (value) {
          },
          onPageFinished: (value) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.5)
                      : HexColor.fromHex('#384341').withOpacity(0.2),
                  offset: Offset(0, 2.0),
                  blurRadius: 4.0,
                )
              ]),
              child: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                leading: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Theme.of(context).brightness == Brightness.dark
                      ? Image.asset(
                    'asset/dark_leftArrow.png',
                    width: 13,
                    height: 22,
                  )
                      : Image.asset(
                    'asset/leftArrow.png',
                    width: 13,
                    height: 22,
                  ),
                ),
                title: Text(
                  widget.isFromHelp != null && widget.isFromHelp! ? stringLocalization.getText(getTitle()) : stringLocalization.getText(widget.title),
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 18,
                      color: HexColor.fromHex('62CBC9'),
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
                centerTitle: true,
              ),
            )),

        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Stack(
          children: [
            webController != null
                ? WebViewWidget(
              controller: webController!,
            )
                : Container(),
            isLoading ? showIndicator(context)
                : Stack(),
          ],
        ));
  }

  String getUrl(String title){
    switch (title) {
      case StringLocalization.bMI :
        return StringLocalization.weightUrl;
      case StringLocalization.bloodPressure :
        return StringLocalization.bpUrl;
      case StringLocalization.sleep :
        return StringLocalization.sleepUrl;
      case StringLocalization.hr :
        return StringLocalization.hrUrl;
      default :
        return '';
    }
  }

  String getTitle(){
    switch (widget.title) {
      case StringLocalization.bMI :
        return StringLocalization.bMI;
      case StringLocalization.bloodPressure :
        return StringLocalization.bloodPressure;
      case StringLocalization.sleep :
        return StringLocalization.sleep;
      case StringLocalization.hr :
        return StringLocalization.hr;
      default :
        return '';
    }
  }


  Widget showIndicator(context){
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black26,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
