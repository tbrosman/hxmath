package hxmath;

typedef Matrix3x2Shape = 
{
    // m00
    public var a:Float;
    
    // m10
    public var b:Float;
    
    // m01
    public var c:Float;
    
    // m11
    public var d:Float;
    
    // m20
    public var tx:Float;
    
    // m21
    public var ty:Float;
}

@:forward(a, b, c, d, tx, ty)
abstract Matrix3x2(Matrix3x2Shape) from Matrix3x2Shape to Matrix3x2Shape
{
    public static inline var elementCount:Int = 6;
    
    public static var zero(get, never):Matrix3x2;
    public static var identity(get, never):Matrix3x2;
    
    // Translation column vector
    public var t(get, set):Vector2;
    
    // 2x2 sub-matrix corresponding to the linear portion of the transformation
    public var linearSubMatrix(get, set):Matrix2x2;
    
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
        return m.clone()
            .addWith(n);
    }
    
    @:op(A - B)
    public static inline function subtract(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        return m.clone()
            .subtractWith(n);
    }
        
    @:op(-A)
    public static inline function negate(m:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            -m.a,  -m.b,
            -m.c,  -m.d,
            -m.tx, -m.ty);
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
    
    @:op(A != B)
    public static inline function notEquals(m:Matrix3x2, n:Matrix3x2):Bool
    {
        return !(m == n);
    }
    
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
    
    /**
     * Rotate by a given angle.
     * 
     * @param angle     The angle to rotate by (ccw).
     * @return          The matrix.
     */
    public static inline function rotate(angle:Float):Matrix3x2
    {
        var m:Matrix3x2 = Matrix3x2.get_identity();
        m.linearSubMatrix = Matrix2x2.rotate(angle);
        return m;
    }
    
    /**
     * Translate by a given vector.
     * 
     * @param v     The vector to translate by.
     * @return      The matrix.
     */
    public static inline function translate(v:Vector2):Matrix3x2
    {
        var m:Matrix3x2 = Matrix3x2.get_identity();
        m.t = v;
        return m;
    }
    
    /**
     * Orbit around a given center point. The matrix is equivalent to the following composition:
     *
     * Matrix3x2.translate(center) * Matrix3x2.rotate(angle) * Matrix3x2.translate(-center)
     * 
     * @param center    The point to rotate around.
     * @param angle     The angle to rotate ccw around the center.
     * @return          The matrix.
     */
    public static inline function orbit(center:Vector2, angle:Float):Matrix3x2
    {
        var m:Matrix3x2 = Matrix3x2.get_identity();
        m.linearSubMatrix = Matrix2x2.rotate(angle);
        m.t = center - (m.linearSubMatrix * center);
        return m;
    }
    
    public inline function clone():Matrix3x2
    {
        var self:Matrix3x2 = this;
        return new Matrix3x2(
            self.a,  self.b,
            self.c,  self.d,
            self.tx, self.ty);
    }
    
    @:arrayAccess
    public inline function getArrayElement(i:Int):Float
    {
        var self:Matrix3x2 = this;
        
        switch (i)
        {
            case 0:
                return self.a;
            case 1:
                return self.b;
            case 2:
                return self.tx;
            case 3:
                return self.c;
            case 4:
                return self.d;
            case 5:
                return self.ty;
            default:
                throw "Invalid element";
        }
    }
    
    @:arrayAccess
    public inline function setArrayElement(i:Int, value:Float):Float
    {
        var self:Matrix3x2 = this;
        
        switch (i)
        {
            case 0:
                return self.a = value;
            case 1:
                return self.b = value;
            case 2:
                return self.tx = value;
            case 3:
                return self.c = value;
            case 4:
                return self.d = value;
            case 5:
                return self.ty = value;
            default:
                throw "Invalid element";
        }
    }
    
    public inline function getElement(column:Int, row:Int):Float
    {
        var self:Matrix3x2 = this;
        return self[row * 3 + column];
    }
    
    public inline function setElement(column:Int, row:Int, value:Float):Float
    {
        var self:Matrix3x2 = this;
        return self[row * 3 + column] = value;
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
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Float->Float):Matrix3x2
    {
        var self:Matrix3x2 = this;
        
        for (i in 0...6)
        {
            self[i] = func(self[i]);
        }
        
        return self;
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
        var self2x2:Matrix2x2 = this;
        return self2x2;
    }
    
    private inline function set_linearSubMatrix(value:Matrix2x2):Matrix2x2
    {
        var self2x2:Matrix2x2 = this;
        
        // TODO: copy functions
        self2x2.a = value.a;
        self2x2.b = value.b;
        self2x2.c = value.c;
        self2x2.d = value.d;
        
        return self2x2;
    }
}