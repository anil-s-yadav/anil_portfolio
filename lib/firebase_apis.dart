import 'dart:developer';

import 'package:anil_portfolio/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
//  In-memory singleton cache — data fetched once per session
// ============================================================
class _HomeCache {
  static HomeData? _data;
  static HomeData? get cached => _data;
  static void store(HomeData d) => _data = d;
  static bool get hasData => _data != null;
  static void invalidate() => _data = null;
}

// ============================================================
//  Login
// ============================================================
Future<bool> loginUser({
  required String mobile,
  required String password,
}) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('login')
        .doc('login')
        .get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    return mobile == data['mobile'] && password == data['password'];
  } catch (e) {
    log("Login error: $e");
    return false;
  }
}

// ============================================================
//  Repository — parallel Firestore fetch with cache
// ============================================================
class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static HomeData get initialDefaultData => HomeData(
        resume: '',
        about:
            'A passionate Flutter developer with experience building beautiful, high-performance cross-platform apps. My focus is on writing clean, maintainable code and delivering pixel-perfect UI with smooth user experiences. Proficient in Firebase, REST APIs, state management, and modern responsive design.',
        skills: [
          'Flutter',
          'Dart',
          'Firebase',
          'REST APIs',
          'Bloc / Provider',
          'Git & GitHub',
          'Android / iOS',
          'UI/UX Design',
          'Clean Architecture',
          'Web Optimization',
        ],
        projects: [
          Project(
            id: 'default-1',
            title: 'Flutter Mobile & Web Apps',
            description:
                'High performance, responsive multiplatform applications with dynamic Firebase backend.',
            icon: '',
            moreUrl: 'https://github.com/anil-s-yadav',
            playUrl:
                'https://play.google.com/store/apps/dev?id=8832237281097064209',
            iosUrl: '',
            order: 0,
          ),
        ],
        experiences: [
          Experience(
            id: 'default-exp-1',
            company: 'V-Trans India – Mumbai, India',
            title: 'Flutter Developer',
            time: 'Jan 2026 - Present',
            desc: [
              'Developing and maintaining custom enterprise Flutter applications.',
              'Delivering high-performance responsive UI and cloud integrations.',
            ],
            order: 0,
          ),
          Experience(
            id: 'default-exp-2',
            company: 'Kaamwalibais – Mumbai, India',
            title: 'Flutter Developer',
            time: 'Dec 2024 - Dec 2025',
            desc: [
              'Developed and maintained custom Flutter-based apps for company services.',
              'Implemented real-time features and state management solutions.',
            ],
            order: 1,
          ),
        ],
        educations: [
          Education(
            id: 'default-edu-1',
            institution: 'Your College / University',
            degree: 'B.E. / B.Tech in Computer Science',
            time: '2020 - 2024',
            desc: 'Relevant coursework and achievements.',
            order: 0,
          ),
        ],
      );

  Future<HomeData> fetchHomeData({bool forceRefresh = false}) async {
    // Serve from in-memory cache instantly unless forced refresh
    if (!forceRefresh && _HomeCache.hasData) return _HomeCache.cached!;

    try {
      // All 6 queries fire in parallel — no sequential waiting
      final results = await Future.wait([
        _firestore
            .collection('resume')
            .doc('HP5nbvwB4U74ppRuK57G')
            .get(const GetOptions(source: Source.serverAndCache)),
        _firestore
            .collection('about')
            .doc('ZRpjpfQ2Xv2UJrOsVrBO')
            .get(const GetOptions(source: Source.serverAndCache)),
        _firestore
            .collection('skills')
            .doc('SswwVql6AcZXOlGhDaX1')
            .get(const GetOptions(source: Source.serverAndCache)),
        _firestore
            .collection('projects')
            .get(const GetOptions(source: Source.serverAndCache)),
        _firestore
            .collection('experiences')
            .get(const GetOptions(source: Source.serverAndCache)),
        _firestore
            .collection('educations')
            .get(const GetOptions(source: Source.serverAndCache)),
      ]);

      final resumeData = (results[0] as DocumentSnapshot).data() as Map<String, dynamic>?;
      final aboutData  = (results[1] as DocumentSnapshot).data() as Map<String, dynamic>?;
      final skillsData = (results[2] as DocumentSnapshot).data() as Map<String, dynamic>?;
      final projectsSnap   = results[3] as QuerySnapshot;
      final experienceSnap = results[4] as QuerySnapshot;
      final educationSnap  = results[5] as QuerySnapshot;

      // Parse and sort each collection by the `order` field
      final projects = projectsSnap.docs.isNotEmpty
          ? (projectsSnap.docs.map((doc) {
              final d = doc.data() as Map<String, dynamic>? ?? {};
              return Project.fromFirestore(d, doc.id);
            }).toList()
            ..sort((a, b) => a.order.compareTo(b.order)))
          : initialDefaultData.projects;

      final experiences = experienceSnap.docs.isNotEmpty
          ? (experienceSnap.docs.map((doc) {
              final d = doc.data() as Map<String, dynamic>? ?? {};
              return Experience.fromFirestore(d, doc.id);
            }).toList()
            ..sort((a, b) => a.order.compareTo(b.order)))
          : initialDefaultData.experiences;

      final educations = educationSnap.docs.isNotEmpty
          ? (educationSnap.docs.map((doc) {
              final d = doc.data() as Map<String, dynamic>? ?? {};
              return Education.fromFirestore(d, doc.id);
            }).toList()
            ..sort((a, b) => a.order.compareTo(b.order)))
          : initialDefaultData.educations;

      final data = HomeData(
        resume: resumeData?['url']?.toString() ?? '',
        about:  aboutData?['about']?.toString() ?? initialDefaultData.about,
        skills: (skillsData?['skills'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                initialDefaultData.skills,
        projects: projects,
        experiences: experiences,
        educations: educations,
      );

      _HomeCache.store(data);
      return data;
    } catch (e, stack) {
      log('HomeRepository fetch error: $e', error: e, stackTrace: stack);
      return _HomeCache.cached ?? initialDefaultData;
    }
  }
}

// ============================================================
//  Controller
// ============================================================
class HomeController {
  final HomeRepository _repo = HomeRepository();

  HomeData homeData = HomeRepository.initialDefaultData;
  bool isLoading = false;
  bool isFetching = false;
  String? error;

  Future<void> loadHome({bool forceRefresh = false}) async {
    try {
      isFetching = true;
      homeData = await _repo.fetchHomeData(forceRefresh: forceRefresh);
      error = null;
    } catch (e) {
      error = null;
      log('HomeController error: $e');
    } finally {
      isLoading = false;
      isFetching = false;
    }
  }
}

// ============================================================
//  Edit helpers
// ============================================================
class EditData {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  // ----- Resume -----
  Future<bool> updateResumeUrl(String newUrl) async {
    try {
      await _fs.collection('resume').doc('HP5nbvwB4U74ppRuK57G').update({'url': newUrl});
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Resume Error: $e');
      return false;
    }
  }

  // ----- About -----
  Future<bool> updateAbout(String newAbout) async {
    try {
      await _fs.collection('about').doc('ZRpjpfQ2Xv2UJrOsVrBO').update({'about': newAbout});
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update About Error: $e');
      return false;
    }
  }

  // ----- Skills -----
  Future<bool> updateSkills(List<String> skills) async {
    try {
      await _fs.collection('skills').doc('SswwVql6AcZXOlGhDaX1').update({'skills': skills});
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Skills Error: $e');
      return false;
    }
  }

  // ----- Projects -----
  Future<bool> addProject(Project project) async {
    try {
      final count = (await _fs.collection('projects').get()).size;
      await _fs.collection('projects').add({
        'title': project.title,
        'description': project.description,
        'icon': project.icon,
        'play_url': project.playUrl,
        'more_url': project.moreUrl,
        'ios_url': project.iosUrl,
        'order': count,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Add Project Error: $e');
      return false;
    }
  }

  Future<bool> updateProject(Project project, String id) async {
    try {
      await _fs.collection('projects').doc(id).update({
        'title': project.title,
        'description': project.description,
        'icon': project.icon,
        'ios_url': project.iosUrl,
        'play_url': project.playUrl,
        'more_url': project.moreUrl,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Project Error: $e');
      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      await _fs.collection('projects').doc(id).delete();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Delete Project Error: $e');
      return false;
    }
  }

  /// Saves the new display order for projects using a single batch write.
  Future<bool> reorderProjects(List<String> orderedIds) async {
    try {
      final batch = _fs.batch();
      for (int i = 0; i < orderedIds.length; i++) {
        batch.update(_fs.collection('projects').doc(orderedIds[i]), {'order': i});
      }
      await batch.commit();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Reorder Projects Error: $e');
      return false;
    }
  }

  // ----- Experiences -----
  Future<bool> addExperience(Experience exp) async {
    try {
      final count = (await _fs.collection('experiences').get()).size;
      await _fs.collection('experiences').add({
        'company': exp.company,
        'title': exp.title,
        'time': exp.time,
        'desc': exp.desc,
        'order': count,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Add Experience Error: $e');
      return false;
    }
  }

  Future<bool> updateExperience(String docId, Experience exp) async {
    try {
      await _fs.collection('experiences').doc(docId).update({
        'company': exp.company,
        'title': exp.title,
        'time': exp.time,
        'desc': exp.desc,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Experience Error: $e');
      return false;
    }
  }

  Future<bool> deleteExperience(String docId) async {
    try {
      await _fs.collection('experiences').doc(docId).delete();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Delete Experience Error: $e');
      return false;
    }
  }

  Future<bool> reorderExperiences(List<String> orderedIds) async {
    try {
      final batch = _fs.batch();
      for (int i = 0; i < orderedIds.length; i++) {
        batch.update(_fs.collection('experiences').doc(orderedIds[i]), {'order': i});
      }
      await batch.commit();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Reorder Experiences Error: $e');
      return false;
    }
  }

  // ----- Educations -----
  Future<bool> addEducation(Education edu) async {
    try {
      final count = (await _fs.collection('educations').get()).size;
      await _fs.collection('educations').add({
        'institution': edu.institution,
        'degree': edu.degree,
        'time': edu.time,
        'desc': edu.desc,
        'order': count,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Add Education Error: $e');
      return false;
    }
  }

  Future<bool> updateEducation(String docId, Education edu) async {
    try {
      await _fs.collection('educations').doc(docId).update({
        'institution': edu.institution,
        'degree': edu.degree,
        'time': edu.time,
        'desc': edu.desc,
      });
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Education Error: $e');
      return false;
    }
  }

  Future<bool> deleteEducation(String docId) async {
    try {
      await _fs.collection('educations').doc(docId).delete();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Delete Education Error: $e');
      return false;
    }
  }

  Future<bool> reorderEducations(List<String> orderedIds) async {
    try {
      final batch = _fs.batch();
      for (int i = 0; i < orderedIds.length; i++) {
        batch.update(_fs.collection('educations').doc(orderedIds[i]), {'order': i});
      }
      await batch.commit();
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Reorder Educations Error: $e');
      return false;
    }
  }
}
