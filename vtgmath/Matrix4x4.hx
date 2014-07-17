package vtgmath;

@:forward(
    m11, m12, m13, m14,
    m21, m22, m23, m24,
    m31, m32, m33, m34,
    m41, m42, m43, m44)
abstract Matrix4x4
{
    // Row-major rawData
    public function new(rawData:Array<Float> = null) 
    {
        if (rawData == null)
        {
            this = identity();
        }
        else
        {
            if (rawData.length != 9)
            {
                throw "Invalid rawData.";
            }
            
            this = {
                m11: rawData[0],  m21: rawData[1],  m31: rawData[2],  m41: rawData[3],
                m12: rawData[4],  m22: rawData[5],  m32: rawData[6],  m42: rawData[7],
                m13: rawData[8],  m23: rawData[9],  m33: rawData[10], m43: rawData[11],
                m14: rawData[12], m24: rawData[13], m34: rawData[14], m44: rawData[15]
            };
        }
    }
    
    public static inline function identity():Matrix3x3
    {
        return new Matrix4x4([
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        ]);
    }
    
    @:op(A * B)
    public static inline function multiply(p:Matrix3x3, q:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3([
            a.m11 * b.m11 + a.m21 * b.m12 + a.m31 * b.m13 + a.m41 * b.m14, // p_11 = a_i1 * b_1i
            a.m11 * b.m21 + a.m21 * b.m22 + a.m31 * b.m23 + a.m41 * b.m24, // p_21 = a_i1 * b_2i
            a.m11 * b.m31 + a.m21 * b.m32 + a.m31 * b.m33 + a.m41 * b.m34, // p_31 = a_i1 * b_3i
            a.m11 * b.m41 + a.m21 * b.m42 + a.m31 * b.m43 + a.m41 * b.m44, // p_41 = a_i1 * b_4i
            
            a.m12 * b.m11 + a.m22 * b.m12 + a.m32 * b.m13 + a.m42 * b.m14, // p_12 = a_i2 * b_1i
            a.m12 * b.m21 + a.m22 * b.m22 + a.m32 * b.m23 + a.m42 * b.m24, // p_22 = a_i2 * b_2i
            a.m12 * b.m31 + a.m22 * b.m32 + a.m32 * b.m33 + a.m42 * b.m34, // p_32 = a_i2 * b_3i
            a.m12 * b.m41 + a.m22 * b.m42 + a.m32 * b.m43 + a.m42 * b.m44, // p_42 = a_i2 * b_4i
            
            a.m13 * b.m11 + a.m23 * b.m12 + a.m33 * b.m13 + a.m43 * b.m14, // p_13 = a_i3 * b_1i
            a.m13 * b.m21 + a.m23 * b.m22 + a.m33 * b.m23 + a.m43 * b.m24, // p_23 = a_i3 * b_2i
            a.m13 * b.m31 + a.m23 * b.m32 + a.m33 * b.m33 + a.m43 * b.m34, // p_33 = a_i3 * b_3i
            a.m13 * b.m41 + a.m23 * b.m42 + a.m33 * b.m43 + a.m43 * b.m44, // p_43 = a_i3 * b_4i
            
            a.m14 * b.m11 + a.m24 * b.m12 + a.m34 * b.m13 + a.m44 * b.m14, // p_14 = a_i4 * b_1i
            a.m14 * b.m21 + a.m24 * b.m22 + a.m34 * b.m23 + a.m44 * b.m24, // p_24 = a_i4 * b_2i
            a.m14 * b.m31 + a.m24 * b.m32 + a.m34 * b.m33 + a.m44 * b.m34, // p_34 = a_i4 * b_3i
            a.m14 * b.m41 + a.m24 * b.m42 + a.m34 * b.m43 + a.m44 * b.m44  // p_44 = a_i4 * b_4i
        ]);
    }
    
    @:op(A * B)
    public static inline function multiplyVector(a:Matrix4x4, v:Vector4):Vector4
    {
        return new Vector4(
            a.m11 * v.x + a.m21 * v.y + a.m31 * v.z + a.m41 * v.w,
            a.m12 * v.x + a.m22 * v.y + a.m32 * v.z + a.m42 * v.w,
            a.m13 * v.x + a.m23 * v.y + a.m33 * v.z + a.m43 * v.w,
            a.m14 * v.x + a.m24 * v.y + a.m34 * v.z + a.m44 * v.w);
    }
}