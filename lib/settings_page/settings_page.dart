import 'dart:developer';

import 'package:anil_portfolio/models.dart';
import 'package:anil_portfolio/firebase_apis.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Basic controllers
  final _aboutCtlr  = TextEditingController();
  final _resumeCtlr = TextEditingController();
  final _skillCtlr  = TextEditingController();

  // Project dialog controllers
  final _prTitle   = TextEditingController();
  final _prDesc    = TextEditingController();
  final _prIcon    = TextEditingController();
  final _prPlay    = TextEditingController();
  final _prIos     = TextEditingController();
  final _prMore    = TextEditingController();

  // Experience dialog controllers
  final _expCompany = TextEditingController();
  final _expTitle   = TextEditingController();
  final _expTime    = TextEditingController();
  final _expDesc    = TextEditingController(); // newline-separated

  // Education dialog controllers
  final _eduInst   = TextEditingController();
  final _eduDegree = TextEditingController();
  final _eduTime   = TextEditingController();
  final _eduDesc   = TextEditingController();

  final HomeController controller = HomeController();

  // Local mutable lists for drag-reorder (copies of Firestore data)
  List<String>     _skills      = [];
  List<Project>    _projects    = [];
  List<Experience> _experiences = [];
  List<Education>  _educations  = [];

  // Tracks if ordering has changed (enables Save Order button)
  bool _projectsReordered    = false;
  bool _experiencesReordered = false;
  bool _educationsReordered  = false;

  @override
  void initState() {
    super.initState();
    _syncFromController();
    _loadData();
  }

  void _syncFromController() {
    final d = controller.homeData;
    _resumeCtlr.text = d.resume;
    _aboutCtlr.text  = d.about;
    _skills      = List.from(d.skills);
    _projects    = List.from(d.projects);
    _experiences = List.from(d.experiences);
    _educations  = List.from(d.educations);
    _projectsReordered    = false;
    _experiencesReordered = false;
    _educationsReordered  = false;
  }

  void _loadData({bool showSnack = false}) {
    controller.loadHome(forceRefresh: true).then((_) {
      if (!mounted) return;
      _syncFromController();
      if (showSnack) {
        _snack("Page Reloaded!", Colors.green);
      }
      setState(() {});
    });
  }

  void _snack(String msg, Color bg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: bg),
    );
  }

  void _showResult(bool ok, [String? msg]) =>
      _snack(msg ?? (ok ? "Saved!" : "Operation failed!"), ok ? Colors.green : Colors.red);

  @override
  void dispose() {
    for (final c in [
      _aboutCtlr, _resumeCtlr, _skillCtlr,
      _prTitle, _prDesc, _prIcon, _prPlay, _prIos, _prMore,
      _expCompany, _expTitle, _expTime, _expDesc,
      _eduInst, _eduDegree, _eduTime, _eduDesc,
    ]) { c.dispose(); }
    super.dispose();
  }

  // ───────────────────────────────────────────────
  // BUILD
  // ───────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: "Refresh",
            onPressed: () => _loadData(showSnack: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _section(color, "Resume URL",          Icons.description_outlined,       _resumeSection(color)),
                _section(color, "About",               Icons.person_outline,             _aboutSection(color)),
                _section(color, "Skills & Tech",       Icons.code_rounded,               _skillsSection(color)),
                _section(color, "Projects",            Icons.work_outline,               _projectsSection(color)),
                _section(color, "Experience",          Icons.business_center_outlined,   _experienceSection(color)),
                _section(color, "Education",           Icons.school_outlined,            _educationSection(color)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // EXPANSION TILE WRAPPER
  // ───────────────────────────────────────────────
  Widget _section(ColorScheme color, String title, IconData icon, Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outline.withAlpha(40)),
        boxShadow: [
          BoxShadow(color: color.shadow.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            leading: Icon(icon, color: color.primary),
            title: Text(title,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color.onSurface)),
            children: [child],
          ),
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // SHARED WIDGETS
  // ───────────────────────────────────────────────
  Widget _saveBtn(String label, VoidCallback onPressed) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save_rounded, size: 17),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _addBtn(String label, VoidCallback onPressed, ColorScheme color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  InputDecoration _field(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
      );

  // ───────────────────────────────────────────────
  // RESUME SECTION
  // ───────────────────────────────────────────────
  Widget _resumeSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(controller: _resumeCtlr, decoration: _field("Resume PDF URL")),
      const SizedBox(height: 12),
      _saveBtn("Save URL", () async {
        final ok = await EditData().updateResumeUrl(_resumeCtlr.text);
        _showResult(ok);
      }),
    ]);
  }

  // ───────────────────────────────────────────────
  // ABOUT SECTION
  // ───────────────────────────────────────────────
  Widget _aboutSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      TextField(
        controller: _aboutCtlr,
        maxLines: 5,
        minLines: 3,
        decoration: _field("About Text"),
      ),
      const SizedBox(height: 12),
      _saveBtn("Save About", () async {
        final ok = await EditData().updateAbout(_aboutCtlr.text);
        _showResult(ok);
      }),
    ]);
  }

  // ───────────────────────────────────────────────
  // SKILLS SECTION  (ReorderableListView)
  // ───────────────────────────────────────────────
  Widget _skillsSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Drag-to-reorder list
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _skills.length,
        onReorderItem: (oldIdx, newIdx) {
          final item = _skills.removeAt(oldIdx);
          _skills.insert(newIdx, item);
          setState(() {});
        },
        itemBuilder: (ctx, i) {
          final skill = _skills[i];
          return Card(
            key: ValueKey(skill),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: color.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color.outline.withAlpha(30)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              leading: ReorderableDragStartListener(
                index: i,
                child: Icon(Icons.drag_handle_rounded, color: color.onSurfaceVariant),
              ),
              title: Text(skill, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              trailing: IconButton(
                icon: Icon(Icons.cancel_outlined, color: color.error, size: 20),
                onPressed: () {
                  _skills.removeAt(i);
                  setState(() {});
                  log("Deleted skill: $skill");
                },
              ),
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      // Add new skill
      Row(children: [
        Expanded(
          child: TextField(
            controller: _skillCtlr,
            decoration: _field("New skill (press Enter or +)"),
            onSubmitted: (v) { if (v.trim().isNotEmpty) { _skills.add(v.trim()); _skillCtlr.clear(); setState(() {}); } },
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (_skillCtlr.text.trim().isNotEmpty) {
              _skills.add(_skillCtlr.text.trim());
              _skillCtlr.clear();
              setState(() {});
            }
          },
        ),
      ]),
      const SizedBox(height: 12),
      _saveBtn("Save Skills & Order", () async {
        final ok = await EditData().updateSkills(_skills);
        _showResult(ok);
        if (ok) setState(() {});
      }),
    ]);
  }

  // ───────────────────────────────────────────────
  // PROJECTS SECTION  (ReorderableListView)
  // ───────────────────────────────────────────────
  Widget _projectsSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Reorder notice + Save Order button (shown when order changed)
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _projectsReordered
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Icon(Icons.swap_vert_rounded, size: 16, color: color.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Order changed — save to apply", style: TextStyle(fontSize: 12, color: color.primary))),
                  TextButton(onPressed: _saveProjectOrder, child: const Text("Save Order")),
                ]),
              )
            : const SizedBox.shrink(key: ValueKey('no-reorder')),
      ),
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _projects.length,
        onReorderItem: (oldIdx, newIdx) {
          final item = _projects.removeAt(oldIdx);
          _projects.insert(newIdx, item);
          _projectsReordered = true;
          setState(() {});
        },
        itemBuilder: (ctx, i) {
          final pr = _projects[i];
          return Card(
            key: ValueKey(pr.id),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: color.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color.outline.withAlpha(30)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              leading: ReorderableDragStartListener(
                index: i,
                child: Icon(Icons.drag_handle_rounded, color: color.onSurfaceVariant),
              ),
              title: Text(pr.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(pr.description, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: color.onSurfaceVariant)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.edit_rounded, color: color.primary, size: 20),
                  onPressed: () => _showProjectDialog(project: pr),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: color.error, size: 20),
                  onPressed: () => _confirmDelete("Delete project \"${pr.title}\"?", () async {
                    final ok = await EditData().deleteProject(pr.id);
                    _showResult(ok);
                    if (ok) _loadData();
                  }),
                ),
              ]),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      _addBtn("Add Project", () => _showProjectDialog(), color),
    ]);
  }

  Future<void> _saveProjectOrder() async {
    final ids = _projects.map((p) => p.id).toList();
    final ok = await EditData().reorderProjects(ids);
    _projectsReordered = false;
    _showResult(ok, ok ? "Project order saved!" : "Failed to save order");
    setState(() {});
  }

  // ───────────────────────────────────────────────
  // EXPERIENCE SECTION  (ReorderableListView)
  // ───────────────────────────────────────────────
  Widget _experienceSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _experiencesReordered
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Icon(Icons.swap_vert_rounded, size: 16, color: color.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Order changed — save to apply", style: TextStyle(fontSize: 12, color: color.primary))),
                  TextButton(onPressed: _saveExperienceOrder, child: const Text("Save Order")),
                ]),
              )
            : const SizedBox.shrink(key: ValueKey('no-reorder-exp')),
      ),
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _experiences.length,
        onReorderItem: (oldIdx, newIdx) {
          final item = _experiences.removeAt(oldIdx);
          _experiences.insert(newIdx, item);
          _experiencesReordered = true;
          setState(() {});
        },
        itemBuilder: (ctx, i) {
          final ex = _experiences[i];
          return Card(
            key: ValueKey(ex.id),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: color.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color.outline.withAlpha(30)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              leading: ReorderableDragStartListener(
                index: i,
                child: Icon(Icons.drag_handle_rounded, color: color.onSurfaceVariant),
              ),
              title: Text("${ex.title} @ ${ex.company}",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(ex.time, style: TextStyle(fontSize: 12, color: color.primary)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.edit_rounded, color: color.primary, size: 20),
                  onPressed: () => _showExperienceDialog(exp: ex),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: color.error, size: 20),
                  onPressed: () => _confirmDelete("Delete experience at \"${ex.company}\"?", () async {
                    final ok = await EditData().deleteExperience(ex.id);
                    _showResult(ok);
                    if (ok) _loadData();
                  }),
                ),
              ]),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      _addBtn("Add Experience", () => _showExperienceDialog(), color),
    ]);
  }

  Future<void> _saveExperienceOrder() async {
    final ids = _experiences.map((e) => e.id).toList();
    final ok = await EditData().reorderExperiences(ids);
    _experiencesReordered = false;
    _showResult(ok, ok ? "Experience order saved!" : "Failed to save order");
    setState(() {});
  }

  // ───────────────────────────────────────────────
  // EDUCATION SECTION  (ReorderableListView)
  // ───────────────────────────────────────────────
  Widget _educationSection(ColorScheme color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _educationsReordered
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Icon(Icons.swap_vert_rounded, size: 16, color: color.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text("Order changed — save to apply", style: TextStyle(fontSize: 12, color: color.primary))),
                  TextButton(onPressed: _saveEducationOrder, child: const Text("Save Order")),
                ]),
              )
            : const SizedBox.shrink(key: ValueKey('no-reorder-edu')),
      ),
      ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        itemCount: _educations.length,
        onReorderItem: (oldIdx, newIdx) {
          final item = _educations.removeAt(oldIdx);
          _educations.insert(newIdx, item);
          _educationsReordered = true;
          setState(() {});
        },
        itemBuilder: (ctx, i) {
          final edu = _educations[i];
          return Card(
            key: ValueKey(edu.id),
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: color.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: color.outline.withAlpha(30)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              leading: ReorderableDragStartListener(
                index: i,
                child: Icon(Icons.drag_handle_rounded, color: color.onSurfaceVariant),
              ),
              title: Text(edu.degree,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text("${edu.institution}  ·  ${edu.time}",
                  style: TextStyle(fontSize: 12, color: color.onSurfaceVariant)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(
                  icon: Icon(Icons.edit_rounded, color: color.primary, size: 20),
                  onPressed: () => _showEducationDialog(edu: edu),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: color.error, size: 20),
                  onPressed: () => _confirmDelete("Delete \"${edu.degree}\"?", () async {
                    final ok = await EditData().deleteEducation(edu.id);
                    _showResult(ok);
                    if (ok) _loadData();
                  }),
                ),
              ]),
            ),
          );
        },
      ),
      const SizedBox(height: 10),
      _addBtn("Add Education", () => _showEducationDialog(), color),
    ]);
  }

  Future<void> _saveEducationOrder() async {
    final ids = _educations.map((e) => e.id).toList();
    final ok = await EditData().reorderEducations(ids);
    _educationsReordered = false;
    _showResult(ok, ok ? "Education order saved!" : "Failed to save order");
    setState(() {});
  }

  // ───────────────────────────────────────────────
  // SHARED CONFIRM DELETE DIALOG
  // ───────────────────────────────────────────────
  void _confirmDelete(String message, Future<void> Function() onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await onConfirm();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // PROJECT ADD / EDIT DIALOG
  // ───────────────────────────────────────────────
  void _showProjectDialog({Project? project}) {
    final isEdit = project != null;
    if (isEdit) {
      _prTitle.text = project.title;
      _prDesc.text  = project.description;
      _prIcon.text  = project.icon;
      _prPlay.text  = project.playUrl;
      _prIos.text   = project.iosUrl;
      _prMore.text  = project.moreUrl;
    } else {
      _prTitle.clear(); _prDesc.clear(); _prIcon.clear();
      _prPlay.clear();  _prIos.clear();  _prMore.clear();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Edit Project" : "Add Project"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _prTitle, decoration: _field("Title")),
            const SizedBox(height: 8),
            TextField(controller: _prIcon, decoration: _field("Icon emoji or URL")),
            const SizedBox(height: 8),
            TextField(controller: _prDesc, maxLines: 3, decoration: _field("Description")),
            const SizedBox(height: 8),
            TextField(controller: _prPlay, decoration: _field("Google Play URL")),
            const SizedBox(height: 8),
            TextField(controller: _prIos, decoration: _field("iOS App Store URL")),
            const SizedBox(height: 8),
            TextField(controller: _prMore, decoration: _field("GitHub / More URL")),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final p = Project(
                id: isEdit ? project.id : "",
                title: _prTitle.text.trim(),
                description: _prDesc.text.trim(),
                icon: _prIcon.text.trim(),
                playUrl: _prPlay.text.trim(),
                iosUrl: _prIos.text.trim(),
                moreUrl: _prMore.text.trim(),
              );
              final ok = isEdit
                  ? await EditData().updateProject(p, project.id)
                  : await EditData().addProject(p);
              if (!mounted) return;
              Navigator.pop(ctx);
              _showResult(ok);
              if (ok) _loadData();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // EXPERIENCE ADD / EDIT DIALOG
  // ───────────────────────────────────────────────
  void _showExperienceDialog({Experience? exp}) {
    final isEdit = exp != null;
    if (isEdit) {
      _expCompany.text = exp.company;
      _expTitle.text   = exp.title;
      _expTime.text    = exp.time;
      _expDesc.text    = exp.desc.join('\n'); // one bullet per line
    } else {
      _expCompany.clear(); _expTitle.clear();
      _expTime.clear();    _expDesc.clear();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Edit Experience" : "Add Experience"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _expTitle, decoration: _field("Job Title")),
            const SizedBox(height: 8),
            TextField(controller: _expCompany, decoration: _field("Company & Location")),
            const SizedBox(height: 8),
            TextField(controller: _expTime, decoration: _field("Duration (e.g. Jan 2024 - Present)")),
            const SizedBox(height: 8),
            TextField(
              controller: _expDesc,
              maxLines: 5,
              decoration: _field("Key highlights (one per line)"),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final descLines = _expDesc.text
                  .split('\n')
                  .map((l) => l.trim())
                  .where((l) => l.isNotEmpty)
                  .toList();
              final e = Experience(
                id: isEdit ? exp.id : '',
                title: _expTitle.text.trim(),
                company: _expCompany.text.trim(),
                time: _expTime.text.trim(),
                desc: descLines,
              );
              final ok = isEdit
                  ? await EditData().updateExperience(exp.id, e)
                  : await EditData().addExperience(e);
              if (!mounted) return;
              Navigator.pop(ctx);
              _showResult(ok);
              if (ok) _loadData();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────
  // EDUCATION ADD / EDIT DIALOG
  // ───────────────────────────────────────────────
  void _showEducationDialog({Education? edu}) {
    final isEdit = edu != null;
    if (isEdit) {
      _eduInst.text   = edu.institution;
      _eduDegree.text = edu.degree;
      _eduTime.text   = edu.time;
      _eduDesc.text   = edu.desc;
    } else {
      _eduInst.clear(); _eduDegree.clear();
      _eduTime.clear(); _eduDesc.clear();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Edit Education" : "Add Education"),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: _eduDegree, decoration: _field("Degree / Course")),
            const SizedBox(height: 8),
            TextField(controller: _eduInst, decoration: _field("Institution / College")),
            const SizedBox(height: 8),
            TextField(controller: _eduTime, decoration: _field("Year (e.g. 2020 - 2024)")),
            const SizedBox(height: 8),
            TextField(
              controller: _eduDesc,
              maxLines: 3,
              decoration: _field("Description / Achievements"),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final e = Education(
                id: isEdit ? edu.id : '',
                institution: _eduInst.text.trim(),
                degree: _eduDegree.text.trim(),
                time: _eduTime.text.trim(),
                desc: _eduDesc.text.trim(),
              );
              final ok = isEdit
                  ? await EditData().updateEducation(edu.id, e)
                  : await EditData().addEducation(e);
              if (!mounted) return;
              Navigator.pop(ctx);
              _showResult(ok);
              if (ok) _loadData();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
