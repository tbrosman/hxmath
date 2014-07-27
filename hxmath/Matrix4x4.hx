package hxmath;

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

@:forward(
    m00, m01, m02, m03,
    m10, m11, m12, m13,
    m20, m21, m22, m23,
    m30, m31, m32, m33)
abstract Matrix4x4(Matrix4x4Shape) from Matrix4x4Shape to Matrix4x4Shape
{
    public static var zero(get, never):Matrix4x4;
    public static var identity(get, never):Matrix4x4;
    
    public var det(get, never):Float;
    public var transpose(get, never):Matrix4x4;
    
    // Row-major rawData
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
    
    @:op(A * B)
    public static inline function multiplyVector(a:Matrix4x4, v:Vector4):Vector4
    {
        return new Vector4(
            a.m00 * v.x + a.m10 * v.y + a.m20 * v.z + a.m30 * v.w,
            a.m01 * v.x + a.m11 * v.y + a.m21 * v.z + a.m31 * v.w,
            a.m02 * v.x + a.m12 * v.y + a.m22 * v.z + a.m32 * v.w,
            a.m03 * v.x + a.m13 * v.y + a.m23 * v.z + a.m33 * v.w);
    }
    
    @:op(A + B)
    public static inline function add(a:Matrix4x4, b:Matrix4x4):Matrix4x4
    {
        return new Matrix4x4([
            a.m00 + b.m00, a.m10 + b.m10, a.m20 + b.m20, a.m30 + b.m30,
            a.m01 + b.m01, a.m11 + b.m11, a.m21 + b.m21, a.m31 + b.m31,
            a.m02 + b.m02, a.m12 + b.m12, a.m22 + b.m22, a.m32 + b.m32,
            a.m03 + b.m03, a.m13 + b.m13, a.m23 + b.m23, a.m33 + b.m33
        ]);
    }
    
    @:op(A += B)
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
    
    @:op(A - B)
    public static inline function subtract(a:Matrix4x4, b:Matrix4x4):Matrix4x4
    {
        return new Matrix4x4([
            a.m00 - b.m00, a.m10 - b.m10, a.m20 - b.m20, a.m30 - b.m30,
            a.m01 - b.m01, a.m11 - b.m11, a.m21 - b.m21, a.m31 - b.m31,
            a.m02 - b.m02, a.m12 - b.m12, a.m22 - b.m22, a.m32 - b.m32,
            a.m03 - b.m03, a.m13 - b.m13, a.m23 - b.m23, a.m33 - b.m33
        ]);
    }
    
    @:op(A -= B)
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
        return b;
    }

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
    
    @:op(A == B)
    public static inline function equals(a:Matrix4x4, b:Matrix4x4):Bool
    {
        return
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
    
    @:op(A != B)
    public static inline function notEquals(a:Matrix4x4, b:Matrix4x4):Bool
    {
        return !(a == b);
    }
    
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