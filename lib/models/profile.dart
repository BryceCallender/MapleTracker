class Profile {
  String username;
  String? avatarUrl;
  String? email;

  Profile({required this.username, this.avatarUrl, required this.email});

  Profile.fromJson(Map<String, dynamic> json)
    : username = json['username'],
      avatarUrl = json['avatar_url'],
      email = '';
}