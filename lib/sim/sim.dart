import 'dart:html';
import '../spatial/spatial.dart';
import '../rvo/shapes.dart';
import '../rvo/agent.dart';

final Vec2 _p1 = new Vec2(0.0, 0.0), _p2 = new Vec2(80.0, 60.0);
class Sim {
  Vec2 p1 = _p1.vclone, p2 = _p2.vclone;
  Spatial<Shape> space = new NaiveSpatial(_p1.vclone, _p2.vclone);
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  double fps, t=0.0, last;
  Sim(this.canvas, this.fps) : ctx = canvas.getContext('2d') {
    window.requestAnimationFrame(raf);
    space.add(new Circle(0.0, 0.0, 0.5)
      ..ctrl = new Agent()
      ..v = new Vec2(0.5, 0.5));
  }
  void raf(double time) {
    if(last != null) tick((time-last)/1000);
    render();
    last = time;
    window.requestAnimationFrame(raf);
  }
  void tick(double dt) {
    for(Shape s in space.vals)
      s.ctrl.control(s, space);
    for(Shape s in space.vals)
      s.step(dt);
  }
  void render() {
    int w = canvas.width, h = canvas.height;
    Vec2 box = p2.vadd(p1.vneg);
    ctx.resetTransform();
    ctx.clearRect(0, 0, w, h);
    ctx.setTransform(w/box.x, 0, 0, -h/box.y, 0, h);
    ctx.translate(-p1.x, -p1.y);
    for(Shape s in space.vals)
      s.render(ctx);
  }
}
