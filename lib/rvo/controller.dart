import '../spatial/spatial.dart';
import 'shapes.dart';

abstract class Controller {
  Vec2 goalv = new Vec2();
  void control(Shape shape, Spatial<Shape> space);
}
