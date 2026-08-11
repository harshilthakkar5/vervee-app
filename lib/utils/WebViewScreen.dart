
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../presentation/screen/AvatarCustomizationScreen.dart';

//import 'HomeScreen.dart'; // color constants ke liye

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    this.title = 'Subscription Portal',
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  // ↓ Sirf yahan se neeche tak badla hai
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgDark,
      appBar: AppBar(
        backgroundColor: kBgCard,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: kPurpleLight, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: kTextPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        // bottom: _isLoading
        //     ? const PreferredSize(
        //   preferredSize: Size.fromHeight(2),
        //   child: LinearProgressIndicator(
        //     color: kPurpleLight,
        //     backgroundColor: kBgDeep,
        //     minHeight: 2,
        //   ),
        // )
           // : null,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: kBgDark,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: kPurpleLight,
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading portal...',
                      style: TextStyle(
                        color: kTextMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}