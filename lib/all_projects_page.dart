import 'package:anil_portfolio/models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AllProjectsPage extends StatefulWidget {
  final List<Project> projects;
  const AllProjectsPage({super.key, required this.projects});

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
    return Scaffold(
      body: Container(
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
                spacing: 15,
                runSpacing: 15,
                children:
                    widget.projects
                        .map(
                          (proj) => _buildProjectCard(
                            proj.title,
                            proj.description,
                            color,
                            proj.icon,
                            proj.playUrl,
                            proj.moreUrl,
                            proj.iosUrl,
                          ),
                        )
                        .toList(),
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

  // Widget _buildProjectCard(
  //   String title,
  //   String description,
  //   // List<String> technologies,
  //   ColorScheme color,
  //   String image,
  //   String url,
  // ) {
  //   final screenSize = MediaQuery.of(context).size;
  //   final isMobile = screenSize.width <= 600;
  //   final isTablet = screenSize.width > 600 && screenSize.width <= 768;

  //   return Container(
  //     width:
  //         isMobile
  //             ? double.infinity
  //             : (isTablet ? screenSize.width * 0.2 : screenSize.width * 0.2),
  //     height:
  //         isMobile
  //             ? double.infinity
  //             : (isTablet
  //                 ? screenSize.height * 0.35
  //                 : screenSize.height * 0.35),
  //     padding: EdgeInsets.all(10),
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       color: color.surface,
  //       borderRadius: BorderRadius.circular(15),
  //       border: Border.all(color: color.outline.withAlpha(50)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: color.tertiary.withAlpha(20),
  //           blurRadius: 8,
  //           offset: Offset(2, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         ListTile(
  //           leading: ClipRRect(
  //             borderRadius: BorderRadius.circular(8),
  //             child: Image.network(image, scale: 6),
  //           ),
  //           title: Text(
  //             title,
  //             style: TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //               color: color.onSurface,
  //             ),
  //           ),
  //           // subtitle: Text(description),
  //           // trailing: IconButton(
  //           //   onPressed: () => _launchUrl(url),
  //           //   icon: Icon(Icons.link),
  //           // ),
  //         ),
  //         Text(
  //           description,
  //           style: TextStyle(
  //             color: color.onSurfaceVariant,
  //             height: 1.4,
  //             fontSize: 11,
  //           ),
  //         ),

  //         SizedBox(height: screenSize.height * 0.01),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             OutlinedButton.icon(
  //               onPressed: () => _launchUrl(url),
  //               label: Text("PlayStore"),
  //               style: ButtonStyle(
  //                 textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
  //                 fixedSize: WidgetStatePropertyAll(Size(120, 20)),
  //                 padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
  //               ),
  //               // style: ButtonStyle(),
  //               icon: Image.asset("lib/assets/playstore.png", scale: 3.2),
  //             ),
  //             OutlinedButton(
  //               onPressed: () {},
  //               style: ButtonStyle(
  //                 textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
  //                 fixedSize: WidgetStatePropertyAll(Size(100, 20)),
  //                 padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
  //               ),
  //               child: Text("Read more"),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildProjectCard(
    String title,
    String description,
    // List<String> technologies,
    ColorScheme color,
    String image,
    String playUrl,
    String moreUrl,
    String iosUrl,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 655 && screenSize.width <= 768;

    return Container(
      width: isTablet ? 260 : 300,
      // height:
      //     isMobile
      //         ? double.infinity
      //         : (isTablet
      //             ? screenSize.height * 0.35
      //             : screenSize.height * 0.35),
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
          Row(
            spacing: 15,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(image, height: 40),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: color.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              color: color.onSurfaceVariant,
              height: 1.4,
              fontSize: 11,
            ),
          ),

          SizedBox(height: screenSize.height * 0.01),
          FittedBox(
            child: Row(
              spacing: iosUrl.isNotEmpty ? 10 : 4,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _launchUrl(playUrl),
                  label: Text("Play Store"),
                  icon: Image.asset("lib/assets/playstore.png", scale: 3.2),
                ),
                if (iosUrl.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: () => _launchUrl(iosUrl),
                    label: Text("App Store"),
                    icon: Image.asset("lib/assets/appstore.png", scale: 3.2),
                  ),
                OutlinedButton(
                  onPressed: () => _launchUrl(moreUrl),
                  // onPressed:
                  // () => Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder:
                  //         (context) => ApkPureWebViewPage(url: moreUrl),
                  //   ),
                  // ),
                  // style: ButtonStyle(
                  //   textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  // ),
                  child: Text("Read more"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
