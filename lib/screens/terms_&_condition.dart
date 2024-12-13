import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndCondition extends StatefulWidget {
  final String? title;

  TermsAndCondition({this.title});

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

//  WebViewController w1;

  String filepath = 'asset/terms_and_condition_french.html';
  WebViewController? webController;

  OverlayEntry? entry;
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
    if (entry != null) entry!.remove();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(
          Uri.parse(widget.title ==
                  StringLocalization.of(context)
                      .getText(StringLocalization.termsAndConditions)
              ? Constants.termAndConditionURL
              : Constants.privacyPolicyURL),
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (value) {
              // entry = showOverlay(context);
              isLoading = true;
              setState(() {});
            },
            onPageFinished: (value) {
              // entry.remove();
              isLoading = false;
              setState(() {});
              webController!
                  .runJavaScript("javascript:(function() { " +
                      "document.getElementsByClassName('mkdf-mobile-header')[0].style.visibility='hidden';" +
                      "document.getElementsByClassName('mkdf-page-title entry-title')[0].style.fontSize='x-large';" +
                      "})()")
                  .then(
                      (value) => debugPrint('Page finished loading Javascript'))
                  .catchError((onError) => debugPrint('$onError'));
            },
          ),
        );
    });
    super.initState();
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
                  : HexColor.fromHex("#384341").withOpacity(0.2),
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
              key: Key('termsBackButton'),
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      "asset/dark_leftArrow.png",
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      "asset/leftArrow.png",
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              widget.title ??
                  StringLocalization.of(context)
                      .getText(StringLocalization.termsAndConditions),
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  color: HexColor.fromHex("62CBC9"),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            centerTitle: true,
          ),
        ),
      ),

      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Stack(
        children: [
          webController != null
              ? WebViewWidget(
                  controller: webController!,
                )
              : Container(),
          Visibility(
            visible: isLoading,
            child: showIndicator(context),
          ),
        ],
      ),
    );
  }

  loadLocalHTML() async {
    String fileHtmlContents = await rootBundle.loadString(filepath);
    webController!.loadRequest(Uri.dataFromString(fileHtmlContents,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

//  }

  OverlayEntry showOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: CircularProgressIndicator()),
          color: Colors.black26,
        ),
      ),
    );
    overlayState!.insert(overlayEntry);
    return overlayEntry;
  }

  Widget showIndicator(context) {
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
