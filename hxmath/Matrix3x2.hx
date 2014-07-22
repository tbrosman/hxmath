package hxmath;

@:forward(a, b, c, d, tx, ty)
abstract Matrix3x2(Matrix3x2Shape) from Matrix3x2Shape to Matrix3x2Shape
{
    public static var zero(get, never):Matrix3x2;
    public static var identity(get, never):Matrix3x2;
    
    // Translation column vector
    public var t(get, set):Vector2;
    
    // 2x2 sub-matrix corresponding to the linear portion of the transformation
    public var linearSubMatrix(get, never):Matrix2x2;
    
    // Linear portion is row-major, affine portion is column-major
    public function new(a:Float = 1.0, b:Float = 0.0, c:Float = 0.0, d:Float = 1.0, tx:Float = 0.0, ty:Float = 0.0) 
    {
        this = {
            a: a, b: b, tx: tx, 
            c: c, d: d, ty: ty };
    }
    
    @:op(A * B)
    public static inline function multiplyScalar(s:Float, m:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            s * m.a,  s * m.b,
            s * m.c,  s * m.d,
            s * m.tx, s * m.ty);
    }
    
    // Treat both arguments as homogenous objects
    @:op(A * B)
    public static inline function transform(m:Matrix3x2, v:Vector2):Vector2
    {
        return m.linearSubMatrix * v + m.t;
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
    
    @:op(A + B)
    public static inline function add(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            m.a  + n.a,  m.b  + n.b,
            m.c  + n.c,  m.d  + n.d,
            m.tx + n.tx, m.ty + n.ty);
    }
    
    @:op(A += B)
    public static inline function addWith(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        m.a  += n.a;
        m.b  += n.b;
        m.c  += n.c;
        m.d  += n.d;
        m.tx += n.tx;
        m.ty += n.ty;
        return m;
    }
    
    @:op(A - B)
    public static inline function subtract(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            m.a  - n.a,  m.b  - n.b,
            m.c  - n.c,  m.d  - n.d,
            m.tx - n.tx, m.ty - n.ty);
    }
    
    @:op(A -= B)
    public static inline function subtractWith(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        m.a  -= n.a;
        m.b  -= n.b;
        m.c  -= n.c;
        m.d  -= n.d;
        m.tx -= n.tx;
        m.ty -= n.ty;
        return m;
    }
       
    @:op(A == B)
    public static inline function equals(m:Matrix3x2, n:Matrix3x2):Bool
    {
        return
            m.a == n.a &&
            m.b == n.b &&
            m.c == n.c &&
            m.d == n.d &&
            m.tx == n.tx &&
            m.ty == n.ty;
    }
    
    public inline function clone():Matrix3x2
    {
        var self:Matrix3x2 = this;
        return new Matrix3x2(
            self.a, self.b, self.tx,
            self.c, self.d, self.ty
        );
    }
    
    public inline function element(column:Int, row:Int):Float
    {
        var self:Matrix3x2 = this;
        var k:Float;
        
        switch [row, column]
        {
            case [0, 0]:
                k = self.a;
            case [1, 0]:
                k = self.b;
            case [2, 0]:
                k = self.tx;
            case [0, 1]:
                k = self.c;
            case [1, 1]:
                k = self.d;
            case [2, 1]:
                k = self.ty;
            default:
                throw "Invalid element";
        }
        
        return k;
    }
    
    public inline function col(index:Int):Vector2
    {
        var self:Matrix3x2 = this;
        
        switch (index)
        {
            case 0:
                return new Vector2(self.a,  self.c);
            case 1:
                return new Vector2(self.b,  self.d);
            case 2:
                return new Vector2(self.tx, self.ty);
            default:
                throw "Invalid column";
        }
    }
        
    public inline function row(index:Int):Vector3
    {
        var self:Matrix3x2 = this;
        
        switch (index)
        {
            case 0:
                return new Vector3(self.a, self.b, self.tx);
            case 1:
                return new Vector3(self.c, self.d, self.ty);
            default:
                throw "Invalid row";
        }
    }
    
    private static inline function get_zero():Matrix3x2
    {
        return new Matrix3x2(
            0.0, 0.0,
            0.0, 0.0,
            0.0, 0.0);
    }
    
    private static inline function get_identity():Matrix3x2
    {
        return new Matrix3x2(
            1.0, 0.0,
            0.0, 1.0,
            0.0, 0.0);
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