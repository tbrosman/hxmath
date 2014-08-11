package hxmath.math;

typedef Vector4Shape =
{
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;
}

/**
 * A 4D vector (used with homogenous/projection matrices in 3D).
 */
@:forward(x, y, z, w)
abstract Vector4(Vector4Shape) from Vector4Shape to Vector4Shape
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
    public function new(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0, w:Float = 0.0)
    {
        this = {x: x, y: y, z: z, w: w};
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
     * @param s
     * @param a
     * @return      s * a
     */
    @:op(A * B)
    public static inline function scalarMultiply(s:Float, a:Vector4):Vector4
    {
        return new Vector4(
            s * a.x,
            s * a.y,
            s * a.z,
            s * a.w);
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
     * Test inequality between two vectors.
     * 
     * @param a
     * @param b
     * @return      !(a_i == b_i)
     */
    @:op(A != B)
    public static inline function notEquals(a:Vector4, b:Vector4):Bool
    {
        return !(a == b);
    }
    
    /**
     * Add a vector in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @param b
     * @return      a_i += b_i
     */
    public static inline function addWith(a:Vector4, b:Vector4):Vector4
    {
        a.x += b.x;
        a.y += b.y;
        a.z += b.z;
        a.w += b.w;
        return a;
    }
    
    /**
     * Subtract a vector in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @param b
     * @return      a_i -= b_i
     */
    public static inline function subtractWith(a:Vector4, b:Vector4):Vector4
    {
        a.x -= b.x;
        a.y -= b.y;
        a.z -= b.z;
        a.w -= b.w;
        return a;
    }
    
    /**
     * Linear interpolation between two vectors.
     * 
     * @param a
     * @param b
     * @param t
     * @return  a + (1 - t)b
     */
    public static inline function lerp(a:Vector4, b:Vector4, t:Float):Vector4
    {
        return t*a + (1.0 - t)*b;
    }
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Vector4):Void
    {
        var self:Vector4 = this;
        
        for (i in 0...Vector4.elementCount)
        {
            other[i] = self[i];
        }
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
        
        for (i in 0...4)
        {
            self[i] = func(self[i]);
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
