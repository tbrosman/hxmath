package vtgmath;
import vtgmath.Vector2.PolarVectorShape;

typedef Vector2Shape =
{
    public var x:Float;
	public var y:Float;
};

typedef PolarVectorShape =
{
    public var angle:Float;
    public var radius:Float;
};

@:forward(x, y)
abstract Vector2(Vector2Shape) from Vector2Shape to Vector2Shape
{
    public static var xAxis(get, never):Vector2;
    public static var yAxis(get, never):Vector2;
    
    public var length(get, never):Float;
    public var lengthSq(get, never):Float;
    
    public function new(x:Float, y:Float)
    {
        this = {x: x, y: y};
    }
	
	@:op(A + B)
	public static inline function add(a:Vector2, b:Vector2):Vector2
	{
		return new Vector2(a.x + b.x, a.y + b.y);
	}
	
	@:op(A * B)
	public static inline function dot(a:Vector2, b:Vector2):Float
	{
		return a.x * b.x + a.y * b.y;
	}
	
	@:op(A * B)
	public static inline function scalarMultiply(s:Float, a:Vector2):Vector2
	{
		return new Vector2(s * a.x, s * a.y);
	}
	
	public static inline function lerp(a:Vector2, b:Vector2, t:Float):Vector2
	{
		return t*a + (1.0 - t)*b;
	}
    
    public inline function toPolarVector():PolarVectorShape
    {
        var self:Vector2 = this;
        return { angle: Math.atan2(self.y, self.x), radius: self.length };
    }
    
    public static inline function fromPolarVector(v:PolarVectorShape):Vector2
    {
        return new Vector2(v.radius * Math.cos(v.angle), v.radius * Math.sin(v.angle));
    }
	
	public inline function clone():Vector2
	{
		var self:Vector2 = this;
		return new Vector2(self.x, self.y);
	}
    
    private inline function get_length():Float
    {
        var self:Vector2 = this;
        return Math.sqrt(self.x * self.x + self.y * self.y);
    }
    
    private inline function get_lengthSq():Float
    {
        var self:Vector2 = this;
        return self.x * self.x + self.y * self.y;
    }
    
    private static inline function get_xAxis():Vector2
    {
        return new Vector2(1.0, 0.0);
    }
    
    private static inline function get_yAxis():Vector2
    {
        return new Vector2(0.0, 1.0);
    }
}

