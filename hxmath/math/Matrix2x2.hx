package hxmath.math;

// Note: All notation is column-major, e.g. m10 is the top element of the 2nd column
typedef Matrix2x2Shape = 
{
    // m00
    public var a:Float;
    
    // m10
    public var b:Float;
    
    // m01
    public var c:Float;
    
    // m11
    public var d:Float;
}

/**
 * The default underlying type.
 */
class Matrix2x2Default
{
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var d:Float;
    
    public function new(a:Float, b:Float, c:Float, d:Float)
    {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
    }
    
    public function toString():String
    {
        return '[a: $a, b: $b, c: $c, d: $d]';
    }
}

typedef Matrix2x2Type = Matrix2x2Default;

/**
 * 2x2 matrix for linear operations defined over a shape matching the 2x2 linear sub-matrix in flash.geom.Matrix.
 */
@:forward(
    a, b,
    c, d)
abstract Matrix2x2(Matrix2x2Type) from Matrix2x2Type to Matrix2x2Type
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 4;
    
    // Zero matrix (A + 0 = A, A * 0 = 0)
    public static var zero(get, never):Matrix2x2;
    
    // Identity matrix (A * I = A)
    public static var identity(get, never):Matrix2x2;
    
    // Determinant (the "area" of the basis)
    public var det(get, never):Float;
    
    // Transpose (columns become rows)
    public var transpose(get, never):Matrix2x2;

    /**
     * Constructor.
     * 
     * Note: parameters are in row-major order for syntactic niceness.
     * 
     * @param a     m00
     * @param b     m10
     * @param c     m01
     * @param d     m11
     */
    public inline function new(a:Float, b:Float, c:Float, d:Float) 
    {
        this = new Matrix2x2Default(a, b, c, d);
    }
    
    /**
     * Construct a Matrix2x2 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Matrix2x2
    {
        if (rawData.length != Matrix2x2.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Matrix2x2(rawData[0], rawData[1], rawData[2], rawData[3]);
    }
    
    /**
     * Convert a shape-similar matrix.
     * 
     * @param other     The matrix to convert.
     * @return          The hxmath equivalent.
     */
    @:from
    public static inline function fromMatrix2x2Shape(other:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(other.a, other.b, other.c, other.d);
    }

    /**
     * Multiply a scalar with a matrix.
     * 
     * @param s
     * @param m
     * @return      s * m
     */
    @:op(A * B)
    public static inline function multiplyScalar(s:Float, m:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(
            s * m.a, s * m.b,
            s * m.c, s * m.d);
    }
    
    /**
     * Multiply a matrix with a vector.
     * 
     * @param m
     * @param v
     * @return      m * v
     */
    @:op(A * B)
    public static inline function multiplyVector(m:Matrix2x2, v:Vector2):Vector2
    {
        return new Vector2(
            m.a * v.x + m.b * v.y,
            m.c * v.x + m.d * v.y);
    }
    
    /**
     * Multiply two matrices.
     * 
     * @param m
     * @param n
     * @return      m * n
     */
    @:op(A * B)
    public static inline function multiply(m:Matrix2x2, n:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(
            m.a * n.a + m.b * n.c,  // p_00 = m_i0 * n_0i
            m.a * n.b + m.b * n.d,  // p_10 = m_i0 * n_1i
            m.c * n.a + m.d * n.c,  // p_01 = m_i1 * n_0i
            m.c * n.b + m.d * n.d); // p_11 = m_i1 * n_1i
    }
    
    /**
     * Add two matrices.
     * 
     * @param m
     * @param n
     * @return      m + n
     */
    @:op(A + B)
    public static inline function add(m:Matrix2x2, n:Matrix2x2):Matrix2x2
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
    public static inline function subtract(m:Matrix2x2, n:Matrix2x2):Matrix2x2
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
    public static inline function negate(m:Matrix2x2):Matrix2x2
    {
        return new Matrix2x2(
            -m.a, -m.b,
            -m.c, -m.d);
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
    public static inline function equals(m:Matrix2x2, n:Matrix2x2):Bool
    {
        return (m == null && n == null) ||
            m != null &&
            n != null &&
            m.a == n.a &&
            m.b == n.b &&
            m.c == n.c &&
            m.d == n.d;
    }
    
    /**
     * Counter-clockwise rotation.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          The rotation matrix.
     */
    public static inline function rotate(angle:Float):Matrix2x2
    {
        // .zero doesn't work (compiler bug?)
        return Matrix2x2.get_zero()
            .setRotate(angle);
    }
    
    /**
     * Non-uniform scale matrix.
     * 
     * @param sx    The amount to scale along the X axis.
     * @param sy    The amount to scale along the Y axis.
     * @return      The scale matrix.
     */
    public static inline function scale(sx:Float, sy:Float):Matrix2x2
    {
        return new Matrix2x2(
            sx, 0.0,
            0.0, sy);
    }
    
    /**
     * Set this matrix to a counter-clockwise rotation.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          This.
     */
    public inline function setRotate(angle:Float):Matrix2x2
    {
        var self:Matrix2x2 = this;
        
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        
        self.a = c;
        self.b = -s;
        self.c = s;
        self.d = c;
        
        return self;
    }
    
    /**
     * Sets all the fields of this structure without allocation.
     * 
     * @param a
     * @param b
     * @param c
     * @param d
     * @return self
     */
    public inline function set(a:Float, b:Float, c:Float, d:Float):Matrix2x2
    {
        var self:Matrix2x2 = this;
        
        self.a = a;
        self.b = b;
        self.c = c;
        self.d = d;
        
        return this;
    }
    
    /**
     * Add a matrix in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param m
     * @return      self_ij += m_ij
     */
    public inline function addWith(m:Matrix2x2):Matrix2x2
    {
        var self:Matrix2x2 = this;
        
        self.a  += m.a;
        self.b  += m.b;
        self.c  += m.c;
        self.d  += m.d;
        
        return self;
    }
    
    /**
     * Subtract a matrix in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param m
     * @return      self_ij -= m_ij
     */
    public inline function subtractWith(m:Matrix2x2):Matrix2x2
    {
        var self:Matrix2x2 = this;
        
        self.a  -= m.a;
        self.b  -= m.b;
        self.c  -= m.c;
        self.d  -= m.d;
        
        return self;
    }
    
    /**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:Matrix2x2):Void
    {
        var self:Matrix2x2 = this;
        
        for (i in 0...Matrix2x2.elementCount)
        {
            target[i] = self[i];
        }
    }
    
    /**
     * Copy the contents of this structure to another (shape-similar) instance.
     * 
     * @param target    The target structure.
     */
    public inline function copyToShape(target:Matrix2x2Shape):Void
    {
        var self:Matrix2x2 = this;
        
        target.a = self.a;
        target.b = self.b;
        target.c = self.c;
        target.d = self.d;
    }
    
    /**
     * Copy the contents of another (shape-similar) instance to this structure.
     * 
     * @param source    The source structure.
     */
    public inline function copyFromShape(source:Matrix2x2Shape):Void
    {
        var self:Matrix2x2 = this;
        
        self.a = source.a;
        self.b = source.b;
        self.c = source.c;
        self.d = source.d;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Matrix2x2
    {
        var self:Matrix2x2 = this;
        return new Matrix2x2(
            self.a, self.b,
            self.c, self.d
        );
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
        var self:Matrix2x2 = this;
        
        switch (i)
        {
            case 0:
                return self.a;
            case 1:
                return self.b;
            case 2:
                return self.c;
            case 3:
                return self.d;
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
        var self:Matrix2x2 = this;
        
        switch (i)
        {
            case 0:
                return self.a = value;
            case 1:
                return self.b = value;
            case 2:
                return self.c = value;
            case 3:
                return self.d = value;
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
        var self:Matrix2x2 = this;
        return self[row * 2 + column];
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
        var self:Matrix2x2 = this;
        return self[row * 2 + column] = value;
    }
    
    /**
     * Get a column vector by index.
     * 
     * @param index     The 0-based index of the column.
     * @return          The column as a vector.
     */
    public inline function col(index:Int):Vector2
    {
        var self:Matrix2x2 = this;
        
        switch (index)
        {
            case 0:
                return new Vector2(self.a, self.c);
            case 1:
                return new Vector2(self.b, self.d);
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
    public inline function row(index:Int):Vector2
    {
        var self:Matrix2x2 = this;
        
        switch (index)
        {
            case 0:
                return new Vector2(self.a, self.b);
            case 1:
                return new Vector2(self.c, self.d);
            default:
                throw "Invalid row";
        }
    }
    
    /**
     * Multiply the tranpose of the matrix with a vector. Useful for fast inverse rotations.
     * 
     * @param v     The vector to multiply with.
     * @return      this^T * v.    
     */
    public inline function transposeMultiplyVector(v:Vector2):Vector2
    {
        var self:Matrix2x2 = this;
        
        return new Vector2(
            self.a * v.x + self.c * v.y,
            self.b * v.x + self.d * v.y);
    }
    
    /**
     * Apply a scalar function to each element.
     * 
     * @param func  The function to apply.
     * @return      The modified object.
     */
    public inline function applyScalarFunc(func:Float->Float):Matrix2x2
    {
        var self:Matrix2x2 = this;
        
        for (i in 0...elementCount)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    private static inline function get_zero():Matrix2x2
    {
        return new Matrix2x2(
            0.0, 0.0,
            0.0, 0.0);
    }
    
    private static inline function get_identity():Matrix2x2
    {
        return new Matrix2x2(
            1.0, 0.0,
            0.0, 1.0);
    }
    
    private inline function get_det():Float
    {
        var self:Matrix2x2 = this;
        return MathUtil.det2x2(
            self.a, self.b,
            self.c, self.d);
    }
    
    private inline function get_transpose():Matrix2x2
    {
        var self:Matrix2x2 = this;
        return new Matrix2x2(
            self.a, self.c,
            self.b, self.d);
    }
}