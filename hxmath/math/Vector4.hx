package hxmath.math;

typedef Vector4Shape =
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;
}

/**
 * The default underlying type.
 */
class Vector4Default
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;
    
    public function new(x:Float, y:Float, z:Float, w:Float)
    {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }
    
    public function toString():String
    {
        return '($x, $y, $z, $w)';
    }
}

#if HXMATH_USE_OPENFL_STRUCTURES
typedef Vector4Type = flash.geom.Vector3D;
#else
typedef Vector4Type = Vector4Default;
#end

/**
 * A 4D vector (used with homogenous/projection matrices in 3D).
 */
@:forward(x, y, z, w)
abstract Vector4(Vector4Type) from Vector4Type to Vector4Type
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 4;
    
    // Zero vector (v + 0 = v)
    public static var zero(get, never):Vector4;
    
    // X axis (1, 0, 0, 0)
    public static var xAxis(get, never):Vector4;
    
    // Y axis (0, 1, 0, 0)
    public static var yAxis(get, never):Vector4;
    
    // Z axis (0, 0, 1, 0)
    public static var zAxis(get, never):Vector4;
    
    // W axis (0, 0, 0, 1)
    public static var wAxis(get, never):Vector4;
    
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
     * @param w
     */
    public inline function new(x:Float, y:Float, z:Float, w:Float)
    {
        #if HXMATH_USE_OPENFL_STRUCTURES
        this = new flash.geom.Vector3D(x, y, z, w);
        #else
        this = new Vector4Default(x, y, z, w);
        #end
    }
    
    /**
     * Construct a Vector4 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Vector4
    {
        if (rawData.length != Vector4.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Vector4(rawData[0], rawData[1], rawData[2], rawData[3]);
    }
    
    /**
     * Convert a shape-similar vector.
     * 
     * @param other     The vector to convert.    
     * @return          The hxmath equivalent.
     */
    @:from
    public static inline function fromVector4Shape(other:Vector4Shape):Vector4
    {
        return new Vector4(other.x, other.y, other.z, other.w);
    }
    
    /**
     * Dot product.
     * 
     * @param a
     * @param b
     * @return      sum_i (a_i * b_i)
     */
    @:op(A * B)
    public static inline function dot(a:Vector4, b:Vector4):Float
    {
        return
            a.x * b.x +
            a.y * b.y +
            a.z * b.z +
            a.w * b.w;
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
    public static inline function multiply(a:Vector4, s:Float):Vector4
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
    public static inline function divide(a:Vector4, s:Float):Vector4
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
    public static inline function add(a:Vector4, b:Vector4):Vector4
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
    public static inline function subtract(a:Vector4, b:Vector4):Vector4
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
    public static inline function negate(a:Vector4):Vector4
    {
        return new Vector4(
            -a.x,
            -a.y,
            -a.z,
            -a.w);
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
    public static inline function equals(a:Vector4, b:Vector4):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.x == b.x &&
            a.y == b.y &&
            a.z == b.z &&
            a.w == b.w;
    }
    
    /**
     * Linear interpolation between two vectors.
     * 
     * @param a     The value at t = 0
     * @param b     The value at t = 1
     * @param t     A number in the range [0, 1]
     * @return      The interpolated value
     */
    public static inline function lerp(a:Vector4, b:Vector4, t:Float):Vector4
    {
        return new Vector4(
            (1.0 - t) * a.x + t * b.x,
            (1.0 - t) * a.y + t * b.y,
            (1.0 - t) * a.z + t * b.z,
            (1.0 - t) * a.w + t * b.w);
    }
    
    /**
     * Returns a vector built from the componentwise max of the input vectors.
     * 
     * @param a
     * @param b
     * @return      max(a_i, b_i)
     */
    public static inline function max(a:Vector4, b:Vector4):Vector4
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
    public static inline function min(a:Vector4, b:Vector4):Vector4
    {
        return a.clone()
            .minWith(b);
    }
    
    /**
     * Returns a vector resulting from this vector projected onto the specified vector.
     * 
     * @param a
     * @param b
     * @return      (dot(self, a) / dot(a, a)) * a
     */
    public static inline function project(a:Vector4, b:Vector4):Vector4
    {
        return a.clone()
            .projectOnto(b);
    }
    
    /**
     * Sets all the fields of this structure without allocation.
     * 
     * @param x
     * @param y
     * @param z
     * @param w
     * @return self
     */
    public inline function set(x:Float, y:Float, z:Float, w:Float):Vector4
    {
        var self:Vector4 = this;
        
        self.x = x;
        self.y = y;
        self.z = z;
        self.w = w;
        
        return self;
    }
    
    /**
     * Multiply a vector with a scalar in place.
     * Note: *= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i *= s
     */
    public inline function multiplyWith(s:Float):Vector4
    {
        var self:Vector4 = this;
        
        self.x *= s;
        self.y *= s;
        self.z *= s;
        self.w *= s;
        
        return self;
    }
    
    /**
     * Divide a vector by a scalar in place.
     * Note: /= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i /= s
     */
    public inline function divideWith(s:Float):Vector4
    {
        var self:Vector4 = this;
        
        self.x /= s;
        self.y /= s;
        self.z /= s;
        self.w /= s;
        
        return self;
    }
    
    /**
     * Add a vector in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i += a_i
     */
    public inline function addWith(a:Vector4):Vector4
    {
        var self:Vector4 = this;
        
        self.x += a.x;
        self.y += a.y;
        self.z += a.z;
        self.w += a.w;
        
        return self;
    }
    
    /**
     * Subtract a vector in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i -= a_i
     */
    public inline function subtractWith(a:Vector4):Vector4
    {
        var self:Vector4 = this;
        
        self.x -= a.x;
        self.y -= a.y;
        self.z -= a.z;
        self.w -= a.w;
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise max of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = max(self_i, a_i)
     */
    public inline function maxWith(a:Vector4):Vector4
    {
        var self:Vector4 = this;
        
        self.x = Math.max(self.x, a.x);
        self.y = Math.max(self.y, a.y);
        self.z = Math.max(self.z, a.z);
        self.w = Math.max(self.w, a.w);
        
        return self;
    }
    
    /**
     * Returns a vector built from the componentwise min of this vector and another.
     * 
     * @param a
     * @param b
     * @return      self_i = min(self_i, a_i)
     */
    public inline function minWith(a:Vector4):Vector4
    {
        var self:Vector4 = this;
        
        self.x = Math.min(self.x, a.x);
        self.y = Math.min(self.y, a.y);
        self.z = Math.min(self.z, a.z);
        self.w = Math.min(self.w, a.w);
        
        return self;
    }
    
    /**
     * Returns a vector resulting from this vector projected onto the specified vector.
     * 
     * @param a
     * @return      self = (dot(self, a) / dot(a, a)) * a
     */
    public inline function projectOnto(a:Vector4):Vector4
    {
        var self:Vector4 = this;
        
        var s:Float = (self * a) / (a * a);
        
        // Set self = s * a without allocating
        a.copyTo(self);
        self.multiplyWith(s);
        
        return self;
    }
    
/**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:Vector4):Void
    {
        var self:Vector4 = this;
        
        for (i in 0...Vector4.elementCount)
        {
            target[i] = self[i];
        }
    }
    
    /**
     * Copy the contents of this structure to another (shape-similar) instance.
     * 
     * @param target    The target structure.
     */
    public inline function copyToShape(target:Vector4Shape):Void
    {
        var self:Vector4 = this;
        
        target.x = self.x;
        target.y = self.y;
        target.z = self.z;
        target.w = self.w;
    }
    
    /**
     * Copy the contents of another (shape-similar) instance to this structure.
     * 
     * @param source    The source structure.
     */
    public inline function copyFromShape(source:Vector4Shape):Void
    {
        var self:Vector4 = this;
        
        self.x = source.x;
        self.y = source.y;
        self.z = source.z;
        self.w = source.w;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Vector4
    {
        var self:Vector4 = this;
        return new Vector4(self.x, self.y, self.z, self.w);
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
        var self:Vector4 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            case 2:
                return self.z;
            case 3:
                return self.w;
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
        var self:Vector4 = this;
        switch (i)
        {
            case 0:
                return self.x = value;
            case 1:
                return self.y = value;
            case 2:
                return self.z = value;
            case 3:
                return self.w = value;
            default:
                throw "Invalid element";
        }
    }
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Float->Float):Vector4
    {
        var self:Vector4 = this;
        
        for (i in 0...elementCount)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    /**
     * Get the distance between this vector and another.
     * 
     * @param b
     * @return      |self - b|
     */
    public inline function distanceTo(b:Vector4):Float
    {
        var self:Vector4 = this;
        
        return (self - b).length;
    }
    
    /**
     * Normalize this vector.
     * 
     * @return  The modified object.
     */
    public inline function normalize():Vector4
    {
        var self:Vector4 = this;
        
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
    public inline function normalizeTo(newLength:Float):Vector4
    {
        var self:Vector4 = this;
        
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
    public inline function clamp(min:Float, max:Float):Vector4
    {
        var self:Vector4 = this;
        
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
        var self:Vector4 = this;
        return Math.sqrt(
            self.x * self.x +
            self.y * self.y +
            self.z * self.z +
            self.w * self.w);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Vector4 = this;
        return
            self.x * self.x +
            self.y * self.y +
            self.z * self.z +
            self.w * self.w;
    }
    
    private static inline function get_zero():Vector4
    {
        return new Vector4(0.0, 0.0, 0.0, 0.0);
    }
    
    private static inline function get_xAxis():Vector4
    {
        return new Vector4(1.0, 0.0, 0.0, 0.0);
    }
    
    private static inline function get_yAxis():Vector4
    {
        return new Vector4(0.0, 1.0, 0.0, 0.0);
    }
    
    private static inline function get_zAxis():Vector4
    {
        return new Vector4(0.0, 0.0, 1.0, 0.0);
    }
    
    private static inline function get_wAxis():Vector4
    {
        return new Vector4(0.0, 0.0, 0.0, 1.0);
    }
}

