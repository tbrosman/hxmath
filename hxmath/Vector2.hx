package hxmath;

typedef Vector2Shape =
{
    public var x:Float;
    public var y:Float;
}

@:forward(x, y)
abstract Vector2(Vector2Shape) from Vector2Shape to Vector2Shape
{
    public static var zero(get, never):Vector2;
    public static var xAxis(get, never):Vector2;
    public static var yAxis(get, never):Vector2;
    
    public var length(get, never):Float;
    public var lengthSq(get, never):Float;
    public var angle(get, never):Float;
    
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
        return new Vector2(
            a.x + b.x,
            a.y + b.y);
    }
    
    @:op(A += B)
    public static inline function addWith(a:Vector2, b:Vector2):Vector2
    {
        a.x += b.x;
        a.y += b.y;
        return a;
    }
    
    @:op(A - B)
    public static inline function subtract(a:Vector2, b:Vector2):Vector2
    {
        return new Vector2(
            a.x - b.x,
            a.y - b.y);
    }
    
    @:op(A - B)
    public static inline function subtractWith(a:Vector2, b:Vector2):Vector2
    {
        a.x -= b.x;
        a.y -= b.y;
        return a;
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

    public static inline function lerp(a:Vector2, b:Vector2, t:Float):Vector2
    {
        return t*a + (1.0 - t)*b;
    }
    
    public inline function clone():Vector2
    {
        var self:Vector2 = this;
        return new Vector2(self.x, self.y);
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
}

