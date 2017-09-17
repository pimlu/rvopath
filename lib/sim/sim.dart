import 'dart:html';
import 'dart:math';
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
    int n = 120;
    Vec2 center = _p2.vmul(0.5);
    double rad = 2*20.0;
    for(int i=0; i<n; i++) {
      Vec2 offset = new Vec2.angle(i/n*2*PI, rad);
      space.add(new Circle.vec(center.vadd(offset), 0.5)
        ..ctrl = new Agent(center.vsub(offset)));
    }
    /*int n = 30, m = 2;
    for(int i=0; i<n; i++) {
      for(int j=0; j<m; j++) {
        Vec2 offset = new Vec2(20.0*j/m, 40.0*i/n);
        Vec2 left = offset.vadd(new Vec2(10.0,10.0)).vmul(2.0),
          right = offset.vadd(new Vec2(50.0,10.0)).vmul(2.0);
        space.add(new Circle.vec(left, 0.5)
          ..ctrl = new Agent(right));
        space.add(new Circle.vec(right, 0.5)
          ..ctrl = new Agent(left));

      }
    }*/
    window.animationFrame.then(raf);
  }
  void raf(double time) {
    if(last != null) tick(min(1/minfps, (time-last)/1000));
    render();
    last = time;
    window.animationFrame.then(raf);
  }
  void tick(double dt) {
    // TODO subclass used in loop
    for(Circle s in space.vals) {
      s.ctrl.control(s, space);
      // TODO better selection process
      for(Circle o in space.within(s.r*2, s)) {
        if(s.vsub(o).vsqmag <= pow((s.r+o.r)*1.1, 2)) {
          s.v = s.v.vadd(s.vsub(o).vnorm(3*dt));
        }
      }
    }
    for(Shape s in space.vals)
      s.step(dt);
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
