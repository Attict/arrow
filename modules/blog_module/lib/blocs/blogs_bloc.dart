part of blog_module;

///
/// BlogsBloc
///
///
class BlogsBloc extends CoreBloc<CoreEvent, CoreState> {
  ///
  /// blogs
  ///
  ///
  List<Blog> blogs;

  ///
  /// onEvent
  ///
  ///
  @override
  void onEvent(CoreEvent event) {
    switch (event) {
      case CoreEvent.load:
        _load();
        break;
      default:
    }
  }

  ///
  /// onError
  ///
  ///
  @override
  void onError(Object e, [StackTrace stackTitem]) {
    CoreApplication.instance.handleException(e);
    setState(CoreState.error);
  }

  ///
  /// _load
  ///
  ///
  Future<void> _load() async {
    CoreApplication.instance.add(CoreEvent.load);
    setState(CoreState.loading);
    try {
      blogs = await _service.getAll();
      setState(CoreState.loaded);
    } catch (e) {
      onError(e);
    } finally {
      CoreApplication.instance.add(CoreEvent.loaded);
    }
  }

  ///
  /// _service
  ///
  ///
  final _service = BlogService();
}
