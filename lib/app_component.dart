import 'dart:math';
import 'package:angular/angular.dart';

import 'rvo/shapes.dart';

@Component(
  selector: 'my-app',
  template: '<h1>Hello {{name}}</h1>',
)
class AppComponent {
  var name = 'Angular';
  AppComponent() {
    Circle c1 = new Circle(0.0, 0.0, 0.5);
    c1.v.pset(0.0, 1.0);
    Circle c2 = new Circle(1.0, 1.0, 0.5);
    c2.v.pset(-1.0, 0.0);
    print(c1.vo(c2));
    c2.pset(1.0-1.1/sqrt(2), 1.0+1.1/sqrt(2));
    print(c1.vo(c2));
  }
}
