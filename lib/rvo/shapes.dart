import 'dart:html';
import 'dart:math';
import '../spatial/spatial.dart';
import 'controller.dart';

abstract class Shape extends Vec2 {
  Controller ctrl;
  Vec2 v = new Vec2();
  double maxv = 6.0;
  Shape([double x=0.0, y=0.0]) : super(x,y);
  void render(CanvasRenderingContext2D ctx);
  void step(double dt) {
    v = v.vadd(ctrl.acc.vmul(dt)).vmul(pow(0.5, dt));
    if(v.vmag > maxv) v = v.vnorm(maxv);
    vcopy(vadd(v.vmul(dt)));
  }
  double vo(Shape o);
}

class Circle extends Shape {
  double r;
  Circle(double x, y, this.r) : super(x,y);
  Circle.vec(Vec2 p, this.r) : super(p.x, p.y);
  void render(CanvasRenderingContext2D ctx) {
    ctx.beginPath();
    ctx.arc(x, y, r, 0, 2 * PI);
    ctx.fill();
  }
  double vo(Shape o) {
    if(o is Circle) {
      // wikipedia: Distance_from_a_point_to_a_line#Line_defined_by_two_points
      Vec2 rv = o.v.vsub(v);
      Vec2 p0 = this, p1 = o, p2 = o.vadd(rv), diff = p0.vsub(p1);
      double rsum = r+o.r;
      if(diff.vsqmag <= rsum*rsum) return 0.0;
      if(diff.vdot(rv) < 0) return double.INFINITY;
      double top = (p0.vzcomp(rv) + p2.vzcomp(p1)).abs();
      double dist = top/rv.vmag;
      if(dist > rsum) return double.INFINITY;
      // ericleong.me/research/circle-circle/
      double backdist = sqrt(rsum*rsum - dist*dist);
      return (diff.vmag-backdist)/rv.vmag;
    }
    throw new StateError('Not in compatible shapes');
  }
}

class Rect extends Shape {
  double w,h;
  Rect(double x, double y, this.w, this.h) : super(x,y);
  void render(CanvasRenderingContext2D ctx) => ctx.fillRect(x-w/2, y-h/2, w, h);
  double vo(Shape o) => throw new StateError('Not in compatible shapes');
}
