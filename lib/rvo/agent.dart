import 'dart:math';

import '../spatial/spatial.dart';

import 'controller.dart';
import 'shapes.dart';

final int scanRes = 17;//, subscanRes = 4, scanDepth = 2;

class Agent extends Controller {
  Vec2 goalp;
  double w = 10.0, u=1.0;
  double seeDist = 5.0;
  double maxa = 10.0;
  Agent(this.goalp);
  @override
  void control(Shape shape, Spatial<Shape> space) {
    List<Shape> local = space.within(seeDist, shape).where((s) => shape!=s)
      .toList(growable: false);
    double maxv = shape.maxv;
    Vec2 goalv = goalp.vsub(shape).vnorm(maxv);
    Vec2 oldv = shape.v, bestv = new Vec2();
    double best = double.INFINITY;
    double width = 2.0/(scanRes-1);
    for(int i=0; i<scanRes; i++) {
      for(int j=0; j<scanRes; j++) {
        shape.v = new Vec2(maxv*(-1+j*width), maxv*(-1+i*width));
        if(shape.v.vmag > maxv) continue;

        double colt = local.map((s) => shape.vo(s)).fold(double.INFINITY, min);
        double dmag = shape.v.vsub(goalv).vmag;
        double rot = u*shape.v.vnorm().vzcomp(goalv.vnorm());
        double penalty = w/colt + dmag + rot;
        if(penalty < best) {
          best = penalty;
          bestv = shape.v;
        }
      }
    }
    /*width *= maxv;
    // binary search on our point
    for(int iter=0; iter<scanDepth; iter++) {
      for(int i=0; i<subscanRes; i++) {
        for(int j=0; j<subscanRes; j++) {

        }
      }
    }*/

    shape.v = oldv;
    acc = bestv.vadd(bestv.vsub(goalv).vmul(0.1))/*.vadd(goalv).vmul(0.5)*/
      .vsub(shape.v).vnorm(maxa);
  }
}
