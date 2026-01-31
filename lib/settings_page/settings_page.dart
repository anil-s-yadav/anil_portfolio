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
  final aboutCnlrt = TextEditingController();
  final resumeCnlrt = TextEditingController();
  final skillsCnlrt = TextEditingController();
  final prIconCtlr = TextEditingController();
  final prTitleCtlr = TextEditingController();
  final prDescCtlr = TextEditingController();
  final prIOSUrlCtlr = TextEditingController();
  final prMoreUrlCtlr = TextEditingController();
  final prPlayUrlCtlr = TextEditingController();
  bool isResume = false;
  bool isAbout = false;
  bool isSkills = false;
  bool isProjects = false;
  bool isExperience = false;
  bool isEducation = false;

  final HomeController controller = HomeController();
  late HomeData data;
  late List<String> newSkills;
  @override
  void initState() {
    super.initState();
    loadAlldata();
  }

  void loadAlldata({bool isResetBtn = false}) {
    controller.loadHome().then((onValue) {
      resumeCnlrt.text = controller.homeData?.resume ?? "error";
      aboutCnlrt.text = controller.homeData?.about ?? "error";
      if (isResetBtn == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Page Reloaded!"),
            backgroundColor: Colors.green,
          ),
        );
      }
      newSkills = controller.homeData?.skills ?? ["error"];
      setState(() {});
    });
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
      appBar: AppBar(
        title: const Text("Settingss"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => loadAlldata(isResetBtn: true),
            icon: Icon(Icons.replay_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                editOpt(
                  color,
                  "Edit Resume url",
                  () => setState(() => isResume = !isResume),
                ),
                editOpt(
                  color,
                  "Edit About section",
                  () => setState(() => isAbout = !isAbout),
                ),
                editOpt(
                  color,
                  "Edit Skills section",
                  () => setState(() => isSkills = !isSkills),
                ),
                editOpt(
                  color,
                  "Edit Projects section",
                  () => setState(() => isProjects = true),
                ),
                editOpt(
                  color,
                  "Edit Experience section",
                  () => setState(() => isExperience = true),
                ),
                editOpt(
                  color,
                  "Edit Education section",

                  // () => setState(() => isEducation = true),
                  () {},
                ),
                Visibility(
                  visible: isResume == true,
                  child: editresumeUrl(color),
                ),
                Visibility(visible: isAbout == true, child: editAbout(color)),
                Visibility(visible: isSkills == true, child: editSkills(color)),
                Visibility(
                  visible: isProjects == true,
                  child: editProjects(color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editOpt(ColorScheme color, String title, GestureTapCallback? ontap) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: ontap,
        child: Container(
          width: isDesktop ? size.width * 0.4 : size.width * 0.8,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.outline.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: color.tertiary.withAlpha(20),
                blurRadius: 8,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget editresumeUrl(ColorScheme color) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Container(
      width: isDesktop ? size.width * 0.4 : size.width * 0.8,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: color.tertiary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            child: Row(
              spacing: 20,
              children: [
                Text("Edit Resume Url"),
                OutlinedButton(
                  onPressed: () => setState(() => isResume = false),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await EditData().updateResumeUrl(
                      resumeCnlrt.text,
                    );
                    if (res == true) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Success")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Operation failled!")),
                      );
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
          Divider(),
          TextField(
            controller: resumeCnlrt,
            // keyboardType: TextInputType.multiline,
            // maxLength: 150,
            // maxLines: null,
            // minLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: color.outline.withAlpha(50)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editAbout(ColorScheme color) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Container(
      width: isDesktop ? size.width * 0.4 : size.width * 0.8,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.outline.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: color.tertiary.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          FittedBox(
            child: Row(
              spacing: 20,
              children: [
                Text("Edit About Section"),
                OutlinedButton(
                  onPressed: () => setState(() => isAbout = false),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await EditData().updateAbout(aboutCnlrt.text);
                    if (res == true) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Success")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Operation failled!")),
                      );
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
          Divider(),
          TextField(
            controller: aboutCnlrt,
            keyboardType: TextInputType.multiline,
            // maxLength: 150,
            maxLines: null,
            minLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: color.outline.withAlpha(50)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editSkills(ColorScheme color) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Container(
      // height: 100, //testing delete later
      // key: sectionKeys['skillsKey'],
      width: isDesktop ? size.width * 0.6 : size.width,
      margin: EdgeInsets.all(20),
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
          FittedBox(
            child: Row(
              spacing: 20,
              children: [
                Text("Edit Skills"),
                OutlinedButton(
                  onPressed: () => setState(() => isSkills = false),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final res = await EditData().updateSkills(newSkills);
                    if (res == true) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Success")));
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Operation failled!")),
                      );
                    }
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
          // Divider(),
          SizedBox(height: 10),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children:
                newSkills.map((skill) {
                  return Chip(
                    deleteIcon: const Icon(Icons.cancel),
                    onDeleted: () {
                      // Your delete logic here
                      newSkills.remove(skill);
                      setState(() {});
                      log("Deleted: $skill");
                    },
                    label: Text(skill),
                    labelStyle: TextStyle(fontSize: 11, color: color.tertiary),
                  );
                }).toList(),
          ),
          // SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(top: 10),
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
            child: TextField(
              controller: skillsCnlrt,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.all(5),
                suffix: IconButton(
                  onPressed: () {
                    if (skillsCnlrt.text.isNotEmpty) {
                      newSkills.add(skillsCnlrt.text);
                      log(newSkills.toString());
                      skillsCnlrt.clear();
                      setState(() {});
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  icon: Icon(Icons.done),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editProjects(ColorScheme color) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 600;

    return Container(
      // height: 100, //testing delete later
      // key: sectionKeys['skillsKey'],
      width: isDesktop ? size.width * 0.6 : size.width,
      margin: EdgeInsets.all(20),
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
          FittedBox(
            child: Row(
              spacing: 20,
              children: [
                Text("Edit Projects"),
                OutlinedButton(
                  onPressed: () => setState(() => isProjects = false),
                  child: Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text("Operation failled!")),
                    // );
                    showAddEditProjectDialog();
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          // Divider(),
          SizedBox(height: 10),
          ...controller.homeData!.projects.map((pr) {
            return TextButton.icon(
              icon: Icon(Icons.edit),
              iconAlignment: IconAlignment.end,
              onPressed: () {
                showAddEditProjectDialog(isUpdate: true, prj: pr);
              },
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pr.title),
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("confirm"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final res = await EditData().deleteProject(
                                      // pr.id,
                                      pr.id,
                                    );
                                    if (res == true) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text("Success")),
                                      );
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("Project not found!"),
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text("delete"),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              // style: ButtonStyle(),
            );
          }).toList(),
        ],
      ),
    );
  }

  void showAddEditProjectDialog({bool isUpdate = false, Project? prj}) {
    if (isUpdate == true && prj != null) {
      prTitleCtlr.text = prj.title;
      prDescCtlr.text = prj.description;
      prIconCtlr.text = prj.icon;
      prIOSUrlCtlr.text = prj.iosUrl;
      prMoreUrlCtlr.text = prj.moreUrl;
      prPlayUrlCtlr.text = prj.playUrl;
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            title: TextField(
              controller: prTitleCtlr,
              decoration: InputDecoration(hintText: "Title"),
            ),
            icon: TextField(
              controller: prIconCtlr,
              decoration: InputDecoration(hintText: "Icon"),
            ),
            content: Column(
              children: [
                TextField(
                  controller: prDescCtlr,
                  decoration: InputDecoration(hintText: "Decs"),
                ),
                TextField(
                  controller: prIOSUrlCtlr,
                  decoration: InputDecoration(hintText: "ios_url"),
                ),
                TextField(
                  controller: prPlayUrlCtlr,
                  decoration: InputDecoration(hintText: "play_url"),
                ),
                TextField(
                  controller: prMoreUrlCtlr,
                  decoration: InputDecoration(hintText: "more_url"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  bool res;
                  if (isUpdate == true) {
                    res = await EditData().updateProject(
                      Project(
                        id: prj!.id,
                        title: prTitleCtlr.text,
                        description: prDescCtlr.text,
                        icon: prIconCtlr.text,
                        moreUrl: prMoreUrlCtlr.text,
                        playUrl: prPlayUrlCtlr.text,
                        iosUrl: prIOSUrlCtlr.text,
                      ),
                      prj!.id,
                    );
                  } else {
                    res = await EditData().addProject(
                      Project(
                        id: "",
                        title: prTitleCtlr.text,
                        description: prDescCtlr.text,
                        icon: prIconCtlr.text,
                        moreUrl: prMoreUrlCtlr.text,
                        playUrl: prPlayUrlCtlr.text,
                        iosUrl: prIOSUrlCtlr.text,
                      ),
                    );
                  }
                  if (res == true) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Success")));
                    prTitleCtlr.clear();
                    prDescCtlr.clear();
                    prIconCtlr.clear();
                    prIOSUrlCtlr.clear();
                    prPlayUrlCtlr.clear();
                    prMoreUrlCtlr.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Project not found!")),
                    );
                  }
                  Navigator.pop(context);
                },
                child: Text("Done"),
              ),
            ],
          ),
    );
  }
}
