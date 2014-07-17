package vtgmath;

@:forward(
    m11, m12, m13,
    m21, m22, m23,
    m31, m32, m33)
abstract Matrix3x3(Matrix3x3Shape) from Matrix3x3Shape to Matrix3x3Shape
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
                m11: rawData[0], m21: rawData[1], m31: rawData[2],
                m12: rawData[3], m22: rawData[4], m32: rawData[5],
                m13: rawData[6], m23: rawData[7], m33: rawData[8]
            };
        }
    }
    
    public static inline function identity():Matrix3x3
    {
        return new Matrix3x3([
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0
        ]);
    }
    
    @:op(A * B)
    public static inline function multiply(p:Matrix3x3, q:Matrix3x3):Matrix3x3
    {
        return new Matrix3x3([
            a.m11 * b.m11 + a.m21 * b.m12 + a.m31 * b.m13, // p_11 = a_i1 * b_1i
            a.m11 * b.m21 + a.m21 * b.m22 + a.m31 * b.m23, // p_21 = a_i1 * b_2i
            a.m11 * b.m31 + a.m21 * b.m32 + a.m31 * b.m33, // p_31 = a_i1 * b_3i
            
            a.m12 * b.m11 + a.m22 * b.m12 + a.m32 * b.m13, // p_12 = a_i2 * b_1i
            a.m12 * b.m21 + a.m22 * b.m22 + a.m32 * b.m23, // p_22 = a_i2 * b_2i
            a.m12 * b.m31 + a.m22 * b.m32 + a.m32 * b.m33, // p_32 = a_i2 * b_3i
            
            a.m13 * b.m11 + a.m23 * b.m12 + a.m33 * b.m13, // p_13 = a_i3 * b_1i
            a.m13 * b.m21 + a.m23 * b.m22 + a.m33 * b.m23, // p_23 = a_i3 * b_2i
            a.m13 * b.m31 + a.m23 * b.m32 + a.m33 * b.m33  // p_33 = a_i3 * b_3i
        ]);
    }
    
    @:op(A * B)
    public static inline function multiplyVector(a:Matrix3x3, v:Vector3):Vector3
    {
        return new Vector3(
            a.m11 * v.x + a.m21 * v.y + a.m31 * v.z,
            a.m12 * v.x + a.m22 * v.y + a.m32 * v.z,
            a.m13 * v.x + a.m23 * v.y + a.m33 * v.z);
    }
}