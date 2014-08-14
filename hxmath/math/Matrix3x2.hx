package hxmath.math;

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

/**
 * The default underlying type.
 */
class Matrix3x2Default
{
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var d:Float;
    public var tx:Float;
    public var ty:Float;
    
    public function new(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float)
    {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        this.tx = tx;
        this.ty = ty;
    }
}

#if HXMATH_USE_DYNAMIC_STRUCTURES
typedef Matrix3x2Type = Matrix3x2Shape;
#else
typedef Matrix3x2Type = Matrix3x2Default;
#end

/**
 * 3x2 matrix for mixed affine/linear operations defined over a shape matching flash.geom.Matrix.
 */
@:forward(
    a, b,
    c, d,
    tx, ty)
abstract Matrix3x2(Matrix3x2Type) from Matrix3x2Type to Matrix3x2Type
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 6;
    
    // Zero matrix (A + 0 = A, A * 0 = 0)
    public static var zero(get, never):Matrix3x2;
    
    // Identity matrix (A.concat(I) = A)
    public static var identity(get, never):Matrix3x2;
    
    // Translation column vector
    public var t(get, set):Vector2;
    
    // 2x2 sub-matrix corresponding to the linear portion of the transformation
    public var linearSubMatrix(get, set):Matrix2x2;
    
    /**
     * Constructor.
     * 
     * Note: the linear portion (a, b, c, d) is row-major, but the affine portion (tx, ty) is column-major.
     * 
     * @param a     m00
     * @param b     m10
     * @param c     m01
     * @param d     m11
     * @param tx    m20
     * @param ty    m21
     */
    public function new(a:Float = 1.0, b:Float = 0.0, c:Float = 0.0, d:Float = 1.0, tx:Float = 0.0, ty:Float = 0.0) 
    {
        this = new Matrix3x2Default(a, b, c, d, tx, ty);
    }
    
    /**
     * Construct a Matrix3x2 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Matrix3x2
    {
        if (rawData.length != Matrix3x2.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Matrix3x2(rawData[0], rawData[1], rawData[2], rawData[3], rawData[4], rawData[5]);
    }
    
    /**
     * Multiply a scalar with a matrix.
     * 
     * @param s
     * @param m
     * @return      s * m
     */
    @:op(A * B)
    public static inline function multiplyScalar(s:Float, m:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            s * m.a,  s * m.b,
            s * m.c,  s * m.d,
            s * m.tx, s * m.ty);
    }
    
    /**
     * Homegenous matrix*vector product (treats the input vector as though it is a Vector3 with a 1 for the z element).
     * Allows translation and linear (e.g. rotation, scale) transformations to be stored in the same matrix.
     * 
     * @param m     The matrix holding the transformation.
     * @param v     The vector to transform
     * @return      The transformed vector.
     */
    @:op(A * B)
    public static inline function transform(m:Matrix3x2, v:Vector2):Vector2
    {
        return m.linearSubMatrix * v + m.t;
    }
    
    /**
     * Concatenate two transformations.
     * Treat as homogenous matrix multiplication, i.e. there is an implicit 3rd row [0, 0, 1] in both matrices
     * 
     * @param m     The first matrix (the second transformation in the order of application).
     * @param n     The second matrix (the first transformation in the order of application).
     * @return      The combined transformation matrix.
     */
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
    
    /**
     * Add two matrices.
     * 
     * @param m
     * @param n
     * @return      m + n
     */
    @:op(A + B)
    public static inline function add(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        return m.clone()
            .addWith(n);
    }
    
    /**
     * Subtract one matrix from another.
     * 
     * @param m
     * @param n
     * @return      m - n
     */
    @:op(A - B)
    public static inline function subtract(m:Matrix3x2, n:Matrix3x2):Matrix3x2
    {
        return m.clone()
            .subtractWith(n);
    }
    
    /**
     * Create a negated copy of a matrix.
     * 
     * @param m
     * @return      -m
     */
    @:op(-A)
    public static inline function negate(m:Matrix3x2):Matrix3x2
    {
        return new Matrix3x2(
            -m.a,  -m.b,
            -m.c,  -m.d,
            -m.tx, -m.ty);
    }
    
    
    /**
     * Test element-wise equality between two matrices.
     * False if one of the inputs is null and the other is not.
     * 
     * @param m
     * @param n
     * @return      m_ij == n_ij
     */
    @:op(A == B)
    public static inline function equals(m:Matrix3x2, n:Matrix3x2):Bool
    {
        return (m == null && n == null) ||
            m != null &&
            n != null &&
            m.a == n.a &&
            m.b == n.b &&
            m.c == n.c &&
            m.d == n.d &&
            m.tx == n.tx &&
            m.ty == n.ty;
    }
    
    /**
     * Test inequality between two matrices.
     * 
     * @param m
     * @param n
     * @return      !(m_ij == n_ij)
     */
    @:op(A != B)
    public static inline function notEquals(m:Matrix3x2, n:Matrix3x2):Bool
    {
        return !(m == n);
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
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Matrix3x2):Void
    {
        var self:Matrix3x2 = this;
        
        for (i in 0...Matrix3x2.elementCount)
        {
            other[i] = self[i];
        }
    }
    
    /**
     * Set this matrix to a counter-clockwise rotation.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          This.
     */
    public inline function setRotate(angle:Float):Matrix3x2
    {
        var self:Matrix3x2 = this;
        
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        
        self.a = c;
        self.b = -s;
        self.c = s;
        self.d = c;
        
        return self;
    }
    
    /**
     * Add a matrix in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param m
     * @return      self_ij += m_ij
     */
    public inline function addWith(m:Matrix3x2):Matrix3x2
    {
        var self:Matrix3x2 = this;
        
        self.a  += m.a;
        self.b  += m.b;
        self.c  += m.c;
        self.d  += m.d;
        self.tx += m.tx;
        self.ty += m.ty;
        
        return self;
    }
    
    /**
     * Subtract a matrix in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param m
     * @return      self_ij -= m_ij
     */
    public inline function subtractWith(m:Matrix3x2):Matrix3x2
    {
        var self:Matrix3x2 = this;
        
        self.a  -= m.a;
        self.b  -= m.b;
        self.c  -= m.c;
        self.d  -= m.d;
        self.tx -= m.tx;
        self.ty -= m.ty;
        
        return self;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Matrix3x2
    {
        var self:Matrix3x2 = this;
        return new Matrix3x2(
            self.a,  self.b,
            self.c,  self.d,
            self.tx, self.ty);
    }
    
    /**
     * Get an element by position.
     * The implicit array is row-major (e.g. element (column count) + 1 is the first element of the second row).
     * 
     * @param i         The element index.
     * @return          The element.
     */
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
    
    /**
     * Set an element by position.
     * The implicit array is row-major (e.g. element (column count) + 1 is the first element of the second row).
     * 
     * @param i         The element index.
     * @param value     The new value.
     * @return          The updated element.
     */
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
    
    /**
     * Get an element by (column, row) indices.
     * Both column and row indices start at 0, e.g. the index of the first element of the first row is (0, 0).
     * 
     * @param column    The column index.
     * @param row       The row index.
     * @return          The element.
     */
    public inline function getElement(column:Int, row:Int):Float
    {
        var self:Matrix3x2 = this;
        return self[row * 3 + column];
    }
    
    /**
     * Set an element by (column, row) indices.
     * Both column and row indices start at 0, e.g. the index of the first element of the first row is (0, 0).
     * 
     * @param column    The column index.
     * @param row       The row index.
     * @param value     The new value.
     * @return          The updated element.
     */
    public inline function setElement(column:Int, row:Int, value:Float):Float
    {
        var self:Matrix3x2 = this;
        return self[row * 3 + column] = value;
    }
    
    /**
     * Get a column vector by index.
     * 
     * @param index     The 0-based index of the column.
     * @return          The column as a vector.
     */
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
    
    /**
     * Get a row vector by index.
     * 
     * @param index     The 0-based index of the row.
     * @return          The row as a vector.
     */
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
        return t;
    }
    
    private inline function get_linearSubMatrix():Matrix2x2
    {
        var self:Matrix3x2 = this;
        return new Matrix2x2(self.a, self.b, self.c, self.d);
    }
    
    private inline function set_linearSubMatrix(value:Matrix2x2):Matrix2x2
    {
        var self:Matrix3x2 = this;
        self.a = value.a;
        self.b = value.b;
        self.c = value.c;
        self.d = value.d;
        return value;
    }
}