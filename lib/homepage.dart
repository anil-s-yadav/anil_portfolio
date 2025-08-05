import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> logo = [
    {
      "logo": "lib/assets/playstore.png",
      "url": "https://play.google.com/store/apps/dev?id=8832237281097064209",
    },
    {"logo": "lib/assets/github.png", "url": "https://github.com/anil-s-yadav"},
    {
      "logo": "lib/assets/linkedin.png",
      "url": "https://www.linkedin.com/in/anil-s-yadav-665938218/",
    },
    {"logo": "lib/assets/whatsapp.png", "url": "https://wa.me/+919892986314/"},
  ];

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    // final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Scaffold(
      backgroundColor: color.surfaceContainerLow,
      appBar: AppBar(
        toolbarHeight: 80,
        title: _buildHeader(color),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding:
            isDesktop
                ? const EdgeInsets.symmetric(horizontal: 80, vertical: 10)
                : const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildHeroSection(color),
            SizedBox(height: 30),

            // Responsive Experience and Education Layout
            if (isDesktop)
              // Desktop: Side by side
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildExperienceSection(color)),
                  SizedBox(width: 20),
                  Expanded(child: _buildEducationSection(color)),
                ],
              )
            else
              // Mobile/Tablet: Stacked
              Column(
                children: [
                  _buildExperienceSection(color),
                  SizedBox(height: 20),
                  _buildEducationSection(color),
                ],
              ),

            SizedBox(height: 30),
            _buildProjectsSection(color),
            SizedBox(height: 10),
            _buildContactSection(color),
            SizedBox(height: 10),
            Column(
              children: [
                Text(
                  "Copyright © Legendary Software",
                  style: TextStyle(
                    color: color.secondaryFixedDim,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "owned by - Anil S. yadav",
                  style: TextStyle(
                    color: color.secondaryFixedDim.withAlpha(180),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 15 : 30),
      margin: EdgeInsets.only(top: 15, right: 10, left: 10, bottom: 20),
      decoration: BoxDecoration(
        color: color.onSecondaryFixedVariant,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withAlpha(50),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "Anil S. Yadav",
            style: TextStyle(
              color: color.secondaryFixedDim,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          Spacer(),
          // if (!isMobile) ...[
          //   _buildNavItem("About me", color),
          //   SizedBox(width: 20),
          //   _buildNavItem("Projects", color),
          //   SizedBox(width: 20),
          // ],
          OutlinedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(color.secondaryFixedDim),
              side: WidgetStatePropertyAll(
                BorderSide(color: color.secondaryFixedDim),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            onPressed:
                () => _launchUrl(
                  "https://drive.google.com/file/d/1G451jAT3YK4wnDkH7oidk6I_dhr2G76l/view?usp=sharing",
                ),
            child: Text(
              "Download Resume",
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String text, ColorScheme color) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: TextStyle(
          color: color.surface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildHeroSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      decoration: BoxDecoration(
        color: color.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withAlpha(50),
            blurRadius: 15,
            offset: Offset(2, 8),
          ),
        ],
      ),
      child:
          isMobile
              ? _buildMobileHeroLayout(color)
              : _buildDesktopHeroLayout(color, isTablet),
    );
  }

  Widget _buildMobileHeroLayout(ColorScheme color) {
    return Column(
      children: [
        // Profile Image
        Container(
          padding: EdgeInsets.all(6),
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('lib/assets/anil_resume.png'),
          ),
        ),
        SizedBox(height: 20),
        // Content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Anil S. Yadav",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color.onSurface,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Hello, my name is Anil Yadav,",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: color.onSurface,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "A passionate Flutter developer with over 1 year of experience building beautiful, high-performance mobile apps. I’ve successfully developed and deployed multiple cross-platform applications for diverse domains including news, e-commerce, and productivity. My focus is on writing clean, maintainable code and delivering pixel-perfect UI with smooth user experiences. I’m proficient in Firebase, REST APIs, third-party integrations, and state management solutions like Provider and BLoC. I take pride in turning ideas into full-fledged apps from scratch. Looking forward to helping you build your next great app!",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                height: 1.6,
                color: color.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  logo
                      .map(
                        (l) => IconButton(
                          onPressed: () => _launchUrl(l['url']),
                          icon: Image.asset(l['logo'], height: 24, width: 24),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeroLayout(ColorScheme color, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(6),
            height: isTablet ? 250 : 300,
            width: isTablet ? 250 : 300,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('lib/assets/anil_resume.png'),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 20 : 30),
        Expanded(
          flex: 2,
          child: Container(
            height: isTablet ? 250 : 300,
            padding: EdgeInsets.all(isTablet ? 15 : 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Anil S. Yadav",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 20 : 24,
                    color: color.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Hello, my name is Anil Yadav,",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 14 : 16,
                    color: color.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "and I believe that focusing on your company's data security plan is essential to growing your company's business. With over 10 years of experience in information and data security, my knowledge and skills can help you create effective security strategies. My dedication to creating comprehensive data security plans can also help your company improve its data integrity and increase customer retention.",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    height: 1.6,
                    color: color.onSurfaceVariant,
                    fontSize: isTablet ? 13 : 14,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      logo
                          .map(
                            (l) => IconButton(
                              onPressed: () => _launchUrl(l['url']),
                              icon: Image.asset(
                                l['logo'],
                                height: 26,
                                width: 26,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      width: isDesktop ? null : double.infinity,
      padding: EdgeInsets.all(20),
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
            children: [
              Icon(Icons.work, color: color.tertiary, size: 24),
              SizedBox(width: 10),
              Text(
                "Experience",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTimelineItem(
            " Flutter Developer   ",
            " Kaamwalibais – Mumbai, India",
            "Dec 2024 - Present",
            "•  Developed and maintained a custom Flutter-based application for the company.\n• Contributed to 24-hour maid services and IT service solutions through app development.",
            color,
            true,
          ),
          _buildTimelineItem(
            "Android Developer (Java,Kotlin)",
            "Prodigy InfoTech · Internship",
            "Jan 2024 - March 2024",
            "• Contribute in componies app development projects.",
            color,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      width: isDesktop ? null : double.infinity,
      padding: EdgeInsets.all(20),
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
            children: [
              Icon(Icons.school, color: color.tertiary, size: 24),
              SizedBox(width: 10),
              Text(
                "Education",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTimelineItem(
            " B.Sc. - Information Technology",
            " Bunts sangha S. M. Shetty college, Powai",
            "2021 - 2024",
            "CGPA - 8.10",
            color,
            true,
          ),
          _buildTimelineItem(
            "HSC - 12th Science",
            "Ramniranjan Jhunjhunwala collage, Ghatkoper.",
            "2019 - 2021",
            "Marks - 78.67%",
            color,
            false,
          ),
          _buildTimelineItem(
            "SSC- 10th",
            " Hindi High School, Ghatkoper.",
            "Compleated in 2019",
            "Marks - 84.45%",
            color,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    // final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
            children: [
              Icon(Icons.code, color: color.tertiary, size: 24),
              SizedBox(width: 10),
              Text(
                "Projects",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              _buildProjectCard(
                "Stream24 Short News & Live Tv",
                "\nStream24 is a smart news and live TV app offering real-time updates, personalized news, and trending reels. Watch live channels, read AI-powered news summaries, and stay informed anytime, anywhere.",
                [
                  "Flutter",
                  "Dart",
                  "Python",
                  "Fast Api",
                  "Firebase",
                  "summary AI Model",
                ],
                color,
                "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/aboutus_logo.png",
                "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
              ),
              _buildProjectCard(
                "WhatsApp Media Manager",
                "\nAn all-in-one app to manage WhatsApp media including photos, PDFs, videos, and more. Easily view, organize, and download both hidden and regular files with a clean, user-friendly interface.",
                ["Flutter", "Dart", "Native Channels"],
                color,
                "https://raw.githubusercontent.com/anil-s-yadav/WhatsApp-Media-Manager/refs/heads/main/lib/images/logo.png",
                "https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      width:
          isMobile
              ? double.infinity
              : (isTablet ? screenWidth * 0.7 : screenWidth * 0.5),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contact_mail, color: color.tertiary, size: 24),
              SizedBox(width: 10),
              Text(
                "Contact Me",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...logo.map(
                (l) => IconButton(
                  onPressed: () => _launchUrl(l['url']),
                  icon: Image.asset(l['logo'], height: 24, width: 24),
                ),
              ),
              _buildContactItem(
                Icons.email,
                Colors.red,
                () => _launchUrl("mailto:anilyadav44x@gmail.com"),
              ),
              _buildContactItem(
                Icons.phone,
                Colors.green.shade600,
                () => _launchUrl("tel:+919892986314"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "• Freelancing work available, contact for best deals!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green),
            ),
          ),

          // if (isMobile) SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String company,
    String period,
    String description,
    ColorScheme color,
    bool isFirst,
  ) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.2,

      isFirst: isFirst,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: color.tertiary,
        iconStyle: IconStyle(color: color.surface, iconData: Icons.work),
      ),
      beforeLineStyle: LineStyle(
        color: color.tertiary.withAlpha(50),
        thickness: 2,
      ),
      endChild: Container(
        margin: EdgeInsets.only(bottom: 20, left: 20),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.outline.withAlpha(60)),
          boxShadow: [
            BoxShadow(
              color: color.onTertiary.withAlpha(100),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color.onSurface,
              ),
            ),
            SizedBox(height: 5),
            Text(
              company,
              style: TextStyle(
                color: color.tertiary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.tertiary.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: color.tertiary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                color: color.onSurfaceVariant,
                height: 1.4,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    List<String> technologies,
    ColorScheme color,
    String image,
    String url,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      width:
          isMobile
              ? double.infinity
              : (isTablet ? screenWidth * 0.4 : screenWidth * 0.25),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: color.tertiary.withAlpha(50),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color.onSurface,
              ),
            ),
            // subtitle: Text(description),
            trailing: IconButton(
              onPressed: () => _launchUrl(url),
              icon: Icon(Icons.link),
            ),
          ),
          Text(
            description,
            style: TextStyle(
              color: color.onSurfaceVariant,
              height: 1.4,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                technologies
                    .map(
                      (tech) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.tertiary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            fontSize: 10,
                            color: color.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
