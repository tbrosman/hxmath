package hxmath;

typedef QuaternionShape =
{
    public var s:Float;
    public var v:Vector3;
}

@:forward(s, v)
abstract Quaternion(QuaternionShape) from QuaternionShape to QuaternionShape
{
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
    
    @:op(~A)
    public static inline function conjugate(a:Quaternion):Quaternion
    {
        return new Quaternion(a.s, -1.0 * a.v);
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
    
    public static inline function normalize(a:Quaternion):Quaternion
    {
        var r2 = a.s * a.s + a.v * a.v;
        var r = Math.sqrt(r2);
        return (1.0 / r) * a;
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
    
    public inline function clone():Quaternion
    {
        var self:Quaternion = this;
        return new Quaternion(self.s, self.v);
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