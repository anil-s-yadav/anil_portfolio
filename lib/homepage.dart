import 'package:anil_portfolio/all_projects_page.dart' deferred as all_projects;
import 'package:anil_portfolio/login_page.dart' deferred as login;
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
  final List<Map<String, String>> socialLinks = [
    {
      "name": "Play Store",
      "logo": "lib/assets/playstore.png",
      "url": "https://play.google.com/store/apps/dev?id=8832237281097064209",
    },
    {
      "name": "GitHub",
      "logo": "lib/assets/github.png",
      "url": "https://github.com/anil-s-yadav",
    },
    {
      "name": "LinkedIn",
      "logo": "lib/assets/linkedin.png",
      "url": "https://www.linkedin.com/in/anil-s-yadav-665938218/",
    },
    {
      "name": "WhatsApp",
      "logo": "lib/assets/whatsapp.png",
      "url": "https://wa.me/+919892986314/",
    },
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, GlobalKey> sectionKeys = {
    'homeKey': GlobalKey(),
    'skillsKey': GlobalKey(),
    'projectsKey': GlobalKey(),
    'experienceKey': GlobalKey(),
    'educationKey': GlobalKey(),
    'contactKey': GlobalKey(),
  };

  late final HomeController controller;
  late HomeData data;

  void scrollTo(String section) {
    final context = sectionKeys[section]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controller = HomeController();
    data = controller.homeData;
    controller.loadHome().then((_) {
      if (mounted) {
        setState(() {
          data = controller.homeData;
        });
      }
    });
  }

  Future<void> _launchUrl(String url) async {
    if (url.trim().isEmpty) return;
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;
    final isMobile = screenWidth <= 650;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surface,
      drawer: isMobile ? _buildMobileDrawer(colorScheme) : null,
      body: Stack(
        children: [
          // Background ambient glow orbs – isolated in own repaint layer
          RepaintBoundary(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Positioned(
                    top: -120,
                    right: -80,
                    child: Container(
                      width: 380,
                      height: 380,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF6366F1).withAlpha(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withAlpha(30),
                            blurRadius: 80,
                            spreadRadius: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 350,
                    left: -120,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF06B6D4).withAlpha(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06B6D4).withAlpha(22),
                            blurRadius: 80,
                            spreadRadius: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 850,
                    right: -100,
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFEC4899).withAlpha(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEC4899).withAlpha(20),
                            blurRadius: 80,
                            spreadRadius: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : (isDesktop ? 40 : 20),
                vertical: 10,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      _buildHeader(colorScheme, isMobile, isDesktop),
                      const SizedBox(height: 15),
                      _buildHeroSection(colorScheme, isMobile, isDesktop),
                      const SizedBox(height: 25),
                      _buildSkillsSection(colorScheme),
                      const SizedBox(height: 25),
                      _buildProjectsSection(colorScheme, isDesktop),
                      const SizedBox(height: 25),
                      _buildExperienceAndEducation(colorScheme, isDesktop),
                      const SizedBox(height: 40),
                      _buildContactSection(colorScheme, isDesktop, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= NAVIGATION HEADER =================
  Widget _buildHeader(ColorScheme colorScheme, bool isMobile, bool isDesktop) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withAlpha(200),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isMobile)
            IconButton(
              icon: Icon(Icons.menu_rounded, color: colorScheme.primary),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),

          // Logo / Brand
          InkWell(
            onTap: () => scrollTo('homeKey'),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "AY",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Anil S. Yadav",
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Desktop Nav links
          if (!isMobile)
            Row(
              children: [
                _navButton("Home", () => scrollTo("homeKey"), colorScheme),
                _navButton("Skills", () => scrollTo("skillsKey"), colorScheme),
                _navButton(
                  "Projects",
                  () => scrollTo("projectsKey"),
                  colorScheme,
                ),
                _navButton(
                  "Experience",
                  () => scrollTo("experienceKey"),
                  colorScheme,
                ),
                _navButton(
                  "Contact",
                  () => scrollTo("contactKey"),
                  colorScheme,
                ),
              ],
            ),

          // Download Resume CTA
          _ModernResumeButton(
            resumeUrl: data.resume,
            colorScheme: colorScheme,
            onTap: () => _launchUrl(data.resume),
          ),
        ],
      ),
    );
  }

  Widget _navButton(String text, VoidCallback onTap, ColorScheme color) {
    return _HoverNavButton(text: text, onTap: onTap, colorScheme: color);
  }

  // ================= MOBILE DRAWER =================
  Widget _buildMobileDrawer(ColorScheme colorScheme) {
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      "AY",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Anil S. Yadav",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            _drawerItem(Icons.home_outlined, "Home", () {
              Navigator.pop(context);
              scrollTo("homeKey");
            }, colorScheme),
            _drawerItem(Icons.code_rounded, "Skills", () {
              Navigator.pop(context);
              scrollTo("skillsKey");
            }, colorScheme),
            _drawerItem(Icons.apps_rounded, "Projects", () {
              Navigator.pop(context);
              scrollTo("projectsKey");
            }, colorScheme),
            _drawerItem(
              Icons.work_outline_rounded,
              "Experience & Education",
              () {
                Navigator.pop(context);
                scrollTo("experienceKey");
              },
              colorScheme,
            ),
            _drawerItem(Icons.contact_mail_outlined, "Contact Me", () {
              Navigator.pop(context);
              scrollTo("contactKey");
            }, colorScheme),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            _freelancingSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    VoidCallback onTap,
    ColorScheme color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color.primary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color.onSurface,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }

  // ================= HERO SECTION =================
  Widget _buildHeroSection(
    ColorScheme colorScheme,
    bool isMobile,
    bool isDesktop,
  ) {
    return Container(
      key: sectionKeys['homeKey'],
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(230),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(14),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child:
          isMobile
              ? _buildMobileHero(colorScheme)
              : _buildDesktopHero(colorScheme),
    );
  }

  Widget _buildMobileHero(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildAvatar(colorScheme, 140),
        const SizedBox(height: 20),

        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF818CF8),
                  Color(0xFF38BDF8),
                  Color(0xFFF472B6),
                ],
              ).createShader(bounds),
          child: const Text(
            "Anil S. Yadav",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 26,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Flutter Developer & Mobile App Engineer",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          data.about,
          textAlign: TextAlign.center,
          style: TextStyle(
            height: 1.6,
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),
        _buildSocialRow(colorScheme, isMobile: true),
      ],
    );
  }

  Widget _buildDesktopHero(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(colorScheme, 170),
        const SizedBox(width: 36),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [_buildAvailableBadge(colorScheme), const Spacer()],
              // ),
              // const SizedBox(height: 12),
              ShaderMask(
                shaderCallback:
                    (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFF818CF8),
                        Color(0xFF38BDF8),
                        Color(0xFFF472B6),
                      ],
                    ).createShader(bounds),
                child: const Text(
                  "Anil S. Yadav",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Flutter Developer & Mobile App Engineer",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.about,
                style: TextStyle(
                  height: 1.65,
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              _buildSocialRow(colorScheme, isMobile: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme, double size) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.surfaceContainerHigh,
        border: Border.all(
          color: colorScheme.primary.withAlpha(140),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'lib/assets/anil.png',
          fit: BoxFit.cover,
          // Limit GPU texture to the display size — avoids decoding 743KB at full res
          cacheWidth: (size * 2).toInt(), // 2× for HiDPI
          filterQuality: FilterQuality.medium,
          errorBuilder:
              (_, __, ___) => Container(
                color: colorScheme.surfaceContainerHigh,
                alignment: Alignment.center,
                child: Text(
                  "AY",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: size * 0.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildSocialRow(ColorScheme colorScheme, {required bool isMobile}) {
    return Wrap(
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      spacing: 12,
      runSpacing: 10,
      children:
          socialLinks.map((item) {
            return _SocialButton(
              name: item['name']!,
              iconPath: item['logo']!,
              onTap: () => _launchUrl(item['url']!),
              colorScheme: colorScheme,
            );
          }).toList(),
    );
  }

  // ================= SKILLS SECTION =================
  Widget _buildSkillsSection(ColorScheme colorScheme) {
    return Container(
      key: sectionKeys['skillsKey'],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.code_rounded,
            title: "Technical Skills",
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children:
                data.skills.map((skill) {
                  return _SkillChip(skill: skill, colorScheme: colorScheme);
                }).toList(),
          ),
        ],
      ),
    );
  }

  // ================= PROJECTS SECTION =================
  Widget _buildProjectsSection(ColorScheme colorScheme, bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 650 && screenWidth <= 1000;

    int displayLimit = isDesktop ? 4 : (isTablet ? 3 : 2);
    final projectsToShow = data.projects.take(displayLimit).toList();

    return Container(
      key: sectionKeys['projectsKey'],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _sectionHeader(
                icon: Icons.layers_rounded,
                title: "Featured Projects",
                colorScheme: colorScheme,
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () async {
                  await all_projects.loadLibrary();
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => all_projects.AllProjectsPage(
                            projects: data.projects,
                          ),
                    ),
                  );
                },
                label: const Text(
                  "View All",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 18,
              runSpacing: 18,
              alignment: WrapAlignment.center,
              children:
                  projectsToShow.map((proj) {
                    return _SoftProjectCard(
                      project: proj,
                      colorScheme: colorScheme,
                      onLaunch: _launchUrl,
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= EXPERIENCE & EDUCATION =================
  Widget _buildExperienceAndEducation(ColorScheme colorScheme, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _buildExperienceCard(colorScheme)),
          const SizedBox(width: 20),
          Expanded(flex: 2, child: _buildEducationCard(colorScheme)),
        ],
      );
    }

    return Column(
      children: [
        _buildExperienceCard(colorScheme),
        const SizedBox(height: 20),
        _buildEducationCard(colorScheme),
      ],
    );
  }

  Widget _buildExperienceCard(ColorScheme colorScheme) {
    return Container(
      key: sectionKeys['experienceKey'],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.work_history_rounded,
            title: "Work Experience",
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),
          ...data.experiences.asMap().entries.map((entry) {
            final isFirst = entry.key == 0;
            final isLast = entry.key == data.experiences.length - 1;
            final exp = entry.value;

            return _SoftTimelineTile(
              company: exp.company,
              title: exp.title,
              period: exp.time,
              description: exp.desc,
              colorScheme: colorScheme,
              isFirst: isFirst,
              isLast: isLast,
              icon: Icons.business_center_rounded,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEducationCard(ColorScheme colorScheme) {
    return Container(
      key: sectionKeys['educationKey'],
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(230),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            icon: Icons.school_rounded,
            title: "Education",
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 20),
          ...data.educations.asMap().entries.map((entry) {
            final isFirst = entry.key == 0;
            final isLast = entry.key == data.educations.length - 1;
            final edu = entry.value;

            return _SoftTimelineTile(
              company: edu.institution,
              title: edu.degree,
              period: edu.time,
              description: [edu.desc],
              colorScheme: colorScheme,
              isFirst: isFirst,
              isLast: isLast,
              icon: Icons.school_rounded,
            );
          }),
        ],
      ),
    );
  }

  // ================= CONTACT & SERVICES SECTION =================
  Widget _buildContactSection(
    ColorScheme colorScheme,
    bool isDesktop,
    bool isMobile,
  ) {
    return Container(
      key: sectionKeys['contactKey'],
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 36,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withAlpha(240),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(35)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildContactDetails(colorScheme)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    width: 1,
                    height: 180,
                    color: colorScheme.outlineVariant.withAlpha(40),
                  ),
                ),
                Expanded(flex: 4, child: _freelancingSection(colorScheme)),
              ],
            )
          else
            Column(
              children: [
                _buildContactDetails(colorScheme),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 24),
                _freelancingSection(colorScheme),
              ],
            ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 20),
          _buildFooter(colorScheme),
        ],
      ),
    );
  }

  Widget _buildContactDetails(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.alternate_email_rounded,
          title: "Get In Touch",
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        Text(
          "Have a project in mind or want to collaborate? Feel free to reach out anytime!",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _ContactChip(
              icon: Icons.email_rounded,
              label: "anilyadav44x@gmail.com",
              color: Colors.redAccent,
              onTap: () => _launchUrl("mailto:anilyadav44x@gmail.com"),
              colorScheme: colorScheme,
            ),
            _ContactChip(
              icon: Icons.phone_rounded,
              label: "+91 9892986314",
              color: Colors.green,
              onTap: () => _launchUrl("tel:+919892986314"),
              colorScheme: colorScheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _freelancingSection(ColorScheme colorScheme) {
    final services = [
      "Apps for Android & iOS",
      "Web App Development",
      "CRM & Admin Dashboards",
      "REST & Cloud API Integration",
      "UI/UX Implementation",
      "Performance Optimization",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.design_services_rounded,
          title: "Freelancing & Services",
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children:
              services.map((service) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooter(ColorScheme colorScheme) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        Text(
          "© ${DateTime.now().year} Anil S. Yadav",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withAlpha(180),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "• Built with Flutter Web & Firebase",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant.withAlpha(140),
            fontSize: 12,
          ),
        ),
        InkWell(
          onTap: () async {
            await login.loadLibrary();
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => login.LoginPage()),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              "Admin Portal",
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required ColorScheme colorScheme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: colorScheme.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

// ================= REUSABLE SOFT UI COMPONENTS =================

class _HoverNavButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _HoverNavButton({
    required this.text,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_HoverNavButton> createState() => _HoverNavButtonState();
}

class _HoverNavButtonState extends State<_HoverNavButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color:
                isHovered
                    ? widget.colorScheme.primary.withAlpha(25)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isHovered ? FontWeight.w600 : FontWeight.w500,
              color:
                  isHovered
                      ? widget.colorScheme.primary
                      : widget.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernResumeButton extends StatefulWidget {
  final String resumeUrl;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ModernResumeButton({
    required this.resumeUrl,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  State<_ModernResumeButton> createState() => _ModernResumeButtonState();
}

class _ModernResumeButtonState extends State<_ModernResumeButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, isHovered ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF6366F1), // Electric Indigo
                Color(0xFF8B5CF6), // Royal Violet
                Color(0xFFEC4899), // Neon Pink
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withAlpha(isHovered ? 120 : 60),
                blurRadius: isHovered ? 20 : 10,
                offset: Offset(0, isHovered ? 6 : 3),
              ),
              if (isHovered)
                BoxShadow(
                  color: const Color(0xFFEC4899).withAlpha(80),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.download_rounded, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                "Resume",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String name;
  final String iconPath;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _SocialButton({
    required this.name,
    required this.iconPath,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool isHovered = false;

  Color _getBrandColor(String name) {
    switch (name.toLowerCase()) {
      case 'google play':
      case 'play store':
        return const Color(0xFF10B981); // Emerald
      case 'github':
        return const Color(0xFF818CF8); // Indigo
      case 'linkedin':
        return const Color(0xFF0284C7); // Cyan
      case 'whatsapp':
        return const Color(0xFF22C55E); // Green
      default:
        return widget.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandColor = _getBrandColor(widget.name);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Tooltip(
        message: widget.name,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(0, isHovered ? -3 : 0, 0),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color:
                  isHovered
                      ? brandColor.withAlpha(35)
                      : widget.colorScheme.surfaceContainerHigh.withAlpha(120),
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isHovered
                        ? brandColor.withAlpha(180)
                        : widget.colorScheme.outlineVariant.withAlpha(40),
                width: isHovered ? 1.5 : 1.0,
              ),
              boxShadow:
                  isHovered
                      ? [
                        BoxShadow(
                          color: brandColor.withAlpha(90),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : [],
            ),
            child: Image.asset(
              widget.iconPath,
              width: 20,
              height: 20,
              errorBuilder:
                  (_, __, ___) =>
                      Icon(Icons.link_rounded, size: 20, color: brandColor),
            ),
          ),
        ),
      ),
    );
  }
}

Color _getSkillColor(String skill) {
  final s = skill.toLowerCase();
  if (s.contains('flutter')) return const Color(0xFF0284C7); // Sky Cyan
  if (s.contains('dart')) return const Color(0xFF3B82F6); // Blue
  if (s.contains('firebase')) return const Color(0xFFF59E0B); // Amber
  if (s.contains('rest') || s.contains('api'))
    return const Color(0xFF10B981); // Emerald
  if (s.contains('bloc') || s.contains('provider') || s.contains('state'))
    return const Color(0xFF8B5CF6); // Purple
  if (s.contains('git')) return const Color(0xFFEF4444); // Crimson
  if (s.contains('android') || s.contains('ios'))
    return const Color(0xFF06B6D4); // Aqua
  if (s.contains('ui') || s.contains('ux') || s.contains('design'))
    return const Color(0xFFEC4899); // Neon Pink
  if (s.contains('architecture') || s.contains('clean'))
    return const Color(0xFF6366F1); // Indigo
  if (s.contains('web') || s.contains('optimization'))
    return const Color(0xFF14B8A6); // Mint
  return const Color(0xFF818CF8);
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final ColorScheme colorScheme;

  const _SkillChip({required this.skill, required this.colorScheme});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final skillColor = _getSkillColor(widget.skill);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, isHovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isHovered ? skillColor.withAlpha(45) : skillColor.withAlpha(22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isHovered
                    ? skillColor.withAlpha(160)
                    : skillColor.withAlpha(60),
            width: isHovered ? 1.5 : 1.0,
          ),
          boxShadow:
              isHovered
                  ? [
                    BoxShadow(
                      color: skillColor.withAlpha(70),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: skillColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: skillColor.withAlpha(150),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.skill,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isHovered ? FontWeight.w700 : FontWeight.w500,
                color:
                    isHovered
                        ? widget.colorScheme.onSurface
                        : widget.colorScheme.onSurface.withAlpha(230),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoftProjectCard extends StatefulWidget {
  final Project project;
  final ColorScheme colorScheme;
  final Function(String) onLaunch;

  const _SoftProjectCard({
    required this.project,
    required this.colorScheme,
    required this.onLaunch,
  });

  @override
  State<_SoftProjectCard> createState() => _SoftProjectCardState();
}

class _SoftProjectCardState extends State<_SoftProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final proj = widget.project;
    final colorScheme = widget.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, isHovered ? -6 : 0, 0),
        width: 320,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color:
              isHovered
                  ? colorScheme.surfaceContainerHigh.withAlpha(240)
                  : colorScheme.surface.withAlpha(200),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isHovered
                    ? colorScheme.primary.withAlpha(80)
                    : colorScheme.outlineVariant.withAlpha(35),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isHovered
                      ? colorScheme.primary.withAlpha(30)
                      : colorScheme.shadow.withAlpha(10),
              blurRadius: isHovered ? 24 : 12,
              offset: Offset(0, isHovered ? 10 : 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withAlpha(120),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withAlpha(40),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child:
                        proj.icon.isNotEmpty
                            ? Image.network(
                              proj.icon,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Icon(
                                    Icons.apps_rounded,
                                    color: colorScheme.primary,
                                  ),
                            )
                            : Icon(
                              Icons.apps_rounded,
                              color: colorScheme.primary,
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    proj.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              proj.description,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                if (proj.playUrl.isNotEmpty)
                  _ProjectActionButton(
                    icon: "lib/assets/playstore.png",
                    label: "Play Store",
                    colorScheme: colorScheme,
                    onTap: () => widget.onLaunch(proj.playUrl),
                  ),
                if (proj.iosUrl.isNotEmpty)
                  _ProjectActionButton(
                    icon: "lib/assets/appstore.png",
                    label: "App Store",
                    colorScheme: colorScheme,
                    onTap: () => widget.onLaunch(proj.iosUrl),
                  ),
                if (proj.moreUrl.isNotEmpty)
                  _ProjectActionButton(
                    iconData: Icons.open_in_new_rounded,
                    label: "Details",
                    colorScheme: colorScheme,
                    onTap: () => widget.onLaunch(proj.moreUrl),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectActionButton extends StatefulWidget {
  final String? icon;
  final IconData? iconData;
  final String label;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _ProjectActionButton({
    this.icon,
    this.iconData,
    required this.label,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  State<_ProjectActionButton> createState() => _ProjectActionButtonState();
}

class _ProjectActionButtonState extends State<_ProjectActionButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color:
                isHovered
                    ? widget.colorScheme.primary.withAlpha(30)
                    : widget.colorScheme.surfaceContainerHighest.withAlpha(120),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isHovered
                      ? widget.colorScheme.primary.withAlpha(80)
                      : widget.colorScheme.outlineVariant.withAlpha(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null)
                Image.asset(
                  widget.icon!,
                  width: 14,
                  height: 14,
                  errorBuilder:
                      (_, __, ___) => Icon(
                        Icons.link,
                        size: 14,
                        color: widget.colorScheme.primary,
                      ),
                )
              else if (widget.iconData != null)
                Icon(
                  widget.iconData,
                  size: 14,
                  color: widget.colorScheme.primary,
                ),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      isHovered
                          ? widget.colorScheme.primary
                          : widget.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoftTimelineTile extends StatelessWidget {
  final String company;
  final String title;
  final String period;
  final List<String> description;
  final ColorScheme colorScheme;
  final bool isFirst;
  final bool isLast;
  final IconData icon;

  const _SoftTimelineTile({
    required this.company,
    required this.title,
    required this.period,
    required this.description,
    required this.colorScheme,
    required this.isFirst,
    required this.isLast,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.0,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 24,
        height: 24,
        color: colorScheme.primary,
        iconStyle: IconStyle(color: Colors.white, iconData: icon, fontSize: 14),
      ),
      beforeLineStyle: LineStyle(
        color: colorScheme.primary.withAlpha(50),
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: colorScheme.primary.withAlpha(50),
        thickness: 2,
      ),
      endChild: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface.withAlpha(200),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withAlpha(30)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(8),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    company,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            ...description.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _ContactChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  State<_ContactChip> createState() => _ContactChipState();
}

class _ContactChipState extends State<_ContactChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color:
                isHovered
                    ? widget.color.withAlpha(25)
                    : widget.colorScheme.surfaceContainerHighest.withAlpha(100),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  isHovered
                      ? widget.color.withAlpha(80)
                      : widget.colorScheme.outlineVariant.withAlpha(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: widget.color),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isHovered
                          ? widget.colorScheme.onSurface
                          : widget.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
