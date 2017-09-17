import 'dart:html';
import 'dart:math';
import '../spatial/spatial.dart';
import 'controller.dart';

abstract class Shape extends Vec2 {
  Controller ctrl;
  Vec2 v = new Vec2();
  Shape([double x=0.0, y=0.0]) : super(x,y);
  void render(CanvasRenderingContext2D ctx);
  void step(double dt) => vcopy(vadd(v.vmul(dt)));
  bool vo(Shape o);
}

class Circle extends Shape {
  double r;
  Circle(double x, y, this.r) : super(x,y);
  void render(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.arc(x, y, r, 0, 2 * PI);
    ctx.fill();
  }
  bool vo(Shape o) {
    if(o is Circle) {
      // wikipedia: Distance_from_a_point_to_a_line#Line_defined_by_two_points
      Vec2 rv = o.v.vadd(v.vneg);
      Vec2 p0 = this, p1 = o, p2 = o.vadd(rv);
      double top = (rv.y*p0.x - rv.x*p0.y + p2.x*p1.y - p2.y*p1.x).abs();
      double dist = top/rv.vmag;
      return dist <= r+o.r;
    }
    throw new StateError('Not in compatible shapes');
  }
}

class Rect extends Shape {
  double w,h;
  Rect(double x, double y, this.w, this.h) : super(x,y);
  void render(CanvasRenderingContext2D ctx) => ctx.fillRect(x-w/2, y-h/2, w, h);
  bool vo(Shape o) => throw new StateError('Not in compatible shapes');
}
