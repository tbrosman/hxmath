package hxmath.math;

typedef Vector3Shape =
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
}

/**
 * The default underlying type.
 */
class Vector3Default
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
    
    public function new(x:Float, y:Float, z:Float)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public function toString():String
    {
        return '($x, $y, $z)';
    }
}

typedef Vector3Type = Vector3Default;

/**
 * A 3D vector.
 */
@:forward(x, y, z)
abstract Vector3(Vector3Type) from Vector3Type to Vector3Type
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 3;
    
    // Zero vector (v + 0 = v)
    public static var zero(get, never):Vector3;
    
    // X axis (1, 0, 0)
    public static var xAxis(get, never):Vector3;
    
    // Y axis (0, 1, 0)
    public static var yAxis(get, never):Vector3;
    
    // Z axis (0, 0, 1)
    public static var zAxis(get, never):Vector3;
    
    // Magnitude
    public var length(get, never):Float;
    
    // Vector dotted with itself
    public var lengthSq(get, never):Float;
    
    /**
     * Constructor.
     * 
     * @param x
     * @param y
     * @param z
     */
    public inline function new(x:Float, y:Float, z:Float)
    {
        this = new Vector3Default(x, y, z);
    }
    
    /**
     * Construct a Vector3 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Vector3
    {
        if (rawData.length != Vector3.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Vector3(rawData[0], rawData[1], rawData[2]);
    }
    
    /**
     * Convert a shape-similar vector.
     * 
     * @param other     The vector to convert.
     * @return          The hxmath equivalent.
     */
    @:from
    public static inline function fromVector3Shape(other:Vector3Shape):Vector3
    {
        return new Vector3(other.x, other.y, other.z);
    }
    
    /**
     * Dot product.
     * 
     * @param a
     * @param b
     * @return      sum_i (a_i * b_i)
     */
    @:op(A * B)
    public static inline function dot(a:Vector3, b:Vector3):Float
    {
        return
            a.x * b.x +
            a.y * b.y +
            a.z * b.z;
    }
    
    /**
     * Cross product. The resulting vector is orthogonal to the plane defined by the input vectors.
     * 
     * @param a
     * @param b
     * @return      a X b
     */
    @:op(A % B)
    public static inline function cross(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .crossWith(b);
    }
    
    /**
     * Multiply a scalar with a vector.
     * 
     * @param a
     * @param s
     * @return      s * a
     */
    @:op(A * B)
    @:commutative
    public static inline function multiply(a:Vector3, s:Float):Vector3
    {
        return a.clone()
            .multiplyWith(s);
    }
    
    /**
     * Divide a vector by a scalar.
     * 
     * @param s
     * @param a
     * @return      a / s
     */
    @:op(A / B)
    public static inline function divide(a:Vector3, s:Float):Vector3
    {
        return a.clone()
            .divideWith(s);
    }
    
    /**
     * Add two vectors.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .addWith(b);
    }
    
    /**
     * Subtract one vector from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .subtractWith(b);
    }
    
    /**
     * Create a negated copy of a vector.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a:Vector3):Vector3
    {
        return new Vector3(
            -a.x,
            -a.y,
            -a.z);
    }
    
    /**
     * Test element-wise equality between two vectors.
     * False if one of the inputs is null and the other is not.
     * 
     * @param a
     * @param b
     * @return     a_i == b_i
     */
    @:op(A == B)
    public static inline function equals(a:Vector3, b:Vector3):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.x == b.x && 
            a.y == b.y &&
            a.z == b.z;
    }
    
    /**
     * Linear interpolation between two vectors.
     * 
     * @param a     The value at t = 0
     * @param b     The value at t = 1
     * @param t     A number in the range [0, 1]
     * @return      The interpolated value
     */
    public static inline function lerp(a:Vector3, b:Vector3, t:Float):Vector3
    {
        return new Vector3(
            (1.0 - t) * a.x + t * b.x,
            (1.0 - t) * a.y + t * b.y,
            (1.0 - t) * a.z + t * b.z);
    }
    
    /**
     * Returns a vector built from the componentwise max of the input vectors.
     * 
     * @param a
     * @param b
     * @return      max(a_i, b_i)
     */
    public static inline function max(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .maxWith(b);
    }
    
    /**
     * Returns a vector built from the componentwise min of the input vectors.
     * 
     * @param a
     * @param b
     * @return      min(a_i, b_i)
     */
    public static inline function min(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .minWith(b);
    }
    
    /**
     * Returns a vector resulting from a vector projected onto the specified vector.
     * 
     * @param a
     * @param b
     * @return      (dot(self, a) / dot(a, a)) * a
     */
    public static inline function project(a:Vector3, b:Vector3):Vector3
    {
        return a.clone()
            .projectOnto(b);
    }
    
    /**
     * Returns a vector resulting from reflecting a vector around the specified normal.
     * 
     * @param a
     * @param b
     * @return       v - 2.0 * proj(v, normal)
     */
    public static inline function reflect(v:Vector3, normal:Vector3):Vector3
    {
        return v.clone()
            .reflectBy(normal);
    }
    
    /**
     * Ortho-normalize a set of vectors in place using the Gram-Schmidt process.
     * 
     * @param u
     * @param v
     * @param w
     */
    public static inline function orthoNormalize(u:Vector3, v:Vector3, w:Vector3):Void
    {
        u.normalize();
        
        v.subtractWith(Vector3.project(v, u));
        v.normalize();
        
        w.subtractWith(Vector3.project(w, u));
        w.subtractWith(Vector3.project(w, v));
        w.normalize();
    }
    
    /**
     * Sets all the fields of this structure without allocation.
     * 
     * @param x
     * @param y
     * @param z
     * @return self
     */
    public inline function set(x:Float, y:Float, z:Float):Vector3
    {
        var self:Vector3 = this;
        
        self.x = x;
        self.y = y;
        self.z = z;
        
        return self;
    }
    
    /**
     * Cross product in place. The resulting vector (this) is orthogonal to the plane defined by the input vectors.
     * Note: %= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self = self X a
     */
    public inline function crossWith(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        var newX = self.y * a.z - self.z * a.y;
        var newY = self.z * a.x - self.x * a.z;
        var newZ = self.x * a.y - self.y * a.x;
        
        self.x = newX;
        self.y = newY;
        self.z = newZ;
        
        return self;
    }
    
    /**
     * Multiply a vector with a scalar in place.
     * Note: *= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i *= s
     */
    public inline function multiplyWith(s:Float):Vector3
    {
        var self:Vector3 = this;
        
        self.x *= s;
        self.y *= s;
        self.z *= s;
        
        return self;
    }
    
    /**
     * Divide a vector by a scalar in place.
     * Note: /= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i /= s
     */
    public inline function divideWith(s:Float):Vector3
    {
        var self:Vector3 = this;
        
        self.x /= s;
        self.y /= s;
        self.z /= s;
        
        return self;
    }
    
    /**
     * Add a vector in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i += a_i
     */
    public inline function addWith(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        self.x += a.x;
        self.y += a.y;
        self.z += a.z;
        
        return self;
    }
    
    /**
     * Subtract a vector in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i -= a_i
     */
    public inline function subtractWith(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        self.x -= a.x;
        self.y -= a.y;
        self.z -= a.z;
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise max of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = max(self_i, a_i)
     */
    public inline function maxWith(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        self.x = Math.max(self.x, a.x);
        self.y = Math.max(self.y, a.y);
        self.z = Math.max(self.z, a.z);
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise min of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = min(self_i, a_i)
     */
    public inline function minWith(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        self.x = Math.min(self.x, a.x);
        self.y = Math.min(self.y, a.y);
        self.z = Math.min(self.z, a.z);
        
        return self;
    }
    
    /**
     * Returns a vector resulting from this vector projected onto the specified vector.
     * 
     * @param a
     * @return      self = (dot(self, a) / dot(a, a)) * a
     */
    public inline function projectOnto(a:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        var s:Float = (self * a) / (a * a);
        
        // Set self = s * a without allocating
        a.copyTo(self);
        self.multiplyWith(s);
        
        return self;
    }
    
    /**
     * Returns this vector projected into the plane defined by the specified normal.
     * 
     * @param normal    The normal to the plane.
     * @return          self = self - proj(self, normal)
     */
    public inline function projectOntoPlane(normal:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        self.subtractWith(Vector3.project(self, normal));
        
        return self;
    }
    
    /**
     * Returns a vector resulting from reflecting this vector around the specified normal.
     * 
     * @param normal
     * @return          self = self - 2.0 * proj(self, normal)
     */
    public inline function reflectBy(normal:Vector3):Vector3
    {
        var self:Vector3 = this;
        
        var projected:Vector3 = Vector3.project(self, normal);
        projected.multiplyWith(2.0);
        
        self.subtractWith(projected);
        
        return self;
    }
    
    /**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:Vector3):Void
    {
        var self:Vector3 = this;
        
        for (i in 0...Vector3.elementCount)
        {
            target[i] = self[i];
        }
    }
    
    /**
     * Copy the contents of this structure to another (shape-similar) instance.
     * 
     * @param target    The target structure.
     */
    public inline function copyToShape(target:Vector3Shape):Void
    {
        var self:Vector3 = this;
        
        target.x = self.x;
        target.y = self.y;
        target.z = self.z;
    }
    
    /**
     * Copy the contents of another (shape-similar) instance to this structure.
     * 
     * @param source    The source structure.
     */
    public inline function copyFromShape(source:Vector3Shape):Void
    {
        var self:Vector3 = this;
        
        self.x = source.x;
        self.y = source.y;
        self.z = source.z;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Vector3
    {
        var self:Vector3 = this;
        return new Vector3(self.x, self.y, self.z);
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
        var self:Vector3 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            case 2:
                return self.z;
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
        var self:Vector3 = this;
        switch (i)
        {
            case 0:
                return self.x = value;
            case 1:
                return self.y = value;
            case 2:
                return self.z = value;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Negate vector in-place.
     * 
     * @return  This.    
     */
    public inline function applyNegate():Vector3
    {
        var self:Vector3 = this;
        
        self.x = -self.x;
        self.y = -self.y;
        self.z = -self.z;
        
        return self;
    }
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Float->Float):Vector3
    {
        var self:Vector3 = this;
        
        for (i in 0...elementCount)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    /**
     * Find the arccosine of the angle between two vectors.
     * 
     * @param b     The other vector.
     * @return      The arccosine angle between this vector and the other in radians.
     */
    public inline function angleWith(b:Vector3):Float
    {
        var self:Vector3 = this;
        return Math.acos((self * b) / (self.length * b.length));
    }
    
    /**
     * Get the distance between this vector and another.
     * 
     * @param b
     * @return      |self - b|
     */
    public inline function distanceTo(b:Vector3):Float
    {
        var self:Vector3 = this;
        
        return (self - b).length;
    }
    
    /**
     * Normalize this vector.
     * 
     * @return  The modified object.
     */
    public inline function normalize():Vector3
    {
        var self:Vector3 = this;
        
        var length = self.length;
        
        if (length > 0.0)
        {
            self.divideWith(length);
        }
        
        return self;
    }
    
    /**
     * Normalize this vector and scale it to the specified length.
     * 
     * @param newLength     The new length to normalize to.
     * @return              The modified object.
     */
    public inline function normalizeTo(newLength:Float):Vector3
    {
        var self:Vector3 = this;
        
        self.normalize();
        self.multiplyWith(newLength);
        
        return self;
    }
    
    /**
     * Clamp this vector's length to the specified range.
     * 
     * @param min   The min length.
     * @param max   The max length.
     * @return      The modified object.
     */
    public inline function clamp(min:Float, max:Float):Vector3
    {
        var self:Vector3 = this;
        
        var length = self.length;
        
        if (length < min)
        {
            self.normalizeTo(min);
        }
        else if (length > max)
        {
            self.normalizeTo(max);
        }
        
        return self;
    }
    
    private inline function get_length():Float
    {
        var self:Vector3 = this;
        return Math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Vector3 = this;
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }
    
    private static inline function get_zero():Vector3
    {
        return new Vector3(0.0, 0.0, 0.0);
    }
    
    private static inline function get_xAxis():Vector3
    {
        return new Vector3(1.0, 0.0, 0.0);
    }
    
    private static inline function get_yAxis():Vector3
    {
        return new Vector3(0.0, 1.0, 0.0);
    }
    
    private static inline function get_zAxis():Vector3
    {
        return new Vector3(0.0, 0.0, 1.0);
    }
}

