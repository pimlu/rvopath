import 'dart:html';

import 'package:angular/angular.dart';
import 'sim/sim.dart';

@Component(
  selector: 'my-app',
  template: '''
<h2>RVO avoidance
  <span class="wblock"></span>
  <button (click)="sim.reset(120,50.0)">Circle</button>
  <button (click)="sim.reset(0,0.0,3,30)">Grid</button>
  <button (click)="sim.reset(50,35.0,2,30)">Circle Grid</button>
</h2>
<canvas #c width="0" height="0">
''',
  preserveWhitespace: false
)
class AppComponent implements AfterViewInit {
  @ViewChild('c')
  ElementRef canvasRef;
  CanvasElement get canvas => canvasRef.nativeElement;
  Sim sim;
  AppComponent();

  @override
  ngAfterViewInit() {
    int w = 800, h = 600;
    canvas.width = (w*window.devicePixelRatio).round();
    canvas.height = (h*window.devicePixelRatio).round();
    canvas.style.width = '${w}px';
    canvas.style.height = '${h}px';
    sim = new Sim(canvas, 30.0);
  }
}
