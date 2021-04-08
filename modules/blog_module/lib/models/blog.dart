part of blog_module;

class Blog implements CoreModel {
  int id;
  String title;
  String body;
  String brief;
  int authorId;
  CoreUser author;
  DateTime created;
  DateTime modified;
  String coverImage;

  ///
  /// Constructor
  ///
  Blog({
    this.id,
    this.title,
    this.body,
    this.brief,
    this.authorId,
    this.author,
    this.created,
    this.modified,
    this.coverImage,
  });

  ///
  /// Convert Map to Object
  ///
  factory Blog.fromMap(Map<String, dynamic> data) {
    return Blog(
      id: data['id'],
      title: data['title'],
      body: data['body'],
      brief: data['brief'],
      authorId: data['authorId'],
      author: CoreUser.fromMap(data['author']),
      created: data['created'] != null
          ? DateTime.parse(data['created']) : null,
      modified: data['modified'] != null
          ? DateTime.parse(data['modified']) : null,
      coverImage: data['coverImage'],
    );
  }

  ///
  /// Convert the object to a data object, which can then be converted to JSON.
  ///
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'brief': brief,
      'authorId': authorId,
      'author': author.toMap(),
      'created': created,
      'modified': modified,
      'coverImage': coverImage,
    };
  }

  String getCoverImage() {
    final baseUrl = CoreApplication.instance.config.api;
    final imageUrl = (coverImage != null)
        ? '$baseUrl/media/blog/$coverImage'
        : '/assets/images/material_bg.png';
    return imageUrl;
  }

  bool hasCoverImage() {
    if (coverImage != null && coverImage != '') {
      return true;
    }
    return false;
  }

}

