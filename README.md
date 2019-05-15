# HxMath

[![Build Status](https://travis-ci.org/tbrosman/hxmath.svg?branch=master)](https://travis-ci.org/tbrosman/hxmath)

Latest stable release: http://lib.haxe.org/p/hxmath

API documentation: http://tbrosman.github.io/hxmath

## What it is

A game-oriented math library for the Haxe language using abstracts instead of classes to allow for more expressive code while still using OpenFL's math types internally. Specifically, the 2D math abstracts use OpenFL types like flash.geom.Point and flash.geom.Matrix when `HXMATH_USE_OPENFL_STRUCTURES` is defined at compile time.

## Project Status

2D math is stable/reasonably fast on Flash and C++. All structures and most operations have test coverage. There are additional features planned, but most of these are beyond the domain of the core math (hxmath.math) structures.

## Features

### Lightweight and unencumbered
Just math, nothing else. Use with your libraries of choice without including ten tons of redundant infrastructure (memory management, etc).

### Operator overloads!

Why write this:

```haxe
a.subtract(b).dot(c.cross(d))
```

when you can write this:

```haxe
(a - b) * (c % d)
```

(`%` chosen due to operator precedence)

### Consistency across platforms

Abstracts allow consistency regardless of which implementation type is used.

Using OpenFL? Add `-D HXMATH_USE_OPENFL_STRUCTURES` to your build parameters and you can use OpenFL math types seamlessly with hxmath.

For example, since openfl.geom.Point will be the inner type, you can cast to a Vector2 without copying:
```haxe
var pointA = new flixel.util.FlxPoint(3.0, 2.0);
var pointACast:Vector2 = new Vector2(pointA.x, pointA.y);
var pointBCast:Vector2 = new flash.geom.Point(2.0, 1.0);

trace(pointACast * pointBCast);
```

Not using OpenFL? hxmath can run without it, falling back on its default inner types.

### 2D and 3D math
Both affine and linear structures:
  * Vector2, Vector3, Vector4
  * Matrix2x2, Matrix3x2, Matrix3x3, Matrix4x4
  * Quaternion

### Coordinate frames

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

## Conventions

### Basic functions/properties

* Operator overloads: All (linear) structures have the following operators: `==`, `!=`, `+`, `-`, and unary `-`.
  * Additionally, `.addWith` and `.subtractWith` are available as functions for direct modification of the object. This is due to the fact you cannot overwrite `+=`, `-=`, etc directly and the generated implementations create new objects. For the `*with` operations, no new object is created and the additional structure of the underlying object is preserved.

* `clone`, `copyTo`
  * `copyTo` is like clone, but without re-allocating.
  
* `copyToShape` and `copyFromShape` allow you to copy to/from shape-compatible types without writing custom conversion functions.

* Array access (read/write) for linear structures

* `lerp`
  * On linear structures and other objects as appropriate (e.g. you can interpolate between `Frame2` instances).

### Products

* The product `*` operator is overloaded for multiple right-hand types: `matrix * matrix` will multiply two matrices, whereas `matrix * vector` will transform a vector. For vectors, the dot product is defined as `vector * vector`.

* The cross product between two Vector3 structures is defined using `%`, e.g. `Vector3.xAxis % Vector3.yAxis == Vector3.zAxis`.

### Matrix Indices

* All matrix indices are column-major and start at 0. For example, m10 is the element in the 2nd column of the 1st row.

* All matrix functions are row-major (left-to-right, top-to-bottom) so that when called the syntax mirrors the layout of the matrix.

## The Future

* More int-math types
 * Useful for tilemaps, voxel intersection, etc.
* Geometry
 * Polygon intersection (no collision processing, just the intersection portion), volume calculations, etc
