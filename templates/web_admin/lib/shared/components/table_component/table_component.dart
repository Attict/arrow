import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/shared/pipes/filter_pipe.dart';
import 'package:web_admin/shared/pipes/sort_pipe.dart';

@Component(
  selector: 'table-component',
  templateUrl: 'table_component.html',
  styleUrls: ['table_component.css'],
  encapsulation: ViewEncapsulation.None,
  directives: [
    formDirectives,
    materialInputDirectives,
    MaterialFabComponent,
    MaterialCheckboxComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialTooltipDirective,
    NgFor,
    NgIf,
    NgTemplateOutlet,
  ],
  pipes: [
    FilterPipe,
    SortPipe,
  ],
)
class TableComponent implements OnInit, OnDestroy {
  ///
  /// headers
  ///
  ///
  @Input()
  Map<String, String> headers;

  ///
  /// data
  ///
  /// Setter for [_data], so that on set, [selected] is generated
  /// by the list of items.
  ///
  @Input()
  set data(List<dynamic> data) {
    _data = data;
    selected = List<bool>.generate(data.length, (i) => false);
  }
  List<dynamic> get data => _data;
  List<dynamic> _data;

  ///
  /// selected
  ///
  /// Controls selected items in the list.
  ///
  List<bool> selected;

  ///
  /// actions
  ///
  ///
  @Input()
  List<TableAction> otherActions;

  ///
  /// selectable
  ///
  /// If checkboxes for selection should be shown.
  ///
  @Input()
  set selectable(bool v) {
    _selectableStream.add(v);
    _selectable = v;
  }
  @Output()
  bool get selectable => _selectable;
  bool _selectable = false;
  final _selectableStream = StreamController<bool>();

  ///
  /// trigger
  ///
  /// The trigger for the row being clicked.
  ///
  @Input()
  Function trigger;

  @Input()
  Function deleteCallback;

  @Input()
  Function addCallback;

  @Input()
  bool allowAdd = false;

  @Input()
  bool allowDelete = false;

  List<TableAction> actions;

  ///
  /// body
  ///
  ///
  @ContentChild(TemplateRef)
  TemplateRef body;

  ///
  /// filter
  ///
  ///
  String filter = '';

  ///
  /// sort
  ///
  ///
  int sortDir = 1;
  String sortField = 'id';
  void sort(String field) {
    sortDir = field != sortField ? 1 : sortDir + 1;
    if (sortDir > 1) sortDir = -1;
    sortField = field;
  }

  Map<String, dynamic> context(dynamic d) => {'\$implicit': d};

  @override
  void ngOnInit() {
    _updateActions();
    _selectableStream.stream.listen((bool v) {
      _updateActions();
    });
  }

  @override
  void ngOnDestroy() {
    _selectableStream.close();
  }

  ///
  /// select
  ///
  /// Mass select all.
  ///
  void select(String checked) {
    bool select = checked == 'true';
    for (int i = 0; i < selected.length; ++i) selected[i] = select;
  }

  ///
  /// _updateActions
  ///
  /// Update the actions, which turns/shows the close button instead of
  /// the add button if [selectable].
  ///
  void _updateActions() {
    // Other actions first
    actions = otherActions ?? List<TableAction>();

    // Delete Button
    if (allowDelete) {
      actions.add(TableAction(
        icon: 'delete',
        classes: 'red',
        tooltip: selectable ? 'Delete selected items' : 'Open selection for deleting',
        trigger: () {
          if (!selectable) {
            selectable = true;
          } else {
            final count = selected.where((i) => i == true).length;
            final items = List<dynamic>();
            for (int i = 0; i < selected.length; ++i) {
              if (selected[i]) {
                items.add(data[i]);
              }
            }
            CoreApplication.instance.dialog = CoreDialog(
              title: 'Confirm Deletion',
              message: 'Are you sure you wish to delete $count record${count == 1 ? '' : 's'}?',
              buttons: <CoreDialogButton>[
                CoreDialogButton.close(label: 'Cancel'),
                CoreDialogButton(
                  label: 'Delete',
                  callback: () {
                    deleteCallback(items);
                    CoreApplication.instance.closeDialog();
                  },
                  classes: 'red',
                  raised: true,
                ),
              ],
            );
          }
        }
      ));
    }

    // Add Button -- or Close Button (if selectable)
    if (allowAdd || (allowDelete && selectable)) {
      actions.add(TableAction(
        icon: 'add',
        classes: selectable ? 'blue add__rotate-close' : 'blue',
        tooltip: selectable ? 'Cancel selection' : 'Add New',
        trigger: () {
          if (selectable) {
            selectable = false;
          } else {
            addCallback != null ? addCallback() : trigger();
          }
        },
      ));
    }
  }
}

class TableAction {
  String icon;
  String tooltip;
  String classes;
  Function trigger;

  TableAction({
    this.icon,
    this.tooltip,
    this.classes,
    this.trigger,
  });
}
