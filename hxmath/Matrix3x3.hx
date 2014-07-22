package hxmath;

@:forward(
    m00, m01, m02,
    m10, m11, m12,
    m20, m21, m22)
abstract Matrix3x3(Matrix3x3Shape) from Matrix3x3Shape to Matrix3x3Shape
{
    public static var zero(get, never):Matrix3x3;
    public static var identity(get, never):Matrix3x3;
    
    public var det(get, never):Float;
    public var transpose(get, never):Matrix3x3;
    
    // Row-major rawData
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

    @:op(A * B)
    public static inline function multiplyScalar(s:Float, a:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3([
            s * a.m00, s * a.m10, s * a.m20,
            s * a.m01, s * a.m11, s * a.m21,
            s * a.m02, s * a.m12, s * a.m22
        ]);
    }

    @:op(A * B)
    public static inline function multiplyVector(a:Matrix3x3, v:Vector3):Vector3
    {
        return new Vector3(
            a.m00 * v.x + a.m10 * v.y + a.m20 * v.z,
            a.m01 * v.x + a.m11 * v.y + a.m21 * v.z,
            a.m02 * v.x + a.m12 * v.y + a.m22 * v.z);
    }
    
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
    
    @:op(A + B)
    public static inline function add(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3([
            a.m00 + b.m00, a.m10 + b.m10, a.m20 + b.m20,
            a.m01 + b.m01, a.m11 + b.m11, a.m21 + b.m21,
            a.m02 + b.m02, a.m12 + b.m12, a.m22 + b.m22
        ]);
    }
    
    @:op(A += B)
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
    
    @:op(A - B)
    public static inline function subtract(a:Matrix3x3, b:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3([
            a.m00 - b.m00, a.m10 - b.m10, a.m20 - b.m20,
            a.m01 - b.m01, a.m11 - b.m11, a.m21 - b.m21,
            a.m02 - b.m02, a.m12 - b.m12, a.m22 - b.m22
        ]);
    }
    
    @:op(A -= B)
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
        return b;
    }
    
    @:op(A == B)
    public static inline function equals(a:Matrix3x3, b:Matrix3x3):Bool
    {
        return
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
    
    public inline function clone():Matrix3x3
    {
        var self:Matrix3x3 = this;
        return new Matrix3x3([
            self.m00, self.m10, self.m20,
            self.m01, self.m11, self.m21,
            self.m02, self.m12, self.m22
        ]);
    }
    
    private static inline function get_zero()
    {
        return new Matrix3x3([
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0]);
    }
    
    private static inline function get_identity()
    {
        return new Matrix3x3([
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0]);
    }
    
    private inline function get_det()
    {
        var self:Matrix3x3 = this;
        return
            self.m00 * (self.m11 * self.m22 - self.m21 * self.m12) -
            self.m10 * (self.m01 * self.m22 - self.m21 * self.m02) +
            self.m20 * (self.m01 * self.m12 - self.m11 * self.m02);
    }
    
    private inline function get_transpose()
    {
        var self:Matrix3x3 = this;
        return new Matrix3x3([
            self.m00, self.m01, self.m02,
            self.m10, self.m11, self.m12,
            self.m20, self.m21, self.m22]);
    }
}