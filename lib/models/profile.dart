class Profile {
  String username;
  String? avatarUrl;

  Profile({required this.username, this.avatarUrl});

  Profile.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      avatarUrl = json['avatar_url'];
}