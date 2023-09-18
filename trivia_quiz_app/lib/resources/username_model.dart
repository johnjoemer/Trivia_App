class userName {
  final String username;
  final int score;

  const userName({required this.username, required this.score});

  factory userName.fromJson(Map<String,dynamic> json) => userName(
    username: json['username'],
    score: json['score']
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'score': score
  };
}