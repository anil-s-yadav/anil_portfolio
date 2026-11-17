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
        resume:
            'https://drive.google.com/file/d/1KchDdVnbn1oMbTemKM7pCQ7Oc4a6NSXa/view?usp=sharing',
        about:
            "Hi, I'm Anil. I engineer high-performance, cross-platform applications using Flutter and Dart.\n\nOver the past 2 years, I have architected enterprise-level CRM systems, automated complex logistics workflows, and published a suite of personal utility apps with over 5,000+ downloads. I focus on writing clean, maintainable code (BLoC, Clean Architecture) while delivering intuitive, pixel-perfect user experiences. Whether it involves complex offline databases, advanced API integrations, or end-to-end product deployment, I build applications that solve real-world problems and scale reliably.",
        skills: [
          'Flutter Framework',
          'Dart',
          'Bloc | Provider | GetX',
          'Isolates',
          'Firebase',
          'Postman',
          'API Integration',
          'Git | GitHub',
          'Figma',
          'UI & UX',
          'Node Js.',
          'Python - FastApi',
          'Android, IOS development',
          'Agile, waterfall Models',
          'Problem Solving Skills',
          'Teamwork',
          'bitbucket',
        ],
        projects: [
          Project(
            id: 'Y6xKgmDunggo2UeO8xpg',
            title: 'KaamwaliJobs – Hire Maid, Cook',
            description:
                'Kaamwali Jobs is India’s trusted and easy-to-use maid service app to hire reliable, verified, and experienced domestic helpers near you. Whether you need a full-time house maid, part-time cook, nanny, babysitter, elder care worker, japa maid, patient caretaker, or a personal driver – Kaamwali Jobs is your one-stop platform for all household staffing needs.',
            icon:
                'https://play-lh.googleusercontent.com/EiBaStzY6YloyVh46s0FXpBuyzyJ5O-B9RnnvTRatF-k7hDEPo-KKaR_1tNFY6R-a3FK=w480-h960-rw',
            moreUrl:
                'https://apkpure.com/kaamwalijobs/com.kaamwalijobs.kaamwalijob',
            playUrl:
                'https://play.google.com/store/apps/details?id=com.kaamwalijobs.kaamwalijob&pcampaignid=web_share',
            iosUrl: 'https://apps.apple.com/us/app/kaamwalijobs/id6755223912',
            order: 0,
          ),
          Project(
            id: 'BHBJelmjHsdEx7lUvfNW',
            title: 'Society Gate',
            description:
                'Society Gate is your go-to smart society management solution designed for modern residential complexes, gated communities, and apartments. It bridges the communication gap between residents, security guards, and the society management committee, making community living more convenient, secure, and efficient.',
            icon:
                'https://play-lh.googleusercontent.com/mBpHmTV2Sxw36Rv3J9vwK6RMhc0u9tjcehZ7QUl-ZO8L3_WnJtscoJ-eJZh8uxwqzrMvXc1il_LTYLYmhcL_ww=w480-h960-rw',
            moreUrl: 'https://thesocietygate.com/',
            playUrl:
                'https://play.google.com/store/apps/details?id=com.webhubinfotech.society_gate',
            iosUrl: '',
            order: 1,
          ),
          Project(
            id: '6kYNpUxJaXS4W21tKcVF',
            title: 'Stream24 News Backend',
            description:
                "use from newspaper import articles -> use article url to extract text. ( I will use this text to train my ai model too.)  pass this text to summary model (model_name = \"csebuetnlp/mT5_multilingual_XLSum\") who'll create summary. ( I will use this summary to train my ai model too.)  now we have summary, insert it into firestore. location => collection(news)->doc(article_id)->\"summary\":\"this is summary\"  also store this text and summary in a csv file to train my model in future. here is structure to save. We also kepp deleting data (articles from news collection(backend) and also from users-saved(its frontend's duty)) who was publised before 7 days.  Host on Renderand Start Executing all of this automatically at 12AM.",
            icon:
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCPcuWZ0dqg1uk6f-yWbt3CgYZ2We3_4AWug&s',
            moreUrl: 'https://github.com/anil-s-yadav/Stream24NewsBackend',
            playUrl: '',
            iosUrl: '',
            order: 2,
          ),
          Project(
            id: 'h7jwUKdATQtgxkVJDho9',
            title: 'Kaamwalibais – Hire Maids,Cook',
            description:
                '1. Download the Kaamwalibais app 2. Select the service you need (maid, cook, babysitter, caretaker, etc.) 3. Browse verified profiles and choose the best fit 4. Book instantly and get trusted help at your doorstep  One-Stop Solution for Home Assistance',
            icon:
                'https://play-lh.googleusercontent.com/VcKgrrmct-dPl1B70xYCLuFAb2gRLvcPLQGlCP4L0F8iin3kTMiSr2rFyk6I0WzJXw=w480-h960-rw',
            moreUrl:
                'https://apkpure.com/kaamwalibais-%E2%80%93-hire-maids-cook/com.innowrap.user.kaamwalibais',
            playUrl:
                'https://play.google.com/store/apps/details?id=com.innowrap.user.kaamwalibais',
            iosUrl: 'https://apps.apple.com/us/app/kaamwalibais/id6754094328',
            order: 3,
          ),
          Project(
            id: 'MVsJUGQ9xTvuosZlsIFx',
            title: 'Kaamwalibais CRM - (for staff)',
            description:
                'Managing a maid service business can be complex without the right tools. Our powerful CRM app is designed to simplify your operations, streamline job assignments, and help you provide exceptional service to your clients. Whether you\'re managing a small team or a large workforce, this app offers everything you need to run your business efficiently and effectively.',
            icon:
                'https://play-lh.googleusercontent.com/ZiEgHhKzmsF8qbYy5ZD03rK_pxLnlhyWnE7Ksa9NW7ggNUUjFneKFNcsdCc9LjPldAc=w480-h960-rw',
            moreUrl:
                'https://apkpure.com/kaamwalibais-crm-for-staff/com.kaamwalibais.kaamwalibais_crm_new',
            playUrl:
                'https://play.google.com/store/apps/details?id=com.kaamwalibais.kaamwalibais_crm_new&pcampaignid=web_share',
            iosUrl: '',
            order: 4,
          ),
          Project(
            id: 'VXGkWRugJRylVyzxQXTz',
            title: 'Anil S. Yadav Portfolio',
            description:
                'A portfolio webapp created using flutter by me, holding details about my profetional works, skills, education and contact and also listed my services their.',
            icon:
                'https://avatars.githubusercontent.com/u/63013659?s=400&u=bffc235dca54b94c7b9e7852fd81353a0f668475&v=4',
            moreUrl: 'https://anil-portfolio-o2q9.onrender.com/',
            playUrl: '',
            iosUrl: '',
            order: 5,
          ),
          Project(
            id: '2WwYggyzgATm5jUKJedg',
            title: 'Stream24 Short News & Live Tv',
            description:
                'Stream24 is a smart news and live TV app offering real-time updates, personalized news, and trending reels. Watch live channels, read AI-powered news summaries, and stay informed anytime, anywhere.',
            icon:
                'https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/aboutus_logo.png',
            moreUrl:
                'https://apkpure.net/stream24-short-news-live-tv/com.legendarysoftware.stream24news',
            playUrl:
                'https://play.google.com/store/apps/details?id=com.legendarysoftware.stream24news&pcampaignid=web_share',
            iosUrl: '',
            order: 6,
          ),
        ],
        experiences: [
          Experience(
            id: 'BdH0SFA8PcflEl8dqIgF',
            company: 'V-Trans India – Mumbai, India',
            title: 'Flutter Developer',
            time: 'Jan 2026 - Present',
            desc: [
              'Engineered 3 enterprise logistics applications (V-Trans, VT Connect, VX Connect) serving 4,000+ staff members and many external customers.',
              'Developed LLM-powered APIs and Integrated to automate document scanning and tracking summaries.',
              'Architected robust systems using Flutter Flavors, strict RBAC, and Shorebird for seamless OTA updates.',
            ],
            order: 0,
          ),
          Experience(
            id: 'HQVE5NxqYY4820fDY0Od',
            company: 'Kaamwalibais – Mumbai, India',
            title: 'Flutter Developer',
            time: 'Dec 2024 - Dec 2025',
            desc: [
              'Developed and deployed 5+ cross-platform apps, including a high-scale CRM and complex society management platforms.',
              'Implemented Clean Architecture to securely process and manage large-scale data records.',
              'Configured CI/CD pipelines, improving app load speeds by 30% and maintaining a 90%+ crash-free rate.',
            ],
            order: 1,
          ),
          Experience(
            id: 'aLfWiPTmLyJQ42gLA2EF',
            company: 'Prodigy InfoTech · Internship',
            title: 'Android Developer (Java,Kotlin)',
            time: 'Jan 2024 - March 2024',
            desc: [
              'Built 5 foundational native Android applications during a 3-month intensive internship.',
              'Developed functional mobile user interfaces and application logic using Java and Kotlin.',
            ],
            order: 2,
          ),
        ],
        educations: [
          Education(
            id: 'HPJGHaeT70Be060OGTHq',
            institution: 'Bunts sangha S. M. Shetty college, Powai.',
            degree: 'B.Sc. - Information Technology',
            time: '2021 - 2024',
            desc: 'CGPA - 8.10',
            order: 0,
          ),
          Education(
            id: '8TRoukoAoi2sdBsfvZcc',
            institution: 'Ramniranjan Jhunjhunwala collage, Ghatkoper.',
            degree: 'HSC - 12th Science',
            time: '2019 - 2021',
            desc: 'Score - 78.67%',
            order: 1,
          ),
          Education(
            id: 'hFHM9thYvhMwl1VyJod9',
            institution: 'Hindi High School, Ghatkoper.',
            degree: 'SSC- 10th',
            time: '2018 - 2019',
            desc: 'Score - 85.40%',
            order: 2,
          ),
        ],
      );

  Future<HomeData> fetchHomeData({bool forceRefresh = false}) async {
    // Serve from in-memory cache instantly unless forced refresh
    if (!forceRefresh && _HomeCache.hasData) return _HomeCache.cached!;
    if (forceRefresh) {
      _HomeCache.invalidate();
    }

    final options = forceRefresh
        ? const GetOptions(source: Source.server)
        : const GetOptions(source: Source.serverAndCache);

    try {
      // All 6 queries fire in parallel — no sequential waiting
      final results = await Future.wait([
        _firestore
            .collection('resume')
            .doc('HP5nbvwB4U74ppRuK57G')
            .get(options)
            .catchError((_) => _firestore.collection('resume').doc('HP5nbvwB4U74ppRuK57G').get()),
        _firestore
            .collection('about')
            .doc('ZRpjpfQ2Xv2UJrOsVrBO')
            .get(options)
            .catchError((_) => _firestore.collection('about').doc('ZRpjpfQ2Xv2UJrOsVrBO').get()),
        _firestore
            .collection('skills')
            .doc('SswwVql6AcZXOlGhDaX1')
            .get(options)
            .catchError((_) => _firestore.collection('skills').doc('SswwVql6AcZXOlGhDaX1').get()),
        _firestore
            .collection('projects')
            .get(options)
            .catchError((_) => _firestore.collection('projects').get()),
        _firestore
            .collection('experiences')
            .get(options)
            .catchError((_) => _firestore.collection('experiences').get()),
        _firestore
            .collection('educations')
            .get(options)
            .catchError((_) => _firestore.collection('educations').get()),
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
      await _fs.collection('resume').doc('HP5nbvwB4U74ppRuK57G').set({'url': newUrl}, SetOptions(merge: true));
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
      await _fs.collection('about').doc('ZRpjpfQ2Xv2UJrOsVrBO').set({'about': newAbout}, SetOptions(merge: true));
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
      await _fs.collection('skills').doc('SswwVql6AcZXOlGhDaX1').set({'skills': skills}, SetOptions(merge: true));
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
      if (id.startsWith('default')) {
        await _fs.collection('projects').add({
          'title': project.title,
          'description': project.description,
          'icon': project.icon,
          'ios_url': project.iosUrl,
          'play_url': project.playUrl,
          'more_url': project.moreUrl,
          'order': project.order,
        });
      } else {
        await _fs.collection('projects').doc(id).set({
          'title': project.title,
          'description': project.description,
          'icon': project.icon,
          'ios_url': project.iosUrl,
          'play_url': project.playUrl,
          'more_url': project.moreUrl,
        }, SetOptions(merge: true));
      }
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Project Error: $e');
      return false;
    }
  }

  Future<bool> deleteProject(String id) async {
    try {
      if (!id.startsWith('default')) {
        await _fs.collection('projects').doc(id).delete();
      }
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
        final id = orderedIds[i];
        if (!id.startsWith('default')) {
          batch.update(_fs.collection('projects').doc(id), {'order': i});
        }
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
      if (docId.startsWith('default')) {
        await _fs.collection('experiences').add({
          'company': exp.company,
          'title': exp.title,
          'time': exp.time,
          'desc': exp.desc,
          'order': exp.order,
        });
      } else {
        await _fs.collection('experiences').doc(docId).set({
          'company': exp.company,
          'title': exp.title,
          'time': exp.time,
          'desc': exp.desc,
        }, SetOptions(merge: true));
      }
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Experience Error: $e');
      return false;
    }
  }

  Future<bool> deleteExperience(String docId) async {
    try {
      if (!docId.startsWith('default')) {
        await _fs.collection('experiences').doc(docId).delete();
      }
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
        final id = orderedIds[i];
        if (!id.startsWith('default')) {
          batch.update(_fs.collection('experiences').doc(id), {'order': i});
        }
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
      if (docId.startsWith('default')) {
        await _fs.collection('educations').add({
          'institution': edu.institution,
          'degree': edu.degree,
          'time': edu.time,
          'desc': edu.desc,
          'order': edu.order,
        });
      } else {
        await _fs.collection('educations').doc(docId).set({
          'institution': edu.institution,
          'degree': edu.degree,
          'time': edu.time,
          'desc': edu.desc,
        }, SetOptions(merge: true));
      }
      _HomeCache.invalidate();
      return true;
    } catch (e) {
      log('Update Education Error: $e');
      return false;
    }
  }

  Future<bool> deleteEducation(String docId) async {
    try {
      if (!docId.startsWith('default')) {
        await _fs.collection('educations').doc(docId).delete();
      }
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
        final id = orderedIds[i];
        if (!id.startsWith('default')) {
          batch.update(_fs.collection('educations').doc(id), {'order': i});
        }
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
