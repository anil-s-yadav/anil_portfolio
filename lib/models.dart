class HomeData {
  final String resume;
  final String about;
  final List<String> skills;
  final List<Project> projects;
  final List<Experience> experiences;
  final List<Education> educations;

  HomeData({
    required this.resume,
    required this.about,
    required this.skills,
    required this.projects,
    required this.experiences,
    required this.educations,
  });
}

class Project {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String moreUrl;
  final String playUrl;
  final String iosUrl;
  final int order;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.moreUrl,
    required this.playUrl,
    required this.iosUrl,
    this.order = 0,
  });

  factory Project.fromFirestore(Map<String, dynamic> data, String id) {
    return Project(
      id: id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      icon: data['icon']?.toString() ?? '',
      moreUrl: data['more_url']?.toString() ?? '',
      playUrl: data['play_url']?.toString() ?? '',
      iosUrl: data['ios_url']?.toString() ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class Experience {
  final String id;
  final String company;
  final String title;
  final String time;
  final List<String> desc;
  final int order;

  Experience({
    required this.id,
    required this.company,
    required this.title,
    required this.time,
    required this.desc,
    this.order = 0,
  });

  factory Experience.fromFirestore(Map<String, dynamic> data, String id) {
    return Experience(
      id: id,
      company: data['company']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      desc: (data['desc'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      order: (data['order'] as num?)?.toInt() ?? 0,
    );
  }
}

class Education {
  final String id;
  final String institution;
  final String degree;
  final String time;
  final String desc;
  final int order;

  Education({
    required this.id,
    required this.institution,
    required this.degree,
    required this.time,
    required this.desc,
    this.order = 0,
  });

  factory Education.fromFirestore(Map<String, dynamic> data, String id) {
    return Education(
      id: id,
      institution: data['institution']?.toString() ?? '',
      degree: data['degree']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      desc: data['desc']?.toString() ?? '',
      order: (data['order'] as num?)?.toInt() ?? 0,
    );
  }
}
