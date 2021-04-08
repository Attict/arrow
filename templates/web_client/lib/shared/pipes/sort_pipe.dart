import 'package:angular/angular.dart';
import 'package:core_module/core_module.dart';

@Pipe('sortPipe')
class SortPipe extends PipeTransform {
  dynamic transform(List<dynamic> items, String field, int direction) {
    return CoreSort.sort(items, field, direction);
  }
}
