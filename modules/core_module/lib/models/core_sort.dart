part of core_module;

class CoreSort {
  static const descending = -1;
  static const none = 0;
  static const ascending = 1;

  static List<dynamic> sort(List<dynamic> items, String field, int direction) {
    if (items == null || field == null || direction == 0) return items;
    final list = items.toList();
    final keys = field.split('.');
    list.sort((a, b) {
      final x = a is Map ? a : a.toMap();
      final y = b is Map ? b : b.toMap();

      dynamic r1;
      dynamic r2;
      for (final k in keys) {
        r1 = r1 == null ? x[k] : r1[k];
        r2 = r2 == null ? y[k] : r2[k];
      }

      if (r1 == null) {
        return direction;
      } else if (r2 == null) {
        return -direction;
      }

      if (r1 is bool) {
        return (r1 ? 1 : -1) * direction;
      }
      return r1.compareTo(r2) * direction;
    });

    return list;
  }
}
