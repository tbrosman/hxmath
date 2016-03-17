package hxmath.math;

// Note: All notation is column-major, e.g. m10 is the top element of the 2nd column
typedef Matrix3x3Shape = 
{
    public var m00:Float;
    public var m01:Float;
    public var m02:Float;
    
    public var m10:Float;
    public var m11:Float;
    public var m12:Float;
    
    public var m20:Float;
    public var m21:Float;
    public var m22:Float;
}

/**
 * The default underlying type.
 */
class Matrix3x3Default
{
    public var m00:Float;
    public var m01:Float;
    public var m02:Float;
    
    public var m10:Float;
    public var m11:Float;
    public var m12:Float;
    
    public var m20:Float;
    public var m21:Float;
    public var m22:Float;
    
    public function new(
        m00:Float, m10:Float, m20:Float,
        m01:Float, m11:Float, m21:Float,
        m02:Float, m12:Float, m22:Float)
    {
        this.m00 = m00;
        this.m10 = m10;
        this.m20 = m20;
        
        this.m01 = m01;
        this.m11 = m11;
        this.m21 = m21;
        
        this.m02 = m02;
        this.m12 = m12;
        this.m22 = m22;
    }
    
    public function toString():String
    {
        return '[[$m00, $m10, $m20], [$m01, $m11, $m21], [$m02, $m12, $m22]]';
    }
}

typedef Matrix3x3Type = Matrix3x3Default;

/**
 * 3x3 matrix for linear transformations in 3D.
 */
@:forward(
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22)
abstract Matrix3x3(Matrix3x3Type) from Matrix3x3Type to Matrix3x3Type
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 9;
    
    // Zero matrix (A + 0 = A, A * 0 = 0)
    public static var zero(get, never):Matrix3x3;
    
    // Identity matrix (A * I = A)
    public static var identity(get, never):Matrix3x3;
    
    // Determinant (the "area" of the basis)
    public var det(get, never):Float;
    
    // Transpose (columns become rows)
    public var transpose(get, never):Matrix3x3;
    
    /**
     * Constructor. Parameters are in row-major order (when written out the array is ordered like the matrix).
     * 
     * @param m00
     * @param m10
     * @param m20
     * @param m01
     * @param m11
     * @param m21
     * @param m02
     * @param m12
     * @param m22
     */
    public inline function new(
        m00:Float, m10:Float, m20:Float,
        m01:Float, m11:Float, m21:Float,
        m02:Float, m12:Float, m22:Float)
    {
        this = new Matrix3x3Default(
            m00, m10, m20,
            m01, m11, m21,
            m02, m12, m22);
    }
    
    /**
     * Construct a Matrix3x3 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Matrix3x3
    {
        if (rawData.length != Matrix3x3.elementCount)
        {
            throw "Invalid rawData.";
        }
        
        return new Matrix3x3(
            rawData[0], rawData[1], rawData[2],
            rawData[3], rawData[4], rawData[5],
            rawData[6], rawData[7], rawData[8]);
    }
    
    /**
     * Convert a shape-similar matrix.
     * 
     * @param other     The matrix to convert.
     * @return          The hxmath equivalent.
     */
    @:from
    public static inline function fromMatrix3x3Shape(other:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3(
            other.m00, other.m10, other.m20,
            other.m01, other.m11, other.m21,
            other.m02, other.m12, other.m22);
    }
    
    /**
     * Multiply a scalar with a matrix.
     * 
     * @param s
     * @param a
     * @return      s * a
     */
    @:op(A * B)
    public static inline function multiplyScalar(s:Float, a:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3(
            s * a.m00, s * a.m10, s * a.m20,
            s * a.m01, s * a.m11, s * a.m21,
            s * a.m02, s * a.m12, s * a.m22);
    }
    
    /**
     * Multiply a matrix with a vector.
     * 
     * @param a
     * @param v
     * @return      a * v
     */
    @:op(A * B)
    public static inline function multiplyVector(a:Matrix3x3, v:Vector3):Vector3
    {
        return new Vector3(
            a.m00 * v.x + a.m10 * v.y + a.m20 * v.z,
            a.m01 * v.x + a.m11 * v.y + a.m21 * v.z,
            a.m02 * v.x + a.m12 * v.y + a.m22 * v.z);
    }
    
    /**
     * Multiply two matrices.
     * 
     * @param a
     * @param b
     * @return      a * b
     */
    @:op(A * B)
    public static inline function multiply(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3(
            a.m00 * b.m00 + a.m10 * b.m01 + a.m20 * b.m02,  // p_00 = a_i0 * b_0i
            a.m00 * b.m10 + a.m10 * b.m11 + a.m20 * b.m12,  // p_10 = a_i0 * b_1i
            a.m00 * b.m20 + a.m10 * b.m21 + a.m20 * b.m22,  // p_20 = a_i0 * b_2i
            
            a.m01 * b.m00 + a.m11 * b.m01 + a.m21 * b.m02,  // p_01 = a_i1 * b_0i
            a.m01 * b.m10 + a.m11 * b.m11 + a.m21 * b.m12,  // p_11 = a_i1 * b_1i
            a.m01 * b.m20 + a.m11 * b.m21 + a.m21 * b.m22,  // p_21 = a_i1 * b_2i
            
            a.m02 * b.m00 + a.m12 * b.m01 + a.m22 * b.m02,  // p_02 = a_i2 * b_0i
            a.m02 * b.m10 + a.m12 * b.m11 + a.m22 * b.m12,  // p_12 = a_i2 * b_1i
            a.m02 * b.m20 + a.m12 * b.m21 + a.m22 * b.m22); // p_22 = a_i2 * b_2i
    }
    
    /**
     * Add two matrices.
     * 
     * @param a
     * @param b
     * @return      a + b
     */
    @:op(A + B)
    public static inline function add(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        return a.clone()
            .addWith(b);
    }
    
    /**
     * Subtract one matrix from another.
     * 
     * @param a
     * @param b
     * @return      a - b
     */
    @:op(A - B)
    public static inline function subtract(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        return a.clone()
            .subtractWith(b);
    }
    
    /**
     * Create a negated copy of a matrix.
     * 
     * @param a
     * @return      -a
     */
    @:op(-A)
    public static inline function negate(a:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3(
            -a.m00, -a.m10, -a.m20,
            -a.m01, -a.m11, -a.m21,
            -a.m02, -a.m12, -a.m22);
    }
    
    /**
     * Test element-wise equality between two matrices.
     * False if one of the inputs is null and the other is not.
     * 
     * @param a
     * @param b
     * @return      a_ij == b_ij
     */
    @:op(A == B)
    public static inline function equals(a:Matrix3x3, b:Matrix3x3):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.m00 == b.m00 &&
            a.m10 == b.m10 &&
            a.m20 == b.m20 &&
            a.m01 == b.m01 &&
            a.m11 == b.m11 &&
            a.m21 == b.m21 &&
            a.m02 == b.m02 &&
            a.m12 == b.m12 &&
            a.m22 == b.m22;
    }
    
    /**
     * Counter-clockwise rotation around the X axis.
     * 
     * @param angle     The angle to rotate (in degrees).
     * @return          The rotation matrix.
     */
    public static inline function rotationX(angleDegrees:Float):Matrix3x3
    {
        var angleRadians = MathUtil.degToRad(angleDegrees);
        var s = Math.sin(angleRadians);
        var c = Math.cos(angleRadians);
        return new Matrix3x3(
            1, 0,  0,
            0, c, -s,
            0, s,  c);
    }
    
    /**
     * Counter-clockwise rotation around the Y axis.
     * 
     * @param angle     The angle to rotate (in degrees).
     * @return          The rotation matrix.
     */
    public static inline function rotationY(angleDegrees:Float):Matrix3x3
    {
        var angleRadians = MathUtil.degToRad(angleDegrees);
        var s = Math.sin(angleRadians);
        var c = Math.cos(angleRadians);
        return new Matrix3x3(
             c,  0, s,
             0,  1, 0,
            -s,  0, c);
    }
    
    /**
     * Counter-clockwise rotation around the Z axis.
     * 
     * @param angle     The angle to rotate (in degrees).
     * @return          The rotation matrix.
     */
    public static inline function rotationZ(angleDegrees:Float):Matrix3x3
    {
        var angleRadians = MathUtil.degToRad(angleDegrees);
        var s = Math.sin(angleRadians);
        var c = Math.cos(angleRadians);
        return new Matrix3x3(
            c, -s, 0,
            s,  c, 0,
            0,  0, 1);
    }

    /**
     * Non-uniform scale matrix.
     * 
     * @param sx    The amount to scale along the X axis.
     * @param sy    The amount to scale along the Y axis.
     * @param sz    The amount to scale along the Z axis.
     * @return      The scale matrix.
     */
    public static inline function scale(sx:Float, sy:Float, sz:Float):Matrix3x3
    {
        return new Matrix3x3(
            sx, 0.0, 0.0,
            0.0, sy, 0.0,
            0.0, 0.0, sz);
    }
    
    /**
     * Sets all the fields of this structure without allocation.
     * 
     * @param m00
     * @param m10
     * @param m20
     * @param m01
     * @param m11
     * @param m21
     * @param m02
     * @param m12
     * @param m22
     * @return self
     */
    public inline function set(
        m00:Float, m10:Float, m20:Float,
        m01:Float, m11:Float, m21:Float,
        m02:Float, m12:Float, m22:Float):Matrix3x3
    {
        var self:Matrix3x3 = this;
        
        self.m00 = m00;
        self.m10 = m10;
        self.m20 = m20;
        
        self.m01 = m01;
        self.m11 = m11;
        self.m21 = m21;
        
        self.m02 = m02;
        self.m12 = m12;
        self.m22 = m22;
        
        return self;
    }
    
    /**
     * Add a matrix in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_ij += a_ij
     */
    public inline function addWith(a:Matrix3x3):Matrix3x3
    {
        var self:Matrix3x3 = this;
        
        self.m00 += a.m00;
        self.m10 += a.m10;
        self.m20 += a.m20;
        self.m01 += a.m01;
        self.m11 += a.m11;
        self.m21 += a.m21;
        self.m02 += a.m02;
        self.m12 += a.m12;
        self.m22 += a.m22;
        
        return self;
    }
    
    /**
     * Subtract a matrix in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @return      self_ij -= a_ij
     */
    public inline function subtractWith(a:Matrix3x3):Matrix3x3
    {
        var self:Matrix3x3 = this;
        
        self.m00 -= a.m00;
        self.m10 -= a.m10;
        self.m20 -= a.m20;
        self.m01 -= a.m01;
        self.m11 -= a.m11;
        self.m21 -= a.m21;
        self.m02 -= a.m02;
        self.m12 -= a.m12;
        self.m22 -= a.m22;
        
        return self;
    }
    
    /**
     * Copy the contents of this structure to another.
     * Faster than copyToShape for static platforms (C++, etc) but requires the target to have the exact same inner type.
     * 
     * @param target    The target structure.
     */
    public inline function copyTo(target:Matrix3x3):Void
    {
        var self:Matrix3x3 = this;
        
        for (i in 0...Matrix3x3.elementCount)
        {
            target[i] = self[i];
        }
    }
    
    /**
     * Copy the contents of this structure to another (shape-similar) instance.
     * 
     * @param target    The target structure.
     */
    public inline function copyToShape(target:Matrix3x3Shape):Void
    {
        var self:Matrix3x3 = this;
        
        target.m00 = self.m00;
        target.m01 = self.m01;
        target.m02 = self.m02;
        
        target.m10 = self.m10;
        target.m11 = self.m11;
        target.m12 = self.m12;
        
        target.m20 = self.m20;
        target.m21 = self.m21;
        target.m22 = self.m22;
    }
    
    /**
     * Copy the contents of another (shape-similar) instance to this structure.
     * 
     * @param source    The source structure.
     */
    public inline function copyFromShape(source:Matrix3x3Shape):Void
    {
        var self:Matrix3x3 = this;
        
        self.m00 = source.m00;
        self.m01 = source.m01;
        self.m02 = source.m02;
        
        self.m10 = source.m10;
        self.m11 = source.m11;
        self.m12 = source.m12;
        
        self.m20 = source.m20;
        self.m21 = source.m21;
        self.m22 = source.m22;
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Matrix3x3
    {
        var self:Matrix3x3 = this;
        return new Matrix3x3(
            self.m00, self.m10, self.m20,
            self.m01, self.m11, self.m21,
            self.m02, self.m12, self.m22);
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
        var self:Matrix3x3 = this;
        
        switch (i)
        {
            case 0:
                return self.m00;
            case 1:
                return self.m10;
            case 2:
                return self.m20;
            case 3:
                return self.m01;
            case 4:
                return self.m11;
            case 5:
                return self.m21;
            case 6:
                return self.m02;
            case 7:
                return self.m12;
            case 8:
                return self.m22;
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
        var self:Matrix3x3 = this;
        
        switch (i)
        {
            case 0:
                return self.m00 = value;
            case 1:
                return self.m10 = value;
            case 2:
                return self.m20 = value;
            case 3:
                return self.m01 = value;
            case 4:
                return self.m11 = value;
            case 5:
                return self.m21 = value;
            case 6:
                return self.m02 = value;
            case 7:
                return self.m12 = value;
            case 8:
                return self.m22 = value;
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
        var self:Matrix3x3 = this;
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
        var self:Matrix3x3 = this;
        return self[row * 3 + column] = value;
    }
    
    /**
     * Get a column vector by index.
     * 
     * @param index     The 0-based index of the column.
     * @return          The column as a vector.
     */
    public inline function col(index:Int):Vector3
    {
        var self:Matrix3x3 = this;
        
        switch (index)
        {
            case 0:
                return new Vector3(self.m00, self.m01, self.m02);
            case 1:
                return new Vector3(self.m10, self.m11, self.m12);
            case 2:
                return new Vector3(self.m20, self.m21, self.m22);
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
        var self:Matrix3x3 = this;
        
        switch (index)
        {
            case 0:
                return new Vector3(self.m00, self.m10, self.m20);
            case 1:
                return new Vector3(self.m01, self.m11, self.m21);
            case 2:
                return new Vector3(self.m02, self.m12, self.m22);
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
    public inline function applyScalarFunc(func:Float->Float):Matrix3x3
    {
        var self:Matrix3x3 = this;
        
        for (i in 0...elementCount)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    private static inline function get_zero():Matrix3x3
    {
        return new Matrix3x3(
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0);
    }
    
    private static inline function get_identity():Matrix3x3
    {
        return new Matrix3x3(
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0);
    }
    
    private inline function get_det():Float
    {
        var self:Matrix3x3 = this;
        return MathUtil.det3x3(
            self.m00, self.m10, self.m20,
            self.m01, self.m11, self.m21,
            self.m02, self.m12, self.m22);
    }
    
    private inline function get_transpose():Matrix3x3
    {
        var self:Matrix3x3 = this;
        return new Matrix3x3(
            self.m00, self.m01, self.m02,
            self.m10, self.m11, self.m12,
            self.m20, self.m21, self.m22);
    }
}