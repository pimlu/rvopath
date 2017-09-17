import 'dart:collection';
import 'dart:math';

class Vec2 {
  double x, y;
  Vec2([this.x=0.0, this.y=0.0]);
  Vec2 vset([double x=0.0, double y=0.0]) {
    this.x = x; this.y = y;
    return this;
  }
  Vec2 vcopy(Vec2 o) {
    this.x = o.x; this.y = o.y;
    return this;
  }
  Vec2 get vclone => new Vec2(x, y);
  // Hesitant to operator overload because Vec2 gets extended a lot
  Vec2 vadd(Vec2 o) => new Vec2(x+o.x, y+o.y);
  Vec2 vmul(double k) => new Vec2(k*x, k*y);
  Vec2 get vneg => new Vec2(-x, -y);
  double get vmag => sqrt(x*x + y*y);
}

abstract class Spatial<T extends Vec2> {
  LinkedHashSet<T> vals = new LinkedHashSet();
  final Vec2 tl, br;
  bool add(T v);
  bool remove(T v);
  Iterable<T> within(double r, Vec2 p);
  Spatial(this.tl, this.br);
}

class NaiveSpatial<T extends Vec2> extends Spatial<T> {
  bool add(T v) => vals.add(v);
  bool remove(T v) => vals.remove(v);
  Iterable<T> within(double r, Vec2 p) =>
    vals.where((v) => pow(v.x-p.x, 2)+pow(v.y-p.y, 2) <= r*r);
  NaiveSpatial(Vec2 tl, br) : super(tl, br);
}
