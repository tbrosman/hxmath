# HxMath

## What it is

A game-oriented math library for the Haxe language using abstracts instead of classes to take advantage of Haxe's structural subtyping and maximize compatibility with existing libraries. Specifically, (most of) the abstracts are compatible with OpenFL's existing math structures: just cast to the abstract type, no copying necessary!

## Project Status

hxmath is at a reasonably stable point where the structures work consistently and have test coverage. There are additional features planned, but for the most part the 2D math portion will not change from this point on.

You can get the latest stable release on haxelib: http://lib.haxe.org/p/hxmath

## Features

* Lightweight and unencumbered: just math, nothing else. Use with your libraries of choice without including ten tons of redundant infrastructure (memory management, etc).

* Operator overloads!

Why write this:

```
    a.subtract(b).dot(c.cross(d))
```

when you can write this:

```
    (a - b) * (c ^ d)
```

('^' chosen due to the correspondence between the Hodge dual for 2-blades in 3-space and the cross product)

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

## Conventions

### Basic functions/properties

* All (linear) structures have the following operators: `==`, `!=`, `+`, `+=`, `-`, `-=`, and unary `-`.

* Additionally, `.addWith` and `.subtractWith` are available as functions for direct modification of the object. This is due to the fact you cannot overwrite `+=`, `-=`, etc directly and the generated implementations create new objects. For the `*with` operations, no new object is created and the additional structure of the underlying object is preserved.

* All structures have clone() functions.

### Products

* The product `*` operator is overloaded for multiple right-hand types: `matrix * matrix` will multiply two matrices, whereas `matrix * vector` will transform a vector. For vectors, the dot product is defined as `vector * vector`.

* The cross product between two Vector3 structures is defined using `^`, e.g. `Vector3.xAxis ^ Vector3.yAxis == Vector3.zAxis`.

### Matrix Indices

* All matrix indices are column-major and start at 0. For example, m10 is the element in the 2nd column of the 1st row.

* All matrix functions are row-major (left-to-right, top-to-bottom) so that when called the syntax mirrors the layout of the matrix.

## The Future

* Int-math types
 * Useful for tilemaps, voxel intersection, etc.
* Geometry
 * Polygon intersection (no collision processing, just the intersection portion), volume calculations, etc
