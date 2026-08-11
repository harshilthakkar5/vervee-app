
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleWebViewLogin extends StatefulWidget {
  const GoogleWebViewLogin({super.key});

  @override
  State<GoogleWebViewLogin> createState() => _GoogleWebViewLoginState();
}

class _GoogleWebViewLoginState extends State<GoogleWebViewLogin> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)

    // ── YE LINE ADD KARO ← Fix for Error 403
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/120.0.6099.144 Mobile Safari/537.36'
      )

    // ── Cookies clear karo taaki har baar fresh Google login aaye
      ..clearCache()
      ..clearLocalStorage()

      ..setNavigationDelegate(NavigationDelegate(

        // Page load hona shuru hua
        onPageStarted: (url) {
          setState(() => _isLoading = true);

          // ── Token wala URL pakdo
          // Format: /google-auth?userid=105&name=...&token=eyJ...
          if (url.contains('google-auth') && url.contains('token=')) {
            final uri = Uri.parse(url);

            final token  = uri.queryParameters['token'];
            final name   = uri.queryParameters['name'];
            final userId = uri.queryParameters['userid'];

            if (token != null && token.isNotEmpty) {
              // ✅ Token mil gaya — screen band karo aur data wapas bhejo
              Navigator.of(context).pop({
                'token':  token,
                'name':   name ?? '',
                'userId': userId ?? '',
              });
            }
          }
        },

        onPageFinished: (_) => setState(() => _isLoading = false),

        onWebResourceError: (error) {
          debugPrint('WebView Error: ${error.description}');
        },
      ))

    // ── Verve Academy ka Google Login URL load karo
      ..loadRequest(Uri.parse(
        'https://verve-be-rla6j.ondigitalocean.app/v1/auth/google/login',
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E0245),
        title: const Text(
          'Sign in with Google',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(null), // Cancel
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // ── Loading indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7C3AED),
              ),
            ),
        ],
      ),
    );
  }
}