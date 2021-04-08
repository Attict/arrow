part of blog_module;

class BlogService extends CoreService<Blog> {
  String route = '${CoreApplication.instance.config.api}/blogs';

  @override
  Blog createObject(Map<String, dynamic> data) => Blog.fromMap(data);
}
