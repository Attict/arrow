///
/// core_dialog.dart
/// ~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <attictt@gmail.com>
///
///
part of core_module;

///
/// CoreDialog
///
/// This is a client-side only data model, which controls the view's
/// dialog by assigning itself to the CoreApplication's dialog property.
///
/// TODO:
///   Add default buttons as constants, such as:
///   - 'Okay' (close)
///   - 'Cancel', 'Delete'
///   - 'No', 'Yes'
///
class CoreDialog {
  ///
  /// title
  ///
  /// The title to be shown on the dialog.
  ///
  String title;

  ///
  /// message
  ///
  /// The message to be shown in the middle of the dialog.
  ///
  String message;

  ///
  /// buttons
  ///
  /// The buttons to be shown for the user to take action upon.  This
  /// is stored as a map from string to action.  The string will be
  /// shown as the text on the button, and the Function will be called
  /// on tap/click.
  ///
  List<CoreDialogButton> buttons;

  ///
  /// CoreDialog
  ///
  CoreDialog({
    this.title,
    this.message,
    this.buttons,
  });

  ///
  /// CoreDialog.fromException
  ///
  /// Construct a core dialog from an exception for ease of use.
  ///
  factory CoreDialog.fromException(CoreException e) => CoreDialog(
    title: e.title,
    message: e.message,
    buttons: <CoreDialogButton>[CoreDialogButton.close()],
  );
}

class CoreDialogButton {
  String label;
  Function callback;
  String classes;
  bool raised;

  CoreDialogButton({
    this.label,
    this.callback,
    this.classes,
    this.raised,
  });

  factory CoreDialogButton.close({
    String label,
    String classes,
    bool raised,
  }) {
    return CoreDialogButton(
      label: label ?? 'Close',
      callback: CoreApplication.instance.closeDialog,
      classes: classes,
      raised: raised,
    );
  }
}
