package hxmath.math;
// initial version based on nanjizal/geom/matrix/DualQuaternion
// @author: Nanjizal
typedef DualQuaternionShape = 
{
    public var real:Quaternion;
    public var dual:Quaternion;
}

/**
 * The default underlying type.
 */
class DualQuaternionDefault
{
    public var real:Quaternion;
    public var dual:Quaternion;
    
    public function new(real:Quaternion, dual:Quaternion)
    {
        this.real = real;
        this.dual = dual;
    }
    
    public function toString():String
    {
        return '[$real, $dual]';
    }
}

typedef DualQuaternionType = DualQuaternionDefault;

/**
 * DualQuaternion for 3D transformation, similar to a Vector4 and Quaternion
 */
@:forward(real,dual)
abstract DualQuaternion(DualQuaternionType) from DualQuaternionType to DualQuaternionType
{
    // The number of elements in this structure ( 4 real + 4 dual )
    public static inline var elementCount:Int = 8;
    
    // Zero dual quaternion 
    public static var zero(get, never):DualQuaternion;
    
    // One/identity dual quaternion 
    public static var identity(get, never):DualQuaternion;
    
    // Gets the corresponding transform matrix
    public var matrix(get, never):Matrix4x4;
    
    // Magnitude
    public var length(get, never):Float;
    
    // Dual Quaternion dotted with itself
    public var lengthSq(get, never):Float;
    
    // The normalized dual quaternion
    public var normal(get, never):DualQuaternion;
    
    /**
     * Constructor.
     * 
     * @param real  Quaternion Real
     * @param dual  Quaternion Dual
     */
    public inline function new(real:Quaternion, dual:Quaternion) 
    {
        this = new DualQuaternionDefault(real, dual);
    }
    
    /**
     * Construct a DualQuaternion the easy way
     * from a rotational Quaternion and a translation Vector4
     * 
     * @param r         The Real Quaternion ( angle )
     * @param t         The Vector4 ( translation )
     * @return          The DualQuaternion
     */
    public static inline function create(r: Quaternion, t: Vector4 ):DualQuaternion
    {
        var real = r.normalize();
        var q = new Quaternion( 0., t.x, t.y, t.z );
        q = q*0.5;
        var dual = q * real;
        return new DualQuaternion(real, dual);
    }
    
    /**
     * Construct a DualQuaternion using axis angle 
     * axis angle in degrees and axis vector3, translation in vector4
     * 
     * @param angleDegrees  The angle to rotate in degrees.
     * @param axis          The axis to rotate around.
     * @param t             The Vector4 ( translation )
     * @return              The DualQuaternion
     */
    public static inline function fromAxisAngle( angleDegrees:Float
                                                , axis: Vector3
                                                , vec4: Vector4 ):DualQuaternion 
    {
        return create(Quaternion.fromAxisAngle(angleDegrees,axis),vec4);
    }
    
    /**
     * Construct a DualQuaternion using axis angle in radians and translation in vector4
     * 
     * @param angleDegrees  The angle to rotate in degrees.
     * @param axis          The axis to rotate around.
     * @param t             The Vector4 ( translation )
     * @return              The DualQuaternion
     */
    public static inline function fromAxisRadian( theta:Float
                                                , axis: Vector3
                                                , vec4: Vector4 ):DualQuaternion 
    {
        var cosHalfAngle = Math.cos(theta / 2.0);
        var sinHalfAngle = Math.sin(theta / 2.0);
        var real = new Quaternion(cosHalfAngle,sinHalfAngle * axis.x,sinHalfAngle * axis.y,
        sinHalfAngle * axis.z);
        return create(real,vec4);
    }
    
    /**
     * Extract the Vector4 part of a DualQuaternion
     * 
     * @return          The translation Vector
     */
    public inline function getTranslation(): Vector4 
    {
        var q = ( this.dual * 2. );
        q = q * ~this.real;
        return new Vector4(q.x, q.y, q.z, 1.);
    }
    
    /**
     * Extract the Real Quaternion the 3D angle as a copy
     * Particularly useful as it clarifies that the Rotation
     * 
     * @return         The rotational Quaternion
     */
    public inline function getRotationQuat(): Quaternion 
    {
        return this.real.clone();
    }
    
    /**
     * Construct a DualQuaternion from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    @:from
    public static inline function fromArray(rawData:Array<Float>):DualQuaternion
    {
        if (rawData.length != DualQuaternion.elementCount)
        {
            throw "Invalid rawData.";
        }
        var real = new Quaternion(rawData[0], rawData[1], rawData[2], rawData[3]);
        var dual = new Quaternion(rawData[4], rawData[5], rawData[6], rawData[7]);
        return new DualQuaternion(real, dual);
    }
    
    /**
     * Creates a Scalar DualQuaternion
     * 
     * @param s         The scale value
     * @return          The Scalar DualQuaternion
     */
    public static inline function scalar(s: Float):DualQuaternion
    {
        return new DualQuaternion(Quaternion.scalarReal( s ), Quaternion.zero);
    }
    
    /**
     * Clone.
     * 
     * @return          The cloned object.
     */
    public inline function clone():DualQuaternion
    {
        return new DualQuaternion( this.real.clone(), this.dual.clone() );
    }
    
    /**
     * dot product
     *
     * @param a         one DualQuaternion
     * @param b         another DualQuaternion
     * @return          the dot product.
     */
    public static inline function dot(a:DualQuaternion, b:DualQuaternion):Float
    {
        return Quaternion.dot(a.real.clone(), b.real.clone());
    }
    
    /**
     * Create a complex conjugate copy of a dualquaternion
     * 
     * @param a
     * @return       ~a
     */
    @:op(~A)
    public static inline function conjugate(a: DualQuaternion):DualQuaternion
    {
        return new DualQuaternion(~a.real, ~a.dual);
    }
    
    /**
     * Create a negated copy of a dualquaternion.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a: DualQuaternion):DualQuaternion
    {
        return new DualQuaternion(-a.real, -a.dual);
    }
    
    /**
     * check if equal
     * 
     * @param a
     * @param b
     * @return       a==b
     */
    @:op( A == B )
    public static inline
    function equal(a:DualQuaternion, b:DualQuaternion):Bool
    {
       return (a == null && b == null) ||
              a != null &&
              b != null &&
              a.real == b.real &&
              a.dual == b.dual;
    }
    
    /**
     * check if not equal
     * 
     * @param a
     * @param b
     * @return       a!==b
     */
    @:op(A != B)
    public static inline
    function notEqual(a:DualQuaternion, b:DualQuaternion):Bool
    {
        return !equal( a, b );
    }
    
    /**
     * multiply by constant see also applyScale
     * 
     * @param a
     * @param v
     * @return       a*v
     */
    @:op(A * B)
    @:commutative 
    public static inline 
    function scaleMultiply(a:DualQuaternion, v:Float):DualQuaternion
    {
        return new DualQuaternion(a.real * v, a.dual * v);
    }
    
    /**
     * divide by constant
     * 
     * @param a
     * @param v
     * @return       a/v
     */
    @:op(A / B)
    public static inline
    function divide(a:DualQuaternion, v:Float):DualQuaternion
    {
        return a * ( 1 / v );
    }
    
    /**
     * applyScale
     * 
     * @param a
     * @return       scaled 
     */
    public inline function applyScale(s:Float):DualQuaternion
    {
        var cloned = clone();
        cloned = cloned*DualQuaternion.scalar( s );
        return cloned;
    }
    
    /**
     * Add two dual quaternions.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:DualQuaternion, b:DualQuaternion):DualQuaternion
    {
        return a.clone()
            .addWith(b);
    }
    
    /**
     * Add a quaternion in place.
     * 
     * @param a
     * @return      self_i += a_i
     */
    public inline function addWith(a:DualQuaternion):DualQuaternion
    {
        return new DualQuaternion( this.real - a.real, this.dual - a.dual );
    }
    
    /**
     * Subtract one dual quaternion from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:DualQuaternion, b:DualQuaternion):DualQuaternion
    {
        return a.clone()
            .subtractWith(b);
    }
    
    /**
     * Subtract a dual quaternion in place.
     *
     * @param a
     * @return      self_i -= a_i
     */
    public inline function subtractWith(a:DualQuaternion):DualQuaternion
    {
        return new DualQuaternion( this.real - a.real, this.dual - a.dual );
    }
    
    /**
     * Multiply two dualquaternions.
     * 
     * @param a
     * @param b
     * @return      a * b
     */
    @:op(A * B)
    public static inline
    function multiplyQ( q1: DualQuaternion, q2: DualQuaternion ):DualQuaternion
    {
        return new DualQuaternion(q2.real * q1.real, q2.dual * q1.real + q1.dual * q2.real);
    }
    
    private static inline function get_zero(): DualQuaternion
    {
        return new DualQuaternion(Quaternion.zero, Quaternion.zero);
    }
    
    private static inline function get_identity():DualQuaternion
    {
        return new DualQuaternion(Quaternion.identity, Quaternion.identity);
    }
    
    private inline function get_normal():DualQuaternion
    {
        var mag = dot(this, this);
        if( mag < 0 ) return null;
        var oneOver = 1/mag;
        return new DualQuaternion(this.real*oneOver, this.dual*oneOver);
    }
    
    /**
     * Normalize the quaternion in-place.
     * 
     * @return  The modified object.
     */
    public inline function normalize(): DualQuaternion
    {
        var mag = dot( this, this );
        if( mag < 0 ) return null;
        var oneOver = 1/mag;
        var self: DualQuaternion = this;
        self.real = this.real*oneOver;
        self.dual = this.dual*oneOver;
        return self;
    }
    
    private inline function get_length():Float
    {
        return Math.sqrt(dot(this, this));
    }
    
    private inline function get_lengthSq():Float
    {
        return dot( this, this );
    }
    
    private inline function get_matrix():Matrix4x4
    {
        var self: DualQuaternion = this;
        var m: Matrix4x4 = self;
        return m;
    }
    
    @:to
    public inline function toMatrix4x4(): Matrix4x4
    {
        var q = normalize();
        var m = Matrix4x4.identity;
        var s = q.real.s;
        var x = q.real.x;
        var y = q.real.y;
        var z = q.real.z;
        // Extract rotational information
        m.m00 = s*s + x*x - y*y - z*z;
        m.m01 = 2*x*y + 2*s*z;
        m.m02 = 2*x*z - 2*s*y;
        m.m03 = 0.;
        m.m10 = 2*x*y - 2*s*z;
        m.m11 = s*s + y*y - x*x - z*z;
        m.m12 = 2*y*z + 2*s*x;
        m.m13 = 0.;
        m.m20 = 2*x*z + 2*s*y;
        m.m21 = 2*y*z - 2*s*x;
        m.m22 = s*s + z*z - x*x - y*y; 
        m.m23 = 0.;
        // Extract translation information
        var t = q.getTranslation();
        m.m30 = t.x;
        m.m31 = t.y;
        m.m32 = t.z;
        // pad last row
        m.m33 = 1.;
        return m;
    }
    
    /**
     * Linear interpolation between two dual quaternions, needs testing think it will work!?
     * 
     * @param a     The value at t = 0
     * @param b     The value at t = 1
     * @param t     A number in the range [0, 1]
     * @return      The interpolated value
     */
    public static inline function lerp(a:DualQuaternion, b:DualQuaternion, t:Float):DualQuaternion
    {
        return new DualQuaternion( Quaternion.lerp(a.real, b.real,t)
                                 , Quaternion.lerp(a.dual, b.dual,t)
                                 );
    }
    
    public static inline function slerp(a:DualQuaternion, b:DualQuaternion, t:Float):DualQuaternion
    {
        return new DualQuaternion( Quaternion.slerp(a.real, b.real,t)
                                 , Quaternion.slerp(a.dual, b.dual,t)
                                 );
    }
    
    /**
     * Sets real fields of this structure without allocation.
     * does not normalize see 'create'
     * 
     * @param s
     * @param x
     * @param y
     * @param z
     * @return self
     */
    public inline function setReal(s:Float, x:Float, y:Float, z:Float):DualQuaternion
    {
        var self: DualQuaternion = this;
        this.real.set(s, x, y, z);
        return self;
    }
    
    /**
     * Sets real fields of this structure without allocation.
     * 
     * @param s
     * @param x
     * @param y
     * @param z
     * @return self
     */
    public inline function setDual(s:Float, x:Float, y:Float, z:Float):DualQuaternion
    {
        var self: DualQuaternion = this;
        this.dual.set(s, x, y, z);
        return self;
    }
    /**
     * Create an inverted copy.
     * 
     * @return  The inverse.
     */
    public inline function invert():DualQuaternion
    {
        return new DualQuaternion( this.real.invert(), this.dual.invert() );
    }
    
    /**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:DualQuaternion):Void
    {
        target.real.copyTo( this.real );
        target.dual.copyTo( this.dual );
    }
    
    
    /**
     * Get an element by position.
     * 
     * @param i         The element index.
     * @return          The element.
     */
    @:arrayAccess
    public inline function getArrayElement(i:Int):Float
    {
        var self:DualQuaternion = this;
        switch (i)
        {
            case 0:
                return self.real.s;
            case 1:
                return self.real.x;
            case 2:
                return self.real.y;
            case 3:
                return self.real.z;
            case 4:
                return self.dual.s;
            case 5:
                return self.dual.x;
            case 6:
                return self.dual.y;
            case 7:
                return self.dual.z;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Set an element by position.
     * 
     * @param i         The element index.
     * @param value     The new value.
     * @return          The updated element.
     */
    @:arrayAccess
    public inline function setArrayElement(i:Int, value:Float):Float
    {
        var self:DualQuaternion = this;
        switch (i)
        {
            case 0:
                return self.real.s = value;
            case 1:
                return self.real.x = value;
            case 2:
                return self.real.y = value;
            case 3:
                return self.real.z = value;
            case 4:
                return self.dual.s = value;
            case 5:
                return self.dual.x = value;
            case 6:
                return self.dual.y = value;
            case 7:
                return self.dual.z = value;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Rotate the given vector, assuming the current DualQuaternion is normalized (if not, normalize first).
     * 
     * @param u     The vector to rotate.
     * @return      The rotated vector.
     */
    public inline function rotate(u:Vector3):Vector3
    {
        normalize();
        return this.real.rotate(u);
    }
    
    
    /**
     * Find the arccosine of the angle between two rotation quaternions in the DualQuaternion
     * 
     * @param b     The other quaternion.
     * @return      The arccosine angle between this vector and the other in radians.
     */
    public inline function angleWith(b:Quaternion):Float
    {
        return 2.0 * Math.acos(Quaternion.dot(this.real, b) / (this.real.length * b.length));
    }
    
    
    /**
     * Conjugate the quaternion in-place.
     * 
     * @return  The modified object.
     */
    public inline function applyConjugate():DualQuaternion
    {
        this.real.applyConjugate;
        this.dual.applyConjugate;
        var self: DualQuaternion = this;
        return this;
    }
    
    /**
     * Invert the quaternion in-place. Useful when the quaternion may have been denormalized.
     * 
     * @return  The modified object.
     */
    public inline function applyInvert():DualQuaternion
    {
        this.real.applyInvert;
        this.dual.applyInvert;
        var self: DualQuaternion = this;
        return self;
    }
}