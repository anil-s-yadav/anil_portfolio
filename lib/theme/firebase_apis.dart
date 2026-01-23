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

      final projectsSnap =
          await _firestore.collection('projects').limit(4).get();

      final experienceSnap = await _firestore.collection('experiences').get();

      // final educationSnap = await _firestore.collection('education').get();

      return HomeData(
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
