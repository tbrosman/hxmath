package hxmath;

typedef QuaternionShape =
{
    public var s:Float;
    public var v:Vector3;
}

@:forward(s, v)
abstract Quaternion(QuaternionShape) from QuaternionShape to QuaternionShape
{
    public static inline var elementCount:Int = 4;
    
    public static var zero(get, never):Quaternion;
    public static var identity(get, never):Quaternion;
    
    /**
     * Gets the rotation matrix (assuming the quaternion is normalized).
     */
    public var matrix(get, never):Matrix3x3;
    
    public var length(get, never):Float;
    public var lengthSq(get, never):Float;
    
    public function new(s:Float=1.0, v:Vector3=null) 
    {
        this = {
            s: s,
            v: v != null
                ? v
                : Vector3.zero
        };
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
    
    @:op(A * B)
    public static inline function scalarMultiply(s:Float, a:Quaternion):Quaternion
    {
        return new Quaternion(s * a.s, s * a.v);
    }
    
    @:op(A * B)
    public static inline function multiply(a:Quaternion, b:Quaternion):Quaternion
    {
        return new Quaternion(a.s * b.s - a.v * b.v, a.s * b.v + b.s * a.v + a.v ^ b.v);
    }
    
    @:op(A + B)
    public static inline function add(a:Quaternion, b:Quaternion):Quaternion
    {
        return a.clone()
            .addWith(b);
    }
    
    @:op(A - B)
    public static inline function subtract(a:Quaternion, b:Quaternion):Quaternion
    {
        return a.clone()
            .subtractWith(b);
    }

    @:op(~A)
    public static inline function conjugate(a:Quaternion):Quaternion
    {
        return new Quaternion(a.s, -a.v);
    }
    
    @:op(-A)
    public static inline function negate(a:Quaternion):Quaternion
    {
        return new Quaternion(-a.s, -a.v);
    }
    
    @:op(A == B)
    public static inline function equals(a:Quaternion, b:Quaternion):Bool
    {
        return a.s == b.s && a.v == b.v;
    }
    
    @:op(A != B)
    public static inline function notEquals(a:Quaternion, b:Quaternion):Bool
    {
        return !(a == b);
    }
    
    public static inline function addWith(a:Quaternion, b:Quaternion):Quaternion
    {
        a.s += b.s;
        a.v += b.v;
        return a;
    }
    
    public static inline function subtractWith(a:Quaternion, b:Quaternion):Quaternion
    {
        a.s -= b.s;
        a.v -= b.v;
        return a;
    }
    
    public static inline function normalize(a:Quaternion):Quaternion
    {
        var r2 = a.s * a.s + a.v * a.v;
        var r = Math.sqrt(r2);
        return (1.0 / r) * a;
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
    
    public inline function clone():Quaternion
    {
        var self:Quaternion = this;
        return new Quaternion(self.s, self.v);
    }
    
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
        
        var m = new Matrix3x3([
            1 - 2 * (y * y + z * z), 2 * (x * y - s * z), 2 * (s * y + x * z),
            2 * (x * y + s * z), 1 - 2 * (x * x + z * z), 2 * (y * z - s * x),
            2 * (x * z - s * y), 2 * (y * z + s * x),  1 - 2 * (x * x + y * y)]);

        return m;
    }
}