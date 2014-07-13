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
    
    // Note: parameters are in row-major order for syntactic niceness
    public function new(a:Float = 1.0, b:Float = 0.0, c:Float = 0.0, d:Float = 1.0) 
    {
        this = {
            a: a, b: b,
            c: c, d: d };
    }
    
    public static inline function rotation(angle:Float):Matrix2x2
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        return new Matrix2x2(
             c, -s,
             s,  c);
    }
    
    public static inline function scale(sx:Float, sy:Float):Matrix2x2
    {
        return new Matrix2x2(
            sx, 0.0,
            0.0, sy);
    }
    
    // TODO
    //public static inline function subtract(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    
    // TODO
    //public static inline function add(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    
    @:op(A * B)
    public static inline function multiply(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(
            m.a * n.a + m.b * n.c,  // p11 = mi1 * n1i
            m.a * n.b + m.b * n.d,  // p21 = mi1 * n2i
            m.c * n.a + m.d * n.c,  // p12 = mi2 * n1i
            m.c * n.b + m.d * n.d); // p22 = mi2 * n2i
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