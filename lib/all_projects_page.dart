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
  String searchQuery = '';

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
    final isMobile = screenWidth <= 650;

    final filteredProjects =
        widget.projects.where((p) {
          final query = searchQuery.toLowerCase();
          return p.title.toLowerCase().contains(query) ||
              p.description.toLowerCase().contains(query);
        }).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer.withAlpha(200),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.primary,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "All Projects (${widget.projects.length})",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 40,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow.withAlpha(220),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(35),
                      ),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.primary,
                        ),
                        hintText: "Search projects by name or technology...",
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant.withAlpha(150),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Project Grid
                  if (filteredProjects.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Text(
                          "No projects matching '$searchQuery'",
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Wrap(
                        spacing: 18,
                        runSpacing: 18,
                        alignment: WrapAlignment.center,
                        children:
                            filteredProjects.map((proj) {
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
            ),
          ),
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
                  : colorScheme.surfaceContainerLow.withAlpha(220),
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
              maxLines: 4,
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
