## RVO avoidance

This is an implementation of [Reciprocal Velocity Obstacles](http://gamma.cs.unc.edu/RVO/icra2008.pdf) for RAMHacks 2017.

It's an obstacle avoidance algorithm which takes into account the velocity of the obstacle it's avoiding, so that you don't get the oscillation you often see when lots of agents pathfind around each other.  I also added a small factor preferring avoidance towards one side, which improves performance even when symmetry is already broken.

It's written in Dart and features reusable vector functions to have cleaner math.  These are automatically inlined by dart2js, so there isn't a performance detriment.

### Running

Just run `pub get` and `pub serve`.

This software is a derivative of the MIT-licensed Angular Dart quickstart, (c) 2017 Google.
