import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/routes.dart';
import 'package:web_admin/shared/pipes/filter_pipe.dart';
import 'package:web_admin/shared/pipes/sort_pipe.dart';

@Component(
  selector: 'backgrounds-component',
  templateUrl: 'backgrounds_component.html',
  styleUrls: ['backgrounds_component.css'],
  directives: [
    routerDirectives,
    MaterialButtonComponent,
    MaterialInputComponent,
    NgClass,
    NgFor,
  ],
  pipes: [
    FilterPipe,
    SortPipe,
  ],
)
class BackgroundsComponent implements OnInit, OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = DndBackgroundsBloc();

  ///
  /// filterInput
  ///
  ///
  @ViewChild('filterInput')
  MaterialInputComponent filterInput;

  ///
  /// filter
  ///
  ///
  String get filter => filterInput.inputText;

  ///
  /// sort
  ///
  ///
  int sortDir = 1;
  String sortField = 'id';

  ///
  /// ngOnInit
  ///
  ///
  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      default:
    }
  });

  ///
  /// onActivate
  ///
  ///
  @override
  void onActivate(_, __) => bloc.add(CoreEvent.load);

  ///
  /// ngOnDestroy
  ///
  ///
  @override
  void ngOnDestroy() => bloc.close();

  ///
  /// goTo
  ///
  ///
  String goTo([int id]) => id != null
      ? RoutePaths.dndBackground.toUrl(parameters: {idParam: '${id}'})
      : RoutePaths.dndBackground.toUrl(parameters: {idParam: 'new'});


  ///
  /// sort
  ///
  void sort(String field) {
    sortDir = field != sortField ? 1 : sortDir * -1;
    sortField = field;
  }
}