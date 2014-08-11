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
 * 3x3 matrix for linear transformations in 3D.
 */
@:forward(
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22)
abstract Matrix3x3(Matrix3x3Shape) from Matrix3x3Shape to Matrix3x3Shape
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
     * Constructor. Takes a row-major array input array (when written out the array is ordered like the matrix).
     * 
     * @param rawData   The matrix as a row-major array.
     */
    public function new(rawData:Array<Float> = null) 
    {
        if (rawData == null)
        {
            this = Matrix3x3.identity;
        }
        else
        {
            if (rawData.length != 9)
            {
                throw "Invalid rawData.";
            }
            
            this = {
                m00: rawData[0], m10: rawData[1], m20: rawData[2],
                m01: rawData[3], m11: rawData[4], m21: rawData[5],
                m02: rawData[6], m12: rawData[7], m22: rawData[8]
            };
        }
    }
    
    /**
     * Construct a Matrix3x3 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Matrix3x3
    {
        return new Matrix3x3(rawData);
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
        return new Matrix3x3([
            s * a.m00, s * a.m10, s * a.m20,
            s * a.m01, s * a.m11, s * a.m21,
            s * a.m02, s * a.m12, s * a.m22
        ]);
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
        return new Matrix3x3([
            a.m00 * b.m00 + a.m10 * b.m01 + a.m20 * b.m02, // p_00 = a_i0 * b_0i
            a.m00 * b.m10 + a.m10 * b.m11 + a.m20 * b.m12, // p_10 = a_i0 * b_1i
            a.m00 * b.m20 + a.m10 * b.m21 + a.m20 * b.m22, // p_20 = a_i0 * b_2i
            
            a.m01 * b.m00 + a.m11 * b.m01 + a.m21 * b.m02, // p_01 = a_i1 * b_0i
            a.m01 * b.m10 + a.m11 * b.m11 + a.m21 * b.m12, // p_11 = a_i1 * b_1i
            a.m01 * b.m20 + a.m11 * b.m21 + a.m21 * b.m22, // p_21 = a_i1 * b_2i
            
            a.m02 * b.m00 + a.m12 * b.m01 + a.m22 * b.m02, // p_02 = a_i2 * b_0i
            a.m02 * b.m10 + a.m12 * b.m11 + a.m22 * b.m12, // p_12 = a_i2 * b_1i
            a.m02 * b.m20 + a.m12 * b.m21 + a.m22 * b.m22  // p_22 = a_i2 * b_2i
        ]);
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
        return new Matrix3x3([
            -a.m00, -a.m10, -a.m20,
            -a.m01, -a.m11, -a.m21,
            -a.m02, -a.m12, -a.m22
        ]);
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
     * Test inequality between two matrices.
     * 
     * @param a
     * @param b
     * @return      !(a_ij == b_ij)
     */
    @:op(A != B)
    public static inline function notEquals(a:Matrix3x3, b:Matrix3x3):Bool
    {
        return !(a == b);
    }
    
    /**
     * Add a matrix in place.
     * Note: += operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @param b
     * @return      a_ij += b_ij
     */
    public static inline function addWith(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        a.m00 += b.m00;
        a.m10 += b.m10;
        a.m20 += b.m20;
        a.m01 += b.m01;
        a.m11 += b.m11;
        a.m21 += b.m21;
        a.m02 += b.m02;
        a.m12 += b.m12;
        a.m22 += b.m22;
        return a;
    }
    
    /**
     * Subtract a matrix in place.
     * Note: -= operator on Haxe abstracts does not behave this way (a new object is returned).
     * 
     * @param a
     * @param b
     * @return      a_ij -= b_ij
     */
    public static inline function subtractWith(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        a.m00 -= b.m00;
        a.m10 -= b.m10;
        a.m20 -= b.m20;
        a.m01 -= b.m01;
        a.m11 -= b.m11;
        a.m21 -= b.m21;
        a.m02 -= b.m02;
        a.m12 -= b.m12;
        a.m22 -= b.m22;
        return a;
    }
    
    /**
     * Counter-clockwise rotation around the X axis.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          The rotation matrix.
     */
    public static inline function rotationX(angle:Float):Matrix3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        return new Matrix3x3([
            1, 0,  0,
            0, c, -s,
            0, s,  c
        ]);
    }
    
    /**
     * Counter-clockwise rotation around the Y axis.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          The rotation matrix.
     */
    public static inline function rotationY(angle:Float):Matrix3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        return new Matrix3x3([
             c,  0, s,
             0,  1, 0,
            -s,  0, c
        ]);
    }
    
    /**
     * Counter-clockwise rotation around the Z axis.
     * 
     * @param angle     The angle to rotate (in radians).
     * @return          The rotation matrix.
     */
    public static inline function rotationZ(angle:Float):Matrix3x3
    {
        var s = Math.sin(angle);
        var c = Math.cos(angle);
        return new Matrix3x3([
            c, -s, 0,
            s,  c, 0,
            0,  0, 1
        ]);
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
        return new Matrix3x3([
            sx, 0.0, 0.0,
            0.0, sy, 0.0,
            0.0, 0.0, sz
        ]);
    }
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Matrix3x3):Void
    {
        var self:Matrix3x3 = this;
        
        for (i in 0...Matrix3x3.elementCount)
        {
            other[i] = self[i];
        }
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Matrix3x3
    {
        var self:Matrix3x3 = this;
        return new Matrix3x3([
            self.m00, self.m10, self.m20,
            self.m01, self.m11, self.m21,
            self.m02, self.m12, self.m22
        ]);
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
        
        for (i in 0...9)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    private static inline function get_zero():Matrix3x3
    {
        return new Matrix3x3([
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0
        ]);
    }
    
    private static inline function get_identity():Matrix3x3
    {
        return new Matrix3x3([
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0
        ]);
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
        return new Matrix3x3([
            self.m00, self.m01, self.m02,
            self.m10, self.m11, self.m12,
            self.m20, self.m21, self.m22]);
    }
}