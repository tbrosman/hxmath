# VTG Math

## What it is

A game-oriented math library for the Haxe language using abstracts instead of classes to take advantage of Haxe's structural subtyping and maximize compatibility with existing libraries.

## Project Status

This project is in very early concept stages. That said, most of the structures are useable, but subject to change. The underlying shapes will remain the same though as the goal is to maintain maximum (within reason) compatibility with OpenFL.

## Features

* Lightweight and unencumbered: just math, nothing else. Use with your libraries of choice without including ten tons of redundant infrastructure (memory management, etc).

* Shape-compatible with (most of) the existing OpenFL math structures. This means no more copying/constructing new types to perform math operations.

Specifically, you can cast both openfl.Vector to a Vector2 without copying, manually construct another Vector2 from FlxPoint (which has a different getter/setter signature for x/y), then use them together:
```
        var pointA = new flixel.util.FlxPoint(3.0, 2.0);
        var pointACast:Vector2 = new Vector2(pointA.x, pointA.y);
        var pointBCast:Vector2 = new flash.geom.Point(2.0, 1.0);
        
        trace(pointACast * pointBCast);
```

In the case of the OpenFL Point, an intermediate variable isn't even required due to shape-compatibility!

* 2D and 3D math (both affine and linear structures).

* More to come

## The Future

* Int-math types
 * Useful for tilemaps, voxel intersection, etc.
* Geometry
 * Polygon intersection (no collision processing, just the intersection portion), volume calculations, etc
* Test case coverage
