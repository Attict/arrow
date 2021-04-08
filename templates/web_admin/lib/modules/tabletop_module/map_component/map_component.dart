import 'dart:html';
import 'package:angular/angular.dart';

@Component(
  selector: 'map-component',
  template: '<canvas #canvas></canvas>',
)
class MapComponent implements OnInit, OnDestroy {
  @ViewChild('canvas')
  CanvasElement canvas;

  @override
  void ngOnInit() {
    canvas.width = document.body.clientWidth;
    canvas.height = document.body.clientHeight;
  }

  @override
  void ngOnDestroy() {}
}
