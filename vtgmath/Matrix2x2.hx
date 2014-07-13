package vtgmath;

@:forward(a, b, c, d)
abstract Matrix2x2(Matrix2x2Shape) from Matrix2x2Shape to Matrix2x2Shape
{
    // TODO
    /*
    public var column1(get, set):Vector2;
    public var column2(get, set):Vector2;
    
    public var row1(get, set):Vector2;
    public var row2(get, set):Vector2;
    */
    
    public function new(m11:Float = 1.0, m12:Float = 0.0, m21:Float = 0.0, m22:Float = 1.0) 
    {
        this = { a: m11, b: m21, c: m12, d: m22 };
    }
    
    // TODO
    //public static inline function subtract(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    
    // TODO
    //public static inline function add(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    
    @:op(A * B)
    public static inline function multiply(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(
            m.a * n.a + m.b * n.c,
            m.a * n.b + m.b * n.d,
            m.c * n.a + m.d * n.c,
            m.c * n.b + m.d * n.d);
    }
    
    @:op(A * B)
    public static inline function multiplyVector2(m:Matrix2x2, v:Vector2):Vector2
    {
        return new Vector2(
            m.a * v.x + m.b * v.y,
            m.c * v.x + m.d * v.y);
    }
    
    public inline function det():Float
    {
        var self:Matrix2x2 = this;
        return self.a * self.d - self.b * self.c;
    }
}