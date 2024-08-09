class AuthorProfilePacket {
  final String authorName;
  final String image;

  AuthorProfilePacket({
    required this.authorName,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
        "authorName": this.authorName,
        "image": this.image,
      };
}
