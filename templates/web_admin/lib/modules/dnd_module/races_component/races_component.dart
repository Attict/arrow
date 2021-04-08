import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/routes.dart';
import 'package:web_admin/shared/pipes/filter_pipe.dart';
import 'package:web_admin/shared/pipes/sort_pipe.dart';

@Component(
  selector: 'races-component',
  templateUrl: 'races_component.html',
  styleUrls: ['races_component.css'],
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
class RacesComponent implements OnInit, OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = DndRacesBloc();

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
      ? RoutePaths.dndRace.toUrl(parameters: {idParam: '${id}'})
      : RoutePaths.dndRace.toUrl(parameters: {idParam: 'new'});


  ///
  /// sort
  ///
  void sort(String field) {
    sortDir = field != sortField ? 1 : sortDir * -1;
    sortField = field;
  }

  void import() {
    final InputElement i = document.createElement('input')
        ..setAttribute('type', 'file')
        ..setAttribute('accept', 'application/json')
        ..style.display = 'none';
    document.body.append(i);
    i.onChange.listen((f) {
      final d = f.target as FileUploadInputElement;
      if (d.files != null && d.files[0] != null) {
        FileReader reader = FileReader();
        reader.onLoad.listen((r) {
          final data = (r.target as dynamic).result;
          bloc.import(data);
        });
        reader.readAsText(d.files[0]);
      }
    });
    i.click();
    i.remove();
  }
}
