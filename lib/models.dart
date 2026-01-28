class HomeData {
  final String resume;
  final String about;
  final List<String> skills;
  final List<Project> projects;
  final List<Experience> experiences;
  // final List<Education> education;

  HomeData({
    required this.resume,
    required this.about,
    required this.skills,
    required this.projects,
    required this.experiences,
    // required this.education,
  });
}

class Project {
  final String title;
  final String description;
  final String icon;
  final String moreUrl;
  final String playUrl;

  Project({
    required this.title,
    required this.description,
    required this.icon,
    required this.moreUrl,
    required this.playUrl,
  });

  factory Project.fromFirestore(Map<String, dynamic> data, String id) {
    return Project(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      moreUrl: data['more_url'] ?? '',
      playUrl: data['play_url'] ?? '',
    );
  }
}

class Experience {
  final String company;
  final String title;
  final String time;
  final List<String> desc;

  Experience({
    required this.company,
    required this.title,
    required this.time,
    required this.desc,
  });

  factory Experience.fromFirestore(Map<String, dynamic> data, String id) {
    return Experience(
      company: data['company']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      desc:
          (data['desc'] as List<dynamic>? ?? [])
              .map((e) => e.toString())
              .toList(),
    );
  }
}
