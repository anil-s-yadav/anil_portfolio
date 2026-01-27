import 'dart:developer';

import 'package:anil_portfolio/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> loginUser({
  required String mobile,
  required String password,
}) async {
  try {
    final doc =
        await FirebaseFirestore.instance.collection('login').doc('login').get();

    if (!doc.exists) {
      return false;
    }

    final data = doc.data()!;

    final storedMobile = data['mobile'];
    final storedPassword = data['password'];

    if (mobile == storedMobile && password == storedPassword) {
      return true; // Login success
    } else {
      return false; // Wrong credentials
    }
  } catch (e) {
    log("Login error: $e");
    return false;
  }
}

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeData> fetchHomeData() async {
    try {
      final resumeSnap =
          await _firestore
              .collection('resume')
              .doc('HP5nbvwB4U74ppRuK57G')
              .get();
      final aboutSnap =
          await _firestore
              .collection('about')
              .doc('ZRpjpfQ2Xv2UJrOsVrBO')
              .get();

      final skillsSnap =
          await _firestore
              .collection('skills')
              .doc('SswwVql6AcZXOlGhDaX1')
              .get();

      final projectsSnap = await _firestore.collection('projects').get();

      final experienceSnap = await _firestore.collection('experiences').get();

      // final educationSnap = await _firestore.collection('education').get();

      return HomeData(
        resume: resumeSnap.data()?['url']?.toString() ?? '',
        about: aboutSnap.data()?['about']?.toString() ?? '',

        skills:
            (skillsSnap.data()?['skills'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .toList(),

        projects:
            projectsSnap.docs
                .map((doc) => Project.fromFirestore(doc.data(), doc.id))
                .toList(),

        experiences:
            experienceSnap.docs
                .map((doc) => Experience.fromFirestore(doc.data(), doc.id))
                .toList(),
      );
    } catch (e, stack) {
      print('HomeRepository error: $e');
      print(stack);
      rethrow;
    }
  }
}

class HomeController {
  final HomeRepository _repo = HomeRepository();

  HomeData? homeData;
  bool isLoading = true;
  String? error;

  Future<void> loadHome() async {
    try {
      isLoading = true;
      homeData = await _repo.fetchHomeData();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}

class EditData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= ABOUT =================

  Future<bool> updateAbout(String newAbout) async {
    try {
      await _firestore.collection('about').doc('ZRpjpfQ2Xv2UJrOsVrBO').update({
        'about': newAbout,
      });

      return true;
    } catch (e) {
      log('Update About Error: $e');
      return false;
    }
  }

  Future<bool> deleteAbout() async {
    try {
      await _firestore.collection('about').doc('ZRpjpfQ2Xv2UJrOsVrBO').delete();

      return true;
    } catch (e) {
      log('Delete About Error: $e');
      return false;
    }
  }

  // ================= SKILLS =================

  Future<bool> updateSkills(List<String> skills) async {
    try {
      await _firestore.collection('skills').doc('SswwVql6AcZXOlGhDaX1').update({
        'skills': skills,
      });

      return true;
    } catch (e) {
      log('Update Skills Error: $e');
      return false;
    }
  }

  Future<bool> deleteSkills() async {
    try {
      await _firestore
          .collection('skills')
          .doc('SswwVql6AcZXOlGhDaX1')
          .delete();

      return true;
    } catch (e) {
      log('Delete Skills Error: $e');
      return false;
    }
  }

  // ================= PROJECTS =================

  Future<bool> addProject(Project project) async {
    try {
      await _firestore.collection('projects').add({
        'title': project.title,
        'description': project.description,
        'icon': project.icon,
        'url': project.url,
      });

      return true;
    } catch (e) {
      log('Add Project Error: $e');
      return false;
    }
  }

  Future<bool> updateProject(Project project) async {
    try {
      await _firestore.collection('projects').doc(project.id).update({
        'title': project.title,
        'description': project.description,
        'icon': project.icon,
        'url': project.url,
      });

      return true;
    } catch (e) {
      log('Update Project Error: $e');
      return false;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();

      return true;
    } catch (e) {
      log('Delete Project Error: $e');
      return false;
    }
  }

  // ================= EXPERIENCE =================

  Future<bool> addExperience(Experience exp) async {
    try {
      await _firestore.collection('experiences').add({
        'company': exp.company,
        'title': exp.title,
        'time': exp.time,
        'desc': exp.desc,
      });

      return true;
    } catch (e) {
      log('Add Experience Error: $e');
      return false;
    }
  }

  Future<bool> updateExperience(String docId, Experience exp) async {
    try {
      await _firestore.collection('experiences').doc(docId).update({
        'company': exp.company,
        'title': exp.title,
        'time': exp.time,
        'desc': exp.desc,
      });

      return true;
    } catch (e) {
      log('Update Experience Error: $e');
      return false;
    }
  }

  Future<bool> deleteExperience(String docId) async {
    try {
      await _firestore.collection('experiences').doc(docId).delete();

      return true;
    } catch (e) {
      log('Delete Experience Error: $e');
      return false;
    }
  }
}
