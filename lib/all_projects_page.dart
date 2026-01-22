import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    return Scaffold(
      body: Container(
        // key: sectionKeys['projectsKey'],
        margin: EdgeInsets.all(10),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.shadow.withAlpha(50),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: color.tertiary,
                    size: 24,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            /*      Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.code, color: color.tertiary, size: 24),
                SizedBox(width: 10),
                Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color.onSurface,
                  ),
                ),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 20,
                    children: [
                      filterOption("All", () {}),
                      filterOption("Test", () {}),
                      filterOption("Test", () {}),
                      filterOption("Test", () {}),
                      filterOption("Test", () {}),
                      // TextButton(onPressed: () {}, child: Text("Test")),
                      // TextButton(onPressed: () {}, child: Text("Test")),
                      // TextButton(onPressed: () {}, child: Text("Test")),
                      // TextButton(onPressed: () {}, child: Text("Test")),
                    ],
                  ),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProjectsPage(),
                        ),
                      ),
                  child: Text(
                    "View All Projects >",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),*/
            SizedBox(height: 20),

            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                spacing: 15,
                runSpacing: 15,
                children: [
                  _buildProjectCard(
                    "Stream24 Short News & Live Tv",
                    "Stream24 is a smart news and live TV app offering real-time updates, personalized news, and trending reels. Watch live channels, read AI-powered news summaries, and stay informed anytime, anywhere.",
                    // [
                    //   "Flutter",
                    //   "Dart",
                    //   "Python",
                    //   "Fast Api",
                    //   "Firebase",
                    //   "summary AI Model",
                    // ],
                    color,
                    "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/aboutus_logo.png",
                    "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
                  ),
                  _buildProjectCard(
                    "WhatsApp Media Manager",
                    "An all-in-one app to manage WhatsApp media including photos, PDFs, videos, and more. Easily view, organize, and download both hidden and regular files with a clean, user-friendly interface.",
                    // ["Flutter", "Dart", "Native Channels"],
                    color,
                    "https://raw.githubusercontent.com/anil-s-yadav/WhatsApp-Media-Manager/refs/heads/main/lib/images/logo.png",
                    "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
                  ),
                  _buildProjectCard(
                    "WhatsApp Media Manager",
                    "An all-in-one app to manage WhatsApp media including photos, PDFs, videos, and more. Easily view, organize, and download both hidden and regular files with a clean, user-friendly interface.",
                    // ["Flutter", "Dart", "Native Channels"],
                    color,
                    "https://raw.githubusercontent.com/anil-s-yadav/WhatsApp-Media-Manager/refs/heads/main/lib/images/logo.png",
                    "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
                  ),
                  _buildProjectCard(
                    "WhatsApp Media Manager",
                    "An all-in-one app to manage WhatsApp media including photos, PDFs, videos, and more. Easily view, organize, and download both hidden and regular files with a clean, user-friendly interface.",
                    // ["Flutter", "Dart", "Native Channels"],
                    color,
                    "https://raw.githubusercontent.com/anil-s-yadav/WhatsApp-Media-Manager/refs/heads/main/lib/images/logo.png",
                    "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterOption(String text, Function? onTap) {
    return TextButton(
      onPressed: () => onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w100,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    // List<String> technologies,
    ColorScheme color,
    String image,
    String url,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width <= 600;
    final isTablet = screenSize.width > 600 && screenSize.width <= 768;

    return Container(
      width:
          isMobile
              ? double.infinity
              : (isTablet ? screenSize.width * 0.2 : screenSize.width * 0.2),
      height:
          isMobile
              ? double.infinity
              : (isTablet
                  ? screenSize.height * 0.35
                  : screenSize.height * 0.35),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: color.tertiary.withAlpha(20),
            blurRadius: 8,
            offset: Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image, scale: 6),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: color.onSurface,
              ),
            ),
            // subtitle: Text(description),
            // trailing: IconButton(
            //   onPressed: () => _launchUrl(url),
            //   icon: Icon(Icons.link),
            // ),
          ),
          Text(
            description,
            style: TextStyle(
              color: color.onSurfaceVariant,
              height: 1.4,
              fontSize: 11,
            ),
          ),

          SizedBox(height: screenSize.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => _launchUrl(url),
                label: Text("PlayStore"),
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  fixedSize: WidgetStatePropertyAll(Size(120, 20)),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                ),
                // style: ButtonStyle(),
                icon: Image.asset("lib/assets/playstore.png", scale: 3.2),
              ),
              OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  fixedSize: WidgetStatePropertyAll(Size(100, 20)),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                ),
                child: Text("Read more"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
