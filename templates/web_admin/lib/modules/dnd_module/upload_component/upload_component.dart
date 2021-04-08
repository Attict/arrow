import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';

@Component(
  selector: 'upload-component',
  template: '<material-button (click)="upload()">Upload</material-button>',
  directives: [
    MaterialButtonComponent,
  ],
)
class UploadComponent {
  void upload() {
    final input = FileUploadInputElement()..style.display = 'none';
    input.onChange.listen((e) {
      final i = e.target as FileUploadInputElement;
      if (i.files != null && i.files[0] != null) {
        final reader = FileReader();
        reader.onLoad.listen((r) {
          final data = (r.target as dynamic).result;
          dndUpload(data).then((_) {
            CoreApplication.instance.dialog = CoreDialog(
              title: 'Success',
              message: 'Upload successful!',
              buttons: <CoreDialogButton>[CoreDialogButton.close()],
            );
          }).catchError(CoreApplication.instance.handleException);
        });
        reader.readAsText(i.files[0]);
      }
    });
    document.body.append(input);
    input.click();
    input.remove();
  }
}
