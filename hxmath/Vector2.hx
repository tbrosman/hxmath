package hxmath;

typedef Vector2Shape =
{
    public var x:Float;
    public var y:Float;
}

@:forward(x, y)
abstract Vector2(Vector2Shape) from Vector2Shape to Vector2Shape
{
    public static inline var elementCount:Int = 2;
    
    public static var zero(get, never):Vector2;
    public static var xAxis(get, never):Vector2;
    public static var yAxis(get, never):Vector2;
    
    public var length(get, never):Float;
    public var lengthSq(get, never):Float;
    public var angle(get, never):Float;
    public var normal(get, never):Vector2;
    public var leftRot(get, never):Vector2;
    public var rightRot(get, never):Vector2;
    
    public function new(x:Float = 0.0, y:Float = 0.0)
    {
        this = {x: x, y: y};
    }
    
    /**
     * Create a new Vector2 from polar coordinates.
     * Example angle-to-vector direction conversions:
     *   0       radians -> +X axis
     *   (1/2)pi radians -> +Y axis
     *   pi      radians -> -X axis
     *   (3/2)pi radians -> -Y axis
     * 
     * @param angle     The angle of the vector (counter-clockwise from the +X axis) in radians.
     * @param radius    The length of the vector.
     * @return          The vector.
     */
    public static inline function fromPolar(angle:Float, radius:Float):Vector2
    {
        return new Vector2(radius * Math.cos(angle), radius * Math.sin(angle));
    }
       
    @:op(A * B)
    public static inline function dot(a:Vector2, b:Vector2):Float
    {
        return
            a.x * b.x +
            a.y * b.y;
    }
    
    @:op(A * B)
    public static inline function multiplyScalar(s:Float, a:Vector2):Vector2
    {
        return new Vector2(
            s * a.x,
            s * a.y);
    }
    
    @:op(A + B)
    public static inline function add(a:Vector2, b:Vector2):Vector2
    {
        return a.clone()
            .addWith(b);
    }
    
    @:op(A - B)
    public static inline function subtract(a:Vector2, b:Vector2):Vector2
    {
        return a.clone()
            .subtractWith(b);
    }
    
    @:op(-A)
    public static inline function negate(a:Vector2):Vector2
    {
        return new Vector2(
            -a.x,
            -a.y);
    }
    
    @:op(A == B)
    public static inline function equals(a:Vector2, b:Vector2):Bool
    {
        return a.x == b.x && a.y == b.y;
    }
    
    @:op(A != B)
    public static inline function notEquals(a:Vector2, b:Vector2):Bool
    {
        return !(a == b);
    }
    
    public static inline function addWith(a:Vector2, b:Vector2):Vector2
    {
        a.x += b.x;
        a.y += b.y;
        return a;
    }
    
    public static inline function subtractWith(a:Vector2, b:Vector2):Vector2
    {
        a.x -= b.x;
        a.y -= b.y;
        return a;
    }

    public static inline function lerp(a:Vector2, b:Vector2, t:Float):Vector2
    {
        return t*a + (1.0 - t)*b;
    }
    
    public inline function clone():Vector2
    {
        var self:Vector2 = this;
        return new Vector2(self.x, self.y);
    }
    
    @:arrayAccess
    public inline function getArrayElement(i:Int):Float
    {
        var self:Vector2 = this;
        switch (i)
        {
            case 0:
                return self.x;
            case 1:
                return self.y;
            default:
                throw "Invalid element";
        }
    }
    
    @:arrayAccess
    public inline function setArrayElement(i:Int, value:Float):Float
    {
        var self:Vector2 = this;
        switch (i)
        {
            case 0:
                return self.x = value;
            case 1:
                return self.y = value;
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
    public inline function applyScalarFunc(func:Float->Float):Vector2
    {
        var self:Vector2 = this;
        
        for (i in 0...2)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    /**
     * Find the (unsigned) angle between this vector and another vector.
     * 
     * @param b     The other vector.
     * @return      The unsigned angle between this vector and the other in radians.
     */
    public inline function angleWith(b:Vector2):Float
    {
        var self:Vector2 = this;
        return Math.acos((self * b) / (self.length * b.length));
    }
    
    /**
     * Find the signed angle between this vector and another vector (i.e. the signed angle this vector must be rotated
     * to align with the other vector). If the other vector is farther rotated counterclockwise, the angle will be
     * positive, whereas if the other vector is farther rotated clockwise, the angle will be negative.
     * 
     * @param b     The other vector.
     * @return      The signed angle between this vector and the other in radians.
     */
    public inline function signedAngleWith(b:Vector2):Float
    {
        var self:Vector2 = this;
        
        // sign(|a b|) = sign(sin(angle)) = sign(angle)
        return Math.asin(MathUtil.det2x2(self.x, b.x, self.y, b.y) / (self.length * b.length));
    }

    private static inline function get_zero():Vector2
    {
        return new Vector2(0.0, 0.0);
    }
    
    private static inline function get_xAxis():Vector2
    {
        return new Vector2(1.0, 0.0);
    }
    
    private static inline function get_yAxis():Vector2
    {
        return new Vector2(0.0, 1.0);
    }
    
    private inline function get_length():Float
    {
        var self:Vector2 = this;
        return Math.sqrt(
            self.x * self.x +
            self.y * self.y);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Vector2 = this;
        return
            self.x * self.x +
            self.y * self.y;
    }
    
    private inline function get_angle():Float
    {
        var self:Vector2 = this;
        return Math.atan2(self.y, self.x);
    }
    
    private inline function get_normal():Vector2
    {
        var self:Vector2 = this;
        var length = self.length;
        
        if (length > 0.0)
        {
            return new Vector2(self.x / length, self.y / length);
        }
        else
        {
            return Vector2.zero;
        }
    }
    
    private inline function get_leftRot():Vector2
    {
        var self:Vector2 = this;
        return new Vector2(-self.y, self.x);
    }
    
    private inline function get_rightRot():Vector2
    {
        var self:Vector2 = this;
        return new Vector2(self.y, -self.x);
    }
}

