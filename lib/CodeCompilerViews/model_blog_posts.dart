class PostList {
  late final String kind;
  late final List<Post> posts;

  PostList({
    required this.kind,
    required this.posts,
  });

  PostList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      posts = <Post>[];
      json['items'].forEach((v) {
        posts.add(new Post.fromJson(v));
      });
    }
  }
}

class Post {
  late final String title;
  late final String content;
  late final String postURL;
  late final List<String> labels;

  Post({
    required this.title,
    required this.content,
    required this.postURL,
    required this.labels,
  });

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    postURL = json['url'];
    labels = json['labels'].cast<String>();
  }
}
