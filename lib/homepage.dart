import 'package:anil_portfolio/all_projects_page.dart';
import 'package:anil_portfolio/apkpure_webview_age.dart';
import 'package:anil_portfolio/login_page.dart';
import 'package:anil_portfolio/models.dart';
import 'package:anil_portfolio/firebase_apis.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    final isMobile = screenWidth <= 655;
    final isTablet = screenWidth > 655 && screenWidth <= 768;
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
      key: _scaffoldKey,
      backgroundColor: color.surfaceContainerLow,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: _buildHeader(color),
        backgroundColor: Colors.transparent,
      ),
      // drawer: isMobile ? Drawer(child: _buildNavItem(color)) : null,
      drawer:
          isMobile
              ? Drawer(
                child: SafeArea(
                  child: ListView(
                    padding: EdgeInsets.all(40),
                    children: [
                      _buildNavItem(color),
                      SizedBox(height: 30),
                      _freelancingSection(color),
                      _freelancingSection2(color),
                    ],
                  ),
                ),
              )
              : null,
      body: SingleChildScrollView(
        // padding:
        //     isDesktop
        //         ? const EdgeInsets.symmetric(horizontal: 80, vertical: 10)
        //         : const EdgeInsets.all(10),
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildHeader(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    final isTablet = screenWidth > 655 && screenWidth <= 768;
    final isMobile = screenWidth <= 655;

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
          // Show only on Mobile
          if (isMobile)
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(Icons.menu, color: color.secondaryFixedDim),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),

          Text(
            "Anil S. Yadav",
            style: TextStyle(
              color: color.secondaryFixedDim,
              fontWeight: FontWeight.bold,
              fontSize:
                  isMobile
                      ? 13
                      : isTablet
                      ? 14
                      : 16,
            ),
          ),
          if (!isMobile)
            Row(
              spacing: isDesktop ? 20 : 5,
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

          OutlinedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(color.secondaryFixedDim),
              side: WidgetStatePropertyAll(
                BorderSide(color: color.secondaryFixedDim),
              ),
              padding:
                  isMobile
                      ? WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 10),
                      )
                      : isTablet
                      ? WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 5),
                      )
                      : null,
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            onPressed: () => _launchUrl(data.resume),
            child: Text(
              "Download Resume",
              style: TextStyle(
                fontSize:
                    isMobile
                        ? 10
                        : isTablet
                        ? 11
                        : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(ColorScheme color) {
    return Column(
      spacing: 20,
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            scrollTo("homeKey");
            Navigator.pop(context);
          },
          child: Text("Home"),
        ),
        InkWell(
          onTap: () {
            scrollTo("skillsKey");
            Navigator.pop(context);
          },
          child: Text("Skills"),
        ),
        InkWell(
          onTap: () {
            scrollTo("projectsKey");
            Navigator.pop(context);
          },
          child: Text("Projects"),
        ),
        InkWell(
          onTap: () {
            scrollTo("experienceKey");
            Navigator.pop(context);
          },
          child: Text("Experience"),
        ),
        InkWell(
          onTap: () {
            scrollTo("EducationKey");
            Navigator.pop(context);
          },
          child: Text("Education"),
        ),
        InkWell(
          onTap: () {
            scrollTo("contactKey");
            Navigator.pop(context);
          },
          child: Text("Contact me"),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildHeroSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 655;
    final isTablet = screenWidth > 655 && screenWidth <= 768;

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
          // height: MediaQuery.of(context).size.width * 0.5,
          width: 150,
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
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.all(5),
          height: isTablet ? 150 : 200,
          width: isTablet ? 150 : 200,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('lib/assets/anil.png', height: 250, width: 250),
          ),
        ),
        SizedBox(width: isTablet ? 20 : 30),
        Expanded(
          // flex: 2,
          child: SelectionArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Anil S. Yadav",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 22,
                    color: color.onSurface,
                  ),
                ),
                SizedBox(height: isTablet ? 5 : 10),
                Text(
                  "Hello, my name is Anil Yadav,",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: isTablet ? 13 : 16,
                    color: color.onSurface,
                  ),
                ),
                SizedBox(height: isTablet ? 5 : 10),
                Text(
                  data.about,
                  // "A passionate Flutter developer with over 1 year of experience building beautiful, high-performance mobile apps. I’ve successfully developed and deployed multiple cross-platform applications for diverse domains including news, e-commerce, and productivity. My focus is on writing clean, maintainable code and delivering pixel-perfect UI with smooth user experiences. I’m proficient in Firebase, REST APIs, third-party integrations, and state management solutions like Provider and BLoC. I take pride in turning ideas into full-fledged apps from scratch. Looking forward to helping you build your next great app!",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // height: 1.6,
                    color: color.onSurfaceVariant,
                    fontSize: isTablet ? 11 : 14,
                  ),
                ),
                // Spacer(),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      logo
                          .map(
                            (l) => IconButton(
                              onPressed: () => _launchUrl(l['url']),
                              icon: Image.asset(
                                l['logo'],
                                height: isTablet ? 20 : 26,
                                width: isTablet ? 20 : 26,
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

  Widget _buildProjectsSection(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define breakpoints
    final isMobile = screenWidth <= 655;
    final isTablet =
        screenWidth > 655 && screenWidth <= 1024; // adjust as needed
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
      margin: EdgeInsets.all(20),
      // width: double.infinity,
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
                        builder:
                            (context) =>
                                AllProjectsPage(projects: data.projects),
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
                          proj.playUrl,
                          proj.moreUrl,
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
    final isMobile = screenWidth <= 655;
    // final isTablet = screenWidth > 655 && screenWidth <= 768;

    return Container(
      // height: 100, //testing delete later
      key: sectionKeys['skillsKey'],
      margin: EdgeInsets.all(20),
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
            spacing: 5,
            children:
                data.skills
                    .map(
                      (skill) => Chip(
                        label: SelectableText(skill),
                        labelPadding: EdgeInsets.all(0),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: color.tertiary,
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
      margin: EdgeInsets.all(20),
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
              ex.desc,
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
      margin: EdgeInsets.all(20),
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
            ["CGPA - 8.10"],
            color,
            true,
            isEdu: true,
          ),
          _buildTimelineItem(
            "HSC - 12th Science",
            "Ramniranjan Jhunjhunwala collage, Ghatkoper.",
            "2019 - 2021",
            ["Marks - 78.67%"],
            color,
            false,
            isEdu: true,
          ),
          _buildTimelineItem(
            "SSC- 10th",
            " Hindi High School, Ghatkoper.",
            "Compleated in 2019",
            ["Marks - 84.45%"],
            color,
            false,
            isEdu: true,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(ColorScheme color) {
    return Container(
      key: sectionKeys['contactKey'],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: color.surfaceContainer,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final isMobile = width < 600;
              final isTablet = width >= 600 && width < 900;

              // ================= MOBILE =================
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _freelancingSection(color),
                    _freelancingSection2(color),

                    const SizedBox(height: 25),

                    _contactSection(color),
                  ],
                );
              }

              // ================= TABLET =================
              if (isTablet) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _contactSection(color)),

                    const SizedBox(width: 30),

                    Expanded(child: _freelancingSection(color)),
                    Expanded(child: _freelancingSection2(color)),
                  ],
                );
              }

              // ================= DESKTOP =================
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _contactSection(color)),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: VerticalDivider(
                      color: color.outlineVariant,
                      thickness: 1,
                    ),
                  ),

                  Expanded(child: _freelancingSection(color)),
                  Expanded(child: _freelancingSection2(color)),
                ],
              );
            },
          ),
          Divider(
            color: color.surfaceContainerLowest,
            height: 40,
            indent: 50,
            endIndent: 30,
          ),

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

  Widget _contactSection(ColorScheme color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contact_mail, size: 16, color: color.tertiary),
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
          alignment: WrapAlignment.center,
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
    );
  }

  Widget _freelancingSection(ColorScheme color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          icon: Icons.work_outline,
          title: "Freelancing Services",
          color: color,
        ),

        const SizedBox(height: 12),

        _serviceItem("Apps for Android & iOS"),
        _serviceItem("Web Apps Development"),
        _serviceItem("CRM & Dashboard"),
        _serviceItem("API Development"),
      ],
    );
  }

  Widget _freelancingSection2(ColorScheme color) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 640;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile) SizedBox(height: 28),

        _serviceItem("UI/UX Design"),
        _serviceItem("Bug Fixing"),
        _serviceItem("Maintenance"),
        _serviceItem("Performance Optimization"),
      ],
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
          Expanded(child: Text(text, style: TextStyle(fontSize: 12))),
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
    List<String> description,
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
            SelectableText(
              company,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: color.onSurface,
              ),
            ),
            SizedBox(height: 5),
            SelectableText(
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
            ...description.map(
              (e) => Text(
                '•  $e',
                style: TextStyle(
                  color: color.onSurfaceVariant,
                  // height: 1.4,
                  fontSize: 12,
                ),
              ),
            ),
            // Text(
            //   description[0],
            //   // textAlign: TextAlign.justify,
            //   style: TextStyle(
            //     color: color.onSurfaceVariant,
            //     // height: 1.4,
            //     fontSize: 12,
            //   ),
            // ),
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
    String playurl,
    String moreUrl,
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
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _launchUrl(playurl),
                  label: Text("PlayStore"),
                  // style: ButtonStyle(
                  //   textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
                  //   fixedSize: WidgetStatePropertyAll(Size(120, 20)),
                  //   padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                  // ),
                  // style: ButtonStyle(),
                  icon: Image.asset("lib/assets/playstore.png", scale: 3.2),
                ),
                OutlinedButton(
                  onPressed: () => _launchUrl(moreUrl),

                  // onPressed:
                  //     () => Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder:
                  //             (context) => ApkPureWebViewPage(url: moreUrl),
                  //       ),
                  //     ),
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

  Future<void> _launchUrl(String url) async {
    await launchUrl(Uri.parse(url));
  }
}
