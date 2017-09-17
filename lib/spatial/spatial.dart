import 'dart:collection';
import 'dart:math';
Random rand = new Random();
class Vec2 {
  double x, y;
  Vec2([this.x=0.0, this.y=0.0]);
  Vec2.angle(double theta, [r=1.0]) : this(cos(theta)*r, sin(theta)*r);
  Vec2.rand([double r=1.0]) :
    this(r*(rand.nextDouble()*2-1),r*(rand.nextDouble()*2-1));
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
  Vec2 vsub(Vec2 o) => new Vec2(x-o.x, y-o.y);
  Vec2 vmul(double k) => new Vec2(k*x, k*y);
  double vdot(Vec2 o) => x*o.x + y*o.y;
  double vzcomp(Vec2 o) => x*o.y - y*o.x;
  Vec2 vproj(Vec2 o) => o.vmul(vdot(o)/o.vsqmag);
  Vec2 vnorm([double m=1.0]) => vmul(m/(vmag==0.0 ? 1.0 : vmag));
  Vec2 get vneg => new Vec2(-x, -y);
  double get vsqmag => x*x + y*y;
  double get vmag => sqrt(vsqmag);
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
