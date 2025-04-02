import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:ui' as ui;
import 'dart:html';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(
            "https://www.google.com/maps?q=Daffodil+International+University&output=embed"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Information"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "\ud83d\udccd University Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: kIsWeb ? _buildWebViewForWeb() : WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }

  // WebView alternative for Web (iframe)
  Widget _buildWebViewForWeb() {
    const String mapUrl =
        "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3558.099701349997!2d90.31758427513486!3d23.87690048390843!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3755b8ada2664e21%3A0x3c872fd17bc11ddb!2sDaffodil%20International%20University!5e1!3m2!1sen!2sbd!4v1743315021357!5m2!1sen!2sbd";

    // Register an iframe for Web
    ui.platformViewRegistry.registerViewFactory(
      'map-iframe',
      (int viewId) => IFrameElement()
        ..src = mapUrl
        ..style.border = 'none'
        ..width = '100%'
        ..height = '100%',
    );

    return const HtmlElementView(viewType: 'map-iframe');
  }
}
