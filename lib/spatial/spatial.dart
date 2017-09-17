import 'dart:collection';
import 'dart:math';

class Point {
  double x, y;
  Point([this.x=0.0, this.y=0.0]);
  Point pset([double x=0.0, double y=0.0]) {
    this.x = x; this.y = y;
    return this;
  }
  Point pcopy(Point o) {
    this.x = o.x; this.y = o.y;
    return this;
  }
  Point padd(Point o) => new Point(x+o.x, y+o.y);
  Point get pneg => new Point(-x, -y);
  double get pmag => sqrt(x*x + y*y);
}

abstract class Spatial<T extends Point> {
  LinkedHashSet<T> vals = new LinkedHashSet();
  bool add(T v);
  bool remove(T v);
  Iterable<T> within(double r, Point p);
}

class NaiveSpatial<T extends Point> extends Spatial<T> {
  bool add(T v) => vals.add(v);
  bool remove(T v) => vals.remove(v);
  Iterable<T> within(double r, Point p) =>
    vals.where((v) => pow(v.x-p.x, 2)+pow(v.y-p.y, 2) <= r*r);
}
