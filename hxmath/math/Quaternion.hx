package hxmath.math;

/**
 * The default underlying type.
 */
class QuaternionDefault
{
    public var s:Float;
    public var v:Vector3;
    
    public function new(s:Float, v:Vector3)
    {
        this.s = s;
        this.v = v;
    }
}

typedef QuaternionType = QuaternionDefault;

/**
 * Quaternion for rotation in 3D.
 */
@:forward(s, v)
abstract Quaternion(QuaternionType) from QuaternionType to QuaternionType
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 4;
    
    // Zero quaternion (q + 0 = 0, q * 0 = 0)
    public static var zero(get, never):Quaternion;
    
    // One/identity quaternion (q * 1 = q)
    public static var identity(get, never):Quaternion;
    
    // Gets the corresponding rotation matrix
    public var matrix(get, never):Matrix3x3;
    
    // Magnitude
    public var length(get, never):Float;
    
    // Quaternion dotted with itself
    public var lengthSq(get, never):Float;
    
    // The normalized quaternion
    public var normal(get, never):Quaternion;
    
    /**
     * Constructor.
     * 
     * @param s     Scalar (real) part.
     * @param v     Vector (complex) part.
     */
    public inline function new(s:Float, v:Vector3) 
    {
        this = new QuaternionDefault(s, v);
    }
    
    /**
     * Construct a Quaternion from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Quaternion
    {
        if (rawData.length != Quaternion.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Quaternion(rawData[0], new Vector3(rawData[1], rawData[2], rawData[3]));
    }
    
    /**
     * Create a quaternion from an axis-angle pair.
     * 
     * @param angle     The angle to rotate.
     * @param axis      The axis to rotate around.
     * @return          The quaternion.
     */
    public static inline function fromAxisAngle(angle:Float, axis:Vector3):Quaternion
    {
        return new Quaternion(Math.cos(angle / 2.0), Math.sin(angle / 2.0) * axis);
    }
    
    /**
     * Multiply a (real) scalar with a quaternion.
     * 
     * @param s
     * @param a
     * @return      s * a
     */
    @:op(A * B)
    public static inline function scalarMultiply(s:Float, a:Quaternion):Quaternion
    {
        return new Quaternion(s * a.s, s * a.v);
    }
    
    /**
     * Multiply two quaternions.
     * 
     * @param a
     * @param b
     * @return      a * b
     */
    @:op(A * B)
    public static inline function multiply(a:Quaternion, b:Quaternion):Quaternion
    {
        return new Quaternion(a.s * b.s - a.v * b.v, a.s * b.v + b.s * a.v + a.v ^ b.v);
    }
    
    /**
     * Add two quaternions.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:Quaternion, b:Quaternion):Quaternion
    {
        return a.clone()
            .addWith(b);
    }
    
    /**
     * Subtract one quaternion from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:Quaternion, b:Quaternion):Quaternion
    {
        return a.clone()
            .subtractWith(b);
    }

    /**
     * Create a complex conjugate copy of a quaternion (complex/vector portion is negated).
     * 
     * @param a
     * @return      a*
     */
    @:op(~A)
    public static inline function conjugate(a:Quaternion):Quaternion
    {
        return new Quaternion(a.s, -a.v);
    }
    
    /**
     * Create a negated copy of a quaternion.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a:Quaternion):Quaternion
    {
        return new Quaternion(-a.s, -a.v);
    }
    
    /**
     * Test element-wise equality between two quaternions.
     * False if one of the inputs is null and the other is not.
     * 
     * @param a
     * @param b
     * @return     a_i == b_i
     */
    @:op(A == B)
    public static inline function equals(a:Quaternion, b:Quaternion):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.s == b.s &&
            a.v == b.v;
    }
    
    /**
     * Test inequality between two quaternions.
     * 
     * @param a
     * @param b
     * @return      !(a_i == b_i)
     */
    @:op(A != B)
    public static inline function notEquals(a:Quaternion, b:Quaternion):Bool
    {
        return !(a == b);
    }
    
    /**
     * Add a quaternion in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i += a_i
     */
    public inline function addWith(a:Quaternion):Quaternion
    {
        var self:Quaternion = this;
        
        self.s += a.s;
        self.v += a.v;
        
        return self;
    }
    
    /**
     * Subtract a quaternion in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_i -= a_i
     */
    public inline function subtractWith(a:Quaternion):Quaternion
    {
        var self:Quaternion = this;
        
        self.s -= a.s;
        self.v -= a.v;
        
        return self;
    }
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Quaternion):Void
    {
        var self:Quaternion = this;
        
        for (i in 0...Quaternion.elementCount)
        {
            other[i] = self[i];
        }
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Quaternion
    {
        var self:Quaternion = this;
        return new Quaternion(self.s, self.v);
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
        var self:Quaternion = this;
        switch (i)
        {
            case 0:
                return self.s;
            case 1:
                return self.v.x;
            case 2:
                return self.v.y;
            case 3:
                return self.v.z;
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
        var self:Quaternion = this;
        switch (i)
        {
            case 0:
                return self.s = value;
            case 1:
                return self.v.x = value;
            case 2:
                return self.v.y = value;
            case 3:
                return self.v.z = value;
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
    public inline function applyScalarFunc(func:Float->Float):Quaternion
    {
        var self:Quaternion = this;
        
        for (i in 0...4)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }

    /**
     * Get the log for the quaternion.
     * 
     * @return  log(q) == [0, theta/sin(theta) * v]
     */
    public inline function log():Quaternion
    {
        var self:Quaternion = this;
        var theta = Math.acos(self.s);
        var sinTheta = Math.sin(theta);
        
        // Avoid division by zero
        if (sinTheta > 0.0)
        {
            return new Quaternion(0.0, (theta / sinTheta) * self.v);
        }
        else
        {
            return Quaternion.zero;
        }
    }
    
    /**
     * Get the exponential for the quaternion.
     * 
     * @return  exp(q) == [cos(theta), v * sin(theta)]
     */
    public inline function exp():Quaternion
    {
        var self:Quaternion = this;
        var theta = self.v.length;
        var sinTheta = Math.sin(theta);
        var cosTheta = Math.cos(theta);

        // Avoid division by zero
        if(theta > 0.0)
        {
            var u = (sinTheta / theta) * self.v;
            return new Quaternion(cosTheta, u);
        }
        else
        {
            return new Quaternion(cosTheta, Vector3.zero);
        }
    }
    
    /**
     * Rotate the given vector, assuming the current quaternion is normalized (if not, normalize first).
     * 
     * @param u     The vector to rotate.
     * @return      The rotated vector.
     */
    public inline function rotate(u:Vector3):Vector3
    {
        // Calculate qvq'
        var self:Quaternion = this;
        return 2.0 * (self.v * u) * self.v +
            (self.s * self.s - self.v * self.v) * u +
            2 * self.s * (self.v ^ u);
    }
    
    private static inline function get_zero():Quaternion
    {
        return new Quaternion(0.0, Vector3.zero);
    }
    
    private static inline function get_identity():Quaternion
    {
        return new Quaternion(1.0, Vector3.zero);
    }
    
    private inline function get_length():Float
    {
        var self:Quaternion = this;
        return Math.sqrt(
            self.s   * self.s   +
            self.v.x * self.v.x +
            self.v.y * self.v.y +
            self.v.z * self.v.z);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Quaternion = this;
        return
            self.s   * self.s   +
            self.v.x * self.v.x +
            self.v.y * self.v.y +
            self.v.z * self.v.z;
    }
    
    private inline function get_matrix():Matrix3x3
    {
        var self:Quaternion = this;
      
        var s = self.s;
        var x = self.v.x;
        var y = self.v.y;
        var z = self.v.z;
        
        var m = new Matrix3x3(
            1 - 2 * (y * y + z * z), 2 * (x * y - s * z), 2 * (s * y + x * z),
            2 * (x * y + s * z), 1 - 2 * (x * x + z * z), 2 * (y * z - s * x),
            2 * (x * z - s * y), 2 * (y * z + s * x),  1 - 2 * (x * x + y * y));

        return m;
    }
    
    private inline function get_normal():Quaternion
    {
        var self:Quaternion = this;
        
        var r2 = self.s * self.s + self.v * self.v;
        var r = Math.sqrt(r2);
        return (1.0 / r) * self;
    }
}