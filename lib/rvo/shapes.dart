import '../spatial/spatial.dart';

abstract class Shape<T> extends Point {
  T data;
  Point v = new Point();
  Shape([double x=0.0, double y=0.0]) : super(x,y);
  bool vo(Shape o);
}

class Circle<T> extends Shape<T> {
  double r;
  Circle(double x, double y, this.r) : super(x,y);
  bool vo(Shape o) {
    if(o is Circle) {
      // wikipedia: Distance_from_a_point_to_a_line#Line_defined_by_two_points
      Point rv = o.v.padd(v.pneg);
      Point p0 = this, p1 = o, p2 = o.padd(rv);
      double top = (rv.y*p0.x - rv.x*p0.y + p2.x*p1.y - p2.y*p1.x).abs();
      double dist = top/rv.pmag;
      print(dist);
      return dist <= r+o.r;
    }
    throw new StateError('Not in compatible shapes');
  }
}

class Rect<T> extends Shape<T> {
  double w,h;
  Rect(double x, double y, this.w, this.h) : super(x,y);
  bool vo(Shape o) => throw new StateError('Not in compatible shapes');
}
