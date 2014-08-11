package hxmath.math;

// Note: All notation is column-major, e.g. m10 is the top element of the 2nd column
typedef Matrix4x4Shape = 
{
    public var m00:Float;
    public var m01:Float;
    public var m02:Float;
    public var m03:Float;
    
    public var m10:Float;
    public var m11:Float;
    public var m12:Float;
    public var m13:Float;
    
    public var m20:Float;
    public var m21:Float;
    public var m22:Float;
    public var m23:Float;
    
    public var m30:Float;
    public var m31:Float;
    public var m32:Float;
    public var m33:Float;
}

/**
 * 4x4 matrix for homogenous/projection transformations in 3D.
 */
@:forward(
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33)
abstract Matrix4x4(Matrix4x4Shape) from Matrix4x4Shape to Matrix4x4Shape
{
    // The number of elements in this structure
    public static inline var elementCount:Int = 16;
    
    // Zero matrix (A + 0 = A, A * 0 = 0)
    public static var zero(get, never):Matrix4x4;
    
    // Identity matrix (A * I = A)
    public static var identity(get, never):Matrix4x4;
    
    // Determinant (the "area" of the basis)
    public var det(get, never):Float;
    
    // Transpose (columns become rows)
    public var transpose(get, never):Matrix4x4;
    
    /**
     * Constructor. Takes a row-major array input array (when written out the array is ordered like the matrix).
     * 
     * @param rawData   The matrix as a row-major array.
     */
    public function new(rawData:Array<Float> = null) 
    {
        if (rawData == null)
        {
            // Getting a compile error with just Matrix4x4.identity. Compiler bug?
            this = Matrix4x4.get_identity();
        }
        else
        {
            if (rawData.length != 16)
            {
                throw "Invalid rawData.";
            }
            
            this = {
                m00: rawData[0],  m10: rawData[1],  m20: rawData[2],  m30: rawData[3],
                m01: rawData[4],  m11: rawData[5],  m21: rawData[6],  m31: rawData[7],
                m02: rawData[8],  m12: rawData[9],  m22: rawData[10], m32: rawData[11],
                m03: rawData[12], m13: rawData[13], m23: rawData[14], m33: rawData[15]
            };
        }
    }
    
    /**
     * Construct a Matrix4x4 from an array.
     * 
     * @param rawData   The input array.
     * @return          The constructed structure.
     */
    public static inline function fromArray(rawData:Array<Float>):Matrix4x4
    {
        return new Matrix4x4(rawData);
    }
    
    /**
     * Multiply a matrix with a vector.
     * 
     * @param a
     * @param v
     * @return      a * v
     */
    @:op(A * B)
    public static inline function multiplyVector(a:Matrix4x4, v:Vector4):Vector4
    {
        return new Vector4(
            a.m00 * v.x + a.m10 * v.y + a.m20 * v.z + a.m30 * v.w,
            a.m01 * v.x + a.m11 * v.y + a.m21 * v.z + a.m31 * v.w,
            a.m02 * v.x + a.m12 * v.y + a.m22 * v.z + a.m32 * v.w,
            a.m03 * v.x + a.m13 * v.y + a.m23 * v.z + a.m33 * v.w);
    }

    /**
     * Multiply two matrices.
     * 
     * @param a
     * @param b
     * @return      a * b
     */
    @:op(A * B)
    public static inline function multiply(a:Matrix4x4, b:Matrix4x4):Matrix4x4
    {
        return new Matrix4x4([
            a.m00 * b.m00 + a.m10 * b.m01 + a.m20 * b.m02 + a.m30 * b.m03, // p_00 = a_i0 * b_0i
            a.m00 * b.m10 + a.m10 * b.m11 + a.m20 * b.m12 + a.m30 * b.m13, // p_10 = a_i0 * b_1i
            a.m00 * b.m20 + a.m10 * b.m21 + a.m20 * b.m22 + a.m30 * b.m23, // p_20 = a_i0 * b_2i
            a.m00 * b.m30 + a.m10 * b.m31 + a.m20 * b.m32 + a.m30 * b.m33, // p_30 = a_i0 * b_3i
            
            a.m01 * b.m00 + a.m11 * b.m01 + a.m21 * b.m02 + a.m31 * b.m03, // p_01 = a_i1 * b_0i
            a.m01 * b.m10 + a.m11 * b.m11 + a.m21 * b.m12 + a.m31 * b.m13, // p_11 = a_i1 * b_1i
            a.m01 * b.m20 + a.m11 * b.m21 + a.m21 * b.m22 + a.m31 * b.m23, // p_21 = a_i1 * b_2i
            a.m01 * b.m30 + a.m11 * b.m31 + a.m21 * b.m32 + a.m31 * b.m33, // p_31 = a_i1 * b_3i
            
            a.m02 * b.m00 + a.m12 * b.m01 + a.m22 * b.m02 + a.m32 * b.m03, // p_02 = a_i2 * b_0i
            a.m02 * b.m10 + a.m12 * b.m11 + a.m22 * b.m12 + a.m32 * b.m13, // p_12 = a_i2 * b_1i
            a.m02 * b.m20 + a.m12 * b.m21 + a.m22 * b.m22 + a.m32 * b.m23, // p_22 = a_i2 * b_2i
            a.m02 * b.m30 + a.m12 * b.m31 + a.m22 * b.m32 + a.m32 * b.m33, // p_32 = a_i2 * b_3i
            
            a.m03 * b.m00 + a.m13 * b.m01 + a.m23 * b.m02 + a.m33 * b.m03, // p_03 = a_i3 * b_0i
            a.m03 * b.m10 + a.m13 * b.m11 + a.m23 * b.m12 + a.m33 * b.m13, // p_13 = a_i3 * b_1i
            a.m03 * b.m20 + a.m13 * b.m21 + a.m23 * b.m22 + a.m33 * b.m23, // p_23 = a_i3 * b_2i
            a.m03 * b.m30 + a.m13 * b.m31 + a.m23 * b.m32 + a.m33 * b.m33  // p_33 = a_i3 * b_3i
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
    public static inline function add(a:Matrix4x4, b:Matrix4x4):Matrix4x4
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
    public static inline function subtract(a:Matrix4x4, b:Matrix4x4):Matrix4x4
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
    public static inline function negate(a:Matrix4x4):Matrix4x4
    {
        return new Matrix4x4([
            -a.m00, -a.m10, -a.m20, -a.m30,
            -a.m01, -a.m11, -a.m21, -a.m31,
            -a.m02, -a.m12, -a.m22, -a.m32,
            -a.m03, -a.m13, -a.m23, -a.m33
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
    public static inline function equals(a:Matrix4x4, b:Matrix4x4):Bool
    {
        return (a == null && b == null) ||
            a != null &&
            b != null &&
            a.m00 == b.m00 &&
            a.m10 == b.m10 &&
            a.m20 == b.m20 &&
            a.m30 == b.m30 &&
            a.m01 == b.m01 &&
            a.m11 == b.m11 &&
            a.m21 == b.m21 &&
            a.m31 == b.m31 &&
            a.m02 == b.m02 &&
            a.m12 == b.m12 &&
            a.m22 == b.m22 &&
            a.m32 == b.m32 &&
            a.m03 == b.m03 &&
            a.m13 == b.m13 &&
            a.m23 == b.m23 &&
            a.m33 == b.m33;
    }
    
    /**
     * Test inequality between two matrices.
     * 
     * @param a
     * @param b
     * @return      !(a_ij == b_ij)
     */
    @:op(A != B)
    public static inline function notEquals(a:Matrix4x4, b:Matrix4x4):Bool
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
    public static inline function addWith(a:Matrix4x4, b:Matrix4x4):Matrix4x4
    {
        a.m00 += b.m00;
        a.m10 += b.m10;
        a.m20 += b.m20;
        a.m30 += b.m30;
        a.m01 += b.m01;
        a.m11 += b.m11;
        a.m21 += b.m21;
        a.m31 += b.m31;
        a.m02 += b.m02;
        a.m12 += b.m12;
        a.m22 += b.m22;
        a.m32 += b.m32;
        a.m03 += b.m03;
        a.m13 += b.m13;
        a.m23 += b.m23;
        a.m33 += b.m33;
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
    public static inline function subtractWith(a:Matrix4x4, b:Matrix4x4):Matrix4x4
    {
        a.m00 -= b.m00;
        a.m10 -= b.m10;
        a.m20 -= b.m20;
        a.m30 -= b.m30;
        a.m01 -= b.m01;
        a.m11 -= b.m11;
        a.m21 -= b.m21;
        a.m31 -= b.m31;
        a.m02 -= b.m02;
        a.m12 -= b.m12;
        a.m22 -= b.m22;
        a.m32 -= b.m32;
        a.m03 -= b.m03;
        a.m13 -= b.m13;
        a.m23 -= b.m23;
        a.m33 -= b.m33;
        return a;
    }
    
    /**
     * Copy the contents of this structure to another.
     * 
     * @param other     The target structure.
     */
    public inline function copyTo(other:Matrix4x4):Void
    {
        var self:Matrix4x4 = this;
        
        for (i in 0...Matrix4x4.elementCount)
        {
            other[i] = self[i];
        }
    }
    
    /**
     * Clone.
     * 
     * @return  The cloned object.
     */
    public inline function clone():Matrix4x4
    {
        var self:Matrix4x4 = this;
        return new Matrix4x4([
            self.m00, self.m10, self.m20, self.m30,
            self.m01, self.m11, self.m21, self.m31,
            self.m02, self.m12, self.m22, self.m32,
            self.m03, self.m13, self.m23, self.m33
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
        var self:Matrix4x4 = this;
        
        switch (i)
        {
            case 0:
                return self.m00;
            case 1:
                return self.m10;
            case 2:
                return self.m20;
            case 3:
                return self.m30;
            case 4:
                return self.m01;
            case 5:
                return self.m11;
            case 6:
                return self.m21;
            case 7:
                return self.m31;
            case 8:
                return self.m02;
            case 9:
                return self.m12;
            case 10:
                return self.m22;
            case 11:
                return self.m32;
            case 12:
                return self.m03;
            case 13:
                return self.m13;
            case 14:
                return self.m23;
            case 15:
                return self.m33;
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
        var self:Matrix4x4 = this;
        
        switch (i)
        {
            case 0:
                return self.m00 = value;
            case 1:
                return self.m10 = value;
            case 2:
                return self.m20 = value;
            case 3:
                return self.m30 = value;
            case 4:
                return self.m01 = value;
            case 5:
                return self.m11 = value;
            case 6:
                return self.m21 = value;
            case 7:
                return self.m31 = value;
            case 8:
                return self.m02 = value;
            case 9:
                return self.m12 = value;
            case 10:
                return self.m22 = value;
            case 11:
                return self.m32 = value;
            case 12:
                return self.m03 = value;
            case 13:
                return self.m13 = value;
            case 14:
                return self.m23 = value;
            case 15:
                return self.m33 = value;
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
        var self:Matrix4x4 = this;
        return self[row * 4 + column];
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
        var self:Matrix4x4 = this;
        return self[row * 4 + column] = value;
    }
    
    /**
     * Get a column vector by index.
     * 
     * @param index     The 0-based index of the column.
     * @return          The column as a vector.
     */
    public inline function col(index:Int):Vector4
    {
        var self:Matrix4x4 = this;
        
        switch (index)
        {
            case 0:
                return new Vector4(self.m00, self.m01, self.m02, self.m03);
            case 1:
                return new Vector4(self.m10, self.m11, self.m12, self.m13);
            case 2:
                return new Vector4(self.m20, self.m21, self.m22, self.m23);
            case 3:
                return new Vector4(self.m30, self.m31, self.m32, self.m33);
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
    public inline function row(index:Int):Vector4
    {
        var self:Matrix4x4 = this;
        
        switch (index)
        {
            case 0:
                return new Vector4(self.m00, self.m10, self.m20, self.m30);
            case 1:
                return new Vector4(self.m01, self.m11, self.m21, self.m31);
            case 2:
                return new Vector4(self.m02, self.m12, self.m22, self.m32);
            case 3:
                return new Vector4(self.m03, self.m13, self.m23, self.m33);
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
    public inline function applyScalarFunc(func:Float->Float):Matrix4x4
    {
        var self:Matrix4x4 = this;
        
        for (i in 0...16)
        {
            self[i] = func(self[i]);
        }
        
        return self;
    }
    
    private static inline function get_zero():Matrix4x4
    {
        return new Matrix4x4([
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 0.0
        ]);
    }
    
    private static inline function get_identity():Matrix4x4
    {
        return new Matrix4x4([
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        ]);
    }
    
    private inline function get_transpose():Matrix4x4
    {
        var self:Matrix4x4 = this;
        return new Matrix4x4([
            self.m00, self.m01, self.m02, self.m03,
            self.m10, self.m11, self.m12, self.m13,
            self.m20, self.m21, self.m22, self.m23,
            self.m30, self.m31, self.m32, self.m33
        ]);
    }
    
    private inline function get_det():Float
    {
        var self:Matrix4x4 = this;
        return MathUtil.det4x4(
            self.m00, self.m10, self.m20, self.m30,
            self.m01, self.m11, self.m21, self.m31,
            self.m02, self.m12, self.m22, self.m32,
            self.m03, self.m13, self.m23, self.m33);
    }
}