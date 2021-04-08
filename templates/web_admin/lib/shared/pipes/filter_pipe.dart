import 'package:angular/angular.dart';
import 'package:core_module/core_module.dart';

@Pipe('filterPipe')
class FilterPipe extends PipeTransform {
  dynamic transform(List<dynamic> items, String term) {
    return CoreFilter.filter(items, term);
  }
}
