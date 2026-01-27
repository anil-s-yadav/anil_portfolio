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
  final String id;
  final String title;
  final String description;
  final String icon;
  final String url;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.url,
  });

  factory Project.fromFirestore(Map<String, dynamic> data, String id) {
    return Project(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      url: data['url'] ?? '',
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
