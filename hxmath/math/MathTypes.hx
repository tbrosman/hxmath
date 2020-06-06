package hxmath.math;

// This class provides underlying types used by HxMath.
// It's possible to override those types by creating `hxmath/math/MathTypes.hx` file
// in your project and defining all types with your own.
#if HXMATH_USE_OPENFL_STRUCTURES
typedef IntVector2Type = hxmath.math.IntVector2.IntVector2Default;
typedef Matrix2x2Type = hxmath.math.Matrix2x2.Matrix2x2Default;
typedef Matrix3x2Type = flash.geom.Matrix;
typedef Matrix3x3Type = hxmath.math.Matrix3x3.Matrix3x3Default;
typedef Matrix4x4Type = hxmath.math.Matrix4x4.Matrix4x4Default;
typedef QuaternionType = hxmath.math.Quaternion.QuaternionDefault;
typedef Vector2Type = flash.geom.Point;
typedef Vector3Type = hxmath.math.Vector3.Vector3Default;
typedef Vector4Type = flash.geom.Vector3D;
#elseif HXMATH_USE_HEAPS_STRUCTURES

typedef IntVector2Type = h2d.col.IPoint;
typedef Vector2Type = h2d.col.Point;
typedef Vector3Type = h3d.col.Point;
typedef Vector4Type = h3d.Vector;

typedef Matrix2x2Type = hxmath.math.Matrix2x2.Matrix2x2Default;
typedef Matrix3x3Type = hxmath.math.Matrix3x3.Matrix3x3Default;

// Heaps 3x2 matrix uses [x, y] as translation name instead of [tx, ty].
@:forward
abstract Matrix3x2Type(h2d.col.Matrix) from h2d.col.Matrix to h2d.col.Matrix
{
  
  public inline function new(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
  {
    this = new h2d.col.Matrix();
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.x = tx;
    this.y = ty;
  }
  
  public var tx(get, set):Float;
  private inline function get_tx():Float return this.x;
  private inline function set_tx(v:Float):Float return this.x = v;
  
  public var ty(get, set):Float;
  private inline function get_ty():Float return this.y;
  private inline function set_ty(v:Float):Float return this.y = v;
}

// Heaps uses different naming convention for matrix with following mapping:
// [      hmath       ] -> [      heaps       ]
// [m00, m10, m20, m30] -> [_11, _12, _13, _14]
// [m01, m11, m21, m31] -> [_21, _22, _23, _24]
// [m02, m12, m22, m32] -> [_31, _32, _33, _34]
// [m03, m13, m23, m33] -> [_41, _42, _43, _44]
@:forward
abstract Matrix4x4Type(h3d.Matrix) from h3d.Matrix to h3d.Matrix
{
  public inline function new(m00:Float, m10:Float, m20:Float, m30:Float,
        m01:Float, m11:Float, m21:Float, m31:Float,
        m02:Float, m12:Float, m22:Float, m32:Float,
        m03:Float, m13:Float, m23:Float, m33:Float)
  {
    this = new h3d.Matrix();
    this._11 = m00; this._12 = m10; this._13 = m20; this._14 = m30;
    this._21 = m01; this._22 = m11; this._23 = m21; this._24 = m31;
    this._31 = m02; this._32 = m12; this._33 = m22; this._34 = m32;
    this._41 = m03; this._42 = m13; this._43 = m23; this._44 = m33;
  }
  
  public var m00(get, set):Float;
  private inline function get_m00():Float return this._11;
  private inline function set_m00(v:Float):Float return this._11 = v;
  
  public var m10(get, set):Float;
  private inline function get_m10():Float return this._12;
  private inline function set_m10(v:Float):Float return this._12 = v;
  
  public var m20(get, set):Float;
  private inline function get_m20():Float return this._13;
  private inline function set_m20(v:Float):Float return this._13 = v;
  
  public var m30(get, set):Float;
  private inline function get_m30():Float return this._14;
  private inline function set_m30(v:Float):Float return this._14 = v;
  
  public var m01(get, set):Float;
  private inline function get_m01():Float return this._21;
  private inline function set_m01(v:Float):Float return this._21 = v;
  
  public var m11(get, set):Float;
  private inline function get_m11():Float return this._22;
  private inline function set_m11(v:Float):Float return this._22 = v;
  
  public var m21(get, set):Float;
  private inline function get_m21():Float return this._23;
  private inline function set_m21(v:Float):Float return this._23 = v;
  
  public var m31(get, set):Float;
  private inline function get_m31():Float return this._24;
  private inline function set_m31(v:Float):Float return this._24 = v;
  
  public var m02(get, set):Float;
  private inline function get_m02():Float return this._31;
  private inline function set_m02(v:Float):Float return this._31 = v;
  
  public var m12(get, set):Float;
  private inline function get_m12():Float return this._32;
  private inline function set_m12(v:Float):Float return this._32 = v;
  
  public var m22(get, set):Float;
  private inline function get_m22():Float return this._33;
  private inline function set_m22(v:Float):Float return this._33 = v;
  
  public var m32(get, set):Float;
  private inline function get_m32():Float return this._34;
  private inline function set_m32(v:Float):Float return this._34 = v;
  
  public var m03(get, set):Float;
  private inline function get_m03():Float return this._41;
  private inline function set_m03(v:Float):Float return this._41 = v;
  
  public var m13(get, set):Float;
  private inline function get_m13():Float return this._42;
  private inline function set_m13(v:Float):Float return this._42 = v;
  
  public var m23(get, set):Float;
  private inline function get_m23():Float return this._43;
  private inline function set_m23(v:Float):Float return this._43 = v;
  
  public var m33(get, set):Float;
  private inline function get_m33():Float return this._44;
  private inline function set_m33(v:Float):Float return this._44 = v;
}

// Heaps Quaternion use `w` instead of `s` to store scalar.
@:forward
abstract QuaternionType(h3d.Quat) from h3d.Quat to h3d.Quat
{
  
  public inline function new(s:Float, x:Float, y:Float, z:Float)
  {
    this = new h3d.Quat(x, y, z, s);
  }
  
  public var s(get, set):Float;
  private inline function get_s():Float return this.w;
  private inline function set_s(v:Float):Float return this.w = v;
  
}

#else
typedef IntVector2Type = hxmath.math.IntVector2.IntVector2Default;
typedef Matrix2x2Type = hxmath.math.Matrix2x2.Matrix2x2Default;
typedef Matrix3x2Type = hxmath.math.Matrix3x2.Matrix3x2Default;
typedef Matrix3x3Type = hxmath.math.Matrix3x3.Matrix3x3Default;
typedef Matrix4x4Type = hxmath.math.Matrix4x4.Matrix4x4Default;
typedef QuaternionType = hxmath.math.Quaternion.QuaternionDefault;
typedef Vector2Type = hxmath.math.Vector2.Vector2Default;
typedef Vector3Type = hxmath.math.Vector3.Vector3Default;
typedef Vector4Type = hxmath.math.Vector4.Vector4Default;
#end