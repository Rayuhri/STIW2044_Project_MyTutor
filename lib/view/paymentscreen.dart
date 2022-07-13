import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/constant.dart';
import 'package:mytutor/model/user.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;
  const PaymentScreen({
    Key? key,
    required this.user,
    required this.totalpayable,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 11, 135, 160),
        title: Text('Payment',
            style: GoogleFonts.pacifico(
                fontSize: 31,
                color: Colors.white,
                fontWeight: FontWeight.normal)),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              initialUrl: CONSTANTS.server +
                  '/mytutor/php/payment.php?email=' +
                  widget.user.email.toString() +
                  '&mobile=' +
                  widget.user.phone.toString() +
                  '&name=' +
                  widget.user.name.toString() +
                  '&amount=' +
                  widget.totalpayable.toString(),
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          ),
        ],
      ),
    );
  }
}
