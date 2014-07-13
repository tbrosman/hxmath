package vtgmath;

@:forward(a, b, c, d, tx, ty)
abstract Matrix3x2(Matrix3x2Shape) from Matrix3x2Shape to Matrix3x2Shape
{
    // Translation column vector
    public var t(get, set):Vector2;
    
    // 2x2 sub-matrix corresponding to the linear portion of the transformation
    public var linearSubMatrix(get, never):Matrix2x2;
    
    // Linear portion is row-major, affine portion is column-major
    public function new(a:Float = 1.0, b:Float = 0.0, c:Float = 0.0, d:Float = 1.0, tx:Float = 0.0, ty:Float = 0.0) 
    {
        this = {
            a: a,   b: b,
            c: c,   d: d,
            tx: tx, ty: ty };
    }
    
    // Treat as homogenous matrix multiplication, i.e. there is an implicit 3rd row [0, 0, 1] in both matrices
    @:op(A * B)
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
    @:op(A * B)
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