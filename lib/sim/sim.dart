import 'dart:html';
import 'dart:math';
import 'dart:collection';

import '../spatial/spatial.dart';
import '../rvo/shapes.dart';
import '../rvo/agent.dart';

final Vec2 _p1 = new Vec2(0.0, 0.0), _p2 = new Vec2(2*80.0, 2*60.0);
class Sim {
  Vec2 p1 = _p1.vclone, p2 = _p2.vclone;
  Spatial<Shape> space = new NaiveSpatial(_p1.vclone, _p2.vclone);
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  double minfps, t=0.0, last;
  Sim(this.canvas, this.minfps) : ctx = canvas.getContext('2d') {
    window.animationFrame.then(raf);
    reset(120, 50.0, 0, 0);
  }
  void reset(int l, double rad, [int m=0, n=0, double vmul=1.0]) {
    space.clear();
    Vec2 center = _p2.vmul(0.5);
    for(int i=0; i<l; i++) {
      Vec2 offset = new Vec2.angle(i/l*2*PI, rad);
      space.add(new Circle.vec(center.vadd(offset), 0.5)
        ..ctrl = new Agent(center.vsub(offset)));
    }
    for(int i=0; i<n; i++) {
      for(int j=0; j<m; j++) {
        Vec2 offset = new Vec2(10.0*j/(m-1), vmul*40.0*i/(n-1));
        double vpos = (1-vmul)/2*40.0+10.0;
        Vec2 left = offset.vadd(new Vec2(20.0,vpos)).vmul(2.0),
          right = offset.vadd(new Vec2(50.0,vpos)).vmul(2.0);
        space.add(new Circle.vec(left, 0.5)
          ..ctrl = new Agent(right));
        space.add(new Circle.vec(right, 0.5)
          ..ctrl = new Agent(left));
      }
    }
  }
  void raf(double time) {
    if(last != null) tick(min(1/minfps, (time-last)/1000));
    render();
    last = time;
    window.animationFrame.then(raf);
  }
  void tick(double dt) {
    HashMap<Shape, Vec2> disps = new HashMap();
    // TODO subclass used in loop
    for(Circle s in space.vals) {
      s.ctrl.control(s, space);
      // TODO better selection process
      for(Circle o in space.within(s.r*2, s)) {
        double sqdist = s.vsub(o).vsqmag;
        if(sqdist <= pow((s.r+o.r)*1.1, 2)) {
          Vec2 push = s.vsub(o).vnorm(dt);
          s.v = s.v.vadd(push.vmul(3.0));
          if(sqdist <= pow(s.r+o.r, 2)) {
            disps.putIfAbsent(s, () => new Vec2());
            disps.putIfAbsent(o, () => new Vec2());
            disps[s] = disps[s].vadd(push);
            disps[o] = disps[o].vsub(push);
          }
        }
      }
    }
    for(Shape s in space.vals) {
      s.vcopy(s.vadd(disps[s]));
      s.step(dt);
    }
  }
  void render() {
    int w = canvas.width, h = canvas.height;
    Vec2 box = p2.vsub(p1);
    ctx.resetTransform();
    ctx.clearRect(0, 0, w, h);
    ctx.setTransform(w/box.x, 0, 0, -h/box.y, 0, h);
    ctx.translate(-p1.x, -p1.y);
    for(Shape s in space.vals)
      s.render(ctx);
  }
}
