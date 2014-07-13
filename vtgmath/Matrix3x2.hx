package vtgmath;


typedef Matrix3x2Shape = 
{
    // m11
    public var a:Float;
    
    // m21
    public var b:Float;
    
    // m12
    public var c:Float;
    
    // m22
    public var d:Float;
    
    // m31
    public var tx:Float;
    
    // m32
    public var ty:Float;
}

@:forward(a, b, c, d, tx, ty)
abstract Matrix3x2(Matrix3x2Shape) from Matrix3x2Shape to Matrix3x2Shape
{
    public var t(get, set):Vector2;
    public var linearSubMatrix(get, never):Matrix2x2;
    
    public function new(m11:Float = 1.0, m12:Float = 0.0, m21:Float = 0.0, m22:Float = 1.0, m31:Float = 0.0, m32:Float = 0.0) 
    {
        this = { a: m11, b: m21, c: m12, d: m22, tx: m31, ty: m32 };
    }
    
    // Treat as homogenous matrix multiplication, i.e. there is an implicit 3rd row [0, 0, 1] in both matrices
    @:operator(A * B)
    public static inline function concat(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        // TODO: speed this up if it becomes an issue
        var mLinear:Matrix2x2 = m.linearSubMatrix;
        var nLinear:Matrix2x2 = n.linearSubMatrix;
        var resultLinear:Matrix2x2 = mLinear * nLinear;
        var resultAffine:Vector2 = nLinear * new Vector2(m.tx, m.ty) + new Vector2(n.tx, n.ty);
        
        return new Matrix3x2(
            resultLinear.a, resultLinear.b,
            resultLinear.c, resultLinear.d,
            resultAffine.x, resultAffine.y);
    }
    
    // Treat both arguments as homogenous objects
    @:operator(A * B)
    public static inline function transform(m:Matrix3x2, v:Vector2):Vector2
    {
        return m.linearSubMatrix * v + m.t;
    }
    
    private inline function get_t():Vector2
    {
        var self:Matrix3x2 = this;
        return new Vector2(self.tx, self.ty);
    }
    
    private inline function set_t(t:Vector2):Vector2
    {
        var self:Matrix3x2 = this;
        self.tx = t.x;
        self.ty = t.y;
        
        return new Vector2(self.tx, self.ty);
    }
    
    private inline function get_linearSubMatrix():Matrix2x2
    {
        var self2x2:Matrix2x2Shape = this;
        var selfLinear:Matrix2x2 = self2x2;
        return selfLinear;
    }
    
}