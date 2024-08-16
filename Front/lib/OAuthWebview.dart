import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:front/socialDone.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher 패키지 추가

class OAuthWebView extends StatefulWidget {
  final String oauthProvider; // 'kakao' 또는 'google'

  OAuthWebView({required this.oauthProvider});

  @override
  _OAuthWebViewState createState() => _OAuthWebViewState();
}

class _OAuthWebViewState extends State<OAuthWebView> {
  late final WebViewController _controller;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    initDeepLinks(); // Custom URL Scheme 처리

    // 플랫폼별 설정
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) async {
            // Google OAuth URL을 감지하면 기본 브라우저로 리디렉션
            if (request.url.startsWith('https://accounts.google.com/o/oauth2/v2/auth')) {
              // 기본 브라우저에서 URL 열기
              await _launchURL(request.url);
              return NavigationDecision.prevent; // WebView에서 로드하지 않도록 막음
            }

            // 서버에서 Custom URL Scheme으로 리디렉션하도록 설정
            if (request.url.startsWith('https://9cc8-106-252-44-73.ngrok-free.app/auth/google/callback')) {
              final Uri uri = Uri.parse(request.url);
              final String? code = uri.queryParameters['code'];

              if (code != null) {
                // 서버가 Custom URL Scheme으로 리디렉션
                await _launchURL('myapp://oauth2callback?code=$code');
                return NavigationDecision.prevent;
              } else {
                print('Error: No code found in redirect URL');
                return NavigationDecision.navigate;
              }
            }

            // 추가: /로 리디렉션될 경우 Custom URL Scheme으로 리디렉션
            if (request.url.startsWith('https://9cc8-106-252-44-73.ngrok-free.app/')) {
              final Uri uri = Uri.parse(request.url);
              final String? code = uri.queryParameters['code'];

              if (code != null) {
                await _launchURL('myapp://oauth2callback?code=$code');
                return NavigationDecision.prevent;
              } else {
                print('Error: No code found in redirect URL');
                return NavigationDecision.navigate;
              }
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    // Android 플랫폼에서 추가 설정
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    // 초기 URL 설정
    if (widget.oauthProvider == 'kakao') {
      final String initialUrl = 'http://192.168.219.161:3000/auth/kakao';
      _controller.loadRequest(Uri.parse(initialUrl));
    } else if (widget.oauthProvider == 'google') {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final String initialUrl = 'https://9cc8-106-252-44-73.ngrok-free.app/auth/google';
        await _launchURL(initialUrl); // Google OAuth URL을 기본 브라우저에서 열기
      });
    } else {
      final String initialUrl = 'http://192.168.219.161:3000/';
      _controller.loadRequest(Uri.parse(initialUrl));
    }
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      if (uri != null && uri.scheme == "myapp") {
        final String? code = uri.queryParameters['code'];
        if (code != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TokenDisplayScreen(token: code),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OAuth Login'),
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  // 기본 브라우저에서 URL 열기
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}
