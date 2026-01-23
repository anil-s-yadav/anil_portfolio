import 'package:anil_portfolio/all_projects_page.dart';
import 'package:anil_portfolio/login_page.dart';
import 'package:anil_portfolio/models.dart';
import 'package:anil_portfolio/theme/firebase_apis.dart';
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

  final Map<String, GlobalKey> sectionKeys = {
    'homeKey': GlobalKey(),
    'skillsKey': GlobalKey(),
    'projectsKey': GlobalKey(),
    'experienceKey': GlobalKey(),
    'EducationKey': GlobalKey(),

    'contactKey': GlobalKey(),
  };

  void scrollTo(String section) {
    final context = sectionKeys[section]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  late final HomeController controller;
  late HomeData data;
  @override
  void initState() {
    super.initState();
    controller = HomeController();
    controller.loadHome().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    // final isTablet = screenWidth > 600 && screenWidth <= 768;
    if (controller.isLoading) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: color.surfaceContainerLow,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.error != null) {
      return Center(child: Text(controller.error!));
    }

    data = controller.homeData!;
    return Scaffold(
      backgroundColor: color.surfaceContainerLow,
      appBar: AppBar(
        toolbarHeight: 80,
        title: _buildHeader(color),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        // padding:
        //     isDesktop
        //         ? const EdgeInsets.symmetric(horizontal: 80, vertical: 10)
        //         : const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildHeroSection(color),
            // SizedBox(height: 30),
            _buildSkillsSection(color),
            _buildProjectsSection(color),
            // SizedBox(height: 30),
            // Responsive Experience and Education Layout
            if (isDesktop)
              // Desktop: Side by side
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Expanded(flex: 3, child: _buildExperienceSection(color)),
                    Expanded(flex: 2, child: _buildEducationSection(color)),
                  ],
                ),
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

            // SizedBox(height: 50),
            // Divider(),
            _buildContactSection(color),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Anil S. Yadav",
            style: TextStyle(
              color: color.secondaryFixedDim,
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 14 : 16,
            ),
          ),
          Row(
            spacing: 20,
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => scrollTo("homeKey"),
                child: Text("Home", style: TextStyle(fontSize: 11)),
              ),
              InkWell(
                onTap: () => scrollTo("skillsKey"),
                child: Text("Skills", style: TextStyle(fontSize: 11)),
              ),
              InkWell(
                onTap: () => scrollTo("projectsKey"),
                child: Text("Projects", style: TextStyle(fontSize: 11)),
              ),
              InkWell(
                onTap: () => scrollTo("experienceKey"),
                child: Text(
                  "Experience & Education",
                  style: TextStyle(fontSize: 11),
                ),
              ),
              // InkWell(
              //   onTap: () => scrollTo("EducationKey"),
              //   child: Text("Education", style: TextStyle(fontSize: 11)),
              // ),
              InkWell(
                onTap: () => scrollTo("contactKey"),
                child: Text("Contact me", style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          // Spacer(),
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
      key: sectionKeys['homeKey'],
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 15 : 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.width * 0.5,
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('lib/assets/anil.png', fit: BoxFit.fitWidth),
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
                fontSize: 18,
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
            // SizedBox(height: 10),
            Text(
              data.about,
              // "A passionate Flutter developer with over 1 year of experience building beautiful, high-performance mobile apps. I’ve successfully developed and deployed multiple cross-platform applications for diverse domains including news, e-commerce, and productivity. My focus is on writing clean, maintainable code and delivering pixel-perfect UI with smooth user experiences. I’m proficient in Firebase, REST APIs, third-party integrations, and state management solutions like Provider and BLoC. I take pride in turning ideas into full-fledged apps from scratch. Looking forward to helping you build your next great app!",
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
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(6),
            height: isTablet ? 250 : 300,
            width: isTablet ? 250 : 300,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('lib/assets/anil.png'),
            ),
          ),
        ),
        SizedBox(width: isTablet ? 20 : 30),
        Expanded(
          flex: 2,
          child: SelectionArea(
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
                      fontSize: isTablet ? 19 : 22,
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
                    data.about,
                    // "A passionate Flutter developer with over 1 year of experience building beautiful, high-performance mobile apps. I’ve successfully developed and deployed multiple cross-platform applications for diverse domains including news, e-commerce, and productivity. My focus is on writing clean, maintainable code and delivering pixel-perfect UI with smooth user experiences. I’m proficient in Firebase, REST APIs, third-party integrations, and state management solutions like Provider and BLoC. I take pride in turning ideas into full-fledged apps from scratch. Looking forward to helping you build your next great app!",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      // height: 1.6,
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
        ),
      ],
    );
  }

  Widget _buildProjectsSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints
    final isMobile = screenWidth <= 600;
    final isTablet =
        screenWidth > 600 && screenWidth <= 1024; // adjust as needed
    final isDesktop = screenWidth > 1024;

    // Determine how many projects to show
    int projectCount;
    if (isDesktop) {
      projectCount = 4;
    } else if (isTablet) {
      projectCount = 3;
    } else {
      projectCount = 2;
    }

    // Slice the list safely
    final projectsToShow = data.projects.take(projectCount).toList();

    return Container(
      key: sectionKeys['projectsKey'],
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
              Spacer(),
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
          ),
          SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 15,
              runSpacing: 15,
              children:
                  projectsToShow
                      .map(
                        (proj) => _buildProjectCard(
                          proj.title,
                          proj.description,
                          color,
                          proj.icon,
                          proj.url,
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    // final isTablet = screenWidth > 600 && screenWidth <= 768;

    return Container(
      // height: 100, //testing delete later
      key: sectionKeys['skillsKey'],
      margin: EdgeInsets.symmetric(horizontal: 40),
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
              Icon(Icons.computer_rounded, color: color.tertiary, size: 22),
              SizedBox(width: 10),
              Text(
                "Skills",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children:
                data.skills
                    .map(
                      (skill) => Chip(
                        label: Text(skill),
                        labelPadding: EdgeInsets.all(0),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: color.secondaryContainer,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      key: sectionKeys['experienceKey'],
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
              Icon(Icons.work, color: color.tertiary, size: 23),
              SizedBox(width: 10),
              Text(
                "Experience",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...data.experiences.asMap().entries.map((entry) {
            final index = entry.key;
            final ex = entry.value;

            final isFirst = index == 0;

            return _buildTimelineItem(
              ex.company,
              ex.title,
              ex.time,
              ex.desc[0],
              color,
              isFirst, // true only for last item, false for others
            );
          }),

          // _buildTimelineItem(
          //   " V-Trans India – Mumbai, India",
          //   " Flutter Developer   ",
          //   "Jan 2026 - Present",
          //   "•  Developed and maintained a custom Flutter-based application for the company.\n• Contributed to 24-hour maid services and IT service solutions through app development.",
          //   color,
          //   true,
          // ),
          // _buildTimelineItem(
          //   " Kaamwalibais – Mumbai, India",
          //   " Flutter Developer   ",

          //   "Dec 2024 - Dec 2025",
          //   "•  Developed and maintained a custom Flutter-based application for the company.\n• Contributed to 24-hour maid services and IT service solutions through app development.",
          //   color,
          //   false,
          // ),
          // _buildTimelineItem(
          //   "Prodigy InfoTech · Internship",
          //   "Android Developer (Java,Kotlin)",

          //   "Jan 2024 - March 2024",
          //   "• Contribute in componies app development projects.",
          //   color,
          //   false,
          // ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Container(
      key: sectionKeys['EducationKey'],
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
                  fontSize: 20,
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
            isEdu: true,
          ),
          _buildTimelineItem(
            "HSC - 12th Science",
            "Ramniranjan Jhunjhunwala collage, Ghatkoper.",
            "2019 - 2021",
            "Marks - 78.67%",
            color,
            false,
            isEdu: true,
          ),
          _buildTimelineItem(
            "SSC- 10th",
            " Hindi High School, Ghatkoper.",
            "Compleated in 2019",
            "Marks - 84.45%",
            color,
            false,
            isEdu: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ColorScheme color) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Container(
      key: sectionKeys['contactKey'],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(color: color.surfaceContainer),
      child: Column(
        children: [
          // Top content
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LEFT — CONTACTS
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contact_mail,
                          size: 16,
                          color: color.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Contact",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      // spacing: 8,
                      children: [
                        ...logo.map(
                          (l) => IconButton(
                            tooltip: l['name'],
                            onPressed: () => _launchUrl(l['url']),
                            icon: Image.asset(l['logo'], height: 22),
                          ),
                        ),
                        _contactIcon(
                          Icons.email,
                          Colors.red,
                          () => _launchUrl("mailto:anilyadav44x@gmail.com"),
                        ),
                        _contactIcon(
                          Icons.phone,
                          Colors.green,
                          () => _launchUrl("tel:+919892986314"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (!isMobile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: VerticalDivider(
                    color: color.outlineVariant,
                    thickness: 1,
                  ),
                ),

              // RIGHT — SERVICES
              Expanded(
                // flex: ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(
                      icon: Icons.work_outline,
                      title: "Freelancing Services",
                      color: color,
                    ),
                    const SizedBox(height: 12),
                    _serviceItem("Apps for Androiid & IOS"),
                    _serviceItem("Web Apps development"),
                    _serviceItem("CRM and dashboard Development"),
                    _serviceItem("Api Development"),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(title: "", color: color),
                    const SizedBox(height: 12),
                    _serviceItem("UI/UX Design"),
                    _serviceItem("Bug Fixing"),
                    _serviceItem("App and WebApps Maintenance"),
                    _serviceItem("App Performance Optimization"),
                  ],
                ),
              ),
            ],
          ),

          // const SizedBox(height: 30),
          Divider(
            color: color.surfaceContainerLowest,
            height: 50,
            indent: 50,
            endIndent: 30,
          ),

          // FOOTER
          // const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              Text(
                "© Legendary Software",
                style: TextStyle(color: color.onSurfaceVariant, fontSize: 11),
              ),
              Text(
                "• Anil Yadav",
                style: TextStyle(
                  color: color.onSurfaceVariant.withAlpha(160),
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: Text(
                  "Admin",
                  style: TextStyle(
                    color: color.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle({
    IconData? icon,
    required String title,
    required ColorScheme color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.tertiary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _serviceItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  Widget _contactIcon(IconData icon, Color color, VoidCallback onTap) {
    return IconButton(onPressed: onTap, icon: Icon(icon, color: color));
  }

  Widget _buildTimelineItem(
    String company,
    String title,
    String period,
    String description,
    ColorScheme color,
    bool isLast, {
    bool isEdu = false,
  }) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.0,

      isFirst: isLast,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: color.tertiary,
        iconStyle: IconStyle(
          color: color.surface,
          iconData: isEdu ? Icons.school : Icons.work,
        ),
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
              company,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color.onSurface,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: color.tertiary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 5),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
              // textAlign: TextAlign.justify,
              style: TextStyle(
                color: color.onSurfaceVariant,
                // height: 1.4,
                fontSize: 12,
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
          /*     SizedBox(height: 5),
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
          ),*/
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
