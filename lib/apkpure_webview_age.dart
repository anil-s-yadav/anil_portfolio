// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class ApkPureWebViewPage extends StatefulWidget {
//   final String url;
//   const ApkPureWebViewPage({super.key, required this.url});

//   @override
//   State<ApkPureWebViewPage> createState() => _ApkPureWebViewPageState();
// }

// class _ApkPureWebViewPageState extends State<ApkPureWebViewPage> {
//   late InAppWebViewController _webViewController;

//   bool isLoading = true;

//   final String url =
//       "https://apkpure.net/kaamwalibais-crm-for-staff/com.kaamwalibais.kaamwalibais_crm_new";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("App Details"), centerTitle: true),
//       body: Stack(
//         children: [
//           InAppWebView(
//             initialUrlRequest: URLRequest(url: WebUri(url)),

//             initialOptions: InAppWebViewGroupOptions(
//               crossPlatform: InAppWebViewOptions(
//                 javaScriptEnabled: true,
//                 userAgent:
//                     "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
//                     "AppleWebKit/537.36 (KHTML, like Gecko) "
//                     "Chrome/120.0.0.0 Safari/537.36",
//                 supportZoom: false,
//               ),
//               android: AndroidInAppWebViewOptions(
//                 useHybridComposition: true,
//                 domStorageEnabled: true,
//                 thirdPartyCookiesEnabled: true,
//                 safeBrowsingEnabled: false,
//                 mixedContentMode:
//                     AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
//               ),
//             ),

//             onWebViewCreated: (controller) {
//               _webViewController = controller;
//             },

//             onLoadStart: (controller, url) {
//               setState(() {
//                 isLoading = true;
//               });
//             },

//             onLoadStop: (controller, url) async {
//               await _hideUnwantedContent(controller);

//               setState(() {
//                 isLoading = false;
//               });
//             },
//           ),

//           // Loading Indicator
//           if (isLoading) const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }

//   /// Inject JS to clean page
//   Future<void> _hideUnwantedContent(InAppWebViewController controller) async {
//     await controller.evaluateJavascript(
//       source: """

//     // Hide header
//     document.querySelector('header')?.remove();

//     // Hide footer
//     document.querySelector('footer')?.remove();

//     // Hide navbar
//     document.querySelector('.navbar')?.remove();

//     // Hide ads
//     document.querySelectorAll('[class*="ad"], [id*="ad"]').forEach(el => {
//       el.remove();
//     });

//     // Hide sidebar / related apps
//     document.querySelectorAll('.sidebar, .related, .recommend').forEach(el => {
//       el.remove();
//     });

//     // Hide install guide
//     document.querySelectorAll('.install-guide, .guide').forEach(el => {
//       el.remove();
//     });

//     // Hide breadcrumbs
//     document.querySelectorAll('.breadcrumb').forEach(el => {
//       el.remove();
//     });

//     // Remove extra padding/margin
//     document.body.style.margin = "0";
//     document.body.style.padding = "0";

//     // Make content full width
//     document.querySelectorAll('.container, .content').forEach(el => {
//       el.style.maxWidth = "100%";
//       el.style.width = "100%";
//     });

//     // Scroll to main content
//     window.scrollTo(0, 150);

//     """,
//     );
//   }
// }
