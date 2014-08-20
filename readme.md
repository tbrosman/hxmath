# HxMath

[![Build Status](https://travis-ci.org/tbrosman/hxmath.svg?branch=master)](https://travis-ci.org/tbrosman/hxmath)

Latest stable release: http://lib.haxe.org/p/hxmath

API documentation: http://tbrosman.github.io/hxmath

## What it is

A game-oriented math library for the Haxe language using abstracts instead of classes to take advantage of Haxe's structural subtyping and maximize compatibility with existing libraries. Specifically, (most of) the abstracts are compatible with OpenFL's existing math structures: just cast to the abstract type, no copying necessary!

## Project Status

2D math is stable/reasonably fast on Flash and C++. All structures and most operations have test coverage. There are additional features planned, but most of these are beyond the domain of the core math (hxmath.math) structures.

## Features

* Lightweight and unencumbered: just math, nothing else. Use with your libraries of choice without including ten tons of redundant infrastructure (memory management, etc).

* Operator overloads!

Why write this:

```haxe
    a.subtract(b).dot(c.cross(d))
```

when you can write this:

```haxe
    (a - b) * (c ^ d)
```

('^' chosen due to the correspondence between the Hodge dual for 2-blades in 3-space and the cross product)

* Shape-compatible with (most of) the existing OpenFL math structures.
  * Note that the abstracts can no longer be cast from shape-similar structures without copying as of 0.7.0 (see issue #16). This is actually faster (especially on statically-typed platforms) due to the way abstracts over typedefs are implemented.

Specifically, you can cast both openfl.Vector to a Vector2 without copying, manually construct another Vector2 from FlxPoint (which has a different getter/setter signature for x/y), then use them together:
```haxe
        var pointA = new flixel.util.FlxPoint(3.0, 2.0);
        var pointACast:Vector2 = new Vector2(pointA.x, pointA.y);
        var pointBCast:Vector2 = new flash.geom.Point(2.0, 1.0);
        
        trace(pointACast * pointBCast);
```

* 2D and 3D math (both affine and linear structures)
  * Vector2, Vector3, Vector4
  * Matrix2x2, Matrix3x2, Matrix3x3, Matrix4x4
  * Quaternion

* Coordinate frames

More expressive than matrices with intuitive to/from notation. Example: say your character has an `armFrame` and a `bodyFrame`, with the `armFrame` oriented at a 90 degree angle to the `bodyFrame` and offset by 10 units up, 4 units right:

```haxe
    var armFrame = new Frame2(new Vector2(4.0, 10.0), 90);
```

To get a point defined in the `armFrame` into the `bodyFrame you would write:

```haxe
    var bodyPoint = armFrame.transformFrom(armPoint);
```

Similarly, to get a point from the `bodyFrame` to the `armFrame`:

```haxe
    var armPoint = armFrame.transformTo(bodyPoint);
```

If the `bodyFrame` is defined in the `worldFrame`, to create a combined transformation from the `armFrame` to `worldFrame`:

```haxe
    // In the from direction: apply armFrame.from followed by bodyFrame.from
	//   (bodyFrame.matrix * armFrame.matrix)
	// In the to direction:   apply bodyFrame.to  followed by armFrame.to   
	//   (armFrame.inverse().matrix * bodyFrame.inverse().matrix) == (bodyFrame * armFrame).inverse().matrix
    var armInWorldFrame = bodyFrame.concat(armFrame);
```

* More to come

## Conventions

### Basic functions/properties

* Operator overloads: All (linear) structures have the following operators: `==`, `!=`, `+`, `-`, and unary `-`.
  * Additionally, `.addWith` and `.subtractWith` are available as functions for direct modification of the object. This is due to the fact you cannot overwrite `+=`, `-=`, etc directly and the generated implementations create new objects. For the `*with` operations, no new object is created and the additional structure of the underlying object is preserved.

* `clone`, `copyTo`
  * `copyTo` is like clone, but without re-allocating.

* Array access (read/write) for linear structures

* `lerp`
  * On linear structures and other objects as appropriate (e.g. you can interpolate between `Frame2` instances).

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
